// PossessionSpreadSystem.reds
// Manages AI possession spread mechanics when enemies die
module BeyondTheWall.AI

import BeyondTheWall.Core.*
import BeyondTheWall.Enemies.*

// ==================================================
// POSSESSION SPREAD SYSTEM
// ==================================================

public class PossessionSpreadSystem extends ScriptableSystem {
  private let m_spreadEnabled: Bool;
  private let m_debugMode: Bool;
  private let m_spreadHistory: array<ref<PossessionSpreadEvent>>;
  private let m_possessedEnemies: array<ref<PossessedEnemyRecord>>;  // Track possessed enemies

  // Initialize system
  private func OnAttach() -> Void {
    this.m_spreadEnabled = true;
    this.m_debugMode = false;
    ArrayClear(this.m_spreadHistory);
    ArrayClear(this.m_possessedEnemies);

    LogChannel(n"BTW", "[PossessionSpread] System initialized");
  }

  // Called when possessed enemy dies
  public func OnPossessedEnemyDeath(deadEnemy: ref<PossessedEnemy>, killerPosition: Vector4) -> Void {
    if !this.m_spreadEnabled {
      return;
    }

    let possessionState: PossessionState = deadEnemy.GetPossessionState();
    let aiEntityName: CName = deadEnemy.GetAIEntityName();
    let deathPosition: Vector4 = deadEnemy.GetWorldPosition();

    // Check if this possession state can spread
    if !this.CanSpread(possessionState) {
      LogChannel(n"BTW", s"[PossessionSpread] \(ToString(possessionState)) cannot spread");
      return;
    }

    // Get spread parameters
    let spreadChance: Float = this.GetSpreadChance(possessionState);
    let spreadRadius: Float = this.GetSpreadRadius(possessionState);
    let maxTargets: Int32 = this.GetMaxSpreadTargets(possessionState);

    // Check if spread succeeds
    if !this.RollSpreadChance(spreadChance) {
      LogChannel(n"BTW", s"[PossessionSpread] Spread failed (chance: \(spreadChance * 100.0)%)");
      return;
    }

    // Find potential targets
    let targets: array<ref<ScriptedPuppet>> = this.FindSpreadTargets(deathPosition, spreadRadius, maxTargets);

    if ArraySize(targets) == 0 {
      LogChannel(n"BTW", "[PossessionSpread] No valid targets found");
      return;
    }

    // Spread possession to targets
    this.SpreadToTargets(targets, aiEntityName, possessionState);

    // Record event
    this.RecordSpreadEvent(deadEnemy, targets, aiEntityName);
  }

  // Check if possession state can spread
  private func CanSpread(state: PossessionState) -> Bool {
    switch state {
      case PossessionState.None:
        return false;
      case PossessionState.Latent:
        return false;  // Latent cannot spread
      case PossessionState.Active:
        return true;   // Active can spread
      case PossessionState.Overwhelmed:
        return true;   // Overwhelmed always spreads
      default:
        return false;
    }
  }

  // Get spread chance for possession state
  private func GetSpreadChance(state: PossessionState) -> Float {
    switch state {
      case PossessionState.Active:
        return 0.3;  // 30% chance
      case PossessionState.Overwhelmed:
        return 1.0;  // 100% chance
      default:
        return 0.0;
    }
  }

  // Get spread radius for possession state
  private func GetSpreadRadius(state: PossessionState) -> Float {
    switch state {
      case PossessionState.Active:
        return 10.0;  // 10 meters
      case PossessionState.Overwhelmed:
        return 15.0;  // 15 meters
      default:
        return 0.0;
    }
  }

  // Get max targets for possession state
  private func GetMaxSpreadTargets(state: PossessionState) -> Int32 {
    switch state {
      case PossessionState.Active:
        return 1;  // Spread to 1 enemy
      case PossessionState.Overwhelmed:
        return 3;  // Spread to 3 enemies
      default:
        return 0;
    }
  }

