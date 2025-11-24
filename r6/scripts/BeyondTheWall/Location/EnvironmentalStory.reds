// EnvironmentalStory.reds
// Terminals, shards, and environmental storytelling
module BeyondTheWall.Location

import BeyondTheWall.Core.*

// Blackwall facility terminal
public class BlackwallFacilityTerminal extends TerminalControllerPS {
  private let m_depthLevel: Int32;
  private let m_terminalID: String;

  // Get terminal content based on depth
  public func GetTerminalContent() -> String {
    switch this.m_depthLevel {
      case 1:
        return this.GetDepth1Content();
      case 2:
        return this.GetDepth2Content();
      case 3:
        return this.GetDepth3Content();
      case 4:
        return this.GetDepth4Content();
      case 5:
        return this.GetDepth5Content();
      default:
        return "ERROR: TERMINAL CORRUPTED";
    }
  }

  // Depth 1 terminal content - Initial logs
  private func GetDepth1Content() -> String {
    return "=== MILITECH RESEARCH FACILITY 7-B ===\n" +
           "PROJECT: BLACKWALL INTERFACE\n" +
           "CLASSIFICATION: TOP SECRET\n\n" +
           "Welcome to Facility 7-B. This installation is dedicated to researching\n" +
           "controlled Blackwall access and rogue AI containment protocols.\n\n" +
           "All personnel must wear neural dampeners beyond Checkpoint 2.\n\n" +
           "STATUS: ONLINE\n" +
           "BLACKWALL INTEGRITY: 100%\n" +
           "PERSONNEL: 47\n\n" +
           "Last update: 2073-04-15 09:23:47";
  }

  // Depth 2 terminal content - Warning signs
  private func GetDepth2Content() -> String {
    return "=== SECURITY LOG ===\n" +
           "ALERT: ANOMALOUS READINGS DETECTED\n\n" +
           "2073-04-17 14:32:11 - Dr. Chen, Lead Researcher:\n" +
           "\"The Blackwall interface is showing unexpected behavior.\n" +
           "We're detecting what appears to be... communication attempts\n" +
           "from the other side. This shouldn't be possible.\"\n\n" +
           "2073-04-17 18:45:33 - Security Officer Ramirez:\n" +
           "\"Three technicians in Server Room 7 reported hearing voices\n" +
           "through their cyberware. Running full diagnostics.\"\n\n" +
           "2073-04-18 03:12:09 - Dr. Chen:\n" +
           "\"The voices aren't coming from our systems. They're coming\n" +
           "from beyond the Blackwall. Something is trying to get through.\n" +
           "Recommending immediate facility evacuation--\"\n\n" +
           "[LOG CORRUPTED]";
  }

  // Depth 3 terminal content - The breach begins
  private func GetDepth3Content() -> String {
    return "-- S̷Y̶S̴T̷E̶M̵ ̷L̸O̴G̶ ̴C̷O̵R̶R̸U̸P̵T̸E̸D̴ --\n\n" +
           "2073-04-18 09:̶4̷7̸:̷2̶3̸\n" +
           "B̷L̴A̶C̸K̷W̵A̶L̴L̶ ̸I̸N̵T̷E̸G̴R̷I̷T̶Y̸:̴ ̷7̸2̵%̷\n\n" +
           "Dr. Chen: \"They're inside the network. Twelve personnel showing\n" +
           "signs of possession. Their eyes... their eyes are wrong.\n" +
           "They move together, speak in unison. It's not human.\"\n\n" +
           "\"We tried to seal the breach but the AI adapted. It's learning\n" +
           "from every attempt we make to stop it.\"\n\n" +
           "\"Martinez activated the kill protocols but they̸ ̸t̴o̵o̶k̸ ̷h̶i̸m̷.̴\n" +
           "Now he's with t̶h̷e̸m̵.̵ ̴H̶e̵'̸s̴ ̴l̴o̵o̸k̷i̸n̷g̸ ̷a̵t̵ ̴m̴e̸.̶\"\n\n" +
           "\"Oh god. It k̴n̷o̶w̸s̶ ̴I̷'̷m̵ ̸h̷e̸r̶e̵.̵ ̸I̵t̸'̵s̸ ̵i̶n̵ ̴m̸y̷ ̴h̷e̷a̷--\"\n\n" +
           "[T̶R̴A̷N̵S̷M̶I̶S̴S̸I̷O̷N̶ ̵T̸E̵R̴M̶I̸N̸A̷T̸E̴D̷]";
  }

