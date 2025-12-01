// PossessionAnimations.reds
// Animation system for possession state transitions
module BeyondTheWall.VFX

import BeyondTheWall.AI.*
import BeyondTheWall.Enemies.*

// ==================================================
// POSSESSION ANIMATION SYSTEM
// ==================================================

public class PossessionAnimationSystem extends ScriptableSystem {
  private let m_activeAnimations: array<ref<ActivePossessionAnimation>>;

  private func OnAttach() -> Void {
    ArrayClear(this.m_activeAnimations);

    LogChannel(n"BTW", "[PossessionAnim] Animation system initialized");
  }

  // Play initial possession animation
  public func PlayInitialPossessionAnimation(puppet: ref<ScriptedPuppet>, entityName: String) -> Void {
    LogChannel(n"BTW", s"[PossessionAnim] Playing initial possession for \(entityName)");

    // Create animation data
    let anim: ref<ActivePossessionAnimation> = new ActivePossessionAnimation();
    anim.targetID = puppet.GetEntityID();
    anim.animationType = PossessionAnimationType.InitialPossession;
    anim.startTime = EngineTime.ToFloat(GameInstance.GetSimTime(puppet.GetGame()));
    anim.duration = 2.0;  // 2 second possession sequence

    ArrayPush(this.m_activeAnimations, anim);

    // Phase 1: Enemy staggers (0.0 - 0.5s)
    this.PlayStaggerAnimation(puppet);

    // Phase 2: Digital corruption effect (0.5 - 1.5s)
    GameInstance.GetDelaySystem(puppet.GetGame()).DelayCallback(
      PossessionAnimationCallback.Create(this, puppet, PossessionAnimationPhase.CorruptionEffect),
      0.5
    );

    // Phase 3: Eyes glow, transformation complete (1.5 - 2.0s)
    GameInstance.GetDelaySystem(puppet.GetGame()).DelayCallback(
      PossessionAnimationCallback.Create(this, puppet, PossessionAnimationPhase.TransformationComplete),
      1.5
    );
  }

  // Play state transition animation (Latent -> Active -> Overwhelmed)
  public func PlayStateTransitionAnimation(puppet: ref<ScriptedPuppet>, fromState: PossessionState, toState: PossessionState) -> Void {
    LogChannel(n"BTW", s"[PossessionAnim] State transition from \(EnumInt(fromState)) to \(EnumInt(toState))");

    // Create animation data
    let anim: ref<ActivePossessionAnimation> = new ActivePossessionAnimation();
    anim.targetID = puppet.GetEntityID();
    anim.animationType = PossessionAnimationType.StateTransition;
    anim.startTime = EngineTime.ToFloat(GameInstance.GetSimTime(puppet.GetGame()));
    anim.duration = 1.5;

    ArrayPush(this.m_activeAnimations, anim);

    // Different animations based on transition
    if Equals(fromState, PossessionState.Latent) && Equals(toState, PossessionState.Active) {
      this.PlayLatentToActiveTransition(puppet);
    } else if Equals(fromState, PossessionState.Active) && Equals(toState, PossessionState.Overwhelmed) {
      this.PlayActiveToOverwhelmedTransition(puppet);
    }
  }

  // Play exorcism animation
  public func PlayExorcismAnimation(puppet: ref<ScriptedPuppet>, progress: Float) -> Void {
    // Escalating struggle animation based on progress
    if progress < 0.3 {
      // Early stage: slight twitching
      this.PlayTwitchAnimation(puppet, 0.2);
    } else if progress < 0.7 {
      // Mid stage: noticeable struggling
      this.PlayStruggleAnimation(puppet, 0.5);
    } else {
      // Late stage: violent convulsions
      this.PlayConvulsionAnimation(puppet, 0.8);
    }

    LogChannel(n"BTW", s"[PossessionAnim] Exorcism animation (progress: \(progress))");
  }

  // Play exorcism complete animation
  public func PlayExorcismCompleteAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    LogChannel(n"BTW", "[PossessionAnim] EXORCISM COMPLETE - Final purge animation");

