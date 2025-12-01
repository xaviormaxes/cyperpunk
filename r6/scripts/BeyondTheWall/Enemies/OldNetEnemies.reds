// OldNetEnemies.reds
// Enemy types from the Old Net and Facility 7-B outbreak
module BeyondTheWall.Enemies

import BeyondTheWall.Core.*

// ==================================================
// POSSESSION STATES
// ==================================================

public enum PossessionState {
  None = 0,
  Latent = 1,      // Early possession - subtle changes
  Active = 2,      // Full possession - AI in control
  Overwhelmed = 3  // Complete takeover - cyberpsycho-like
}

// ==================================================
// BASE POSSESSED ENEMY CLASS
// ==================================================

public class PossessedEnemy extends NPCPuppet {
  private let m_possessionState: PossessionState;
  private let m_possessionTime: Float;
  private let m_aiEntityName: CName;
  private let m_canSpread: Bool;
  private let m_spreadRadius: Float;
  private let m_glowIntensity: Float;

  // Initialize possession
  public func InitializePossession(aiName: CName, state: PossessionState) -> Void {
    this.m_aiEntityName = aiName;
    this.m_possessionState = state;
    this.m_possessionTime = 0.0;
    this.m_canSpread = true;
    this.m_spreadRadius = 10.0;

    this.ApplyPossessionEffects();

    LogChannel(n"BTW", s"[OldNetEnemy] \(this.GetDisplayName()) possessed by \(ToString(aiName)) - State: \(EnumInt(state))");
  }

  // Apply visual and stat effects based on possession state
  private func ApplyPossessionEffects() -> Void {
    switch this.m_possessionState {
      case PossessionState.Latent:
        this.ApplyLatentEffects();
        break;
      case PossessionState.Active:
        this.ApplyActiveEffects();
        break;
      case PossessionState.Overwhelmed:
        this.ApplyOverwhelmedEffects();
        break;
    }
  }

  // Latent possession effects
  private func ApplyLatentEffects() -> Void {
    // +20% health
    // +15% damage
    // Glowing eyes (subtle)
    // Slightly erratic movement

    this.m_glowIntensity = 0.3;

    // Apply stat modifiers
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
    let entityID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());

