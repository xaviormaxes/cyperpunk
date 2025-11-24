# Beyond the Wall - Development Guide

## Project Overview

This mod introduces a progressive Blackwall corruption system with new AI-possessed enemies and powerful Blackwall quickhacks for Cyberpunk 2077.

## Tech Stack

- **REDscript** - Game logic and systems (.reds files)
- **Cyber Engine Tweaks (CET)** - Lua scripting for UI, persistence, and debugging
- **TweakXL** - Game data modification (YAML files)
- **ArchiveXL** - Custom assets and resources
- **WolvenKit** - Asset creation and packaging (future use)

## Project Structure

```
cyperpunk/
├── README.md                    # User-facing documentation
├── DEVELOPMENT.md               # This file - developer documentation
├── LICENSE                      # MIT License
│
├── r6/                          # REDscript and TweakXL files
│   ├── scripts/BeyondTheWall/
│   │   ├── Core/
│   │   │   ├── CorruptionSystem.reds      # Corruption tracking system
│   │   │   ├── MasterySystem.reds         # Mastery progression system
│   │   │   └── BlackwallIntegration.reds  # Integration helpers
│   │   ├── Quickhacks/
│   │   │   └── BlackwallTrace.reds        # Sample quickhack effect
│   │   └── AI/
│   │       └── (Future: Possession system)
│   └── tweaks/
│       └── blackwall_quickhacks.yaml      # Quickhack definitions
│
├── bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/
│   ├── init.lua                 # Main CET entry point
│   ├── config.json              # Configuration file
│   └── modules/
│       ├── corruption.lua       # Corruption meter (Lua side)
│       ├── mastery.lua          # Mastery tracking (Lua side)
│       ├── ui.lua               # ImGui UI overlay
│       └── debug.lua            # Debug commands
│
└── archive/pc/mod/              # Future: Custom assets (icons, textures, etc.)
```

## Development Phases

### ✅ Phase 1: Core Systems (COMPLETED)
- [x] Corruption meter system
- [x] Mastery tracking and progression
- [x] Basic quickhack framework
- [x] CET UI overlay
- [x] Debug commands

### Phase 2: Location
- [ ] Create/repurpose interior for Breach Zone
- [ ] Implement depth-based zone triggers
- [ ] Add environmental storytelling (terminals, shards)
- [ ] Place Stabilizer Nodes

### Phase 3: Possession Mechanics
- [ ] Implement AI possession states (Latent, Active, Overwhelmed)
- [ ] Create possession jump/spread logic
- [ ] Add visual indicators for possessed enemies
- [ ] Implement possession UI elements

### Phase 4: Polish & Visual Effects
- [ ] Custom glitch shaders for corruption effects
- [ ] Reality warping visuals for deep zones
- [ ] Distorted AI voice lines
- [ ] HUD distortion effects
- [ ] Particle systems for Blackwall manifestation

### Phase 5: Expansion
- [ ] Additional quickhack variants
- [ ] Side missions within the facility
- [ ] Unique Blackwall-corrupted weapons
- [ ] Blackwall-modified cyberware
- [ ] Expanded Cynosure facility content

## Setting Up Development Environment

