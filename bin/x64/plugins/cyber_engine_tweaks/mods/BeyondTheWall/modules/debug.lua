-- Debug Module
-- Provides debugging commands and utilities

local Debug = {}
Debug.__index = Debug

-- Constructor
function Debug:New(config, corruptionSystem, masterySystem)
    local instance = setmetatable({}, Debug)
    instance.config = config
    instance.corruption = corruptionSystem
    instance.mastery = masterySystem
    instance.commandHistory = {}

    return instance
end

-- Execute debug command
function Debug:ExecuteCommand(command, args)
    if not self.config.enableDebugMode then
        print("[BTW Debug] Debug mode is disabled. Enable it in config.json")
        return false
    end

    -- Log command
    table.insert(self.commandHistory, {
        command = command,
        args = args,
        timestamp = os.time()
    })

    -- Dispatch to appropriate handler
    local handler = self["cmd_" .. command]
    if handler then
        handler(self, args)
        return true
    else
        print("[BTW Debug] Unknown command: " .. command)
        self:cmd_help()
        return false
    end
end

-- Help command
function Debug:cmd_help()
    print("=== Beyond the Wall Debug Commands ===")
    print("  help - Show this help")
    print("  status - Show current system status")
    print("  corruption <value> - Set corruption to value (0-100)")
    print("  mastery <value> - Set mastery to value (0-100)")
    print("  depth <value> - Unlock depth level (1-5)")
    print("  teleport <depth> - Teleport to depth zone (1-5)")
    print("  zone_info - Show current zone information")
    print("  reset_corruption - Reset corruption to 0")
    print("  reset_mastery - Reset mastery to 0")
    print("  reset_all - Reset all systems")
    print("  add_xp <amount> - Add mastery XP")
    print("  stats - Show detailed statistics")
    print("  unlock_all - Unlock all depth levels")
    print("  simulate_hack <name> [success] - Simulate quickhack usage")
end

-- Status command
function Debug:cmd_status()
    print("=== Beyond the Wall Status ===")
    print(string.format("Corruption: %.2f / 100.0 (%s)",
        self.corruption:GetLevel(),
        self.corruption:GetTier():upper()))
    print(string.format("Mastery: %.2f / 100.0 (Level %d)",
        self.mastery:GetMastery(),
        self.mastery:GetLevel()))
    print(string.format("Current Depth: %d", self.corruption:GetDepth()))
    print(string.format("Max Unlocked Depth: %d", self.mastery:GetMaxDepth()))
    print(string.format("In Deep Zone: %s", self.corruption.isInDeepZone and "YES" or "NO"))
    print(string.format("Feedback Chance: %.1f%%", self.corruption:GetFeedbackChance() * 100))
end

-- Set corruption command
function Debug:cmd_corruption(args)
    local value = tonumber(args[1])
    if not value then
        print("[BTW Debug] Usage: corruption <value>")
        return
    end

    self.corruption:Set(value)
    print(string.format("[BTW Debug] Corruption set to %.2f", value))
end

-- Set mastery command
function Debug:cmd_mastery(args)
    local value = tonumber(args[1])
    if not value then
        print("[BTW Debug] Usage: mastery <value>")
        return
    end

    -- Set mastery by adding/removing XP
    local current = self.mastery:GetMastery()
    local diff = value - current
    self.mastery:AddExperience(diff)
    print(string.format("[BTW Debug] Mastery set to %.2f (Level %d)",
        self.mastery:GetMastery(),
        self.mastery:GetLevel()))
end

-- Unlock depth command
function Debug:cmd_depth(args)
    local depth = tonumber(args[1])
    if not depth or depth < 1 or depth > 5 then
        print("[BTW Debug] Usage: depth <1-5>")
        return
    end

    self.mastery:UnlockDepth(depth)
    print(string.format("[BTW Debug] Depth %d unlocked", depth))
end

