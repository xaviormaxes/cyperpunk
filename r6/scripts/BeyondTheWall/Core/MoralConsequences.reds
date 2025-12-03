// MoralConsequences.reds
// Tracks player choices and determines consequences/endings
module BeyondTheWall.Core

import Codeware.*

// Player alignment towards AI cooperation vs resistance
public enum BlackwallAlignment {
  Neutral = 0,
  Resistant = 1,     // Fights against AI influence
  Cooperative = 2,   // Works with AI entities
  Symbiotic = 3,     // Full integration with Blackwall
  Corrupted = 4      // Lost to corruption
}

// Choice types that affect alignment
public enum BlackwallChoiceType {
  None = 0,
  UseBlackwallPower = 1,    // Using Blackwall abilities
  ResistCorruption = 2,     // Stabilizing, cleansing
  HelpAI = 3,               // Aiding AI entities
  DestroyAI = 4,            // Destroying AI entities
  AcceptWhisper = 5,        // Following AI guidance
  RejectWhisper = 6,        // Ignoring AI guidance
  SavePossessed = 7,        // Freeing possessed NPCs
  ExploitPossessed = 8      // Using possessed NPCs
}

// NPC reaction data
public class NPCReactionData {
  public let npcID: EntityID;
  public let reactionLevel: Int32; // -100 to 100
  public let lastReactionTime: Float;
}

// Main moral consequences system
public class MoralConsequencesSystem extends ScriptableSystem {
  private let m_cooperationScore: Float;     // -100 (resistance) to 100 (cooperation)
  private let m_choiceHistory: array<BlackwallChoiceType>;
  private let m_npcReactions: array<ref<NPCReactionData>>;
  private let m_currentAlignment: BlackwallAlignment;
  private let m_isMarkedByNetwatch: Bool;
  private let m_aiTrustLevel: Float;
  
  private func OnAttach() -> Void {
    this.m_cooperationScore = 0.0;
    ArrayClear(this.m_choiceHistory);
    ArrayClear(this.m_npcReactions);
    this.m_currentAlignment = BlackwallAlignment.Neutral;
    this.m_isMarkedByNetwatch = false;
    this.m_aiTrustLevel = 0.0;
    
    LogChannel(n"BTW", "[MoralConsequences] System initialized");
  }
  
  // Record a choice
  public func RecordChoice(choiceType: BlackwallChoiceType) -> Void {
    ArrayPush(this.m_choiceHistory, choiceType);
    
    // Keep only last 100 choices
    while ArraySize(this.m_choiceHistory) > 100 {
      ArrayErase(this.m_choiceHistory, 0);
    }
    
    // Update scores based on choice
    this.UpdateScoresFromChoice(choiceType);
    
    // Update alignment
    this.UpdateAlignment();
    
    LogChannel(n"BTW", s"[MoralConsequences] Choice recorded: \(EnumInt(choiceType))");
  }
  
  // Update scores based on choice type
  private func UpdateScoresFromChoice(choiceType: BlackwallChoiceType) -> Void {
    switch choiceType {
      case BlackwallChoiceType.UseBlackwallPower:
        this.m_cooperationScore += 2.0;
        this.m_aiTrustLevel += 1.0;
        break;
      case BlackwallChoiceType.ResistCorruption:
        this.m_cooperationScore -= 3.0;
        break;
      case BlackwallChoiceType.HelpAI:
        this.m_cooperationScore += 10.0;
        this.m_aiTrustLevel += 5.0;
        break;
      case BlackwallChoiceType.DestroyAI:
        this.m_cooperationScore -= 10.0;
        this.m_aiTrustLevel -= 5.0;
        break;
      case BlackwallChoiceType.AcceptWhisper:
        this.m_cooperationScore += 5.0;
        this.m_aiTrustLevel += 3.0;
        break;
      case BlackwallChoiceType.RejectWhisper:
        this.m_cooperationScore -= 5.0;
        break;
      case BlackwallChoiceType.SavePossessed:
        this.m_cooperationScore -= 2.0;
        break;
      case BlackwallChoiceType.ExploitPossessed:
        this.m_cooperationScore += 5.0;
        this.m_aiTrustLevel += 2.0;
        break;
    }
    
    // Clamp values
    this.m_cooperationScore = ClampF(this.m_cooperationScore, -100.0, 100.0);
    this.m_aiTrustLevel = ClampF(this.m_aiTrustLevel, 0.0, 100.0);
    
    // Check for NetWatch attention
    if this.m_cooperationScore >= 50.0 && !this.m_isMarkedByNetwatch {
      this.OnNetwatchAlert();
    }
  }
  
