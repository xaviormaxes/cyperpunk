// AudioManager.reds
// Audio management system for Beyond the Wall
module BeyondTheWall.VFX

import BeyondTheWall.Core.*
import BeyondTheWall.AI.*

// ==================================================
// AUDIO MANAGER SYSTEM
// ==================================================

public class BTWAudioManager extends ScriptableSystem {
  private let m_activeSoundscapes: array<CName>;
  private let m_soundEnabled: Bool;
  private let m_masterVolume: Float;
  private let m_currentDepthSoundscape: CName;

  private func OnAttach() -> Void {
    ArrayClear(this.m_activeSoundscapes);
    this.m_soundEnabled = true;
    this.m_masterVolume = 1.0;
    this.m_currentDepthSoundscape = n"";

    // Load audio bank
    this.LoadAudioBank();

    LogChannel(n"BTW", "[AudioManager] Audio system initialized");
  }

  // Load the Beyond the Wall audio bank
  private func LoadAudioBank() -> Void {
    // TODO: Load actual audio bank
    // Would use game's audio system to load "beyond_the_wall" bank
    LogChannel(n"BTW", "[AudioManager] Audio bank loaded");
  }

  // ==================================================
  // POSSESSION SOUNDS
  // ==================================================

  public func PlayPossessionSpread(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"possession_spread_screech", position, this.m_masterVolume * 0.8);
    LogChannel(n"BTW", "[AudioManager] Playing possession spread sound");
  }

  public func PlayExorcismComplete(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"exorcism_complete_chime", position, this.m_masterVolume * 0.9);
    LogChannel(n"BTW", "[AudioManager] Playing exorcism complete sound");
  }

  public func PlayPossessionBreak(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"possession_break_scream", position, this.m_masterVolume * 0.85);
    LogChannel(n"BTW", "[AudioManager] Playing possession break sound");
  }

  public func PlayBanishment(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"banishment_reality_tear", position, this.m_masterVolume * 0.9);
    LogChannel(n"BTW", "[AudioManager] Playing banishment sound");
  }

  public func PlayPossessionOverwhelmed(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"possession_overwhelmed_scream", position, this.m_masterVolume * 0.95);
    LogChannel(n"BTW", "[AudioManager] Playing overwhelmed scream");
  }

  // ==================================================
  // DEPTH ZONE SOUNDS
  // ==================================================

  public func PlayDepthTransition(descending: Bool, position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    let soundName: CName = descending ? n"depth_transition_descend" : n"depth_transition_ascend";
    let volume: Float = descending ? 0.8 : 0.7;

    this.PlaySoundAtPosition(soundName, position, this.m_masterVolume * volume);
    LogChannel(n"BTW", s"[AudioManager] Playing depth transition (\(descending ? "descend" : "ascend"))");
  }

  public func StartDepthSoundscape(depth: Int32) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    // Stop current soundscape
    this.StopDepthSoundscape();

    // Determine soundscape name
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

    // Play looping soundscape
    GameObject.PlaySoundEvent(soundscapeName);
    this.m_currentDepthSoundscape = soundscapeName;
    ArrayPush(this.m_activeSoundscapes, soundscapeName);

    LogChannel(n"BTW", s"[AudioManager] Started depth \(depth) soundscape");
  }

  public func StopDepthSoundscape() -> Void {
    if !IsNameValid(this.m_currentDepthSoundscape) {
      return;
    }

    GameObject.StopSoundEvent(this.m_currentDepthSoundscape);
    ArrayRemove(this.m_activeSoundscapes, this.m_currentDepthSoundscape);
    this.m_currentDepthSoundscape = n"";

    LogChannel(n"BTW", "[AudioManager] Stopped depth soundscape");
  }

  // ==================================================
  // STABILIZER SOUNDS
  // ==================================================

  public func PlayStabilizerActivate(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"stabilizer_activate", position, this.m_masterVolume * 0.75);
    LogChannel(n"BTW", "[AudioManager] Playing stabilizer activate");
  }

  // ==================================================
  // WEAPON SOUNDS
  // ==================================================

  public func PlayRABIDSFire(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"rabids_remnant_fire", position, this.m_masterVolume * 0.8);
  }

  public func PlayNeuralScrambleProc(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"rabids_neural_scramble_proc", position, this.m_masterVolume * 0.7);
    LogChannel(n"BTW", "[AudioManager] Neural Scramble proc sound");
  }

  public func PlayNetWatchEMP(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"netwatch_disruptor_emp", position, this.m_masterVolume * 0.9);
    LogChannel(n"BTW", "[AudioManager] NetWatch EMP sound");
  }

  public func PlayOniSwing(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"oni_no_kiru_swing", position, this.m_masterVolume * 0.75);
  }

  public func PlayOniBanish(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"oni_no_kiru_banish", position, this.m_masterVolume * 0.85);
    LogChannel(n"BTW", "[AudioManager] Oni no Kiru banishment sound");
  }

  public func PlayExorcistStack(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"digital_exorcist_stack", position, this.m_masterVolume * 0.6);
  }

  public func PlayErebusQuickhack(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"erebus_quickhack_deploy", position, this.m_masterVolume * 0.7);
  }

  // ==================================================
  // QUICKHACK SOUNDS
  // ==================================================

  public func PlayQuickhackSound(quickhackName: CName, position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    let soundName: CName;

    if Equals(quickhackName, n"BlackwallTrace") {
      soundName = n"blackwall_trace_cast";
    } else if Equals(quickhackName, n"NeuralHijack") {
      soundName = n"neural_hijack_cast";
    } else if Equals(quickhackName, n"CascadeProtocol") {
      soundName = n"cascade_protocol_cast";
    } else if Equals(quickhackName, n"SummonDaemon") {
      soundName = n"summon_daemon_cast";
    } else if Equals(quickhackName, n"BlackwallOverload") {
      soundName = n"blackwall_overload_cast";
    } else if Equals(quickhackName, n"Stabilize") {
      soundName = n"stabilize_cast";
    } else {
      return;
    }

    this.PlaySoundAtPosition(soundName, position, this.m_masterVolume * 0.75);
    LogChannel(n"BTW", s"[AudioManager] Playing quickhack sound: \(ToString(quickhackName))");
  }

  // ==================================================
  // ENEMY SOUNDS
  // ==================================================

  public func PlayDigitalConstructMove(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"digital_construct_move", position, this.m_masterVolume * 0.5);
  }

  public func PlayCerberusAlert(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"cerberus_alert", position, this.m_masterVolume * 0.8);
    LogChannel(n"BTW", "[AudioManager] Cerberus alert sound");
  }

  public func PlayBossChenDialogue(position: Vector4) -> Void {
    if !this.m_soundEnabled {
      return;
    }

    this.PlaySoundAtPosition(n"boss_chen_dialogue_corrupted", position, this.m_masterVolume * 0.85);
    LogChannel(n"BTW", "[AudioManager] Dr. Chen corrupted dialogue");
  }

  public func StartBossErebusPresence() -> Void {
    if !this.m_soundEnabled {
      return;
    }

    GameObject.PlaySoundEvent(n"boss_erebus_presence");
    ArrayPush(this.m_activeSoundscapes, n"boss_erebus_presence");

    LogChannel(n"BTW", "[AudioManager] EREBUS BOSS PRESENCE STARTED");
  }

  public func StopBossErebusPresence() -> Void {
    GameObject.StopSoundEvent(n"boss_erebus_presence");
    ArrayRemove(this.m_activeSoundscapes, n"boss_erebus_presence");

    LogChannel(n"BTW", "[AudioManager] Erebus boss presence stopped");
  }

  // ==================================================
  // UI SOUNDS
  // ==================================================

  public func PlayCorruptionWarning() -> Void {
    if !this.m_soundEnabled {
      return;
    }

    GameObject.PlaySoundEvent(n"corruption_tier_warning");
    LogChannel(n"BTW", "[AudioManager] Corruption warning sound");
  }

  public func PlayMasteryLevelUp() -> Void {
    if !this.m_soundEnabled {
      return;
    }

    GameObject.PlaySoundEvent(n"mastery_levelup");
    LogChannel(n"BTW", "[AudioManager] Mastery level up sound");
  }

  public func PlayDepthUnlocked() -> Void {
    if !this.m_soundEnabled {
      return;
    }

    GameObject.PlaySoundEvent(n"depth_unlocked");
    LogChannel(n"BTW", "[AudioManager] Depth unlocked sound");
  }

  public func PlayExorcismStackAdded() -> Void {
    if !this.m_soundEnabled {
      return;
    }

    GameObject.PlaySoundEvent(n"exorcism_stack_added");
  }

  // ==================================================
  // UTILITY METHODS
  // ==================================================

  // Play sound at world position
  private func PlaySoundAtPosition(soundName: CName, position: Vector4, volume: Float) -> Void {
    // TODO: Implement positional audio
    // Would create audio emitter at position with specified volume
    GameObject.PlaySoundEvent(soundName);
  }

  // Set master volume
  public func SetMasterVolume(volume: Float) -> Void {
    this.m_masterVolume = ClampF(volume, 0.0, 1.0);
    LogChannel(n"BTW", s"[AudioManager] Master volume set to \(this.m_masterVolume)");
  }

  // Enable/disable all BTW sounds
  public func SetSoundEnabled(enabled: Bool) -> Void {
    this.m_soundEnabled = enabled;

    if !enabled {
      this.StopAllActiveSounds();
    }

    LogChannel(n"BTW", s"[AudioManager] Sound \(enabled ? "enabled" : "disabled")");
  }

  // Stop all active looping sounds
  public func StopAllActiveSounds() -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_activeSoundscapes) {
      GameObject.StopSoundEvent(this.m_activeSoundscapes[i]);
      i += 1;
    }

    ArrayClear(this.m_activeSoundscapes);

    LogChannel(n"BTW", "[AudioManager] All active sounds stopped");
  }
}

