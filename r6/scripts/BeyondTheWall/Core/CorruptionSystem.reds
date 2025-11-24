// CorruptionSystem.reds
// Handles Blackwall corruption tracking and effects
module BeyondTheWall.Core

import Codeware.*

// Corruption tier enumeration
public enum BlackwallCorruptionTier {
  None = 0,
  Low = 1,
  Medium = 2,
  High = 3,
  Critical = 4
}

// Main corruption system class
public class BlackwallCorruptionSystem extends ScriptableSystem {
  private let m_corruptionLevel: Float;
  private let m_isInDeepZone: Bool;
  private let m_currentDepth: Int32;
  private let m_decayTimer: Float;
  private let m_lastTier: BlackwallCorruptionTier;

  // Configuration (should match config.json)
  private let m_decayRate: Float;
  private let m_decayInterval: Float;
  private let m_maxCorruption: Float;

  // Initialize system
  private func OnAttach() -> Void {
    this.m_corruptionLevel = 0.0;
    this.m_isInDeepZone = false;
    this.m_currentDepth = 0;
    this.m_decayTimer = 0.0;
    this.m_lastTier = BlackwallCorruptionTier.None;

    // Configuration defaults
    this.m_decayRate = 0.5;
    this.m_decayInterval = 5.0;
    this.m_maxCorruption = 100.0;

    LogChannel(n"BTW", "[CorruptionSystem] Initialized");
  }

  // Update tick
  private func OnTick(deltaTime: Float) -> Void {
    // Decay corruption over time when not in deep zone
    if !this.m_isInDeepZone && this.m_corruptionLevel > 0.0 {
      this.m_decayTimer += deltaTime;

      if this.m_decayTimer >= this.m_decayInterval {
        this.RemoveCorruption(this.m_decayRate);
        this.m_decayTimer = 0.0;
      }
    }

    // Check for tier changes
    this.CheckTierChange();
  }

  // Get current corruption level
  public func GetCorruptionLevel() -> Float {
    return this.m_corruptionLevel;
  }

  // Get corruption percentage (0.0 - 1.0)
  public func GetCorruptionPercentage() -> Float {
    return this.m_corruptionLevel / this.m_maxCorruption;
  }

  // Get current corruption tier
  public func GetCorruptionTier() -> BlackwallCorruptionTier {
    if this.m_corruptionLevel >= 90.0 {
      return BlackwallCorruptionTier.Critical;
    } else if this.m_corruptionLevel >= 75.0 {
      return BlackwallCorruptionTier.High;
    } else if this.m_corruptionLevel >= 50.0 {
      return BlackwallCorruptionTier.Medium;
    } else if this.m_corruptionLevel >= 25.0 {
      return BlackwallCorruptionTier.Low;
    } else {
      return BlackwallCorruptionTier.None;
    }
  }

  // Add corruption
  public func AddCorruption(amount: Float, mastery: Float) -> Void {
    // Apply mastery reduction
    let reduction: Float = MinF((mastery / 100.0) * 0.5, 0.5);
    let adjustedAmount: Float = amount * (1.0 - reduction);

    this.m_corruptionLevel = MinF(this.m_corruptionLevel + adjustedAmount, this.m_maxCorruption);

    LogChannel(n"BTW", s"[CorruptionSystem] Added \(adjustedAmount) corruption (mastery reduction: \(reduction * 100.0)%) -> Current: \(this.m_corruptionLevel)");
  }

  // Remove corruption
  public func RemoveCorruption(amount: Float) -> Void {
    this.m_corruptionLevel = MaxF(this.m_corruptionLevel - amount, 0.0);
  }

  // Set corruption to specific value
  public func SetCorruption(value: Float) -> Void {
    this.m_corruptionLevel = ClampF(value, 0.0, this.m_maxCorruption);
  }

  // Set deep zone status
  public func SetInDeepZone(inZone: Bool, depth: Int32) -> Void {
    this.m_isInDeepZone = inZone;
    this.m_currentDepth = depth;

    if inZone {
      LogChannel(n"BTW", s"[CorruptionSystem] Entered depth \(depth)");
    }
  }

  // Get current depth
  public func GetCurrentDepth() -> Int32 {
    return this.m_currentDepth;
  }

  // Check if should apply negative effects
  public func ShouldApplyNegativeEffects(mastery: Float) -> Bool {
    let tier: BlackwallCorruptionTier = this.GetCorruptionTier();

    switch tier {
      case BlackwallCorruptionTier.Critical:
        return mastery < 80.0;
      case BlackwallCorruptionTier.High:
        return mastery < 60.0;
      case BlackwallCorruptionTier.Medium:
        return mastery < 40.0;
      default:
        return false;
    }
  }

  // Get feedback damage chance
  public func GetFeedbackChance() -> Float {
    let baseChance: Float = this.GetBaseChanceForDepth(this.m_currentDepth);
    let tier: BlackwallCorruptionTier = this.GetCorruptionTier();
    let multiplier: Float = 1.0;

    switch tier {
      case BlackwallCorruptionTier.Critical:
        multiplier = 2.0;
        break;
      case BlackwallCorruptionTier.High:
        multiplier = 1.5;
        break;
      case BlackwallCorruptionTier.Medium:
        multiplier = 1.2;
        break;
    }

    return baseChance * multiplier;
  }

  // Get base feedback chance for depth
  private func GetBaseChanceForDepth(depth: Int32) -> Float {
    switch depth {
      case 1:
        return 0.05;
      case 2:
        return 0.10;
      case 3:
        return 0.15;
      case 4:
        return 0.20;
      case 5:
        return 0.25;
      default:
        return 0.0;
    }
  }

  // Check for tier changes
  private func CheckTierChange() -> Void {
    let currentTier: BlackwallCorruptionTier = this.GetCorruptionTier();

    if NotEquals(currentTier, this.m_lastTier) {
      this.OnTierChanged(this.m_lastTier, currentTier);
      this.m_lastTier = currentTier;
    }
  }

  // Called when corruption tier changes
  private func OnTierChanged(oldTier: BlackwallCorruptionTier, newTier: BlackwallCorruptionTier) -> Void {
    LogChannel(n"BTW", s"[CorruptionSystem] Tier changed: \(EnumInt(oldTier)) -> \(EnumInt(newTier))");

    // Apply visual effects based on tier (to be implemented in Phase 4)
    if Equals(newTier, BlackwallCorruptionTier.Critical) {
      // TODO: Apply critical corruption visual effects
      LogChannel(n"BTW", "[CorruptionSystem] WARNING: Critical corruption level!");
    }
  }

  // Reset corruption
  public func Reset() -> Void {
    this.m_corruptionLevel = 0.0;
    this.m_isInDeepZone = false;
    this.m_currentDepth = 0;
    this.m_decayTimer = 0.0;
    this.m_lastTier = BlackwallCorruptionTier.None;

    LogChannel(n"BTW", "[CorruptionSystem] Reset");
  }
}

// Global accessor function
public static func GetBlackwallCorruptionSystem() -> ref<BlackwallCorruptionSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.BlackwallCorruptionSystem") as BlackwallCorruptionSystem;
}
