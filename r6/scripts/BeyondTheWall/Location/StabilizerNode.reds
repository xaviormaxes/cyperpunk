// StabilizerNode.reds
// Interactive nodes that reduce Blackwall corruption
module BeyondTheWall.Location

import BeyondTheWall.Core.*
import Codeware.*

// Stabilizer node device
public class BlackwallStabilizerNode extends InteractiveDevice {
  private let m_isActive: Bool;
  private let m_corruptionReduction: Float;
  private let m_cooldownDuration: Float;
  private let m_lastUsedTime: Float;
  private let m_usesRemaining: Int32;
  private let m_maxUses: Int32;

  // Initialize stabilizer
  protected cb func OnGameAttach() -> Bool {
    super.OnGameAttach();

    this.m_isActive = true;
    this.m_corruptionReduction = 25.0; // Reduces corruption by 25
    this.m_cooldownDuration = 60.0; // 60 second cooldown per player
    this.m_lastUsedTime = 0.0;
    this.m_usesRemaining = 3; // 3 uses before depleted
    this.m_maxUses = 3;

    this.RefreshUI();
  }

  // Check if can be used
  protected func CanUse() -> Bool {
    if !this.m_isActive {
      return false;
    }

    if this.m_usesRemaining <= 0 {
      return false;
    }

    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
    let timeSinceUse: Float = currentTime - this.m_lastUsedTime;

    return timeSinceUse >= this.m_cooldownDuration;
  }

  // Get interaction text
  protected const func GetInkWidgetTweakDBID() -> TweakDBID {
    return t"DevicesUIDefinitions.GenericDeviceWidget";
  }

  // Use the stabilizer
  public func Use(player: ref<PlayerPuppet>) -> Bool {
    if !this.CanUse() {
      this.ShowCooldownMessage(player);
      return false;
    }

    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if !IsDefined(corruptionSystem) {
      LogChannel(n"BTW", "[StabilizerNode] ERROR: Corruption system not found");
      return false;
    }

    // Reduce corruption
    let currentCorruption: Float = corruptionSystem.GetCorruptionLevel();
    corruptionSystem.RemoveCorruption(this.m_corruptionReduction);
    let newCorruption: Float = corruptionSystem.GetCorruptionLevel();
    let actualReduction: Float = currentCorruption - newCorruption;

    // Update usage
    this.m_usesRemaining -= 1;
    this.m_lastUsedTime = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));

    // Check if depleted
    if this.m_usesRemaining <= 0 {
      this.m_isActive = false;
      this.OnDepleted();
    }

    // Show feedback
    this.ShowUsageMessage(player, actualReduction);
    this.PlayStabilizeEffect();

    LogChannel(n"BTW", s"[StabilizerNode] Used! Reduced corruption by \(actualReduction). Uses remaining: \(this.m_usesRemaining)");

    this.RefreshUI();
    return true;
  }

  // Show usage message
  private func ShowUsageMessage(player: ref<PlayerPuppet>, reductionAmount: Float) -> Void {
    // TODO: Show actual notification in Phase 4
    LogChannel(n"BTW", s"[STABILIZER] Corruption reduced by \(reductionAmount)");
    LogChannel(n"BTW", s"[STABILIZER] Uses remaining: \(this.m_usesRemaining)/\(this.m_maxUses)");
  }

  // Show cooldown message
  private func ShowCooldownMessage(player: ref<PlayerPuppet>) -> Void {
    if this.m_usesRemaining <= 0 {
      LogChannel(n"BTW", "[STABILIZER] Node depleted - no uses remaining");
      return;
    }

    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
    let timeSinceUse: Float = currentTime - this.m_lastUsedTime;
    let timeRemaining: Float = this.m_cooldownDuration - timeSinceUse;

    LogChannel(n"BTW", s"[STABILIZER] Cooldown active - \(timeRemaining)s remaining");
  }

  // Play stabilization effect
  private func PlayStabilizeEffect() -> Void {
    // TODO: Play visual/audio effects in Phase 4
    // - Blue particle effect
    // - Stabilization sound
    // - Screen flash
    LogChannel(n"BTW", "[StabilizerNode] Playing stabilization effect");
  }

  // Called when node is depleted
  private func OnDepleted() -> Void {
    LogChannel(n"BTW", "[StabilizerNode] Node depleted!");
    // TODO: Change visual appearance to show depletion
    // - Dim lights
    // - Sparking effects
    // - Disabled appearance
  }

  // Refresh UI state
  private func RefreshUI() -> Void {
    // Update device state
    let deviceState: EDeviceStatus;

    if this.m_usesRemaining > 0 {
      deviceState = EDeviceStatus.ON;
    } else {
      deviceState = EDeviceStatus.DISABLED;
    }

    // TODO: Update visual state in Phase 4
  }

  // Get remaining cooldown
  public func GetCooldownRemaining() -> Float {
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(this.GetGame()));
    let timeSinceUse: Float = currentTime - this.m_lastUsedTime;
    return MaxF(0.0, this.m_cooldownDuration - timeSinceUse);
  }

  // Get uses remaining
  public func GetUsesRemaining() -> Int32 {
    return this.m_usesRemaining;
  }

  // Recharge node (for testing/admin)
  public func Recharge() -> Void {
    this.m_usesRemaining = this.m_maxUses;
    this.m_isActive = true;
    this.m_lastUsedTime = 0.0;

    LogChannel(n"BTW", "[StabilizerNode] Recharged!");
    this.RefreshUI();
  }
}

// Stabilizer node placement helper
public class StabilizerNodeManager {
  // Predefined stabilizer positions
  // Format: (depth, position, rotation)

  public static func GetStabilizerPositions() -> array<Vector4> {
    let positions: array<Vector4>;

    // Depth 1 - 2 stabilizers
    ArrayPush(positions, new Vector4(-120.0, 60.0, 10.0, 1.0));
    ArrayPush(positions, new Vector4(-130.0, 40.0, 10.0, 1.0));

    // Depth 2 - 2 stabilizers
    ArrayPush(positions, new Vector4(-170.0, 55.0, 10.0, 1.0));
    ArrayPush(positions, new Vector4(-180.0, 45.0, 10.0, 1.0));

    // Depth 3 - 2 stabilizers (more important here)
    ArrayPush(positions, new Vector4(-220.0, 60.0, 5.0, 1.0));
    ArrayPush(positions, new Vector4(-230.0, 40.0, 5.0, 1.0));

    // Depth 4 - 1 stabilizer (rare at this depth)
    ArrayPush(positions, new Vector4(-270.0, 50.0, 0.0, 1.0));

    // Depth 5 - 1 stabilizer (critical placement)
    ArrayPush(positions, new Vector4(-290.0, 50.0, -5.0, 1.0));

    return positions;
  }

  // Spawn stabilizer at position (for testing)
  public static func SpawnStabilizer(position: Vector4) -> Void {
    // TODO: Actual spawning would require entity spawning system
    LogChannel(n"BTW", s"[StabilizerManager] Would spawn stabilizer at position: \(ToString(position))");
  }
}