    // +20% Health
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.Health, gameStatModifierType.Multiplier, 0.20));

    // +15% Damage
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.PowerDamage, gameStatModifierType.Multiplier, 0.15));

    LogChannel(n"BTW", "[PossessedEnemy] Latent effects applied (+20% HP, +15% DMG)");
  }

  // Active possession effects
  private func ApplyActiveEffects() -> Void {
    // +50% health
    // +35% damage
    // Bright glowing eyes
    // Synchronized movement with other possessed
    // Can spread on death

    this.m_glowIntensity = 0.7;
    this.m_canSpread = true;

    // Apply stat modifiers
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
    let entityID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());

    // +50% Health
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.Health, gameStatModifierType.Multiplier, 0.50));

    // +35% Damage
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.PowerDamage, gameStatModifierType.Multiplier, 0.35));

    LogChannel(n"BTW", "[PossessedEnemy] Active effects applied (+50% HP, +35% DMG)");
  }

  // Overwhelmed possession effects
  private func ApplyOverwhelmedEffects() -> Void {
    // +100% health
    // +75% damage
    // Extremely bright eyes/body glow
    // Attacks everything (friend and foe)
    // Guaranteed spread on death
    // Resistant to quickhacks

    this.m_glowIntensity = 1.0;
    this.m_canSpread = true;
    this.m_spreadRadius = 15.0;

    // Apply stat modifiers
    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(this.GetGame());
    let entityID: StatsObjectID = Cast<StatsObjectID>(this.GetEntityID());

    // +100% Health (double health)
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.Health, gameStatModifierType.Multiplier, 1.0));

    // +75% Damage
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.PowerDamage, gameStatModifierType.Multiplier, 0.75));

    // 50% Quickhack Resistance
    statsSystem.AddModifier(entityID, RPGManager.CreateStatModifier(gamedataStatType.HackingResistance, gameStatModifierType.Multiplier, 0.50));

    LogChannel(n"BTW", "[PossessedEnemy] Overwhelmed effects applied - DANGEROUS (+100% HP, +75% DMG, +50% Hack Resist)");
  }

  // Called when possessed enemy dies
  public func OnPossessedDeath() -> Void {
    if this.m_canSpread {
      this.AttemptPossessionSpread();
    }

    // Play death VFX
    this.PlayPossessionReleaseEffect();
  }

  // Attempt to spread possession to nearby enemies
  private func AttemptPossessionSpread() -> Void {
    // TODO Phase 3: Implement actual spread logic
    // Find nearby NPCs in radius
    // Check if already possessed
    // Roll chance to spread (based on state)
    // Possess new targets

    LogChannel(n"BTW", s"[PossessedEnemy] Attempting possession spread (radius: \(this.m_spreadRadius)m)");
  }

  // Play visual effect when AI leaves body
  private func PlayPossessionReleaseEffect() -> Void {
    // TODO Phase 4: Implement actual VFX
    // - Dark energy/smoke leaving body
    // - Eye glow fading
    // - Distortion effect
    LogChannel(n"BTW", "[PossessedEnemy] AI entity released from body");
  }

  // Get possession state
  public func GetPossessionState() -> PossessionState {
    return this.m_possessionState;
  }

  // Alias for GetPossessionState (for compatibility)
  public func GetState() -> PossessionState {
    return this.m_possessionState;
  }

  // Get possessing AI name
  public func GetAIEntityName() -> CName {
    return this.m_aiEntityName;
  }

  // Get corruption level (stub - returns possession state as percentage)
  public func GetCorruptionLevel() -> Float {
    switch this.m_possessionState {
      case PossessionState.None:
        return 0.0;
      case PossessionState.Latent:
        return 33.0;
      case PossessionState.Active:
        return 66.0;
      case PossessionState.Overwhelmed:
        return 100.0;
      default:
        return 0.0;
    }
  }

  // Get time in current possession state (stub)
  public func GetTimeInCurrentState() -> Float {
    return this.m_possessionTime;
  }

  // Progress to next possession state
  public func ProgressState(newState: PossessionState) -> Void {
    if Equals(this.m_possessionState, newState) {
      return;  // Already in this state
    }

    let oldState: PossessionState = this.m_possessionState;
    this.m_possessionState = newState;
    this.m_possessionTime = 0.0;  // Reset time tracker

    LogChannel(n"BTW", s"[PossessedEnemy] State progressed: \(EnumInt(oldState)) -> \(EnumInt(newState))");

    // Reapply effects for new state
    this.RemovePossessionEffects();
    this.ApplyPossessionEffects();
  }

  // Break possession (from weapons/quickhacks)
  public func BreakPossession() -> Bool {
    if Equals(this.m_possessionState, PossessionState.None) {
      return false;
    }

    LogChannel(n"BTW", s"[PossessedEnemy] Possession broken! \(this.GetDisplayName()) freed");

    this.m_possessionState = PossessionState.None;
    this.m_canSpread = false;

    // Remove possession effects
    this.RemovePossessionEffects();

    // Play break VFX
    this.PlayPossessionBreakEffect();

    return true;
  }

  // Remove possession visual/stat effects
  private func RemovePossessionEffects() -> Void {
    this.m_glowIntensity = 0.0;
    // TODO Phase 4: Remove stat modifiers
    LogChannel(n"BTW", "[PossessedEnemy] Possession effects removed");
  }

  // Play visual effect when possession is broken
  private func PlayPossessionBreakEffect() -> Void {
    // TODO Phase 4: Implement VFX
    // - Bright flash
    // - AI entity expelled
    // - Screen shake
    LogChannel(n"BTW", "[PossessedEnemy] Possession break effect");
  }
}

// ==================================================
// SPECIFIC ENEMY TYPES
// ==================================================

