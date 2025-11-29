// PossessionBehavior.reds
// AI behavior modifications for possessed enemies
module BeyondTheWall.AI

import BeyondTheWall.Enemies.*

// ==================================================
// POSSESSION BEHAVIOR SYSTEM
// ==================================================

public class PossessionBehaviorSystem extends ScriptableSystem {
  private let m_behaviorModsEnabled: Bool;

  private func OnAttach() -> Void {
    this.m_behaviorModsEnabled = true;

    LogChannel(n"BTW", "[PossessionBehavior] System initialized");
  }

  // Apply behavior modifications for possession state
  public func ApplyBehaviorMods(enemy: ref<PossessedEnemy>, state: PossessionState) -> Void {
    if !this.m_behaviorModsEnabled {
      return;
    }

    switch state {
      case PossessionState.Latent:
        this.ApplyLatentBehavior(enemy);
        break;
      case PossessionState.Active:
        this.ApplyActiveBehavior(enemy);
        break;
      case PossessionState.Overwhelmed:
        this.ApplyOverwhelmedBehavior(enemy);
        break;
    }
  }

  // Latent possession behavior
  private func ApplyLatentBehavior(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 3: Implement actual AI behavior mods
    // - Slight movement irregularities
    // - Occasional head twitches
    // - Slightly enhanced reflexes (+15%)
    // - Group coordination (move together)
    // - Stare at player briefly

    LogChannel(n"BTW", "[PossessionBehavior] Latent behavior applied");
  }

  // Active possession behavior
  private func ApplyActiveBehavior(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 3: Implement actual AI behavior mods
    // - Synchronized movement with other possessed
    // - Enhanced combat abilities (+35% damage)
    // - Aggressive pursuit
    // - Perfect flanking coordination
    // - Uses cyberware more effectively
    // - Prioritizes spreading infection

    LogChannel(n"BTW", "[PossessionBehavior] Active behavior applied");
  }

  // Overwhelmed possession behavior
  private func ApplyOverwhelmedBehavior(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 3: Implement actual AI behavior mods
    // - Attacks EVERYTHING (change faction to hostile to all)
    // - Berserker mode (+75% damage, +100% health)
    // - Erratic, unpredictable movement
    // - Extremely aggressive
    // - No self-preservation
    // - Will sacrifice itself to spread
    // - Resistant to quickhacks (50% resistance)

    LogChannel(n"BTW", "[PossessionBehavior] Overwhelmed behavior applied - DANGEROUS");
  }

  // Remove behavior modifications
  public func RemoveBehaviorMods(enemy: ref<PossessedEnemy>) -> Void {
    // TODO Phase 3: Reset AI to normal behavior
    // - Remove stat modifiers
    // - Restore original faction
    // - Reset aggression levels

    LogChannel(n"BTW", "[PossessionBehavior] Behavior mods removed");
  }

  // Get stat multiplier for possession state
  public func GetStatMultiplier(state: PossessionState, statType: CName) -> Float {
    // Health multipliers
    if Equals(statType, n"Health") {
      switch state {
        case PossessionState.Latent:
          return 1.2;  // +20%
        case PossessionState.Active:
          return 1.5;  // +50%
        case PossessionState.Overwhelmed:
          return 2.0;  // +100%
        default:
          return 1.0;
      }
    }

    // Damage multipliers
    if Equals(statType, n"Damage") {
      switch state {
        case PossessionState.Latent:
          return 1.15;  // +15%
        case PossessionState.Active:
          return 1.35;  // +35%
        case PossessionState.Overwhelmed:
          return 1.75;  // +75%
        default:
          return 1.0;
      }
    }

    // Quickhack resistance
    if Equals(statType, n"QuickhackResistance") {
      switch state {
        case PossessionState.Overwhelmed:
          return 0.5;  // 50% resistance
        default:
          return 1.0;
      }
    }

    return 1.0;
  }

  // Enable/disable behavior mods
  public func SetBehaviorModsEnabled(enabled: Bool) -> Void {
    this.m_behaviorModsEnabled = enabled;
  }
}

