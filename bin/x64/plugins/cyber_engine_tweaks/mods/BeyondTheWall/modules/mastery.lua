-- Mastery Module
-- Manages the Blackwall mastery progression system

local Mastery = {}
Mastery.__index = Mastery

-- Constructor
function Mastery:New(config)
    local instance = setmetatable({}, Mastery)
    instance.config = config
    instance.currentMastery = 0.0
    instance.maxMastery = 100.0
    instance.currentLevel = 1
    instance.maxLevel = 10
    instance.experiencePerLevel = 10.0
    instance.listeners = {}

    -- Track individual quickhack usage
    instance.quickhackStats = {
        BlackwallTrace = { uses = 0, successes = 0 },
        NeuralHijack = { uses = 0, successes = 0 },
        CascadeProtocol = { uses = 0, successes = 0 },
        SummonDaemon = { uses = 0, successes = 0 },
        BlackwallOverload = { uses = 0, successes = 0 }
    }

    -- Depth unlock tracking
    instance.unlockedDepths = { 1 }

    return instance
end

-- Get current mastery level (0-100)
function Mastery:GetMastery()
    return self.currentMastery
end

-- Get current mastery level (1-10)
function Mastery:GetLevel()
    return self.currentLevel
end

-- Get progress to next level (0-1)
function Mastery:GetLevelProgress()
    local currentLevelXP = (self.currentLevel - 1) * self.experiencePerLevel
    local nextLevelXP = self.currentLevel * self.experiencePerLevel
    local progress = (self.currentMastery - currentLevelXP) / (nextLevelXP - currentLevelXP)
    return math.max(0.0, math.min(1.0, progress))
end

-- Add mastery experience
function Mastery:AddExperience(amount)
    amount = amount * self.config.masteryMultiplier

    local oldMastery = self.currentMastery
    local oldLevel = self.currentLevel

    self.currentMastery = math.min(self.currentMastery + amount, self.maxMastery)

    -- Calculate new level
    self.currentLevel = math.min(
        math.floor(self.currentMastery / self.experiencePerLevel) + 1,
        self.maxLevel
    )

    -- Check for level up
    if self.currentLevel > oldLevel then
        self:_NotifyListeners("level_up", {
            oldLevel = oldLevel,
            newLevel = self.currentLevel
        })

        if self.config.enableDebugLogging then
            print(string.format("[BTW] Mastery level up! %d -> %d", oldLevel, self.currentLevel))
        end
    end

    if self.config.enableDebugLogging and amount > 0 then
        print(string.format("[BTW] Mastery XP gained: %.2f (multiplier: %.2f) -> Current: %.2f",
            amount, self.config.masteryMultiplier, self.currentMastery))
    end
end

-- Record quickhack usage
function Mastery:RecordQuickhackUse(quickhackName, success)
    if not self.quickhackStats[quickhackName] then
        self.quickhackStats[quickhackName] = { uses = 0, successes = 0 }
    end

    self.quickhackStats[quickhackName].uses = self.quickhackStats[quickhackName].uses + 1

    if success then
        self.quickhackStats[quickhackName].successes = self.quickhackStats[quickhackName].successes + 1

        -- Award mastery XP for successful use
        local baseXP = 1.0

        -- More XP for advanced quickhacks
        if quickhackName == "BlackwallOverload" then
            baseXP = 5.0
        elseif quickhackName == "SummonDaemon" then
            baseXP = 3.0
        elseif quickhackName == "CascadeProtocol" then
            baseXP = 2.0
        end

        self:AddExperience(baseXP)
    end
end

-- Get quickhack statistics
function Mastery:GetQuickhackStats(quickhackName)
    return self.quickhackStats[quickhackName] or { uses = 0, successes = 0 }
end

-- Get success rate for a quickhack
function Mastery:GetQuickhackSuccessRate(quickhackName)
    local stats = self:GetQuickhackStats(quickhackName)
    if stats.uses == 0 then
        return 0.0
    end
    return stats.successes / stats.uses
end

