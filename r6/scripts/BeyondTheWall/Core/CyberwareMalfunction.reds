// CyberwareMalfunction.reds
// Cyberware integration with corruption - high-end implants become liabilities
module BeyondTheWall.Core

import Codeware.*

// Types of cyberware malfunctions
public enum CyberwareMalfunctionType {
  None = 0,
  Glitch = 1,           // Visual/audio interference only
  Reduced = 2,          // Reduced effectiveness
  Disabled = 3,         // Temporarily disabled
  Hijacked = 4,         // AI takes control briefly
  Overload = 5          // Damages the user
}

// Cyberware vulnerability categories
public enum CyberwareVulnerability {
  Low = 0,              // Basic implants - resistant
  Medium = 1,           // Standard implants
  High = 2,             // Advanced implants - very vulnerable
  Shielded = 3          // Special Blackwall-resistant gear
}

// Malfunction record
public class CyberwareMalfunctionRecord {
  public let type: CyberwareMalfunctionType;
  public let cyberwareName: CName;
  public let duration: Float;
  public let startTime: Float;
}

// Main cyberware malfunction system
public class CyberwareMalfunctionSystem extends ScriptableSystem {
  private let m_activeMalfunctions: array<ref<CyberwareMalfunctionRecord>>;
  private let m_lastCheckTime: Float;
  private let m_checkInterval: Float;
  private let m_isEnabled: Bool;
  private let m_malfunctionHistory: Int32;
  
  private func OnAttach() -> Void {
    ArrayClear(this.m_activeMalfunctions);
    this.m_lastCheckTime = 0.0;
    this.m_checkInterval = 5.0; // Check every 5 seconds
    this.m_isEnabled = true;
    this.m_malfunctionHistory = 0;
    
    LogChannel(n"BTW", "[CyberwareMalfunction] System initialized");
  }
  
  // Update system
  public func Update(deltaTime: Float, corruptionLevel: Float, mastery: Float) -> Void {
    if !this.m_isEnabled {
      return;
    }
    
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    
    // Check for new malfunctions
    if currentTime - this.m_lastCheckTime >= this.m_checkInterval {
      this.CheckForMalfunctions(corruptionLevel, mastery);
      this.m_lastCheckTime = currentTime;
    }
    
    // Update active malfunctions
    this.UpdateActiveMalfunctions(currentTime);
  }
  
  // Check if any cyberware should malfunction
  private func CheckForMalfunctions(corruptionLevel: Float, mastery: Float) -> Void {
    // Only check at medium corruption or higher
    if corruptionLevel < 50.0 {
      return;
    }
    
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }
    
    // Get cyberware vulnerability
    let vulnerability: CyberwareVulnerability = this.GetOverallVulnerability(player);
    
    // Calculate malfunction chance
    let baseChance: Float = this.GetBaseChance(corruptionLevel, vulnerability);
    
    // Mastery reduces chance
    let masteryReduction: Float = mastery / 200.0; // Up to 50% reduction
    let finalChance: Float = baseChance * (1.0 - masteryReduction);
    
    // During Blackwall pulse, increase chance
    let eventsSystem: ref<BlackwallEventsSystem> = GetBlackwallEventsSystem();
    if IsDefined(eventsSystem) && eventsSystem.IsPulseActive() {
      finalChance *= 1.5;
    }
    
