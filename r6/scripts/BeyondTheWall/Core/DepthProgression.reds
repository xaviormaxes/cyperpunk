// DepthProgression.reds
// Manages depth level progression and zone transitions
module BeyondTheWall.Core

import Codeware.*

// Depth zone information
public class DepthZone {
  public let depth: Int32;
  public let name: String;
  public let description: String;
  public let corruptionMultiplier: Float;
  public let position: Vector4;
  public let radius: Float;

  public static func Create(depth: Int32, name: String, desc: String, pos: Vector4, radius: Float, corruptionMult: Float) -> ref<DepthZone> {
    let zone = new DepthZone();
    zone.depth = depth;
    zone.name = name;
    zone.description = desc;
    zone.position = pos;
    zone.radius = radius;
    zone.corruptionMultiplier = corruptionMult;
    return zone;
  }

  public func IsPlayerInZone(playerPos: Vector4) -> Bool {
    let distance: Float = Vector4.Distance(this.position, playerPos);
    return distance <= this.radius;
  }
}

// Main depth progression system
public class BlackwallDepthProgressionSystem extends ScriptableSystem {
  private let m_currentDepth: Int32;
  private let m_depthZones: array<ref<DepthZone>>;
  private let m_isInFacility: Bool;
  private let m_lastPlayerPosition: Vector4;
  private let m_updateInterval: Float;
  private let m_updateTimer: Float;
  private let m_enteredFacilityTime: Float;

  // Initialize system
  private func OnAttach() -> Void {
    this.m_currentDepth = 0;
    this.m_isInFacility = false;
    this.m_updateInterval = 1.0; // Check every second
    this.m_updateTimer = 0.0;
    this.m_enteredFacilityTime = 0.0;

    // Initialize depth zones
    this.InitializeDepthZones();

    LogChannel(n"BTW", "[DepthProgression] Initialized");
  }

  // Initialize the depth zones with coordinates
  private func InitializeDepthZones() -> Void {
    ArrayClear(this.m_depthZones);

    // Depth 1: Surface Contact - Outer facility
    // Position: Militech Research Facility entrance area
    let depth1 = DepthZone.Create(
      1,
      "Surface Contact",
      "The outer facility. Minimal corruption, but the Blackwall's presence is felt.",
      new Vector4(-100.0, 50.0, 10.0, 1.0), // Placeholder coordinates
      30.0, // 30m radius
      1.0   // Normal corruption rate
    );
    ArrayPush(this.m_depthZones, depth1);

    // Depth 2: Protocol Breach - Server rooms
    let depth2 = DepthZone.Create(
      2,
      "Protocol Breach",
      "Server rooms with active Blackwall connections. Reality begins to distort.",
      new Vector4(-150.0, 50.0, 10.0, 1.0),
      25.0,
      1.2
    );
    ArrayPush(this.m_depthZones, depth2);

    // Depth 3: Deep Dive - Experimental labs
    let depth3 = DepthZone.Create(
      3,
      "Deep Dive",
      "Experimental labs where they tested Blackwall interface technology. Heavy corruption.",
      new Vector4(-200.0, 50.0, 5.0, 1.0),
      25.0,
      1.5
    );
    ArrayPush(this.m_depthZones, depth3);

    // Depth 4: Old Net Interface - Containment core
    let depth4 = DepthZone.Create(
      4,
      "Old Net Interface",
      "The Blackwall containment core. The boundary between realities thins.",
      new Vector4(-250.0, 50.0, 0.0, 1.0),
      20.0,
      2.0
    );
    ArrayPush(this.m_depthZones, depth4);

    // Depth 5: Beyond the Veil - Breach point
    let depth5 = DepthZone.Create(
      5,
      "Beyond the Veil",
      "The breach point into the Old Net. You stand at the edge of oblivion.",
      new Vector4(-300.0, 50.0, -5.0, 1.0),
      15.0,
      3.0
    );
    ArrayPush(this.m_depthZones, depth5);

    LogChannel(n"BTW", s"[DepthProgression] Initialized \(ArraySize(this.m_depthZones)) depth zones");
  }

