// ScannerIntegration.reds
// Scanner integration for possession and corruption data
module BeyondTheWall.VFX

import BeyondTheWall.AI.*
import BeyondTheWall.Enemies.*

// ==================================================
// SCANNER POSSESSION DATA PROVIDER
// ==================================================

public class ScannerPossessionDataProvider extends ScriptableSystem {
  private let m_scannerDataCache: array<ref<PossessionScannerData>>;

  private func OnAttach() -> Void {
    ArrayClear(this.m_scannerDataCache);

    LogChannel(n"BTW", "[ScannerPossession] Scanner integration initialized");
  }

  // Get possession data for scanned enemy
  public func GetPossessionData(targetID: EntityID) -> ref<PossessionScannerData> {
    // Check cache first
    let cachedData: ref<PossessionScannerData> = this.GetCachedData(targetID);
    if IsDefined(cachedData) {
      return cachedData;
    }

    // Generate new data
    let newData: ref<PossessionScannerData> = this.GeneratePossessionData(targetID);

    // Cache it
    ArrayPush(this.m_scannerDataCache, newData);

    return newData;
  }

  // Generate possession data for target
  private func GeneratePossessionData(targetID: EntityID) -> ref<PossessionScannerData> {
    let gameInstance: GameInstance = GetGameInstance();
    let puppet: ref<ScriptedPuppet> = GameInstance.FindEntityByID(gameInstance, targetID) as ScriptedPuppet;

    let data: ref<PossessionScannerData> = new PossessionScannerData();
    data.targetID = targetID;

    if !IsDefined(puppet) {
      data.isPossessed = false;
      return data;
    }

    // Check if enemy is possessed
    let possessionSystem: ref<PossessionSpreadSystem> = GetPossessionSpreadSystem();
    let possessedEnemy: ref<PossessedEnemy> = possessionSystem.GetPossessedEnemy(targetID);

    if !IsDefined(possessedEnemy) {
      data.isPossessed = false;
      return data;
    }

    // Enemy is possessed - get detailed data
    data.isPossessed = true;
    data.possessionState = possessedEnemy.GetState();
    data.aiEntityName = possessedEnemy.GetAIEntityName();
    data.corruptionLevel = possessedEnemy.GetCorruptionLevel();
    data.timeInState = possessedEnemy.GetTimeInCurrentState();

    // Get exorcism progress if being exorcised
    let exorcismTracker: ref<ExorcismStackTracker> = GetExorcismStackTracker();
    data.exorcismStacks = exorcismTracker.GetStacks(targetID);
    data.exorcismProgress = Cast<Float>(data.exorcismStacks) / 10.0;

    // Check if Neural Scramble active
    let preventionSystem: ref<PossessionPreventionSystem> = GetPossessionPreventionSystem();
    data.hasNeuralScramble = preventionSystem.HasNeuralScramble(targetID);

    return data;
  }

  // Get cached data
  private func GetCachedData(targetID: EntityID) -> ref<PossessionScannerData> {
    let i: Int32 = 0;
    while i < ArraySize(this.m_scannerDataCache) {
      if Equals(this.m_scannerDataCache[i].targetID, targetID) {
        return this.m_scannerDataCache[i];
      }
      i += 1;
    }

    return null;
  }

  // Clear cache for target
  public func ClearCacheForTarget(targetID: EntityID) -> Void {
    let i: Int32 = 0;
    while i < ArraySize(this.m_scannerDataCache) {
      if Equals(this.m_scannerDataCache[i].targetID, targetID) {
        ArrayErase(this.m_scannerDataCache, i);
      } else {
        i += 1;
      }
    }
  }

  // Clear entire cache
  public func ClearCache() -> Void {
    ArrayClear(this.m_scannerDataCache);
  }
}

// Possession scanner data
public class PossessionScannerData {
  public let targetID: EntityID;
  public let isPossessed: Bool;
  public let possessionState: PossessionState;
  public let aiEntityName: String;
  public let corruptionLevel: Float;
  public let timeInState: Float;
  public let exorcismStacks: Int32;
  public let exorcismProgress: Float;
  public let hasNeuralScramble: Bool;
}

// Global accessor
public static func GetScannerPossessionDataProvider() -> ref<ScannerPossessionDataProvider> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.ScannerPossessionDataProvider") as ScannerPossessionDataProvider;
}

// ==================================================
// SCANNER UI OVERLAY
// ==================================================