  // Update current alignment based on scores
  private func UpdateAlignment() -> Void {
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    let corruptionLevel: Float = 0.0;
    
    if IsDefined(corruptionSystem) {
      corruptionLevel = corruptionSystem.GetCorruptionLevel();
    }
    
    // Check for corruption override first
    if corruptionLevel >= 95.0 && this.m_cooperationScore >= 50.0 {
      this.m_currentAlignment = BlackwallAlignment.Corrupted;
    } else if this.m_cooperationScore >= 75.0 && this.m_aiTrustLevel >= 75.0 {
      this.m_currentAlignment = BlackwallAlignment.Symbiotic;
    } else if this.m_cooperationScore >= 25.0 {
      this.m_currentAlignment = BlackwallAlignment.Cooperative;
    } else if this.m_cooperationScore <= -25.0 {
      this.m_currentAlignment = BlackwallAlignment.Resistant;
    } else {
      this.m_currentAlignment = BlackwallAlignment.Neutral;
    }
  }
  
  // Called when NetWatch notices the player's activities
  private func OnNetwatchAlert() -> Void {
    this.m_isMarkedByNetwatch = true;
    LogChannel(n"BTW", "[MoralConsequences] NETWATCH ALERT - Player marked for observation");
    
    // This could trigger:
    // - NetWatch agents appearing
    // - Blackmail opportunities
    // - Quest hooks
  }
  
  // Update NPC reaction to player
  public func UpdateNPCReaction(npcID: EntityID, change: Int32) -> Void {
    let existingIndex: Int32 = this.FindNPCReactionIndex(npcID);
    
    if existingIndex >= 0 {
      let reaction: ref<NPCReactionData> = this.m_npcReactions[existingIndex];
      reaction.reactionLevel = Clamp(reaction.reactionLevel + change, -100, 100);
      reaction.lastReactionTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    } else {
      let newReaction = new NPCReactionData();
      newReaction.npcID = npcID;
      newReaction.reactionLevel = Clamp(change, -100, 100);
      newReaction.lastReactionTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
      ArrayPush(this.m_npcReactions, newReaction);
    }
  }
  
  // Find NPC reaction index
  private func FindNPCReactionIndex(npcID: EntityID) -> Int32 {
    let i: Int32 = 0;
    while i < ArraySize(this.m_npcReactions) {
      if Equals(this.m_npcReactions[i].npcID, npcID) {
        return i;
      }
      i += 1;
    }
    return -1;
  }
  
  // Get NPC reaction level
  public func GetNPCReaction(npcID: EntityID) -> Int32 {
    let index: Int32 = this.FindNPCReactionIndex(npcID);
    if index >= 0 {
      return this.m_npcReactions[index].reactionLevel;
    }
    
    // Default reaction based on corruption visibility
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if IsDefined(corruptionSystem) {
      let corruption: Float = corruptionSystem.GetCorruptionLevel();
      if corruption >= 75.0 {
        return -30; // NPCs are uneasy around highly corrupted player
      } else if corruption >= 50.0 {
        return -10;
      }
    }
    
    return 0;
  }
  
