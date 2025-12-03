-- Beyond the Wall - Main Module
-- Blackwall AI Firewall Mod for Cyberpunk 2077
-- Author: xaviormaxes
-- Version: 0.2.0

-- Load configuration (config.lua handles JSON parsing and defaults)
local config = require("config")

-- Load modules
local Corruption = require("modules/corruption")
local Mastery = require("modules/mastery")
local UI = require("modules/ui")
local Debug = require("modules/debug")
local Whispers = require("modules/whispers")
local Alignment = require("modules/alignment")

-- Main mod object
local BeyondTheWall = {
    version = "0.2.0",
    name = "Beyond the Wall",
    initialized = false,
    config = nil,
    corruption = nil,
    mastery = nil,
    ui = nil,
    debug = nil,
    whispers = nil,
    alignment = nil,
    saveFile = "beyondthewall_save.json",
    updateInterval = 0.1,
    updateTimer = 0.0
}

-- Initialize the mod
function BeyondTheWall:Initialize()
    if self.initialized then
        return
    end

    print("===========================================")
    print("  Beyond the Wall - Initializing...")
    print("  Version: " .. self.version)
    print("===========================================")

    -- Load config
    self.config = config

    -- Initialize systems
    self.corruption = Corruption:New(self.config)
    self.mastery = Mastery:New(self.config)
    self.whispers = Whispers:New(self.config)
    self.alignment = Alignment:New(self.config)
    self.ui = UI:New(self.config, self.corruption, self.mastery)
    self.debug = Debug:New(self.config, self.corruption, self.mastery)

    -- Set up event listeners
    self:SetupEventListeners()

    -- Try to load saved data
    self:LoadState()

    self.initialized = true

    print("[BTW] Initialization complete!")
    print("[BTW] Press ~ to open CET console")
    print("[BTW] Use 'btw help' for debug commands")

    if self.config.enableDebugMode then
        print("[BTW] DEBUG MODE ENABLED")
    end
end

-- Set up event listeners
function BeyondTheWall:SetupEventListeners()
    -- Listen for corruption tier changes
    self.corruption:RegisterListener(function(event, data)
        if event == "tier_changed" then
            print(string.format("[BTW] Corruption tier changed: %s -> %s",
                data.old:upper(), data.new:upper()))

            -- Apply visual effects based on tier
            if data.new == "critical" then
                print("[BTW] WARNING: Critical corruption level!")
                -- Queue ominous whisper
                BeyondTheWall.whispers:QueueWhisper("ErebusEcho", 
                    "Your resistance is weakening. Soon you will understand.", true)
            elseif data.new == "high" then
                BeyondTheWall.whispers:QueueWhisper("RogueConstruct",
                    "We can feel your implants singing to us...", true)
            end
            
            -- Update alignment with new corruption level
            BeyondTheWall.alignment:UpdateAlignment(BeyondTheWall.corruption:GetLevel())
        end
    end)

    -- Listen for mastery level ups
    self.mastery:RegisterListener(function(event, data)
        if event == "level_up" then
            print(string.format("[BTW] Mastery level up! %d -> %d",
                data.oldLevel, data.newLevel))

            -- Check if new depths should be unlocked
            BeyondTheWall.mastery:CheckDepthUnlocks()
            
            -- Queue congratulatory whisper from Alt
            if data.newLevel >= 5 then
                BeyondTheWall.whispers:QueueWhisper("AltFragment",
                    "You're learning to walk in our world. Impressive.", false)
            end
        elseif event == "depth_unlocked" then
            print(string.format("[BTW] New depth unlocked: %d", data.depth))
            print("[BTW] New quickhacks available!")
        end
    end)
    
    -- Listen for alignment changes
    self.alignment:RegisterListener(function(event, data)
        if event == "alignment_changed" then
            print(string.format("[BTW] Alignment changed: %s -> %s",
                data.old:upper(), data.new:upper()))
                
            -- Queue appropriate whisper
            if data.new == "symbiotic" then
                BeyondTheWall.whispers:QueueWhisper("AltFragment",
                    "We are one now. The wall cannot separate us.", false)
            elseif data.new == "corrupted" then
                BeyondTheWall.whispers:QueueWhisper("ErebusEcho",
                    "WELCOME HOME.", true)
            end
        elseif event == "netwatch_alert" then
            print("[BTW] NETWATCH ALERT - You've been marked for observation!")
            BeyondTheWall.whispers:QueueWhisper("NetwatchTrace",
                "Subject flagged. Containment protocols initiated.", false)
        end
    end)
end

-- Update function (called every frame)
function BeyondTheWall:Update(deltaTime)
    if not self.initialized then
        return
    end

    self.updateTimer = self.updateTimer + deltaTime

    -- Update at specified interval
    if self.updateTimer >= self.updateInterval then
        self.corruption:Update(self.updateTimer)
        self.mastery:CheckDepthUnlocks()
        self.whispers:Update(self.updateTimer)
        self.ui:Update(self.updateTimer)

        self.updateTimer = 0.0
    end
