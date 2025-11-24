-- Corruption Module
-- Manages the Blackwall corruption system

local Corruption = {}
Corruption.__index = Corruption

-- Constructor
function Corruption:New(config)
    local instance = setmetatable({}, Corruption)
    instance.config = config
    instance.currentCorruption = 0.0
    instance.maxCorruption = 100.0
    instance.decayTimer = 0.0
    instance.isInDeepZone = false
    instance.currentDepth = 0
    instance.listeners = {}

    return instance
end

-- Get current corruption level
function Corruption:GetLevel()
    return self.currentCorruption
end

-- Get corruption percentage (0-1)
function Corruption:GetPercentage()
    return self.currentCorruption / self.maxCorruption
end

-- Get corruption tier (low, medium, high, critical)
function Corruption:GetTier()
    local thresholds = self.config.corruptionThresholds
    if self.currentCorruption >= thresholds.critical then
        return "critical"
    elseif self.currentCorruption >= thresholds.high then
        return "high"
    elseif self.currentCorruption >= thresholds.medium then
        return "medium"
    elseif self.currentCorruption >= thresholds.low then
        return "low"
    else
        return "none"
    end
end

-- Add corruption
function Corruption:Add(amount, mastery)
    mastery = mastery or 0

    -- Apply mastery reduction
    if self.config.masteryReduction.enabled and mastery > 0 then
        local reduction = math.min(
            (mastery / self.config.masteryReduction.masteryRequired) * self.config.masteryReduction.maxReduction,
            self.config.masteryReduction.maxReduction
        )
        amount = amount * (1.0 - reduction)
    end

    local oldLevel = self.currentCorruption
    self.currentCorruption = math.min(self.currentCorruption + amount, self.maxCorruption)

    -- Trigger listeners if tier changed
    local oldTier = self:_GetTierForLevel(oldLevel)
    local newTier = self:GetTier()
    if oldTier ~= newTier then
        self:_NotifyListeners("tier_changed", { old = oldTier, new = newTier })
    end

    if self.config.enableDebugLogging then
        print(string.format("[BTW] Corruption added: %.2f (mastery reduction applied: %.2f) -> Current: %.2f",
            amount, mastery, self.currentCorruption))
    end
end

-- Remove corruption
function Corruption:Remove(amount)
    local oldLevel = self.currentCorruption
    self.currentCorruption = math.max(self.currentCorruption - amount, 0.0)

    -- Trigger listeners if tier changed
    local oldTier = self:_GetTierForLevel(oldLevel)
    local newTier = self:GetTier()
    if oldTier ~= newTier then
        self:_NotifyListeners("tier_changed", { old = oldTier, new = newTier })
    end

    if self.config.enableDebugLogging then
        print(string.format("[BTW] Corruption removed: %.2f -> Current: %.2f", amount, self.currentCorruption))
    end
end

-- Set corruption to specific value
function Corruption:Set(value)
    local oldTier = self:GetTier()
    self.currentCorruption = math.max(0.0, math.min(value, self.maxCorruption))

    local newTier = self:GetTier()
    if oldTier ~= newTier then
        self:_NotifyListeners("tier_changed", { old = oldTier, new = newTier })
    end
end

-- Update corruption (call every frame/tick)
function Corruption:Update(deltaTime)
    -- Decay corruption over time when not in deep zone
    if not self.isInDeepZone and self.currentCorruption > 0 then
        self.decayTimer = self.decayTimer + deltaTime

        if self.decayTimer >= self.config.corruptionDecayInterval then
            self:Remove(self.config.corruptionDecayRate)
            self.decayTimer = 0.0
        end
    end
end

-- Set whether player is in deep zone
function Corruption:SetInDeepZone(inZone, depth)
    self.isInDeepZone = inZone
    if depth then
        self.currentDepth = depth
    end
end

-- Get current depth
function Corruption:GetDepth()
    return self.currentDepth
end

-- Check if corruption causes negative effects
function Corruption:ShouldApplyNegativeEffects(mastery)
    mastery = mastery or 0
    local tier = self:GetTier()

    -- With high mastery, can tolerate higher corruption
    if tier == "critical" then
        return mastery < 80
    elseif tier == "high" then
        return mastery < 60
    elseif tier == "medium" then
        return mastery < 40
    end

    return false
end

-- Get feedback damage chance based on depth and corruption
function Corruption:GetFeedbackChance()
    local baseChance = self.config.feedbackDamageChance["depth" .. self.currentDepth] or 0.0

    -- Increase chance based on corruption tier
    local tier = self:GetTier()
    local multiplier = 1.0

    if tier == "critical" then
        multiplier = 2.0
    elseif tier == "high" then
        multiplier = 1.5
    elseif tier == "medium" then
        multiplier = 1.2
    end

    return baseChance * multiplier
end

-- Register listener for corruption events
function Corruption:RegisterListener(callback)
    table.insert(self.listeners, callback)
end

-- Internal: Get tier for specific level
function Corruption:_GetTierForLevel(level)
    local thresholds = self.config.corruptionThresholds
    if level >= thresholds.critical then
        return "critical"
    elseif level >= thresholds.high then
        return "high"
    elseif level >= thresholds.medium then
        return "medium"
    elseif level >= thresholds.low then
        return "low"
    else
        return "none"
    end
end

-- Internal: Notify all listeners
function Corruption:_NotifyListeners(event, data)
    for _, callback in ipairs(self.listeners) do
        callback(event, data)
    end
end

-- Reset corruption to zero
function Corruption:Reset()
    self:Set(0.0)
    self.isInDeepZone = false
    self.currentDepth = 0
    self.decayTimer = 0.0
end

-- Serialize state for saving
function Corruption:Serialize()
    return {
        currentCorruption = self.currentCorruption,
        currentDepth = self.currentDepth
    }
end

-- Deserialize state from save
function Corruption:Deserialize(data)
    if data then
        self.currentCorruption = data.currentCorruption or 0.0
        self.currentDepth = data.currentDepth or 0
    end
end

return Corruption