// Global accessor
public static func GetPossessionBehaviorSystem() -> ref<PossessionBehaviorSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessionBehaviorSystem") as PossessionBehaviorSystem;
}

// ==================================================
// POSSESSION STATE PROGRESSION
// ==================================================

public class PossessionStateProgressionSystem extends ScriptableSystem {
  private let m_progressionEnabled: Bool;
  private let m_progressionThreshold: Float;  // Time or damage to progress

  private func OnAttach() -> Void {
    this.m_progressionEnabled = true;
    this.m_progressionThreshold = 60.0;  // 60 seconds in combat

    LogChannel(n"BTW", "[PossessionProgression] System initialized");
  }

  // Check if enemy should progress to next state
  public func CheckProgression(enemy: ref<PossessedEnemy>, timeInCombat: Float) -> Bool {
    if !this.m_progressionEnabled {
      return false;
    }

    let currentState: PossessionState = enemy.GetPossessionState();

    // Check if can progress
    if !this.CanProgress(currentState) {
      return false;
    }

    // Check if threshold met
    if timeInCombat >= this.m_progressionThreshold {
      this.ProgressToNextState(enemy);
      return true;
    }

    return false;
  }

  // Check if state can progress
  private func CanProgress(state: PossessionState) -> Bool {
    switch state {
      case PossessionState.Latent:
        return true;   // Can progress to Active
      case PossessionState.Active:
        return true;   // Can progress to Overwhelmed
      case PossessionState.Overwhelmed:
        return false;  // Final state
      default:
        return false;
    }
  }

  // Progress to next possession state
  private func ProgressToNextState(enemy: ref<PossessedEnemy>) -> Void {
    let currentState: PossessionState = enemy.GetPossessionState();
    let newState: PossessionState;

    switch currentState {
      case PossessionState.Latent:
        newState = PossessionState.Active;
        break;
      case PossessionState.Active:
        newState = PossessionState.Overwhelmed;
        break;
      default:
        return;
    }

    LogChannel(n"BTW", s"[PossessionProgression] Enemy progressing: \(EnumInt(currentState)) -> \(EnumInt(newState))");

    // Actually change enemy's state (applies new effects automatically)
    enemy.ProgressState(newState);

    // Update possession registry
    let possessionSystem: ref<PossessionSpreadSystem> = GetPossessionSpreadSystem();
    if IsDefined(possessionSystem) {
      let record: ref<PossessedEnemyRecord> = possessionSystem.GetPossessedEnemyRecord(enemy.GetEntityID());
      if IsDefined(record) {
        record.possessionState = newState;
      }
    }

    // Play state transition animation
    this.OnStateProgression(enemy, currentState, newState);
  }

  // Callback for state progression (triggers animations)
  private func OnStateProgression(enemy: ref<PossessedEnemy>, oldState: PossessionState, newState: PossessionState) -> Void {
    let animSystem: ref<PossessionAnimationSystem> = GetPossessionAnimationSystem();
    if IsDefined(animSystem) && IsDefined(enemy) {
      animSystem.PlayStateTransitionAnimation(enemy, oldState, newState);
    }
  }

  // Force immediate progression (for scripted events)
  public func ForceProgression(enemy: ref<PossessedEnemy>) -> Void {
    this.ProgressToNextState(enemy);
  }

  // Set progression threshold
  public func SetProgressionThreshold(threshold: Float) -> Void {
    this.m_progressionThreshold = threshold;
  }

  // Enable/disable progression
  public func SetProgressionEnabled(enabled: Bool) -> Void {
    this.m_progressionEnabled = enabled;
  }
}

// Global accessor
public static func GetPossessionStateProgressionSystem() -> ref<PossessionStateProgressionSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessionStateProgressionSystem") as PossessionStateProgressionSystem;
}

// ==================================================
// GROUP COORDINATION SYSTEM
// ==================================================

