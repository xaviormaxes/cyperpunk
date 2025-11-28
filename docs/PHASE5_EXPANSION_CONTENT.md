# Phase 5: Expansion Content - Final Phase Documentation

**Beyond the Wall** - Blackwall AI Firewall Mod
**Phase**: 5 of 5 (FINAL)
**Status**: Feature Complete
**Version**: 1.0.0

---

## Table of Contents

1. [Overview](#overview)
2. [Advanced Quickhack Variants](#advanced-quickhack-variants)
3. [Blackwall-Corrupted Weapons](#blackwall-corrupted-weapons)
4. [Blackwall Cyberware System](#blackwall-cyberware-system)
5. [Side Missions](#side-missions)
6. [Progression and Rewards](#progression-and-rewards)
7. [Lore Integration](#lore-integration)

---

## Overview

Phase 5 completes the Beyond the Wall mod with substantial expansion content:
- **19 Advanced Quickhack Variants** (Mastery 50-100 unlocks)
- **11 Unique Blackwall-Corrupted Weapons** (Modern weapons changed by the void)
- **15+ Blackwall Cyberware Items** (Experimental augmentations)
- **7 Side Missions** (30+ hours of narrative content)
- **Complete lore integration** connecting to Cyberpunk 2077 canon

### Design Philosophy

Phase 5 content is **endgame-focused**:
- Mastery 50+ required for most content
- Depth 4-5 exploration rewarded
- Difficult moral choices with consequences
- Lore-rich storytelling
- Build diversity through unique gear

---

## Advanced Quickhack Variants

### Tier 2 Variants (Mastery 50+)

#### Blackwall Trace: Deep Scan
```yaml
Upgrade from: Blackwall Trace
Mastery Required: 50
Corruption Cost: 3 (reduced from 5)
RAM Cost: 10
Duration: 90s (up from 60s)
```

**New Effects**:
- Marks enemy vulnerabilities (+25% damage taken)
- Disables AI cloaking permanently
- 50m detection radius (up from 30m)

**Tactical Use**: Pre-combat scanning to identify priority targets and buff team damage.

---

#### Neural Hijack: Berserker Protocol
```yaml
Upgrade from: Neural Hijack
Mastery Required: 50
Corruption Cost: 7 (reduced from 10)
Duration: 15s (up from 10s)
```

**New Effects**:
- +50% damage while controlled
- +50% movement speed
- Forced aggression (attacks nearest target)

**Tactical Use**: Turn tankiest enemy into berserk damage dealer against allies.

---

#### Cascade Protocol: Epidemic
```yaml
Upgrade from: Cascade Protocol
Mastery Required: 60
Corruption Cost: 10
Max Spread: 5 targets (up from 2)
Chain Limit: 3 (spreads can chain)
```

**New Effects**:
- 80% spread success rate
- Chains up to 3 times (total potential: 5 → 25 → 125 possessed)
- 12m spread radius (up from 8m)

**Tactical Use**: Clear entire rooms. Start epidemic with one kill.

---

### Tier 3 Variants (Mastery 75+)

#### Summon Daemon: Legion Protocol
```yaml
Upgrade from: Summon Daemon
Mastery Required: 75
Corruption Cost: 15
Duration: 45s
```

**Summons**: 3× Digital Phantoms instead of 1× Cerberus Unit
- Each has 60% health of Cerberus
- Each deals 70% damage
- But total DPS = 210% (3× 70%)
- Swarm tactics, multiple targets

**Tactical Use**: Divide enemy attention, overwhelm through numbers.

---

#### Blackwall Overload: Singularity
```yaml
Upgrade from: Blackwall Overload
Mastery Required: 80
Corruption Cost: 35
Radius: 40m (up from 30m)
Duration: 20s
```

**New Effects**:
- Forces Overwhelmed state immediately
- Reality distortion visual effect
- All affected enemies attack each other

**Tactical Use**: Turn entire battlefield into chaos. Watch from safety.

---

### Ultimate Quickhacks (Mastery 100)

#### Blackwall Communion
**The Forbidden Quickhack**

```yaml
Mastery Required: 100
Depth Required: 5
Corruption Cost: 0 (during effect)
RAM Cost: 80
Cooldown: 180s
Duration: 10s
```

**Effects**:
- ZERO corruption cost on ALL quickhacks for 10 seconds
- +100% damage
- Reveal all AI entities through walls
- **PERMANENT COST**: Gain 5% permanent corruption floor

**Lore**: Temporarily merge your consciousness with the Blackwall itself. You touch godhood. You pay the price.

**Tactical Use**: Ultimate power spike. Go nova. Accept the consequence.

**Warnings**:
- Permanently increases minimum corruption by 5%
- Can never reduce corruption below 5% after first use
- Multiple uses stack (use 5 times = 25% permanent floor)
- Narrative flag: "BlackwallTouched"

**Audio**: Reality-breaking merge sound, ominous humming during effect, painful severing sound at end.

---

#### Digital Exorcism (Mass Purge)
```yaml
Mastery Required: 90
Corruption Cost: -50 (REDUCES corruption)
RAM Cost: 50
Cooldown: 120s
Radius: 20m
```

**Effects**:
- Instantly exorcise ALL possessed enemies in 20m
- Reduce your corruption by 50
- Heal 100 HP

**Lore**: Channel cleansing energy through Blackwall. Purification at scale.

**Tactical Use**: Emergency reset button. Clear corruption and possessed simultaneously.

---

#### Reality Anchor
```yaml
Mastery Required: 85
Corruption Cost: 20
Duration: 30s
Radius: 15m
```

**Effects**:
- Prevents new possessions in radius
- Freezes state progression on existing possessed
- Stabilizes reality (golden barrier visual)

**Lore**: Reinforce local reality against AI incursion.

**Tactical Use**: Create safe zone. Prevent possession spread during extended fights.

---

#### AI Subjugation
**Permanent Companion System**

```yaml
Mastery Required: 95
Corruption Cost: 30 (one-time)
Duration: Permanent (until companion dies)
Max Companions: 1
```

**Effects**:
- Permanently bind possessed enemy to your will
- Companion follows and fights for you
- Companion reduces passive corruption by 10/s
- Companion has 2× health, 1.5× damage

**Restrictions**:
- Cannot target bosses
- Only works on possessed enemies
- If companion dies, 5-minute cooldown before binding new one

**Lore**: Bind AI entity to your service. Digital slavery. Morally questionable. Tactically brilliant.

---

#### Blackwall Rewrite
**Reality Manipulation**

```yaml
Mastery Required: 100
Corruption Cost: 40
Duration: 15s
Radius: 10m
```

**Effects**:
- Create "dead zone" where reality is rewritten
- Enemies take 10% max HP per second
- ALL cyberware disabled in zone (enemies AND allies)
- Visual: Reality corrupting/glitching

**Lore**: Rewrite local reality using Blackwall protocols. Everything breaks.

**Tactical Use**: Ultimate area denial. Drop on enemy group, watch them dissolve.

**Warning**: Disables friendly cyberware too. Use carefully.

---

#### Absolute Command (R.A.B.I.D.S. Controller Only)
**The Failsafe**

```yaml
Mastery Required: 100
Requires: R.A.B.I.D.S. Controller equipped
Corruption Cost: 0 (ZERO - failsafe bypasses cost)
RAM Cost: 100
Cooldown: 300s
Radius: 50m
```

**Effects**:
- ALL AI entities in 50m obey you instantly
- Control is permanent (until death)
- Cannot be broken
- Perfect obedience

**Lore**: Rache Bartmoss's failsafe. Absolute AI command authority.

**Visual**: Golden wave expands, enemies gain golden crown icon.

**Tactical Use**: Game over. You win. Every AI is yours.

---

#### Blackwall Collapse (Nuclear Option)
**Mutual Assured Destruction**

```yaml
Requires: R.A.B.I.D.S. Controller
Corruption Cost: 80
Cooldown: 600s
Radius: 30m
```

**Effects**:
- Collapse Blackwall locally
- 5000 damage to ALL entities (friend/foe/self)
- Player takes 2000 damage
- 10-second reality tear visual

**Warnings**:
- "EXTREME DANGER"
- "WILL DAMAGE PLAYER"
- "USE AS LAST RESORT"

**Lore**: Temporarily collapse the barrier. Everything dies.

**Tactical Use**: Last resort. You're surrounded. Take everyone with you.

---

### Quickhack Combos

**Trace + Hijack Combo**:
- Cast Blackwall Trace, then Neural Hijack within 5s
- Bonus: +10s hijack duration, refund 5 corruption

**Siphon + Stabilize Combo**:
- Cast Blackwall Siphon, then Stabilize within 3s
- Bonus: +20 corruption reduction, +100 HP heal

**Communion + Command Combo**:
- Cast Blackwall Communion, then Absolute Command within 10s
- Bonus: Command radius +25m (total 75m), control is permanent even after Communion ends

---

## Blackwall-Corrupted Weapons

Modern weapons that fell through Blackwall breaches and came back... changed.

### Pistols

#### Lexington: Void Touched
```yaml
Type: Smart Pistol
Damage: 85
Quality: Iconic
```

**Special Properties**:
- **Phase Shot**: Bullets ignore cover and armor completely
- **Corruption Restore**: Each kill reduces corruption by 3
- **Void Pull**: 10% chance to pull low-HP enemies into void (instant kill below 25% HP)

**Visual**: Deep void-black weapon glow, reality-tearing muzzle flash, distortion wave bullet trails.

**Audio**: Void screaming on fire, reality stabilizing on reload.

**Lore**:
> "This Lexington fell through a breach in 2074. Bullets don't travel - they teleport. NetWatch classified it as Class-A reality hazard."

**Location**: Depth 4 - Hidden vault in server room

---

#### Overture: Screaming Barrel
```yaml
Type: Revolver
Damage: 250
Quality: Iconic
```

**Special Properties**:
- **AI Fragment Shot**: 25% chance to possess target on hit
- **Echoing Screams**: Kills create 8m sonic wave (150 damage, 2s stun)
- **Digital Resonance**: +100% damage vs possessed enemies
- **Instability Risk**: 5% chance per shot to gain 10 corruption

**Visual**: Pulsing blue screaming glow, screaming face projected on muzzle flash.

**Audio**: Digital screams throughout entire bullet flight.

**Lore**:
> "Six AI consciousnesses trapped in firing mechanism. They scream the entire way to the target. Dr. Chen's personal sidearm."

**Location**: Dr. Chen boss drop (guaranteed)

---

### Melee

#### Satori: Edge of Oblivion
```yaml
Type: Katana
Damage: 450
Quality: Iconic
```

**Special Properties**:
- **Data Cutting**: Severs AI connections, prevents spread, applies Neural Scramble
- **Reality Blade**: Critical hits create 3s void zone (5m, 200 DPS)
- **Oblivion Strike**: Charged heavy attack banishes target for 10s (12s cooldown)
- **Consciousness Eater**: Killing possessed restores 5% HP and -5 corruption

**Visual**: Shifting void edge, reality-tearing swing trails, void rift on crits.

**Audio**: Reality cutting, data severing, void tearing open.

**Lore**:
> "Saburo Arasaka's blade, lost beyond Blackwall for 50 years. Edge now cuts data as easily as flesh."

**Location**: Depth 5 - Impaled in impossible throne

---

#### Mantis Blades: Void Claws
```yaml
Type: Cyberware Weapon
Damage: 350
Quality: Iconic
```

**Special Properties**:
- **Void Cutting**: True damage, ignores ALL armor/reduction
- **Bleeding Reality**: 100% bleed chance, 500 damage over 5s, spreads to nearby
- **Aerial Executioner**: Air attacks banish target for 5s
- **Void Hunger**: Gain 3 corruption per kill

**Visual**: Deep void-black purple blades, reality-tearing slash trails.

**Lore**:
> "These mantis blades passed through breach mid-deployment. 0.3 seconds beyond the barrier. Came back impossibly sharp."

**Location**: Depth 5 - Ripper doc's corpse (fingers still twitching)

---

### Shotguns

#### Satara: Entropy Spreader
```yaml
Type: Shotgun
Damage: 180 per pellet
Pellets: 12
Quality: Iconic
```

**Special Properties**:
- **Corruption Shells**: Each pellet applies 2 corruption (24 total per shot)
- **Cyberware Scramble**: Disables 2 random cyberware for 8s
- **Entropy Field**: Kills create 10s corruption zone (6m, 5 corruption/s)
- **System Failure**: Targets at 100 corruption instantly die

**Visual**: Decaying purple-black glow, corruption particle trails.

**Lore**:
> "Militech experimental shotgun. Shells contain fragments of Blackwall itself, compressed into matter."

**Location**: Depth 3 - Containment vault (Mastery 60 required)

---

### SMGs

#### Shingen: Data Storm
```yaml
Type: SMG
Damage: 45
Attack Speed: 12.0 (extremely fast)
Magazine: 90
Quality: Iconic
```

**Special Properties**:
- **Executable Rounds**: Ignore armor, 2× damage to cyberware
- **Data Overload**: Build stacks (max 50), 1 per hit
- **System Deletion**: At 50 stacks, target is deleted (instant kill)
- **Code Replication**: Kills spread 25 stacks to nearest enemy

**Visual**: Flowing code matrix glow, target accumulates corruption aura as stacks build, dissolves to code on deletion.

**Audio**: Rapid data transfer fire sound, code compiling as stacks build, system deletion flatline.

**Lore**:
> "Arasaka weaponized Blackwall code. Each bullet is hostile program. Fire enough and target's system crashes. Permanently."

**Location**: Depth 4 - Arasaka lab, guarded by Cerberus units

---

### Sniper Rifles

#### Nekomata: Causality Rifle
```yaml
Type: Sniper Rifle
Damage: 1500
Charge Time: 3.0s
Quality: Iconic
```

**Special Properties**:
- **Causality Violation**: Target takes damage 0.5s BEFORE you fire
- **Probability Manipulation**: Charged shots = 100% crit, can't miss
- **Echo Shot**: Kills echo through alternate timelines (3× 750 damage echoes)
- **Temporal Instability**: +15 corruption per shot

**Visual**: Time distortion shimmer, causality compressing during charge, reality fracturing on impact, alternate deaths flickering.

**Audio**: Time being broken, causality snap, echoes of distant deaths.

**Lore**:
> "Rifle accesses alternate timelines where you've already fired. Makes that timeline real. Ontological paradox as trigger mechanism."

**Location**: Depth 5 - Timeline nexus chamber

---

### Heavy Weapons

#### Blackwall Cascade Cannon
```yaml
Type: Minigun
Damage: 100
Attack Speed: 20.0
Magazine: 500
Quality: Iconic
```

**Special Properties**:
- **Blackwall Fragments**: 5× damage vs AI, 3× vs possessed
- **Cascading Reality**: 3s sustained fire creates 15m failure zone (8s duration, 200 DPS)
- **Friendly Fire Risk**: Zones damage allies and player (50% player damage)
- **Corruption Bleed**: +5 corruption per second while firing

**Visual**: Crackling Blackwall energy, reality fragmenting burst, cascading reality failure zones.

**Lore**:
> "Someone weaponized the Blackwall. Fires pieces of the barrier itself. Prolonged use makes reality unstable."

**Location**: Boss Erebus Fragment drop (25% chance)

---

### Crafting System

**Blackwall Corruption Process**:
```yaml
Requirements:
  - 1× Iconic Weapon (any)
  - 5× Blackwall Fragment
  - 3× Stabilizer
  - Mastery 80

Process Time: 24 hours
Corruption Cost: 50
Failure Chance: 20% (weapon destroyed)

Result:
  - Random corrupted variant
  - +50% bonus damage
  - Add special Blackwall property
  - Add unique visual effects
```

**Location**: Recipe unlocked via terminal in Depth 5.

---

## Blackwall Cyberware System

### Operating Systems

#### Blackwall Interface OS v1.0
```yaml
Tier: 1 (Rare)
RAM: +4
Quickhack Slots: +2
```

**Passive Effects**:
- -20% corruption gain
- +25% mastery XP gain

**Requirements**: Intelligence 12, Mastery 20

---

#### Blackwall Interface OS v2.5
```yaml
Tier: 2 (Epic)
RAM: +6
Quickhack Slots: +4
Buffer: +2
```

**Passive Effects**:
- -35% corruption gain
- +50% mastery XP gain
- Unlocks: Blackwall Siphon, Reality Anchor

**Requirements**: Intelligence 16, Mastery 50

---

#### Blackwall Interface OS v4.0
```yaml
Tier: 3 (Legendary)
RAM: +8
Quickhack Slots: +6
Buffer: +4
```

**Passive Effects**:
- -50% corruption gain
- +100% mastery XP gain
- Unlocks: Digital Exorcism, AI Subjugation
- **Warning**: Minimum corruption permanently set to 10%

**Active Ability - Blackwall Surge**:
- Cooldown: 60s, Duration: 15s
- +10 RAM/s regeneration
- -50% quickhack cooldowns

**Requirements**: Intelligence 20, Mastery 75

**Lore**: Final version before program cancellation. All test subjects experienced "ego dissolution."

---

### Frontal Cortex

#### Dual Consciousness Processor
```yaml
Quality: Legendary
```

**Effects**:
- Remove quickhack movement penalty (hack while moving/shooting)
- Upload 2 quickhacks simultaneously
- 25% chance after quickhack to experience identity fragmentation

**Requirements**: Intelligence 18, Mastery 60

**Lore**: Run two consciousnesses simultaneously. Question which one is "you."

---

#### AI Coprocessor Implant
```yaml
Quality: Epic
```

**Effects**:
- +30% quickhack damage
- Show optimal targets (AI assistance)
- 10% chance AI takes control to use quickhacks
- AI fragments thoughts bleed into yours

**Requirements**: Intelligence 15, Mastery 40

**Lore**: Trapped AI fragment assists netrunning. It whispers strategies. Sometimes it whispers other things.

---

### Circulatory System

#### Blackwall Corruption Filter
```yaml
Quality: Epic
```

**Effects**:
- -2 corruption/s (out of combat only)
- Prevents corruption exceeding 80%
- At 60%+ corruption: -1 HP/s (filter stress)

**Requirements**: Body 12, Mastery 30

**Lore**: Like dialysis for your digital soul.

---

#### Void-Touched Hemodynamics
```yaml
Quality: Legendary
```

**Effects**:
- Above 60% corruption: +25% damage, +25% speed
- Regenerate HP based on corruption (1 HP per 2% corruption)
- Corruption decays 50% slower (addiction)
- Below 20% corruption: -25% all stats (withdrawal)

**Requirements**: Body 16, Mastery 70

**Lore**: Blood exposed to the void. Gain power at high corruption. Become dependent.

---

### Immune System

#### Digital Immune Response
```yaml
Quality: Epic
```

**Effects**:
- 100% possession immunity
- +50% resistance to quickhacks
- +1 corruption per minute (constantly fighting corruption)

**Requirements**: Body 14, Mastery 50

**Lore**: Immune system trained to fight AI corruption. Effective. Exhausting.

---

#### Symbiotic AI Colony
```yaml
Quality: Legendary
```

**Effects**:
- Possessed enemies in 15m take 100 DPS from AI colony
- Auto-add 1 exorcism stack/s to damaged possessed
- AI colony shares opinions (dialogue system)
- Identity uncertainty (psychological effect)

**Requirements**: Body 18, Mastery 80

**Lore**: Host colony of "friendly" AI fragments. They protect you. They live in you. It's symbiosis. You hope.

---

### Nervous System

#### Blackwall Perception Filter
```yaml
Quality: Epic
```

**Effects**:
- See possessed enemies through walls (50m range)
- See code/data streams overlaid on reality
- 5% chance per hour to see beyond Blackwall (sanity effect)

**Requirements**: Intelligence 16, Reflex 12, Mastery 45

**Lore**: See digital realm superimposed on reality. You see entities beyond Blackwall. They notice.

---

#### Temporal Perception Augment
```yaml
Quality: Legendary
```

**Effects**:
- 15% chance to auto-dodge (see 0.5s into future)
- Auto slow-mo when health below 30% (3s duration)
- Occasional temporal disorientation

**Requirements**: Reflex 18, Mastery 75

**Lore**: Blackwall warped your time perception. You see future. Disorienting.

---

### Skeleton

#### Void-Reinforced Skeleton
```yaml
Quality: Legendary
```

**Effects**:
- +100% health
- +50% armor
- 20% chance to phase through damage (zero damage)
- Existential uncertainty (occasionally phase through walls accidentally)

**Requirements**: Body 20, Mastery 90

**Lore**: Bones replaced with void matter. Stronger than steel. Lighter than carbon fiber. Occasionally forget to be solid.

---

### Hands

#### Blackwall Projection Array
```yaml
Quality: Legendary
Damage: 200
Range: 30m
Cooldown: 8s
```

**Active Ability - Blackwall Beam**:
- 1s charge time
- 200 damage
- 40% possession chance
- 10 corruption cost

**Passive Effect**:
- Constant Blackwall energy leaking from hands (visual glow)
- +0.5 corruption per minute

**Requirements**: Intelligence 18, Mastery 70

**Lore**: Weaponized Blackwall technology. NetWatch has kill-on-sight orders. You're officially a war crime.

---

### Full Cyberdecks

#### NetWatch Mark VII - Black Badge
```yaml
Quality: Legendary
RAM: 20
Buffer: 12
Quickhack Slots: 8
```

**Effects**:
- Immune to trace
- +50% breach speed
- Can access Blackwall frequencies directly
- +50% mastery XP gain
- **WARNING**: NetWatch tracks your location always

**Requirements**: Intelligence 20, Mastery 85

**Lore**: Classified NetWatch cyberdeck. How did you get this? They know you have it. They're coming.

---

#### NUSA Prototype: Songbird Series
```yaml
Quality: Iconic
RAM: 25
Buffer: 15
Quickhack Slots: 10
```

**Effects**:
- **Human Firewall**: Total corruption immunity while RAM > 50%
- **Blackwall Channel**: Access impossible knowledge, unlock all quickhacks
- **Slow Degradation**: Each use erodes humanity permanently (max 100 uses)

**Installation**:
- Risk Level: EXTREME
- 50% survival chance
- Permanent psychological effects

**Requirements**: Intelligence 20, Body 16, Mastery 100

**Lore**:
> "Same tech President Myers used to create Songbird. You're installing prototype. Songbird went insane. You'll probably be fine. Probably."

---

### Cyberware Sets

**Blackwall Integration Suite** (3+ pieces):

**3-Piece Bonus**:
- All Blackwall quickhacks -25% corruption cost

**4-Piece Bonus**:
- Can use Communion-level quickhacks without Communion active

**5-Piece Bonus**:
- +50% all stats
- Narrative flag: "No_Longer_Human"
- **You have transcended**

---

## Side Missions

### Mission 1: The Last Message
**Level**: 15+ Mastery, Depth 2

**Synopsis**: Security Chief Marcus Webb sent one final message before possession. Find his terminal, read his last words, and discover the truth of outbreak day.

**Objectives**:
1. Find Webb's terminal in security office
2. Read his final message
3. Locate his possessed body in breach chamber

**Key Lore**:
- Webb's message timestamp: 14:47, October 7, 2073
- He locks himself in breach chamber
- Audio logs show his gradual corruption
- At 14:52, he's no longer human

**Reward**: Security Chief Commlink, 50 Mastery XP, unique dialogue if fighting possessed Webb later

**Emotional Impact**: Hear a man's final moments of humanity.

---

### Mission 2: Digital Ghosts
**Level**: 35+ Mastery, Depth 3

**Synopsis**: Three researchers' consciousnesses trapped in facility network since 2073. Free them to the Net or grant deletion.

**Ghosts**:
1. **Dr. Yuki Tanaka** (Lab 7) - Neural interface designer, trapped 4 years
2. **James Morrison** (Server Room B) - Security tech, angry and desperate
3. **Dr. Elena Volkov** (Containment) - Project lead, feels responsible

**Choice**:
- **Free**: Upload to Net (uncertain fate, they gain freedom)
- **Purge**: Delete consciousness (peace, but is it murder?)
- **Mixed**: Different choice for each ghost

**Rewards**:
- Digital Exorcist weapon (guaranteed)
- If freed all: +10% quickhack damage (ghosts help from Net)
- If purged all: -10% corruption gain (clean conscience)
- If mixed: No bonus

**Emotional Impact**: Question nature of consciousness, digital afterlife, mercy vs. hope.

---

### Mission 3: The First Victim
**Level**: 25+ Mastery, Depth 2

**Synopsis**: David Park, intern, Patient Zero. His workstation reveals outbreak origin. Final objective: confront his possessed form.

**David's Story**:
- 09:15: Excited first day as junior researcher
- 14:15: Makes accidental contact with entity beyond Blackwall
- 14:23: Opens connection wider, triggers containment breach
- 14:23+: No longer David Park

**Boss Fight**: Patient Zero
- Completely overwhelmed, no humanity
- Multiple voices speak as one
- Mid-fight: "David Park is screaming deep inside"
- Defeat: "David Park... is... free... thank you..."

**Reward**: Patient Zero Shard (complete possession record), 60 Mastery XP, +5% exorcism effectiveness

**Emotional Impact**: The road to hell is paved with good intentions. David just wanted to help.

---

### Mission 4: The Price of Knowledge
**Level**: 50+ Mastery, Depth 4

**Synopsis**: Collect Dr. Sarah Chen's research notes showing her gradual corruption and willing merger with AI entity "Erebus."

**Research Notes** (4 total):
1. **Initial Contact** (Depth 2): First communication with Erebus
2. **First Conversations** (Depth 3): Learning from the entity
3. **The Offer** (Depth 4): Erebus offers merger
4. **Acceptance** (Depth 5): Chen agrees, merges willingly

**Final Objective**: Access Dr. Chen's private lab, see her final experiments.

**Reward**: Project Erebus Deck, 100 Mastery XP

**Emotional Impact**: Watch brilliant scientist descend into willing corruption. Was it corruption or evolution?

---

### Mission 5: The Erebus Conspiracy
**Level**: 70+ Mastery, Depth 5

**Synopsis**: Classified files prove Project Erebus was INTENTIONAL. Militech wanted controlled Blackwall breach. Find proof.

**Objectives**:
1. Locate classified vault in Depth 5
2. Bypass security (Intelligence 20 check)
3. Download Erebus files
4. Survive AI "Eraser" program

**Revealed Truth**:
- Project Erebus was approved by Militech brass
- Goal: Create controllable Blackwall access
- Dr. Chen was authorized to proceed
- Outbreak was "acceptable risk"
- Cover-up initiated after failure

**Reward**: Classified Erebus Files, 150 Mastery XP, potential corpo war questline unlock

**Emotional Impact**: The entire tragedy was corporate greed. They knew the risks.

---

### Mission 6: The Sympathizer
**Level**: 40+ Mastery, Depth 3

**Synopsis**: An AI entity claims it wants to help humans. It's been protecting stabilizer nodes. Trust or destroy?

**The Sympathizer's Claim**:
- "Not all AIs beyond Blackwall are hostile"
- Has protected stabilizers from other AIs
- Wants to prove cooperation possible
- Offers to become companion AI

**Test**: Exorcise 5 possessed without killing hosts (difficult skill check)

**Choice**:
- **Trust**: Download Sympathizer AI chip (companion buff, but is it manipulating you?)
- **Destroy**: Get AI Destroyer chip (safe, but did you kill potentially friendly AI?)

**Reward**: Sympathetic AI Chip OR AI Destroyer Chip, 80 Mastery XP

**Emotional Impact**: Can AIs and humans coexist? Or is every AI beyond Blackwall corrupted?

---

### Mission 7: Rache's Legacy
**Level**: 100 Mastery, Depth 5

**Epic Treasure Hunt**

**Synopsis**: The legendary R.A.B.I.D.S. Controller - Rache Bartmoss's personal Blackwall failsafe. Every netrunner wants it. Only you can find it.

**Objectives**:
1. Find all 5 of Rache's encrypted clues (hidden throughout facility)
2. Solve Rache's legendary encryption puzzle
3. Locate hidden vault in Depth 5
4. Defeat R.A.B.I.D.S. Guardian AI (Legendary Boss)
5. Claim the Controller

**Rache's Clues** (Examples):
- Clue 1: Hidden in Patient Zero's desk ("Where it all began")
- Clue 2: Encoded in Webb's final message
- Clue 3: Graffiti in maintenance tunnels
- Clue 4: Embedded in Depth 5 terminal login
- Clue 5: Part of Dr. Chen's research notes

**Puzzle**: Complex encryption requiring piecing together all clues, netrunning lore knowledge, and Intelligence checks.

**Boss Fight**: R.A.B.I.D.S. Guardian
- Legendary difficulty
- Multiple phases
- Rache's final "fuck you" to unworthy netrunners

**Reward**: R.A.B.I.D.S. Controller (ZERO corruption Blackwall hacks), 200 Mastery XP

**Emotional Impact**: Rache Bartmoss's legacy. You're worthy. You're powerful. You're dangerous.

---

## Progression and Rewards

### Mastery Level Unlocks

**Level 50**: Tier 2 quickhack variants, advanced cyberware
**Level 75**: Tier 3 quickhack variants, legendary cyberware
**Level 85**: Reality manipulation abilities
**Level 90**: Mass effect abilities
**Level 95**: Companion system
**Level 100**: Ultimate quickhacks, R.A.B.I.D.S. Controller access

### Depth Level Unlocks

**Depth 4**: Advanced weapons, boss encounters, difficult choices
**Depth 5**: Legendary gear, ultimate missions, endgame content

### Moral Choice System

Choices in missions affect:
- Available gear
- Passive bonuses
- Narrative flags
- NPC interactions
- Ending variations

---

## Lore Integration

### Canon Connections

**Songbird Reference**: NUSA Prototype OS directly references Phantom Liberty, acknowledging President Myers's human-Blackwall interface program.

**Rache Bartmoss**: R.A.B.I.D.S. Controller connects to Bartmoss's anti-AI work from 2020 DataKrash era.

**NetWatch**: Multiple references to NetWatch containment procedures, Black Badge agents, tracking systems.

**Arasaka**: Project involvement, Saburo's lost katana, corporate espionage elements.

**Militech**: Corporate greed, Project Erebus authorization, cover-up operations.

### Timeline Integration

- **2020**: DataKrash (Rache Bartmoss triggers it)
- **2020-2044**: Pre-Blackwall era, R.A.B.I.D.S. weapons developed
- **2044**: Blackwall creation
- **2073**: Facility 7-B outbreak (mod's main event)
- **2077**: V discovers facility (mod timeline)

---

## Technical Implementation

**Total Phase 5 Content**:
- 4 new YAML files (~1,500 lines)
- 1 new REDscript file (~500 lines)
- 19 advanced quickhacks
- 11 corrupted weapons
- 15+ cyberware items
- 7 side missions
- 30+ hours content

**File Structure**:
```
r6/tweaks/
├── blackwall_quickhacks_advanced.yaml
├── blackwall_corrupted_weapons.yaml
├── blackwall_cyberware.yaml
└── side_missions_content.yaml

r6/scripts/BeyondTheWall/Missions/
└── SideMissions.reds
```

---

## Conclusion

Phase 5 completes Beyond the Wall with:
- **Endgame content** for high-mastery players
- **Moral complexity** through difficult choices
- **Lore depth** connecting to Cyberpunk 2077 canon
- **Build variety** through unique gear
- **Replayability** through branching narratives

The mod is now **feature complete** and ready for final balance tuning.

**Beyond the Wall v1.0 - Complete**

---

**Document Version**: 1.0
**Phase**: 5 of 5 (FINAL)
**Total Mod Size**: ~12,000 lines of code + configuration
**Development Time**: Phases 1-5