  // Update tick
  private func OnTick(deltaTime: Float) -> Void {
    this.m_updateTimer += deltaTime;

    if this.m_updateTimer >= this.m_updateInterval {
      this.CheckPlayerDepth();
      this.m_updateTimer = 0.0;
    }

    // Apply passive corruption in facility
    if this.m_isInFacility && this.m_currentDepth > 0 {
      this.ApplyPassiveCorruption(deltaTime);
    }
  }

  // Check player's current depth
  private func CheckPlayerDepth() -> Void {
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    let playerPos: Vector4 = player.GetWorldPosition();
    this.m_lastPlayerPosition = playerPos;

    // Check if in any depth zone
    let inAnyZone: Bool = false;
    let newDepth: Int32 = 0;

    // Check from deepest to shallowest
    let i: Int32 = ArraySize(this.m_depthZones) - 1;
    while i >= 0 {
      let zone: ref<DepthZone> = this.m_depthZones[i];
      if zone.IsPlayerInZone(playerPos) {
        newDepth = zone.depth;
        inAnyZone = true;
        break;
      }
      i -= 1;
    }

    // Update depth if changed
    if inAnyZone && newDepth != this.m_currentDepth {
      this.SetDepth(newDepth);
    }

    // Update facility status
    if inAnyZone && !this.m_isInFacility {
      this.OnEnterFacility();
    } else if !inAnyZone && this.m_isInFacility {
      this.OnLeaveFacility();
    }
  }

  // Set current depth
  private func SetDepth(depth: Int32) -> Void {
    let oldDepth: Int32 = this.m_currentDepth;
    this.m_currentDepth = depth;

    // Update corruption system
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if IsDefined(corruptionSystem) {
      corruptionSystem.SetInDeepZone(true, depth);
    }

    // Get zone info
    let zoneName: String = this.GetZoneName(depth);

    if depth > oldDepth {
      LogChannel(n"BTW", s"[DepthProgression] Descending to Depth \(depth): \(zoneName)");
      this.ShowDepthNotification(depth, zoneName, true);
    } else if depth < oldDepth {
      LogChannel(n"BTW", s"[DepthProgression] Ascending to Depth \(depth): \(zoneName)");
      this.ShowDepthNotification(depth, zoneName, false);
    }

    // Apply depth-specific effects
    this.ApplyDepthEffects(depth);
  }

  // Get zone name for depth
  private func GetZoneName(depth: Int32) -> String {
    let i: Int32;
    let size: Int32 = ArraySize(this.m_depthZones);

    for i = 0; i < size; i += 1 {
      if this.m_depthZones[i].depth == depth {
        return this.m_depthZones[i].name;
      }
    }

    return "Unknown Zone";
  }

  // Get zone by depth
  public func GetZone(depth: Int32) -> ref<DepthZone> {
    let i: Int32;
    let size: Int32 = ArraySize(this.m_depthZones);

    for i = 0; i < size; i += 1 {
      if this.m_depthZones[i].depth == depth {
        return this.m_depthZones[i];
      }
    }

    return null;
  }

