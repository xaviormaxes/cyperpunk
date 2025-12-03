// BlackwallEvents.reds
// Random Blackwall pulse events and reality glitches in the open world
module BeyondTheWall.Core

import Codeware.*

// Types of Blackwall events
public enum BlackwallEventType {
  None = 0,
  BlackwallPulse = 1,      // Barrier weakens temporarily
  RealityGlitch = 2,       // Visual/audio distortion
  NPCPossession = 3,       // Nearby NPC briefly possessed
  DeviceMalfunction = 4,   // Electronics go haywire
  ThinSpotDiscovered = 5,  // Permanent weak point found
  AIManifest = 6           // Brief AI entity appearance
}

// Event severity levels
public enum BlackwallEventSeverity {
  Minor = 0,    // Subtle, easily missed
  Moderate = 1, // Noticeable effects
  Major = 2,    // Significant impact
  Critical = 3  // Dangerous, unmissable
}

// Thin spot location data
public class BlackwallThinSpot {
  public let position: Vector4;
  public let name: String;
  public let passiveCorruption: Float;
  public let isDiscovered: Bool;
  
  public static func Create(pos: Vector4, spotName: String, corruption: Float) -> ref<BlackwallThinSpot> {
    let spot = new BlackwallThinSpot();
    spot.position = pos;
    spot.name = spotName;
    spot.passiveCorruption = corruption;
    spot.isDiscovered = false;
    return spot;
  }
}

// Event record for tracking
public class BlackwallEventRecord {
  public let eventType: BlackwallEventType;
  public let severity: BlackwallEventSeverity;
  public let timestamp: Float;
  public let position: Vector4;
}

// Main events system
public class BlackwallEventsSystem extends ScriptableSystem {
  private let m_thinSpots: array<ref<BlackwallThinSpot>>;
  private let m_eventHistory: array<ref<BlackwallEventRecord>>;
  private let m_lastEventTime: Float;
  private let m_eventCooldown: Float;
  private let m_isEnabled: Bool;
  private let m_currentPulseActive: Bool;
  private let m_pulseEndTime: Float;
  
  private func OnAttach() -> Void {
    this.m_lastEventTime = 0.0;
    this.m_eventCooldown = 60.0; // 1 minute between random events
    this.m_isEnabled = true;
    this.m_currentPulseActive = false;
    this.m_pulseEndTime = 0.0;
    
    this.InitializeThinSpots();
    ArrayClear(this.m_eventHistory);
    
    LogChannel(n"BTW", "[BlackwallEvents] System initialized");
  }
  
