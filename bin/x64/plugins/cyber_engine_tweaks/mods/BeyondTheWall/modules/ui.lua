-- UI Module
-- Manages the in-game UI overlay for corruption and mastery display

local UI = {}
UI.__index = UI

-- Constructor
function UI:New(config, corruptionSystem, masterySystem)
    local instance = setmetatable({}, UI)
    instance.config = config
    instance.corruption = corruptionSystem
    instance.mastery = masterySystem
    instance.visible = true
    instance.updateTimer = 0.0

    -- Colors for corruption tiers
    instance.colors = {
        none = { 0.0, 1.0, 0.0, 1.0 },      -- Green
        low = { 0.5, 1.0, 0.0, 1.0 },       -- Yellow-green
        medium = { 1.0, 1.0, 0.0, 1.0 },    -- Yellow
        high = { 1.0, 0.5, 0.0, 1.0 },      -- Orange
        critical = { 1.0, 0.0, 0.0, 1.0 }   -- Red
    }

    return instance
end

-- Toggle UI visibility
function UI:Toggle()
    self.visible = not self.visible
end

-- Set UI visibility
function UI:SetVisible(visible)
    self.visible = visible
end

-- Update UI (call every frame if needed)
function UI:Update(deltaTime)
    self.updateTimer = self.updateTimer + deltaTime
end

-- Draw the main UI overlay using ImGui
function UI:Draw()
    if not self.visible then
        return
    end

    local uiConfig = self.config.ui

    -- Main window
    if ImGui.Begin("Beyond the Wall", ImGuiWindowFlags.NoCollapse) then
        self:DrawCorruptionMeter()
        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()
        self:DrawMasteryProgress()
        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()
        self:DrawDepthInfo()
        ImGui.Spacing()
        ImGui.Separator()
        ImGui.Spacing()
        self:DrawQuickhackStats()
    end
    ImGui.End()
end

-- Draw corruption meter
function UI:DrawCorruptionMeter()
    if not self.config.ui.showCorruptionMeter then
        return
    end

    local corruption = self.corruption:GetLevel()
    local percentage = self.corruption:GetPercentage()
    local tier = self.corruption:GetTier()
    local color = self.colors[tier]

    ImGui.Text("Blackwall Corruption")

    -- Progress bar
    ImGui.PushStyleColor(ImGuiCol.PlotHistogram, color[1], color[2], color[3], color[4])
    ImGui.ProgressBar(percentage, -1, 20, string.format("%.1f / 100.0", corruption))
    ImGui.PopStyleColor()

    -- Tier indicator
    ImGui.SameLine()
    ImGui.TextColored(color[1], color[2], color[3], color[4], string.format("[%s]", tier:upper()))

    -- Decay info
    if not self.corruption.isInDeepZone and corruption > 0 then
        local decayIn = self.config.corruptionDecayInterval - self.corruption.decayTimer
        ImGui.TextColored(0.7, 0.7, 0.7, 1.0, string.format("Decaying in: %.1fs", decayIn))
    elseif self.corruption.isInDeepZone then
        ImGui.TextColored(1.0, 0.5, 0.0, 1.0, "In Deep Zone - No Decay")
    end
end

-- Draw mastery progress
function UI:DrawMasteryProgress()
    if not self.config.ui.showMasteryProgress then
        return
    end

    local mastery = self.mastery:GetMastery()
    local level = self.mastery:GetLevel()
    local progress = self.mastery:GetLevelProgress()

    ImGui.Text(string.format("Mastery Level: %d / %d", level, self.mastery.maxLevel))

    -- Progress to next level
    ImGui.ProgressBar(progress, -1, 20, string.format("%.1f%%", progress * 100))

    -- Bonuses
    local resistance = self.mastery:GetCorruptionResistance() * 100
    local costReduction = self.mastery:GetCostReduction() * 100

    ImGui.TextColored(0.5, 1.0, 0.5, 1.0, string.format("Corruption Resistance: %.1f%%", resistance))
    ImGui.TextColored(0.5, 0.5, 1.0, 1.0, string.format("RAM Cost Reduction: %.1f%%", costReduction))
end

-- Draw depth information
function UI:DrawDepthInfo()
    if not self.config.ui.showDepthLevel then
        return
    end

    local currentDepth = self.corruption:GetDepth()
    local maxDepth = self.mastery:GetMaxDepth()

    ImGui.Text(string.format("Current Depth: %d", currentDepth))
    ImGui.Text(string.format("Max Unlocked Depth: %d / 5", maxDepth))

    -- Show which depths are unlocked
    ImGui.Text("Unlocked Depths:")
    for depth = 1, 5 do
        local unlocked = self.mastery:IsDepthUnlocked(depth)
        if unlocked then
            ImGui.SameLine()
            ImGui.TextColored(0.0, 1.0, 0.0, 1.0, string.format("[%d]", depth))
        else
            ImGui.SameLine()
            ImGui.TextColored(0.5, 0.5, 0.5, 1.0, string.format("[%d]", depth))
        end
    end

    -- Show feedback chance
    local feedbackChance = self.corruption:GetFeedbackChance() * 100
    if feedbackChance > 0 then
        ImGui.TextColored(1.0, 0.5, 0.0, 1.0, string.format("Feedback Damage Chance: %.1f%%", feedbackChance))
    end
end

-- Draw quickhack statistics
function UI:DrawQuickhackStats()
    if ImGui.CollapsingHeader("Quickhack Statistics") then
        local stats = self.mastery:GetStatsSummary()

        ImGui.Text(string.format("Total Uses: %d", stats.totalQuickhackUses))
        ImGui.Text(string.format("Total Successes: %d", stats.totalSuccesses))
        ImGui.Text(string.format("Success Rate: %.1f%%", stats.overallSuccessRate * 100))

        ImGui.Spacing()
        ImGui.Text("Individual Quickhacks:")

        local quickhacks = {
            "BlackwallTrace",
            "NeuralHijack",
            "CascadeProtocol",
            "SummonDaemon",
            "BlackwallOverload"
        }

        for _, qh in ipairs(quickhacks) do
            local qhStats = self.mastery:GetQuickhackStats(qh)
            local successRate = self.mastery:GetQuickhackSuccessRate(qh)

            ImGui.Text(string.format("  %s:", qh))
            ImGui.SameLine()
            ImGui.TextColored(0.7, 0.7, 0.7, 1.0, string.format("%d uses, %.1f%% success", qhStats.uses, successRate * 100))
        end
    end
end

-- Draw minimal HUD overlay (for in-game, non-menu view)
function UI:DrawHUD()
    if not self.visible then
        return
    end

    local uiConfig = self.config.ui
    local corruption = self.corruption:GetLevel()
    local tier = self.corruption:GetTier()
    local color = self.colors[tier]

    -- Minimal corruption meter in top-right
    ImGui.SetNextWindowPos(uiConfig.hudPosition.x, uiConfig.hudPosition.y)
    ImGui.SetNextWindowSize(200, 80)

    if ImGui.Begin("BTW_HUD", ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoScrollbar) then
        ImGui.Text("Corruption")
        ImGui.PushStyleColor(ImGuiCol.PlotHistogram, color[1], color[2], color[3], color[4])
        ImGui.ProgressBar(self.corruption:GetPercentage(), -1, 15, string.format("%.0f%%", corruption))
        ImGui.PopStyleColor()

        ImGui.Text(string.format("Mastery Lv.%d", self.mastery:GetLevel()))
    end
    ImGui.End()
end

-- Get color for corruption tier
function UI:GetTierColor(tier)
    return self.colors[tier] or self.colors.none
end

return UI
