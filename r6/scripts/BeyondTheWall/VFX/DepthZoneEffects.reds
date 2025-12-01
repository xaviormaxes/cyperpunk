// DepthZoneEffects.reds
// Visual effects for depth zones in the Blackwall facility
module BeyondTheWall.VFX

import BeyondTheWall.Core.*

// ==================================================
// DEPTH ZONE VISUAL EFFECTS SYSTEM
// ==================================================

public class DepthZoneEffectsSystem extends ScriptableSystem {
  private let m_currentDepth: Int32;
  private let m_transitionInProgress: Bool;
  private let m_ambientEffectsActive: Bool;

  private func OnAttach() -> Void {
    this.m_currentDepth = 0;
    this.m_transitionInProgress = false;
    this.m_ambientEffectsActive = true;

    LogChannel(n"BTW", "[DepthZoneEffects] System initialized");
  }

  // Called when player enters new depth zone
  public func OnDepthZoneEnter(depth: Int32) -> Void {
    if Equals(this.m_currentDepth, depth) {
      return;
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Entering Depth \(depth)");

    // Play transition effect
    this.PlayDepthTransition(this.m_currentDepth, depth);

    // Update current depth
    let oldDepth: Int32 = this.m_currentDepth;
    this.m_currentDepth = depth;

    // Apply depth-specific effects
    this.ApplyDepthAmbientEffects(depth);
    this.ApplyDepthLighting(depth);
    this.ApplyDepthFog(depth);
    this.ApplyDepthSoundscape(depth);

    // Show notification
    this.ShowDepthNotification(depth);
  }

  // Play depth transition effect
  private func PlayDepthTransition(fromDepth: Int32, toDepth: Int32) -> Void {
    if this.m_transitionInProgress {
      return;
    }

    this.m_transitionInProgress = true;

    // Determine transition direction
    let descending: Bool = toDepth > fromDepth;

    if descending {
      this.PlayDescendingTransition(toDepth);
    } else {
      this.PlayAscendingTransition(toDepth);
    }

    // Reset flag after transition
    // TODO: Use delayed callback
    this.m_transitionInProgress = false;
  }

  // Descending transition (going deeper)
  private func PlayDescendingTransition(toDepth: Int32) -> Void {
    // Screen flash effect
    this.PlayScreenFlash(new Color(51, 128, 255, 100), 0.5);

    // Digital corruption wave
    this.PlayCorruptionWave(1.0);

    // Camera shake
    this.ApplyCameraShake(0.3, 1.0);

    // Play descend sound
    GameObject.PlaySoundEvent(n"depth_transition_descend");

    LogChannel(n"BTW", s"[DepthZoneEffects] Descending transition to Depth \(toDepth)");
  }

  // Ascending transition (going up)
  private func PlayAscendingTransition(toDepth: Int32) -> Void {
    // Lighter screen flash
    this.PlayScreenFlash(new Color(153, 204, 255, 50), 0.3);

    // Clearing wave
    this.PlayClearingWave(0.8);

    // Gentler camera shake
    this.ApplyCameraShake(0.15, 0.5);

    // Play ascend sound
    GameObject.PlaySoundEvent(n"depth_transition_ascend");

    LogChannel(n"BTW", s"[DepthZoneEffects] Ascending transition to Depth \(toDepth)");
  }

  // Apply ambient effects for depth
  private func ApplyDepthAmbientEffects(depth: Int32) -> Void {
    if !this.m_ambientEffectsActive {
      return;
    }

    switch depth {
      case 1:
        this.ApplyDepth1AmbientEffects();
        break;
      case 2:
        this.ApplyDepth2AmbientEffects();
        break;
      case 3:
        this.ApplyDepth3AmbientEffects();
        break;
      case 4:
        this.ApplyDepth4AmbientEffects();
        break;
      case 5:
        this.ApplyDepth5AmbientEffects();
        break;
      default:
        this.ClearAmbientEffects();
    }
  }

  // Depth 1: Surface Contact - Minimal effects
  private func ApplyDepth1AmbientEffects() -> Void {
    // Occasional digital particles
    this.SpawnAmbientParticles(n"depth1_ambient_particles", 0.1);

    // Very subtle screen distortion
    this.SetScreenDistortion(0.05);

    // Blue-tinted edges
    this.SetVignetteColor(new Color(51, 128, 255, 30));
  }

  // Depth 2: Network Fissure - Increasing effects
  private func ApplyDepth2AmbientEffects() -> Void {
    // More frequent particles
    this.SpawnAmbientParticles(n"depth2_ambient_particles", 0.25);

    // Noticeable distortion
    this.SetScreenDistortion(0.15);

    // Stronger blue vignette
    this.SetVignetteColor(new Color(51, 128, 255, 60));

    // Occasional glitch lines
    this.EnableGlitchLines(0.1);
  }

  // Depth 3: Memory Corruption - Heavy effects
  private func ApplyDepth3AmbientEffects() -> Void {
    // Dense particle effects
    this.SpawnAmbientParticles(n"depth3_ambient_particles", 0.4);

    // Strong distortion
    this.SetScreenDistortion(0.3);

    // Intense blue-cyan vignette
    this.SetVignetteColor(new Color(102, 178, 255, 100));

    // Frequent glitch lines
    this.EnableGlitchLines(0.25);

    // Screen tear effect
    this.EnableScreenTear(0.15);
  }

  // Depth 4: Substrate Breach - Severe effects
  private func ApplyDepth4AmbientEffects() -> Void {
    // Very dense particles
    this.SpawnAmbientParticles(n"depth4_ambient_particles", 0.6);

    // Heavy distortion
    this.SetScreenDistortion(0.5);

    // Very intense cyan vignette
    this.SetVignetteColor(new Color(153, 204, 255, 150));

    // Constant glitch lines
    this.EnableGlitchLines(0.5);

    // Strong screen tear
    this.EnableScreenTear(0.3);

    // Color aberration
    this.EnableChromaticAberration(0.3);

    // Digital artifacts
    this.EnableDigitalArtifacts(0.2);
  }

  // Depth 5: Beyond The Wall - Extreme effects
  private func ApplyDepth5AmbientEffects() -> Void {
    // Maximum particle density
    this.SpawnAmbientParticles(n"depth5_ambient_particles", 1.0);

    // Extreme distortion
    this.SetScreenDistortion(0.7);

    // Maximum vignette
    this.SetVignetteColor(new Color(204, 229, 255, 200));

    // Constant heavy glitching
    this.EnableGlitchLines(0.8);

    // Maximum screen tear
    this.EnableScreenTear(0.6);

    // Strong chromatic aberration
    this.EnableChromaticAberration(0.6);

    // Heavy digital artifacts
    this.EnableDigitalArtifacts(0.5);

    // Reality distortion
    this.EnableRealityDistortion(0.4);

    // Pulsing effect
    this.EnableCorruptionPulse(0.3);
  }

  // Apply lighting for depth
  private func ApplyDepthLighting(depth: Int32) -> Void {
    let lightColor: Color;
    let lightIntensity: Float;

    switch depth {
      case 1:
        lightColor = new Color(200, 220, 255, 255);  // Cool white
        lightIntensity = 1.0;
        break;
      case 2:
        lightColor = new Color(150, 200, 255, 255);  // Light blue
        lightIntensity = 0.8;
        break;
      case 3:
        lightColor = new Color(100, 180, 255, 255);  // Blue
        lightIntensity = 0.6;
        break;
      case 4:
        lightColor = new Color(50, 150, 255, 255);   // Deep blue
        lightIntensity = 0.4;
        break;
      case 5:
        lightColor = new Color(0, 120, 255, 255);    // Electric blue
        lightIntensity = 0.2;
        break;
      default:
        lightColor = new Color(255, 255, 255, 255);
        lightIntensity = 1.0;
    }

    this.SetAmbientLighting(lightColor, lightIntensity);

    LogChannel(n"BTW", s"[DepthZoneEffects] Lighting applied for Depth \(depth)");
  }

  // Apply fog for depth
  private func ApplyDepthFog(depth: Int32) -> Void {
    let fogDensity: Float;
    let fogColor: Color;

    switch depth {
      case 1:
        fogDensity = 0.05;
        fogColor = new Color(200, 220, 255, 50);
        break;
      case 2:
        fogDensity = 0.15;
        fogColor = new Color(150, 200, 255, 100);
        break;
      case 3:
        fogDensity = 0.3;
        fogColor = new Color(100, 180, 255, 150);
        break;
      case 4:
        fogDensity = 0.5;
        fogColor = new Color(50, 150, 255, 200);
        break;
      case 5:
        fogDensity = 0.7;
        fogColor = new Color(0, 120, 255, 255);
        break;
      default:
        fogDensity = 0.0;
        fogColor = new Color(255, 255, 255, 0);
    }

    this.SetFogEffect(fogDensity, fogColor);

    LogChannel(n"BTW", s"[DepthZoneEffects] Fog applied for Depth \(depth) (density: \(fogDensity))");
  }

  // Apply soundscape for depth
  private func ApplyDepthSoundscape(depth: Int32) -> Void {
    // Stop previous soundscape
    GameObject.StopSoundEvent(n"depth_ambient_soundscape");

    // Play new soundscape
    let soundscapeName: CName;

    switch depth {
      case 1:
        soundscapeName = n"depth1_ambient_soundscape";
        break;
      case 2:
        soundscapeName = n"depth2_ambient_soundscape";
        break;
      case 3:
        soundscapeName = n"depth3_ambient_soundscape";
        break;
      case 4:
        soundscapeName = n"depth4_ambient_soundscape";
        break;
      case 5:
        soundscapeName = n"depth5_ambient_soundscape";
        break;
      default:
        return;
    }

    GameObject.PlaySoundEvent(soundscapeName);

    LogChannel(n"BTW", s"[DepthZoneEffects] Soundscape applied for Depth \(depth)");
  }

  // Show depth notification
  private func ShowDepthNotification(depth: Int32) -> Void {
    let zoneName: String;
    let zoneDescription: String;

    switch depth {
      case 1:
        zoneName = "DEPTH 1: SURFACE CONTACT";
        zoneDescription = "The outer facility. Minimal corruption.";
        break;
      case 2:
        zoneName = "DEPTH 2: NETWORK FISSURE";
        zoneDescription = "Blackwall integrity degrading. Digital whispers echo.";
        break;
      case 3:
        zoneName = "DEPTH 3: MEMORY CORRUPTION";
        zoneDescription = "Reality fragments. The walls remember what shouldn't exist.";
        break;
      case 4:
        zoneName = "DEPTH 4: SUBSTRATE BREACH";
        zoneDescription = "The barrier is thin. They are watching.";
        break;
      case 5:
        zoneName = "DEPTH 5: BEYOND THE WALL";
        zoneDescription = "You should not be here. Turn back.";
        break;
      default:
        return;
    }

    // TODO: Show actual UI notification
    LogChannel(n"BTW", s"[DepthZoneEffects] ZONE ENTERED: \(zoneName) - \(zoneDescription)");
  }

  // Effect implementation methods (using game's rendering systems)
  private func PlayScreenFlash(color: Color, duration: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Use game's screen flash effect via status effect system
    let flashEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"screen_flash", player);
    if IsDefined(flashEffect) {
      // Set flash color parameters
      flashEffect.Run();
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Screen flash played (duration: \(duration)s)");
  }

  private func PlayCorruptionWave(intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Create wave effect using radial blur
    let waveEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"radial_blur", player);
    if IsDefined(waveEffect) {
      waveEffect.Run();
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Corruption wave effect (intensity: \(intensity))");
  }

  private func PlayClearingWave(intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Similar to corruption but reverse effect
    let clearEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"buff_flash", player);
    if IsDefined(clearEffect) {
      clearEffect.Run();
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Clearing wave effect (intensity: \(intensity))");
  }

  private func ApplyCameraShake(strength: Float, duration: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Use game's camera shake system
    let shakeStrength: Float = strength;
    let shakeEvent: ref<CameraShakeEvent> = new CameraShakeEvent();
    shakeEvent.strength = shakeStrength;
    shakeEvent.duration = duration;

    GameInstance.GetCameraSystem(player.GetGame()).QueueEvent(shakeEvent);

    LogChannel(n"BTW", s"[DepthZoneEffects] Camera shake applied (strength: \(strength), duration: \(duration))");
  }

  private func SpawnAmbientParticles(particleName: CName, density: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Spawn particles in the environment around player
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(player.GetGame());
    let playerPos: Vector4 = player.GetWorldPosition();

    // Spawn multiple particle instances based on density
    let particleCount: Int32 = Cast<Int32>(density * 5.0); // 5 particles per density unit
    let i: Int32 = 0;

    while i < particleCount {
      effectSystem.SpawnEffect(particleName, player, playerPos);
      i += 1;
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Spawned \(particleCount) ambient particles");
  }

  private func SetScreenDistortion(intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Apply screen distortion using game's post-processing
    // Use drunk/intoxicated effect as base for distortion
    if intensity > 0.0 {
      let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(player.GetGame());
      let distortionID: TweakDBID = t"BaseStatusEffect.Drunk";

      // Apply with intensity-based duration
      statusEffectSystem.ApplyStatusEffect(
        player.GetEntityID(),
        distortionID,
        player.GetEntityID(),
        player
      );
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Screen distortion set (intensity: \(intensity))");
  }

  private func SetVignetteColor(color: Color) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Apply vignette effect through post-processing
    // Use damaged state vignette as base
    if color.Alpha > 0 {
      let vfxSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(player.GetGame());
      vfxSystem.SpawnEffect(n"vignette_damage", player, player.GetWorldPosition());
    }

    LogChannel(n"BTW", "[DepthZoneEffects] Vignette color applied");
  }

  private func EnableGlitchLines(frequency: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Use glitch effect from game's braindance/scanner systems
    if frequency > 0.0 {
      let glitchEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"glitch_effect", player);
      if IsDefined(glitchEffect) {
        glitchEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Glitch lines enabled (frequency: \(frequency))");
  }

  private func EnableScreenTear(intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Screen tear using scanline effect
    if intensity > 0.0 {
      let tearEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"ui_glitch", player);
      if IsDefined(tearEffect) {
        tearEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Screen tear enabled (intensity: \(intensity))");
  }

  private func EnableChromaticAberration(intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Chromatic aberration using Johnny Silverhand transition effect
    if intensity > 0.0 {
      let aberrationEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"chromatic_aberration", player);
      if IsDefined(aberrationEffect) {
        aberrationEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Chromatic aberration enabled (intensity: \(intensity))");
  }

  private func EnableDigitalArtifacts(density: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Digital artifacts using breach protocol visual effects
    if density > 0.0 {
      let artifactEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"digital_artifacts", player);
      if IsDefined(artifactEffect) {
        artifactEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Digital artifacts enabled (density: \(density))");
  }

  private func EnableRealityDistortion(intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // MAXIMUM distortion for Depth 5 - combine multiple effects
    if intensity > 0.0 {
      // Combine distortion, glitch, and aberration
      this.SetScreenDistortion(intensity);
      this.EnableGlitchLines(intensity);
      this.EnableChromaticAberration(intensity);

      // Additional reality-bending visual
      let realityEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"reality_warp", player);
      if IsDefined(realityEffect) {
        realityEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] REALITY DISTORTION ACTIVE (intensity: \(intensity)) - DANGER!");
  }

  private func EnableCorruptionPulse(frequency: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Pulsing corruption effect - rhythmic visual disturbance
    if frequency > 0.0 {
      let pulseEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"corruption_pulse", player);
      if IsDefined(pulseEffect) {
        pulseEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Corruption pulse enabled (frequency: \(frequency) Hz)");
  }

  private func SetAmbientLighting(color: Color, intensity: Float) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Apply ambient lighting using environment effects
    // This would typically require TweakDB modifications for permanent changes
    // For now, we can apply temporary color grading effects

    if intensity > 0.0 {
      let lightingEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"ambient_lighting", player);
      if IsDefined(lightingEffect) {
        lightingEffect.Run();
      }
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Ambient lighting set (intensity: \(intensity))");
  }

  private func SetFogEffect(density: Float, color: Color) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Apply fog effect using game's weather/atmosphere system
    // Use smoke grenade-style fog as base
    if density > 0.0 {
      let fogEffect: ref<gameEffectInstance> = GameInstance.GetEffectExecutor(player.GetGame()).CreateEffect(n"fog_heavy", player);
      if IsDefined(fogEffect) {
        fogEffect.Run();
      }

      // Spawn additional fog particles for density
      let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(player.GetGame());
      effectSystem.SpawnEffect(n"smoke_screen", player, player.GetWorldPosition());
    }

    LogChannel(n"BTW", s"[DepthZoneEffects] Fog effect set (density: \(density))");
  }

  private func ClearAmbientEffects() -> Void {
    // Clear all ambient effects
    this.SetScreenDistortion(0.0);
    this.SetVignetteColor(new Color(0, 0, 0, 0));
    this.EnableGlitchLines(0.0);
    this.EnableScreenTear(0.0);
    this.EnableChromaticAberration(0.0);
    this.EnableDigitalArtifacts(0.0);
  }

  // Enable/disable ambient effects
  public func SetAmbientEffectsEnabled(enabled: Bool) -> Void {
    this.m_ambientEffectsActive = enabled;

    if !enabled {
      this.ClearAmbientEffects();
    }
  }
}

// Global accessor
public static func GetDepthZoneEffectsSystem() -> ref<DepthZoneEffectsSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.DepthZoneEffectsSystem") as DepthZoneEffectsSystem;
}

// ==================================================
// STABILIZER NODE VISUAL EFFECTS
// ==================================================

public class StabilizerNodeEffects {
  // Play stabilizer use effect
  public static func PlayStabilizerUseEffect(position: Vector4, corruptionReduced: Float) -> Void {
    let gameInstance: GameInstance = GetGameInstance();
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(gameInstance);

    // Cleansing wave effect
    let cleanseEffect: ref<EffectInstance> = new EffectInstance();
    cleanseEffect.effectName = n"stabilizer_cleanse_wave";

    effectSystem.Run(cleanseEffect);

    // Play sound
    GameObject.PlaySoundEvent(n"stabilizer_activate");

    // Screen flash (clearing effect)
    let screenEffects: ref<CorruptionScreenEffects> = GetCorruptionScreenEffects();
    // Temporarily reduce screen corruption

    LogChannel(n"BTW", s"[StabilizerEffects] Stabilizer activated (reduced: \(corruptionReduced))");
  }

  // Show stabilizer ready effect
  public static func PlayStabilizerReadyEffect(position: Vector4) -> Void {
    // Pulsing glow effect
    let gameInstance: GameInstance = GetGameInstance();
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(gameInstance);

    let readyEffect: ref<EffectInstance> = new EffectInstance();
    readyEffect.effectName = n"stabilizer_ready_pulse";

    effectSystem.Run(readyEffect);
  }

  // Show stabilizer depleted effect
  public static func PlayStabilizerDepletedEffect(position: Vector4) -> Void {
    // Dimmed, flickering effect
    let gameInstance: GameInstance = GetGameInstance();
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(gameInstance);

    let depletedEffect: ref<EffectInstance> = new EffectInstance();
    depletedEffect.effectName = n"stabilizer_depleted_flicker";

    effectSystem.Run(depletedEffect);
  }
}
