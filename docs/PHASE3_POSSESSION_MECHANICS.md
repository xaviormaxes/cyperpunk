# Phase 3: AI Possession Mechanics - Technical Documentation

## Overview

Phase 3 implements the complete AI possession system that makes enemies from the 2073 outbreak terrifyingly dynamic. Possessed enemies can spread their corruption to others, progress through states, and exhibit unique AI behaviors.

## 🧬 **Core Systems**

### 1. Possession Spread System

**Purpose:** Manages the spread of AI possession when enemies die.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionSpreadSystem.reds`

#### How Possession Spreading Works:

```
Possessed Enemy Dies
↓
Check Possession State (can it spread?)
↓
Roll Spread Chance
↓
Find Nearby Enemies (within radius)
↓
Spread to Valid Targets
↓
Apply Possession to New Targets
```

#### Spread Mechanics by State:

| State | Can Spread? | Chance | Radius | Max Targets |
|-------|-------------|--------|--------|-------------|
| **Latent** | ❌ No | 0% | 0m | 0 |
| **Active** | ✅ Yes | 30% | 10m | 1 |
| **Overwhelmed** | ✅ Yes | 100% | 15m | 3 |

**Key Features:**
- Dynamic spread calculation
- Prevention mechanisms (Neural Scramble)
- Spread history tracking for debugging
- Event recording system

**Example Code:**
```swift
// When enemy dies
let spreadSystem: ref<PossessionSpreadSystem> = GetPossessionSpreadSystem();
spreadSystem.OnPossessedEnemyDeath(enemy, killerPosition);

// System automatically:
// 1. Checks if can spread
// 2. Rolls chance
// 3. Finds targets
// 4. Spreads possession
```

---

### 2. Possession Prevention System

**Purpose:** Handles debuffs and effects that prevent possession spread.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionSpreadSystem.reds`

#### Prevention Methods:

**Neural Scramble (R.A.B.I.D.S. Remnant)**
- Applied when hit by R.A.B.I.D.S. Remnant pistol
- Duration: 10 seconds
- Effect: Prevents this enemy from spreading possession when killed
- Visual: Shield icon, blue particles

**Exorcism Stacks (Digital Exorcist)**
- Applied by Digital Exorcist SMG hits
- Stacks: 0-10
- At 10 stacks: Complete AI purge
- Stack decay: 5 seconds without hit
- Visual: White light particles, intensity increases with stacks

**Possession Break (NetWatch Disruptor)**
- Charged shot from NetWatch Disruptor
- Effect: Immediately breaks possession, frees target
- Duration: 5 seconds of freedom
- Visual: Bright flash, AI entity expelled

#### Exorcism System:

```
Hit 1-9: Build Exorcism Stacks
↓
Visual feedback (white particles increase)
↓
Hit 10: COMPLETE EXORCISM
↓
AI entity purged from body
↓
Enemy freed, cannot be re-possessed for 30s
```

**Implementation:**
```swift
// Apply Neural Scramble
let preventionSystem = GetPossessionPreventionSystem();
preventionSystem.ApplyNeuralScramble(targetID, 10.0);

// Track exorcism stacks
let tracker = GetExorcismStackTracker();
let stacks = tracker.AddStack(targetID);  // Returns current stack count

// Complete exorcism at 10 stacks
if stacks >= 10 {
  // AI is purged!
}
```

---

### 3. Possession Visual Effects System

**Purpose:** Renders visual indicators for possessed enemies.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionVisuals.reds`

#### Visual Effects by State:

**Latent Possession:**
- Eye glow: Subtle blue (RGB: 51, 128, 255), 30% intensity
- Particle effect: Minimal shimmer around head
- Aura: None
- Screen effect: Slight glitch when looking at them

**Active Possession:**
- Eye glow: Bright blue (RGB: 102, 178, 255), 70% intensity
- Particle effect: Blue energy around body
- Aura: Distortion field
- Screen effect: Moderate glitch

**Overwhelmed Possession:**
- Eye glow: Blue-white (RGB: 153, 204, 255), 100% intensity
- Body glow: Full body illumination
- Particle effect: Crackling energy, heavy corruption
- Aura: 3m corruption aura (damages nearby)
- Screen effect: Heavy distortion, reality tears

#### Special Effect Types:

**Spread Effect:**
- Dark energy stream from dead enemy to target
- Blue particle trail
- Digital screech sound
- Shows possession "jumping" to new host

**Exorcism Effect:**
- White light particles (scale with stack count)
- Glowing outline on target
- At completion: Bright expulsion burst
- Sound: Purification tone

**Possession Break:**
- Bright white flash
- AI entity expelled upward (visible digital form)
- Screen shake
- Sound: Digital scream

**Banishment (Oni no Kiru critical):**
- Violent AI expulsion
- Reality tear opens briefly
- Black tendrils pull entity through
- Leaves corruption residue on ground

---

### 4. Possession UI System

**Purpose:** Displays information about possessed enemies to player.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionVisuals.reds`

