// PossessionEffects.reds
// Actual visual effect implementations for possession system
module BeyondTheWall.VFX

import BeyondTheWall.AI.*
import BeyondTheWall.Enemies.*

// ==================================================
// POSSESSION VISUAL EFFECTS RENDERER
// ==================================================

public class PossessionEffectsRenderer extends ScriptableSystem {
  private let m_activeEffects: array<ref<ActivePossessionEffect>>;
  private let m_particleEffects: array<CName>;

  private func OnAttach() -> Void {
    ArrayClear(this.m_activeEffects);
    this.InitializeParticleEffects();

    LogChannel(n"BTW", "[PossessionEffects] Renderer initialized");
  }

  // Initialize particle effect names
  private func InitializeParticleEffects() -> Void {
    ArrayClear(this.m_particleEffects);

    // Possession state particles
    ArrayPush(this.m_particleEffects, n"possession_latent_particles");
    ArrayPush(this.m_particleEffects, n"possession_active_particles");
    ArrayPush(this.m_particleEffects, n"possession_overwhelmed_particles");

    // Special effect particles
    ArrayPush(this.m_particleEffects, n"possession_spread_trail");
    ArrayPush(this.m_particleEffects, n"exorcism_purge_effect");
    ArrayPush(this.m_particleEffects, n"possession_break_flash");
    ArrayPush(this.m_particleEffects, n"banishment_rift_effect");
  }

  // Apply eye glow effect to possessed enemy
  public func ApplyEyeGlow(puppet: ref<ScriptedPuppet>, state: PossessionState) -> Void {
    let color: Color = PossessionVisualPresets.GetEyeGlowColor(state);
    let intensity: Float = PossessionVisualPresets.GetGlowIntensity(state);

    // Create eye glow effect data
    let glowEffect: ref<EffectInstance> = this.CreateEyeGlowEffect(puppet, color, intensity);

    if IsDefined(glowEffect) {
      GameInstance.GetEffectSystem(puppet.GetGame()).Run(glowEffect);
      LogChannel(n"BTW", s"[PossessionEffects] Eye glow applied (intensity: \(intensity))");
    }
  }

  // Remove eye glow effect
  public func RemoveEyeGlow(puppet: ref<ScriptedPuppet>) -> Void {
    // Stop all eye glow effects on puppet
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());
    effectSystem.BreakEffectLoopOnEntity(puppet, n"possession_eye_glow");