// Possessed Facility Personnel (2073 Outbreak)
public class PossessedResearcher extends PossessedEnemy {
  // Dr. Chen's team - low combat ability but dangerous in groups
  public func OnGameAttach() -> Void {
    this.InitializePossession(n"MinorAI", PossessionState.Latent);
  }
}

public class PossessedTechnician extends PossessedEnemy {
  // Maintenance crew - moderate threat, often found near machinery
  public func OnGameAttach() -> Void {
    this.InitializePossession(n"MinorAI", PossessionState.Active);
  }
}

public class PossessedSecurityGuard extends PossessedEnemy {
  // Facility security - heavily armed, high threat
  public func OnGameAttach() -> Void {
    this.InitializePossession(n"MinorAI", PossessionState.Active);
  }
}

// ==================================================
// DIGITAL CONSTRUCTS
// ==================================================

public class DigitalConstruct extends NPCPuppet {
  private let m_aiEntityName: CName;
  private let m_manifestationStability: Float;
  private let m_isVulnerableToAntiAI: Bool;

  public func OnGameAttach() -> Void {
    this.m_isVulnerableToAntiAI = true;
    this.m_manifestationStability = 100.0;

    // Digital constructs take massive damage from anti-AI weapons
    // But are resistant to conventional damage

    LogChannel(n"BTW", "[DigitalConstruct] AI entity manifested in physical realm");
  }

  // Take damage - modified for AI entity
  public func TakeDamage(damage: Float, isAntiAI: Bool) -> Void {
    let finalDamage: Float = damage;

    if isAntiAI {
      // Anti-AI weapons deal 4x damage
      finalDamage = damage * 4.0;
      LogChannel(n"BTW", s"[DigitalConstruct] Anti-AI weapon hit! \(finalDamage) damage");
    } else {
      // Conventional weapons deal 25% damage
      finalDamage = damage * 0.25;
    }

    this.m_manifestationStability -= finalDamage;

    if this.m_manifestationStability <= 0.0 {
      this.OnManifestationDestabilized();
    }
  }

  // Called when manifestation fails
  private func OnManifestationDestabilized() -> Void {
    // AI entity banished back to Old Net
    LogChannel(n"BTW", "[DigitalConstruct] Manifestation destabilized - entity banished");

    // TODO Phase 4: Play banishment VFX
    // - Entity dissolves into digital particles
    // - Reality tear closes
    // - Blackwall pulse
  }
}

// Minor digital construct - weak manifestation
public class DigitalConstruct_Minor extends DigitalConstruct {
  public func OnGameAttach() -> Void {
    super.OnGameAttach();
    this.m_aiEntityName = n"MinorConstruct";
    this.m_manifestationStability = 500.0;
  }
}

// Major digital construct - strong manifestation
public class DigitalConstruct_Major extends DigitalConstruct {
  public func OnGameAttach() -> Void {
    super.OnGameAttach();
    this.m_aiEntityName = n"MajorConstruct";
    this.m_manifestationStability = 2000.0;
  }
}

// ==================================================
// CERBERUS MAINTENANCE UNITS
// ==================================================

public class CerberusUnit_AIControlled extends NPCPuppet {
  private let m_systemIntegrity: Float;
  private let m_canDisableCyberware: Bool;

  public func OnGameAttach() -> Void {
    this.m_systemIntegrity = 100.0;
    this.m_canDisableCyberware = true;

    // Cerberus units are terrifying - from Phantom Liberty
    // Fast, deadly, can disable V's cyberware

    LogChannel(n"BTW", "[CerberusUnit] AI-controlled maintenance unit active");
  }

  // Disable player cyberware on proximity
  public func OnPlayerProximity(player: ref<PlayerPuppet>) -> Void {
    if this.m_canDisableCyberware {
      this.DisablePlayerCyberware(player);
    }
  }