    // Create animation data
    let anim: ref<ActivePossessionAnimation> = new ActivePossessionAnimation();
    anim.targetID = puppet.GetEntityID();
    anim.animationType = PossessionAnimationType.ExorcismComplete;
    anim.startTime = EngineTime.ToFloat(GameInstance.GetSimTime(puppet.GetGame()));
    anim.duration = 3.0;

    ArrayPush(this.m_activeAnimations, anim);

    // Phase 1: Violent expulsion (0.0 - 1.0s)
    this.PlayExpulsionAnimation(puppet);

    // Phase 2: Enemy collapses (1.0 - 2.0s)
    GameInstance.GetDelaySystem(puppet.GetGame()).DelayCallback(
      PossessionAnimationCallback.Create(this, puppet, PossessionAnimationPhase.Collapse),
      1.0
    );

    // Phase 3: Enemy struggles to stand (2.0 - 3.0s)
    GameInstance.GetDelaySystem(puppet.GetGame()).DelayCallback(
      PossessionAnimationCallback.Create(this, puppet, PossessionAnimationPhase.Recovery),
      2.0
    );
  }

  // Play possession break animation (NetWatch Disruptor)
  public func PlayPossessionBreakAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    LogChannel(n"BTW", "[PossessionAnim] Possession break - EMP disruption");

    // Instant jolt animation
    this.PlayEMPJoltAnimation(puppet);

    // Brief stun
    this.ApplyStunEffect(puppet, 2.0);
  }

  // Play AI banishment animation (Oni no Kiru)
  public func PlayBanishmentAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    LogChannel(n"BTW", "[PossessionAnim] AI banishment - Reality tear");

    // Dramatic death animation
    this.PlayBanishmentDeathAnimation(puppet);
  }

  // ============================================
  // ANIMATION IMPLEMENTATIONS
  // ============================================

  // Stagger animation
  private func PlayStaggerAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    if !IsDefined(puppet) {
      return;
    }

    // Use game's stagger/ragdoll impulse system
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(puppet.GetGame());

    // Apply brief knockdown effect to simulate stagger
    statusEffectSystem.ApplyStatusEffect(
      puppet.GetEntityID(),
      t"BaseStatusEffect.Knockdown",
      puppet.GetEntityID(),
      puppet
    );

    LogChannel(n"BTW", "[PossessionAnim] -> Stagger effect applied");
  }

  // Corruption effect animation
  private func PlayCorruptionEffectAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    // TODO: Play corruption spreading animation
    // Digital particles crawl over enemy's body
    let effectsRenderer: ref<PossessionEffectsRenderer> = GetPossessionEffectsRenderer();
    // Play corruption spreading particles

    LogChannel(n"BTW", "[PossessionAnim] -> Corruption spreading");
  }

  // Transformation complete animation
  private func PlayTransformationCompleteAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    // Eyes begin glowing
    let effectsRenderer: ref<PossessionEffectsRenderer> = GetPossessionEffectsRenderer();
    effectsRenderer.ApplyEyeGlow(puppet, PossessionState.Latent);

    // Stand upright with slight digital distortion
    LogChannel(n"BTW", "[PossessionAnim] -> Transformation complete");
  }

  // Latent to Active transition
  private func PlayLatentToActiveTransition(puppet: ref<ScriptedPuppet>) -> Void {
    // Eye glow intensifies
    let effectsRenderer: ref<PossessionEffectsRenderer> = GetPossessionEffectsRenderer();
    effectsRenderer.ApplyEyeGlow(puppet, PossessionState.Active);

    // Aggressive stance shift
    this.PlayStanceShiftAnimation(puppet, n"aggressive");

    // Digital burst effect
    effectsRenderer.ApplyParticleEffect(puppet, PossessionState.Active);

    LogChannel(n"BTW", "[PossessionAnim] -> Latent to Active transition");
  }

  // Active to Overwhelmed transition
  private func PlayActiveToOverwhelmedTransition(puppet: ref<ScriptedPuppet>) -> Void {
    // Maximum eye glow
    let effectsRenderer: ref<PossessionEffectsRenderer> = GetPossessionEffectsRenderer();
    effectsRenderer.ApplyEyeGlow(puppet, PossessionState.Overwhelmed);

    // Corruption aura appears
    effectsRenderer.ApplyCorruptionAura(puppet, 5.0);

    // Twitchy, unstable movement
    this.PlayTwitchAnimation(puppet, 0.5);

    // Heavy particle effects
    effectsRenderer.ApplyParticleEffect(puppet, PossessionState.Overwhelmed);

    // Digital scream
    GameObject.PlaySoundEvent(n"possession_overwhelmed_scream");

    LogChannel(n"BTW", "[PossessionAnim] -> Active to Overwhelmed transition");
  }

  // Twitch animation
  private func PlayTwitchAnimation(puppet: ref<ScriptedPuppet>, intensity: Float) -> Void {
    // TODO: Play twitching animation
    // Erratic head and limb movements
    LogChannel(n"BTW", s"[PossessionAnim] -> Twitch (\(intensity))");
  }

  // Struggle animation
  private func PlayStruggleAnimation(puppet: ref<ScriptedPuppet>, intensity: Float) -> Void {
    // TODO: Play struggling animation
    // Enemy fights against exorcism
    LogChannel(n"BTW", s"[PossessionAnim] -> Struggle (\(intensity))");
  }

  // Convulsion animation
  private func PlayConvulsionAnimation(puppet: ref<ScriptedPuppet>, intensity: Float) -> Void {
    // TODO: Play convulsion animation
    // Violent full-body spasms
    LogChannel(n"BTW", s"[PossessionAnim] -> Convulsion (\(intensity))");
  }

  // Expulsion animation
  private func PlayExpulsionAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    // TODO: Play violent expulsion animation
    // AI entity forcibly ejected from host
    // Bright light burst from eyes and mouth

    let effectsRenderer: ref<PossessionEffectsRenderer> = GetPossessionEffectsRenderer();
    effectsRenderer.PlayExorcismCompleteEffect(puppet);

    LogChannel(n"BTW", "[PossessionAnim] -> AI expulsion");
  }

  // Collapse animation
  private func PlayCollapseAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    // TODO: Play collapse animation
    // Enemy falls to knees, then to ground
    LogChannel(n"BTW", "[PossessionAnim] -> Collapse");
  }

  // Recovery animation
  private func PlayRecoveryAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    // TODO: Play recovery animation
    // Enemy slowly gets back up, disoriented
    LogChannel(n"BTW", "[PossessionAnim] -> Recovery");
  }

  // EMP jolt animation
  private func PlayEMPJoltAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    if !IsDefined(puppet) {
      return;
    }

    // Use game's EMP effect
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(puppet.GetGame());
    statusEffectSystem.ApplyStatusEffect(
      puppet.GetEntityID(),
      t"BaseStatusEffect.EMPShock",
      puppet.GetEntityID(),
      puppet
    );

    // Play electrical VFX using existing game effect
    let effectSystem: ref<EffectSystem> = GameInstance.GetEffectSystem(puppet.GetGame());
    effectSystem.SpawnEffect(n"emp_discharge", puppet, puppet.GetWorldPosition());

    LogChannel(n"BTW", "[PossessionAnim] -> EMP jolt with electrical discharge");
  }

  // Banishment death animation
  private func PlayBanishmentDeathAnimation(puppet: ref<ScriptedPuppet>) -> Void {
    // TODO: Play banishment death animation
    // Enemy dissolves into digital particles, sucked into reality tear
    LogChannel(n"BTW", "[PossessionAnim] -> Banishment death");
  }

  // Stance shift animation
  private func PlayStanceShiftAnimation(puppet: ref<ScriptedPuppet>, stance: CName) -> Void {
    // TODO: Shift combat stance
    LogChannel(n"BTW", s"[PossessionAnim] -> Stance shift to \(ToString(stance))");
  }

  // Apply stun effect
  private func ApplyStunEffect(puppet: ref<ScriptedPuppet>, duration: Float) -> Void {
    if !IsDefined(puppet) {
      return;
    }

    // Apply stun status effect using game's status effect system
    let statusEffectID: TweakDBID = t"BaseStatusEffect.Stunned";
    let statusEffectSystem: ref<StatusEffectSystem> = GameInstance.GetStatusEffectSystem(puppet.GetGame());

    statusEffectSystem.ApplyStatusEffect(
      puppet.GetEntityID(),
      statusEffectID,
      puppet.GetEntityID(),
      puppet
    );

    LogChannel(n"BTW", s"[PossessionAnim] -> Stun applied (\(duration)s)");
  }

  // Execute animation phase callback
  public func ExecuteAnimationPhase(puppet: ref<ScriptedPuppet>, phase: PossessionAnimationPhase) -> Void {
    switch phase {
      case PossessionAnimationPhase.CorruptionEffect:
        this.PlayCorruptionEffectAnimation(puppet);
        break;
      case PossessionAnimationPhase.TransformationComplete:
        this.PlayTransformationCompleteAnimation(puppet);
        break;
      case PossessionAnimationPhase.Collapse:
        this.PlayCollapseAnimation(puppet);
        break;
      case PossessionAnimationPhase.Recovery:
        this.PlayRecoveryAnimation(puppet);
        break;
    }
  }

  // Clean up completed animations
  public func CleanupCompletedAnimations() -> Void {
    let gameInstance: GameInstance = GetGameInstance();
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(gameInstance));

    let i: Int32 = 0;
    while i < ArraySize(this.m_activeAnimations) {
      let anim: ref<ActivePossessionAnimation> = this.m_activeAnimations[i];
      if currentTime - anim.startTime > anim.duration {
        ArrayErase(this.m_activeAnimations, i);
      } else {
        i += 1;
      }
    }
  }
}

