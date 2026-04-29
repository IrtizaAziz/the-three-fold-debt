# Level 1 — Complete Progression Reference
## The Whispering Bamboo Grove
### The Three-Fold Debt

> **Purpose of this document:** A single reference that any team member can open to understand the complete picture of Level 1 — what happens, when it happens, who does what, and what the player should feel at every moment.
>
> **Target runtime:** 3–4 minutes at a comfortable walking pace.
> **Theme:** Survival & Discovery. Fragility. The silence that comes after death.
> **Core question posed to the player:** *"Will you stay with her, or leave her behind?"*

---

## 🌑 The Setup: Why Level 1 Exists

### Story Context
The Inoue siblings — **Kaito** (eldest), **Ren** (middle), and **Hana** (youngest) — were executed by their Lord, **Daimyo Sorin Ashikaga**, using the Kodoku Curse. Their bodies were buried in the bamboo grove outside their home village. The curse intended to fuse their three souls into a mindless Gashadokuro — a giant cursed skeleton — before the Ebon Moon rises.

Their bond resisted the merge. But the pull is relentless. **They have until the Ebon Moon rises to reach the Celestial Forge at the peak of Mount Urashima**, where its flame can sever the spiritual chains. Level 1 is the moment Ren wakes up in the mud of his own grave, completely alone, in the dark.

### What Level 1 Teaches
Level 1 is the tutorial, but it never announces itself as one. Every lesson is delivered through environment and consequence:

| Lesson | How the Player Learns It |
|--------|--------------------------|
| Stay near Hana | Gloom Meter fills the second Ren leaves her light — no text, just a purple bar climbing |
| Hana's light is precious | A Gloom Wisp shrinks her radius — the gold circle visibly gets smaller |
| Roll through danger | Enemy hitboxes miss Ren during the 0.4s roll — no tutorial prompt |
| Kaito is watching | Kaito auto-parries one hit at low HP — the player wonders what just happened |
| Run when told to | Gloom rises from the ground in the climax — the only correct answer is "go faster" |

---

## 📊 Level 1 At a Glance