public class PossessionScannerOverlay extends inkGameController {
  private let m_rootWidget: wref<inkCanvas>;
  private let m_stateText: wref<inkText>;
  private let m_entityNameText: wref<inkText>;
  private let m_corruptionBar: wref<inkWidget>;
  private let m_exorcismBar: wref<inkWidget>;
  private let m_warningText: wref<inkText>;
  private let m_currentTargetID: EntityID;

  protected cb func OnInitialize() -> Bool {
    this.CreateUI();
    LogChannel(n"BTW", "[ScannerOverlay] Possession scanner overlay initialized");
  }

  // Create UI elements
  private func CreateUI() -> Void {
    this.m_rootWidget = this.GetRootWidget() as inkCanvas;

    // Create state text
    let stateText: ref<inkText> = new inkText();
    stateText.SetName(n"StateText");
    stateText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    stateText.SetFontSize(24);
    stateText.SetLetterCase(textLetterCase.UpperCase);
    stateText.SetText("POSSESSION STATE: UNKNOWN");
    stateText.SetTintColor(new HDRColor(1.0, 1.0, 1.0, 1.0));
    stateText.SetAnchor(inkEAnchor.TopLeft);
    stateText.SetMargin(new inkMargin(20.0, 100.0, 0.0, 0.0));
    this.m_stateText = stateText;
    this.m_rootWidget.AddChild(stateText);

    // Create entity name text
    let entityNameText: ref<inkText> = new inkText();
    entityNameText.SetName(n"EntityNameText");
    entityNameText.SetFontFamily("base\\gameplay\\gui\\fonts\\raj\\raj.inkfontfamily");
    entityNameText.SetFontSize(20);
    entityNameText.SetText("AI ENTITY: UNKNOWN");
    entityNameText.SetTintColor(new HDRColor(0.6, 0.8, 1.0, 1.0));
    entityNameText.SetAnchor(inkEAnchor.TopLeft);
    entityNameText.SetMargin(new inkMargin(20.0, 130.0, 0.0, 0.0));
    this.m_entityNameText = entityNameText;
    this.m_rootWidget.AddChild(entityNameText);

    // TODO: Create corruption bar, exorcism bar, warning text
  }

  // Update display for target
  public func UpdateDisplay(targetID: EntityID) -> Void {
    this.m_currentTargetID = targetID;

    // Get possession data
    let dataProvider: ref<ScannerPossessionDataProvider> = GetScannerPossessionDataProvider();
    let data: ref<PossessionScannerData> = dataProvider.GetPossessionData(targetID);

    if !IsDefined(data) || !data.isPossessed {
      this.ShowNoPossession();
      return;
    }

    // Update state text
    this.UpdateStateText(data.possessionState);

    // Update entity name
    this.UpdateEntityName(data.aiEntityName);

    // Update corruption level
    this.UpdateCorruptionBar(data.corruptionLevel);

    // Update exorcism progress if applicable
    if data.exorcismStacks > 0 {
      this.UpdateExorcismBar(data.exorcismProgress);
      this.ShowExorcismProgress(data.exorcismStacks);
    }

    // Show warnings
    this.UpdateWarnings(data);

    // Set visibility
    this.m_rootWidget.SetVisible(true);
  }

  // Update state text with color coding
  private func UpdateStateText(state: PossessionState) -> Void {
    let stateText: String;
    let stateColor: HDRColor;

    switch state {
      case PossessionState.Latent:
        stateText = "POSSESSION STATE: LATENT";
        stateColor = new HDRColor(0.2, 0.5, 1.0, 1.0);  // Light blue
        break;
      case PossessionState.Active:
        stateText = "POSSESSION STATE: ACTIVE";
        stateColor = new HDRColor(0.4, 0.7, 1.0, 1.0);  // Medium blue
        break;
      case PossessionState.Overwhelmed:
        stateText = "POSSESSION STATE: OVERWHELMED";
        stateColor = new HDRColor(0.6, 0.8, 1.0, 1.0);  // Bright blue
        break;
    }

    this.m_stateText.SetText(stateText);
    this.m_stateText.SetTintColor(stateColor);
  }

  // Update entity name
  private func UpdateEntityName(entityName: String) -> Void {
    let displayText: String = "AI ENTITY: " + entityName;
    this.m_entityNameText.SetText(displayText);
  }

  // Update corruption bar
  private func UpdateCorruptionBar(corruptionLevel: Float) -> Void {
    // TODO: Implement progress bar visualization
    // Should show 0-100% corruption level
  }

