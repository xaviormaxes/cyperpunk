# Beyond the Wall - Blackwall AI Firewall Mod

A comprehensive Cyberpunk 2077 mod that introduces a progressive Blackwall corruption system, new AI-possessed enemies, and powerful Blackwall quickhacks with risk/reward mechanics.

## 🔥 Core Concept

Explore a forgotten Militech research facility where experiments with controlled Blackwall access went catastrophically wrong. The Blackwall has developed a "thin spot" here, and rogue AI entities are bleeding through into our reality.

## ⚡ Key Features

### Depth Progression System
Progress through 5 distinct depth levels, each unlocking new abilities and increasing corruption:

**Depth 1: Surface Contact**
- Location: Outer facility, minimal corruption
- Unlock: `Blackwall Trace` - Mark enemies through walls by detecting AI signatures
- Risk: 5% chance of feedback damage when hacking

**Depth 2: Protocol Breach**
- Location: Server rooms, moderate glitching
- Unlock: `Neural Hijack` - Take control of enemy for 10 seconds
- Risk: Screen distortion effects, 10% feedback chance

**Depth 3: Deep Dive**
- Location: Experimental labs, heavy corruption
- Unlock: `Cascade Protocol` - Possessed enemy spreads to 2 others
- Risk: Periodic vision blackouts, 15% feedback, cyberware glitches

**Depth 4: Old Net Interface**
- Location: Blackwall containment core
- Unlock: `Summon Daemon` - Temporarily summon AI entity to fight for you
- Risk: Health drain over time, 20% feedback, random cyberware malfunctions

**Depth 5: Beyond the Veil**
- Location: Actual breach point into Old Net
- Unlock: `Blackwall Mastery` - All previous hacks cost 50% less RAM, no spread limit
- Risk: Constant corruption effects, but you've learned to control them

### Rogue AI Possession System

Enemies can be possessed by entities from beyond the Blackwall in three states:

- **Latent**: Slightly off behavior, enhanced reflexes, glowing eyes
- **Active**: Full AI control, enhanced abilities, can spread to nearby enemies
- **Overwhelmed**: Cyberpsycho-like state, attacks everything, extremely dangerous

When you kill possessed enemies, the AI entity can jump to another nearby target, creating dynamic tactical combat.

### Corruption/Mastery Balance

**Corruption Meter (0-100%)**
- Increases as you use Blackwall hacks or stay in deep zones
- At high corruption: More powerful hacks, but reality distortion effects
- Decreases slowly over time when not using abilities
- Find "Stabilizer Nodes" in the facility to rapidly decrease corruption

**Mastery System**
- Each successful Blackwall hack builds mastery XP
- Higher mastery = better control at high corruption levels
- Eventually operate at 80-90% corruption without negative effects
- Represents V learning to "speak the language" of rogue AIs

## 🎮 New Blackwall Quickhacks

| Quickhack | RAM | Depth Required | Effect |
|-----------|-----|----------------|--------|
| **Blackwall Trace** | 8 | 1 | Reveals AI-corrupted entities through walls for 60s |
| **Neural Hijack** | 15 | 2 | Take control of target for 10s, they attack allies |
| **Cascade Protocol** | 20 | 3 | Possession spreads to 2 nearby enemies when target dies |
| **Summon Daemon** | 30 | 4 | Spawn hostile AI entity (Cerberus-style bot) for 30s |
| **Blackwall Overload** | 50 | 5 | All enemies in 30m become possessed, attack each other |
| **Stabilize** | 10 | - | Reduces corruption by 25%, removes negative effects (60s cooldown) |

## ⚔️ Pre-Blackwall Weapons

Discover arsenal from the DataKrash era (2020-2044) - weapons built when rogue AIs were the primary threat:

| Weapon | Type | Special Property | Location |
|--------|------|------------------|----------|
| **R.A.B.I.D.S. Remnant** | Smart Pistol | +300% vs AI, prevents possession spread | Depth 2 Armory |
| **NetWatch Neural Disruptor** | Tech Rifle | EMP blast, breaks possession | Depth 3 Lab |
| **Oni no Kiru** | Katana | +400% vs digital constructs, banishes AI | Depth 4 Boss |
| **Militech EMP-7B** | Grenade | Mass possession break, 8m radius | Depth 2 Armory |
| **Digital Exorcist** | Smart SMG | Exorcism stacks purge AI | Depth 3 Office |
| **Project Erebus Deck** | Cyberdeck | -50% Blackwall hack cost, +6 slots | Dr. Chen Boss |
| **R.A.B.I.D.S. Controller** ⭐ | Cyberdeck | **ZERO corruption cost**, AI command | Depth 5 Vault |

⭐ *Ultra Rare - Rache Bartmoss's personal failsafe. Requires 100 Mastery to unlock.*

## 👾 Old Net Enemies

Face the aftermath of the 2073 Facility 7-B outbreak:

### Possessed Personnel (The 63)
- **Researchers** (Latent) - Low threat, coordinated groups
- **Technicians** (Active) - Moderate threat, can spread possession
- **Security Guards** (Active) - High threat, heavily armed
- **The Overwhelmed** - Extreme threat, attacks everything, guaranteed spread

### Digital Constructs
- **Digital Phantoms** - Weak AI manifestations, 4x damage from anti-AI weapons
- **Digital Revenants** - Strong manifestations, summon reinforcements

### AI-Controlled Machines
- **Cerberus Units** - Maintenance robots, disable cyberware, vulnerable to EMP

### Boss Encounters
- **Dr. Sarah Chen** (Possessed) - 3-phase fight, Erebus entity
- **EREBUS Fragment** - Ultimate boss, 4 phases, requires R.A.B.I.D.S. Controller

*Anti-AI weapons deal 3-4x damage to these enemies. Conventional weapons are 25-70% effective.*

## 📦 Installation

