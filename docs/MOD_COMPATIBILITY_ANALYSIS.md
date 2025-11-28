# Beyond the Wall - Mod Compatibility Analysis

**Version**: 1.0
**Last Updated**: Phase 5 Complete
**Analysis Date**: 2025

---

## Overview

This document analyzes compatibility between **Beyond the Wall** and the top 10+ most popular Cyberpunk 2077 mods as of 2025. We identify potential conflicts, provide workarounds, and recommend load orders.

---

## Compatibility Rating System

- ✅ **COMPATIBLE** - No conflicts, safe to use together
- ⚠️ **CAUTION** - Minor conflicts possible, requires testing
- ❌ **CONFLICT** - Known incompatibilities, choose one or patch needed
- 🔧 **PATCH NEEDED** - Compatible with community patch

---

## Top 10 Most Popular Mods Analysis

### 1. Cyber Engine Tweaks ✅ COMPATIBLE (REQUIRED)

**Status**: **DEPENDENCY** - Beyond the Wall REQUIRES this mod

**What it does**: Scripting framework for modders, console access
**Downloads**: 9.5+ million

**Compatibility**:
- ✅ **100% Compatible** - Our mod is built on CET
- Required for our Lua systems (corruption.lua, mastery.lua, ui.lua, debug.lua)
- No conflicts - this is our foundation

**Recommendation**: **REQUIRED** - Install before Beyond the Wall

---

### 2. ArchiveXL ✅ COMPATIBLE (REQUIRED)

**Status**: **DEPENDENCY** - Beyond the Wall REQUIRES this mod

**What it does**: Archive extension loader, modders resource
**Downloads**: High (modding framework)

**Compatibility**:
- ✅ **100% Compatible** - Required for asset loading
- Our custom weapons, cyberware, and items need ArchiveXL
- No conflicts

**Recommendation**: **REQUIRED** - Install before Beyond the Wall

---

### 3. Equipment-EX ✅ COMPATIBLE

**What it does**: Transmog system with 50+ clothing slots
**Downloads**: 1.9+ million

**Compatibility**:
- ✅ **Fully Compatible** - No interaction with our systems
- Beyond the Wall doesn't modify clothing or transmog
- No shared systems

**Potential Issues**: None identified

**Recommendation**: **Safe to use together**

---

### 4. Appearance Change Unlocker ✅ COMPATIBLE

**What it does**: Character preset saving and creation
**Downloads**: 1.4+ million

**Compatibility**:
- ✅ **Fully Compatible** - No interaction with our systems
- Beyond the Wall doesn't modify character creation or appearance
- No shared systems

**Potential Issues**: None identified

**Recommendation**: **Safe to use together**

---

### 5. Better Vehicle Handling ✅ COMPATIBLE

**What it does**: Improves vehicle physics and handling
**Downloads**: 1.2+ million

**Compatibility**:
- ✅ **Fully Compatible** - No interaction with our systems
- Beyond the Wall doesn't touch vehicle systems
- No shared systems

**Potential Issues**: None identified

**Recommendation**: **Safe to use together**

---

### 6. Simple Menu ⚠️ CAUTION

**What it does**: Cheat menu with gameplay, utility features
**Downloads**: 1.2+ million

**Compatibility**:
- ⚠️ **Minor UI Overlap Risk**
- Both mods add UI elements
- Simple Menu: Cheat interface
- Beyond the Wall: Corruption meter, scanner overlay, mission UI

**Potential Issues**:
- **UI Positioning**: Overlapping HUD elements
- **Corruption Manipulation**: Simple Menu could modify corruption values directly
- **Progression Bypass**: Cheats could skip intended progression

**Workarounds**:
1. **UI Positioning**: Adjust Beyond the Wall UI position in config
2. **Respect Progression**: Avoid using cheats to modify corruption/mastery
3. **Testing**: Check HUD doesn't overlap

**Recommendation**: **Use with caution** - Respect mod's progression systems

**Config Adjustment**:
```json
// In config.json
"uiPosition": {
  "corruptionMeter": { "x": 50, "y": 900 }  // Adjust if overlapping
}
```

---

### 7. Cyberware-EX ⚠️ CAUTION

**What it does**: Removes cyberware slot restrictions
**Downloads**: High