#### UI Elements:

**Enemy Health Bar Modifications:**
- Color-coded by possession state:
  - Latent: Light blue
  - Active: Blue
  - Overwhelmed: Red (danger)

**Possession State Icon:**
- Above enemy head
- Shows current state
- Pulsing animation for Overwhelmed

**AI Entity Name:**
- Displays which AI is controlling enemy
- Examples: "Minor AI", "Erebus Fragment", "Digital Construct"
- Color matches possession state

**Exorcism Progress Bar:**
- Appears when exorcism stacks building
- Fills 0-100% (based on stacks/10)
- Color shifts blue → white as it fills
- Flashes on completion

**Neural Scramble Indicator:**
- Shield icon above enemy
- Timer countdown showing remaining duration
- Blue pulsing effect

**Spread Warning:**
- Red pulsing circle on ground showing spread radius
- Appears when enemy dies and spread is possible
- Warning icon for nearby allies

#### Scanner Integration:

```swift
// Scanner shows:
- Possession State: "Active Possession - Minor AI"
- Exorcism Stacks: "7/10"
- Neural Scramble Status: "Protected (5s)"
- Spread Potential: "High - Keep Distance!"
```

---

### 5. Possession Behavior System

**Purpose:** Modifies AI behavior based on possession state.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionBehavior.reds`

#### Behavior Modifications:

**Latent Possession:**
```
Movement:
- Occasional irregular movements
- Head twitches
- Slightly enhanced reflexes

Combat:
- Normal aggression
- +15% damage
- +20% health

Special:
- Group coordination (move together)
- Sometimes stare at player
- Can be commanded by stronger AI
```

**Active Possession:**
```
Movement:
- Synchronized with other possessed
- Perfect flanking coordination
- Aggressive pursuit

Combat:
- +35% damage
- +50% health
- Enhanced cyberware usage
- Tactical combat awareness

Special:
- Prioritizes spreading infection
- Protects Overwhelmed allies
- Calls for reinforcements
```

**Overwhelmed Possession:**
```
Movement:
- Erratic, unpredictable
- No self-preservation
- Will charge into danger

Combat:
- +75% damage
- +100% health
- 50% quickhack resistance
- Attacks EVERYTHING (hostile to all)
- Berserker mode

Special:
- Will sacrifice self to spread
- Corrupts nearby area
- Cannot be reasoned with
- Extremely dangerous
```

#### Stat Multipliers:

| Stat | Latent | Active | Overwhelmed |
|------|--------|--------|-------------|
| Health | +20% | +50% | +100% |
| Damage | +15% | +35% | +75% |
| Quickhack Resist | - | - | +50% |
| Movement Speed | - | +10% | +25% |

---

### 6. State Progression System

**Purpose:** Manages possession state transitions over time.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionBehavior.reds`

#### Progression Flow:

```
Latent (Initial Possession)
↓ (60 seconds in combat)
Active (Full AI Control)
↓ (60 seconds in combat)
Overwhelmed (Complete Takeover)
```

**Progression Triggers:**
- Time in combat: 60 seconds per tier
- Taking heavy damage: Can trigger early progression
- Scripted events: Boss fights force progression

**Visual Feedback:**
- Transformation animation
- Particle effect burst
- Eye glow intensifies
- Warning message to player

**Cannot Progress If:**
- Neural Scramble active
- Being exorcised (stacks > 5)
- Possession broken recently

---

### 7. Group Coordination System

**Purpose:** Makes possessed enemies work together.

**File:** `r6/scripts/BeyondTheWall/AI/PossessionBehavior.reds`

#### Coordination Features:

**Synchronized Movement:**
- Enemies possessed by same AI entity move together
- Maintain formation
- Coordinated flanking
- Simultaneous attacks

**Shared Awareness:**
- If one sees player, all know
- Share tactical information
- Coordinate target priority

**Protection Behavior:**
- Lower tiers protect higher tiers
- Overwhelmed enemies get priority
- Will sacrifice Latent to save Active

**Communication:**
- Speak in unison sometimes
- Share AI entity's voice
- Creepy synchronized dialogue

**Example:**
```
Group of 5 enemies possessed by "Erebus Fragment"
- 2 Latent (scouts)
- 2 Active (main force)
- 1 Overwhelmed (priority target)

Behavior:
- Latent enemies flank and distract
- Active enemies attack directly
- Overwhelmed charges player
- All move in perfect coordination
- If Overwhelmed threatened, others protect it
```

---

## 🎮 **Gameplay Integration**

### Combat Flow with Possession:

```
1. Encounter possessed enemies
   ↓
2. Use scanner to identify states
   ↓
3. Prioritize Overwhelmed (most dangerous)
   ↓
4. Apply Neural Scramble to prevent spread
   ↓
5. Build Exorcism stacks with Digital Exorcist
   ↓
6. Break possession with NetWatch Disruptor
   ↓
7. Free enemies or eliminate threats
```

### Strategic Decisions:

**Do I use Neural Scramble?**
- Yes, if surrounded by enemies (prevents chain spread)
- Yes, if enemy is Overwhelmed (100% spread chance)
- No, if isolated enemy (no spread risk)

**Do I go for Exorcism?**
- Yes, to save important NPCs
- Yes, to reduce enemy count without killing
- No, if time-critical situation

**Do I break possession or kill?**
- Break: Saves ammo, reduces spread risk
- Kill: Faster, but risks spreading

---

## 📊 **Technical Specifications**

### Performance:

**Spread Calculations:**
- Only run on enemy death
- Radius checks are optimized
- Maximum 1-3 targets per spread

**Visual Effects:**
- LOD system (fade at distance)
- Configurable intensity
- Can be disabled for performance

**Group Coordination:**
- Updates every 0.5 seconds
- Only for groups of 2+
- Maximum group size: 10 enemies

### Save Data:

**What Gets Saved:**
- Spread event history (last 50)
- Exorcism stack data
- Neural Scramble durations
- Possession state per enemy

**What Doesn't:**
- Visual effect states (regenerated)
- Temporary behavior mods (reapplied)
- Coordination data (recalculated)

---

## 🔧 **Configuration**

### Spread System Config:

```json
{
  "spreadEnabled": true,
  "spreadChances": {
    "active": 0.3,
    "overwhelmed": 1.0
  },
  "spreadRadius": {
    "active": 10.0,
    "overwhelmed": 15.0
  },
  "maxTargets": {
    "active": 1,
    "overwhelmed": 3
  }
}
```

### Progression Config:

```json
{
  "progressionEnabled": true,
  "timeThreshold": 60.0,
  "damageThreshold": 500.0,
  "allowEarlyProgression": true
}
```

### Visual Effects Config:

```json
{
  "effectsEnabled": true,
  "intensity": 1.0,
  "showPossessionIndicators": true,
  "showExorcismProgress": true,
  "lodDistance": 50.0
}
```

---

## 🐛 **Debug Commands**

Phase 3 adds no new debug commands (uses existing systems), but you can test with:

```lua
-- Spawn possessed enemy (future)
btw.spawn_possessed("PossessedTechnician", "Active")

-- Test spread manually
btw.test_spread(3)  -- Test spread to 3 targets

-- Check possession stats
btw.possession_stats()
-- Shows: Total possessed, groups, spread events

-- Toggle spread system
btw.toggle_spread()  -- Disable/enable spreading
```

---

## 📈 **Gameplay Balance**

### Spread Mechanics Balance:

**Why 30% for Active?**
- Not guaranteed = tactical choices matter
- Too high = overwhelming player quickly
- Too low = spread never happens

**Why 100% for Overwhelmed?**
- Ultimate threat
- Rewards player for killing Latent/Active first
- Creates tension ("Don't let it get close to others!")

### Exorcism Balance:

**Why 10 stacks?**
- High enough to require commitment
- Low enough to be achievable
- ~1.5 seconds of sustained fire with SMG

**Why 5 second decay?**
- Punishes missed shots
- Rewards accuracy
- Makes it skillful, not automatic

### State Progression Balance:

**Why 60 seconds?**
- Long enough for skilled players to clear area
- Short enough to create pressure
- Can be shortened by player actions (damage)

---

## 🎯 **Implementation Status**

### ✅ Completed (Phase 3):
- [x] Possession spread system
- [x] Spread chance calculation
- [x] Target finding logic
- [x] Prevention system (Neural Scramble, Exorcism, Break)
- [x] Exorcism stack tracker
- [x] Visual effects framework
- [x] UI marker system
- [x] Behavior modification system
- [x] Stat multiplier system
- [x] State progression system
- [x] Group coordination system

### ⏳ Phase 4 (Next):
- [ ] Actual visual effect rendering (shaders, particles)
- [ ] Sound effects for all events
- [ ] Scanner integration (show possession info)
- [ ] Animation system for state transitions
- [ ] Full group AI coordination behavior

### 📝 **Notes for Phase 4**:

When implementing actual visual effects:

**Priority 1:**
1. Eye glow effects (most important visual cue)
2. Spread effect (shows possession jumping)
3. Exorcism particles (clear feedback)

**Priority 2:**
4. State transition animations
5. Aura effects (Overwhelmed)
6. Screen distortion

**Priority 3:**
7. UI markers
8. Scanner integration
9. Polish effects

---

## 🔗 **Integration with Other Systems**

### With Weapons:

**R.A.B.I.D.S. Remnant:**
```swift
// On hit
preventionSystem.ApplyNeuralScramble(targetID, 10.0);
```

**Digital Exorcist:**
```swift
// On hit
tracker.AddStack(targetID);
if stacks >= 10 {
  // Purge AI
}
```

**NetWatch Disruptor:**
```swift
// On charged hit
possessedEnemy.BreakPossession();
```

**Oni no Kiru:**
```swift
// On critical
visualsSystem.PlayBanishmentEffect(target, 15.0);
// AI banished for 15s
```

### With Depth System:

```swift
// Deeper levels = more dangerous possessed
depth 4-5: More Overwhelmed enemies spawn
depth 1-2: Mostly Latent
depth 3: Mix of all states
```

### With Corruption System:

```swift
// Being near Overwhelmed enemies increases corruption
auraRadius = 3.0m
corruptionRate = 0.5/sec within aura
```

---

## 💀 **Example Combat Scenario**

**Location:** Depth 3 - Deep Dive Lab
**Enemies:** 6 Possessed Technicians (4 Latent, 2 Active)

```
Round 1: Engagement
- Player scans: Identifies 4 Latent, 2 Active
- Uses R.A.B.I.D.S. Remnant on Active enemies (prevent spread)
- Kills 1 Latent with headshot

Round 2: Spread Attempt
- Dead Latent cannot spread (Latent state)
- Other Latent enemies coordinating, moving together
- Active enemies advancing aggressively

Round 3: Strategic Exorcism
- Player switches to Digital Exorcist
- Focuses one Active enemy
- Builds stacks: 1...5...8...10
- EXORCISM COMPLETE - AI purged!
- Enemy freed, confused, no longer threat

Round 4: Spread Success
- Player kills remaining Active (no Neural Scramble)
- Spread roll: SUCCESS (30% chance)
- AI jumps to nearest Latent
- Visual: Dark energy stream, target's eyes light up
- Now Active possession on that enemy

Round 5: Escalation
- 60 seconds have passed
- Remaining Active enemy progresses to Overwhelmed
- Visual: Transformation burst, eyes go white-blue
- Overwhelmed attacks everything
- Player and remaining enemies both in danger

Round 6: Desperate Measures
- Player uses NetWatch Disruptor charged shot
- EMP blast breaks possession
- Overwhelmed enemy freed
- 5 second window to finish fight before re-possession possible

Result: 3 enemies freed (exorcism/break), 3 killed, no casualties
```

---

## 🎓 **Best Practices**

### For Modders:

**Adding New Possession States:**
```swift
// 1. Add to PossessionState enum
// 2. Add visual preset in PossessionVisualPresets
// 3. Add behavior in PossessionBehaviorSystem
// 4. Add spread parameters in PossessionSpreadSystem
// 5. Update UI colors
```

**Custom Prevention Methods:**
```swift
// Create new status effect
// Register with PossessionPreventionSystem
// Add visual indicator
// Test spread blocking
```

### For Players:

**Survival Tips:**
1. Always scan before engaging
2. Prioritize Overwhelmed enemies
3. Use Neural Scramble on grouped enemies
4. Exorcise to save NPCs
5. Keep distance when Overwhelmed enemy dies (spread radius!)
6. Watch for state progression (60s timer)
7. Anti-AI weapons are essential in deep levels

---

## 📚 **API Reference**

### Key Functions:

```swift
// Spread System
GetPossessionSpreadSystem()
.OnPossessedEnemyDeath(enemy, killerPos)
.SetSpreadEnabled(bool)

// Prevention System
GetPossessionPreventionSystem()
.ApplyNeuralScramble(targetID, duration)
.CompleteExorcism(targetID)

// Exorcism Tracker
GetExorcismStackTracker()
.AddStack(targetID) -> int
.GetStacks(targetID) -> int

// Visual System
GetPossessionVisualsSystem()
.ApplyPossessionVisuals(enemy, state)
.PlaySpreadEffect(sourcePos, targetPos)
.PlayExorcismEffect(target, progress)

// Behavior System
GetPossessionBehaviorSystem()
.ApplyBehaviorMods(enemy, state)
.GetStatMultiplier(state, statType) -> float

// Progression System
GetPossessionStateProgressionSystem()
.CheckProgression(enemy, timeInCombat) -> bool
.ForceProgression(enemy)

// Group Coordination
GetPossessedGroupCoordinationSystem()
.AddToGroup(enemy, aiEntityName)
.GetGroupMembers(aiEntityName) -> array
.GetTotalPossessedCount() -> int
```

---

**Phase 3 Complete!**

The possession system is fully implemented at the logic level. Phase 4 will add the visual polish (shaders, particles, sounds) that brings it all to life.

*"They move together. They think together. They are one mind in many bodies. And they're coming for you."*