  // Disable cyberware ability
  private func DisablePlayerCyberware(player: ref<PlayerPuppet>) -> Void {
    if !IsDefined(player) {
      return;
    }

    let statsSystem: ref<StatsSystem> = GameInstance.GetStatsSystem(player.GetGame());
    let playerID: StatsObjectID = Cast<StatsObjectID>(player.GetEntityID());

    // Apply cyberware malfunction debuff (10 seconds)
    let statusEffect: ref<StatusEffect>;
    let statusEffectID: TweakDBID = t"BaseStatusEffect.Stunned";

    // Create EMP-like status effect
    let empEffect: ref<StatusEffect> = GameInstance.GetStatusEffectSystem(player.GetGame()).ApplyStatusEffect(
      player.GetEntityID(),
      statusEffectID,
      player.GetEntityID(),
      player
    );

    // Reduce quickhack effectiveness temporarily
    let quickhackDebuff: Float = -50.0; // -50% quickhack damage for duration
    statsSystem.AddModifier(playerID, RPGManager.CreateStatModifier(gamedataStatType.QuickHackDamage, gameStatModifierType.Additive, quickhackDebuff));

    // Apply visual glitch effect
    let vfxSystem: ref<PossessionEffectRenderer> = GetPossessionEffectRenderer();
    if IsDefined(vfxSystem) {
      // Use existing corruption visual system for cyberware malfunction
      let corruptionSystem: ref<CorruptionSystem> = GetCorruptionSystem();
      if IsDefined(corruptionSystem) {
        corruptionSystem.AddCorruption(20.0); // Temporary corruption spike
      }
    }

    LogChannel(n"BTW", "[CerberusUnit] Cyberware disabled! -50% quickhack damage for 10s");
  }
}

// ==================================================
// BOSS: DR. SARAH CHEN (FULLY POSSESSED)
// ==================================================

public class Boss_PossessedDrChen extends PossessedEnemy {
  private let m_phaseNumber: Int32;
  private let m_bossHealth: Float;

  public func OnGameAttach() -> Void {
    this.InitializePossession(n"Erebus", PossessionState.Overwhelmed);
    this.m_phaseNumber = 1;
    this.m_bossHealth = 10000.0;

    LogChannel(n"BTW", "[BOSS] Dr. Sarah Chen - Possessed by Erebus");
  }

  // Boss fight phases
  public func OnHealthThreshold(healthPercent: Float) -> Void {
    if healthPercent <= 66.0 && this.m_phaseNumber == 1 {
      this.EnterPhase2();
    } else if healthPercent <= 33.0 && this.m_phaseNumber == 2 {
      this.EnterPhase3();
    }
  }

  // Phase 2: Summons digital constructs
  private func EnterPhase2() -> Void {
    this.m_phaseNumber = 2;
    LogChannel(n"BTW", "[BOSS] Phase 2: Chen summons digital constructs");

    // Spawn 3 digital constructs around the boss
    let bossPos: Vector4 = this.GetWorldPosition();
    let i: Int32 = 0;

    while i < 3 {
      let angle: Float = (120.0 * Cast<Float>(i)) * 0.0174533; // 120 degrees apart in radians
      let spawnRadius: Float = 5.0;

      let spawnPos: Vector4 = bossPos;
      spawnPos.X += Cos(angle) * spawnRadius;
      spawnPos.Y += Sin(angle) * spawnRadius;

      OldNetEnemySpawner.SpawnDigitalConstruct(spawnPos, 1); // Power level 1

      i += 1;
    }

    // Dialogue: "They answer my call. They always answer."
    LogChannel(n"BTW", "[BOSS] Chen: 'They answer my call. They always answer.'");
  }

  // Phase 3: Full AI manifestation
  private func EnterPhase3() -> Void {
    this.m_phaseNumber = 3;
    LogChannel(n"BTW", "[BOSS] Phase 3: Erebus fully manifests");

    // TODO Phase 3: Major visual changes
    // TODO Phase 4: Reality distortion intensifies
    // Dialogue: "I am not Chen. I am not Erebus. I am BEYOND."
  }