| Category | Detail |
|----------|--------|
| **Setting** | Bamboo grove, spirit world version — bamboo is translucent white, sky is deep purple-black |
| **Time of day** | Eternal twilight — no sun, no moon yet |
| **Player character** | Ren (`CharacterBody2D`) — dark silhouette, broken katana |
| **Companion** | Hana (`Node2D`, top_level=true) — golden lantern spirit, trails Ren with lag |
| **Enemies** | Hollowed Ash (×2), Bamboo Lurker (×1), Gloom Wisp (×2) |
| **Primary threat** | Gloom Meter (fills at 10/s outside Hana's radius; max 100) |
| **Secondary threat** | Enemy damage (Ren has 100 HP; enemies hit for 10–20 per strike) |
| **Kaito status** | Slumbering. Only his Vengeful Echo passive is active |
| **No music** | Ambient sound only — silence is the atmosphere |
| **Level exit** | A gate Area2D at the top-right of the level loads `Level_2.tscn` |

---

## 🗺️ Beat-by-Beat Progression

The level flows **left-to-right then upward** — climbing out of a grave, literally.

---

### 🟫 BEAT 0 — The Grave (Start)
**Platform layout:** Flat ground, ~10 tiles wide. Enclosed by walls on both sides. No exits visible.

**What happens:**
- The screen is completely black. `CanvasModulate` set to `#1A0030`.
- Ren spawns face-down in the mud. He stands automatically as the scene loads.
- No Hana yet. No light. Just the sound of rain and bamboo rustling.
- The player can move left and right — but there is nowhere to go. Both walls block.

**Enemies:** None.

**Atmosphere:**
- 🔊 Rain ambience. Soft bamboo creak. No music.
- 💡 No light sources. Total darkness except a faint outline of the ground from the `CanvasModulate` color.

**Dialogue:**
> *[No speaker — environmental text appears in the DialogueBox]*
> **"The mud is cold. The bamboo is silent. Something is wrong with the sky."**

*Fires automatically 1 second after scene loads. Hides after 4 seconds.*

**Design intent:** Disorient. Establish that darkness is the default state. Make the player feel the weight of the absence.

---

### 🟡 BEAT 1 — Hana's Discovery (The Light Returns)
**Platform layout:** A large bamboo tree root structure to the right of the starting area. Ren must walk right through a gap in the wall (1 tile wide opening).

**What happens:**
1. Ren moves right. The gap in the wall opens into a slightly wider clearing.
2. At the base of the bamboo tree roots, a faint gold shimmer is visible — the only color on screen.
3. A `HanaSpawnTrigger` Area2D covers the shimmer. When Ren walks into it:
   - **Hana emerges.** Her `PointLight2D` (gold, energy 1.2) activates — the world lights up in a warm circle.
   - The bamboo around Hana instantly becomes visible: translucent white, ghostly and beautiful.
   - The Gloom Meter on the HUD appears for the first time (it was hidden before Hana existed).
4. Hana begins following Ren via `lerp()` with a visible lag.

**Enemies:** None.

**Atmosphere:**
- 🔊 Hana's lantern hum begins (looping, very low volume). Grove ambience starts.
- 💡 Hana's gold light fills the screen. `PointLight2D` energy 1.2, texture scale 2.0.

**Dialogue:**
> **Hana:** *"Ren... I found you. Don't let go of the lantern. Please."*

*Fires when HanaSpawnTrigger is entered. Hides after 4 seconds.*

**Design intent:** Relief. The warm gold light should feel like safety after the total darkness. The player should immediately understand: Hana = light = alive.

---

### 🪜 BEAT 2 — The First Climb (Platforming Introduces Hana Dependency)
**Platform layout:** 3 ascending ledges to the right, each one slightly higher than the last.
- Ledge 1: Reachable with a single jump from ground level.
- Ledge 2: Requires a jump from Ledge 1. The gap is *just* wider than comfortable — the player feels the distance.
- Ledge 3: Another gap. At the top, the path continues rightward.

**Gap design rule:** Each gap is 10–12% wider than Ren's comfortable jump range. The player will barely make it, which forces them to notice that Hana's lag means she arrives at the top *after* Ren does. The Gloom Meter may briefly tick upward if Ren is fast — teaching the player that rushing ahead costs them.

**Enemies:** None.

**Atmosphere:**
- 🔊 The bamboo creak becomes slightly louder here — wind picks up.
- 💡 Hana's light makes each ledge visible as she catches up. Ren is briefly in near-darkness mid-jump.

**Dialogue:** None. Let the player focus on the platforming.

**Design intent:** Establish Hana's follow-lag as a mechanic, not a bug. The player should learn to wait for her, or learn the cost of not waiting.

---

### 👻 BEAT 3 — First Enemy (The Hollowed Ash)
**Platform layout:** Wide, flat open section — ~20 tiles wide. Slight height variation but walkable. This is intentional: give the player room to dodge and roll.

**Enemy:** `HollowedAsh_1`
- Patrol zone: 15 tiles wide across the center of Beat 3.
- Starts facing left. Patrol speed: 50px/s.
- Detection radius: 200px (will trigger chase when Ren enters this circle).
- Chase speed: 90px/s. Attack damage: 20 HP per hit. HP: 30.

**Combat math:**
- Ren's Broken Edge (attack Z key) deals 15 damage per hit → takes **2 hits** to kill the Ash.
- The Ash deals 20 per hit → **5 hits** kills Ren if he doesn't roll.
- Roll (Shift) grants 0.4s iframes — the Ash's attack window is 0.3s → a well-timed roll avoids all damage.

**Encounter flow:**
1. The Ash appears mid-patrol. Player can watch it for a moment before engaging.
2. If Ren approaches within 200px → Ash switches to CHASE. Moves toward Ren at 90px/s.
3. Within 40px → Ash ATTACKS. Attack animation plays; hitbox active between 0.5s–0.2s remaining.
4. Player rolls through or kills the Ash in 2 hits.
5. On death → `soul_released` signal fires (no effect in Level 1 — no ShadowGate here).

**Atmosphere:**
- 🔊 Ash attack: sword whoosh SFX plays.
- 🔊 Ash death: soul dissipation SFX plays.
- 💡 Hana's gold light should fully illuminate this area. The Ash should be clearly visible.

**Dialogue:**
> **Ren** *(inner monologue):* *"They're still here. The soldiers who killed us. Their grudge won't let them rest."*

*Fires when Ren enters Beat 3 area, before the Ash detects him. Hides after 4 seconds.*

**Design intent:** Safe first combat. Enough space to roll. The Ash is slow and predictable. The real threat is if the player panics and runs *away from Hana* — the Gloom Meter then becomes the actual danger.

---

### 🎋 BEAT 4 — The Narrow Corridor (Bamboo Lurker)
**Platform layout:** A tight corridor, 3–4 tiles wide and 12 tiles long. Bamboo walls on both sides. The ceiling is low. The player cannot jump high here.

**Enemy:** `BambooLurker_1`
- Positioned mid-corridor, flush against the right wall.
- Looks exactly like regular bamboo. No visual indicator it's an enemy.
- Trigger radius: 100px. When Ren enters range → attack fires once (total duration: 0.8s).
- Hitbox is active 0.3s–0.1s before animation ends → approximately 0.5s into the animation.
- Attack damage: 15 HP.

**Encounter flow:**
1. Player enters the narrow corridor. Bamboo flanks both sides — the Lurker is indistinguishable.
2. A `GloomTrigger` Area2D covers the corridor ceiling → Gloom fills while Ren is inside (the dark corridor simulates being out of Hana's light even with her following).
3. Ren reaches 100px from the Lurker → it snaps forward with no warning.
4. If the player rolls immediately after the snap → iframes absorb it.
5. The Lurker does not reset. It returns to IDLE after one strike.

**Atmosphere:**
- 🔊 No ambient change — the silence here is oppressive, a deliberate contrast to Beat 3.
- 💡 Hana's light barely reaches both corridor walls. Tight and claustrophobic.
- 🔊 Lurker attack: a sharp bamboo crack SFX.

**Dialogue:**
> **Hana:** *"Stay close. The Gloom feeds on loneliness — it always has."*

*Fires when Ren enters the corridor entrance. Hides after 4 seconds.*

**Design intent:** Teach surprise. The player thought they were just walking through bamboo. The narrow corridor also forces the player to commit — they can't dodge sideways. Only roll forward or backward.

---

### 🌑 BEAT 5 — The Open Grove (Gloom Wisps)
**Platform layout:** Open section, ~15 tiles wide. A few low decorative platforms that the player can stand on but aren't required for navigation. Wide enough to dodge in multiple directions.

**Enemies:** `GloomWisp_1` and `GloomWisp_2`
- Both placed on opposite sides of the section (left wall and right wall).
- Speed: 30px/s. They move toward Hana's `global_position` — not Ren's.
- On contact with `HanaLightRadius` → `reduce_light(0.20)` shrinks Hana's radius by 20%, then Wisp `queue_free()`s.
- One Wisp hit: 150px → 120px radius.
- Two Wisp hits: 120px → 96px radius.
- Three Wisp hits: 96px → 76px radius.
- Four Wisp hits: 76px → 60px radius.
- Five Wisp hits: hits the minimum cap of 40px — Hana cannot shrink further.

**Combat math:** With 2 Wisps: both reach Hana while the player deals with the corridor aftermath. Player must actively intercept them. The Wisps do NOT damage Ren — only Hana's radius.

**Encounter flow:**
1. Wisps begin moving toward Hana immediately when the player enters the area.
2. Player cannot kill them with melee (they are `Area2D` — not `CharacterBody2D`). They cannot be attacked.
3. The only way to protect Hana is to **move faster than the Wisps** — keep Hana moving so Wisps have to chase, or lead the Wisps away.
4. If both Wisps reach Hana → radius shrinks to 96px. Noticeably smaller on screen.

**Atmosphere:**
- 🔊 Dark, pulsing sound as Wisps approach. Low hum.
- 💡 If a Wisp reaches Hana, her light visibly shrinks. Gold circle contracts.

**Dialogue:**
> **Ren:** *"Hana — hold on! Don't let them snuff you out!"*

*Fires when the first Wisp is spawned / when the player enters Beat 5. Hides after 3 seconds.*

**Design intent:** Reframe the threat. The player has been focused on protecting Ren. Now they must protect Hana. This creates the emotional core: Ren needs Hana's light to survive, and Hana needs Ren to keep moving so the Wisps can't catch her.

---

### 💙 BEAT 6 — Kaito's Memory (The Headband)
**Platform layout:** Single flat platform. No jumps required. No enemies. Wide open.

**What happens:**
1. A prop (Sprite2D — Kaito's blood-stained sash/headband) sits on the ground.
2. A `KaitoMemoryTrigger` Area2D covers it.
3. When Ren walks onto it → the DialogueBox fires Ren's grief line.
4. 1 second later → Kaito's memory flash triggers.

**Kaito's Memory Flash:**
- `KaitoEchoLight` (the PointLight2D on the sword) tweens from Energy 0 → 2.5 in 0.05s, then back to 0 over 0.25s.
- `kaito_echo_triggered` signal fires → the Atmosphere Lead's Tween activates.
- Simultaneously, the second dialogue line fires (Kaito's voice).

**Enemies:** None. Zero enemies. The player is safe here — deliberately.

**Atmosphere:**
- 🔊 All ambient sound drops for 0.5 seconds (brief silence) — then a single deep Shinto bell tone.
- 💡 Kaito's ice-blue flash. Then returns to only Hana's gold glow.

**Dialogue (two lines in sequence):**
> **Ren:** *"...Kaito. He died right here. Right on this ground."*
> *(2 second pause)*
> **Kaito** *(echoing, distant):* *"Move, little brother. Grieve later."*

*First line fires on trigger entry. Second fires 2 seconds later. Both hide after their 4-second window.*

**Design intent:** Introduce Kaito as a presence before Level 2 makes him fully active. The flash of blue light + his voice establishes him. The player should feel the weight of Ren's guilt and the older brother's cold, loving authority.

---

### 🏃 BEAT 7 — The Climax (The Gloom Rises)
**Platform layout:** A narrow upward-sloping corridor. 4 tiles wide, angled 20–30° upward. Goes from the flat section of Beat 6 to the level exit gate at the top. `HollowedAsh_2` blocks the midpoint of the corridor.

**Enemy:** `HollowedAsh_2`
- Positioned mid-corridor. **Does not patrol** — stands stationary facing left (toward Ren's approach).
- On detection (200px): immediately CHASE. No patrol phase.
- Same stats as Ash_1: HP 30, attack 20, chase speed 90px/s.
- Placed in a tight space — the player must either fight it (2 hits) or roll through it using iframes.

**Gloom Climax trigger:**
1. `GloomClimaxTrigger` Area2D covers the bottom of the corridor.
2. When Ren enters → a `GloomTrigger` at the corridor bottom begins filling Gloom at double the normal rate (20/s instead of 10/s).
3. A visual effect (the ground turns darker purple, rising) signals danger.
4. The Gloom meter fills visibly faster. The player must reach the top before it hits 100.

**At 100% Gloom:** `player_died` signal fires → scene reloads from the start.

**Atmosphere:**
- 🔊 Deep Taiko drum hit plays the moment the GloomClimaxTrigger fires.
- 🔊 A rising, low rumble under the ambient — building pressure.
- 💡 Hana's light becomes slightly more orange/red — a visual tint shift to signal danger.

**Dialogue:**
> **Hana:** *"It knows we're here. REN — RUN!"*

*Fires immediately when GloomClimaxTrigger is entered. Does not auto-hide — stays visible for the entire climax to maintain urgency.*

**Design intent:** The level's one moment of pure adrenaline. After 3 minutes of careful navigation, the player must move fast. Everything the level taught — don't run from Hana, roll through enemies, don't stop — is tested in a 20-second sprint.

---

### 🚪 BEAT 8 — The Level Exit
**Platform layout:** A small landing platform at the top of the climax corridor. Wide enough to stop and breathe.

**What happens:**
1. Ren reaches the top. The Gloom stops rising (it only fills in the corridor zone — the exit platform is safe).
2. A tall `LevelEnd` Area2D (32×200px vertical strip) marks the right edge of the platform.
3. When Ren walks into it → `get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")`.

**No dialogue. No enemies. No Gloom.** Just the gate and the path forward.

**Atmosphere:**
- 🔊 All ambient fades. 1 second of silence.
- 💡 As Ren reaches the exit, the screen briefly dims — a transition to Level 2.

**Design intent:** Let the player exhale. The relief of silence after the climax sprint is itself a reward.

---

## 🧮 Full Stats Reference

### Ren
| Stat | Value | Notes |
|------|-------|-------|
| Max HP | 100 | Exported; tunable |
| Speed | 200 px/s | |
| Jump force | -400 (upward) | |
| Roll duration | 0.4s | Iframe window |
| Roll speed | 350 px/s | |
| Gloom rate | Fills at 10/s | When outside Hana's radius |
| Gloom recovery | 5/s | When inside Hana's radius |
| Kaito Echo trigger | Below 25 HP | One-time auto-parry per health-below-25% event |

### Hana
| Stat | Value | Notes |
|------|-------|-------|
| Follow speed | 5 (lerp factor) | Creates the ghostly trailing lag |
| Light radius | 150 px | Starting radius of the safe zone |
| Min light radius | 40 px | Wisps can never shrink below this |
| Gloom fill rate | 10/s | Outside radius |
| Gloom recovery | 5/s | Inside radius |

### Hollowed Ash
| Stat | Value | Notes |
|------|-------|-------|
| Max HP | 30 | Dies in 2 hits from Broken Edge (15 dmg × 2) |
| Patrol speed | 50 px/s | |
| Chase speed | 90 px/s | |
| Attack damage | 20 HP | Kills Ren in 5 unblocked hits |
| Attack cooldown | 1.5s | Between attacks |
| Detection radius | 200 px | Area2D circle |
| Attack range | 40 px | Distance to trigger ATTACK state |

### Bamboo Lurker
| Stat | Value | Notes |
|------|-------|-------|
| Max HP | 20 | |
| Attack damage | 15 HP | |
| Trigger radius | 100 px | |
| Attack duration | 0.8s total | Hitbox active 0.3s–0.1s |
| One-shot | Yes | Does not reset to IDLE in Level 1 |

### Gloom Wisp
| Stat | Value | Notes |
|------|-------|-------|
| Speed | 30 px/s | Moves toward Hana |
| Ren damage | 0 | Does NOT hurt Ren |
| Hana radius reduction | 20% per contact | Min 40px floor |
| On contact | `queue_free()` | Wisp is consumed on hit |

---

## 🎙️ All Dialogue — In Order

| # | Beat | Speaker | Text | Display Duration |
|---|------|---------|------|-----------------|
| 1 | Start | *[Environment]* | *"The mud is cold. The bamboo is silent. Something is wrong with the sky."* | 4s |
| 2 | Hana found | **Hana** | *"Ren... I found you. Don't let go of the lantern. Please."* | 4s |
| 3 | First enemy | **Ren** | *"They're still here. The soldiers who killed us. Their grudge won't let them rest."* | 4s |
| 4 | Corridor | **Hana** | *"Stay close. The Gloom feeds on loneliness — it always has."* | 4s |
| 5 | Wisps | **Ren** | *"Hana — hold on! Don't let them snuff you out!"* | 3s |
| 6a | Kaito headband | **Ren** | *"...Kaito. He died right here. Right on this ground."* | 4s |
| 6b | Memory flash | **Kaito** *(echoing)* | *"Move, little brother. Grieve later."* | 4s |
| 7 | Climax | **Hana** | *"It knows we're here. REN — RUN!"* | Until scene ends |

---

## 🔊 Audio Cue Map

| Moment | Sound | Notes |
|--------|-------|-------|
| Scene opens | Rain + bamboo creak | Looping ambient, very low |
| Hana spawns | Hana lantern hum begins | Looping, barely audible |
| Hana spawns | Grove ambience starts | Whisper wind loop |
| Hollowed Ash attacks | Sword whoosh / metal clink | Short, hollow — not heroic |
| Hollowed Ash dies | Soul dissipation sound | Ghost fade-out SFX |
| Kaito echo flash | Spectral clash / bell sting | Simultaneous with blue light flash |
| BambooLurker triggers | Bamboo crack | Sharp, sudden |
| Climax starts | Deep Taiko drum hit | Single heavy impact |
| Climax active | Rising low rumble | Builds under ambient |
| Level exit | All audio fades | 1 second silence before scene transition |

---

## 💡 Lighting Map

| Location | Light Source | Color | Energy |
|----------|-------------|-------|--------|
| Everywhere | `CanvasModulate` | `#1A0030` | — (darkens all) |
| Hana's position | `PointLight2D` (HanaLight) | `#FFD580` | 1.2 |
| Ren's sword | `PointLight2D` (KaitoEchoLight) | `#00BFFF` | 0 → 2.5 → 0 on trigger |
| Everywhere else | No other lights | — | — |

---

## ✅ Level 1 Complete Checklist (Team Sign-Off)

Run `Level_1.tscn` end-to-end. All must be green before starting Level 2.

| # | Check | Owner |
|---|-------|-------|
| 1 | Screen is completely dark on load | Atmosphere + World-Builder |
| 2 | Beat 0 dialogue fires 1 second after scene starts | World-Builder |
| 3 | Hana's gold light activates when HanaSpawnTrigger is entered | Atmosphere + World-Builder |
| 4 | Gloom Meter appears and fills when Ren leaves Hana's radius | Architect + World-Builder |
| 5 | Gloom Meter drains when Ren returns to Hana's radius | Architect |
| 6 | Beat 1 dialogue fires on Hana spawn | World-Builder |
| 7 | Hana visually trails behind Ren with lag | Architect |
| 8 | Beat 2 ledges require effort but are possible without Hana's light | World-Builder |
| 9 | HollowedAsh_1 patrols, chases, and attacks | Architect |
| 10 | HollowedAsh dies in 2 Broken Edge hits (if implemented in L1) | Architect |
| 11 | Beat 3 dialogue fires before first Ash detection | World-Builder |
| 12 | BambooLurker looks identical to bamboo in IDLE | Visual Artist + World-Builder |
| 13 | BambooLurker triggers once, attacks, does not reset | Architect |
| 14 | Beat 4 dialogue fires at corridor entrance | World-Builder |
| 15 | Both Gloom Wisps move toward Hana, NOT Ren | Architect |
| 16 | Hana's light radius visibly shrinks when a Wisp reaches her | Architect + Atmosphere |
| 17 | Beat 5 dialogue fires when Wisps appear | World-Builder |
| 18 | Kaito's memory beat area has NO enemies | World-Builder |
| 19 | Beat 6 Ren dialogue fires on KaitoMemoryTrigger | World-Builder |
| 20 | Kaito echo flash (ice blue) fires 2 seconds later | Atmosphere |
| 21 | Beat 6 Kaito dialogue fires after the flash | World-Builder |
| 22 | Climax Gloom fills faster than normal (20/s) | Architect |
| 23 | Taiko drum hit fires at climax trigger | Atmosphere |
| 24 | Beat 7 Hana dialogue fires and STAYS visible | World-Builder |
| 25 | HollowedAsh_2 blocks mid-corridor; player can roll through | Architect + World-Builder |
| 26 | Reaching LevelEnd loads Level_2.tscn | World-Builder |
| 27 | Player_died at 100% Gloom reloads Level_1.tscn | World-Builder + Architect |
| 28 | All sprites visible — no blurry imports | Visual Artist |
| 29 | All signals wired — no broken connections in Node tab | World-Builder |
| 30 | Level completable in under 4 minutes at walking pace | World-Builder (layout) |
