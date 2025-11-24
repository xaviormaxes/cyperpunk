// BlackwallIntegration.reds
// Integration helpers for Blackwall quickhacks
module BeyondTheWall.Core

import Codeware.*

// Blackwall quickhack helper functions
public abstract class BlackwallHelper {

  // Called when a Blackwall quickhack is used
  public static func OnQuickhackUsed(quickhackName: CName, success: Bool) -> Bool {
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();

    if !IsDefined(corruptionSystem) || !IsDefined(masterySystem) {
      LogChannel(n"BTW", "[Integration] ERROR: Systems not initialized!");
      return false;
    }

    // Record the quickhack use
    masterySystem.RecordQuickhackUse(quickhackName, success);

    // Add corruption
    let corruptionCost: Float = BlackwallHelper.GetCorruptionCost(quickhackName);
    if corruptionCost > 0.0 {
      corruptionSystem.AddCorruption(corruptionCost, masterySystem.GetMastery());
    } else if corruptionCost < 0.0 {
      // Stabilize reduces corruption
      corruptionSystem.RemoveCorruption(-corruptionCost);
    }

    // Check for feedback damage
    if success {
      let feedbackChance: Float = corruptionSystem.GetFeedbackChance();
      let randomValue: Float = RandRangeF(0.0, 1.0);

      if randomValue < feedbackChance {
        LogChannel(n"BTW", s"[Integration] Feedback damage! (\(feedbackChance * 100.0)% chance)");
        // TODO: Apply actual damage in Phase 2
        return true; // Indicates feedback occurred
      }
    }

    return false;
  }

  // Get corruption cost for quickhack
  private static func GetCorruptionCost(quickhackName: CName) -> Float {
    // Matches config.json quickhackCorruptionCost
    if Equals(quickhackName, n"BlackwallTrace") {
      return 5.0;
    } else if Equals(quickhackName, n"NeuralHijack") {
      return 10.0;
    } else if Equals(quickhackName, n"CascadeProtocol") {
      return 15.0;
    } else if Equals(quickhackName, n"SummonDaemon") {
      return 20.0;
    } else if Equals(quickhackName, n"BlackwallOverload") {
      return 30.0;
    } else if Equals(quickhackName, n"Stabilize") {
      return -25.0;
    }

    return 0.0;
  }

  // Check if quickhack is unlocked
  public static func IsQuickhackUnlocked(depthRequired: Int32) -> Bool {
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();

    if !IsDefined(masterySystem) {
      return false;
    }

    return masterySystem.IsDepthUnlocked(depthRequired);
  }

  // Get adjusted RAM cost (with mastery reduction)
  public static func GetAdjustedRAMCost(baseRAMCost: Int32) -> Int32 {
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();

    if !IsDefined(masterySystem) {
      return baseRAMCost;
    }

    let reduction: Float = masterySystem.GetCostReduction();
    let adjustedCost: Float = Cast<Float>(baseRAMCost) * (1.0 - reduction);

    return Max(RoundF(adjustedCost), 1); // Minimum 1 RAM
  }

  // Check if player should suffer negative effects
  public static func ShouldApplyNegativeEffects() -> Bool {
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();

    if !IsDefined(corruptionSystem) || !IsDefined(masterySystem) {
      return false;
    }

    return corruptionSystem.ShouldApplyNegativeEffects(masterySystem.GetMastery());
  }

  // Get current corruption tier
  public static func GetCorruptionTier() -> BlackwallCorruptionTier {
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();

    if !IsDefined(corruptionSystem) {
      return BlackwallCorruptionTier.None;
    }

    return corruptionSystem.GetCorruptionTier();
  }

  // Get current mastery level
  public static func GetMasteryLevel() -> Int32 {
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();

    if !IsDefined(masterySystem) {
      return 1;
    }

    return masterySystem.GetLevel();
  }
}

// Extension to PlayerPuppet for easier access
@addMethod(PlayerPuppet)
public func GetBlackwallCorruption() -> Float {
  let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
  if IsDefined(corruptionSystem) {
    return corruptionSystem.GetCorruptionLevel();
  }
  return 0.0;
}

@addMethod(PlayerPuppet)
public func GetBlackwallMastery() -> Float {
  let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();
  if IsDefined(masterySystem) {
    return masterySystem.GetMastery();
  }
  return 0.0;
}

@addMethod(PlayerPuppet)
public func IsBlackwallDepthUnlocked(depth: Int32) -> Bool {
  return BlackwallHelper.IsQuickhackUnlocked(depth);
}

// Log initialization
@addMethod(GameInstance)
private func InitializeBlackwallSystems() -> Void {
  LogChannel(n"BTW", "[Integration] Blackwall systems initialized");
}