### Prerequisites
1. Cyberpunk 2077 (v2.0+)
2. [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511)
3. [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107)
4. [TweakXL](https://www.nexusmods.com/cyberpunk2077/mods/4197)
5. [ArchiveXL](https://www.nexusmods.com/cyberpunk2077/mods/4198)
6. [WolvenKit](https://github.com/WolvenKit/WolvenKit) (for asset creation)
7. VSCode with REDscript extension (recommended)

### Installation for Development

1. Clone the repository:
   ```bash
   git clone https://github.com/xaviormaxes/cyperpunk.git
   cd cyperpunk
   ```

2. Create symlinks to your Cyberpunk 2077 installation:
   ```bash
   # Windows (run as Administrator)
   mklink /J "C:\Program Files\Steam\steamapps\common\Cyberpunk 2077\r6\scripts\BeyondTheWall" "path\to\repo\r6\scripts\BeyondTheWall"
   mklink /J "C:\Program Files\Steam\steamapps\common\Cyberpunk 2077\r6\tweaks" "path\to\repo\r6\tweaks"
   mklink /J "C:\Program Files\Steam\steamapps\common\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\mods\BeyondTheWall" "path\to\repo\bin\x64\plugins\cyber_engine_tweaks\mods\BeyondTheWall"
   ```

3. Launch the game and enable the CET overlay (`~` key)

4. Check console for initialization messages:
   ```
   [BTW] Module loaded. Use 'btw.help()' in console for commands
   ```

## Key Systems Explained

### Corruption System

**Files:**
- `bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/modules/corruption.lua`
- `r6/scripts/BeyondTheWall/Core/CorruptionSystem.reds`

**How it works:**
- Corruption increases when using Blackwall quickhacks
- Decays slowly over time when not in deep zones
- Higher mastery reduces corruption gain
- Corruption tiers trigger different visual effects

**Key Functions:**
```lua
-- Lua side
corruption:Add(amount, mastery)      -- Add corruption with mastery reduction
corruption:GetTier()                 -- Get current tier (none/low/medium/high/critical)
corruption:SetInDeepZone(bool, depth) -- Set zone status
```

```swift
// REDscript side
corruptionSystem.AddCorruption(amount, mastery)
corruptionSystem.GetCorruptionTier()
corruptionSystem.ShouldApplyNegativeEffects(mastery)
```

### Mastery System

**Files:**
- `bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/modules/mastery.lua`
- `r6/scripts/BeyondTheWall/Core/MasterySystem.reds`

**How it works:**
- Gain XP by successfully using Blackwall quickhacks
- Level 1-10, with each level reducing RAM costs
- Auto-unlocks depth levels at specific mastery thresholds
- Provides corruption resistance

**Key Functions:**
```lua
-- Lua side
mastery:AddExperience(amount)           -- Add XP
mastery:RecordQuickhackUse(name, success) -- Track usage
mastery:IsDepthUnlocked(depth)          -- Check unlock status
```

```swift
// REDscript side
masterySystem.AddExperience(amount)
masterySystem.IsDepthUnlocked(depth)
masterySystem.GetCostReduction()  // RAM cost reduction
```

### Quickhack Integration

**Files:**
- `r6/scripts/BeyondTheWall/Core/BlackwallIntegration.reds`
- `r6/tweaks/blackwall_quickhacks.yaml`

**How to add a new quickhack:**

1. Add to `blackwall_quickhacks.yaml`:
   ```yaml
   Items.MyNewQuickhack:
     $base: Items.QuickHackBase
     displayName: My New Quickhack
     baseRAMCost: 15
     blackwallDepthRequired: 2
     corruptionCost: 10.0
   ```

2. Create effect in REDscript:
   ```swift
   public class MyNewQuickhackEffect extends GameplayLogicEffect {
     // Implementation
   }
   ```

3. Add to corruption cost lookup in `BlackwallIntegration.reds`:
   ```swift
   if Equals(quickhackName, n"MyNewQuickhack") {
     return 10.0;
   }
   ```

4. Update config.json with corruption cost and depth requirement

## Debug Commands

Enable debug mode in `config.json`:
```json
{
  "enableDebugMode": true,
  "enableDebugLogging": true
}
```

### Console Commands (via CET)

Open console with `~` key, then use:

```lua
-- Show help
btw.help()

-- Show current status
btw.status()

-- Set corruption level
btw.corruption(50)

-- Set mastery level
btw.mastery(75)

-- Add mastery XP
btw.addxp(10)

-- Unlock specific depth
btw.depth(3)

-- Unlock all depths
btw.unlock_all()

-- Show detailed statistics
btw.stats()

-- Simulate quickhack usage
btw.simulate("BlackwallTrace", true)  -- Success
btw.simulate("NeuralHijack", false)   -- Failure

-- Reset everything
btw.reset()

-- Toggle UI
btw.toggle()

-- Manual save/load
btw.save()
btw.load()
```

## Testing Workflow

1. **Local Testing:**
   ```bash
   # Make changes to Lua/REDscript files
   # Reload in-game with CET:
   # In CET console: exec("r", "BeyondTheWall")
   ```

2. **Test Corruption:**
   ```lua
   btw.corruption(90)  -- Set to critical
   -- Verify visual effects apply
   btw.corruption(0)   -- Reset
   ```

3. **Test Mastery:**
   ```lua
   btw.mastery(25)     -- Unlock depth 3
   btw.stats()         -- Verify unlock
   ```

4. **Test Quickhacks:**
   ```lua
   btw.simulate("BlackwallTrace", true)
   btw.stats()  -- Check XP gain
   ```

## Configuration

Edit `bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/config.json`:

```json
{
  "corruptionDecayRate": 0.5,        // Corruption lost per decay tick
  "corruptionDecayInterval": 5.0,    // Seconds between decay ticks
  "masteryMultiplier": 1.0,          // XP gain multiplier
  "enableDebugMode": false,          // Enable debug UI and commands
  "possessionSpreadChance": 0.3,     // 30% chance for possession spread
  "visualEffectsIntensity": 1.0      // Visual effect strength (0-1)
}
```

## Performance Considerations

- CET updates run at `updateInterval` (default 0.1s = 10 FPS)
- REDscript systems use `OnTick` for frame updates
- UI rendering is conditional based on visibility
- Save operations occur on overlay close and shutdown

## Common Issues

### "Systems not initialized" error
- Check CET console for initialization messages
- Verify REDscript compilation (check redscript.log)
- Ensure all dependencies are installed

### Quickhacks not appearing
- Check depth unlock requirements
- Verify TweakXL is loaded
- Check for TweakXL errors in log

### UI not showing
- Press `~` to open CET overlay
- Check config.json: `ui.showCorruptionMeter` etc.
- Use `btw.toggle()` to toggle visibility

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make your changes
4. Test thoroughly
5. Commit with clear messages
6. Push to your fork
7. Create a Pull Request

## Code Style

### REDscript
- Use PascalCase for class names: `BlackwallCorruptionSystem`
- Use camelCase for function names: `GetCorruptionLevel()`
- Use m_ prefix for member variables: `m_corruptionLevel`
- Add comments for complex logic

### Lua
- Use PascalCase for module names: `Corruption`
- Use camelCase for functions: `AddExperience()`
- Use `self` for instance methods
- Document public API functions

### YAML
- Use PascalCase for TweakDB IDs: `Items.BlackwallTrace`
- Indent with 2 spaces
- Comment complex configurations

## Resources

- [REDscript Documentation](https://wiki.redmodding.org/redscript/)
- [Cyber Engine Tweaks Wiki](https://wiki.redmodding.org/cyber-engine-tweaks/)
- [TweakXL Documentation](https://wiki.redmodding.org/tweakxl/)
- [CP2077 Modding Discord](https://discord.gg/redmodding)
- [WolvenKit Wiki](https://wiki.redmodding.org/wolvenkit/)

## Next Steps

After Phase 1, focus on:

1. **Zone Creation** - Repurpose an interior space for the Breach Zone
2. **Trigger System** - Detect when player enters different depth levels
3. **Possession AI** - Implement the three possession states
4. **Visual Effects** - Add glitch shaders and corruption visuals

See individual Phase sections in README.md for detailed task lists.

---

**Happy Modding!** 🔥

*Remember: The deeper you go, the more powerful you become - but at what cost?*