    if RandRangeF(0.0, 1.0) < finalChance {
      this.TriggerRandomMalfunction(player, corruptionLevel);
    }
  }
  
  // Get base malfunction chance
  private func GetBaseChance(corruptionLevel: Float, vulnerability: CyberwareVulnerability) -> Float {
    let baseChance: Float = (corruptionLevel - 50.0) / 500.0; // 0% at 50, 10% at 100
    
    switch vulnerability {
      case CyberwareVulnerability.Low:
        return baseChance * 0.25;
      case CyberwareVulnerability.Medium:
        return baseChance * 0.5;
      case CyberwareVulnerability.High:
        return baseChance * 1.0;
      case CyberwareVulnerability.Shielded:
        return baseChance * 0.1;
      default:
        return baseChance;
    }
  }
  
  // Determine overall cyberware vulnerability based on equipped items
  private func GetOverallVulnerability(player: ref<PlayerPuppet>) -> CyberwareVulnerability {
    // Check for shielded cyberware first
    if this.HasShieldedCyberware(player) {
      return CyberwareVulnerability.Shielded;
    }
    
    // Check for high-end cyberware that increases vulnerability
    if this.HasHighEndCyberware(player) {
      return CyberwareVulnerability.High;
    }
    
    // Default to medium
    return CyberwareVulnerability.Medium;
  }
  
  // Check for Blackwall-shielded cyberware
  private func HasShieldedCyberware(player: ref<PlayerPuppet>) -> Bool {
    // TODO: Check for specific shielded items
    // These would be special items from the mod
    return false;
  }
  
  // Check for high-end vulnerable cyberware
  private func HasHighEndCyberware(player: ref<PlayerPuppet>) -> Bool {
    // TODO: Check for Sandevistan, Berserk, high-tier Cyberdecks
    // These are more connected to the Net and thus more vulnerable
    return true; // Assume most players have high-end gear
  }
  
  // Trigger a random malfunction
  private func TriggerRandomMalfunction(player: ref<PlayerPuppet>, corruptionLevel: Float) -> Void {
    let malfunctionType: CyberwareMalfunctionType = this.SelectMalfunctionType(corruptionLevel);
    let cyberwareName: CName = this.SelectAffectedCyberware(player);
    
    if Equals(malfunctionType, CyberwareMalfunctionType.None) {
      return;
    }
    
    this.ExecuteMalfunction(player, malfunctionType, cyberwareName);
    this.m_malfunctionHistory += 1;
  }
  
  // Select malfunction type based on corruption
  private func SelectMalfunctionType(corruptionLevel: Float) -> CyberwareMalfunctionType {
    let roll: Int32 = RandRange(0, 100);
    
    if corruptionLevel >= 90.0 {
      // Critical - dangerous malfunctions
      if roll < 15 { return CyberwareMalfunctionType.Overload; }
      if roll < 35 { return CyberwareMalfunctionType.Hijacked; }
      if roll < 55 { return CyberwareMalfunctionType.Disabled; }
      if roll < 80 { return CyberwareMalfunctionType.Reduced; }
      return CyberwareMalfunctionType.Glitch;
    } else if corruptionLevel >= 75.0 {
      // High corruption
      if roll < 10 { return CyberwareMalfunctionType.Hijacked; }
      if roll < 30 { return CyberwareMalfunctionType.Disabled; }
      if roll < 60 { return CyberwareMalfunctionType.Reduced; }
      return CyberwareMalfunctionType.Glitch;
    } else {
      // Moderate corruption
      if roll < 20 { return CyberwareMalfunctionType.Disabled; }
      if roll < 50 { return CyberwareMalfunctionType.Reduced; }
      return CyberwareMalfunctionType.Glitch;
    }
  }
  
  // Select which cyberware is affected
  private func SelectAffectedCyberware(player: ref<PlayerPuppet>) -> CName {
    // Priority targets for AI interference:
    let cyberwareOptions: array<CName>;
    
    // Most vulnerable to Blackwall
    ArrayPush(cyberwareOptions, n"Sandevistan");
    ArrayPush(cyberwareOptions, n"Berserk");
    ArrayPush(cyberwareOptions, n"Cyberdeck");
    ArrayPush(cyberwareOptions, n"Kiroshi");
    ArrayPush(cyberwareOptions, n"Monowire");
    ArrayPush(cyberwareOptions, n"Mantis Blades");
    ArrayPush(cyberwareOptions, n"Gorilla Arms");
    
    let randomIndex: Int32 = RandRange(0, ArraySize(cyberwareOptions));
    return cyberwareOptions[randomIndex];
  }
  
  // Execute the malfunction
  private func ExecuteMalfunction(player: ref<PlayerPuppet>, malfunctionType: CyberwareMalfunctionType, cyberwareName: CName) -> Void {
    let duration: Float = this.GetMalfunctionDuration(malfunctionType);
    
    // Create record
    let record = new CyberwareMalfunctionRecord();
    record.type = malfunctionType;
    record.cyberwareName = cyberwareName;
    record.duration = duration;
    record.startTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    ArrayPush(this.m_activeMalfunctions, record);
    
    LogChannel(n"BTW", s"[CyberwareMalfunction] \(ToString(cyberwareName)) - Type: \(EnumInt(malfunctionType)) for \(duration)s");
    
    // Apply effects
    switch malfunctionType {
      case CyberwareMalfunctionType.Glitch:
        this.ApplyGlitchEffect(player);
        break;
      case CyberwareMalfunctionType.Reduced:
        this.ApplyReducedEffect(player, cyberwareName);
        break;
      case CyberwareMalfunctionType.Disabled:
        this.ApplyDisabledEffect(player, cyberwareName);
        break;
      case CyberwareMalfunctionType.Hijacked:
        this.ApplyHijackedEffect(player, cyberwareName);
        break;
      case CyberwareMalfunctionType.Overload:
        this.ApplyOverloadEffect(player);
        break;
    }
    
    // Trigger whisper about the malfunction
    let whispersSystem: ref<BlackwallWhispersSystem> = GetBlackwallWhispersSystem();
    if IsDefined(whispersSystem) && Equals(malfunctionType, CyberwareMalfunctionType.Hijacked) {
      whispersSystem.ForceWhisper(BlackwallAIEntity.RogueConstruct);
    }
  }
  
  // Get duration for malfunction type
  private func GetMalfunctionDuration(malfunctionType: CyberwareMalfunctionType) -> Float {
    switch malfunctionType {
      case CyberwareMalfunctionType.Glitch:
        return RandRangeF(1.0, 3.0);
      case CyberwareMalfunctionType.Reduced:
        return RandRangeF(5.0, 15.0);
      case CyberwareMalfunctionType.Disabled:
        return RandRangeF(3.0, 8.0);
      case CyberwareMalfunctionType.Hijacked:
        return RandRangeF(2.0, 5.0);
      case CyberwareMalfunctionType.Overload:
        return 1.0; // Instant damage
      default:
        return 0.0;
    }
  }
  
  // Apply glitch effect (visual/audio only)
  private func ApplyGlitchEffect(player: ref<PlayerPuppet>) -> Void {
    // TODO: Screen glitch effect
    // TODO: Audio static
    LogChannel(n"BTW", "[CyberwareMalfunction] Glitch effect applied");
  }
  
  // Apply reduced effectiveness
  private func ApplyReducedEffect(player: ref<PlayerPuppet>, cyberwareName: CName) -> Void {
    // TODO: Apply stat modifier to reduce cyberware effectiveness
    LogChannel(n"BTW", s"[CyberwareMalfunction] \(ToString(cyberwareName)) operating at reduced capacity");
  }
  
  // Apply disabled effect
  private func ApplyDisabledEffect(player: ref<PlayerPuppet>, cyberwareName: CName) -> Void {
    // TODO: Temporarily disable the cyberware
    LogChannel(n"BTW", s"[CyberwareMalfunction] \(ToString(cyberwareName)) DISABLED");
  }
  
  // Apply hijacked effect (AI takes brief control)
  private func ApplyHijackedEffect(player: ref<PlayerPuppet>, cyberwareName: CName) -> Void {
    // TODO: Trigger cyberware against player's will
    // - Sandevistan activates randomly
    // - Kiroshi shows corrupted data
    // - Cyberdeck targets wrong enemy
    LogChannel(n"BTW", s"[CyberwareMalfunction] \(ToString(cyberwareName)) HIJACKED BY AI");
    
    // This is scary - add corruption
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if IsDefined(corruptionSystem) {
      corruptionSystem.AddCorruption(5.0, 0.0);
    }
  }
  
  // Apply overload effect (damage)
  private func ApplyOverloadEffect(player: ref<PlayerPuppet>) -> Void {
    // TODO: Deal damage to player
    // TODO: Strong visual feedback
    LogChannel(n"BTW", "[CyberwareMalfunction] CYBERWARE OVERLOAD - TAKING DAMAGE");
  }
  
  // Update active malfunctions
  private func UpdateActiveMalfunctions(currentTime: Float) -> Void {
    let i: Int32 = ArraySize(this.m_activeMalfunctions) - 1;
    
    while i >= 0 {
      let record: ref<CyberwareMalfunctionRecord> = this.m_activeMalfunctions[i];
      
      if currentTime >= record.startTime + record.duration {
        // Malfunction ended
        this.EndMalfunction(record);
        ArrayErase(this.m_activeMalfunctions, i);
      }
      
      i -= 1;
    }
  }
  
  // End a malfunction
  private func EndMalfunction(record: ref<CyberwareMalfunctionRecord>) -> Void {
    LogChannel(n"BTW", s"[CyberwareMalfunction] \(ToString(record.cyberwareName)) restored");
    // TODO: Remove stat modifiers
    // TODO: Re-enable cyberware
  }
  
  // Check if specific cyberware is malfunctioning
  public func IsMalfunctioning(cyberwareName: CName) -> Bool {
    let i: Int32 = 0;
    while i < ArraySize(this.m_activeMalfunctions) {
      if Equals(this.m_activeMalfunctions[i].cyberwareName, cyberwareName) {
        return true;
      }
      i += 1;
    }
    return false;
  }
  
  // Get current malfunction type for cyberware
  public func GetMalfunctionType(cyberwareName: CName) -> CyberwareMalfunctionType {
    let i: Int32 = 0;
    while i < ArraySize(this.m_activeMalfunctions) {
      if Equals(this.m_activeMalfunctions[i].cyberwareName, cyberwareName) {
        return this.m_activeMalfunctions[i].type;
      }
      i += 1;
    }
    return CyberwareMalfunctionType.None;
  }
  
  // Get total malfunction count (for consequences)
  public func GetMalfunctionHistory() -> Int32 {
    return this.m_malfunctionHistory;
  }
  
  // Enable/disable system
  public func SetEnabled(enabled: Bool) -> Void {
    this.m_isEnabled = enabled;
  }
  
  // Force a specific malfunction (for quests/debug)
  public func ForceMalfunction(cyberwareName: CName, malfunctionType: CyberwareMalfunctionType) -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if IsDefined(player) {
      this.ExecuteMalfunction(player, malfunctionType, cyberwareName);
    }
  }
}

// Global accessor
public static func GetCyberwareMalfunctionSystem() -> ref<CyberwareMalfunctionSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.CyberwareMalfunctionSystem") as CyberwareMalfunctionSystem;
}