    LogChannel(n"BTW", "[PossessionEffects] Eye glow removed");
  }

  // Create eye glow effect instance
  private func CreateEyeGlowEffect(puppet: ref<ScriptedPuppet>, color: Color, intensity: Float) -> ref<EffectInstance> {
    let effect: ref<EffectInstance> = new EffectInstance();
    effect.effectName = n"possession_eye_glow";
    effect.owner = puppet;

    // Set effect parameters
    let colorParam: ref<EffectParameter_Color> = new EffectParameter_Color();
    colorParam.name = n"glowColor";
    colorParam.value = color;

    let intensityParam: ref<EffectParameter_Float> = new EffectParameter_Float();
    intensityParam.name = n"glowIntensity";
    intensityParam.value = intensity;

    return effect;
  }

  // Apply particle effects for possession state
  public func ApplyParticleEffect(puppet: ref<ScriptedPuppet>, state: PossessionState) -> Void {
    let particleName: CName = PossessionVisualPresets.GetParticleEffect(state);

    if !IsNameValid(particleName) {
      return;
    }

    // Spawn particle effect on puppet
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());
    let effectTransform: WorldTransform;
    WorldTransform.SetWorldPosition(effectTransform, puppet.GetWorldPosition());

    effectSystem.SpawnEffect(particleName, puppet, effectTransform);

    LogChannel(n"BTW", s"[PossessionEffects] Particle effect spawned: \(ToString(particleName))");
  }

  // Remove particle effects
  public func RemoveParticleEffect(puppet: ref<ScriptedPuppet>) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());

    // Stop all possession particle effects
    let i: Int32 = 0;
    while i < ArraySize(this.m_particleEffects) {
      effectSystem.BreakEffectLoopOnEntity(puppet, this.m_particleEffects[i]);
      i += 1;
    }

    LogChannel(n"BTW", "[PossessionEffects] Particle effects removed");
  }

  // Apply corruption aura (Overwhelmed state)
  public func ApplyCorruptionAura(puppet: ref<ScriptedPuppet>, radius: Float) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());

    // Create aura effect
    let auraEffect: ref<EffectInstance> = new EffectInstance();
    auraEffect.effectName = n"possession_corruption_aura";
    auraEffect.owner = puppet;

    let radiusParam: ref<EffectParameter_Float> = new EffectParameter_Float();
    radiusParam.name = n"auraRadius";
    radiusParam.value = radius;

    effectSystem.Run(auraEffect);

    LogChannel(n"BTW", s"[PossessionEffects] Corruption aura applied (radius: \(radius)m)");
  }

  // Remove corruption aura
  public func RemoveCorruptionAura(puppet: ref<ScriptedPuppet>) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());
    effectSystem.BreakEffectLoopOnEntity(puppet, n"possession_corruption_aura");

    LogChannel(n"BTW", "[PossessionEffects] Corruption aura removed");
  }

  // Play possession spread effect
  public func PlaySpreadEffect(sourcePos: Vector4, targetPos: Vector4) -> Void {
    let gameInstance: GameInstance = GetGameInstance();
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(gameInstance);

    // Create spread trail effect
    let spreadEffect: ref<EffectInstance> = new EffectInstance();
    spreadEffect.effectName = n"possession_spread_trail";

    // Set source and target positions
    let sourceParam: ref<EffectParameter_Vector> = new EffectParameter_Vector();
    sourceParam.name = n"sourcePosition";
    sourceParam.value = sourcePos;

    let targetParam: ref<EffectParameter_Vector> = new EffectParameter_Vector();
    targetParam.name = n"targetPosition";
    targetParam.value = targetPos;

    effectSystem.Run(spreadEffect);

    // Play spread sound
    this.PlaySpreadSound(sourcePos);

    LogChannel(n"BTW", "[PossessionEffects] Spread effect played");
  }

  // Play exorcism effect
  public func PlayExorcismEffect(puppet: ref<ScriptedPuppet>, progress: Float) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());

    // Create exorcism effect with progress
    let exorcismEffect: ref<EffectInstance> = new EffectInstance();
    exorcismEffect.effectName = n"exorcism_purge_effect";
    exorcismEffect.owner = puppet;

    let progressParam: ref<EffectParameter_Float> = new EffectParameter_Float();
    progressParam.name = n"exorcismProgress";
    progressParam.value = progress;

    effectSystem.Run(exorcismEffect);

    // At completion, play dramatic effect
    if progress >= 1.0 {
      this.PlayExorcismCompleteEffect(puppet);
    }
  }

  // Play exorcism complete effect
  private func PlayExorcismCompleteEffect(puppet: ref<ScriptedPuppet>) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());

    // Bright expulsion effect
    let completeEffect: ref<EffectInstance> = new EffectInstance();
    completeEffect.effectName = n"exorcism_complete_burst";
    completeEffect.owner = puppet;

    effectSystem.Run(completeEffect);

    // Play exorcism complete sound
    this.PlayExorcismCompleteSound(puppet.GetWorldPosition());

    LogChannel(n"BTW", "[PossessionEffects] EXORCISM COMPLETE effect played");
  }

  // Play possession break effect
  public func PlayPossessionBreakEffect(puppet: ref<ScriptedPuppet>) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());

    // Flash effect
    let breakEffect: ref<EffectInstance> = new EffectInstance();
    breakEffect.effectName = n"possession_break_flash";
    breakEffect.owner = puppet;

    effectSystem.Run(breakEffect);

    // Camera shake
    this.ApplyCameraShake(puppet.GetWorldPosition(), 5.0, 0.3);

    // Play break sound
    this.PlayPossessionBreakSound(puppet.GetWorldPosition());

    LogChannel(n"BTW", "[PossessionEffects] Possession break effect played");
  }

  // Play AI banishment effect (Oni no Kiru)
  public func PlayBanishmentEffect(puppet: ref<ScriptedPuppet>, duration: Float) -> Void {
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());

    // Reality tear effect
    let banishEffect: ref<EffectInstance> = new EffectInstance();
    banishEffect.effectName = n"banishment_rift_effect";
    banishEffect.owner = puppet;

    let durationParam: ref<EffectParameter_Float> = new EffectParameter_Float();
    durationParam.name = n"effectDuration";
    durationParam.value = duration;

    effectSystem.Run(banishEffect);

    // Play banishment sound
    this.PlayBanishmentSound(puppet.GetWorldPosition());

    LogChannel(n"BTW", s"[PossessionEffects] Banishment effect played (duration: \(duration)s)");
  }

  // Apply camera shake
  private func ApplyCameraShake(position: Vector4, radius: Float, strength: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Check if player is within shake radius
    let playerPos: Vector4 = player.GetWorldPosition();
    let distance: Float = Vector4.Distance(playerPos, position);

    if distance <= radius {
      // Apply camera shake with falloff based on distance
      let distanceFactor: Float = 1.0 - (distance / radius);
      let effectiveStrength: Float = strength * distanceFactor;

      // Create and queue camera shake event
      let shakeEvent: ref<CameraShakeEvent> = new CameraShakeEvent();
      shakeEvent.strength = effectiveStrength;
      shakeEvent.duration = 0.5; // Half second shake

      GameInstance.GetCameraSystem(player.GetGame()).QueueEvent(shakeEvent);

      LogChannel(n"BTW", s"[PossessionEffects] Camera shake applied (strength: \(effectiveStrength), distance: \(distance)m)");
    }
  }

  // Sound effect methods (placeholders for actual audio implementation)
  private func PlaySpreadSound(position: Vector4) -> Void {
    // Play digital screech sound
    GameObject.PlaySoundEvent(n"possession_spread_screech");
  }

  private func PlayExorcismCompleteSound(position: Vector4) -> Void {
    // Play purge completion sound
    GameObject.PlaySoundEvent(n"exorcism_complete_chime");
  }

  private func PlayPossessionBreakSound(position: Vector4) -> Void {
    // Play digital scream
    GameObject.PlaySoundEvent(n"possession_break_scream");
  }

  private func PlayBanishmentSound(position: Vector4) -> Void {
    // Play reality tear sound
    GameObject.PlaySoundEvent(n"banishment_reality_tear");
  }
}