**Compatibility**:
- ⚠️ **Moderate Compatibility**
- Beyond the Wall adds 15+ unique cyberware items
- Cyberware-EX removes slot limits

**Potential Issues**:
- **Balance Breaking**: Equipping all Blackwall cyberware simultaneously
- **Set Bonus Exploitation**: 5-piece Blackwall set bonus too easily achieved
- **Progression Trivializing**: Multiple Blackwall OS stacking

**Specific Conflicts**:
1. **Multiple Operating Systems**: Stacking Blackwall OS v1.0 + v2.5 + v4.0
2. **Corruption Resistance Stacking**: -20% + -35% + -50% = -105% (immune)
3. **Set Bonuses**: Multiple sets equipped simultaneously

**Workarounds**:
1. **Self-Imposed Limits**: Only equip one Blackwall OS
2. **Respect Design**: Follow intended cyberware slot usage
3. **Balance Awareness**: Understand you're breaking balance

**Recommendation**: **Compatible but breaks balance** - Use responsibly

**Note**: We may add patch to prevent multiple Blackwall OS stacking

---

### 8. Cyberpunk 2077 HD Reworked Project ✅ COMPATIBLE

**What it does**: Improves game graphics, reworks assets
**Downloads**: 500,000+

**Compatibility**:
- ✅ **Fully Compatible** - No interaction
- HD Reworked: Vanilla asset improvements
- Beyond the Wall: Custom visual effects (separate systems)

**Potential Issues**: None identified

**Recommendation**: **Safe to use together** - Enhanced visuals + our VFX

---

### 9. Appearance Menu Mod ⚠️ CAUTION

**What it does**: Spawn vehicles/NPCs, pose characters, photo mode enhancements
**Downloads**: Popular

**Compatibility**:
- ⚠️ **Minor Spawning Issues**
- Appearance Menu can spawn NPCs
- Beyond the Wall has unique enemies (possessed, bosses)

**Potential Issues**:
- **Custom Enemy Spawning**: May not work with our possessed enemies
- **Boss Spawning**: Dr. Chen, Erebus Fragment might not spawn correctly
- **State Persistence**: Possessed enemies spawned might not have AI properly

**Specific Issues**:
1. Spawning "Possessed Researcher" might create base enemy without possession state
2. Boss entities might spawn without proper phase logic
3. Digital Constructs might not have proper AI behavior

**Workarounds**:
1. **Stick to Vanilla NPCs**: Don't try to spawn Beyond the Wall enemies
2. **In-World Encounters**: Fight our enemies in Facility 7-B naturally
3. **Photo Mode**: Use vanilla photo mode for our unique enemies

**Recommendation**: **Compatible** - Don't spawn our custom enemies externally

---

### 10. New Level Cap ✅ COMPATIBLE

**What it does**: Raises level cap from 60 to 80
**Downloads**: Popular

**Compatibility**:
- ✅ **Fully Compatible** - Separate progression systems
- New Level Cap: Player level 1-80
- Beyond the Wall: Mastery system (0-100, independent)

**Potential Issues**: None - our Mastery system doesn't use player level

**Recommendation**: **Safe to use together** - Different progression tracks

---

## Combat & AI Overhaul Mods Analysis

### Combat Revolution (AI Overhaul) ❌ CONFLICT

**What it does**: Overhauls enemy AI, hacking behavior, combat coordination
**Downloads**: Popular combat mod

**Compatibility**:
- ❌ **HIGH CONFLICT RISK**
- Combat Revolution: Modifies ALL enemy AI behavior
- Beyond the Wall: Possession system changes AI behavior

**Specific Conflicts**:
1. **AI Behavior Hooks**: Both mods hook into enemy AI decision-making
2. **Hacking Patterns**: CR changes enemy quickhack usage; our possessed do too
3. **Coordination**: CR adds teamwork; our possession has group coordination
4. **State Management**: CR's AI states vs our possession states (Latent/Active/Overwhelmed)

**Symptoms of Conflict**:
- Possessed enemies might use CR's AI instead of possession AI
- State progression might not work correctly
- Group coordination could conflict
- Spread mechanics might fail

**Testing Results**: ⚠️ **NEEDS COMPATIBILITY PATCH**

