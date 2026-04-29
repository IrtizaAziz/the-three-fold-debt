# Level 2 — Complete Progression Reference
## The Burning Village
### The Three-Fold Debt

> **Purpose of this document:** A single reference that any team member can open to understand the complete picture of Level 2 — what happens, when it happens, who does what, and what the player should feel at every moment.
>
> **Target runtime:** 5–6 minutes at a moderate combat pace.
> **Theme:** Vengeance & Power. Aggression. The roar of spectral steel.
> **Core question posed to the player:** *"Will you be consumed by the hunt?"*

---

## 🌑 The Setup: Why Level 2 Exists

### Story Context
Ren and Hana have escaped the Whispering Bamboo Grove and arrived at their home village. It is not as they left it in life. The Kodoku Curse has frozen the village in the exact moment of its destruction, burning eternally with cold, blue spectral flames. The soldiers who slaughtered their family are here, corrupted into heavily armored shadows. 

When Ren finds the shattered armor of his eldest brother, Kaito's spirit awakens in full. Kaito fuses his energy with Ren's broken katana. The stealth of Level 1 is gone. Level 2 is about righteous anger and breaking through.

### What Level 2 Teaches
Level 2 is the combat trial. It shifts the player from prey to predator:

| Lesson | How the Player Learns It |
|--------|--------------------------|
| Kaito is power | Finding the armor permanently changes Ren's attack from a weak stab to a huge 3-hit combo |
| Phantom Strike is heavy | It pauses the game (hit-stop) and shatters Shadow Gates |
| Hana is still crucial | Phased enemies are untouchable *unless* you lure them into Hana's light |
| Deflection | Archers fire down; parrying their arrows sends them back to kill the archer |
| Boss patterns | The Captain loops 3 distinct attacks; the player must learn to punish the openings |

---

## 📊 Level 2 At a Glance

| Category | Detail |
|----------|--------|
| **Setting** | Burning village — jagged roofs, burning carts, falling ash. `CanvasModulate` remains `#1A0030`, but blue flames add ambient lighting. |
| **Player character** | Ren (`CharacterBody2D`) — now armed with Kaito's spectral blue extensions. |
| **Companion** | Hana (`Node2D`) — still provides light, but now actively solidifies Phased enemies. |
| **Enemies** | Phased Ashigaru, Crimson Archer, The Captain (Boss). |
| **Primary threat** | Combat damage. Gloom is still active, but arenas are smaller. |
| **Kaito status** | Fully Awake. Provides Spectral Edge, Upward Slash, Phantom Strike, and Parry. |
| **Progression blocker** | Shadow Gates. Must be broken by collecting souls or using Phantom Strike. |
| **Level exit** | The Captain's defeat yields the Soul-Key, unlocking the mountain path to Level 3. |

---

## 🗺️ Beat-by-Beat Progression

The level flows horizontally through village streets, with vertical combat on burning rooftops, culminating in a boss arena.

---

### 🔥 BEAT 0 — The Blue Inferno (Arrival)
**Platform layout:** Flat village outskirts. Broken fences and a single burning cart in the background.

**What happens:**
- Ren and Hana enter from the left.
- The environment is darker than Level 1, but punctuated by blue flame props.
- No enemies yet. The player has a moment to take in the destruction.
- Ren still only has his weak Level 1 attack here.

**Enemies:** None.

**Atmosphere:**
- 🔊 Roaring spectral fire. No rain.
- 💡 Blue PointLight2Ds scattered around the burning props.

**Dialogue:**
> **Ren:** *"Our home... It's frozen in the moment we died."*
> **Hana:** *"It burns, but there is no heat. Only hate."*

*Fires on level start.*

**Design intent:** Establish the aesthetic shift. Level 1 was quiet and natural; Level 2 is violent and supernatural.

---

### ⚔️ BEAT 1 — Kaito's Armor (The Awakening)
**Platform layout:** The village square. A large open area with an altar/statue in the center.

**What happens:**
1. A prop rests in the center: Kaito's shattered armor.
2. A `KaitoArmorTrigger` Area2D covers it.
3. When Ren enters:
   - A massive burst of blue light (PointLight2D tweens up).
   - Kaito's spirit fully emerges and wraps around Ren's sword.
   - **Gameplay unlock:** Ren's attacks are instantly upgraded. Pressing Attack now triggers the `Spectral Edge` 3-hit combo. `Phantom Strike`, `Upward Slash`, and `Parry` are unlocked.

**Enemies:** None, but a Shadow Gate blocks the exit on the right.

**Atmosphere:**
- 🔊 A sharp, ringing sword draw sound. The ambient fire sound intensifies.
- 💡 Huge ice-blue flash that settles into a persistent blue glow on Ren's sword.

**Dialogue:**
> **Kaito:** *"They took our home. They took your lives. They will pay the debt."*

*Fires on armor pickup.*

**Design intent:** The power fantasy moment. Give the player space to test their new 3-hit combo and heavy attack before throwing enemies at them.

---