  // Update exorcism bar
  private func UpdateExorcismBar(progress: Float) -> Void {
    // TODO: Implement progress bar visualization
    // Should show 0-100% exorcism progress (10 stacks)
  }

  // Show exorcism progress
  private func ShowExorcismProgress(stacks: Int32) -> Void {
    // Show text like "EXORCISM: 3/10 STACKS"
    let progressText: String = "EXORCISM: " + ToString(stacks) + "/10 STACKS";
    // TODO: Display this text
  }

  // Update warnings
  private func UpdateWarnings(data: ref<PossessionScannerData>) -> Void {
    let warnings: array<String>;

    // Check for spread risk
    if Equals(data.possessionState, PossessionState.Active) {
      ArrayPush(warnings, "⚠ SPREAD RISK: 30% ON DEATH");
    } else if Equals(data.possessionState, PossessionState.Overwhelmed) {
      ArrayPush(warnings, "⚠ CRITICAL: 100% SPREAD ON DEATH");
    }

    // Check for state progression
    if data.timeInState > 45.0 && NotEquals(data.possessionState, PossessionState.Overwhelmed) {
      ArrayPush(warnings, "⚠ STATE PROGRESSION IMMINENT");
    }

    // Check for Neural Scramble
    if data.hasNeuralScramble {
      ArrayPush(warnings, "✓ NEURAL SCRAMBLE ACTIVE");
    }

    // TODO: Display warnings
    let warningText: String = "";
    let i: Int32 = 0;
    while i < ArraySize(warnings) {
      warningText += warnings[i];
      if i < ArraySize(warnings) - 1 {
        warningText += "\n";
      }
      i += 1;
    }
  }

  // Show no possession message
  private func ShowNoPossession() -> Void {
    this.m_stateText.SetText("NO POSSESSION DETECTED");
    this.m_stateText.SetTintColor(new HDRColor(0.5, 0.5, 0.5, 1.0));
    this.m_entityNameText.SetVisible(false);
    // Hide other elements
  }

  // Hide overlay
  public func Hide() -> Void {
    this.m_rootWidget.SetVisible(false);
  }
}

// ==================================================
// SCANNER EXTENSION
// ==================================================

// Extension to vanilla scanner to show possession data
@addMethod(ScannerGameController)
protected cb func OnPossessionScanUpdate(evt: ref<PossessionScanUpdateEvent>) -> Bool {
  // Get possession overlay
  // TODO: Get or create possession overlay widget

  // Update with target ID
  // possessionOverlay.UpdateDisplay(evt.targetID);
}

// Event for possession scan updates
public class PossessionScanUpdateEvent extends Event {
  public let targetID: EntityID;
}

// ==================================================
// TARGETED ENEMY OVERLAY
// ==================================================

public class TargetedEnemyPossessionMarker extends ScriptableSystem {
  private let m_currentTarget: EntityID;
  private let m_markerActive: Bool;

  private func OnAttach() -> Void {
    this.m_markerActive = false;

    LogChannel(n"BTW", "[TargetMarker] Possession marker system initialized");
  }

  // Show marker for possessed enemy
  public func ShowMarker(targetID: EntityID, possessionState: PossessionState) -> Void {
    this.m_currentTarget = targetID;
    this.m_markerActive = true;

    // Get color based on state
    let markerColor: Color = PossessionVisualPresets.GetEyeGlowColor(possessionState);

    // TODO: Create world-space marker above enemy's head
    // Should show:
    // - Possession state icon
    // - Corruption level bar
    // - Exorcism progress (if being exorcised)

    LogChannel(n"BTW", s"[TargetMarker] Marker shown for target");
  }

  // Update marker
  public func UpdateMarker(exorcismStacks: Int32) -> Void {
    if !this.m_markerActive {
      return;
    }

    // Update exorcism progress
    // TODO: Update marker UI
  }

  // Hide marker
  public func HideMarker() -> Void {
    this.m_markerActive = false;
    // TODO: Hide marker UI
  }
}

// Global accessor
public static func GetTargetedEnemyPossessionMarker() -> ref<TargetedEnemyPossessionMarker> {
  let gameInstance: GameInstance = GetGameInstance();
  return GameInstance.GetScriptableSystemsContainer(gameInstance).Get(n"BeyondTheWall.VFX.TargetedEnemyPossessionMarker") as TargetedEnemyPossessionMarker;
}