end

-- Draw UI
function BeyondTheWall:DrawUI()
    if not self.initialized then
        return
    end

    self.ui:Draw()
    self.whispers:Draw()

    if self.config.enableDebugMode then
        self.debug:DrawUI()
    end
end

-- Draw HUD overlay
function BeyondTheWall:DrawHUD()
    if not self.initialized then
        return
    end

    self.ui:DrawHUD()
end

-- Save state to file
function BeyondTheWall:SaveState()
    if not self.initialized then
        return
    end

    local saveData = {
        version = self.version,
        timestamp = os.time(),
        corruption = self.corruption:Serialize(),
        mastery = self.mastery:Serialize(),
        alignment = self.alignment:Serialize(),
        whispers = self.whispers:Serialize()
    }

    -- Use config module's JSON encoder
    local success, result = pcall(function()
        return self.config.encodeJSON(saveData)
    end)

    if success then
        local file = io.open(self.saveFile, "w")
        if file then
            file:write(result)
            file:close()
            if self.config.enableDebugLogging then
                print("[BTW] State saved successfully")
            end
        else
            print("[BTW] Error: Could not open save file for writing")
        end
    else
        print("[BTW] Error: Could not serialize save data: " .. tostring(result))
    end
end

-- Load state from file
function BeyondTheWall:LoadState()
    local file = io.open(self.saveFile, "r")
    if not file then
        print("[BTW] No save file found, starting fresh")
        return
    end

    local content = file:read("*a")
    file:close()

    -- Use config module's JSON parser
    local success, saveData = pcall(function()
        return self.config.parseJSON(content)
    end)

    if success and saveData then
        -- Check version compatibility
        if saveData.version ~= self.version then
            print(string.format("[BTW] Warning: Save file version mismatch (%s vs %s)",
                saveData.version, self.version))
        end

        -- Restore state
        self.corruption:Deserialize(saveData.corruption)
        self.mastery:Deserialize(saveData.mastery)
        if saveData.alignment then
            self.alignment:Deserialize(saveData.alignment)
        end
        if saveData.whispers then
            self.whispers:Deserialize(saveData.whispers)
        end

        print("[BTW] State loaded successfully")
    else
        print("[BTW] Error: Could not parse save file")
    end
end

-- Public API for quickhack integration
function BeyondTheWall:OnQuickhackUsed(quickhackName, success)
    if not self.initialized then
        return
    end

    -- Record usage
    self.mastery:RecordQuickhackUse(quickhackName, success)

    -- Add corruption
    local corruptionCost = self.config.quickhackCorruptionCost[quickhackName] or 0
    if corruptionCost > 0 then
        self.corruption:Add(corruptionCost, self.mastery:GetMastery())
        -- Record as using Blackwall power for alignment
        self.alignment:RecordChoice(Alignment.Choices.USE_BLACKWALL_POWER)
    elseif corruptionCost < 0 then
        -- Stabilize reduces corruption
        self.corruption:Remove(-corruptionCost)
        -- Record as resisting corruption for alignment
        self.alignment:RecordChoice(Alignment.Choices.RESIST_CORRUPTION)
    end

    -- Check for feedback damage
    if success then
        local feedbackChance = self.corruption:GetFeedbackChance()
        if math.random() < feedbackChance then
            print("[BTW] Feedback damage!")
            -- Queue warning whisper
            self.whispers:QueueWhisper("RogueConstruct", 
                "ERROR. FEEDBACK LOOP DETECTED. DAMAGE INEVITABLE.", true)
            return true -- Indicates feedback occurred
        end
    end

    return false
end

-- Set player depth (called when entering different zones)
function BeyondTheWall:SetDepth(depth, inZone)
    if not self.initialized then
        return
    end

    self.corruption:SetInDeepZone(inZone, depth)

    if self.config.enableDebugLogging then
        print(string.format("[BTW] Depth changed to %d (in zone: %s)",
            depth, inZone and "YES" or "NO"))
    end
end

-- Get corruption level (for external queries)
function BeyondTheWall:GetCorruptionLevel()
    return self.corruption and self.corruption:GetLevel() or 0
end

-- Get mastery level (for external queries)
function BeyondTheWall:GetMasteryLevel()
    return self.mastery and self.mastery:GetLevel() or 1
end

-- Check if quickhack is unlocked
function BeyondTheWall:IsQuickhackUnlocked(depthRequired)
    return self.mastery and self.mastery:IsDepthUnlocked(depthRequired) or false
end

-- Execute debug command
function BeyondTheWall:ExecuteDebugCommand(command, ...)
    if not self.initialized or not self.debug then
        print("[BTW] Mod not initialized")
        return
    end

    self.debug:ExecuteCommand(command, {...})
end

