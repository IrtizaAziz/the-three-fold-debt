# Level 1 Role Breakdown: The Whispering Bamboo Grove

> **Level Theme:** Survival & Discovery | **Target Duration:** ~3–4 minutes  
> **Core Mechanic Focus:** Hana's light radius & the Gloom death-meter  
> **Phase:** Graybox → Playable Tutorial

---

## 🧠 The Architect (Lead Programmer)

### What You're Building for Level 1

Level 1 is your **tutorial foundation**. Your goal is to get a functional, playable character into the grove and wire up the two core systems: **Ren's movement** and **Hana's light/Gloom mechanic**.

---

### Task 1 — Ren's Player Controller (`Player.tscn`)

Set up `Ren` as a `CharacterBody2D` with the following states:

| State | What it does |
|-------|-------------|
| `IDLE` | Ren stands still; no input |
| `RUN` | Left/Right arrow keys; apply acceleration and friction |
| `JUMP` | Space bar; apply upward velocity with a gravity modifier for snappy fall |
| `FALL` | Gravity pulls Ren down after jump apex |
| `ROLL` | Shift key; short iframe dash through enemies |

**Rules:**
- Use Godot's `move_and_slide()` for all movement.
- Keep gravity, jump force, and friction as **exported variables** so values can be tweaked without code changes.
- Do NOT add attack logic yet — that's Level 2's job.

---

### Task 2 — Hana's Follow Logic & Light Radius

Hana is a spirit node that floats near Ren. Her position should lag slightly behind him (creates a ghostly feel).

- Use a `Tween` or `lerp()` in `_physics_process()` to make Hana smoothly follow Ren's position.
- Attach an `Area2D` (named `HanaLightRadius`) with a `CircleShape2D` to represent her Safe Zone.
- When Ren is **inside** the radius: nothing happens.
- When Ren **exits** the radius: begin filling the **Gloom Meter**.

```gdscript
# Pseudocode for Gloom logic
if not hana_radius.overlaps_body(ren):
    gloom_meter += GLOOM_RATE * delta
    if gloom_meter >= 100:
        emit_signal("player_died")
else:
    gloom_meter = max(0, gloom_meter - GLOOM_RECOVERY * delta)
```

- Emit a `gloom_changed(value)` signal so the World-Builder's UI can listen for it — **do not touch the UI script directly**.

---

### Task 3 — Kaito's "Vengeful Echo" (Passive Auto-Parry)

Kaito is not yet awake, but acts as a safety net:

- Monitor Ren's health. When health drops below **25%**, start a one-shot `Timer` (2-second cooldown).
- On the next incoming enemy hitbox collision while the timer is active, play a brief **Kaito spectral hand animation** and negate the damage (block it).
- Emit a `kaito_echo_triggered` signal so the Atmosphere Lead can fire a sound effect.

---

### Task 4 — Enemy AI: Hollow Ash & Bamboo Lurkers

Keep enemy AI brutally simple for Level 1:

**Hollowed Ash (foot soldier ghost):**
- `PATROL`: Walk left and right between two `Marker2D` points.
- `CHASE`: If Ren enters an `Area2D` detection radius, move toward him.
- `ATTACK`: When close enough, play attack animation and spawn a hitbox briefly.

**Bamboo Lurker:**
- Default state: static (looks like bamboo).
- Triggered state: When Ren's `Area2D` enters the lurker's proximity, play a "bend and whip" animation and spawn a forward hitbox.
- No movement needed — it is rooted in place.

**Gloom Wisp:**
- Floats toward Hana's position using `lerp()`.
- On contact with Hana's `Area2D`, reduce her light radius by 20%.
- Does NOT damage Ren directly.

---

### Week 1–2 Deliverable Checklist

- [ ] `Player.tscn` — Ren can run, jump, and roll
- [ ] Hana follow-logic working with smooth lag
- [ ] `HanaLightRadius` Area2D emits `gloom_changed` signal correctly
- [ ] Gloom meter fills when Ren leaves the light
- [ ] One enemy (Hollowed Ash) patrolling and chasing
- [ ] Signals used for all inter-scene communication (no direct node references across scenes)