// Active possession effect tracker
public class ActivePossessionEffect {
  public let targetID: EntityID;
  public let effectName: CName;
  public let startTime: Float;
  public let duration: Float;
}

// Effect parameter types
public class EffectParameter_Color {
  public let name: CName;
  public let value: Color;
}

public class EffectParameter_Float {
  public let name: CName;
  public let value: Float;
}

public class EffectParameter_Vector {
  public let name: CName;
  public let value: Vector4;
}

// Global accessor
public static func GetPossessionEffectsRenderer() -> ref<PossessionEffectsRenderer> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.PossessionEffectsRenderer") as PossessionEffectsRenderer;
}

// ==================================================
// CORRUPTION SCREEN EFFECTS
// ==================================================

public class CorruptionScreenEffects extends ScriptableSystem {
  private let m_currentIntensity: Float;
  private let m_effectsEnabled: Bool;

  private func OnAttach() -> Void {
    this.m_currentIntensity = 0.0;
    this.m_effectsEnabled = true;

    LogChannel(n"BTW", "[CorruptionScreen] System initialized");
  }

  // Update screen effects based on corruption level
  public func UpdateScreenEffects(corruptionLevel: Float) -> Void {
    if !this.m_effectsEnabled {
      return;
    }

    // Calculate intensity (0-100 corruption -> 0.0-1.0 intensity)
    let targetIntensity: Float = corruptionLevel / 100.0;

    // Smooth transition
    this.m_currentIntensity = LerpF(this.m_currentIntensity, targetIntensity, 0.1);

    // Apply effects based on corruption tier
    if corruptionLevel < 20.0 {
      this.ApplyMinimalEffects();
    } else if corruptionLevel < 40.0 {
      this.ApplyLowEffects();
    } else if corruptionLevel < 60.0 {
      this.ApplyModerateEffects();
    } else if corruptionLevel < 80.0 {
      this.ApplyHighEffects();
    } else {
      this.ApplyCriticalEffects();
    }
  }