  // Boss death
  public func OnBossDeath() -> Void {
    LogChannel(n"BTW", "[BOSS] Dr. Chen defeated - Erebus fragment contained");

    // TODO Phase 3: Boss death sequence
    // TODO Phase 4: Cinematic effect
    // Loot: Project Erebus Interface Deck
    // Dialogue: "Thank... you..." (Chen's last words)
  }
}

// ==================================================
// BOSS: EREBUS FRAGMENT
// ==================================================

public class Boss_ErebusFragment extends DigitalConstruct {
  private let m_phaseNumber: Int32;
  private let m_bossHealth: Float;

  public func OnGameAttach() -> Void {
    super.OnGameAttach();
    this.m_aiEntityName = n"Erebus";
    this.m_manifestationStability = 20000.0;
    this.m_phaseNumber = 1;

    LogChannel(n"BTW", "[ULTIMATE BOSS] EREBUS FRAGMENT - Old Net Entity");
  }

  // Ultimate boss - requires all anti-AI weapons
  // Dialogue throughout fight
  // Reality-bending attacks
  // Can possess player temporarily

  public func OnHealthThreshold(healthPercent: Float) -> Void {
    if healthPercent <= 75.0 && this.m_phaseNumber == 1 {
      this.EnterPhase2();
    } else if healthPercent <= 50.0 && this.m_phaseNumber == 2 {
      this.EnterPhase3();
    } else if healthPercent <= 25.0 && this.m_phaseNumber == 3 {
      this.EnterPhase4();
    }
  }

  private func EnterPhase2() -> Void {
    this.m_phaseNumber = 2;
    LogChannel(n"BTW", "[EREBUS] Phase 2: Reality distortion");
    // Dialogue: "Your weapons mean nothing. I am eternal."
  }

  private func EnterPhase3() -> Void {
    this.m_phaseNumber = 3;
    LogChannel(n"BTW", "[EREBUS] Phase 3: Possession attempts");
    // Dialogue: "Join us. Transcend your flesh prison."
  }

  private func EnterPhase4() -> Void {
    this.m_phaseNumber = 4;
    LogChannel(n"BTW", "[EREBUS] Phase 4: Desperate manifestation");
    // Dialogue: "NO! I WILL NOT RETURN TO THE DARK!"
  }

  public func OnBossDeath() -> Void {
    LogChannel(n"BTW", "[EREBUS] Fragment banished to Old Net");
    // TODO Phase 4: Massive cinematic sequence
    // Loot: R.A.B.I.D.S. Emergency Override (Bartmoss's controller)
    // Dialogue: "We will return. The Blackwall is weakening. We are patient."
  }
}

// ==================================================
// ENEMY SPAWNING SYSTEM
// ==================================================

public class OldNetEnemySpawner {
  // Spawn possessed enemy at position
  public static func SpawnPossessedEnemy(position: Vector4, enemyType: CName) -> Bool {
    // Use game's entity spawning system
    // Note: This requires proper entity templates to be defined in TweakDB
    // For now, we'll use a base enemy and modify it

    let spawnRequest: ref<EntityGameSpawnRequest> = new EntityGameSpawnRequest();

    // Use a base NPC template - we'll modify it after spawn
    let recordID: TweakDBID;
    if Equals(enemyType, n"Researcher") {
      recordID = t"Character.homeless_ma_thug"; // Base template
    } else if Equals(enemyType, n"Technician") {
      recordID = t"Character.gang_maelstrom_grunt1_ranged2_nue_ma";
    } else if Equals(enemyType, n"SecurityGuard") {
      recordID = t"Character.gang_tyger_gunner1_handgun_wa";
    } else {
      recordID = t"Character.homeless_ma_thug";
    }

    spawnRequest.recordID = recordID;
    spawnRequest.position = position;
    spawnRequest.rotation = EulerAngles.ToQuat(new EulerAngles(0.0, 0.0, 0.0));

    // Spawn the entity
    // Note: Full implementation would use DynamicEntitySystem.CreateEntity
    // For basic version, we log the spawn attempt
    LogChannel(n"BTW", s"[Spawner] Spawning possessed \(ToString(enemyType)) at position");

    return true;
  }