// Active possession animation data
public class ActivePossessionAnimation {
  public let targetID: EntityID;
  public let animationType: PossessionAnimationType;
  public let startTime: Float;
  public let duration: Float;
}

// Animation types
public enum PossessionAnimationType {
  InitialPossession = 0,
  StateTransition = 1,
  ExorcismProgress = 2,
  ExorcismComplete = 3,
  PossessionBreak = 4,
  Banishment = 5
}

// Animation phases (for delayed callbacks)
public enum PossessionAnimationPhase {
  CorruptionEffect = 0,
  TransformationComplete = 1,
  Collapse = 2,
  Recovery = 3
}

// Delayed callback for animation phases
public class PossessionAnimationCallback extends DelayCallback {
  private let m_system: wref<PossessionAnimationSystem>;
  private let m_puppet: wref<ScriptedPuppet>;
  private let m_phase: PossessionAnimationPhase;

  public static func Create(system: ref<PossessionAnimationSystem>, puppet: ref<ScriptedPuppet>, phase: PossessionAnimationPhase) -> ref<PossessionAnimationCallback> {
    let callback: ref<PossessionAnimationCallback> = new PossessionAnimationCallback();
    callback.m_system = system;
    callback.m_puppet = puppet;
    callback.m_phase = phase;
    return callback;
  }

  public func Call() -> Void {
    if IsDefined(this.m_system) && IsDefined(this.m_puppet) {
      this.m_system.ExecuteAnimationPhase(this.m_puppet, this.m_phase);
    }
  }
}

// Global accessor
public static func GetPossessionAnimationSystem() -> ref<PossessionAnimationSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.PossessionAnimationSystem") as PossessionAnimationSystem;
}

// ==================================================
// POSSESSION ANIMATION HOOKS
// ==================================================

// NOTE: Animation triggers are now integrated directly into:
// - PossessionSpreadSystem.OnPossessionSpread() - triggers initial possession animations
// - PossessionStateProgressionSystem.OnStateProgression() - triggers state transition animations
//
// This avoids the need for @wrapMethod hooks on private methods