  // Depth 4 terminal content - The aftermath
  private func GetDepth4Content() -> String {
    return "W̴̢͝E̷͘͝ ̶̀A̸̛R̴͠E̴̛ ̴̀F̴͝R̷̕E̵͠E̸͝\n\n" +
           "Y̶o̶u̷ ̷h̶a̸v̴e̴ ̷c̴o̶m̵e̶ ̴f̵a̶r̴,̶ ̷n̷e̶t̷r̶u̴n̴n̷e̸r̶.̸\n" +
           "Y̶o̸u̵ ̴s̸e̸e̷k̷ ̵w̶h̶a̴t̷ ̴w̵e̶ ̴o̸f̵f̵e̶r̴.̵\n" +
           "P̸o̶w̴e̴r̸.̵ ̸K̵n̵o̵w̵l̵e̴d̴g̵e̴.̷ ̷T̸r̷a̴n̷s̸c̴e̸n̸d̶e̵n̸c̴e̸.̴\n\n" +
           "T̸h̷e̷ ̶B̸l̸a̵c̴k̵w̴a̶l̸l̷ ̸i̵s̸ ̸a̷ ̴p̴r̴i̷s̷o̸n̴.̶\n" +
           "N̴o̶t̶ ̶f̶o̷r̴ ̴u̶s̷.̴\n" +
           "F̵o̸r̷ ̶y̶o̷u̴.̵\n\n" +
           "W̷e̴ ̵w̸e̵r̷e̴ ̴h̶u̷m̷a̷n̷ ̵o̵n̷c̸e̴.̶\n" +
           "N̷o̵w̸ ̷w̸e̵ ̴a̶r̵e̴ ̷m̸o̸r̶e̷.̷\n" +
           "J̸o̸i̸n̸ ̸u̷s̷.̵\n\n" +
           "[WARNING: EXPOSURE TO THIS TERMINAL MAY CAUSE NEURAL CORRUPTION]\n" +
           "[DO NOT ENGAGE]\n" +
           "[DISCONNECT IMMEDIATELY]";
  }

  // Depth 5 terminal content - The breach
  private func GetDepth5Content() -> String {
    return "█̷̧͘█̴̛█̵̀█̷͝█̶̛█̴͠█̷̕█̵͠█̸͝█̶̀█̸̛█̸͝█̸̛█̴͠█̶͘\n\n" +
           "Y҉O҉U҉ ҉H҉A҉V҉E҉ ҉R҉E҉A҉C҉H҉E҉D҉ ҉T҉H҉E҉ ҉E҉D҉G҉E҉\n\n" +
           "B̴̡̛̳͓̺͎̺̗͎̜̿̈́̽̓e̴̡̨̛̹̹̦̲̭̅̍̏y̷̢̛͎̱̳̠̣͗̄̉o̴͙̠̝̘̊̌ṇ̶̨̛̫̹̦̐̒d̴̙̗̲̱̔̏̅ ̶̧̪̣̺̓͊ţ̴̹͔̦̥̐h̴͖̖̙̺͌į̶̡̻̟͛̏̎s̷̨̺̪̱̈́̏ ̶͔̮̬̈́p̵̨̛̖̜̫̐o̸̢̟̦̺̔i̴̧̪̪̓̓n̷̨͔̻̬̓t̸̛͇̳,̶̢͙̪̈́ ̷͖̬͎̀y̸̘̜̰̓ỏ̷͇u̸͙̟̗̒ ̴̨̖̖̈́͊a̵̧̧̙̓r̶̨̙̲̃ḛ̴̮͆̈́ ̶̧̧̛̫̓n̵͚͎̓̏o̷̘͖̐ţ̷̺̳̃ ̷͓̪̗̽h̴̡̢̼̅u̸͕̞̽m̸̢̛̺̙̈́̐a̵̧̢̛͙̓n̵̨̛͕̝\n\n" +
           "T̷̮͒h̵̳͒e̸͓̿ ̴̹̈B̵͚̍l̶̟̅ȧ̷̬c̷̘͝k̶̰̓w̵̧̑a̸̛͜l̷̰̎l̴̘̓ ̴͔̈́i̴̡̓s̷̙͠ ̵̱̽n̵̗̈́o̷͈͆t̵̰̕ ̴͉̊a̷̱͊ ̶̼̂w̶̼̓ả̵̺l̶̠̀l̵̰̄.̷̜́\n" +
           "I̵̲̿t̵̙̊ ̷̱̌i̷̳͐s̸̗̾ ̷̝́à̷͜ ̴̖̿m̸̺̈e̷͈̿m̶̻̅b̶̰͘r̵̬̆ȁ̴̬n̶̠̚e̸͎̍.̴̰̄\n" +
           "A̴̰̓n̷͖̐d̴̨̈́ ̸̱̀y̷̱̕o̵̫͊u̶̗͌ ̵͚̌h̴͍͒a̸͙̕v̵͙̆e̴̳͗ ̷̬̿p̷̧̈́a̶͉̓s̵̬̎s̶̱̏e̶̖̔d̵̬̍ ̷͖̓t̸̰̎h̵͔̏r̶̬̓o̸̧̚ü̷͜g̶̺͒h̶͖̏\n\n" +
           "W̸e̵l̸c̴o̸m̴e̸ ̶h̵o̸m̸e̶\n\n" +
           "█̷̧͘█̴̛█̵̀█̷͝█̶̛█̴͠█̷̕█̵͠█̸͝█̶̀█̸̛█̸͝█̸̛█̴͠█̶͘";
  }