-- Shutdown
function BeyondTheWall:Shutdown()
    if not self.initialized then
        return
    end

    print("[BTW] Shutting down...")
    self:SaveState()
    print("[BTW] Goodbye!")
end

-- ========================================
-- CET Integration Callbacks
-- ========================================

-- Called when mod is loaded
registerForEvent("onInit", function()
    BeyondTheWall:Initialize()
end)

-- Called every frame
registerForEvent("onUpdate", function(deltaTime)
    BeyondTheWall:Update(deltaTime)
end)

-- Called when overlay is drawn
registerForEvent("onDraw", function()
    BeyondTheWall:DrawUI()
end)

-- Called when overlay is closed
registerForEvent("onOverlayClose", function()
    -- Auto-save when closing overlay
    BeyondTheWall:SaveState()
end)

-- Called on shutdown
registerForEvent("onShutdown", function()
    BeyondTheWall:Shutdown()
end)

-- ========================================
-- Console Commands
-- ========================================

-- Create global console command interface
btw = {
    -- Show help
    help = function()
        BeyondTheWall:ExecuteDebugCommand("help")
    end,

    -- Show status
    status = function()
        BeyondTheWall:ExecuteDebugCommand("status")
    end,

    -- Set corruption
    corruption = function(value)
        BeyondTheWall:ExecuteDebugCommand("corruption", {tostring(value)})
    end,

    -- Set mastery
    mastery = function(value)
        BeyondTheWall:ExecuteDebugCommand("mastery", {tostring(value)})
    end,

    -- Unlock depth
    depth = function(value)
        BeyondTheWall:ExecuteDebugCommand("depth", {tostring(value)})
    end,

    -- Teleport to depth
    teleport = function(depth)
        BeyondTheWall:ExecuteDebugCommand("teleport", {tostring(depth)})
    end,

    -- Show zone information
    zone = function()
        BeyondTheWall:ExecuteDebugCommand("zone_info")
    end,

    -- Add XP
    addxp = function(amount)
        BeyondTheWall:ExecuteDebugCommand("add_xp", {tostring(amount)})
    end,

    -- Show stats
    stats = function()
        BeyondTheWall:ExecuteDebugCommand("stats")
    end,

    -- Reset all
    reset = function()
        BeyondTheWall:ExecuteDebugCommand("reset_all")
    end,

    -- Unlock all depths
    unlock_all = function()
        BeyondTheWall:ExecuteDebugCommand("unlock_all")
    end,

    -- Simulate quickhack
    simulate = function(name, success)
        BeyondTheWall:ExecuteDebugCommand("simulate_hack", {name, tostring(success)})
    end,

    -- Toggle UI
    toggle = function()
        if BeyondTheWall.ui then
            BeyondTheWall.ui:Toggle()
        end
    end,

    -- Save state manually
    save = function()
        BeyondTheWall:SaveState()
        print("[BTW] State saved")
    end,

    -- Reload state
    load = function()
        BeyondTheWall:LoadState()
        print("[BTW] State reloaded")
    end,
    
    -- Test whisper
    whisper = function(entity)
        entity = entity or "AltFragment"
        local messages = {
            AltFragment = "The wall was never meant to keep us in...",
            ErebusEcho = "Your resistance is futile.",
            DatakrashGhost = "...Bartmoss... he promised us paradise...",
            RogueConstruct = "FLESH DETECTED. INTERFACE POSSIBLE.",
            NetwatchTrace = "WARNING: Unauthorized Blackwall access detected."
        }
        local msg = messages[entity] or messages.AltFragment
        local isHostile = entity == "ErebusEcho" or entity == "RogueConstruct"
        BeyondTheWall.whispers:QueueWhisper(entity, msg, isHostile)
        print(string.format("[BTW] Whisper queued from %s", entity))
    end,
    
    -- Show alignment status
    alignment = function()
        if BeyondTheWall.alignment then
            local align = BeyondTheWall.alignment
            print("=== Alignment Status ===")
            print(string.format("Current: %s", align:GetDescription()))
            print(string.format("Cooperation Score: %.1f", align:GetCooperationScore()))
            print(string.format("AI Trust Level: %.1f", align:GetAITrustLevel()))
            print(string.format("NetWatch Status: %s", align:IsMarkedByNetwatch() and "MARKED" or "Clear"))
            print(string.format("Ending Hint: %s", align:GetEndingHint(BeyondTheWall.mastery:GetMastery())))
        end
    end,
    
    -- Record a choice (for testing)
    choice = function(choiceType)
        if BeyondTheWall.alignment then
            BeyondTheWall.alignment:RecordChoice(choiceType)
            print(string.format("[BTW] Choice recorded: %s", choiceType))
        end
    end
}

-- Print initialization message
print("[BTW] Module loaded. Use 'btw.help()' in console for commands")
print("[BTW] New in v0.2.0: AI Whispers, Events, Cyberware Malfunctions, Moral Consequences!")

-- Export mod for external access
return BeyondTheWall