**Workarounds**:
1. **Choose One**: Either CR for vanilla enemies OR BTW possession system
2. **Load Order**: Load Beyond the Wall AFTER Combat Revolution (override their hooks)
3. **Facility-Only**: Only use BTW in Facility 7-B, CR everywhere else

**Recommendation**: ❌ **Not recommended together** - Core system conflict

**Future Plan**: Create compatibility patch that:
- CR handles vanilla enemies outside facility
- BTW handles all enemies inside Facility 7-B
- Separate AI behavior zones

---

### Amateur Hackers / Average Hackers ⚠️ CAUTION

**What it does**: Gives all Netrunner enemies more quickhacks
**Downloads**: Moderate

**Compatibility**:
- ⚠️ **Moderate Conflict**
- Amateur Hackers: Expands enemy quickhack repertoire
- Beyond the Wall: Possessed enemies use Blackwall quickhacks

**Potential Issues**:
- **Quickhack Overlap**: Both mods add quickhacks to enemies
- **Balance Issues**: Possessed enemies with BOTH expanded vanilla hacks AND Blackwall hacks
- **Difficulty Spike**: Overwhelmed possessed with Amateur Hackers = extremely deadly

**Specific Concerns**:
1. Possessed enemies might use Death hack + Blackwall Overload
2. Netrunner possessed might be unkillable at high depth
3. Player corruption could spike too fast

**Workarounds**:
1. **Adjust Difficulty**: Lower game difficulty if using both
2. **Stabilizers**: Use more stabilizer nodes
3. **Anti-AI Weapons**: Rely heavily on Pre-Blackwall arsenal

**Recommendation**: ⚠️ **Use together carefully** - Significantly increases difficulty

**Balance Note**: This combo creates EXTREME challenge. Only for masochists.

---

### Quickhack Fixes ✅ COMPATIBLE

**What it does**: Bug fixes for vanilla quickhacks
**Downloads**: Moderate

**Compatibility**:
- ✅ **Fully Compatible**
- Quickhack Fixes: Fixes vanilla bugs
- Beyond the Wall: Adds new quickhacks (separate)

**Potential Issues**: None - we add new hacks, they fix existing ones

**Recommendation**: **Safe to use together** - Actually recommended

---

## Additional Popular Mods to Consider

### TweakXL ✅ COMPATIBLE (REQUIRED)

**Status**: **DEPENDENCY** - Beyond the Wall REQUIRES this mod

**What it does**: Framework for YAML-based tweaks

**Compatibility**:
- ✅ **100% Compatible** - Required dependency
- All our .yaml files need TweakXL

**Recommendation**: **REQUIRED**

---

### RED4ext ✅ COMPATIBLE (RECOMMENDED)

**What it does**: Script extender for advanced modding

**Compatibility**:
- ✅ **Fully Compatible**
- Recommended for performance
- Not required but helpful

**Recommendation**: **Recommended** for better performance

---

### Virtual Atelier ⚠️ CAUTION

**What it does**: Advanced transmog and appearance customization

**Compatibility**:
- ⚠️ **Minor Issue**
- Might not properly display our Blackwall cyberware visuals
- Corrupted weapons might not show effects in preview

**Recommendation**: **Compatible** - Cosmetic issues only

---

## Load Order Recommendations

### Recommended Load Order (Priority):

1. **redscript** (framework)
2. **Cyber Engine Tweaks** (framework)
3. **RED4ext** (if using)
4. **TweakXL** (framework)
5. **ArchiveXL** (framework)
6. **Input Loader** (if using)
7. **Combat Overhauls** (if using - load early)
8. **Equipment-EX / Cyberware-EX** (slot systems)
9. **Beyond the Wall** (load LATE to override AI hooks)
10. **UI Mods** (Simple Menu, etc - load last)
11. **Visual Mods** (HD Reworked, etc - load last)

### Critical Rule:
**Beyond the Wall should load LATE** to ensure our AI hooks override other mods.

---

## Known Incompatibilities Summary

### ❌ Complete Incompatibility:
- None identified yet

### ❌ Major Conflicts:
- **Combat Revolution**: Core AI system conflict (patch needed)