---

---

## 🎨 The Visual Artist (Character & FX)

### What You're Creating for Level 1

Level 1 is your **art foundation sprint**. You are establishing the visual language of the entire game. Prioritize readability of silhouettes over detail.

---

### Task 1 — Style Guide (Day 1 Priority)

Before drawing anything, lock in the **color palette** and share it with the whole team:

| Element | Color | Hex Suggestion |
|---------|-------|----------------|
| World Background | Ink Black / Deep Purple | `#0D0A1A` |
| Bamboo Grove | Ghostly Translucent White | `#D0E8FF` (low opacity) |
| Ren (Silhouette) | Pure Black / Charcoal | `#1A1A2E` |
| Enemy (Hollowed Ash) | Medium Grey with Red Eyes | `#5A5A6A` / `#FF2222` |
| Hana (Light) | Warm Gold | `#FFD700` |
| Kaito (Steel) | Neon Ice Blue | `#00BFFF` |
| Gloom | Pitch Black with Purple Tint | `#1A0030` |

> **Rule:** If an element can't be identified by its silhouette alone, simplify it. Every character must be instantly readable at 64×64px.

---

### Task 2 — Ren's Core Sprite Sheet

**Canvas size:** 64×96 px per frame  
**Style:** Black silhouette, no facial detail, broken katana clearly shorter than a full sword

| Animation | Frame Count | Notes |
|-----------|-------------|-------|
| Idle | 2 frames | Subtle breathing bob — chest rises/falls |
| Run | 4 frames | Exaggerated lean forward; broken sword trails behind |
| Jump (Rise) | 1 frame | Tucked knees, sword arm extended upward |
| Fall | 1 frame | Slightly spread arms, descent posture |
| Roll/Dodge | 3 frames | Low spin; blur smear on frame 2 |

> **Tip:** For the jump and fall, use a single sprite each. The Programmer's Tween will handle smooth transitions.

---

### Task 3 — Hana's Sprite

**Canvas size:** 48×48 px  
**Style:** A simple, round, glowing lantern shape with a ghostly wisp tail

| Animation | Frame Count | Notes |
|-----------|-------------|-------|
| Float | 2 frames | Very subtle — just the flame flickers |

> **Don't animate the bobbing.** Leave that to the Programmer's Tween node. Your job is only the flame flicker.

---

### Task 4 — Enemy Sprites

**Hollowed Ash:**
- Canvas: 48×80 px
- Style: Featureless grey human silhouette with glowing red eye sockets, carrying a ghostly pike

| Animation | Frames |
|-----------|--------|
| Walk | 4 frames |
| Attack Lunge | 2 frames |

**Bamboo Lurker:**
- A static sprite of a bamboo stalk (32×128 px)
- One "bent and whipping" frame for the attack animation

**Gloom Wisp:**
- A small dark orb (24×24 px), 2-frame pulse animation

---

### Task 5 — Particle Effects (Godot GPUParticles2D)

Do NOT draw these — set them up as Godot particle systems:

| Effect | Description |
|--------|-------------|
| Hana's Ambient Glow | Golden soft particles drifting upward slowly around her |
| Gloom Wisp Trail | Dark purple smoke particles trailing the wisp |
| Ren's Roll Dust | A small burst of grey particles at Ren's feet on dodge |

---

### Week 1–2 Deliverable Checklist

- [ ] Color palette / Style Guide shared with team (Google Doc or image file in `/Assets`)
- [ ] Ren: Idle + Run sprite sheets exported as PNG sprite sheets
- [ ] Hana: Float sprite (2 frames)
- [ ] Hollowed Ash: Walk + Attack sprite sheets
- [ ] Bamboo Lurker: Static + Attack frames
- [ ] Gloom Wisp: 2-frame pulse sprite