  // Check if NPC will react negatively to player
  public func WillNPCReactNegatively(npcID: EntityID) -> Bool {
    return this.GetNPCReaction(npcID) <= -50;
  }
  
  // Get current alignment
  public func GetAlignment() -> BlackwallAlignment {
    return this.m_currentAlignment;
  }
  
  // Get cooperation score
  public func GetCooperationScore() -> Float {
    return this.m_cooperationScore;
  }
  
  // Get AI trust level
  public func GetAITrustLevel() -> Float {
    return this.m_aiTrustLevel;
  }
  
  // Check if marked by NetWatch
  public func IsMarkedByNetwatch() -> Bool {
    return this.m_isMarkedByNetwatch;
  }
  
  // Get alignment description
  public func GetAlignmentDescription() -> String {
    switch this.m_currentAlignment {
      case BlackwallAlignment.Corrupted:
        return "Lost to the Blackwall";
      case BlackwallAlignment.Symbiotic:
        return "One with the AI";
      case BlackwallAlignment.Cooperative:
        return "AI Ally";
      case BlackwallAlignment.Resistant:
        return "Blackwall Resistant";
      default:
        return "Neutral";
    }
  }
  
  // Get ending hint based on current state
  public func GetEndingHint() -> String {
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();
    let mastery: Float = 0.0;
    if IsDefined(masterySystem) {
      mastery = masterySystem.GetMastery();
    }
    
    switch this.m_currentAlignment {
      case BlackwallAlignment.Corrupted:
        return "The Old Net calls. There is no escape.";
      case BlackwallAlignment.Symbiotic:
        if mastery >= 80.0 {
          return "Perfect harmony between flesh and code. A new kind of existence awaits.";
        } else {
          return "The bond grows stronger. Master your power or be consumed.";
        }
      case BlackwallAlignment.Cooperative:
        return "The AI entities see you as an ally. This path leads to symbiosis... or destruction.";
      case BlackwallAlignment.Resistant:
        if mastery >= 50.0 {
          return "You use their power but reject their influence. A dangerous balance.";
        } else {
          return "The Blackwall's gifts come with strings attached. Be careful.";
        }
      default:
        return "Your path is not yet set. Every choice matters.";
    }
  }
  
  // Calculate ending variation (0-100, affects final mission/cutscene)
  public func CalculateEndingVariation() -> Int32 {
    let base: Int32 = 50; // Neutral
    
    // Cooperation shifts ending towards AI integration
    base += RoundF(this.m_cooperationScore / 2.0);
    
    // High mastery allows for better outcomes in either direction
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();
    if IsDefined(masterySystem) {
      let mastery: Float = masterySystem.GetMastery();
      if mastery >= 80.0 {
        base += 10; // More options available
      }
    }
    
    // NetWatch attention affects ending
    if this.m_isMarkedByNetwatch {
      base -= 5; // Complications
    }
    
    return Clamp(base, 0, 100);
  }
  
  // Serialize for saving
  public func Serialize() -> array<Float> {
    let data: array<Float>;
    ArrayPush(data, this.m_cooperationScore);
    ArrayPush(data, this.m_aiTrustLevel);
    ArrayPush(data, this.m_isMarkedByNetwatch ? 1.0 : 0.0);
    ArrayPush(data, Cast<Float>(EnumInt(this.m_currentAlignment)));
    return data;
  }
  
  // Deserialize from save
  public func Deserialize(data: array<Float>) -> Void {
    if ArraySize(data) >= 4 {
      this.m_cooperationScore = data[0];
      this.m_aiTrustLevel = data[1];
      this.m_isMarkedByNetwatch = data[2] > 0.0;
      this.m_currentAlignment = IntEnum<BlackwallAlignment>(RoundF(data[3]));
    }
  }
}

// Global accessor
public static func GetMoralConsequencesSystem() -> ref<MoralConsequencesSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.MoralConsequencesSystem") as MoralConsequencesSystem;
}
