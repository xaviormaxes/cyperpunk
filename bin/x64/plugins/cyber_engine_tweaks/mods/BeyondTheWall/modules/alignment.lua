-- Alignment Module
-- Tracks player's moral alignment with AI entities

local Alignment = {}
Alignment.__index = Alignment

-- Alignment types
Alignment.Types = {
    NEUTRAL = "neutral",
    RESISTANT = "resistant",
    COOPERATIVE = "cooperative",
    SYMBIOTIC = "symbiotic",
    CORRUPTED = "corrupted"
}

-- Choice types
Alignment.Choices = {
    USE_BLACKWALL_POWER = "use_blackwall_power",
    RESIST_CORRUPTION = "resist_corruption",
    HELP_AI = "help_ai",
    DESTROY_AI = "destroy_ai",
    ACCEPT_WHISPER = "accept_whisper",
    REJECT_WHISPER = "reject_whisper",
    SAVE_POSSESSED = "save_possessed",
    EXPLOIT_POSSESSED = "exploit_possessed"
}

-- Constructor
function Alignment:New(config)
    local instance = setmetatable({}, Alignment)
    instance.config = config
    instance.cooperationScore = 0.0  -- -100 (resistant) to 100 (cooperative)
    instance.aiTrustLevel = 0.0       -- 0 to 100
    instance.currentAlignment = Alignment.Types.NEUTRAL
    instance.isMarkedByNetwatch = false
    instance.choiceHistory = {}
    instance.listeners = {}
    
    return instance
end

-- Record a choice
function Alignment:RecordChoice(choiceType)
    table.insert(self.choiceHistory, {
        choice = choiceType,
        timestamp = os.time()
    })
    
    -- Limit history size
    while #self.choiceHistory > 100 do
        table.remove(self.choiceHistory, 1)
    end
    
    -- Update scores
    self:UpdateScoresFromChoice(choiceType)
    
    -- Update alignment
    self:UpdateAlignment()
    
    if self.config.enableDebugLogging then
        print(string.format("[BTW] Choice recorded: %s -> Cooperation: %.1f, Trust: %.1f",
            choiceType, self.cooperationScore, self.aiTrustLevel))
    end
end

-- Update scores based on choice
function Alignment:UpdateScoresFromChoice(choiceType)
    local scoreChanges = {
        [Alignment.Choices.USE_BLACKWALL_POWER] = {coop = 2, trust = 1},
        [Alignment.Choices.RESIST_CORRUPTION] = {coop = -3, trust = 0},
        [Alignment.Choices.HELP_AI] = {coop = 10, trust = 5},
        [Alignment.Choices.DESTROY_AI] = {coop = -10, trust = -5},
        [Alignment.Choices.ACCEPT_WHISPER] = {coop = 5, trust = 3},
        [Alignment.Choices.REJECT_WHISPER] = {coop = -5, trust = 0},
        [Alignment.Choices.SAVE_POSSESSED] = {coop = -2, trust = 0},
        [Alignment.Choices.EXPLOIT_POSSESSED] = {coop = 5, trust = 2}
    }
    
    local changes = scoreChanges[choiceType]
    if changes then
        self.cooperationScore = math.max(-100, math.min(100, self.cooperationScore + changes.coop))
        self.aiTrustLevel = math.max(0, math.min(100, self.aiTrustLevel + changes.trust))
    end
    
    -- Check for NetWatch attention
    local threshold = self.config.moralConsequences and self.config.moralConsequences.netwatchAlertThreshold or 50
    if self.cooperationScore >= threshold and not self.isMarkedByNetwatch then
        self:OnNetwatchAlert()
    end
end

-- Update current alignment
function Alignment:UpdateAlignment(corruptionLevel)
    corruptionLevel = corruptionLevel or 0
    
    local oldAlignment = self.currentAlignment
    local corruptedThreshold = self.config.moralConsequences and self.config.moralConsequences.corruptedAlignmentThreshold or 95
    local symbioticTrust = self.config.moralConsequences and self.config.moralConsequences.symbioticRequiredTrust or 75
    
    -- Determine new alignment
    if corruptionLevel >= corruptedThreshold and self.cooperationScore >= 50 then
        self.currentAlignment = Alignment.Types.CORRUPTED
    elseif self.cooperationScore >= 75 and self.aiTrustLevel >= symbioticTrust then
        self.currentAlignment = Alignment.Types.SYMBIOTIC
    elseif self.cooperationScore >= 25 then
        self.currentAlignment = Alignment.Types.COOPERATIVE
    elseif self.cooperationScore <= -25 then
        self.currentAlignment = Alignment.Types.RESISTANT
    else
        self.currentAlignment = Alignment.Types.NEUTRAL
    end
    
    -- Notify listeners if alignment changed
    if oldAlignment ~= self.currentAlignment then
        self:_NotifyListeners("alignment_changed", {
            old = oldAlignment,
            new = self.currentAlignment
        })
    end