---

---

## 🗺️ The World-Builder (Level Design & UI)

### What You're Building for Level 1

You are building the **physical space** of the game and the **interface** that tells the player how they're doing. In Level 1, both must be functional before any other team member can test their work.

---

### Task 1 — Level 1 Scene Tree Structure

Set up `Level_1.tscn` with this exact hierarchy:

```
Level_1 (Node2D)
├── CanvasModulate          ← Global darkness (set to deep purple #1A0030)
├── TileMapLayer            ← All platforms and bamboo walls
├── Hazards (Node2D)
│   ├── GloomTrigger_1 (Area2D)   ← Pit/dark zone; signals gloom fill
│   ├── GloomTrigger_2 (Area2D)
│   └── BambooLurker_Spawn (Marker2D)
├── Enemies (Node2D)
│   ├── HollowedAsh_1 (instanced scene)
│   └── HollowedAsh_2 (instanced scene)
├── Events (Node2D)
│   ├── KaitoMemoryTrigger (Area2D)  ← End-of-level story beat
│   └── LevelEnd (Area2D)           ← Loads Level_2 scene
├── Player (instanced Player.tscn)
├── HUD (CanvasLayer)
│   ├── HealthBar (ProgressBar)
│   ├── GloomMeter (ProgressBar)
│   └── DialogueBox (PanelContainer)
└── AudioManager (AutoLoad reference — do not nest audio here)
```

> **Rule:** Keep `Player.tscn` as an instanced scene — never embed player code directly inside the level. This prevents Git merge conflicts with the Architect.

---

### Task 2 — Minimum Tile Types for Level 1 Graybox

You only need **4 tile types** to block out the level. Do not add decorative tiles yet:

| Tile Type | Color (Graybox) | Purpose |
|-----------|-----------------|---------|
| Solid Ground | Grey `#555555` | Main walkable floor |
| Platform | Dark Grey `#333333` | Floating ledges for jumps |
| Wall / Barrier | Dark Grey `#222222` | Blocks Ren's horizontal path |
| Hazard Zone | Red `#AA0000` | Marks instant-Gloom areas (bottomless pits) |

---

### Task 3 — The "Golden Path" Layout (3-Minute Route)

Build the level as a **left-to-right then upward** path. Follow this beat-by-beat flow:

| Beat | What Happens | Design Note |
|------|-------------|-------------|
| **Start** | Ren wakes in a flat, dark clearing | Tiny enclosed space; no jumps required |
| **Beat 1** | Hana's lantern discovered at roots of first tree | Place a glowing `Area2D` trigger here to spawn Hana and restore color |
| **Beat 2** | First platforming section — 3 ledges ascending | Gap width: slightly larger than a normal jump to encourage Hana dependency |
| **Beat 3** | First enemy encounter (1 Hollowed Ash, slow patrol) | Wide open space; give the player room to roll past |
| **Beat 4** | Narrow bamboo corridor with a Bamboo Lurker | Force the player to time their movement; Hana's light shrinks the threat |
| **Beat 5** | Open section with 2 Gloom Wisps targeting Hana | Teach the player to protect Hana |
| **Beat 6** | Kaito's headband on the ground — memory flash trigger | Single flat platform; no enemies. Place the `KaitoMemoryTrigger` Area2D here |
| **Climax** | Gloom begins rising from the bottom; run to gate | Narrow corridor sloping upward; the LevelEnd Area2D triggers Level 2 |

> **Rule:** The entire level must be completable in 3 minutes at a walking pace. If it takes longer, it is too long for a jam.

---

### Task 4 — HUD (Level 1 Minimum UI)

Build the HUD in a `CanvasLayer` so it renders above all world elements:

| UI Element | Node Type | Position | Notes |
|------------|-----------|----------|-------|
| Health Bar | `ProgressBar` | Top-left | Connect to Ren's `health_changed` signal |
| Gloom Meter | `ProgressBar` | Top-right | Connect to Architect's `gloom_changed` signal; use dark purple fill |
| Dialogue Box | `PanelContainer` + `Label` | Bottom-center | Hidden by default; visible when `DialogueTrigger` Area2D fires |

**Style rules (no custom art needed):**
- Use `StyleBoxFlat` in Godot's theme override.
- Health bar: Dark red background, bright red fill.
- Gloom meter: Black background, deep purple fill.
- Dialogue box: Semi-transparent black background, white text, no ornate borders.

---

### Week 1–2 Deliverable Checklist

- [ ] `Level_1.tscn` scene tree built with correct hierarchy
- [ ] 4 tile types painted; graybox Golden Path is walkable end-to-end
- [ ] `GloomTrigger` Area2Ds placed at all pit/dark zones
- [ ] `KaitoMemoryTrigger` and `LevelEnd` Area2Ds placed correctly
- [ ] HUD visible with Health Bar and Gloom Meter connected to signals
- [ ] Dialogue Box hidden by default, triggerable by Area2D overlap

---

---

## 🏮 The Atmosphere Lead (Audio, Narrative & Lighting)

### What You're Creating for Level 1

You set the **emotional tone** of the entire game. Level 1 must feel lonely, quiet, and unsettling. Your lighting makes the dark world real. Your sound makes the silence threatening. Your words give the siblings their voice.

---

### Task 1 — Core Lighting Setup

Set up the darkness layer in `Level_1.tscn` (coordinate with World-Builder to add these nodes):

**Step 1 — Global Darkness:**
- Add a `CanvasModulate` node to Level_1.
- Set its color to `#1A0030` (deep, oppressive purple-black).
- This makes the entire scene dark. Now nothing is visible without a light source.

**Step 2 — Hana's Light (Primary Light Source):**
- Inside `Player.tscn`, attach a `PointLight2D` as a child of Hana's node.
- Settings:

| Property | Value |
|----------|-------|
| Color | `#FFD580` (warm gold) |
| Energy | `1.2` |
| Texture Scale | `2.0` (start here; adjust for feel) |
| Shadow Enabled | `false` (keep it simple; shadows cost performance) |

**Step 3 — Kaito's Echo Flash:**
- Create a second `PointLight2D` as a child of the sword node.
- Default Energy: `0` (invisible).
- When `kaito_echo_triggered` signal fires, use a `Tween` to: Energy → `2.5` then back to `0` over 0.3 seconds.

> **Rule:** Keep it to these 2 lights in Level 1. Do not add ambient rim lights or decorative torches — that is Level 2's visual language.

---

### Task 2 — Top 5 Sound Effects to Source This Week

Find these sounds from **Freesound.org** or **Kenney.nl** (filter by CC0 license). Edit in **Audacity** if needed.

| # | Sound | Where to Use | Search Term |
|---|-------|-------------|-------------|
| 1 | **Broken sword clink** | Ren's basic attack swing | `"katana swing"` or `"metal clank"` |
| 2 | **Soft footstep (dirt/mud)** | Ren's run cycle (play every 2 steps) | `"footstep dirt"` |
| 3 | **Ghost whisper / wind breath** | Ambient background loop for the grove | `"spirit whisper"` or `"wind ambient"` |
| 4 | **Lantern hum** | Hana's ambient presence sound | `"lantern hum"` or `"flame crackle soft"` |
| 5 | **Low Taiko drum thud** | When the Gloom starts rising at the end of Level 1 | `"taiko drum"` or `"deep drum hit"` |

**Implementation notes:**
- Footstep: use `AudioStreamPlayer2D` on Ren. Randomize `pitch_scale` between `0.9` and `1.1` so it doesn't sound robotic.
- Hana's hum: use `AudioStreamPlayer` (not 2D) at very low volume — she's always nearby.
- Ambient grove: loop a background `AudioStreamPlayer` at `Volume DB: -18` — barely audible, but felt.

---