  // Initialize known thin spots in Night City
  private func InitializeThinSpots() -> Void {
    ArrayClear(this.m_thinSpots);
    
    // Konpeki Plaza - Site of the heist, weakened by Arasaka's experiments
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(-1450.0, 1200.0, 120.0, 1.0),
      "Konpeki Plaza Server Room", 0.5));
    
    // Arasaka Tower ruins - Massive Net activity during 2023
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(-1200.0, 900.0, 80.0, 1.0),
      "Arasaka Tower Memorial", 0.8));
    
    // Pacifica - Abandoned NetWatch operations
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(2800.0, -1400.0, 10.0, 1.0),
      "Pacifica Dead Zone", 0.6));
    
    // Charter Hill - Old Militech black site
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(-500.0, 2100.0, 150.0, 1.0),
      "Charter Hill Bunker", 0.4));
    
    // Night City Center - Massive data hub
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(0.0, 0.0, 50.0, 1.0),
      "Central Data Hub", 0.3));
    
    // Dogtown - FIA experiments (Phantom Liberty)
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(-2500.0, 2800.0, 30.0, 1.0),
      "Dogtown Core", 1.0));
    
    // Badlands - Biotechnica research
    ArrayPush(this.m_thinSpots, BlackwallThinSpot.Create(
      new Vector4(3000.0, 2000.0, 5.0, 1.0),
      "Biotechnica Flats Facility", 0.5));
    
    LogChannel(n"BTW", s"[BlackwallEvents] Initialized \(ArraySize(this.m_thinSpots)) thin spots");
  }
  
  // Update system (call from game tick)
  public func Update(deltaTime: Float, playerPosition: Vector4, corruptionLevel: Float) -> Void {
    if !this.m_isEnabled {
      return;
    }
    
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    
    // Check for pulse end
    if this.m_currentPulseActive && currentTime >= this.m_pulseEndTime {
      this.EndBlackwallPulse();
    }
    
    // Check thin spot proximity
    this.CheckThinSpotProximity(playerPosition, corruptionLevel);
    
    // Try random event
    if currentTime - this.m_lastEventTime >= this.m_eventCooldown {
      this.TryTriggerRandomEvent(corruptionLevel, playerPosition);
    }
  }
  
  // Check if player is near any thin spots
  private func CheckThinSpotProximity(playerPos: Vector4, corruptionLevel: Float) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_thinSpots) {
      let spot: ref<BlackwallThinSpot> = this.m_thinSpots[i];
      let distance: Float = Vector4.Distance(playerPos, spot.position);
      
      // Discovery range: 50 meters
      if distance <= 50.0 && !spot.isDiscovered {
        this.DiscoverThinSpot(spot);
      }
      
      // Passive corruption range: 30 meters
      if distance <= 30.0 && spot.isDiscovered {
        this.ApplyThinSpotCorruption(spot, distance);
      }
      
      i += 1;
    }
  }
  
  // Discover a new thin spot
  private func DiscoverThinSpot(spot: ref<BlackwallThinSpot>) -> Void {
    spot.isDiscovered = true;
    
    LogChannel(n"BTW", s"[BlackwallEvents] Thin spot discovered: \(spot.name)");
    
    // Trigger discovery event
    this.TriggerEvent(BlackwallEventType.ThinSpotDiscovered, BlackwallEventSeverity.Moderate, spot.position);
    
    // Award mastery XP for discovery
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();
    if IsDefined(masterySystem) {
      masterySystem.AddExperience(5.0);
    }
  }
  
  // Apply passive corruption from thin spot
  private func ApplyThinSpotCorruption(spot: ref<BlackwallThinSpot>, distance: Float) -> Void {
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();
    
    if !IsDefined(corruptionSystem) {
      return;
    }
    
    let mastery: Float = 0.0;
    if IsDefined(masterySystem) {
      mastery = masterySystem.GetMastery();
    }
    
    // Corruption falls off with distance
    let distanceFactor: Float = 1.0 - (distance / 30.0);
    let corruptionAmount: Float = spot.passiveCorruption * distanceFactor * 0.01; // Per tick
    
    corruptionSystem.AddCorruption(corruptionAmount, mastery);
  }
  
  // Try to trigger a random event
  private func TryTriggerRandomEvent(corruptionLevel: Float, playerPos: Vector4) -> Void {
    // Base chance increases with corruption
    let eventChance: Float = (corruptionLevel / 100.0) * 0.1; // Max 10% chance
    
    // Increase during active pulse
    if this.m_currentPulseActive {
      eventChance *= 2.0;
    }
    
    if RandRangeF(0.0, 1.0) < eventChance {
      let eventType: BlackwallEventType = this.SelectRandomEventType(corruptionLevel);
      let severity: BlackwallEventSeverity = this.DetermineSeverity(corruptionLevel);
      
      this.TriggerEvent(eventType, severity, playerPos);
      this.m_lastEventTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    }
  }
  
  // Select event type based on corruption
  private func SelectRandomEventType(corruptionLevel: Float) -> BlackwallEventType {
    let roll: Int32 = RandRange(0, 100);
    
    if corruptionLevel >= 90.0 {
      // Critical corruption - dangerous events
      if roll < 30 { return BlackwallEventType.AIManifest; }
      if roll < 50 { return BlackwallEventType.NPCPossession; }
      if roll < 70 { return BlackwallEventType.BlackwallPulse; }
      if roll < 85 { return BlackwallEventType.RealityGlitch; }
      return BlackwallEventType.DeviceMalfunction;
    } else if corruptionLevel >= 50.0 {
      // Moderate corruption
      if roll < 20 { return BlackwallEventType.NPCPossession; }
      if roll < 40 { return BlackwallEventType.RealityGlitch; }
      if roll < 70 { return BlackwallEventType.DeviceMalfunction; }
      return BlackwallEventType.BlackwallPulse;
    } else {
      // Low corruption
      if roll < 40 { return BlackwallEventType.DeviceMalfunction; }
      if roll < 70 { return BlackwallEventType.RealityGlitch; }
      return BlackwallEventType.None;
    }
  }
  
  // Determine event severity
  private func DetermineSeverity(corruptionLevel: Float) -> BlackwallEventSeverity {
    let roll: Float = RandRangeF(0.0, 100.0);
    let threshold: Float = corruptionLevel;
    
    if roll < threshold * 0.1 { return BlackwallEventSeverity.Critical; }
    if roll < threshold * 0.3 { return BlackwallEventSeverity.Major; }
    if roll < threshold * 0.6 { return BlackwallEventSeverity.Moderate; }
    return BlackwallEventSeverity.Minor;
  }
  
  // Trigger a specific event
  public func TriggerEvent(eventType: BlackwallEventType, severity: BlackwallEventSeverity, position: Vector4) -> Void {
    if Equals(eventType, BlackwallEventType.None) {
      return;
    }
    
    // Record event
    let record = new BlackwallEventRecord();
    record.eventType = eventType;
    record.severity = severity;
    record.timestamp = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    record.position = position;
    ArrayPush(this.m_eventHistory, record);
    
    // Keep only last 50 events
    while ArraySize(this.m_eventHistory) > 50 {
      ArrayErase(this.m_eventHistory, 0);
    }
    
    LogChannel(n"BTW", s"[BlackwallEvents] Event triggered: \(EnumInt(eventType)) (Severity: \(EnumInt(severity)))");
    
    // Execute event effects
    switch eventType {
      case BlackwallEventType.BlackwallPulse:
        this.ExecuteBlackwallPulse(severity);
        break;
      case BlackwallEventType.RealityGlitch:
        this.ExecuteRealityGlitch(severity);
        break;
      case BlackwallEventType.NPCPossession:
        this.ExecuteNPCPossession(severity, position);
        break;
      case BlackwallEventType.DeviceMalfunction:
        this.ExecuteDeviceMalfunction(severity, position);
        break;
      case BlackwallEventType.AIManifest:
        this.ExecuteAIManifest(severity, position);
        break;
    }
  }
  
  // Execute Blackwall pulse event
  private func ExecuteBlackwallPulse(severity: BlackwallEventSeverity) -> Void {
    this.m_currentPulseActive = true;
    
    let duration: Float;
    switch severity {
      case BlackwallEventSeverity.Critical:
        duration = 120.0; // 2 minutes
        break;
      case BlackwallEventSeverity.Major:
        duration = 60.0;
        break;
      case BlackwallEventSeverity.Moderate:
        duration = 30.0;
        break;
      default:
        duration = 15.0;
    }
    
    this.m_pulseEndTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance())) + duration;
    
    LogChannel(n"BTW", s"[BlackwallEvents] BLACKWALL PULSE ACTIVE for \(duration) seconds!");
    
    // During pulse, Blackwall abilities are stronger but more dangerous
    // TODO: Apply pulse visual effects (screen distortion, sky color change)
    
    // Trigger whispers during pulse
    let whispersSystem: ref<BlackwallWhispersSystem> = GetBlackwallWhispersSystem();
    if IsDefined(whispersSystem) {
      whispersSystem.ForceWhisper(BlackwallAIEntity.ErebusEcho);
    }
  }
  
  // End Blackwall pulse
  private func EndBlackwallPulse() -> Void {
    this.m_currentPulseActive = false;
    LogChannel(n"BTW", "[BlackwallEvents] Blackwall pulse ended");
  }
  
  // Execute reality glitch event
  private func ExecuteRealityGlitch(severity: BlackwallEventSeverity) -> Void {
    // TODO: Screen effects - chromatic aberration, distortion
    // TODO: Audio effects - static, reversed audio
    
    LogChannel(n"BTW", "[BlackwallEvents] Reality glitch triggered");
    
    // Minor corruption spike during glitch
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if IsDefined(corruptionSystem) {
      let amount: Float = Cast<Float>(EnumInt(severity) + 1) * 2.0;
      corruptionSystem.AddCorruption(amount, 0.0);
    }
  }
  
  // Execute NPC possession event
  private func ExecuteNPCPossession(severity: BlackwallEventSeverity, position: Vector4) -> Void {
    // TODO: Find nearby NPC and apply temporary possession effect
    // - Glowing eyes
    // - Strange behavior (staring at player, speaking in tongues)
    // - Reverts after short time
    
    LogChannel(n"BTW", "[BlackwallEvents] NPC possession event");
  }
  
  // Execute device malfunction event
  private func ExecuteDeviceMalfunction(severity: BlackwallEventSeverity, position: Vector4) -> Void {
    // TODO: Cause nearby electronic devices to malfunction
    // - Vending machines dispense random items
    // - Screens show static or Blackwall imagery
    // - Lights flicker
    // - Cars honk randomly
    
    LogChannel(n"BTW", "[BlackwallEvents] Device malfunction event");
  }
  
  // Execute AI manifest event
  private func ExecuteAIManifest(severity: BlackwallEventSeverity, position: Vector4) -> Void {
    // TODO: Brief visual appearance of AI entity
    // - Ghostly figure
    // - Digital distortion effect
    // - Whisper dialogue
    // - Disappears quickly
    
    LogChannel(n"BTW", "[BlackwallEvents] AI MANIFEST - Danger!");
    
    // Significant corruption spike
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if IsDefined(corruptionSystem) {
      corruptionSystem.AddCorruption(10.0, 0.0);
    }
    
    // Force whisper from the manifesting entity
    let whispersSystem: ref<BlackwallWhispersSystem> = GetBlackwallWhispersSystem();
    if IsDefined(whispersSystem) {
      whispersSystem.ForceWhisper(BlackwallAIEntity.RogueConstruct);
    }
  }
  
  // Check if pulse is active
  public func IsPulseActive() -> Bool {
    return this.m_currentPulseActive;
  }
  
  // Get discovered thin spots
  public func GetDiscoveredThinSpots() -> array<ref<BlackwallThinSpot>> {
    let discovered: array<ref<BlackwallThinSpot>>;
    
    let i: Int32 = 0;
    while i < ArraySize(this.m_thinSpots) {
      if this.m_thinSpots[i].isDiscovered {
        ArrayPush(discovered, this.m_thinSpots[i]);
      }
      i += 1;
    }
    
    return discovered;
  }
  
  // Get nearby thin spot
  public func GetNearbyThinSpot(position: Vector4, range: Float) -> ref<BlackwallThinSpot> {
    let i: Int32 = 0;
    while i < ArraySize(this.m_thinSpots) {
      let spot: ref<BlackwallThinSpot> = this.m_thinSpots[i];
      if Vector4.Distance(position, spot.position) <= range {
        return spot;
      }
      i += 1;
    }
    return null;
  }
  
  // Enable/disable events
  public func SetEnabled(enabled: Bool) -> Void {
    this.m_isEnabled = enabled;
  }
  
  // Force trigger pulse (for quests/debug)
  public func ForcePulse(duration: Float) -> Void {
    this.ExecuteBlackwallPulse(BlackwallEventSeverity.Major);
    this.m_pulseEndTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance())) + duration;
  }
}

// Global accessor
public static func GetBlackwallEventsSystem() -> ref<BlackwallEventsSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.BlackwallEventsSystem") as BlackwallEventsSystem;
}