public class PossessedGroupCoordinationSystem extends ScriptableSystem {
  // Track groups of possessed enemies
  private let m_groups: array<ref<PossessedGroup>>;

  private func OnAttach() -> Void {
    ArrayClear(this.m_groups);

    LogChannel(n"BTW", "[GroupCoordination] System initialized");
  }

  // Add enemy to coordination group
  public func AddToGroup(enemy: ref<PossessedEnemy>, aiEntityName: CName) -> Void {
    let group: ref<PossessedGroup> = this.FindOrCreateGroup(aiEntityName);
    ArrayPush(group.members, enemy);

    LogChannel(n"BTW", s"[GroupCoordination] Enemy added to group \(ToString(aiEntityName)) (size: \(ArraySize(group.members)))");
  }

  // Remove enemy from group
  public func RemoveFromGroup(enemy: ref<PossessedEnemy>) -> Void {
    let i: Int32 = 0;
    let groupCount: Int32 = ArraySize(this.m_groups);

    while i < groupCount {
      let group: ref<PossessedGroup> = this.m_groups[i];
      let j: Int32 = 0;
      let memberCount: Int32 = ArraySize(group.members);

      while j < memberCount {
        if Equals(group.members[j], enemy) {
          ArrayErase(group.members, j);
          LogChannel(n"BTW", s"[GroupCoordination] Enemy removed from group");

          // Remove empty groups
          if ArraySize(group.members) == 0 {
            ArrayErase(this.m_groups, i);
          }

          return;
        }
        j += 1;
      }
      i += 1;
    }
  }

  // Get all members of same AI entity group
  public func GetGroupMembers(aiEntityName: CName) -> array<ref<PossessedEnemy>> {
    let group: ref<PossessedGroup> = this.FindGroup(aiEntityName);
    if IsDefined(group) {
      return group.members;
    }

    let empty: array<ref<PossessedEnemy>>;
    return empty;
  }

  // Coordinate group movement (all move together)
  public func CoordinateMovement(aiEntityName: CName, targetPosition: Vector4) -> Void {
    let group: ref<PossessedGroup> = this.FindGroup(aiEntityName);
    if !IsDefined(group) {
      return;
    }

    // TODO Phase 3: Implement actual coordinated movement
    // - All group members move in formation
    // - Maintain spacing
    // - Synchronized actions

    LogChannel(n"BTW", s"[GroupCoordination] Coordinating \(ArraySize(group.members)) enemies");
  }

  // Find existing group
  private func FindGroup(aiEntityName: CName) -> ref<PossessedGroup> {
    let i: Int32 = 0;
    let size: Int32 = ArraySize(this.m_groups);

    while i < size {
      if Equals(this.m_groups[i].aiEntityName, aiEntityName) {
        return this.m_groups[i];
      }
      i += 1;
    }

    return null;
  }

  // Find or create group
  private func FindOrCreateGroup(aiEntityName: CName) -> ref<PossessedGroup> {
    let group: ref<PossessedGroup> = this.FindGroup(aiEntityName);

    if !IsDefined(group) {
      group = new PossessedGroup();
      group.aiEntityName = aiEntityName;
      ArrayClear(group.members);
      ArrayPush(this.m_groups, group);

      LogChannel(n"BTW", s"[GroupCoordination] New group created: \(ToString(aiEntityName))");
    }

    return group;
  }

  // Get total number of possessed enemies
  public func GetTotalPossessedCount() -> Int32 {
    let total: Int32 = 0;
    let i: Int32 = 0;
    let size: Int32 = ArraySize(this.m_groups);

    while i < size {
      total += ArraySize(this.m_groups[i].members);
      i += 1;
    }

    return total;
  }
}

// Possessed enemy group
public class PossessedGroup {
  public let aiEntityName: CName;
  public let members: array<ref<PossessedEnemy>>;
}

// Global accessor
public static func GetPossessedGroupCoordinationSystem() -> ref<PossessedGroupCoordinationSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessedGroupCoordinationSystem") as PossessedGroupCoordinationSystem;
}
