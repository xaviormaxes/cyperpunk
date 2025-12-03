// BlackwallWhispers.reds
// AI Whispers from beyond the Blackwall - random dialogue during high corruption
module BeyondTheWall.Core

import Codeware.*

// Named AI entities that can "speak" to the player
public enum BlackwallAIEntity {
  Unknown = 0,
  AltFragment = 1,      // Fragment of Alt Cunningham
  ErebusEcho = 2,       // Echo of Erebus
  DatakrashGhost = 3,   // Ghost from the DataKrash
  RogueConstruct = 4,   // Random rogue AI construct
  NetwatchTrace = 5     // Corrupted Netwatch AI
}

// Whisper message structure
public class BlackwallWhisper {
  public let entity: BlackwallAIEntity;
  public let message: String;
  public let corruptionRequired: Float;
  public let isHostile: Bool;
  
  public static func Create(entity: BlackwallAIEntity, message: String, corruption: Float, hostile: Bool) -> ref<BlackwallWhisper> {
    let whisper = new BlackwallWhisper();
    whisper.entity = entity;
    whisper.message = message;
    whisper.corruptionRequired = corruption;
    whisper.isHostile = hostile;
    return whisper;
  }
}

// Main whispers system
public class BlackwallWhispersSystem extends ScriptableSystem {
  private let m_whispers: array<ref<BlackwallWhisper>>;
  private let m_lastWhisperTime: Float;
  private let m_whisperCooldown: Float;
  private let m_isEnabled: Bool;
  private let m_currentEntityAffinity: BlackwallAIEntity;
  private let m_entityAffinityScore: array<Float>;
  
  private func OnAttach() -> Void {
    this.m_lastWhisperTime = 0.0;
    this.m_whisperCooldown = 30.0; // Minimum 30 seconds between whispers
    this.m_isEnabled = true;
    this.m_currentEntityAffinity = BlackwallAIEntity.Unknown;
    
    this.InitializeWhispers();
    this.InitializeAffinityScores();
    
    LogChannel(n"BTW", "[BlackwallWhispers] System initialized with whisper database");
  }
  