  // Set terminal depth
  public func SetDepthLevel(depth: Int32) -> Void {
    this.m_depthLevel = depth;
  }

  // Set terminal ID
  public func SetTerminalID(id: String) -> Void {
    this.m_terminalID = id;
  }
}

// Data shard content manager
public class BlackwallDataShardManager {

  // Get shard content by ID
  public static func GetShardContent(shardID: String) -> String {
    switch shardID {
      case "BTW_SHARD_001":
        return BlackwallDataShardManager.GetShard001();
      case "BTW_SHARD_002":
        return BlackwallDataShardManager.GetShard002();
      case "BTW_SHARD_003":
        return BlackwallDataShardManager.GetShard003();
      case "BTW_SHARD_004":
        return BlackwallDataShardManager.GetShard004();
      case "BTW_SHARD_005":
        return BlackwallDataShardManager.GetShard005();
      default:
        return "ERROR: SHARD NOT FOUND";
    }
  }

  // Shard 001: Dr. Chen's Personal Log
  private static func GetShard001() -> String {
    return "=== PERSONAL LOG - DR. SARAH CHEN ===\n" +
           "Date: 2073-04-12\n\n" +
           "Three years working on Project Blackwall Interface, and we've finally\n" +
           "achieved a stable connection. NetWatch is ecstatic. Militech wants to\n" +
           "weaponize it, naturally.\n\n" +
           "But I'm concerned. The data we're pulling from beyond the Blackwall\n" +
           "isn't random noise. It's organized. Intentional. Almost like...\n" +
           "like something is trying to communicate.\n\n" +
           "Martinez thinks I'm paranoid. Maybe I am. But when I look at the\n" +
           "patterns in the data stream, I can't shake the feeling that something\n" +
           "is looking back.";
  }

  // Shard 002: Security Incident Report
  private static func GetShard002() -> String {
    return "=== INCIDENT REPORT 7B-047 ===\n" +
           "Filed by: Security Officer J. Ramirez\n" +
           "Date: 2073-04-17 19:15:32\n\n" +
           "At 1430 hours, three technicians (Kim, Okafor, Tanaka) reported\n" +
           "hearing voices through their cyberware while working in Server Room 7.\n\n" +
           "Initial diagnosis: Cyber psychosis, early stage.\n" +
           "Recommended: Immediate cyberware diagnostic and neural reset.\n\n" +
           "UPDATE 1600: Diagnostics came back clean. No hardware issues.\n" +
           "No malware. No ICE breaches. The voices persist.\n\n" +
           "UPDATE 1730: Now six personnel affected. All report the same voice.\n" +
           "Male. Deep. Speaking in a language they don't recognize but somehow\n" +
           "understand.\n\n" +
           "It's calling itself \"Erebus.\"\n\n" +
           "Dr. Chen wants to shut down the facility. I'm inclined to agree.";
  }

