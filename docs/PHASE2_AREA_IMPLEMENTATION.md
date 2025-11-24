# Phase 2: Area Implementation - Technical Documentation

## Overview

Phase 2 implements the Blackwall Breach Zone - a multi-depth facility where players progressively descend into areas of increasing Blackwall corruption. This phase builds on Phase 1's corruption and mastery systems by adding physical zones, environmental storytelling, and interactive elements.

## 🏗️ Architecture

### Depth Progression System (`DepthProgression.reds`)

**Purpose:** Tracks player position and manages transitions between 5 depth zones.

**Key Components:**
- `DepthZone` class - Defines zone properties (position, radius, corruption multiplier)
- `BlackwallDepthProgressionSystem` - Main system tracking player location
- Zone detection via position/radius checks (runs every 1 second)
- Automatic depth transitions with notifications

**Depth Zones:**
```
Depth 1: Surface Contact (-100, 50, 10) - 30m radius
Depth 2: Protocol Breach (-150, 50, 10) - 25m radius
Depth 3: Deep Dive (-200, 50, 5) - 25m radius
Depth 4: Old Net Interface (-250, 50, 0) - 20m radius
Depth 5: Beyond the Veil (-300, 50, -5) - 15m radius
```

**Passive Corruption:**
- Base rate: 0.1 corruption/sec * depth level
- Multiplied by zone's corruption multiplier
- Only applies when in facility zones
- Stops when player leaves facility

### Stabilizer Node System (`StabilizerNode.reds`)

**Purpose:** Interactive devices that reduce corruption at the cost of limited uses.

**Features:**
- 3 uses per node (configurable per node)
- 60-second cooldown between uses (configurable)
- 25 corruption reduction per use (configurable)
- Visual feedback for usage/depletion
- Strategic placement throughout facility

**Placement Strategy:**
- Depth 1-3: 2 stabilizers each (easier access)
- Depth 4: 1 stabilizer (30 reduction, 2 uses, 90s cooldown)
- Depth 5: 1 stabilizer (50 reduction, 1 use, 120s cooldown)

**Total: 8 stabilizer nodes**

### Environmental Storytelling (`EnvironmentalStory.reds`)

**Purpose:** Lore delivery through terminals and data shards.

**Terminals (8 total):**
- Depth 1: Facility entry log
- Depth 2: Security reports, system status
- Depth 3: Corrupted logs, breach documentation
- Depth 4: AI communications (dangerous, can damage player)
- Depth 5: Fully corrupted terminal (rewards mastery XP)

**Terminal Content Progression:**
- Normal → Warning signs → Breach → AI takeover → Full corruption
- Text corruption increases with depth (visual ̷g̴l̷i̸t̸c̶h̵ effects)
- Tells story of Dr. Chen, Martinez, and facility outbreak

**Data Shards (5 total):**
1. Dr. Chen's Personal Log - Early concerns about Blackwall
2. Security Incident Report - First possession cases
3. Evacuation Order (Never Sent) - The breach begins
4. Martinez's Final Message - Last moments before lockdown
5. The Truth About Songbird - Connection to Phantom Liberty

**Lore Integration:**
- Ties to existing CP2077 lore (Phantom Liberty, Songbird)
- Explains rogue AI behavior
- Foreshadows what player will encounter
- Creates tension through environmental narrative

### Visual Effects System (`VisualEffects.reds`)

**Purpose:** Phase 4 placeholder system for depth-based visual corruption.

**Planned Effects by Depth:**

**Depth 1:** Minimal
- 5% screen flicker
- Slight blue tint
- Minimal HUD glitches

**Depth 2:** Screen Distortion
- 10-15% distortion intensity
- HUD glitches
- Static noise overlay
- Blue color grading

**Depth 3:** Vision Blackouts
- 25% distortion
- Random 0.5s vision blackouts
- Geometry edge distortion
- Corrupted UI elements

**Depth 4:** Reality Warping
- 40% distortion
- Geometry warping
- Time dilation effects
- Phantom entities in periphery
- Severe HUD corruption

**Depth 5:** Full Corruption
- 60% distortion
- Constant geometry warping
- Void effects (black tendrils)
- Extreme color aberration
- Partial HUD failure
- Audio distortion

**Effect Parameters:**
- `ScreenGlitchParams` - Intensity, frequency, duration
- `GeometryDistortionParams` - Wave amplitude/frequency
- `ColorGradingParams` - Hue shift, saturation, tint
- `VoidEffectParams` - Tendril count, opacity, speed