// Global accessor
public static func GetBTWAudioManager() -> ref<BTWAudioManager> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.BTWAudioManager") as BTWAudioManager;
}

// ==================================================
// AUDIO INTEGRATION HOOKS
// ==================================================

// Hook into corruption system to play warning sounds
@wrapMethod(BeyondTheWall.Core.CorruptionSystem)
public func AddCorruption(amount: Float, mastery: Float) -> Void {
  let oldTier: Int32 = this.GetTier();

  wrappedMethod(amount, mastery);

  let newTier: Int32 = this.GetTier();

  // Play warning if tier increased
  if newTier > oldTier {
    let audioManager: ref<BTWAudioManager> = GetBTWAudioManager();
    audioManager.PlayCorruptionWarning();
  }
}

// Hook into mastery system to play level up sound
@wrapMethod(BeyondTheWall.Core.MasterySystem)
public func AddExperience(amount: Float) -> Void {
  let oldLevel: Int32 = this.GetLevel();

  wrappedMethod(amount);

  let newLevel: Int32 = this.GetLevel();

  // Play level up sound if leveled
  if newLevel > oldLevel {
    let audioManager: ref<BTWAudioManager> = GetBTWAudioManager();
    audioManager.PlayMasteryLevelUp();

    // Also play depth unlock if applicable
    audioManager.PlayDepthUnlocked();
  }
}