### Requirements
- Cyberpunk 2077 (v2.0+)
- [redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511)
- [Cyber Engine Tweaks](https://www.nexusmods.com/cyberpunk2077/mods/107)
- [TweakXL](https://www.nexusmods.com/cyberpunk2077/mods/4197)
- [ArchiveXL](https://www.nexusmods.com/cyberpunk2077/mods/4198)

### Installation Steps
1. Download the mod from [Nexus Mods](#) (TBD)
2. Extract the archive to your Cyberpunk 2077 installation directory
3. The folder structure should look like:
   ```
   Cyberpunk 2077/
   ├── r6/
   │   ├── scripts/BeyondTheWall/
   │   └── tweaks/
   ├── bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/
   └── archive/pc/mod/
   ```
4. Launch the game and enjoy!

## 🎯 Usage

### In-Game Access
- Open the CET overlay (default: `~` key)
- Navigate to the "Beyond the Wall" menu
- View your current corruption level, mastery progress, and depth level
- Access debug options and configuration

### Controls
- New quickhacks appear in your Cyberdeck when you reach the appropriate depth level
- Use normal quickhack controls to deploy Blackwall abilities
- Monitor your corruption meter in the HUD

## 🛠️ Development Roadmap

### ✅ Phase 1: Core Systems (COMPLETED)
- [x] Corruption meter system (CET)
- [x] Mastery tracking
- [x] Basic Blackwall quickhack framework
- [x] Depth level progression

### ✅ Phase 2: Location (COMPLETED)
- [x] Depth progression system with 5 zones
- [x] Environmental storytelling (8 terminals, 5 data shards)
- [x] Depth-based zone triggers and transitions
- [x] Stabilizer Node system (8 nodes placed)
- [x] Passive corruption in deep zones
- [x] Area configuration and layout
- [x] Visual effects structure (Phase 4 prep)

### ✅ Phase 3: Possession Mechanics (COMPLETED)
- [x] Possession spread system (30-100% chance based on state)
- [x] Prevention systems (Neural Scramble, Exorcism, Break)
- [x] AI behavior modifications (Latent/Active/Overwhelmed)
- [x] State progression system (60s combat threshold)
- [x] Visual effects framework (eye glow, particles, auras)
- [x] Possession UI system (markers, progress bars, warnings)
- [x] Group coordination (synchronized movement)
- [x] Exorcism stack tracker (10 hits = purge AI)

### ⏳ Phase 4: Polish (NEXT)
- [ ] Visual effect rendering (shaders, particles)
- [ ] Sound effects and audio distortion
- [ ] Animation system for transitions
- [ ] Scanner integration
- [ ] Custom distorted AI voice lines
- [ ] Advanced visual effects (reality warping)
- [ ] Glitch shaders and particle systems
- [ ] Balance testing and tuning

### ⏳ Phase 5: Expansion
- [ ] Additional quickhack variants
- [ ] Side missions within facility
- [ ] Unique Blackwall-corrupted weapons
- [ ] Blackwall-modified cyberware

## 🧠 Lore Background

### What is the Blackwall?

The Blackwall isn't just a firewall - it's a powerful AI masquerading as ICE, created to keep rogue AIs from breaking through into the rest of cyberspace. It was created secretly in 2044 by NetWatch with help from Transcendentals (AIs that achieved Transcendental Sentience) and Ghosts (engrams) after Rache Bartmoss triggered the DataKrash in 2020.

### The Old Net

The Old Net behind the Blackwall is terrifying. Nobody really knows how advanced the rogue AIs are because they've been operating there without checks or controls for decades. These aren't typical AIs - they're more like gods or demons in the Cyberpunk universe. With all the cyberware everyone has, these AIs can completely control people through their implants.

### Phantom Liberty Connection

This mod draws heavy inspiration from Songbird's storyline in Phantom Liberty. She was forcibly augmented by President Myers to use as a link between the Blackwall and the real world, constantly traveling beyond it. The AIs she encountered corrupted her mind over time - this mod explores what would happen if V walked a similar path, but learned to control it.

## 📁 File Structure

```
BeyondTheWall/
├── README.md
├── r6/
│   ├── scripts/BeyondTheWall/
│   │   ├── Core/
│   │   │   ├── CorruptionSystem.reds
│   │   │   ├── MasterySystem.reds
│   │   │   └── DepthProgression.reds
│   │   ├── Quickhacks/
│   │   │   ├── BlackwallTrace.reds
│   │   │   ├── NeuralHijack.reds
│   │   │   ├── CascadeProtocol.reds
│   │   │   ├── SummonDaemon.reds
│   │   │   ├── BlackwallOverload.reds
│   │   │   └── Stabilize.reds
│   │   └── AI/
│   │       ├── PossessionSystem.reds
│   │       └── PossessionStates.reds
│   └── tweaks/
│       ├── blackwall_quickhacks.yaml
│       └── possession_modifiers.yaml
├── bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/
│   ├── init.lua
│   ├── modules/
│   │   ├── corruption.lua
│   │   ├── mastery.lua
│   │   ├── ui.lua
│   │   └── debug.lua
│   └── config.json
└── archive/pc/mod/
    └── (Asset files for visual effects, icons, etc.)
```

## ⚙️ Configuration

Edit `bin/x64/plugins/cyber_engine_tweaks/mods/BeyondTheWall/config.json`:

```json
{
  "corruptionDecayRate": 0.5,
  "masteryMultiplier": 1.0,
  "enableDebugMode": false,
  "possessionSpreadChance": 0.3,
  "visualEffectsIntensity": 1.0
}
```

## 🐛 Known Issues

- Visual effects may impact performance on lower-end systems
- Possession spread can occasionally target already-possessed enemies
- Some quickhacks may conflict with vanilla netrunner perks

## 🤝 Contributing

This is an open-source project. Contributions, bug reports, and feedback are welcome!

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📜 License

MIT License - See LICENSE file for details

## 🙏 Credits

- **Lore References**: CD Projekt Red, Cyberpunk 2077, Phantom Liberty DLC
- **Inspiration**: "Somewhat Damaged" mission, Songbird's storyline
- **Tools**: redscript, Cyber Engine Tweaks, TweakXL, ArchiveXL, WolvenKit

## 📞 Support

- Report issues on [GitHub Issues](https://github.com/xaviormaxes/cyperpunk/issues)
- Discussion on [Nexus Mods](#) (TBD)

---

*"The deeper you go, the more you understand. The more you understand, the less human you become."*