-- Reset corruption command
function Debug:cmd_reset_corruption()
    self.corruption:Reset()
    print("[BTW Debug] Corruption reset to 0")
end

-- Reset mastery command
function Debug:cmd_reset_mastery()
    self.mastery:Reset()
    print("[BTW Debug] Mastery reset to 0")
end

-- Reset all command
function Debug:cmd_reset_all()
    self.corruption:Reset()
    self.mastery:Reset()
    print("[BTW Debug] All systems reset")
end

-- Add XP command
function Debug:cmd_add_xp(args)
    local amount = tonumber(args[1])
    if not amount then
        print("[BTW Debug] Usage: add_xp <amount>")
        return
    end

    self.mastery:AddExperience(amount)
    print(string.format("[BTW Debug] Added %.2f XP (Current: %.2f, Level: %d)",
        amount,
        self.mastery:GetMastery(),
        self.mastery:GetLevel()))
end

-- Show detailed stats command
function Debug:cmd_stats()
    local summary = self.mastery:GetStatsSummary()

    print("=== Detailed Statistics ===")
    print(string.format("Mastery: %.2f (Level %d)", summary.mastery, summary.level))
    print(string.format("Max Depth: %d", summary.maxDepth))
    print(string.format("Total Quickhack Uses: %d", summary.totalQuickhackUses))
    print(string.format("Total Successes: %d", summary.totalSuccesses))
    print(string.format("Overall Success Rate: %.1f%%", summary.overallSuccessRate * 100))
    print(string.format("Corruption Resistance: %.1f%%", summary.corruptionResistance * 100))
    print(string.format("RAM Cost Reduction: %.1f%%", summary.costReduction * 100))

    print("\n=== Quickhack Breakdown ===")
    local quickhacks = {
        "BlackwallTrace",
        "NeuralHijack",
        "CascadeProtocol",
        "SummonDaemon",
        "BlackwallOverload"
    }

    for _, qh in ipairs(quickhacks) do
        local stats = self.mastery:GetQuickhackStats(qh)
        local successRate = self.mastery:GetQuickhackSuccessRate(qh)
        print(string.format("  %s: %d uses, %d successes (%.1f%%)",
            qh, stats.uses, stats.successes, successRate * 100))
    end
end

-- Unlock all depths command
function Debug:cmd_unlock_all()
    for depth = 1, 5 do
        self.mastery:UnlockDepth(depth)
    end
    print("[BTW Debug] All depths unlocked")
end

-- Simulate quickhack usage command
function Debug:cmd_simulate_hack(args)
    local hackName = args[1]
    local success = args[2] ~= "false" and args[2] ~= "0"

    if not hackName then
        print("[BTW Debug] Usage: simulate_hack <name> [success]")
        print("Available hacks: BlackwallTrace, NeuralHijack, CascadeProtocol, SummonDaemon, BlackwallOverload")
        return
    end

    self.mastery:RecordQuickhackUse(hackName, success)
    print(string.format("[BTW Debug] Simulated %s quickhack (%s)",
        hackName,
        success and "SUCCESS" or "FAILED"))
end

-- Teleport to depth command (triggers REDscript side)
function Debug:cmd_teleport(args)
    local depth = tonumber(args[1])
    if not depth or depth < 1 or depth > 5 then
        print("[BTW Debug] Usage: teleport <1-5>")
        return
    end

    print(string.format("[BTW Debug] Teleporting to Depth %d...", depth))
    print("[BTW Debug] NOTE: This requires REDscript integration")
    print("[BTW Debug] In-game, use console: Game.TeleportPlayerToNode(\"BTW_Depth" .. depth .. "\")")

    -- For testing, just simulate entering the zone
    self.corruption:SetInDeepZone(true, depth)
    print(string.format("[BTW Debug] Simulated entry to Depth %d zone", depth))
end