  // Roll for spread chance
  private func RollSpreadChance(chance: Float) -> Bool {
    let roll: Float = RandRangeF(0.0, 1.0);
    return roll <= chance;
  }

  // Find valid targets for possession spread
  private func FindSpreadTargets(position: Vector4, radius: Float, maxTargets: Int32) -> array<ref<ScriptedPuppet>> {
    let targets: array<ref<ScriptedPuppet>>;
    let gameInstance: GameInstance = GetGameInstance();

    // TODO Phase 3: Implement actual NPC search
    // This would use game's NPC tracking system to find nearby enemies
    // For now, return empty array (placeholder)

    LogChannel(n"BTW", s"[PossessionSpread] Searching for targets in \(radius)m radius");

    return targets;
  }

  // Spread possession to targets
  private func SpreadToTargets(targets: array<ref<ScriptedPuppet>>, aiEntityName: CName, sourceState: PossessionState) -> Void {
    let size: Int32 = ArraySize(targets);
    let i: Int32 = 0;

    while i < size {
      // Check if target is already possessed
      let target: ref<ScriptedPuppet> = targets[i];
      if this.IsAlreadyPossessed(target) {
        i += 1;
        continue;
      }

      // Possess the target
      this.PossessTarget(target, aiEntityName, sourceState);

      // Trigger animation callback
      this.OnPossessionSpread(target, aiEntityName, sourceState);

      LogChannel(n"BTW", s"[PossessionSpread] Spread to target \(i + 1)/\(size)");
      i += 1;
    }
  }

  // Public callback for possession spread (for animation system)
  private func OnPossessionSpread(target: ref<ScriptedPuppet>, aiEntityName: CName, sourceState: PossessionState) -> Void {
    // Play initial possession animation
    let animSystem: ref<PossessionAnimationSystem> = GetPossessionAnimationSystem();
    if IsDefined(animSystem) {
      animSystem.PlayInitialPossessionAnimation(target, ToString(aiEntityName));
    }
  }

  // Check if NPC is already possessed
  private func IsAlreadyPossessed(npc: ref<ScriptedPuppet>) -> Bool {
    // TODO Phase 3: Implement possession check
    // Would check if NPC has PossessedEnemy component
    return false;
  }

  // Possess a target NPC
  private func PossessTarget(target: ref<ScriptedPuppet>, aiEntityName: CName, state: PossessionState) -> Void {
    // TODO Phase 3: Implement actual possession
    // This would:
    // 1. Add PossessedEnemy component to target
    // 2. Set AI entity name
    // 3. Set possession state
    // 4. Apply visual effects
    // 5. Modify NPC behavior

    // For now, just register as a stub
    this.RegisterPossessedEnemy(target.GetEntityID(), aiEntityName, state);

    LogChannel(n"BTW", s"[PossessionSpread] Possessing target with \(ToString(aiEntityName))");
  }

  // Register a possessed enemy in tracking system
  private func RegisterPossessedEnemy(targetID: EntityID, aiEntityName: CName, state: PossessionState) -> Void {
    // Check if already registered
    let i: Int32 = 0;
    while i < ArraySize(this.m_possessedEnemies) {
      if Equals(this.m_possessedEnemies[i].targetID, targetID) {
        // Update existing record
        this.m_possessedEnemies[i].possessionState = state;
        return;
      }
      i += 1;
    }

    // Add new record
    let record: ref<PossessedEnemyRecord> = new PossessedEnemyRecord();
    record.targetID = targetID;
    record.aiEntityName = aiEntityName;
    record.possessionState = state;
    record.possessionTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    ArrayPush(this.m_possessedEnemies, record);

    LogChannel(n"BTW", s"[PossessionSpread] Registered possessed enemy (total: \(ArraySize(this.m_possessedEnemies)))");
  }

