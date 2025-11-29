// SideMissions.reds
// Side mission implementations for Beyond the Wall
module BeyondTheWall.Missions

import BeyondTheWall.Core.*
import BeyondTheWall.Enemies.*

// ==================================================
// SIDE MISSION SYSTEM
// ==================================================

public class BTWSideMissionManager extends ScriptableSystem {
  private let m_activeMissions: array<ref<BTWSideMission>>;
  private let m_completedMissions: array<CName>;
  private let m_availableMissions: array<ref<BTWSideMission>>;

  private func OnAttach() -> Void {
    ArrayClear(this.m_activeMissions);
    ArrayClear(this.m_completedMissions);

    this.InitializeMissions();

    LogChannel(n"BTW", "[Missions] Side mission system initialized");
  }

  // Initialize all side missions
  private func InitializeM

issions() -> Void {
    // Mission 1: The Last Message
    let mission1: ref<BTWSideMission> = this.CreateMission_LastMessage();
    ArrayPush(this.m_availableMissions, mission1);

    // Mission 2: Digital Ghosts
    let mission2: ref<BTWSideMission> = this.CreateMission_DigitalGhosts();
    ArrayPush(this.m_availableMissions, mission2);

    // Mission 3: The First Victim
    let mission3: ref<BTWSideMission> = this.CreateMission_FirstVictim();
    ArrayPush(this.m_availableMissions, mission3);

    // Mission 4: Dr. Chen's Research
    let mission4: ref<BTWSideMission> = this.CreateMission_ChensResearch();
    ArrayPush(this.m_availableMissions, mission4);

    // Mission 5: Project Erebus Files
    let mission5: ref<BTWSideMission> = this.CreateMission_ErebusFiles();
    ArrayPush(this.m_availableMissions, mission5);

    // Mission 6: The Sympathizer
    let mission6: ref<BTWSideMission> = this.CreateMission_Sympathizer();
    ArrayPush(this.m_availableMissions, mission6);

    // Mission 7: Rache's Legacy
    let mission7: ref<BTWSideMission> = this.CreateMission_RachesLegacy();
    ArrayPush(this.m_availableMissions, mission7);
  }

  // Check for mission triggers
  public func CheckMissionTriggers(player: ref<PlayerPuppet>, depthLevel: Int32) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_availableMissions) {
      let mission: ref<BTWSideMission> = this.m_availableMissions[i];

      if this.CanActivateMission(mission, player, depthLevel) {
        this.ActivateMission(mission);
        ArrayErase(this.m_availableMissions, i);
        // Don't increment i after removal - next item moves to current index
      } else {
        i += 1;
      }
    }
  }

  // Check if mission can be activated
  private func CanActivateMission(mission: ref<BTWSideMission>, player: ref<PlayerPuppet>, depthLevel: Int32) -> Bool {
    if ArrayContains(this.m_completedMissions, mission.missionID) {
      return false;
    }

    if depthLevel < mission.requiredDepth {
      return false;
    }

    let masterySystem: ref<MasterySystem> = GetMasterySystem();
    if masterySystem.GetMasteryLevel() < mission.requiredMastery {
      return false;
    }

    return true;
  }

  // Activate mission
  private func ActivateMission(mission: ref<BTWSideMission>) -> Void {
    ArrayPush(this.m_activeMissions, mission);

    // Show notification
    LogChannel(n"BTW", s"[Missions] NEW MISSION: \(mission.displayName)");

    // Play sound
    GameObject.PlaySoundEvent(n"quest_new_objectives");
  }

  // Complete mission
  public func CompleteMission(missionID: CName) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_activeMissions) {
      if Equals(this.m_activeMissions[i].missionID, missionID) {
        let mission: ref<BTWSideMission> = this.m_activeMissions[i];

        // Grant rewards
        this.GrantMissionRewards(mission);

        // Mark complete
        ArrayPush(this.m_completedMissions, missionID);
        ArrayErase(this.m_activeMissions, i);

        LogChannel(n"BTW", s"[Missions] COMPLETED: \(mission.displayName)");
        return;
      }
    }
  }

  // Grant mission rewards
  private func GrantMissionRewards(mission: ref<BTWSideMission>) -> Void {
    // Grant XP
    let masterySystem: ref<MasterySystem> = GetMasterySystem();
    masterySystem.AddExperience(mission.masteryXPReward);

    // Grant items (would be implemented with actual item system)
    LogChannel(n"BTW", s"[Missions] Rewards: \(mission.masteryXPReward) Mastery XP, \(ToString(mission.rewardItem))");

    // Play completion sound
    GameObject.PlaySoundEvent(n"quest_completed");
  }
}

// Side mission data structure
public class BTWSideMission {
  public let missionID: CName;
  public let displayName: String;
  public let description: String;
  public let requiredDepth: Int32;
  public let requiredMastery: Int32;
  public let masteryXPReward: Float;
  public let rewardItem: CName;
  public let objectives: array<ref<MissionObjective>>;
}

