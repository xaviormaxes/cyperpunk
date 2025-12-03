-- Whispers Module
-- Displays AI whispers from beyond the Blackwall in the UI

local Whispers = {}
Whispers.__index = Whispers

-- Configuration constants
local DEFAULT_QUEUE_SIZE = 5
local DEFAULT_WHISPER_DURATION = 5.0
local DEFAULT_FADEOUT_DURATION = 1.0

-- Constructor
function Whispers:New(config)
    local instance = setmetatable({}, Whispers)
    instance.config = config
    instance.activeWhisper = nil
    instance.whisperStartTime = 0
    instance.whisperDuration = DEFAULT_WHISPER_DURATION
    instance.fadeOutDuration = DEFAULT_FADEOUT_DURATION
    instance.isEnabled = config.whispers and config.whispers.enabled or true
    instance.whisperQueue = {}
    instance.maxQueueSize = config.whispers and config.whispers.maxQueueSize or DEFAULT_QUEUE_SIZE
    
    -- AI entity display names with glitch effects
    instance.entityNames = {
        AltFragment = "???",
        ErebusEcho = "E̷R̷E̷B̷U̷S̷",
        DatakrashGhost = "GHOST_2023",
        RogueConstruct = "CONSTRUCT://NULL",
        NetwatchTrace = "[NETWATCH]",
        Unknown = "UNKNOWN"
    }
    
    -- Colors for different entities
    instance.entityColors = {
        AltFragment = {0.5, 0.8, 1.0, 1.0},      -- Cyan (mysterious)
        ErebusEcho = {1.0, 0.2, 0.2, 1.0},       -- Red (threatening)
        DatakrashGhost = {0.7, 0.7, 0.7, 1.0},   -- Gray (faded)
        RogueConstruct = {1.0, 0.5, 0.0, 1.0},   -- Orange (aggressive)
        NetwatchTrace = {0.0, 1.0, 0.5, 1.0},    -- Green (official)
        Unknown = {0.8, 0.8, 0.8, 1.0}           -- Light gray
    }
    
    return instance
end

-- Queue a new whisper
function Whispers:QueueWhisper(entity, message, isHostile)
    if not self.isEnabled then
        return
    end
    
    local whisper = {
        entity = entity,
        message = message,
        isHostile = isHostile,
        timestamp = os.time()
    }
    
    table.insert(self.whisperQueue, whisper)
    
    -- Limit queue size (uses configured max)
    while #self.whisperQueue > self.maxQueueSize do
        table.remove(self.whisperQueue, 1)
    end
end

-- Update whispers (call every frame)
function Whispers:Update(deltaTime)
    if not self.isEnabled then
        return
    end
    
    local currentTime = os.clock()
    
    -- Check if current whisper has expired
    if self.activeWhisper then
        local elapsed = currentTime - self.whisperStartTime
        if elapsed >= self.whisperDuration + self.fadeOutDuration then
            self.activeWhisper = nil
        end
    end
    
    -- Show next whisper from queue if none active
    if not self.activeWhisper and #self.whisperQueue > 0 then
        self.activeWhisper = table.remove(self.whisperQueue, 1)
        self.whisperStartTime = currentTime
    end
end

-- Draw whisper UI
function Whispers:Draw()
    if not self.isEnabled or not self.activeWhisper then
        return
    end
    
    if not self.config.ui or not self.config.ui.showWhispers then
        return
    end
    
    local currentTime = os.clock()
    local elapsed = currentTime - self.whisperStartTime
    
    -- Calculate alpha for fade in/out
    local alpha = 1.0
    if elapsed < 0.5 then
        -- Fade in
        alpha = elapsed / 0.5
    elseif elapsed > self.whisperDuration then
        -- Fade out
        alpha = 1.0 - ((elapsed - self.whisperDuration) / self.fadeOutDuration)
    end
    alpha = math.max(0, math.min(1, alpha))
    
    -- Get entity display info
    local entityName = self.entityNames[self.activeWhisper.entity] or self.entityNames.Unknown
    local entityColor = self.entityColors[self.activeWhisper.entity] or self.entityColors.Unknown
    
    -- Apply alpha to color
    local color = {entityColor[1], entityColor[2], entityColor[3], entityColor[4] * alpha}
    
    -- Position whisper at bottom center of screen
    local screenWidth = ImGui.GetIO().DisplaySize.x
    local screenHeight = ImGui.GetIO().DisplaySize.y
    
    local windowWidth = 600
    local windowHeight = 80
    local windowX = (screenWidth - windowWidth) / 2
    local windowY = screenHeight - 200
    
    ImGui.SetNextWindowPos(windowX, windowY)
    ImGui.SetNextWindowSize(windowWidth, windowHeight)
    
    local flags = ImGuiWindowFlags.NoTitleBar + 
                  ImGuiWindowFlags.NoResize + 
                  ImGuiWindowFlags.NoMove + 
                  ImGuiWindowFlags.NoScrollbar +
                  ImGuiWindowFlags.NoBackground
    
    if ImGui.Begin("BTW_Whisper", flags) then
        -- Apply glitch effect for hostile whispers
        local displayMessage = self.activeWhisper.message
        if self.activeWhisper.isHostile and math.random() < 0.1 then
            displayMessage = self:ApplyGlitchEffect(displayMessage)
        end
        
        -- Entity name (header)
        ImGui.PushStyleColor(ImGuiCol.Text, color[1], color[2], color[3], color[4])
        ImGui.SetCursorPosX((windowWidth - ImGui.CalcTextSize(entityName)) / 2)
        ImGui.Text(entityName)
        
        -- Message
        local textColor = {0.9, 0.9, 0.9, alpha}
        if self.activeWhisper.isHostile then
            textColor = {1.0, 0.8, 0.8, alpha}
        end
        
        ImGui.PopStyleColor()
        ImGui.PushStyleColor(ImGuiCol.Text, textColor[1], textColor[2], textColor[3], textColor[4])
        
        -- Center and wrap text
        local textWidth = ImGui.CalcTextSize(displayMessage)
        if textWidth < windowWidth - 20 then
            ImGui.SetCursorPosX((windowWidth - textWidth) / 2)
        end
        ImGui.TextWrapped(displayMessage)
        
        ImGui.PopStyleColor()
    end
    ImGui.End()
end

-- Apply glitch effect to text
function Whispers:ApplyGlitchEffect(text)
    local glitchChars = {"█", "▓", "░", "▒", "■", "□", "▪", "▫"}
    local result = ""
    
    for i = 1, #text do
        local char = text:sub(i, i)
        if math.random() < 0.1 then
            -- Replace with glitch character
            result = result .. glitchChars[math.random(#glitchChars)]
        else
            result = result .. char
        end
    end
    
    return result
end

-- Enable/disable whispers
function Whispers:SetEnabled(enabled)
    self.isEnabled = enabled
end

-- Clear all whispers
function Whispers:Clear()
    self.activeWhisper = nil
    self.whisperQueue = {}
end

-- Get active whisper info (for external systems)
function Whispers:GetActiveWhisper()
    return self.activeWhisper
end

-- Serialize state
function Whispers:Serialize()
    return {
        isEnabled = self.isEnabled
    }
end

-- Deserialize state
function Whispers:Deserialize(data)
    if data then
        self.isEnabled = data.isEnabled ~= false
    end
end

return Whispers