  // Unregister possessed enemy (when freed or killed)
  public func UnregisterPossessedEnemy(targetID: EntityID) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_possessedEnemies) {
      if Equals(this.m_possessedEnemies[i].targetID, targetID) {
        ArrayErase(this.m_possessedEnemies, i);
        LogChannel(n"BTW", "[PossessionSpread] Unregistered possessed enemy");
        return;
      }
      i += 1;
    }
  }

  // Record spread event for debugging
  private func RecordSpreadEvent(source: ref<PossessedEnemy>, targets: array<ref<ScriptedPuppet>>, aiName: CName) -> Void {
    let event: ref<PossessionSpreadEvent> = new PossessionSpreadEvent();
    event.sourceName = source.GetDisplayName();
    event.aiEntityName = aiName;
    event.targetCount = ArraySize(targets);
    event.timestamp = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));

    ArrayPush(this.m_spreadHistory, event);

    // Keep only last 50 events
    if ArraySize(this.m_spreadHistory) > 50 {
      ArrayErase(this.m_spreadHistory, 0);
    }
  }

  // Get spread history (for debugging)
  public func GetSpreadHistory() -> array<ref<PossessionSpreadEvent>> {
    return this.m_spreadHistory;
  }

  // Enable/disable spreading
  public func SetSpreadEnabled(enabled: Bool) -> Void {
    this.m_spreadEnabled = enabled;
    LogChannel(n"BTW", s"[PossessionSpread] Spreading \(enabled ? "ENABLED" : "DISABLED")");
  }

  // Clear spread history
  public func ClearHistory() -> Void {
    ArrayClear(this.m_spreadHistory);
  }

  // Get possessed enemy record by entity ID
  public func GetPossessedEnemyRecord(targetID: EntityID) -> ref<PossessedEnemyRecord> {
    let i: Int32 = 0;
    while i < ArraySize(this.m_possessedEnemies) {
      if Equals(this.m_possessedEnemies[i].targetID, targetID) {
        return this.m_possessedEnemies[i];
      }
      i += 1;
    }
    return null;
  }

  // Get possessed enemy by entity ID (returns actual puppet cast to PossessedEnemy)
  // NOTE: This is a temporary shim - actual game would spawn proper PossessedEnemy instances
  public func GetPossessedEnemy(targetID: EntityID) -> ref<PossessedEnemy> {
    // Check if we have this enemy registered
    let record: ref<PossessedEnemyRecord> = this.GetPossessedEnemyRecord(targetID);
    if !IsDefined(record) {
      return null;
    }

    // Get the actual entity from game
    let gameInstance: GameInstance = GetGameInstance();
    let entity: ref<Entity> = GameInstance.FindEntityByID(gameInstance, targetID);

    // Try to cast to PossessedEnemy (will work if it's actually a PossessedEnemy instance)
    return entity as PossessedEnemy;
  }

  // Check if enemy is possessed
  public func IsPossessed(targetID: EntityID) -> Bool {
    return IsDefined(this.GetPossessedEnemyRecord(targetID));
  }
}

// Possession spread event record
public class PossessionSpreadEvent {
  public let sourceName: String;
  public let aiEntityName: CName;
  public let targetCount: Int32;
  public let timestamp: Float;
}

// Possessed enemy tracking record
public class PossessedEnemyRecord {
  public let targetID: EntityID;
  public let aiEntityName: CName;
  public let possessionState: PossessionState;
  public let possessionTime: Float;

  // Get possession state (for compatibility with PossessedEnemy interface)
  public func GetState() -> PossessionState {
    return this.possessionState;
  }

  public func GetAIEntityName() -> CName {
    return this.aiEntityName;
  }