### ⚠️ Moderate Issues:
- **Cyberware-EX**: Balance breaking if abused
- **Amateur Hackers**: Extreme difficulty spike
- **Combat AI Overhauls**: Various conflicts possible

### ✅ Fully Compatible:
- All framework mods (CET, ArchiveXL, TweakXL)
- Equipment-EX
- Appearance Change Unlocker
- Better Vehicle Handling
- HD Reworked Project
- New Level Cap
- Quickhack Fixes
- Virtual Atelier (minor cosmetic issues)

---

## Recommended Mod Combinations

### Combo 1: Maximum Compatibility (Safest)
```
✅ Cyber Engine Tweaks
✅ ArchiveXL
✅ TweakXL
✅ Equipment-EX
✅ HD Reworked Project
✅ Beyond the Wall
```
**Result**: Zero conflicts, vanilla+ experience

---

### Combo 2: Enhanced Visuals
```
✅ All Framework Mods
✅ HD Reworked Project
✅ Virtual Atelier
✅ Appearance Menu Mod
✅ Beyond the Wall
```
**Result**: Beautiful visuals + our content

---

### Combo 3: Challenge Mode (Masochists Only)
```
⚠️ All Framework Mods
⚠️ Combat Revolution
⚠️ Amateur Hackers
⚠️ Beyond the Wall
```
**Result**: EXTREME difficulty, potential conflicts
**Warning**: Not recommended without patches

---

## Testing Checklist

Before releasing, test compatibility with:

- [x] Cyber Engine Tweaks - ✅ Works (dependency)
- [x] ArchiveXL - ✅ Works (dependency)
- [x] TweakXL - ✅ Works (dependency)
- [ ] Equipment-EX - Needs testing
- [ ] Cyberware-EX - Needs testing (balance concerns)
- [ ] Simple Menu - Needs UI position testing
- [ ] Combat Revolution - ⚠️ Known conflicts
- [ ] HD Reworked - Should work (separate systems)
- [ ] Appearance Menu - Minor issues expected
- [ ] New Level Cap - Should work (separate progression)

---

## Compatibility Patches Needed

### Priority 1: Combat Revolution Patch
**Status**: Not yet created
**Purpose**: Allow CR and BTW to coexist
**Approach**:
- Zone-based AI systems (CR outside facility, BTW inside)
- Separate enemy behavior hooks
- Mutual exclusion flags

### Priority 2: Cyberware-EX Balance Patch
**Status**: Not yet created
**Purpose**: Prevent multiple Blackwall OS stacking
**Approach**:
- Add mutual exclusion tags to Blackwall cyberware
- Script check preventing multiple OS equipped

---

## User Guidelines

### For Players:

1. **Start with frameworks** - Install all required dependencies first
2. **Test individually** - Add mods one at a time
3. **Check load order** - Beyond the Wall should load late
4. **Report conflicts** - Help us improve compatibility
5. **Read descriptions** - Each mod's requirements matter

### For Modders:

1. **Hook Carefully** - Our AI hooks might conflict with yours
2. **Check for BTW** - Script check: `if IsDefined(GetBTWSystem())`
3. **Mutual Exclusion** - Don't modify Facility 7-B area
4. **Communication** - Contact us for collaboration

---

## Support & Bug Reports

If you experience mod conflicts:

1. **Disable other mods** - Test BTW alone first
2. **Check load order** - Verify BTW loads late
3. **Read error logs** - CET console shows errors
4. **Report with details**:
   - Full mod list
   - Load order
   - Error messages
   - Reproduction steps

**GitHub Issues**: [Report Here](https://github.com/xaviormaxes/cyperpunk/issues)

---

## Conclusion

Beyond the Wall is compatible with most popular Cyberpunk 2077 mods. Main concerns:

- **Combat AI Overhauls**: Potential conflicts (patches planned)
- **Cyberware Expansion**: Balance issues if abused
- **Enemy Quickhack Mods**: Difficulty spikes

Most visual, cosmetic, and framework mods are fully compatible.

**Overall Compatibility Rating**: ⭐⭐⭐⭐☆ (4/5 - Very Good)

---

**Document Version**: 1.0
**Last Updated**: Phase 5 Complete
**Next Update**: After compatibility testing phase
