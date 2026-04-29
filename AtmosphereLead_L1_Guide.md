# Atmosphere Lead — Level 1 Implementation Guide
### The Three-Fold Debt | Godot 4.x

> **Your role:** You set the emotional tone of the entire game. Without your work, the level is a silent grey box. With it, the bamboo grove feels alive, lonely, and threatening.
>
> You own three domains: **Lighting**, **Audio**, and **Narrative**. None of these require writing GDScript from scratch — mostly editor configuration and one simple Autoload script.
>
> **Tone target for Level 1:** Lonely. Quiet. Unsettling. The silence should feel wrong. Every sound should feel like it could be the last one.

---

## 🔦 Part 1 — Lighting

### The Design Philosophy
The game uses Godot's **CanvasModulate** to make the world pitch black. Then, specific `PointLight2D` nodes are the *only* things that reveal the world. In Level 1, **Hana's lantern is the only light source.** This is your primary tool for tension — if Ren strays from Hana, he walks into absolute darkness.

You have exactly **2 lights** to set up in Level 1. Do not add more. Extra lights break the tension.

---

### Light 1 — Hana's Lantern (Primary, Always On)

**Where it lives:** Inside `Player.tscn`, as a child of the `Hana` node.

**Step-by-step:**
1. Open `Player.tscn` (wait for the Artist to have finished their work on it, or coordinate — only one person edits a `.tscn` at a time).
2. In the Scene dock, find the `Hana` node (child of the Player root).
3. Right-click `Hana` → **Add Child Node** → search `PointLight2D` → click **Add**.
4. Rename it `HanaLight`.
5. In the Inspector, set:

| Property | Value | Why |
|----------|-------|-----|
| **Color** | `#FFD580` | Warm gold — feels safe, like firelight |
| **Energy** | `1.2` | Bright enough to see platforms clearly |
| **Texture Scale** | `2.0` | Controls the radius of the light cone |
| **Shadow Enabled** | `false` | Shadows cost performance; skip for the jam |
| **Blend Mode** | Add | Standard glow blend |

6. Set `Position` to `Vector2(0, -8)` so the light emanates from Hana's flame, not her feet.
7. Save `Player.tscn`.

**Testing:** With `CanvasModulate` set to `#1A0030` in `Level_1.tscn`, run the scene. The only visible area should be a warm gold circle around Hana. Walking Ren away from Hana should plunge him into total darkness.

---

### Light 2 — Kaito's Echo Flash (Triggered, Momentary)

This light fires when Kaito's passive parry (`kaito_echo_triggered` signal) activates. It's a brief ice-blue flash on the sword — a ghost of Kaito's power.

**Where it lives:** Inside `Player.tscn`, as a child of the Player root (or a child of a `KaitoSword` Marker2D if the Artist has created one).

**Step-by-step:**
1. In `Player.tscn`, add a child of the root: **PointLight2D**. Name it `KaitoEchoLight`.
2. Set its properties:

| Property | Value |
|----------|-------|
| **Color** | `#00BFFF` (neon ice blue) |
| **Energy** | `0` (starts invisible) |
| **Texture Scale** | `1.0` (smaller than Hana — it's a flash, not a glow) |
| **Shadow Enabled** | `false` |

3. Position it at approximately `Vector2(20, -10)` — near where Ren holds his broken sword.

**Wiring the Tween:**
4. Select `KaitoEchoLight` in the Scene dock.
5. Open the **Node tab** → find the `Player` node's `kaito_echo_triggered` signal.
6. Connect it to a new function. Then add this script to `KaitoEchoLight` (right-click → Attach Script → create a new script `KaitoEchoLight.gd`):

```gdscript
extends PointLight2D

func trigger_flash():
    # Flash ice blue when Kaito's echo parries an attack
    var tween = create_tween()
    tween.tween_property(self, "energy", 2.5, 0.05)  # Snap to bright
    tween.tween_property(self, "energy", 0.0, 0.25)  # Fade out over 0.25s
```

7. In the Node tab → `kaito_echo_triggered` → Connect → receiver: `KaitoEchoLight` → function: `trigger_flash`.

**Testing:** Take damage while Ren's health is below 25%. The screen should briefly flash ice blue, then return to only Hana's gold glow.

---

## 🔊 Part 2 — Audio Manager Setup

### Create the AudioManager Autoload
The AudioManager is a **singleton** — it lives outside any scene and is accessible from anywhere. The Architect triggers sounds through it by calling `AudioManager.play_footstep()` without needing to know where the audio files are.

**Step-by-step:**
1. In the FileSystem dock, right-click `Scripts/` → **New Script** → name it `AudioManager.gd`.
2. Paste this complete script:

```gdscript
extends Node
# AudioManager.gd — Global Autoload Singleton
# Call these functions from anywhere: AudioManager.play_footstep()

@onready var sfx_sword    = $SwordClink
@onready var sfx_footstep = $Footstep
@onready var sfx_kaito    = $KaitoEcho
@onready var sfx_hana_hum = $HanaHum
@onready var sfx_enemy_die = $EnemyDeath
@onready var sfx_gloom_rise = $GloomRise
@onready var ambient_grove = $AmbientGrove

func play_sword_swing():
    sfx_sword.pitch_scale = randf_range(0.95, 1.05)
    sfx_sword.play()

func play_footstep():
    if sfx_footstep.playing: return  # Don't overlap footsteps
    sfx_footstep.pitch_scale = randf_range(0.9, 1.1)
    sfx_footstep.play()

func play_kaito_echo():
    sfx_kaito.play()

func play_enemy_death():
    sfx_enemy_die.pitch_scale = randf_range(0.85, 1.05)
    sfx_enemy_die.play()

func play_gloom_rise():
    sfx_gloom_rise.play()

func start_grove_ambience():
    if not ambient_grove.playing:
        ambient_grove.play()

func stop_grove_ambience():
    ambient_grove.stop()

func start_hana_hum():
    sfx_hana_hum.play()
```

3. **Register as Autoload:** Go to **Project → Project Settings → AutoLoad** tab.
4. Click the folder icon → select `AudioManager.gd`.
5. Name: `AudioManager`. **Enable** the checkbox. Click **Add**.

Now create the `AudioManager.tscn` scene to hold the actual audio nodes:

1. **FileSystem** → New Scene → root: **Node** (plain Node). Name it `AudioManager`. Save as `Scenes/AudioManager.tscn`.
2. Attach `AudioManager.gd` to the root.
3. Add these child nodes (all type `AudioStreamPlayer` — **not** 2D, they are global):

| Child Node Name | Volume DB | Notes |
|----------------|-----------|-------|
| `SwordClink` | -6 | Short sword impact sound |
| `Footstep` | -8 | Dirt/mud step sound |
| `KaitoEcho` | -4 | Ghost parry sound |
| `HanaHum` | -18 | Always-on ambient lantern hum (set Autoplay ON) |
| `EnemyDeath` | -6 | Ghost dissipation sound |
| `GloomRise` | -6 | Deep drum hit for the climax |
| `AmbientGrove` | -18 | Looping background wind/whisper (set Loop ON, Autoplay OFF) |

> **HanaHum vs AmbientGrove:** HanaHum uses Autoplay and plays as soon as the scene starts. AmbientGrove starts when the World-Builder's `HanaSpawnTrigger` fires (they call `AudioManager.start_grove_ambience()` from their trigger script).

4. Update the Autoload path in Project Settings to point to `AudioManager.tscn` instead of the `.gd` file directly (this ensures the node tree with the AudioStreamPlayer children is loaded).

---

## 🎵 Part 3 — Sourcing the 5 Core Sound Effects

All sounds must be **CC0 (royalty-free, no attribution required)**. Source from:
- **Freesound.org** (filter: CC0)
- **Kenney.nl** (Impact Sounds, UI Audio packs)

After downloading, save every file to `/Assets/Audio/SFX/` as `.wav` (not `.mp3` — Godot handles `.wav` better for short SFX).

### The 5 Sounds

| # | Sound | Search Terms | Target File | Notes |
|---|-------|-------------|-------------|-------|
| 1 | **Broken sword clink** | `"katana swing"`, `"metal clank short"`, `"sword impact"` | `sword_clink.wav` | Should feel hollow/broken, not powerful. Avoid heroic metallic ringing. |
| 2 | **Footstep on dirt/mud** | `"footstep dirt"`, `"mud step"`, `"soft ground footstep"` | `footstep_dirt.wav` | Pick a dull, soft thud — not a crisp click. Ren is a ghost moving through mud. |
| 3 | **Ghost whisper / wind breath** | `"spirit whisper"`, `"wind ambient loop"`, `"ghost breath"` | `ambient_grove.wav` | Must be a **loop** with no obvious start/end click. Very low energy. |
| 4 | **Lantern hum / flame** | `"lantern hum"`, `"flame crackle soft"`, `"oil lamp"` | `hana_hum.wav` | Warm, constant, barely audible. Think: the only comforting sound in the game. |
| 5 | **Low Taiko drum hit** | `"taiko drum"`, `"deep drum thud"`, `"war drum single hit"` | `gloom_rise.wav` | One heavy impact. No reverb tail. Used at the climax moment when the Gloom starts rising. |

### Importing Audio Files
1. Drag each `.wav` file from Windows Explorer into Godot's FileSystem dock onto `/Assets/Audio/SFX/`.
2. Select the imported file. Open the **Import** tab.
3. Settings for **SFX (short sounds):**
   - **Loop:** Off
   - **Compress:** On (or Lossless for small files)
4. Settings for **ambient_grove.wav (loop):**
   - **Loop:** On
   - **Loop Mode:** Ping-Pong or Forward (whichever sounds smoother on transition)
5. Click **Reimport** after every settings change.
6. Assign each `.wav` to the correct `AudioStreamPlayer` child node: select the node → Inspector → **Stream** → drag the `.wav` file in.

---

## 👻 Part 4 — Bonus: Enemy Sound Effects

These are lower priority but add significant polish. Source and import the same way.

| Sound | When It Plays | Search Terms | File Name |
|-------|-------------|-------------|-----------|
| **Hollow Ash spawn** | When the Ash appears or begins chasing | `"ghost moan"`, `"spirit groan"` | `ash_spawn.wav` |
| **Hollow Ash attack** | When the Ash lunges | `"whoosh"`, `"spirit strike"` | `ash_attack.wav` |
| **Enemy death / soul release** | When any enemy's `soul_released` signal fires | `"soul dissipate"`, `"ghost death"`, `"spirit fade"` | `enemy_death.wav` |
| **Kaito echo parry** | When `kaito_echo_triggered` fires | `"spectral clash"`, `"ghostly ring"`, `"bell sting"` | `kaito_echo.wav` |
| **Gloom Wisp contact** | When a Wisp touches Hana's light | `"dark orb burst"`, `"wisp extinguish"` | `wisp_die.wav` |

**Wiring enemy sounds** (coordinate with Architect to add these two lines to `HollowedAsh.gd`):
```gdscript
# In start_attack():
AudioManager.play_sword_swing()

# In take_damage() when health <= 0:
AudioManager.play_enemy_death()
```

---

## ✍️ Part 5 — Narrative: Dialogue Script

The World-Builder pastes your lines into the `DialogueTrigger` Area2D scripts in `Level_1.tscn`. Your job is to write and deliver these lines in a shared Google Doc.

### The 8 Dialogue Beats

| # | Trigger Location | Speaker | Line | Tone |
|---|-----------------|---------|------|------|
| 1 | Game start | *[Environment — no speaker name]* | *"The mud is cold. The bamboo is silent. Something is wrong with the sky."* | Disorientation |
| 2 | Hana discovered | **Hana** | *"Ren... I found you. Don't let go of the lantern. Please."* | Desperate relief |
| 3 | First enemy | **Ren** *(inner monologue)* | *"They're still here. The soldiers who killed us. Their grudge won't let them rest."* | Quiet dread |
| 4 | Narrow corridor | **Hana** | *"Stay close. The Gloom feeds on loneliness — it always has."* | Warning, love |
| 5 | Gloom Wisps | **Ren** | *"Hana — hold on! Don't let them snuff you out!"* | Panic, protectiveness |
| 6 | Kaito headband | **Ren** | *"...Kaito. He died right here. Right on this ground."* | Grief |
| 7 | Memory flash | **Kaito** *(echoing, distant)* | *"Move, little brother. Grieve later."* | Authority, warmth |
| 8 | Gloom rising | **Hana** | *"It knows we're here. REN — RUN!"* | Pure fear |

### Writing Rules
- **2 sentences maximum** per beat. Never more.
- **No lore dumps.** Don't explain the Kodoku Curse. Let the player feel the emotion without understanding everything yet.
- **Speaker attribution:** The World-Builder's `DialogueLabel` just shows the text. If you want a speaker name displayed, prefix the line with `[Hana]` or `[Ren]` and ask the World-Builder to style it differently.

---

## 🔌 Part 6 — Signal Connections You Own

You must connect two signals in the editor (coordinate with the World-Builder who has `Level_1.tscn` open):

| Signal | Source | What You Connect To | Effect |
|--------|--------|-------------------|--------|
| `kaito_echo_triggered` | `Player` node | `KaitoEchoLight.trigger_flash()` | Blue flash on parry |
| `kaito_echo_triggered` | `Player` node | `AudioManager.play_kaito_echo()` | Echo sound on parry |

**How to connect:**
1. In `Level_1.tscn` (ask World-Builder to do this during their signal wiring session, or open it yourself when they're not in it):
2. Select the `Player` instance → **Node tab** → `kaito_echo_triggered`.
3. Connect to `KaitoEchoLight` node inside Player → function `trigger_flash`.
4. Connect a second time to `AudioManager` → function `play_kaito_echo`.

---

## ✅ Part 7 — Final Atmosphere Checklist

Run `Level_1.tscn` from start to finish. Check:

### Lighting
- [ ] Screen is **completely dark** without Hana's light (CanvasModulate `#1A0030` active)
- [ ] Hana emits a warm **gold glow** (`#FFD580`) that clearly illuminates a circle around Ren
- [ ] Moving Ren far from Hana plunges him into total darkness
- [ ] Kaito echo parry triggers a brief **ice blue flash** (`#00BFFF`) then fades in 0.25s
- [ ] Kaito light does NOT stay on — it returns to energy 0 after the flash

### Audio
- [ ] Hana's lantern hum plays immediately and loops quietly throughout the level
- [ ] Grove ambience starts after the `HanaSpawnTrigger` fires (coordinate with World-Builder)
- [ ] Footstep sound plays with slight pitch variation — does not sound robotic
- [ ] Sword clink plays when Ren attacks
- [ ] Enemy death sound plays when Hollowed Ash dies
- [ ] Kaito echo sound plays simultaneously with the blue flash
- [ ] Deep Taiko drum hits when the Gloom starts rising in the climax
- [ ] No audio is too loud — grove ambience and hum should be felt, not heard

### Narrative
- [ ] All 8 dialogue lines fire at the correct trigger location
- [ ] Dialogue auto-hides after ~4 seconds (ask World-Builder to set the timer)
- [ ] No two dialogue boxes appear simultaneously
- [ ] Kaito's memory flash line feels different from Ren's lines (echoing quality — ask Architect if a pitch shift `pitch_scale = 0.85` effect can be added to that AudioStreamPlayer)

---

## 🚨 Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Hana light too bright (everything visible in darkness) | Lower Energy to 0.8, reduce Texture Scale to 1.5 |
| Kaito flash stays on permanently | Check the Tween targets energy `0.0` at the end, not `2.5` |
| Footstep sound overlaps/doubles | Add `if sfx_footstep.playing: return` at the top of `play_footstep()` |
| Grove ambience has an audible loop click | Re-import the `.wav` with Loop Mode: Ping-Pong or trim the clip in Audacity to create a seamless loop |
| AudioManager functions not found | Verify AudioManager is registered in Project → Project Settings → AutoLoad with correct path |
| Two PointLight2D nodes fighting (different colors mixing) | Ensure only HanaLight and KaitoEchoLight exist — delete any test lights you placed |
| Dialogue fires on first frame before player controls load | Add a 0.5s `await get_tree().create_timer(0.5).timeout` before the first dialogue in the trigger script |