  public func GetCorruptionLevel() -> Float {
    switch this.possessionState {
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

  public func GetTimeInCurrentState() -> Float {
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    return currentTime - this.possessionTime;
  }
}

// Global accessor
public static func GetPossessionSpreadSystem() -> ref<PossessionSpreadSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessionSpreadSystem") as PossessionSpreadSystem;
}

// ==================================================
// POSSESSION PREVENTION SYSTEM
// ==================================================

public class PossessionPreventionSystem extends ScriptableSystem {
  // Status effects that prevent possession spread
  private let m_neuralScrambleActive: array<EntityID>;  // NPCs with Neural Scramble
  private let m_exorcismInProgress: array<EntityID>;     // NPCs being exorcised

  private func OnAttach() -> Void {
    ArrayClear(this.m_neuralScrambleActive);
    ArrayClear(this.m_exorcismInProgress);

    LogChannel(n"BTW", "[PossessionPrevention] System initialized");
  }

  // Apply Neural Scramble debuff (from R.A.B.I.D.S. Remnant)
  public func ApplyNeuralScramble(target: EntityID, duration: Float) -> Void {
    if !this.HasNeuralScramble(target) {
      ArrayPush(this.m_neuralScrambleActive, target);
      LogChannel(n"BTW", "[PossessionPrevention] Neural Scramble applied");

      // TODO Phase 3: Set timer to remove after duration
    }
  }

  // Check if target has Neural Scramble
  public func HasNeuralScramble(target: EntityID) -> Bool {
    let size: Int32 = ArraySize(this.m_neuralScrambleActive);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_neuralScrambleActive[i], target) {
        return true;
      }
      i += 1;
    }

    return false;
  }

  // Remove Neural Scramble
  public func RemoveNeuralScramble(target: EntityID) -> Void {
    let size: Int32 = ArraySize(this.m_neuralScrambleActive);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_neuralScrambleActive[i], target) {
        ArrayErase(this.m_neuralScrambleActive, i);
        LogChannel(n"BTW", "[PossessionPrevention] Neural Scramble removed");
        break;
      }
      i += 1;
    }
  }

  // Start Exorcism process (from Digital Exorcist SMG)
  public func StartExorcism(target: EntityID) -> Void {
    if !this.IsBeingExorcised(target) {
      ArrayPush(this.m_exorcismInProgress, target);
      LogChannel(n"BTW", "[PossessionPrevention] Exorcism started");
    }
  }

  // Check if target is being exorcised
  public func IsBeingExorcised(target: EntityID) -> Bool {
    let size: Int32 = ArraySize(this.m_exorcismInProgress);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_exorcismInProgress[i], target) {
        return true;
      }
      i += 1;
    }

    return false;
  }

  // Complete exorcism (purge AI)
  public func CompleteExorcism(target: EntityID) -> Void {
    let size: Int32 = ArraySize(this.m_exorcismInProgress);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_exorcismInProgress[i], target) {
        ArrayErase(this.m_exorcismInProgress, i);
        LogChannel(n"BTW", "[PossessionPrevention] Exorcism COMPLETE - AI purged!");

        // TODO Phase 3: Actually remove possession from target
        break;
      }
      i += 1;
    }
  }

  // Cancel exorcism (target died or stacks decayed)
  public func CancelExorcism(target: EntityID) -> Void {
    let size: Int32 = ArraySize(this.m_exorcismInProgress);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_exorcismInProgress[i], target) {
        ArrayErase(this.m_exorcismInProgress, i);
        LogChannel(n"BTW", "[PossessionPrevention] Exorcism cancelled");
        break;
      }
      i += 1;
    }
  }
}

// Global accessor
public static func GetPossessionPreventionSystem() -> ref<PossessionPreventionSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.PossessionPreventionSystem") as PossessionPreventionSystem;
}

// ==================================================
// EXORCISM STACK TRACKER
// ==================================================

public class ExorcismStackTracker extends ScriptableSystem {
  // Track exorcism stacks per enemy
  private let m_stacks: array<ref<ExorcismStackData>>;
  private let m_stackDecayInterval: Float;
  private let m_stacksRequired: Int32;