### Area Configuration (`blackwall_facility.yaml`)

**Purpose:** Centralized configuration for all zones, placements, and features.

**Structure:**
```yaml
Zones:
  - Depth zones with positions, radii, corruption multipliers
StabilizerNodes:
  - Exact positions, uses, cooldowns
Terminals:
  - Positions, content references, hack requirements
DataShards:
  - Positions, hidden status, unlock requirements
EntryPoints:
  - Main entrance and emergency exit
```

**Key Stats:**
- 5 depth zones
- 8 stabilizer nodes
- 8 terminals
- 5 data shards
- 2 entry points

## 🎮 Gameplay Flow

### Player Experience:

1. **Enter Facility** → Depth 1: Surface Contact
   - Read entrance terminal (facility introduction)
   - Find Dr. Chen's first shard
   - Corruption begins accumulating slowly
   - Use first stabilizer if needed

2. **Descend to Server Rooms** → Depth 2: Protocol Breach
   - Corruption rate increases (1.2x multiplier)
   - Read security reports (things going wrong)
   - Find Ramirez's incident report
   - More frequent stabilizer use needed

3. **Enter Experimental Labs** → Depth 3: Deep Dive
   - Corruption rate higher (1.5x multiplier)
   - Vision effects become noticeable
   - Read corrupted logs about breach
   - Find evacuation order (never sent)
   - Strategic stabilizer use critical

4. **Reach Containment Core** → Depth 4: Old Net Interface
   - Corruption rate doubles (2.0x multiplier)
   - Reality distortion visible
   - Terminals can damage player
   - Find Martinez's final message
   - Limited stabilizer access

5. **Breach Point** → Depth 5: Beyond the Veil
   - Corruption rate triples (3.0x multiplier)
   - Full visual corruption active
   - Read about Songbird connection
   - Final emergency stabilizer
   - Must have high mastery to survive

### Strategic Elements:

**Corruption Management:**
- Passive corruption increases with depth
- Stabilizers have limited uses
- Must balance exploration vs. corruption risk
- High mastery reduces corruption gain

**Progression Gating:**
- Depth 5 requires 100 mastery (auto-unlock)
- Higher depths need better corruption control
- Strategic use of Stabilize quickhack
- Risk/reward: deeper = more powerful but more dangerous

## 🔧 Debug Commands (New in Phase 2)

```lua
btw.teleport(depth)  -- Teleport to specific depth zone
btw.zone()          -- Show current zone information
```

**Testing Workflow:**
```lua
-- Teleport to depth 3
btw.teleport(3)

-- Check status
btw.zone()
-- Shows:
-- Current Zone: Depth 3 - Deep Dive
-- In Facility: YES
-- Corruption Multiplier: 1.5x
-- Ambient Corruption: 0.3/sec

-- Watch corruption increase
btw.status()
-- Corruption will passively accumulate

-- Use stabilizer
-- (Would interact with stabilizer node in-game)

-- Leave facility
btw.teleport(0)
btw.zone()
-- Shows: Outside Facility
-- Corruption begins decaying
```

## 📁 File Structure (Phase 2 Additions)

```
r6/scripts/BeyondTheWall/
├── Core/
│   ├── CorruptionSystem.reds (Phase 1)
│   ├── MasterySystem.reds (Phase 1)
│   ├── BlackwallIntegration.reds (Phase 1)
│   └── DepthProgression.reds ✨ NEW
│
└── Location/ ✨ NEW DIRECTORY
    ├── StabilizerNode.reds
    ├── EnvironmentalStory.reds
    └── VisualEffects.reds (Phase 4 placeholder)

r6/tweaks/
├── blackwall_quickhacks.yaml (Phase 1)
└── blackwall_facility.yaml ✨ NEW

bin/.../BeyondTheWall/modules/
├── corruption.lua (Phase 1)
├── mastery.lua (Phase 1)
├── ui.lua (Phase 1)
└── debug.lua (Updated with zone commands)

docs/ ✨ NEW DIRECTORY
└── PHASE2_AREA_IMPLEMENTATION.md (This file)
```

## 🔗 Integration with Phase 1