### Task 3 — Level 1 Dialogue Script

These lines appear in the World-Builder's Dialogue Box at specific trigger points. Keep every line under **2 sentences**.

| Trigger Location | Speaker | Dialogue |
|-----------------|---------|---------|
| Game start (Ren wakes) | *[No speaker — environmental text]* | *"The mud is cold. The bamboo is silent. Something is wrong with the sky."* |
| Hana discovered | **Hana** | *"Ren... I found you. Don't let go of the lantern. Please."* |
| First enemy encountered | **Ren** (inner monologue) | *"They're still here. The soldiers who killed us. Their grudge won't let them rest."* |
| Entering the narrow bamboo corridor | **Hana** | *"Stay close. The Gloom feeds on loneliness — it always has."* |
| Gloom Wisp attacks Hana | **Ren** | *"Hana — hold on! Don't let them snuff you out!"* |
| Kaito's headband discovered | **Ren** | *"...Kaito. He died right here. Right on this ground."* |
| Kaito memory flash triggers | **Kaito** *(distant, echoing)* | *"Move, little brother. Grieve later."* |
| Gloom begins rising (climax) | **Hana** | *"It knows we're here. REN — RUN!"* |

> **Writing Rule:** Do not explain the lore. Let the player feel it. Short, punchy, emotional. Never more than 2 sentences per beat.

---

### Task 4 — AudioManager Setup

Build an **Autoload Singleton** called `AudioManager.gd` so the Architect can trigger sounds without creating dependencies:

```gdscript
# AudioManager.gd (Autoload Singleton)
extends Node

@onready var sfx_sword = $SwordClink
@onready var sfx_footstep = $Footstep
@onready var sfx_hana_hum = $HanaHum
@onready var ambient_grove = $AmbientGrove

func play_sword_swing():
    sfx_sword.pitch_scale = randf_range(0.95, 1.05)
    sfx_sword.play()

func play_footstep():
    sfx_footstep.pitch_scale = randf_range(0.9, 1.1)
    sfx_footstep.play()

func start_grove_ambience():
    ambient_grove.play()

func stop_grove_ambience():
    ambient_grove.stop()
```

Register `AudioManager.gd` in **Project → Project Settings → AutoLoad**.

---

### Week 1–2 Deliverable Checklist

- [ ] `CanvasModulate` set to deep purple in `Level_1.tscn` (coordinate with World-Builder)
- [ ] Hana's `PointLight2D` configured with gold color and correct energy
- [ ] Kaito's flash light set up with `Tween` on `kaito_echo_triggered` signal
- [ ] Top 5 sound effects sourced and imported into `/Assets/Audio/SFX/`
- [ ] `AudioManager.gd` Autoload created and registered
- [ ] Level 1 dialogue script written and shared in Google Docs / Notion for World-Builder to implement

---

---

## 📅 Week 1–2 Team Sync Checklist

At the end of Week 2, the team should be able to run `Level_1.tscn` and see this working:

| Check | Owner |
|-------|-------|
| ✅ Ren runs, jumps, and rolls | Architect |
| ✅ Hana floats and follows Ren with a lag | Architect |
| ✅ Gloom Meter fills when Ren leaves Hana's light | Architect |
| ✅ At least 1 Hollowed Ash enemy patrols and chases | Architect |
| ✅ Ren, Hana, and Ash sprites replace placeholder squares | Visual Artist |
| ✅ Level graybox is walkable from start to LevelEnd trigger | World-Builder |
| ✅ Health Bar and Gloom Meter visible and reactive | World-Builder |
| ✅ Screen is dark; Hana is the only light | Atmosphere Lead |
| ✅ Grove ambience plays on level start | Atmosphere Lead |
| ✅ At least 2 dialogue lines fire at correct trigger points | Atmosphere Lead + World-Builder |

> **Reminder:** Do not start Level 2 until this checklist is 100% green. A polished, complete Level 1 is worth more than three broken levels.
