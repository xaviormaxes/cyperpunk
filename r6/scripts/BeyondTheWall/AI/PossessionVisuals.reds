// PossessionVisuals.reds
// Visual effects and indicators for possessed enemies
module BeyondTheWall.AI

import BeyondTheWall.Enemies.*

// ==================================================
// POSSESSION VISUAL EFFECTS MANAGER
// ==================================================

public class PossessionVisualsSystem extends ScriptableSystem {
  private let m_effectsEnabled: Bool;
  private let m_intensity: Float;

  private func OnAttach() -> Void {
    this.m_effectsEnabled = true;
    this.m_intensity = 1.0;

    LogChannel(n"BTW", "[PossessionVisuals] System initialized");
  }

  // Apply visual effects to possessed enemy
  public func ApplyPossessionVisuals(enemy: ref<PossessedEnemy>, state: PossessionState) -> Void {
    if !this.m_effectsEnabled {
      return;
    }

    switch state {
      case PossessionState.Latent:
        this.ApplyLatentVisuals(enemy);
        break;
      case PossessionState.Active:
        this.ApplyActiveVisuals(enemy);
        break;
      case PossessionState.Overwhelmed:
        this.ApplyOverwhelmedVisuals(enemy);
        break;
    }
  }

  // Latent possession visuals
  private func ApplyLatentVisuals(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 4: Implement actual visual effects
    // - Subtle eye glow (blue, 30% intensity)
    // - Faint particle effect around head
    // - Slight screen glitch when looking at them

    LogChannel(n"BTW", "[PossessionVisuals] Latent visuals applied");
  }

  // Active possession visuals
  private func ApplyActiveVisuals(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 4: Implement actual visual effects
    // - Bright eye glow (blue, 70% intensity)
    // - Particle effects around body
    // - Distortion aura
    // - Synchronized movement patterns with other possessed

    LogChannel(n"BTW", "[PossessionVisuals] Active visuals applied");
  }

  // Overwhelmed possession visuals
  private func ApplyOverwhelmedVisuals(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 4: Implement actual visual effects
    // - Intense eye/body glow (blue-white, 100% intensity)
    // - Heavy particle effects (crackling energy)
    // - Corruption aura (damages nearby)
    // - Erratic twitching movements
    // - Screen distortion when near

    LogChannel(n"BTW", "[PossessionVisuals] Overwhelmed visuals applied");
  }

  // Remove possession visuals
  public func RemovePossessionVisuals(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 4: Clear all visual effects

    LogChannel(n"BTW", "[PossessionVisuals] Visuals removed");
  }

  // Play possession spread effect
  public func PlaySpreadEffect(sourcePosition: Vector4, targetPosition: Vector4) -> Void {
    // TODO Phase 4: Implement spread visual
    // - Dark energy stream from source to target
    // - Blue particle trail
    // - Sound effect (digital screech)

    LogChannel(n"BTW", "[PossessionVisuals] Spread effect played");
  }

  // Play exorcism effect
  public func PlayExorcismEffect(target: ref<ScriptedPuppet>, stackProgress: Float) -> Void {
    // TODO Phase 4: Implement exorcism visual
    // - White light particles increasing with stacks
    // - Glowing outline
    // - At completion: Bright expulsion of AI entity

    LogChannel(n"BTW", s"[PossessionVisuals] Exorcism effect (\(stackProgress * 100.0)% progress)");
  }

  // Play possession break effect
  public func PlayPossessionBreakEffect(target: ref<ScriptedPuppet>) -> Void {
    // TODO Phase 4: Implement break visual
    // - Bright flash
    // - AI entity expelled upward
    // - Screen shake
    // - Sound: digital scream

    LogChannel(n"BTW", "[PossessionVisuals] Possession break effect");
  }

  // Play AI banishment effect (from Oni no Kiru critical)
  public func PlayBanishmentEffect(target: ref<ScriptedPuppet>, duration: Float) -> Void {
    // TODO Phase 4: Implement banishment visual
    // - AI entity violently expelled
    // - Reality tear opens briefly
    // - Black tendrils pull entity through
    // - Leaves corruption residue

    LogChannel(n"BTW", s"[PossessionVisuals] Banishment effect (\(duration)s)");
  }

  // Set effects intensity
  public func SetIntensity(intensity: Float) -> Void {
    this.m_intensity = ClampF(intensity, 0.0, 1.0);
  }

  // Enable/disable effects
  public func SetEffectsEnabled(enabled: Bool) -> Void {
    this.m_effectsEnabled = enabled;
  }
}

// Global accessor
public static func GetPossessionVisualsSystem() -> ref<PossessionVisualsSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessionVisualsSystem") as PossessionVisualsSystem;
}

// ==================================================
// POSSESSION UI MARKERS
// ==================================================

public class PossessionUISystem extends ScriptableSystem {
  private let m_showPossessionIndicators: Bool;
  private let m_showExorcismProgress: Bool;

  private func OnAttach() -> Void {
    this.m_showPossessionIndicators = true;
    this.m_showExorcismProgress = true;

    LogChannel(n"BTW", "[PossessionUI] System initialized");
  }