  // Called when player enters facility
  private func OnEnterFacility() -> Void {
    this.m_isInFacility = true;
    this.m_enteredFacilityTime = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));

    LogChannel(n"BTW", "[DepthProgression] Entered Blackwall facility");

    // Show facility entry notification
    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if IsDefined(player) {
      this.ShowFacilityNotification(true);
    }
  }

  // Called when player leaves facility
  private func OnLeaveFacility() -> Void {
    this.m_isInFacility = false;
    this.m_currentDepth = 0;

    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    if IsDefined(corruptionSystem) {
      corruptionSystem.SetInDeepZone(false, 0);
    }

    LogChannel(n"BTW", "[DepthProgression] Left Blackwall facility");

    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if IsDefined(player) {
      this.ShowFacilityNotification(false);
    }
  }

  // Apply passive corruption while in deep zones
  private func ApplyPassiveCorruption(deltaTime: Float) -> Void {
    let corruptionSystem: ref<BlackwallCorruptionSystem> = GetBlackwallCorruptionSystem();
    let masterySystem: ref<BlackwallMasterySystem> = GetBlackwallMasterySystem();

    if !IsDefined(corruptionSystem) || !IsDefined(masterySystem) {
      return;
    }

    // Get corruption multiplier for current zone
    let zone: ref<DepthZone> = this.GetZone(this.m_currentDepth);
    if !IsDefined(zone) {
      return;
    }

    // Passive corruption: 0.1 per second at depth 1, scaled by zone multiplier
    let baseCorruptionRate: Float = 0.1 * Cast<Float>(this.m_currentDepth);
    let corruptionAmount: Float = baseCorruptionRate * zone.corruptionMultiplier * deltaTime;

    corruptionSystem.AddCorruption(corruptionAmount, masterySystem.GetMastery());
  }

  // Apply depth-specific effects
  private func ApplyDepthEffects(depth: Int32) -> Void {
    // TODO: Apply visual and gameplay effects based on depth
    // - Depth 1: Minimal effects
    // - Depth 2: Screen distortion, glitches
    // - Depth 3: Vision blackouts, stronger distortion
    // - Depth 4: Reality warping, cyberware malfunctions
    // - Depth 5: Full Blackwall immersion effects

    LogChannel(n"BTW", s"[DepthProgression] Applying effects for depth \(depth)");
  }

  // Show depth notification to player
  private func ShowDepthNotification(depth: Int32, zoneName: String, descending: Bool) -> Void {
    // TODO: Implement actual UI notification in Phase 4
    // For now, just log
    let direction: String = descending ? "DESCENDING" : "ASCENDING";
    LogChannel(n"BTW", s"[\(direction)] DEPTH \(depth): \(zoneName)");
  }

  // Show facility entry/exit notification
  private func ShowFacilityNotification(entering: Bool) -> Void {
    // TODO: Implement actual UI notification
    if entering {
      LogChannel(n"BTW", "=== ENTERING BLACKWALL FACILITY ===");
      LogChannel(n"BTW", "WARNING: Blackwall corruption detected");
    } else {
      LogChannel(n"BTW", "=== LEAVING BLACKWALL FACILITY ===");
      LogChannel(n"BTW", "Corruption decay will resume");
    }
  }

  // Public getters
  public func GetCurrentDepth() -> Int32 {
    return this.m_currentDepth;
  }

  public func IsInFacility() -> Bool {
    return this.m_isInFacility;
  }

  public func GetTimeInFacility() -> Float {
    if !this.m_isInFacility {
      return 0.0;
    }
    let currentTime: Float = EngineTime.ToFloat(GameInstance.GetSimTime(GetGameInstance()));
    return currentTime - this.m_enteredFacilityTime;
  }

  // Teleport player to facility (debug/testing)
  public func TeleportToDepth(depth: Int32) -> Void {
    let zone: ref<DepthZone> = this.GetZone(depth);
    if !IsDefined(zone) {
      LogChannel(n"BTW", s"[DepthProgression] ERROR: Invalid depth \(depth)");
      return;
    }

    let player: ref<PlayerPuppet> = GetPlayer(GetGameInstance());
    if !IsDefined(player) {
      return;
    }

    // Teleport player to zone position
    GameInstance.GetTeleportationFacility(GetGameInstance()).Teleport(player, zone.position, EulerAngles.ToQuat(new EulerAngles(0.0, 0.0, 0.0)));

    LogChannel(n"BTW", s"[DepthProgression] Teleported to depth \(depth): \(zone.name)");
  }
}

// Global accessor function
public static func GetBlackwallDepthProgressionSystem() -> ref<BlackwallDepthProgressionSystem> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Core.BlackwallDepthProgressionSystem") as BlackwallDepthProgressionSystem;
}