-- Check if depth is unlocked
function Mastery:IsDepthUnlocked(depth)
    for _, unlockedDepth in ipairs(self.unlockedDepths) do
        if unlockedDepth == depth then
            return true
        end
    end
    return false
end

-- Unlock new depth
function Mastery:UnlockDepth(depth)
    if not self:IsDepthUnlocked(depth) then
        table.insert(self.unlockedDepths, depth)
        table.sort(self.unlockedDepths)

        self:_NotifyListeners("depth_unlocked", { depth = depth })

        if self.config.enableDebugLogging then
            print(string.format("[BTW] Depth %d unlocked!", depth))
        end
    end
end

-- Get maximum unlocked depth
function Mastery:GetMaxDepth()
    local maxDepth = 1
    for _, depth in ipairs(self.unlockedDepths) do
        if depth > maxDepth then
            maxDepth = depth
        end
    end
    return maxDepth
end

-- Check depth unlock requirements
function Mastery:CheckDepthUnlocks()
    local requirements = self.config.depthUnlockRequirements

    for depthStr, requiredMastery in pairs(requirements) do
        local depth = tonumber(depthStr:match("%d+"))
        if depth and self.currentMastery >= requiredMastery then
            self:UnlockDepth(depth)
        end
    end
end

-- Get corruption resistance (0-1) based on mastery
function Mastery:GetCorruptionResistance()
    return math.min(self.currentMastery / 100.0, 1.0)
end

-- Get quickhack cost reduction (0-1) based on mastery
function Mastery:GetCostReduction()
    -- At max mastery level (10), get 50% cost reduction
    return (self.currentLevel / self.maxLevel) * 0.5
end

-- Register listener for mastery events
function Mastery:RegisterListener(callback)
    table.insert(self.listeners, callback)
end

-- Internal: Notify all listeners
function Mastery:_NotifyListeners(event, data)
    for _, callback in ipairs(self.listeners) do
        callback(event, data)
    end
end

-- Reset mastery (for debugging/testing)
function Mastery:Reset()
    self.currentMastery = 0.0
    self.currentLevel = 1
    self.unlockedDepths = { 1 }
    self.quickhackStats = {
        BlackwallTrace = { uses = 0, successes = 0 },
        NeuralHijack = { uses = 0, successes = 0 },
        CascadeProtocol = { uses = 0, successes = 0 },
        SummonDaemon = { uses = 0, successes = 0 },
        BlackwallOverload = { uses = 0, successes = 0 }
    }
end

-- Get detailed stats summary
function Mastery:GetStatsSummary()
    local totalUses = 0
    local totalSuccesses = 0

    for _, stats in pairs(self.quickhackStats) do
        totalUses = totalUses + stats.uses
        totalSuccesses = totalSuccesses + stats.successes
    end

    return {
        mastery = self.currentMastery,
        level = self.currentLevel,
        maxDepth = self:GetMaxDepth(),
        totalQuickhackUses = totalUses,
        totalSuccesses = totalSuccesses,
        overallSuccessRate = totalUses > 0 and (totalSuccesses / totalUses) or 0.0,
        corruptionResistance = self:GetCorruptionResistance(),
        costReduction = self:GetCostReduction()
    }
end

-- Serialize state for saving
function Mastery:Serialize()
    return {
        currentMastery = self.currentMastery,
        currentLevel = self.currentLevel,
        unlockedDepths = self.unlockedDepths,
        quickhackStats = self.quickhackStats
    }
end

-- Deserialize state from save
function Mastery:Deserialize(data)
    if data then
        self.currentMastery = data.currentMastery or 0.0
        self.currentLevel = data.currentLevel or 1
        self.unlockedDepths = data.unlockedDepths or { 1 }
        self.quickhackStats = data.quickhackStats or {
            BlackwallTrace = { uses = 0, successes = 0 },
            NeuralHijack = { uses = 0, successes = 0 },
            CascadeProtocol = { uses = 0, successes = 0 },
            SummonDaemon = { uses = 0, successes = 0 },
            BlackwallOverload = { uses = 0, successes = 0 }
        }
    end
end

return Mastery