// Hook into depth progression to play soundscapes
@wrapMethod(BeyondTheWall.Core.DepthProgressionSystem)
public func UpdatePlayerDepth(player: ref<PlayerPuppet>) -> Void {
  let oldDepth: Int32 = this.m_currentDepth;

  wrappedMethod(player);

  let newDepth: Int32 = this.m_currentDepth;

  // If depth changed, update soundscape
  if NotEquals(oldDepth, newDepth) {
    let audioManager: ref<BTWAudioManager> = GetBTWAudioManager();

    // Play transition sound
    let descending: Bool = newDepth > oldDepth;
    audioManager.PlayDepthTransition(descending, player.GetWorldPosition());

    // Start new soundscape
    audioManager.StartDepthSoundscape(newDepth);
  }
}

// Hook into possession spread to play sounds
@wrapMethod(BeyondTheWall.AI.PossessionSpreadSystem)
public func OnPossessedEnemyDeath(deadEnemy: ref<PossessedEnemy>, killerPosition: Vector4) -> Void {
  // Get death position before calling wrapped method
  let deathPosition: Vector4 = deadEnemy.GetPosition();

  wrappedMethod(deadEnemy, killerPosition);

  // Play spread sound
  let audioManager: ref<BTWAudioManager> = GetBTWAudioManager();
  audioManager.PlayPossessionSpread(deathPosition);
}

// Hook into exorcism to play stack sounds
@wrapMethod(BeyondTheWall.AI.ExorcismStackTracker)
public func AddStack(targetID: EntityID) -> Void {
  wrappedMethod(targetID);

  // Play stack added sound
  let audioManager: ref<BTWAudioManager> = GetBTWAudioManager();
  audioManager.PlayExorcismStackAdded();

  // If reached 10 stacks, play complete sound
  if this.GetStacks(targetID) >= 10 {
    let gameInstance: GameInstance = GetGameInstance();
    let puppet: ref<ScriptedPuppet> = GameInstance.FindEntityByID(gameInstance, targetID) as ScriptedPuppet;

    if IsDefined(puppet) {
      audioManager.PlayExorcismComplete(puppet.GetWorldPosition());
    }
  }
}