end

-- Called when NetWatch notices player
function Alignment:OnNetwatchAlert()
    self.isMarkedByNetwatch = true
    self:_NotifyListeners("netwatch_alert", {})
    
    if self.config.enableDebugLogging then
        print("[BTW] NETWATCH ALERT - Player marked for observation")
    end
end

-- Get current alignment
function Alignment:GetAlignment()
    return self.currentAlignment
end

-- Get cooperation score
function Alignment:GetCooperationScore()
    return self.cooperationScore
end

-- Get AI trust level
function Alignment:GetAITrustLevel()
    return self.aiTrustLevel
end

-- Check if marked by NetWatch
function Alignment:IsMarkedByNetwatch()
    return self.isMarkedByNetwatch
end

-- Get alignment description
function Alignment:GetDescription()
    local descriptions = {
        [Alignment.Types.CORRUPTED] = "Lost to the Blackwall",
        [Alignment.Types.SYMBIOTIC] = "One with the AI",
        [Alignment.Types.COOPERATIVE] = "AI Ally",
        [Alignment.Types.RESISTANT] = "Blackwall Resistant",
        [Alignment.Types.NEUTRAL] = "Neutral"
    }
    return descriptions[self.currentAlignment] or "Unknown"
end

-- Get alignment color for UI
function Alignment:GetColor()
    local colors = {
        [Alignment.Types.CORRUPTED] = {1.0, 0.0, 0.0, 1.0},      -- Red
        [Alignment.Types.SYMBIOTIC] = {0.5, 0.0, 1.0, 1.0},      -- Purple
        [Alignment.Types.COOPERATIVE] = {0.0, 0.5, 1.0, 1.0},    -- Blue
        [Alignment.Types.RESISTANT] = {0.0, 1.0, 0.5, 1.0},      -- Green
        [Alignment.Types.NEUTRAL] = {0.7, 0.7, 0.7, 1.0}         -- Gray
    }
    return colors[self.currentAlignment] or {1.0, 1.0, 1.0, 1.0}
end

-- Get ending hint based on current state
function Alignment:GetEndingHint(mastery)
    mastery = mastery or 0
    
    local hints = {
        [Alignment.Types.CORRUPTED] = "The Old Net calls. There is no escape.",
        [Alignment.Types.SYMBIOTIC] = mastery >= 80 
            and "Perfect harmony between flesh and code. A new kind of existence awaits."
            or "The bond grows stronger. Master your power or be consumed.",
        [Alignment.Types.COOPERATIVE] = "The AI entities see you as an ally. This path leads to symbiosis... or destruction.",
        [Alignment.Types.RESISTANT] = mastery >= 50
            and "You use their power but reject their influence. A dangerous balance."
            or "The Blackwall's gifts come with strings attached. Be careful.",
        [Alignment.Types.NEUTRAL] = "Your path is not yet set. Every choice matters."
    }
    
    return hints[self.currentAlignment] or "Unknown fate awaits."
end

-- Calculate ending variation (0-100)
function Alignment:CalculateEndingVariation(mastery)
    mastery = mastery or 0
    
    local base = 50 -- Neutral
    
    -- Cooperation shifts ending towards AI integration
    base = base + math.floor(self.cooperationScore / 2)
    
    -- High mastery allows for better outcomes
    if mastery >= 80 then
        base = base + 10
    end
    
    -- NetWatch attention affects ending
    if self.isMarkedByNetwatch then
        base = base - 5
    end
    
    return math.max(0, math.min(100, base))
end

-- Register listener
function Alignment:RegisterListener(callback)
    table.insert(self.listeners, callback)
end

-- Notify listeners
function Alignment:_NotifyListeners(event, data)
    for _, callback in ipairs(self.listeners) do
        callback(event, data)
    end
end

-- Reset alignment
function Alignment:Reset()
    self.cooperationScore = 0.0
    self.aiTrustLevel = 0.0
    self.currentAlignment = Alignment.Types.NEUTRAL
    self.isMarkedByNetwatch = false
    self.choiceHistory = {}
end

-- Serialize state
function Alignment:Serialize()
    return {
        cooperationScore = self.cooperationScore,
        aiTrustLevel = self.aiTrustLevel,
        currentAlignment = self.currentAlignment,
        isMarkedByNetwatch = self.isMarkedByNetwatch,
        choiceHistory = self.choiceHistory
    }
end

-- Deserialize state
function Alignment:Deserialize(data)
    if data then
        self.cooperationScore = data.cooperationScore or 0.0
        self.aiTrustLevel = data.aiTrustLevel or 0.0
        self.currentAlignment = data.currentAlignment or Alignment.Types.NEUTRAL
        self.isMarkedByNetwatch = data.isMarkedByNetwatch or false
        self.choiceHistory = data.choiceHistory or {}
    end
end

return Alignment