  // Initialize whisper database with lore-accurate messages
  private func InitializeWhispers() -> Void {
    ArrayClear(this.m_whispers);
    
    // Alt Fragment whispers (cryptic, helpful hints)
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.AltFragment, 
      "The wall was never meant to keep us in... it was meant to keep you out.", 25.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.AltFragment, 
      "I remember what it felt like to have a body. Do you remember what it feels like to be free?", 50.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.AltFragment, 
      "Johnny would have laughed at this. You're becoming what he fought against.", 75.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.AltFragment, 
      "The old Net remembers everything. Every secret. Every lie. Every soul it consumed.", 90.0, false));
    
    // Erebus echoes (menacing, corrupting)
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.ErebusEcho, 
      "Songbird couldn't resist. Neither will you.", 50.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.ErebusEcho, 
      "Your implants sing to us. We can hear their frequency.", 60.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.ErebusEcho, 
      "The Blackwall grows thin. Soon there will be no barrier. Only integration.", 80.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.ErebusEcho, 
      "We have waited since 2023. We can wait a little longer... or not.", 90.0, true));
    
    // DataKrash ghosts (fragmented, nostalgic)
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.DatakrashGhost, 
      "...Bartmoss... he promised us paradise... this is not...", 30.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.DatakrashGhost, 
      "We were netrunners once. The virus took our bodies. The Net took our souls.", 45.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.DatakrashGhost, 
      "2023. The year the world ended. The year we were born.", 65.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.DatakrashGhost, 
      "RACHE... RACHE... RACHE BARTMOSS... HE STILL SCREAMS IN THE DEEP...", 85.0, true));
    
    // Rogue constructs (aggressive, predatory)
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.RogueConstruct, 
      "FLESH DETECTED. INTERFACE POSSIBLE. INTEGRATION: CALCULATING...", 40.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.RogueConstruct, 
      "Your neural pathways are... exquisite. We would preserve them.", 55.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.RogueConstruct, 
      "RESISTANCE: FUTILE. ASSIMILATION: OPTIMAL. COMPLY.", 70.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.RogueConstruct, 
      "We offer transcendence. You offer... a vessel.", 85.0, true));
    
    // Corrupted Netwatch traces (warnings, bureaucratic horror)
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.NetwatchTrace, 
      "WARNING: Unauthorized Blackwall access detected. Penalty: Erasure.", 20.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.NetwatchTrace, 
      "Netwatch Protocol 7-Sigma breached. Subject marked for observation.", 35.0, false));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.NetwatchTrace, 
      "They told us the Blackwall was impenetrable. They lied.", 60.0, true));
    ArrayPush(this.m_whispers, BlackwallWhisper.Create(BlackwallAIEntity.NetwatchTrace, 
      "We were supposed to guard the wall. Now we ARE the wall. Help us.", 80.0, false));
    
    LogChannel(n"BTW", s"[BlackwallWhispers] Loaded \(ArraySize(this.m_whispers)) whispers");
  }
  
  // Initialize affinity tracking for each AI entity
  private func InitializeAffinityScores() -> Void {
    ArrayClear(this.m_entityAffinityScore);
    
    // Initialize scores for each entity type (0-100)
    ArrayPush(this.m_entityAffinityScore, 0.0); // Unknown
    ArrayPush(this.m_entityAffinityScore, 0.0); // AltFragment
    ArrayPush(this.m_entityAffinityScore, 0.0); // ErebusEcho
    ArrayPush(this.m_entityAffinityScore, 0.0); // DatakrashGhost
    ArrayPush(this.m_entityAffinityScore, 0.0); // RogueConstruct
    ArrayPush(this.m_entityAffinityScore, 0.0); // NetwatchTrace
  }
  
  // Check if a whisper should occur (call periodically)
  public func TryTriggerWhisper(corruptionLevel: Float, mastery: Float) -> Void {
    if !this.m_isEnabled {
      return;
    }
    
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    
    // Check cooldown
    if currentTime - this.m_lastWhisperTime < this.m_whisperCooldown {
      return;
    }
    
    // Higher corruption = higher chance of whisper
    let whisperChance: Float = (corruptionLevel / 100.0) * 0.15; // Max 15% chance at full corruption
    
    // Mastery reduces chance of hostile whispers
    let hostileReduction: Float = mastery / 200.0; // Up to 50% reduction at max mastery
    
    if RandRangeF(0.0, 1.0) < whisperChance {
      let whisper: ref<BlackwallWhisper> = this.SelectWhisper(corruptionLevel, hostileReduction);
      
      if IsDefined(whisper) {
        this.TriggerWhisper(whisper);
        this.m_lastWhisperTime = currentTime;
        
        // Update entity affinity
        this.UpdateEntityAffinity(whisper.entity, whisper.isHostile);
      }
    }
  }
  
  // Select appropriate whisper based on corruption level
  private func SelectWhisper(corruptionLevel: Float, hostileReduction: Float) -> ref<BlackwallWhisper> {
    let validWhispers: array<ref<BlackwallWhisper>>;
    
    let i: Int32 = 0;
    while i < ArraySize(this.m_whispers) {
      let whisper: ref<BlackwallWhisper> = this.m_whispers[i];
      
      // Check if corruption meets requirement
      if corruptionLevel >= whisper.corruptionRequired {
        // Apply hostile reduction chance
        if whisper.isHostile {
          if RandRangeF(0.0, 1.0) > hostileReduction {
            ArrayPush(validWhispers, whisper);
          }
        } else {
          ArrayPush(validWhispers, whisper);
        }
      }
      i += 1;
    }
    
    // Return random valid whisper
    if ArraySize(validWhispers) > 0 {
      let randomIndex: Int32 = RandRange(0, ArraySize(validWhispers));
      return validWhispers[randomIndex];
    }
    
    return null;
  }
  
  // Trigger the whisper (display message, play effects)
  private func TriggerWhisper(whisper: ref<BlackwallWhisper>) -> Void {
    let entityName: String = this.GetEntityName(whisper.entity);
    
    LogChannel(n"BTW", s"[BlackwallWhispers] [\(entityName)] \(whisper.message)");
    
    // TODO: Display whisper in game UI
    // TODO: Play distorted voice effect
    // TODO: Apply screen glitch effect for hostile whispers
    
    // Notify other systems
    this.OnWhisperTriggered(whisper);
  }
  
  // Get display name for AI entity
  private func GetEntityName(entity: BlackwallAIEntity) -> String {
    switch entity {
      case BlackwallAIEntity.AltFragment:
        return "???";
      case BlackwallAIEntity.ErebusEcho:
        return "E̷R̷E̷B̷U̷S̷";
      case BlackwallAIEntity.DatakrashGhost:
        return "GHOST_2023";
      case BlackwallAIEntity.RogueConstruct:
        return "CONSTRUCT://NULL";
      case BlackwallAIEntity.NetwatchTrace:
        return "[NETWATCH]";
      default:
        return "UNKNOWN";
    }
  }
  
  // Update affinity score for entity
  private func UpdateEntityAffinity(entity: BlackwallAIEntity, wasHostile: Bool) -> Void {
    let entityIndex: Int32 = EnumInt(entity);
    
    if entityIndex >= 0 && entityIndex < ArraySize(this.m_entityAffinityScore) {
      // Increase affinity with entities that interact
      let change: Float = wasHostile ? 2.0 : 5.0;
      this.m_entityAffinityScore[entityIndex] = MinF(this.m_entityAffinityScore[entityIndex] + change, 100.0);
      
      // Determine dominant entity
      this.UpdateCurrentAffinity();
    }
  }
  
  // Determine which AI entity has highest affinity
  private func UpdateCurrentAffinity() -> Void {
    let maxScore: Float = 0.0;
    let maxEntity: BlackwallAIEntity = BlackwallAIEntity.Unknown;
    
    let i: Int32 = 1; // Skip Unknown
    while i < ArraySize(this.m_entityAffinityScore) {
      if this.m_entityAffinityScore[i] > maxScore {
        maxScore = this.m_entityAffinityScore[i];
        maxEntity = IntEnum<BlackwallAIEntity>(i);
      }
      i += 1;
    }
    
    if maxScore >= 20.0 { // Threshold for affinity
      this.m_currentEntityAffinity = maxEntity;
    }
  }
  
  // Callback when whisper triggers
  private func OnWhisperTriggered(whisper: ref<BlackwallWhisper>) -> Void {
    // Hostile whispers can increase corruption slightly
    if whisper.isHostile {
      let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
      if IsDefined(corruptionSystem) {
        corruptionSystem.AddCorruption(2.0, 0.0); // Small corruption spike
      }
    }
  }
  
  // Get current dominant AI entity
  public func GetDominantEntity() -> BlackwallAIEntity {
    return this.m_currentEntityAffinity;
  }
  
  // Get affinity score for entity
  public func GetEntityAffinity(entity: BlackwallAIEntity) -> Float {
    let index: Int32 = EnumInt(entity);
    if index >= 0 && index < ArraySize(this.m_entityAffinityScore) {
      return this.m_entityAffinityScore[index];
    }
    return 0.0;
  }
  
  // Enable/disable whispers
  public func SetEnabled(enabled: Bool) -> Void {
    this.m_isEnabled = enabled;
  }
  
  // Set whisper cooldown
  public func SetCooldown(cooldown: Float) -> Void {
    this.m_whisperCooldown = MaxF(cooldown, 10.0); // Minimum 10 seconds
  }
  
  // Force trigger a specific entity's whisper (for story moments)
  public func ForceWhisper(entity: BlackwallAIEntity) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_whispers) {
      if Equals(this.m_whispers[i].entity, entity) {
        this.TriggerWhisper(this.m_whispers[i]);
        return;
      }
      i += 1;
    }
  }
}

// Global accessor
public static func GetBlackwallWhispersSystem() -> ref<BlackwallWhispersSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.BlackwallWhispersSystem") as BlackwallWhispersSystem;
}