  // Update UI for possessed enemy
  public func UpdateEnemyUI(enemy: ref<PossessedEnemy>) -> Void {
    if !this.m_showPossessionIndicators {
      return;
    }

    let state: PossessionState = enemy.GetPossessionState();
    let aiName: CName = enemy.GetAIEntityName();

    // TODO Phase 3: Implement actual UI markers
    // - Icon above enemy head indicating possession state
    // - Color-coded health bar
    // - AI entity name display
    // - Warning indicator for Overwhelmed state

    LogChannel(n"BTW", s"[PossessionUI] UI updated for \(ToString(state)) enemy");
  }

  // Show exorcism progress bar
  public func ShowExorcismProgress(target: EntityID, stacks: Int32, maxStacks: Int32) -> Void {
    if !this.m_showExorcismProgress {
      return;
    }

    let progress: Float = Cast<Float>(stacks) / Cast<Float>(maxStacks);

    // TODO Phase 3: Implement progress bar
    // - Bar above enemy
    // - Fills from empty to full
    // - Changes color as it fills (blue -> white)
    // - Flashes when complete

    LogChannel(n"BTW", s"[PossessionUI] Exorcism progress: \(stacks)/\(maxStacks) (\(progress * 100.0)%)");
  }

  // Hide exorcism progress
  public func HideExorcismProgress(target: EntityID) -> Void {
    // TODO Phase 3: Remove progress bar

    LogChannel(n"BTW", "[PossessionUI] Exorcism progress hidden");
  }

  // Show possession spread warning
  public func ShowSpreadWarning(position: Vector4, radius: Float) -> Void {
    // TODO Phase 3: Implement warning visual
    // - Pulsing circle on ground showing spread radius
    // - Warning icon
    // - Red tint

    LogChannel(n"BTW", s"[PossessionUI] Spread warning at radius \(radius)m");
  }

  // Show Neural Scramble indicator
  public func ShowNeuralScrambleIndicator(target: EntityID, timeRemaining: Float) -> Void {
    // TODO Phase 3: Implement debuff indicator
    // - Icon above enemy
    // - Timer countdown
    // - Shield effect (prevents spread)

    LogChannel(n"BTW", s"[PossessionUI] Neural Scramble active (\(timeRemaining)s remaining)");
  }

  // Configure UI visibility
  public func SetShowPossessionIndicators(show: Bool) -> Void {
    this.m_showPossessionIndicators = show;
  }

  public func SetShowExorcismProgress(show: Bool) -> Void {
    this.m_showExorcismProgress = show;
  }
}

// Global accessor
public static func GetPossessionUISystem() -> ref<PossessionUISystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessionUISystem") as PossessionUISystem;
}

// ==================================================
// POSSESSION SCANNER INTEGRATION
// ==================================================

// Extension to scanner to show possession information
@addMethod(ScannerBlackboardDef)
public func GetPossessionState(target: EntityID) -> PossessionState {
  // TODO Phase 3: Actually check target's possession state
  // For now, return None
  return PossessionState.None;
}

@addMethod(ScannerBlackboardDef)
public func GetAIEntityName(target: EntityID) -> CName {
  // TODO Phase 3: Get AI entity name from target
  return n"Unknown";
}

@addMethod(ScannerBlackboardDef)
public func GetExorcismStacks(target: EntityID) -> Int32 {
  let tracker: ref<ExorcismStackTracker> = GetExorcismStackTracker();
  if IsDefined(tracker) {
    return tracker.GetStacks(target);
  }
  return 0;
}

// ==================================================
// POSSESSION VISUAL EFFECT PRESETS
// ==================================================

public class PossessionVisualPresets {
  // Get eye glow color for possession state
  public static func GetEyeGlowColor(state: PossessionState) -> Color {
    switch state {
      case PossessionState.Latent:
        return new Color(51, 128, 255, 77);    // Blue, 30% opacity
      case PossessionState.Active:
        return new Color(102, 178, 255, 179);  // Bright blue, 70% opacity
      case PossessionState.Overwhelmed:
        return new Color(153, 204, 255, 255);  // Blue-white, 100% opacity
      default:
        return new Color(0, 0, 0, 0);          // Transparent
    }
  }

  // Get glow intensity
  public static func GetGlowIntensity(state: PossessionState) -> Float {
    switch state {
      case PossessionState.Latent:
        return 0.3;
      case PossessionState.Active:
        return 0.7;
      case PossessionState.Overwhelmed:
        return 1.0;
      default:
        return 0.0;
    }
  }

  // Get particle effect name
  public static func GetParticleEffect(state: PossessionState) -> CName {
    switch state {
      case PossessionState.Latent:
        return n"possession_latent_particles";
      case PossessionState.Active:
        return n"possession_active_particles";
      case PossessionState.Overwhelmed:
        return n"possession_overwhelmed_particles";
      default:
        return n"";
    }
  }

  // Get aura radius (for Overwhelmed)
  public static func GetAuraRadius(state: PossessionState) -> Float {
    switch state {
      case PossessionState.Overwhelmed:
        return 3.0;  // 3m corruption aura
      default:
        return 0.0;
    }
  }

  // Get UI marker color
  public static func GetUIMarkerColor(state: PossessionState) -> Color {
    switch state {
      case PossessionState.Latent:
        return new Color(100, 150, 255, 255);  // Light blue
      case PossessionState.Active:
        return new Color(0, 100, 255, 255);    // Blue
      case PossessionState.Overwhelmed:
        return new Color(255, 50, 50, 255);    // Red (danger)
      default:
        return new Color(255, 255, 255, 255);  // White
    }
  }
}