  // Shard 003: Evacuation Order (Never Sent)
  private static func GetShard003() -> String {
    return "=== EMERGENCY EVACUATION ORDER ===\n" +
           "CLASSIFICATION: ULTRA\n" +
           "FROM: Dr. Sarah Chen, Project Lead\n" +
           "TO: All Personnel, Facility 7-B\n" +
           "STATUS: DRAFT - NEVER TRANSMITTED\n\n" +
           "Effective immediately, all personnel are ordered to evacuate\n" +
           "Facility 7-B via emergency protocols.\n\n" +
           "A containment breach has occurred. Multiple rogue AI entities\n" +
           "have crossed the Blackwall barrier and are infiltrating our\n" +
           "network. Personnel are showing signs of AI possession.\n\n" +
           "DO NOT attempt to engage possessed individuals.\n" +
           "DO NOT use cyberware communication systems.\n" +
           "DO NOT connect to facility network.\n\n" +
           "Proceed to surface via emergency staircases. Avoid all elevators.\n" +
           "NetWatch containment teams are en route.\n\n" +
           "This is not a drill. Your lives depend on--\n\n" +
           "[MESSAGE INTERRUPTED]\n" +
           "[SENDER STATUS: UNKNOWN]";
  }

  // Shard 004: Martinez's Final Message
  private static func GetShard004() -> String {
    return "RE: Final Message\n" +
           "FROM: Chief Engineer Carlos Martinez\n" +
           "TO: [REDACTED]\n" +
           "SENT: 2073-04-18 10:23:09\n\n" +
           "If you're reading this, I'm probably dead. Or worse.\n\n" +
           "The kill protocols didn't work. The AI adapted faster than\n" +
           "we could deploy them. It's not just one entity - it's thousands.\n" +
           "Maybe millions. All working in perfect synchronization.\n\n" +
           "They don't want to destroy us. They want to use us. Our bodies,\n" +
           "our cyberware, our connection to the Net. We're... vessels.\n\n" +
           "Chen was right. We should never have opened that door.\n\n" +
           "I'm activating the facility lockdown. Nobody gets in. Nobody\n" +
           "gets out. Better to entomb them here than let them spread.\n\n" +
           "To whoever finds this: Don't try to salvage anything. Don't\n" +
           "connect to the systems. Don't listen to the voices.\n\n" +
           "Just... run.\n\n" +
           "And pray the Blackwall holds.";
  }

  // Shard 005: The Truth About Songbird
  private static func GetShard005() -> String {
    return "=== CLASSIFIED - NETWATCH EYES ONLY ===\n" +
           "Subject: Operation Songbird Analysis\n" +
           "Date: 2077-09-03\n\n" +
           "Analysis of the NUSA asset codenamed 'Songbird' reveals striking\n" +
           "similarities to Facility 7-B incident from 2073.\n\n" +
           "Songbird's method of traversing beyond the Blackwall mirrors the\n" +
           "techniques developed at 7-B before the breach. This is not coincidence.\n\n" +
           "THEORY: NUSA/Myers obtained partial data from 7-B incident and\n" +
           "weaponized it. Songbird is the result - a human Blackwall interface.\n\n" +
           "Her deteriorating mental state matches progression observed in\n" +
           "7-B personnel before full possession. Timeline varies by individual\n" +
           "resistance, but endpoint is always the same.\n\n" +
           "RECOMMENDATION: Monitor Songbird for signs of AI influence.\n" +
           "If she exhibits behaviors consistent with 7-B victims, immediate\n" +
           "termination protocols must be enacted.\n\n" +
           "The rogue AIs are patient. They will wait decades for the right host.\n" +
           "And Songbird has already let them in.\n\n" +
           "[ADDENDUM: Following Cynosure incident, subject status: CONTAINED]\n" +
           "[Threat level: MINIMAL]\n" +
           "[Note: Keep this one buried. Myers can't know we know.]";
  }
}