### 🛡️ BEAT 2 — The Phased Vanguard
**Platform layout:** A wider street section. The Shadow Gate from Beat 1 was destroyed, leading here.

**Enemies:** `PhasedAshigaru_1` and `PhasedAshigaru_2`.
- These enemies flicker between SOLID and PHASED every 3 seconds.
- While PHASED, normal attacks pass through them.
- **The Catch:** If they walk into `HanaLightRadius`, they are forced SOLID instantly.

**Encounter flow:**
1. The enemies approach. They may be PHASED.
2. Player tries to hit them → attacks phase through.
3. Player realizes they must let the enemies enter Hana's light, or use Kaito's `Phantom Strike` (which pierces immunity).
4. Slaying them grants souls. A Shadow Gate at the end of the street absorbs the souls and dissolves.

**Atmosphere:**
- 🔊 Phased enemies have a distinct distorted static/whisper sound.

**Dialogue:**
> **Hana:** *"My light makes them real, Ren! Bring them to me!"*

*Fires when the first Phased enemy is encountered.*

**Design intent:** Teach the Hana synergy. Even though Kaito is powerful, Hana is still mechanically essential to control the battlefield.

---

### 🏹 BEAT 3 — Death from Above (The Crimson Archer)
**Platform layout:** A multi-tiered section. The street level is blocked by fire. Ren must jump up onto a slightly elevated roof structure.

**Enemies:** `CrimsonArcher_1`.
- Positioned on a high ledge, out of reach of normal horizontal attacks.
- Fires a `SpiritArrow` every 2 seconds straight down the path.

**Encounter flow:**
1. Arrows fly horizontally toward Ren.
2. Player can roll through, or press Block just before impact to `Parry`.
3. Parrying reverses the arrow, sending it back to instantly kill the Archer (deals 25 damage).
4. Alternatively, player can jump under the ledge and use `Upward Slash` to hit the Archer through the floor.

**Atmosphere:**
- 🔊 Bow string draw (warning cue), followed by a sharp whistling projectile.
- 💡 Arrows emit a faint red glow.

**Dialogue:**
> **Kaito:** *"Do not cower. Strike their arrows back!"*

*Fires when the first arrow is fired.*

**Design intent:** Force vertical thinking. Teach the `Parry` timing in a controlled environment with a single stationary threat before combining it with melee enemies.

---

### ⚔️ BEAT 4 — The Courtyard Skirmish
**Platform layout:** A large, complex courtyard with a raised central platform and a Shadow Gate blocking the far right exit.

**Enemies:**
- `CrimsonArcher_2` on the high platform.
- `PhasedAshigaru_3` and `PhasedAshigaru_4` on the ground.

**Encounter flow:**
1. The player is under fire from above while dealing with phasing enemies on the ground.
2. Player must use Hana's light to solidify the Ashigaru, while keeping an ear out for the Archer's bow string audio cue to Parry.
3. Once all enemies are dead, their souls flow into the Shadow Gate, breaking it.
4. Alternatively, the player can use `Phantom Strike` on the Gate directly to shatter it without killing everyone (creative problem solving).

**Atmosphere:**
- 🔊 Chaotic combat. Blue flashes from Kaito's strikes, red from the arrows.

**Dialogue:** None. Let the combat breathe.

**Design intent:** The final exam for standard enemies. Combines the Phased logic, the Parry logic, and the Shadow Gate logic into one chaotic fight.

---

### 👹 BEAT 5 — The Headman's Manor (Boss Arena)
**Platform layout:** A single, flat, wide screen. No camera scrolling. The burning manor forms the background. The arena is enclosed once Ren enters.

**Enemy:** `The Captain` (Level 2 Boss)
- A towering Yokai with a spiked iron club.
- HP: 300.

**Encounter flow:**
1. Ren enters. Invisible walls block the exit.
2. The Captain loops three attacks:
   - **SMASH:** Slow overhead slam. Player must roll away.
   - **SWEEP:** Ground sweep. Player must jump or Parry (parrying a sweep is a high-skill move).
   - **ROAR:** Ash falls from the sky. Player MUST stand inside Hana's light to avoid chip damage.
3. At 50% HP (150 HP), the Boss turns red and attacks 20% faster.
4. Ren must weave Spectral Edge combos between attacks, and use Phantom Strike during the Boss's recovery animations for heavy damage.

**Atmosphere:**
- 🔊 Heavy, bass-boosted thuds for the Boss's footsteps and Smash.
- 💡 The arena is lit by raging blue fires.

**Dialogue:**
> **Kaito:** *"He gave the order. He watched us die. Take his head, Ren!"*

*Fires as the Boss intro animation plays.*

**Design intent:** Test patience and pattern recognition. The player must use Hana defensively (during Roar) and Kaito offensively. The 0.08s hit-stop on Phantom Strike should feel incredibly satisfying here.

---

### 🗝️ BEAT 6 — The Soul-Key (Exit)
**Platform layout:** The right side of the Boss Arena opens up.