### Corruption System Integration:
```lua
-- CET side (Lua)
corruption:SetInDeepZone(true, depth)  -- Called when entering zones
corruption:Add(amount, mastery)        -- Passive corruption

-- REDscript side
corruptionSystem.SetInDeepZone(true, depth)
corruptionSystem.AddCorruption(amount, mastery)
```

### Mastery System Integration:
```lua
-- Depth unlocks tied to mastery
mastery >= 10  -> Depth 2 unlocked
mastery >= 25  -> Depth 3 unlocked
mastery >= 50  -> Depth 4 unlocked
mastery >= 100 -> Depth 5 unlocked
```

### Event Flow:
```
Player moves → DepthProgression checks position
             → Detects new zone
             → Calls corruptionSystem.SetInDeepZone()
             → Updates corruption multiplier
             → Passive corruption applies
             → Visual effects update (Phase 4)
```

## 🎯 Implementation Status

### ✅ Completed (Phase 2):
- [x] Depth progression system with 5 zones
- [x] Zone detection and transition logic
- [x] Stabilizer node system (8 nodes placed)
- [x] Environmental storytelling (8 terminals, 5 shards)
- [x] Lore content written and implemented
- [x] Passive corruption in zones
- [x] Area configuration (YAML)
- [x] Visual effects structure (Phase 4 prep)
- [x] Debug commands for zone testing
- [x] Documentation

### ⏳ Phase 3 (Next):
- [ ] AI possession system
- [ ] Possession visual indicators
- [ ] Possession spread mechanics
- [ ] Enemy AI modifications
- [ ] Possession state UI

### ⏳ Phase 4 (Future):
- [ ] Implement visual effect shaders
- [ ] Screen distortion effects
- [ ] Geometry warping
- [ ] Reality tear effects
- [ ] Audio distortion
- [ ] Lighting adjustments

### ⏳ Phase 5 (Future):
- [ ] Unique weapons from facility
- [ ] Boss encounters
- [ ] Side quest integration
- [ ] Expanded areas
- [ ] Additional lore content

## 📊 Technical Specifications

**Performance:**
- Zone checks: 1 per second (low overhead)
- Passive corruption: Calculated per frame only when in zone
- Terminal/shard loading: On-demand
- Visual effects: Configurable intensity (0-1)

**Save Data:**
- Stabilizer node states (uses remaining)
- Terminal hack status
- Shard collection status
- Current depth (saved with corruption system)

**Coordinates (Placeholder):**
> **Note:** These are placeholder coordinates. In full implementation, would use actual game world coordinates for a repurposed interior location (e.g., abandoned Militech facility).

```
X axis: Depth progression (-100 to -300)
Y axis: Width variation (40-60)
Z axis: Elevation change (10 to -5)
```

## 🐛 Known Limitations (Phase 2)

1. **Visual Effects Not Implemented**
   - Structure in place, actual shaders/effects pending Phase 4
   - Currently logs only

2. **Stabilizer Nodes Not Interactive**
   - Class defined, interaction requires game entity spawning
   - Placeholder for full implementation

3. **Terminal Content Not Rendered**
   - Text written, rendering requires proper terminal UI integration
   - Content stored and ready for integration

4. **Coordinates Are Placeholders**
   - Would need actual game world coordinates
   - Current values for testing logic only

5. **No Physical Geometry**
   - Zone detection works, but no actual 3D environment
   - Would require WolvenKit asset creation

## 🎓 Learning Resources

For implementing Phase 3-5:

**AI/NPC Modification:**
- [RED4ext Documentation](https://docs.red4ext.com/)
- [Cyberpunk Modding Wiki - AI](https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/ai-and-npc)

**Visual Effects:**
- [Cyberpunk Shader Modding](https://wiki.redmodding.org/wolvenkit/modding-guides/shaders)
- [Post-Processing Effects](https://wiki.redmodding.org/cyberpunk-2077-modding/modding-guides/visual-effects)

**Entity Spawning:**
- [WolvenKit Entity Guide](https://wiki.redmodding.org/wolvenkit/wolvenkit-app/usage/import-export/entities)
- [Streaming Sectors](https://wiki.redmodding.org/cyberpunk-2077-modding/world-editing/streaming-sectors)

---

**Phase 2 Complete!** 🎉

The foundation for the Blackwall Breach Zone is now in place. Players can descend through 5 distinct depth levels, each with increasing corruption, environmental storytelling, and strategic stabilizer placement. Phase 3 will add AI possession mechanics to populate these zones with terrifying enemies.