  private func OnAttach() -> Void {
    ArrayClear(this.m_stacks);
    this.m_stackDecayInterval = 5.0;  // Stacks decay after 5 seconds
    this.m_stacksRequired = 10;       // 10 stacks = complete purge

    LogChannel(n"BTW", "[ExorcismTracker] System initialized");
  }

  // Add stack to target
  public func AddStack(target: EntityID) -> Int32 {
    let stackData: ref<ExorcismStackData> = this.GetOrCreateStackData(target);
    stackData.stacks += 1;
    stackData.lastHitTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));

    LogChannel(n"BTW", s"[ExorcismTracker] Stack added: \(stackData.stacks)/\(this.m_stacksRequired)");

    // Check if exorcism complete
    if stackData.stacks >= this.m_stacksRequired {
      this.OnExorcismComplete(target);
    }

    return stackData.stacks;
  }

  // Get current stacks for target
  public func GetStacks(target: EntityID) -> Int32 {
    let stackData: ref<ExorcismStackData> = this.FindStackData(target);
    if IsDefined(stackData) {
      return stackData.stacks;
    }
    return 0;
  }

  // Update (decay stacks over time)
  private func OnTick(deltaTime: Float) -> Void {
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    let i: Int32 = ArraySize(this.m_stacks) - 1;

    // Iterate backwards so we can remove while iterating
    while i >= 0 {
      let stackData: ref<ExorcismStackData> = this.m_stacks[i];
      let timeSinceHit: Float = currentTime - stackData.lastHitTime;

      if timeSinceHit >= this.m_stackDecayInterval {
        // Decay all stacks
        LogChannel(n"BTW", s"[ExorcismTracker] Stacks decayed for target (timeout)");
        ArrayErase(this.m_stacks, i);
      }

      i -= 1;
    }
  }

  // Called when exorcism completes (10 stacks reached)
  private func OnExorcismComplete(target: EntityID) -> Void {
    LogChannel(n"BTW", "[ExorcismTracker] EXORCISM COMPLETE!");

    // Notify prevention system
    let preventionSystem: ref<PossessionPreventionSystem> = GetPossessionPreventionSystem();
    if IsDefined(preventionSystem) {
      preventionSystem.CompleteExorcism(target);
    }

    // Remove stack data
    this.RemoveStackData(target);

    // TODO Phase 3: Play exorcism complete effect
    // - Visual effect: AI expelled from body
    // - Sound effect
    // - Screen flash
  }

  // Get or create stack data for target
  private func GetOrCreateStackData(target: EntityID) -> ref<ExorcismStackData> {
    let stackData: ref<ExorcismStackData> = this.FindStackData(target);

    if !IsDefined(stackData) {
      stackData = new ExorcismStackData();
      stackData.targetID = target;
      stackData.stacks = 0;
      stackData.lastHitTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
      ArrayPush(this.m_stacks, stackData);
    }

    return stackData;
  }

  // Find existing stack data
  private func FindStackData(target: EntityID) -> ref<ExorcismStackData> {
    let size: Int32 = ArraySize(this.m_stacks);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_stacks[i].targetID, target) {
        return this.m_stacks[i];
      }
      i += 1;
    }

    return null;
  }

  // Remove stack data
  private func RemoveStackData(target: EntityID) -> Void {
    let size: Int32 = ArraySize(this.m_stacks);
    let i: Int32 = 0;

    while i < size {
      if Equals(this.m_stacks[i].targetID, target) {
        ArrayErase(this.m_stacks, i);
        break;
      }
      i += 1;
    }
  }
}

// Exorcism stack data
public class ExorcismStackData {
  public let targetID: EntityID;
  public let stacks: Int32;
  public let lastHitTime: Float;
}

// Global accessor
public static func GetExorcismStackTracker() -> ref<ExorcismStackTracker> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.AI.ExorcismStackTracker") as ExorcismStackTracker;
}