// Mission objective
public class MissionObjective {
  public let objectiveID: CName;
  public let description: String;
  public let completed: Bool;
  public let objectiveType: MissionObjectiveType;
}

public enum MissionObjectiveType {
  FindTerminal = 0,
  ReadDataShard = 1,
  DefeatEnemy = 2,
  InteractWithDevice = 3,
  ReachLocation = 4,
  ReduceCorruption = 5
}

// Global accessor
public static func GetBTWSideMissionManager() -> ref<BTWSideMissionManager> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.Missions.BTWSideMissionManager") as BTWSideMissionManager;
}

// ==================================================
// MISSION DEFINITIONS
// ==================================================

// MISSION 1: The Last Message
private func CreateMission_LastMessage() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_LastMessage";
  mission.displayName = "The Last Message";
  mission.description = "Security Chief Marcus Webb sent one final message before succumbing to possession. Find it and learn the truth of outbreak day.";
  mission.requiredDepth = 2;
  mission.requiredMastery = 15;
  mission.masteryXPReward = 50.0;
  mission.rewardItem = n"Items.SecurityChief_Commlink";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"FindWebbTerminal";
  obj1.description = "Locate Marcus Webb's terminal in Depth 2 security office";
  obj1.objectiveType = MissionObjectiveType.FindTerminal;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"ReadWebbMessage";
  obj2.description = "Read Webb's final message";
  obj2.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"FindWebbBody";
  obj3.description = "Find Webb's body in the breach chamber";
  obj3.objectiveType = MissionObjectiveType.ReachLocation;
  ArrayPush(mission.objectives, obj3);

  return mission;
}

// MISSION 2: Digital Ghosts
private func CreateMission_DigitalGhosts() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_DigitalGhosts";
  mission.displayName = "Digital Ghosts";
  mission.description = "Three researchers' consciousnesses are trapped in the facility network. Free them... or give them peace.";
  mission.requiredDepth = 3;
  mission.requiredMastery = 35;
  mission.masteryXPReward = 75.0;
  mission.rewardItem = n"Items.DigitalExorcist";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"LocateGhost1";
  obj1.description = "Locate Dr. Yuki Tanaka's consciousness (Lab 7)";
  obj1.objectiveType = MissionObjectiveType.FindTerminal;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"LocateGhost2";
  obj2.description = "Locate James Morrison's consciousness (Server Room B)";
  obj2.objectiveType = MissionObjectiveType.FindTerminal;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"LocateGhost3";
  obj3.description = "Locate Elena Volkov's consciousness (Containment)";
  obj3.objectiveType = MissionObjectiveType.FindTerminal;
  ArrayPush(mission.objectives, obj3);

  let obj4: ref<MissionObjective> = new MissionObjective();
  obj4.objectiveID = n"FreeOrPurge";
  obj4.description = "Choose: Free them into the Net or purge their data";
  obj4.objectiveType = MissionObjectiveType.InteractWithDevice;
  ArrayPush(mission.objectives, obj4);

  return mission;
}

// MISSION 3: The First Victim
private func CreateMission_FirstVictim() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_FirstVictim";
  mission.displayName = "The First Victim";
  mission.description = "Patient Zero of the outbreak was Intern David Park. His workstation might reveal how it started.";
  mission.requiredDepth = 2;
  mission.requiredMastery = 25;
  mission.masteryXPReward = 60.0;
  mission.rewardItem = n"Items.PatientZero_Shard";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"FindParksDesk";
  obj1.description = "Find David Park's workstation in Depth 2";
  obj1.objectiveType = MissionObjectiveType.FindTerminal;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"RecoverLogs";
  obj2.description = "Recover Park's activity logs from outbreak day";
  obj2.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"DefeatPatientZero";
  obj3.description = "Confront David Park's possessed form (Boss Fight)";
  obj3.objectiveType = MissionObjectiveType.DefeatEnemy;
  ArrayPush(mission.objectives, obj3);

  return mission;
}

// MISSION 4: Dr. Chen's Research
private func CreateMission_ChensResearch() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_ChensResearch";
  mission.displayName = "The Price of Knowledge";
  mission.description = "Dr. Sarah Chen's research notes detail her descent into madness. Collect them all to understand what drove her to willingly merge with an AI.";
  mission.requiredDepth = 4;
  mission.requiredMastery = 50;
  mission.masteryXPReward = 100.0;
  mission.rewardItem = n"Items.ProjectErebusDeck";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"FindResearchNote1";
  obj1.description = "Research Note 1: Initial Contact (Depth 2)";
  obj1.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"FindResearchNote2";
  obj2.description = "Research Note 2: First Conversations (Depth 3)";
  obj2.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"FindResearchNote3";
  obj3.description = "Research Note 3: The Offer (Depth 4)";
  obj3.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj3);

  let obj4: ref<MissionObjective> = new MissionObjective();
  obj4.objectiveID = n"FindResearchNote4";
  obj4.description = "Research Note 4: Acceptance (Depth 5)";
  obj4.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj4);

  let obj5: ref<MissionObjective> = new MissionObjective();
  obj5.objectiveID = n"FindChenLab";
  obj5.description = "Access Dr. Chen's private lab";
  obj5.objectiveType = MissionObjectiveType.ReachLocation;
  ArrayPush(mission.objectives, obj5);

  return mission;
}

