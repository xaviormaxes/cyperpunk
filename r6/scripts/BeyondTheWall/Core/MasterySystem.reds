// MasterySystem.reds
// Handles Blackwall mastery progression and quickhack tracking
module BeyondTheWall.Core

import Codeware.*

// Quickhack statistics structure
public struct QuickhackStats {
  let uses: Int32;
  let successes: Int32;
}

// Main mastery system class
public class BlackwallMasterySystem extends ScriptableSystem {
  private let m_currentMastery: Float;
  private let m_currentLevel: Int32;
  private let m_experiencePerLevel: Float;
  private let m_maxMastery: Float;
  private let m_maxLevel: Int32;
  private let m_masteryMultiplier: Float;

  // Track unlocked depths
  private let m_unlockedDepths: array<Int32>;

  // Quickhack statistics (simplified - would use proper data structure in full implementation)
  private let m_totalQuickhackUses: Int32;
  private let m_totalSuccesses: Int32;

  // Initialize system
  private func OnAttach() -> Void {
    this.m_currentMastery = 0.0;
    this.m_currentLevel = 1;
    this.m_experiencePerLevel = 10.0;
    this.m_maxMastery = 100.0;
    this.m_maxLevel = 10;
    this.m_masteryMultiplier = 1.0;

    this.m_totalQuickhackUses = 0;
    this.m_totalSuccesses = 0;

    // Initialize with depth 1 unlocked
    ArrayClear(this.m_unlockedDepths);
    ArrayPush(this.m_unlockedDepths, 1);

    LogChannel(n"BTW", "[MasterySystem] Initialized");
  }

  // Get current mastery (0-100)
  public func GetMastery() -> Float {
    return this.m_currentMastery;
  }

  // Get current level (1-10)
  public func GetLevel() -> Int32 {
    return this.m_currentLevel;
  }

  // Get progress to next level (0.0 - 1.0)
  public func GetLevelProgress() -> Float {
    let currentLevelXP: Float = Cast<Float>(this.m_currentLevel - 1) * this.m_experiencePerLevel;
    let nextLevelXP: Float = Cast<Float>(this.m_currentLevel) * this.m_experiencePerLevel;
    let progress: Float = (this.m_currentMastery - currentLevelXP) / (nextLevelXP - currentLevelXP);
    return ClampF(progress, 0.0, 1.0);
  }

  // Add mastery experience
  public func AddExperience(amount: Float) -> Void {
    let adjustedAmount: Float = amount * this.m_masteryMultiplier;
    let oldMastery: Float = this.m_currentMastery;
    let oldLevel: Int32 = this.m_currentLevel;

    this.m_currentMastery = MinF(this.m_currentMastery + adjustedAmount, this.m_maxMastery);

    // Calculate new level
    let newLevel: Int32 = Min(
      FloorF(this.m_currentMastery / this.m_experiencePerLevel) + 1,
      this.m_maxLevel
    );
    this.m_currentLevel = newLevel;

    // Check for level up
    if newLevel > oldLevel {
      this.OnLevelUp(oldLevel, newLevel);
    }

    if adjustedAmount > 0.0 {
      LogChannel(n"BTW", s"[MasterySystem] XP gained: \(adjustedAmount) -> Current: \(this.m_currentMastery) (Level \(this.m_currentLevel))");
    }
  }

  // Record quickhack usage
  public func RecordQuickhackUse(quickhackName: CName, success: Bool) -> Void {
    this.m_totalQuickhackUses += 1;

    if success {
      this.m_totalSuccesses += 1;

      // Award mastery XP for successful use
      let baseXP: Float = this.GetXPForQuickhack(quickhackName);
      this.AddExperience(baseXP);
    }
  }

  // Get XP reward for quickhack
  private func GetXPForQuickhack(quickhackName: CName) -> Float {
    // More XP for advanced quickhacks
    if Equals(quickhackName, n"BlackwallOverload") {
      return 5.0;
    } else if Equals(quickhackName, n"SummonDaemon") {
      return 3.0;
    } else if Equals(quickhackName, n"CascadeProtocol") {
      return 2.0;
    } else {
      return 1.0;
    }
  }