  // Minimal corruption effects (0-20%)
  private func ApplyMinimalEffects() -> Void {
    // Occasional screen glitch
    if RandRangeF(0.0, 1.0) < 0.01 {
      this.TriggerScreenGlitch(0.1);
    }
  }

  // Low corruption effects (20-40%)
  private func ApplyLowEffects() -> Void {
    // More frequent glitches, slight color shift
    if RandRangeF(0.0, 1.0) < 0.02 {
      this.TriggerScreenGlitch(0.2);
    }
    this.ApplyColorGrading(0.1);
  }

  // Moderate corruption effects (40-60%)
  private func ApplyModerateEffects() -> Void {
    // Frequent glitches, noticeable distortion
    if RandRangeF(0.0, 1.0) < 0.05 {
      this.TriggerScreenGlitch(0.3);
    }
    this.ApplyColorGrading(0.3);
    this.ApplyDistortion(0.2);
  }

  // High corruption effects (60-80%)
  private func ApplyHighEffects() -> Void {
    // Very frequent glitches, heavy distortion
    if RandRangeF(0.0, 1.0) < 0.08 {
      this.TriggerScreenGlitch(0.5);
    }
    this.ApplyColorGrading(0.5);
    this.ApplyDistortion(0.4);
    this.ApplyVignette(0.3);
  }

  // Critical corruption effects (80-100%)
  private func ApplyCriticalEffects() -> Void {
    // Constant glitching, extreme distortion
    if RandRangeF(0.0, 1.0) < 0.15 {
      this.TriggerScreenGlitch(0.8);
    }
    this.ApplyColorGrading(0.7);
    this.ApplyDistortion(0.6);
    this.ApplyVignette(0.5);
    this.ApplyScanlines(0.3);
  }

  // Trigger screen glitch effect
  private func TriggerScreenGlitch(intensity: Float) -> Void {
    // TODO: Implement actual glitch shader
    LogChannel(n"BTW", s"[CorruptionScreen] Screen glitch (intensity: \(intensity))");
  }

  // Apply color grading shift (blue tint)
  private func ApplyColorGrading(intensity: Float) -> Void {
    // TODO: Implement color grading
    // Blue-cyan tint increasing with intensity
  }

  // Apply screen distortion
  private func ApplyDistortion(intensity: Float) -> Void {
    // TODO: Implement distortion shader
    // Wave/ripple effect
  }

  // Apply vignette effect
  private func ApplyVignette(intensity: Float) -> Void {
    // TODO: Implement vignette
    // Dark edges closing in
  }

  // Apply scanline effect
  private func ApplyScanlines(intensity: Float) -> Void {
    // TODO: Implement scanlines
    // Horizontal scan lines like old CRT
  }

  // Clear all corruption effects
  public func ClearEffects() -> Void {
    this.m_currentIntensity = 0.0;
    // TODO: Clear all shader effects
    LogChannel(n"BTW", "[CorruptionScreen] Effects cleared");
  }

  // Enable/disable effects
  public func SetEffectsEnabled(enabled: Bool) -> Void {
    this.m_effectsEnabled = enabled;
  }
}

// Global accessor
public static func GetCorruptionScreenEffects() -> ref<CorruptionScreenEffects> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.CorruptionScreenEffects") as CorruptionScreenEffects;
}