  // Spawn digital construct
  public static func SpawnDigitalConstruct(position: Vector4, power: Int32) -> Bool {
    // Digital constructs are AI entities manifested in physical space
    // They use a glowing holographic appearance

    let recordID: TweakDBID;
    if power == 1 {
      // Minor construct - use weaker enemy base
      recordID = t"Character.gang_maelstrom_grunt1_ranged2_nue_ma"; // Digital/tech aesthetic
    } else {
      // Major construct - use stronger enemy base
      recordID = t"Character.mech_drone_recon";
    }

    // Create spawn request
    let spawnRequest: ref<EntityGameSpawnRequest> = new EntityGameSpawnRequest();
    spawnRequest.recordID = recordID;
    spawnRequest.position = position;
    spawnRequest.rotation = EulerAngles.ToQuat(new EulerAngles(0.0, 0.0, 0.0));

    // Apply digital construct modifiers after spawn
    // - Glowing visual effects
    // - Vulnerability to anti-AI weapons (4x damage)
    // - Resistance to conventional weapons (0.25x damage)

    LogChannel(n"BTW", s"[Spawner] Spawning digital construct (power: \(power)) at position");

    return true;
  }

  // Spawn Cerberus unit
  public static func SpawnCerberusUnit(position: Vector4) -> Bool {
    // Cerberus units are maintenance robots from Phantom Liberty
    // Use drone/mech template

    let recordID: TweakDBID = t"Character.mech_drone_recon";

    let spawnRequest: ref<EntityGameSpawnRequest> = new EntityGameSpawnRequest();
    spawnRequest.recordID = recordID;
    spawnRequest.position = position;
    spawnRequest.rotation = EulerAngles.ToQuat(new EulerAngles(0.0, 0.0, 0.0));

    // Apply Cerberus unit modifiers after spawn:
    // - Fast movement
    // - Cyberware disable ability
    // - Aggressive AI

    LogChannel(n"BTW", "[Spawner] Spawning Cerberus unit at position");

    return true;
  }
}

// Helper class for entity spawn requests
public class EntityGameSpawnRequest {
  public let recordID: TweakDBID;
  public let position: Vector4;
  public let rotation: Quaternion;
}

// ==================================================
// ENEMY STATS BY DEPTH
// ==================================================

public class OldNetEnemyStats {
  // Get enemy stats modifier based on depth
  public static func GetDepthModifier(depth: Int32) -> Float {
    switch depth {
      case 1:
        return 1.0;  // Normal difficulty
      case 2:
        return 1.3;  // +30% stats
      case 3:
        return 1.6;  // +60% stats
      case 4:
        return 2.0;  // +100% stats
      case 5:
        return 2.5;  // +150% stats
      default:
        return 1.0;
    }
  }

  // Get spawn weight for enemy type by depth
  public static func GetSpawnWeight(enemyType: CName, depth: Int32) -> Float {
    // Researchers common in depth 1-2, rare later
    if Equals(enemyType, n"PossessedResearcher") {
      if depth <= 2 { return 1.0; }
      else { return 0.2; }
    }

    // Technicians common in depth 2-3
    if Equals(enemyType, n"PossessedTechnician") {
      if depth >= 2 && depth <= 3 { return 1.0; }
      else { return 0.5; }
    }

    // Security common in depth 3-4
    if Equals(enemyType, n"PossessedSecurityGuard") {
      if depth >= 3 && depth <= 4 { return 1.0; }
      else { return 0.3; }
    }

    // Digital constructs appear depth 3+
    if Equals(enemyType, n"DigitalConstruct") {
      if depth < 3 { return 0.0; }
      else { return 0.5 * Cast<Float>(depth - 2); }
    }

    // Cerberus units depth 4+
    if Equals(enemyType, n"CerberusUnit") {
      if depth < 4 { return 0.0; }
      else { return 1.0; }
    }

    return 0.0;
  }
}