-- Show zone information command
function Debug:cmd_zone_info()
    local currentDepth = self.corruption:GetDepth()
    local inZone = self.corruption.isInDeepZone

    print("=== Zone Information ===")
    if inZone then
        local zoneName = self:GetZoneName(currentDepth)
        print(string.format("Current Zone: Depth %d - %s", currentDepth, zoneName))
        print(string.format("In Facility: YES"))

        -- Show zone details from configuration
        local zoneDetails = self:GetZoneDetails(currentDepth)
        if zoneDetails then
            print(string.format("Corruption Multiplier: %.1fx", zoneDetails.corruptionMultiplier))
            print(string.format("Ambient Corruption: %.2f/sec", zoneDetails.ambientRate))
        end
    else
        print("Current Zone: Outside Facility")
        print("In Facility: NO")
        print("Corruption is decaying normally")
    end
end

-- Helper: Get zone name
function Debug:GetZoneName(depth)
    local zoneNames = {
        [1] = "Surface Contact",
        [2] = "Protocol Breach",
        [3] = "Deep Dive",
        [4] = "Old Net Interface",
        [5] = "Beyond the Veil"
    }
    return zoneNames[depth] or "Unknown"
end

-- Helper: Get zone details
function Debug:GetZoneDetails(depth)
    local zoneDetails = {
        [1] = { corruptionMultiplier = 1.0, ambientRate = 0.1 },
        [2] = { corruptionMultiplier = 1.2, ambientRate = 0.2 },
        [3] = { corruptionMultiplier = 1.5, ambientRate = 0.3 },
        [4] = { corruptionMultiplier = 2.0, ambientRate = 0.5 },
        [5] = { corruptionMultiplier = 3.0, ambientRate = 1.0 }
    }
    return zoneDetails[depth]
end

-- Get command history
function Debug:GetHistory(count)
    count = count or 10
    local history = {}
    local start = math.max(1, #self.commandHistory - count + 1)

    for i = start, #self.commandHistory do
        table.insert(history, self.commandHistory[i])
    end

    return history
end

-- Draw debug UI
function Debug:DrawUI()
    if not self.config.enableDebugMode then
        return
    end

    if ImGui.Begin("Beyond the Wall - Debug") then
        ImGui.TextColored(1.0, 0.5, 0.0, 1.0, "DEBUG MODE ENABLED")
        ImGui.Spacing()

        -- Quick actions
        if ImGui.Button("Reset All") then
            self:cmd_reset_all()
        end
        ImGui.SameLine()
        if ImGui.Button("Unlock All Depths") then
            self:cmd_unlock_all()
        end
        ImGui.SameLine()
        if ImGui.Button("Max Mastery") then
            self:cmd_mastery({"100"})
        end

        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        -- Corruption controls
        ImGui.Text("Corruption Controls:")
        local corruption = self.corruption:GetLevel()
        local newCorruption = ImGui.SliderFloat("##corruption", corruption, 0.0, 100.0, "%.1f")
        if newCorruption ~= corruption then
            self.corruption:Set(newCorruption)
        end

        ImGui.Spacing()

        -- Mastery controls
        ImGui.Text("Mastery Controls:")
        local mastery = self.mastery:GetMastery()
        local newMastery = ImGui.SliderFloat("##mastery", mastery, 0.0, 100.0, "%.1f")
        if newMastery ~= mastery then
            self.mastery:AddExperience(newMastery - mastery)
        end

        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()

        -- Quickhack simulation
        ImGui.Text("Simulate Quickhack:")
        local quickhacks = {
            "BlackwallTrace",
            "NeuralHijack",
            "CascadeProtocol",
            "SummonDaemon",
            "BlackwallOverload"
        }

        for _, qh in ipairs(quickhacks) do
            if ImGui.Button("Success: " .. qh) then
                self.mastery:RecordQuickhackUse(qh, true)
            end
            ImGui.SameLine()
            if ImGui.Button("Fail: " .. qh) then
                self.mastery:RecordQuickhackUse(qh, false)
            end
        end
    end
    ImGui.End()
end

return Debug