// MISSION 5: Project Erebus Files
private func CreateMission_ErebusFiles() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_ErebusFiles";
  mission.displayName = "The Erebus Conspiracy";
  mission.description = "Classified files reveal Project Erebus was intentional. Militech wanted a controllable Blackwall breach. Find proof of the conspiracy.";
  mission.requiredDepth = 5;
  mission.requiredMastery = 70;
  mission.masteryXPReward = 150.0;
  mission.rewardItem = n"Items.ClassifiedErebusFiles";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"FindVault";
  obj1.description = "Locate classified document vault in Depth 5";
  obj1.objectiveType = MissionObjectiveType.ReachLocation;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"BypassSecurity";
  obj2.description = "Bypass vault security (Intelligence 20 required)";
  obj2.objectiveType = MissionObjectiveType.InteractWithDevice;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"RecoverFiles";
  obj3.description = "Download classified Erebus files";
  obj3.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj3);

  let obj4: ref<MissionObjective> = new MissionObjective();
  obj4.objectiveID = n"EscapeEraser";
  obj4.description = "Survive the AI 'Eraser' program (optional: defeat it)";
  obj4.objectiveType = MissionObjectiveType.DefeatEnemy;
  ArrayPush(mission.objectives, obj4);

  return mission;
}

// MISSION 6: The Sympathizer
private func CreateMission_Sympathizer() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_Sympathizer";
  mission.displayName = "The Sympathizer";
  mission.description = "An AI entity claims it wants to help humans. It's been protecting stabilizer nodes. Is it genuine, or is this a trap?";
  mission.requiredDepth = 3;
  mission.requiredMastery = 40;
  mission.masteryXPReward = 80.0;
  mission.rewardItem = n"Items.SympatheticAI_Chip";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"MakeContact";
  obj1.description = "Make contact with the Sympathizer via terminal";
  obj1.objectiveType = MissionObjectiveType.FindTerminal;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"ProveLoyalty";
  obj2.description = "Complete Sympathizer's test: Exorcise 5 possessed without killing";
  obj2.objectiveType = MissionObjectiveType.DefeatEnemy;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"TrustOrDestroy";
  obj3.description = "Choose: Download Sympathizer AI or destroy it";
  obj3.objectiveType = MissionObjectiveType.InteractWithDevice;
  ArrayPush(mission.objectives, obj3);

  return mission;
}

// MISSION 7: Rache's Legacy
private func CreateMission_RachesLegacy() -> ref<BTWSideMission> {
  let mission: ref<BTWSideMission> = new BTWSideMission();
  mission.missionID = n"BTW_RachesLegacy";
  mission.displayName = "Rache's Legacy";
  mission.description = "The legendary R.A.B.I.D.S. Controller - Rache Bartmoss's personal Blackwall failsafe. It's hidden in Depth 5. Every netrunner wants it. Only you can find it.";
  mission.requiredDepth = 5;
  mission.requiredMastery = 100;
  mission.masteryXPReward = 200.0;
  mission.rewardItem = n"Items.RABIDS_Controller";

  // Objectives
  let obj1: ref<MissionObjective> = new MissionObjective();
  obj1.objectiveID = n"FindRachesClues";
  obj1.description = "Find all 5 of Rache's encrypted clues hidden throughout facility";
  obj1.objectiveType = MissionObjectiveType.ReadDataShard;
  ArrayPush(mission.objectives, obj1);

  let obj2: ref<MissionObjective> = new MissionObjective();
  obj2.objectiveID = n"SolveRachesPuzzle";
  obj2.description = "Solve Rache's legendary encryption puzzle";
  obj2.objectiveType = MissionObjectiveType.InteractWithDevice;
  ArrayPush(mission.objectives, obj2);

  let obj3: ref<MissionObjective> = new MissionObjective();
  obj3.objectiveID = n"FindVault";
  obj3.description = "Locate Rache's hidden vault in Depth 5";
  obj3.objectiveType = MissionObjectiveType.ReachLocation;
  ArrayPush(mission.objectives, obj3);

  let obj4: ref<MissionObjective> = new MissionObjective();
  obj4.objectiveID = n"DefeatGuardian";
  obj4.description = "Defeat R.A.B.I.D.S. Guardian AI (Legendary Boss)";
  obj4.objectiveType = MissionObjectiveType.DefeatEnemy;
  ArrayPush(mission.objectives, obj4);

  let obj5: ref<MissionObjective> = new MissionObjective();
  obj5.objectiveID = n"ClaimController";
  obj5.description = "Claim the R.A.B.I.D.S. Controller";
  obj5.objectiveType = MissionObjectiveType.InteractWithDevice;
  ArrayPush(mission.objectives, obj5);

  return mission;
}