  // Check if depth is unlocked
  public func IsDepthUnlocked(depth: Int32) -> Bool {
    let i: Int32;
    let size: Int32 = ArraySize(this.m_unlockedDepths);

    for i = 0; i < size; i += 1 {
      if this.m_unlockedDepths[i] == depth {
        return true;
      }
    }

    return false;
  }

  // Unlock new depth
  public func UnlockDepth(depth: Int32) -> Void {
    if !this.IsDepthUnlocked(depth) {
      ArrayPush(this.m_unlockedDepths, depth);
      LogChannel(n"BTW", s"[MasterySystem] Depth \(depth) unlocked!");
    }
  }

  // Get maximum unlocked depth
  public func GetMaxDepth() -> Int32 {
    let maxDepth: Int32 = 1;
    let i: Int32;
    let size: Int32 = ArraySize(this.m_unlockedDepths);

    for i = 0; i < size; i += 1 {
      if this.m_unlockedDepths[i] > maxDepth {
        maxDepth = this.m_unlockedDepths[i];
      }
    }

    return maxDepth;
  }

  // Check depth unlock requirements
  public func CheckDepthUnlocks() -> Void {
    // Depth unlock requirements (matches config.json)
    if this.m_currentMastery >= 10.0 {
      this.UnlockDepth(2);
    }
    if this.m_currentMastery >= 25.0 {
      this.UnlockDepth(3);
    }
    if this.m_currentMastery >= 50.0 {
      this.UnlockDepth(4);
    }
    if this.m_currentMastery >= 100.0 {
      this.UnlockDepth(5);
    }
  }

  // Get corruption resistance (0.0 - 1.0) based on mastery
  public func GetCorruptionResistance() -> Float {
    return MinF(this.m_currentMastery / 100.0, 1.0);
  }

  // Get quickhack RAM cost reduction (0.0 - 1.0) based on mastery
  public func GetCostReduction() -> Float {
    // At max mastery level (10), get 50% cost reduction
    return (Cast<Float>(this.m_currentLevel) / Cast<Float>(this.m_maxLevel)) * 0.5;
  }

  // Get total quickhack uses
  public func GetTotalUses() -> Int32 {
    return this.m_totalQuickhackUses;
  }

  // Get total successes
  public func GetTotalSuccesses() -> Int32 {
    return this.m_totalSuccesses;
  }

  // Get overall success rate
  public func GetSuccessRate() -> Float {
    if this.m_totalQuickhackUses == 0 {
      return 0.0;
    }
    return Cast<Float>(this.m_totalSuccesses) / Cast<Float>(this.m_totalQuickhackUses);
  }

  // Called when level up occurs
  private func OnLevelUp(oldLevel: Int32, newLevel: Int32) -> Void {
    LogChannel(n"BTW", s"[MasterySystem] Level up! \(oldLevel) -> \(newLevel)");

    // Check for depth unlocks
    this.CheckDepthUnlocks();

    // TODO: Show level up notification to player (Phase 4)
  }

  // Reset mastery
  public func Reset() -> Void {
    this.m_currentMastery = 0.0;
    this.m_currentLevel = 1;
    this.m_totalQuickhackUses = 0;
    this.m_totalSuccesses = 0;

    ArrayClear(this.m_unlockedDepths);
    ArrayPush(this.m_unlockedDepths, 1);

    LogChannel(n"BTW", "[MasterySystem] Reset");
  }

  // Set mastery multiplier
  public func SetMasteryMultiplier(multiplier: Float) -> Void {
    this.m_masteryMultiplier = multiplier;
  }
}

// Global accessor function
public static func GetBlackwallMasterySystem() -> ref<BlackwallMasterySystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.BlackwallMasterySystem") as BlackwallMasterySystem;
}