**What happens:**
1. The Captain dies, dissolving into ash.
2. He drops a glowing object: The Captain's Soul-Key.
3. Picking it up unlocks the massive gates leading up the mountain.
4. Ren walks through the gates to trigger the `LevelEnd`.

**Atmosphere:**
- 🔊 Combat sounds fade. Only the crackle of fire remains.

**Dialogue:**
> **Hana:** *"The path to the mountain is open. We're almost there..."*

*Fires when the Boss dies.*

---

## 🧮 Full Stats Reference

### Ren & Kaito (Level 2)
| Stat | Value | Notes |
|------|-------|-------|
| Spectral Edge Reach | 40, 60, 80px | Increases with each combo step |
| Phantom Strike Damage | 40 HP | Also yields 3 souls when hitting a Gate |
| Phantom Strike Hit-stop | 0.08s | `Engine.time_scale = 0` |
| Parry Window | 0.15s | Perfectly timed block |
| Upward Slash Reach | 60px (up) | Useful for hitting Archers on ledges |

### Phased Ashigaru
| Stat | Value | Notes |
|------|-------|-------|
| Max HP | 50 | |
| Attack Damage | 15 HP | |
| Phase Interval | 3.0s | Toggles SOLID ↔ PHASED |
| Hana Interaction | Immediate | Entering Hana's light forces SOLID state |

### Crimson Archer
| Stat | Value | Notes |
|------|-------|-------|
| Max HP | 25 | Dies instantly to a reversed arrow |
| Arrow Damage | 20 HP | |
| Fire Rate | 2.0s | |
| Detection Radius | 300px | |
| Arrow Speed | 300 px/s | |

### The Captain (Boss)
| Stat | Value | Notes |
|------|-------|-------|
| Max HP | 300 | |
| Attack Damage | 25 HP | Smash/Sweep |
| Roar Damage | 5 HP/sec | Prevented by standing in Hana's light |
| Phase 2 Trigger | 50% HP | |
| Phase 2 Speed Multiplier | 1.2x | Attacks execute 20% faster |

---

## 🎙️ All Dialogue — In Order

| # | Beat | Speaker | Text | Display Duration |
|---|------|---------|------|-----------------|
| 1 | Start | **Ren** | *"Our home... It's frozen in the moment we died."* | 4s |
| 1b| Start | **Hana** | *"It burns, but there is no heat. Only hate."* | 4s |
| 2 | Armor | **Kaito** | *"They took our home. They took your lives. They will pay the debt."* | 5s |
| 3 | Ashigaru | **Hana** | *"My light makes them real, Ren! Bring them to me!"* | 4s |
| 4 | Archer | **Kaito** | *"Do not cower. Strike their arrows back!"* | 4s |
| 5 | Boss Intro| **Kaito** | *"He gave the order. He watched us die. Take his head, Ren!"* | 5s |
| 6 | Boss Death| **Hana** | *"The path to the mountain is open. We're almost there..."* | 4s |

---

## 🔊 Audio Cue Map

| Moment | Sound | Notes |
|--------|-------|-------|
| Scene opens | Roaring fire | Looping ambient |
| Kaito awakens | Sharp sword draw / ring | Clear, high-pitched sting |
| Phantom Strike | Heavy bass impact + shatter | Needs to sound devastating |
| Parry success | Sharp metallic *PING* | Distinct from normal block |
| Archer attacks | Bow string tension | Warning cue 0.5s before arrow fires |
| Phased enemies | Static / ghostly whisper | Distorted when PHASED |
| Boss footsteps | Heavy thud | Shakes the screen slightly |

---

## ✅ Level 2 Complete Checklist (Team Sign-Off)

Run `Level_2.tscn` end-to-end.

| # | Check | Owner |
|---|-------|-------|
| 1 | Ren starts with basic attacks; picking up armor unlocks Spectral Edge | Architect |
| 2 | Kaito's 3-hit combo extends hitbox range on each swing | Architect |
| 3 | Phased Ashigaru ignore damage while transparent | Architect |
| 4 | Phased Ashigaru become solid instantly inside Hana's light | Architect |
| 5 | Crimson Archer arrows deal damage to Ren | Architect |
| 6 | Parrying an arrow reverses it and damages the Archer | Architect |
| 7 | Phantom Strike triggers 0.08s hit-stop | Architect |
| 8 | Shadow Gates dissolve when enough enemies die | Architect |
| 9 | Phantom Strike on a Shadow Gate grants 3 souls (breaks it faster) | Architect |
| 10 | The Captain cycles Smash → Sweep → Roar | Architect |
| 11 | Roar ash hazards only damage Ren if he is outside Hana's light | Architect |
| 12 | At 50% HP, The Captain attacks 20% faster | Architect |
| 13 | Defeating The Captain unlocks the LevelExit | Architect / World-Builder |
| 14 | All 7 dialogue lines fire at the correct moments | World-Builder |
| 15 | Kaito's visual effects (blue flashes) are distinct and impactful | Visual Artist / Atmosphere |
