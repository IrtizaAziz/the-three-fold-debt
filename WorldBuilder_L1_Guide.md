# LEVEL 1: The Whispering Bamboo Grove
## World Builder's Complete Implementation Blueprint

---

## I. The Creative Vision

Level 1 is not a tutorial. It is a **resurrection**. Ren has been dead. He doesn't know how long. The bamboo grove doesn't care.

Every design decision in this level asks one question of the player before they even encounter an enemy:
> *"Will you stay with her, or leave her behind?"*

This question is never asked in words. It is asked through a purple bar that climbs when Ren runs too far ahead. It is asked through a gold circle that shrinks when he ignores the dark shapes chasing it. The answer determines whether the player has understood the game.

### The Emotional Arc

The level is a journey from **nothing → warmth → danger → grief → terror → escape**. Each beat is a distinct emotional state:

| Beat | Emotion | Design Weapon |
|------|---------|---------------|
| Grave | Emptiness, disorientation | Total darkness, no sound, nowhere to go |
| Hana Discovery | Relief, wonder | Warm gold light erupts; the world becomes visible |
| First Climb | Mild anxiety | Hana lags; Gloom ticks up briefly; player learns dependency |
| Hollowed Ash | Wariness | Slow, readable enemy; enough space to breathe |
| Bamboo Lurker | Shock | The ambush. Silence, then violence. No warning. |
| Gloom Wisps | Responsibility | The player must protect something other than themselves |
| Kaito's Memory | Grief | Silence, a ghost, a voice. The game breathes. |
| Climax | Pure adrenaline | Everything the level taught, tested in 20 seconds |
| Exit | Exhale | Silence again. But earned. |

### The Visual Language

The level operates on a simple visual grammar the player learns without reading:

- **Gold = safe.** Hana's light is the only warm color in the level. Wherever it reaches, the player can breathe.
- **Purple/black = death.** The `CanvasModulate` at `#1A0030` turns everything outside Hana's light into threat.
- **White/translucent = the spirit world.** Bamboo is ghostly white; enemies are grey. The world is already dead.
- **Blue = Kaito.** A single flash of ice-blue is his entire presence in Level 1. One flash. Unforgettable.

---

## II. Scene Architecture

### The Exact Node Hierarchy

Build `Level_1.tscn` with this structure. Node names are contract — the Architect's scripts look for these exact names.

```
Level_1 (Node2D)                     ← Root. Add a Level_1.gd script here.
│
├── CanvasModulate                    ← Global darkness. Color: #1A0030
│
├── TileMapLayer                      ← All terrain. One layer, 4 tile types.
│
├── Hazards (Node2D)                  ← Environmental threats (not enemies)
│   ├── GloomTrigger_Corridor (Area2D) ← Beat 4: corridor fills Gloom fast
│   ├── GloomTrigger_Climax (Area2D)   ← Beat 7: double-rate Gloom fill
│   └── BambooLurker_1 (instanced BambooLurker.tscn)
│
├── Enemies (Node2D)                  ← Combat encounters
│   ├── HollowedAsh_1 (instanced)    ← Beat 3
│   ├── GloomWisp_1 (instanced)      ← Beat 5 (left side)
│   ├── GloomWisp_2 (instanced)      ← Beat 5 (right side)
│   └── HollowedAsh_2 (instanced)    ← Beat 7: climax blocker
│
├── Events (Node2D)                   ← Story triggers and progression
│   ├── HanaSpawnTrigger (Area2D)    ← Beat 1: spawns Hana, reveals light
│   ├── DialogueTrigger_Grave (Area2D)     ← Beat 0: opening environmental text
│   ├── DialogueTrigger_FirstEnemy (Area2D) ← Beat 3: Ren's inner monologue
│   ├── DialogueTrigger_Corridor (Area2D)   ← Beat 4: Hana's warning
│   ├── DialogueTrigger_Wisps (Area2D)      ← Beat 5: Ren protects Hana
│   ├── KaitoMemoryTrigger (Area2D)         ← Beat 6: the grief beat
│   ├── GloomClimaxTrigger (Area2D)         ← Beat 7: point of no return
│   └── LevelEnd (Area2D)                   ← Beat 8: loads Level_2.tscn
│
├── Props (Node2D)                    ← Environmental storytelling objects
│   ├── KaitoHeadband (Sprite2D)     ← Beat 6: Kaito's blood-stained sash
│   └── GraveMarkers (Node2D)        ← Beat 0: broken grave markers (3 of them)
│
├── Player (instanced Player.tscn)   ← Drag from FileSystem dock. Blue link icon.
│   └── Camera2D                     ← Child of Player so it follows automatically
│
└── HUD (instanced HUD.tscn)         ← Drag from FileSystem dock. Blue link icon.
```

### Key Architecture Rules

- `Player.tscn` is always instanced, never embedded. Blue link icon required in Scene dock.
- `Camera2D` is a child of `Player` — it follows automatically with no script required.
- `HollowedAsh_2` lives in the `Enemies` container. It is a narrative barrier AND a combat encounter.
- `BambooLurker_1` lives in `Hazards` because it is an environmental threat rooted in place.
- `Props` node is purely visual. No collision, no scripts, no signals. Art only.
- You are the **only person who saves changes to `Level_1.tscn`**. Always `git pull` before opening Godot.

---

## III. Tilemap Setup

### Tile Configuration

**Tile size:** 64×64 px (standard; matches Ren's foot width for readable collision)

Create these 4 tile types in your TileSet. If the Artist hasn't delivered tiles, use Godot's built-in placeholder colors — the level geometry can be painted now and texture-swapped later without changing layout.

| Tile Name | Graybox Color | Physics Layer | Collision Type | Purpose |
|-----------|--------------|---------------|----------------|---------|
| `SolidGround` | `#4A4A5A` (slate grey) | Layer 1 | Full rect | Floors, walls, ceilings |
| `Platform` | `#2A2A3A` (dark) | Layer 1 | One-way (top only) | Ledges Ren can jump up through |
| `Wall` | `#1A1A2A` (near-black) | Layer 1 | Full rect | Horizontal barriers |
| `Bamboo` | `#C8E8D8` (ghostly teal-white) | Layer 1 | Full rect | Grove walls with spirit world color |

**Setting one-way collision on `Platform` tiles:**
1. TileSet editor → select Platform tile → Physics tab
2. Draw collision polygon covering the top half only
3. Enable **One Way** checkbox
4. Set **One Way Margin** to `2.0`

**Collision Layer Assignment:**
- TileMapLayer: Physics Layer `1` (Environment layer)
- All Area2D triggers: Layer `0` (no self-layer), Mask `2` (detects Player layer only)

---

## IV. Beat-by-Beat Level Design

### Level Coordinate System

The level flows **bottom-to-top**. Ren starts at the bottom — literally buried, dead — and must climb upward to escape. This maps directly to the resurrection arc: descending into death, rising back into the world.

In Godot 2D, Y increases downward. Lower Y = higher in the world. Use these approximate Y coordinates as beat anchors (in pixels, with 64px tile size):

```
Y=0        Y=128      Y=768      Y=1280    Y=2240    Y=2880    Y=3840    Y=4480    Y=5504
[EXIT]──[CLIMAX]──[KAITO]──[WISPS]──[CORRIDOR]──[ASH_1]──[CLIMB]──[HANA]──[GRAVE]
 ↑ top                                                                      bottom ↓
```

**Level width:** 640 px (10 tiles × 64 px). Left and right walls (`SolidGround`) bound the entire height. The player cannot escape left or right — the only freedom is vertical.

| Beat | Name             | Y Range       | Approx. Height |
|------|------------------|---------------|----------------|
| 0    | The Grave        | 5504 → 4864   | 640 px (10 tiles) |
| 1    | Hana's Discovery | 4864 → 4480   | 384 px (6 tiles) |
| 2    | First Climb      | 4480 → 3840   | 640 px (10 tiles) |
| 3    | Open Chamber     | 3840 → 2880   | 960 px (15 tiles) |
| 4    | Narrow Shaft     | 2880 → 2240   | 640 px (10 tiles) |
| 5    | Open Grove       | 2240 → 1280   | 960 px (15 tiles) |
| 6    | Kaito's Memory   | 1280 → 768    | 512 px (8 tiles) |
| 7    | Climax Corridor  | 768 → 128     | 640 px (10 tiles) |
| 8    | Exit             | 128 → 0       | 128 px (2 tiles) |

---

### BEAT 0 — The Grave `(Y: 5504–4864, bottom of level)`

**What the player sees:**
Total darkness. The `CanvasModulate` at `#1A0030` makes the ground barely a shade lighter than the sky. No color. No light. Three broken grave markers visible as dark silhouettes. Ren's silhouette stands in mud at the lowest point of the world.

**Tile layout:**
```
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]   ← ceiling (Y: 4864) — 1-tile gap at center (tiles 4–5)
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]   ← air
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]   ← air (grave markers here)
[GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND] ← floor (Y: 5504)
```
10 tiles wide, fully enclosed on left and right. A 2-tile opening in the ceiling (tiles 4–5, center) leads upward into Beat 1.

**Player start position:** `Vector2(320, 5472)` — center of level, standing on the floor.

**Triggers:**
- `DialogueTrigger_Grave` (Area2D): Full-width strip at floor level, 128px tall. Fires 1 second after scene loads via `_ready()` auto-trigger, not on body_entered.

**Props:**
- `GraveMarkers`: 3 × Sprite2D at positions `(128, 5440)`, `(480, 5408)`, `(320, 5376)`. Broken wooden grave markers, tilted at different angles.

**Design intent:** The player feels the weight of nothing. They try to move left — wall. They try to move right — wall. They look up — a faint gap in the ceiling. The only way is up. The vertical ascent is established immediately as the sole direction of escape.

---

### BEAT 1 — Hana's Discovery `(Y: 4864–4480)`

**What the player sees:**
A slightly wider clearing just above the grave pit. At the base of a massive bamboo tree root structure (visible as bamboo tile columns), a single pixel of gold flickers. It's the only color on screen. Ren climbs up through the ceiling gap into this space.

**Tile layout:**
```
[BAMB][    ][    ][    ][    ][    ][    ][    ][    ][BAMB]  ← ceiling (Y: 4480) — open upward
[BAMB][    ][    ][    ][    ][    ][    ][    ][    ][BAMB]  ← air
[BAMB][    ][    ][    ][    ][    ][    ][    ][    ][BAMB]  ← HanaSpawnTrigger mid-level
[BAMB][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][BAMB] ← floor (Y: 4864, connects from Beat 0 gap)
```
Full 10 tiles wide. Left/right bamboo columns create the feel of a root system. The ceiling is open — the path continues upward into Beat 2. The `HanaSpawnTrigger` Area2D sits at mid-height (Y: 4672, center of beat).

**HanaSpawnTrigger setup:**
- Shape: `RectangleShape2D`, size `128×128` px
- Position: center of level, Y: 4672 (X: 320)
- `body_entered` signal → `Level_1._on_hana_spawn(body)`
- One-shot: set a `has_fired` bool to prevent re-triggering

**What happens on trigger:**
1. Hana's `PointLight2D` activates (`Energy: 0 → 1.2` via Tween, 0.5s)
2. GloomMeter appears in HUD (was `visible = false` before this)
3. Beat 1 dialogue fires: *"Ren... I found you. Don't let go of the lantern. Please."*

**Design intent:** The gold light should feel like a physical sensation of relief. The Tween fade-in (not instant pop) makes it feel like Hana coming back to life. The world literally becomes visible as she awakens.

---

### BEAT 2 — The First Climb `(Y: 4480–3840)`

**What the player sees:**
Three staggered ledges ascending vertically through an open shaft. Each ledge alternates left / center / right, forcing Ren to hop across as he climbs. Bamboo stalks flank both sides. Between ledges, Ren is briefly in near-darkness as Hana's lag means she hasn't caught up yet. The Gloom meter may tick up slightly — a soft warning.

**Platform layout (64px tiles, precise positions):**
```
[GRND][    ][    ][    ][    ][    ][    ][GRND]  ← Y: 3840 — opens into Beat 3
[GRND][    ][PLAT][PLAT][PLAT][    ][    ][GRND]  ← Ledge C (Y: 3968, X: 448–640, right-side)
[GRND][    ][    ][    ][    ][    ][    ][GRND]  ← gap
[GRND][    ][    ][PLAT][PLAT][PLAT][    ][GRND]  ← Ledge B (Y: 4160, X: 256–448, center)
[GRND][    ][    ][    ][    ][    ][    ][GRND]  ← gap
[GRND][PLAT][PLAT][PLAT][    ][    ][    ][GRND]  ← Ledge A (Y: 4352, X: 0–192, left-side)
[GRND][    ][    ][    ][    ][    ][    ][GRND]  ← Y: 4480 — floor from Beat 1
```

**Gap design:**
- Gap A→B: 192 px horizontal + 192 px vertical. Ren must jump left-side ledge to center ledge.
- Gap B→C: 192 px horizontal + 192 px vertical. Center to right. Same rhythm, reinforces pattern.
- Gap C→Beat3: right-side ledge connects directly to Beat 3 wide floor at Y: 3840.

**No triggers here.** No dialogue. Let the player focus completely on the platforming.

**Design intent:** Hana's lag is the mechanic, not the enemy. If the player rushes all three ledges without waiting for her, the Gloom meter climbs from 0 to 15–20 before they reach Beat 3. They learn: Hana's light lags. Rushing costs Gloom. Patience is survival.

---

### BEAT 3 — First Enemy: The Hollowed Ash `(Y: 3840–2880)`

**What the player sees:**
A wide, open chamber — the most generous space in the level so far. Room to breathe, room to roll. One Hollowed Ash patrols the central floor, a grey silhouette with two glowing red eye sockets moving slowly back and forth. Hana's gold light fully illuminates the Ash — the player can study it before engaging. The exit upward is a gap at the top of the chamber.

**Tile layout:**
```
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← Y: 2880 — gap leads up to Beat 4
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← air
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← HollowedAsh_1 patrol zone
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← patrol zone
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← DialogueTrigger_FirstEnemy
[GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND] ← floor (Y: 3840, from Beat 2)
```
Full 10 tiles wide (640px). 15 tiles tall. HollowedAsh_1 patrols across the floor.

**HollowedAsh_1 configuration in Inspector:**
```
left_patrol_marker  → AshPatrolLeft_1  (at X: 128, Y: 3776)
right_patrol_marker → AshPatrolRight_1 (at X: 512, Y: 3776)
```
Set these two `Marker2D` nodes as children of the `Enemies` container, NOT inside the Ash scene.

**Combat math for context:**
- Ren's attack deals `15 HP` per hit → Ash dies in **2 hits**
- Ash attacks for `20 HP` per hit → kills Ren in **5 unblocked hits**
- Ren's roll (0.4s iframes) covers the Ash's attack window (0.3s) → perfect timing = zero damage

**DialogueTrigger_FirstEnemy:**
- Shape: `RectangleShape2D`, `512×64px` (full-width horizontal strip)
- Position: Y: 3900, X: 320 — fires as Ren drops into the chamber, before Ash detects him
- Fires before the Ash detects Ren — the monologue plays while Ren watches the patrol from above

**Design intent:** Safe first combat. The space is generous. The enemy is slow and readable. The real danger is if the player drops back down — away from Hana — and the Gloom meter punishes them for it. The lesson: don't retreat from the enemy by abandoning Hana.

---

### BEAT 4 — The Narrow Shaft `(Y: 2880–2240)`

**What the player sees:**
The open chamber above suddenly closes in. Bamboo walls press from both sides, squeezing the passage to just 3 tiles wide (192 px). Ren must climb straight upward through this vertical shaft. Hana's gold light barely reaches both walls. It feels like ascending through a throat. Claustrophobic, inescapable.

**Tile layout:**
```
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← Y: 2240 — opens into Beat 5
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← inner shaft (X: 224–416)
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← BambooLurker_1 here
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← walkable shaft (3 tiles wide)
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← GloomTrigger_Corridor zone
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← DialogueTrigger_Corridor
[BAMB][BAMB][BAMB][    ][    ][    ][BAMB][BAMB][BAMB][BAMB]  ← Y: 2880 — entry from Beat 3
```
10 tiles tall (640px). Inner shaft is tiles 4–6 (X: 224–416). Outer bamboo walls (tiles 1–3 and 7–10) are impassable. `BambooLurker_1` positioned flush against the right inner wall at Y: 2560 (mid-shaft).

**GloomTrigger_Corridor:**
- Shape: `RectangleShape2D`, `192×64px` (shaft width × 1 tile)
- Position: Y: 2700, X: 320 — covers the mid-entry zone of the shaft
- When player body enters: signals `gloom_fill_override(20.0)` — fills at 20/s instead of 10/s (ask Architect to implement)

**BambooLurker_1 configuration:**
- `trigger_radius`: `100.0` (default — verify in Inspector)
- Position: X: 320, Y: 2560 — flush against right inner bamboo wall, mid-shaft
- **Must look identical to regular bamboo in IDLE state.** The Visual Artist makes this possible — coordinate with them.

**DialogueTrigger_Corridor:**
- Shape: `RectangleShape2D`, `192×64px` (full shaft width)
- Position: Y: 2900, X: 320 — at the shaft entrance as Ren climbs in
- Fires: *"Stay close. The Gloom feeds on loneliness — it always has."*

**Design intent:** The Bamboo Lurker is a trust violation. The player has just learned the grove has rules: enemies are clearly visible, space is generous. Then the shaft breaks both rules. The Lurker is invisible; the space is a trap. This beat teaches: in the Whispering Grove, anything can be an enemy.

---

### BEAT 5 — The Open Grove `(Y: 2240–1280)`

**What the player sees:**
Emerging from the narrow shaft into a wide open chamber feels like a breath. Full 10-tile width opens up. A small decorative platform floats at the center height — not required for navigation, just visual relief. Then: two dark orbs, one on each side of the chamber, begin drifting toward Hana's light. They don't threaten Ren. They threaten the light itself.

**Tile layout:**
```
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← Y: 1280 — leads up into Beat 6
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← air
[GRND][    ][    ][PLAT][PLAT][PLAT][PLAT][    ][    ][GRND]  ← decorative platform (Y: 1760)
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← GloomWisp_1 (left) / GloomWisp_2 (right)
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← DialogueTrigger_Wisps
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← Y: 2240 — open from shaft top
```
15 tiles tall (960 px). Full width throughout.
- `GloomWisp_1`: X: 160, Y: 1760 (left side, mid-height)
- `GloomWisp_2`: X: 480, Y: 1760 (right side, mid-height)

**Wisp behavior (no setup required — scripts auto-target Hana):**
- Speed: `30px/s` toward Hana's `global_position`
- On contact with `HanaLightRadius`: radius reduces 20%, Wisp `queue_free()`s
- Both wisps active simultaneously — player must intercept at least one

**The player's options:**
1. Keep climbing, lead Wisps upward, reach Beat 6 before they catch Hana → both survive
2. Stand still: Wisps catch Hana → radius shrinks from 150px → 120px → 96px
3. There is no "attack the wisps" — they are `Area2D`, not `CharacterBody2D`. They cannot be hit.

**DialogueTrigger_Wisps:**
- Shape: `RectangleShape2D`, `512×64px` (full-width strip)
- Position: Y: 2250, X: 320 — fires as Ren exits the shaft into open space
- Text: *"Hana — hold on! Don't let them snuff you out!"*

**Design intent:** The Wisps reframe the threat. For the first time, the danger isn't to Ren — it's to Hana. The player has been thinking "protect myself." Now they must think "protect her." This is the emotional heart of the level. If Hana's light shrinks enough, the Gloom meter climbs faster, and the remaining level becomes harder. The consequence is felt, not instant.

---

### BEAT 6 — Kaito's Memory `(Y: 1280–768)`

**What the player sees:**
A single wide platform spanning the full level width. Completely flat. No enemies. Silence. And resting on the platform ledge: a blood-stained sash — Kaito's headband, the only prop with a color (dark crimson against the grey floor). It's the only red that isn't an enemy's eyes.

**Tile layout:**
```
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← Y: 768 — leads up into Beat 7
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← air
[GRND][    ][    ][    ][    ][    ][    ][    ][    ][GRND]  ← KaitoHeadband at (320, 1216)
[GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND][GRND] ← floor (Y: 1280, from Beat 5)
```
8 tiles tall (512 px). Full width. KaitoMemoryTrigger Area2D covers the headband sprite (X: 320, Y: 1216).

**KaitoMemoryTrigger setup:**
- Shape: `RectangleShape2D`, `192×64px`
- Position: X: 320, Y: 1050 — slightly above the headband, fires as Ren approaches it climbing
- `body_entered` → fires two-part dialogue sequence:
  1. Immediately: *"...Kaito. He died right here. Right on this ground."* (4s)
  2. After 2-second pause: `kaito_echo_triggered` signal fires (Atmosphere Lead's blue flash)
  3. Simultaneously with flash: *"Move, little brother. Grieve later."* — Kaito's voice (4s)

**Level_1.gd implementation:**
```gdscript
var kaito_trigger_fired := false

func _on_kaito_memory_trigger_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player") or kaito_trigger_fired:
        return
    kaito_trigger_fired = true
    $HUD.show_dialogue("...Kaito. He died right here. Right on this ground.")
    await get_tree().create_timer(2.0).timeout
    # Signal fires to Atmosphere Lead's Tween (KaitoEchoLight)
    # HUD shows second line after flash
    $HUD.show_dialogue("Move, little brother. Grieve later.")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()
```

**Design intent:** This beat exists so the player breathes. After the Lurker ambush and the Wisp chase, they've been on edge for 90 seconds. This is the first moment of stillness. The game is telling them: these siblings have a history. This isn't just a survival game. Kaito's voice — stern, cold, loving — establishes him before Level 2 makes him fully active.

---

### BEAT 7 — The Climax Corridor `(Y: 768–128)`

**What the player sees:**
The vertical shaft tightens again — 4 tiles wide (256 px), straight up. The ground darkens to deep violet. A purple fog rises from below. The Gloom meter climbs twice as fast. `HollowedAsh_2` stands mid-shaft, stationary, facing downward. Blocking the only way out — up.

**Tile layout:**
```
[GRND][GRND][    ][    ][    ][    ][GRND][GRND][GRND][GRND]  ← Y: 128 — LevelEnd strip here
[GRND][GRND][    ][    ][    ][    ][GRND][GRND][GRND][GRND]  ← exit gap (tiles 3–6, X: 192–416)
[GRND][GRND][    ][    ][    ][    ][GRND][GRND][GRND][GRND]  ← HollowedAsh_2 (Y: 448)
[GRND][GRND][    ][    ][    ][    ][GRND][GRND][GRND][GRND]  ← 4-tile-wide inner shaft
[GRND][GRND][    ][    ][    ][    ][GRND][GRND][GRND][GRND]  ← GloomClimaxTrigger zone
[GRND][GRND][    ][    ][    ][    ][GRND][GRND][GRND][GRND]  ← Y: 768 — entry from Beat 6
```
10 tiles tall (640 px). Inner passage is tiles 3–6 (X: 192–416). Outer walls are impassable.

**HollowedAsh_2 configuration:**
- Position: X: 320, Y: 448 — center of the shaft, mid-height
- Does NOT use patrol markers — immediately enters CHASE when Ren is within 200px
- Same stats as Ash_1 (HP 30, attack 20)
- Player can either: fight (2 hits, ~2 seconds), or roll through (0.4s iframes bypass the attack window)

**GloomClimaxTrigger (Area2D):**
- Shape: `256×64px` strip (inner shaft width × 1 tile)
- Position: Y: 780, X: 320 — at the shaft entrance as Ren climbs in
- `body_entered` → signals to Architect's script that Gloom should fill at `20/s` (double rate)

**DialogueTrigger Behavior:**
Dialogue fires immediately on GloomClimaxTrigger entry. Unlike all previous lines, this one **does not auto-hide**. It stays on screen for the entire climax sprint:
```gdscript
func _on_gloom_climax_trigger_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        $HUD.show_dialogue("It knows we're here. REN — RUN!")
        # DO NOT call hide_dialogue() — leave it visible until level ends
```

**Design intent:** Everything the level taught is tested here in 20 seconds. Don't run from Hana (but move fast). Roll through enemies (Ash_2 blocks the path). Don't stop (Gloom climbs at 20/s). The shaft's narrowness removes every option except upward. The player has no choice but to climb.

---

### BEAT 8 — The Exit `(Y: 128–0, top of level)`

**What the player sees:**
A small platform at the very top of the world. Flat, wide, safe. The Gloom stops rising the moment Ren reaches the top (GloomTrigger stops filling outside the shaft zone). No enemies. No dialogue. Just a thin horizontal strip at the top edge — and beyond it, sky. A transition.

**LevelEnd configuration:**
- Shape: `RectangleShape2D`, `200×32px` (horizontal strip, top edge of exit platform)
- Position: X: 320, Y: 64 — at the ceiling of the exit area
- `body_entered` signal → `Level_1._on_level_end_body_entered(body)`

```gdscript
func _on_level_end_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")
```

**Design intent:** No fanfare. No victory screen. The level ends in silence, which is itself the reward. After 3–4 minutes of darkness and tension, silence feels like survival. Level 2 begins before the player has time to exhale.

---

## V. Complete HUD Implementation

### HUD.tscn Scene Tree

```
HUD (CanvasLayer)
├── HealthBar (ProgressBar)
├── GloomMeter (ProgressBar)
└── DialogueBox (PanelContainer)
    └── DialogueLabel (Label)
```

### Node Configurations

**CanvasLayer root:** Layer `128` (renders above everything, including particles)

**HealthBar:**
- Anchors: Top-left corner
- Position: `Vector2(16, 16)`, Size: `Vector2(200, 18)`
- Min/Max/Value: `0 / 100 / 100`
- Fill Mode: Left to Right
- Theme Override → StyleBoxFlat (Fill): BG Color `#330000`, Fill Color `#CC2222`
- `visible = true` from scene start

**GloomMeter:**
- Anchors: Top-right
- Position: `Vector2(-216, 16)` (16px from right edge), Size: `Vector2(200, 18)`
- Min/Max/Value: `0 / 100 / 0`
- Fill Mode: Left to Right
- Theme Override → StyleBoxFlat (Fill): BG Color `#0D000D`, Fill Color `#4B0082` (deep purple)
- **`visible = false` at scene start** — becomes visible only after Hana spawns

**DialogueBox:**
- Anchors: Bottom-center
- Position: `Vector2(-300, -100)` from bottom-center anchor
- Size: `Vector2(600, 80)`
- Theme Override → StyleBoxFlat (Panel): BG Color `#000000` at 80% opacity
- **`visible = false` by default**

**DialogueLabel:**
- Layout: Full Rect (fills the PanelContainer)
- Horizontal Alignment: Center, Vertical Alignment: Center
- Autowrap Mode: Word
- Font Color: `#FFFFFF`
- Font Size: `14`

### HUD.gd

```gdscript
extends CanvasLayer

func update_health(new_health: float) -> void:
    $HealthBar.value = new_health

func update_gloom(value: float) -> void:
    $GloomMeter.value = value

func show_gloom_meter() -> void:
    $GloomMeter.visible = true

func show_dialogue(text: String) -> void:
    $DialogueBox/DialogueLabel.text = text
    $DialogueBox.visible = true

func hide_dialogue() -> void:
    $DialogueBox.visible = false
```

---

## VI. Level_1.gd Root Script

Attach this to the `Level_1` root node. This is the only GDScript you write as the World Builder.

```gdscript
extends Node2D

# One-shot guards — prevent dialogue from re-firing
var hana_spawned := false
var kaito_triggered := false
var climax_triggered := false

func _ready() -> void:
    # Auto-fire the opening dialogue 1 second after scene loads
    await get_tree().create_timer(1.0).timeout
    $HUD.show_dialogue("The mud is cold. The bamboo is silent. Something is wrong with the sky.")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_hana_spawn_trigger_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player") or hana_spawned:
        return
    hana_spawned = true
    $HUD.show_gloom_meter()
    $HUD.show_dialogue("Ren... I found you. Don't let go of the lantern. Please.")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_dialogue_trigger_first_enemy_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player"):
        return
    $HUD.show_dialogue("They're still here. The soldiers who killed us. Their grudge won't let them rest.")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_dialogue_trigger_corridor_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player"):
        return
    $HUD.show_dialogue("Stay close. The Gloom feeds on loneliness — it always has.")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_dialogue_trigger_wisps_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player"):
        return
    $HUD.show_dialogue("Hana — hold on! Don't let them snuff you out!")
    await get_tree().create_timer(3.0).timeout
    $HUD.hide_dialogue()

func _on_kaito_memory_trigger_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player") or kaito_triggered:
        return
    kaito_triggered = true
    $HUD.show_dialogue("...Kaito. He died right here. Right on this ground.")
    await get_tree().create_timer(2.0).timeout
    # Atmosphere Lead's KaitoEchoLight Tween fires here via signal
    # (signal already on Player.gd — World Builder doesn't write this)
    $HUD.show_dialogue("Move, little brother. Grieve later.")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_gloom_climax_trigger_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player") or climax_triggered:
        return
    climax_triggered = true
    $HUD.show_dialogue("It knows we're here. REN — RUN!")
    # Do NOT hide — stays visible until scene ends

func _on_level_end_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")

func _on_player_died() -> void:
    get_tree().reload_current_scene()
```

---

## VII. Signal Wiring Master Table

Connect all of these in the **Node tab** of each source node. Right-click the signal → Connect → select receiver → type function name.

| Source Node | Signal | Receiver | Function | One-Shot? |
|------------|--------|----------|----------|-----------|
| `Player` | `health_changed(float)` | `HUD` | `update_health` | No |
| `Hana` (inside Player) | `gloom_changed(float)` | `HUD` | `update_gloom` | No |
| `Player` | `player_died` | `Level_1` | `_on_player_died` | No |
| `Events/HanaSpawnTrigger` | `body_entered` | `Level_1` | `_on_hana_spawn_trigger_body_entered` | Via guard bool |
| `Events/DialogueTrigger_FirstEnemy` | `body_entered` | `Level_1` | `_on_dialogue_trigger_first_enemy_body_entered` | Naturally (enemy already encountered) |
| `Events/DialogueTrigger_Corridor` | `body_entered` | `Level_1` | `_on_dialogue_trigger_corridor_body_entered` | Naturally |
| `Events/DialogueTrigger_Wisps` | `body_entered` | `Level_1` | `_on_dialogue_trigger_wisps_body_entered` | Naturally |
| `Events/KaitoMemoryTrigger` | `body_entered` | `Level_1` | `_on_kaito_memory_trigger_body_entered` | Via guard bool |
| `Events/GloomClimaxTrigger` | `body_entered` | `Level_1` | `_on_gloom_climax_trigger_body_entered` | Via guard bool |
| `Events/LevelEnd` | `body_entered` | `Level_1` | `_on_level_end_body_entered` | Naturally |

**Verifying connections:** Select each source node → Node tab. Connected signals appear with a green icon. A broken connection (red icon) means the receiver node path changed or the function name has a typo.

---

## VIII. Area2D Trigger Sizing & Position Reference

All triggers need a `CollisionShape2D` child with these dimensions. Positions are in world space (X, Y).

| Trigger | Shape | Width × Height | Position (X, Y) | Notes |
|---------|-------|----------------|-----------------|-------|
| `HanaSpawnTrigger` | Rectangle | `128 × 128` | (320, 4672) | Mid-height of Beat 1, fires on climb |
| `GloomTrigger_Corridor` | Rectangle | `192 × 64` | (320, 2700) | Shaft mid-zone; fills Gloom at 20/s |
| `GloomClimaxTrigger` | Rectangle | `256 × 64` | (320, 780) | Shaft entry; fills Gloom at 20/s |
| `DialogueTrigger_Grave` | Rectangle | `640 × 64` | (320, 5472) | Full width of grave floor (auto-fires in _ready anyway) |
| `DialogueTrigger_FirstEnemy` | Rectangle | `512 × 64` | (320, 3900) | Drop-in strip at Beat 3 chamber entry |
| `DialogueTrigger_Corridor` | Rectangle | `192 × 64` | (320, 2900) | Full shaft width at shaft entry |
| `DialogueTrigger_Wisps` | Rectangle | `512 × 64` | (320, 2250) | Full-width strip at Beat 5 open grove entry |
| `KaitoMemoryTrigger` | Rectangle | `192 × 64` | (320, 1050) | Above headband prop, fires on approach |
| `LevelEnd` | Rectangle | `200 × 32` | (320, 64) | Thin horizontal strip at top of exit area |

**All triggers:** Collision Layer `0` (no self-layer), Mask `2` (player layer). No physics bodies — detection only.

---

## IX. Execution Roadmap

### Phase A — Scene Skeleton `(~30 min)`
**Goal:** A scene that opens, is dark, and Ren can move.

1. Create `Level_1.tscn` — root Node2D named `Level_1`
2. Add `CanvasModulate` → set Color `#1A0030`
3. Add container nodes: `Hazards`, `Enemies`, `Events`, `Props`
4. Drag `Player.tscn` from FileSystem dock → verify blue link icon in Scene dock
5. Set Player start position to `Vector2(320, 5472)` (bottom center of level)
6. Drag `HUD.tscn` from FileSystem dock → verify blue link icon
7. Add a `Camera2D` as a child of `Player` (it will follow automatically):
   - `limit_top = 0`
   - `limit_bottom = 5600`
   - `drag_horizontal_enabled = false`
   - `drag_vertical_enabled = true`
   - `process_callback = IDLE`
8. Add a temporary flat `TileMapLayer` with a `SolidGround` floor at Y=5504 so Ren has ground to stand on
9. Set `project.godot` main scene to `Level_1.tscn` (Project Settings → Application → Run)
10. Press F5. Verify: total darkness, Ren silhouette visible at screen bottom, camera scrolls upward as he jumps

**Gate check:** Screen is dark. Player spawns at bottom. Camera follows upward. HUD is visible. No console errors.

---

### Phase B — Tilemap & Enemy Placement `(~2 hours)`
**Goal:** The golden path is climbable. All 4 enemies are in place.

1. Create placeholder tileset (if Artist hasn't delivered): 64×64 white square PNG, one atlas
2. Paint all 8 beats following the tile layouts above — remember: level flows **bottom-to-top**
3. Verify left and right boundary walls span the full height of the level
4. Verify one-way collision on Platform tiles (jump up through, land on top)
5. Drag `HollowedAsh.tscn` → place as `HollowedAsh_1` in `Enemies` node at Beat 3 floor (X:320, Y:3776)
6. Add `Marker2D` nodes `AshPatrolLeft_1` (X:128, Y:3776) and `AshPatrolRight_1` (X:512, Y:3776) → assign in Inspector
7. Drag `BambooLurker.tscn` → place in `Hazards` node at Beat 4 shaft mid-height (X:320, Y:2560)
8. Drag `GloomWisp.tscn` twice → `GloomWisp_1` at (160, 1760), `GloomWisp_2` at (480, 1760)
9. Drag `HollowedAsh.tscn` → place as `HollowedAsh_2` in `Enemies` node at Beat 7 (X:320, Y:448)
10. Climb the level: can you reach `LevelEnd` at the top in under 4 minutes?

**Gate check:** All enemies present and behaving. Level is climbable from bottom to top.

---

### Phase C — Events, Dialogue & Signal Wiring `(~1.5 hours)`
**Goal:** Signals fire. Story beats play. HUD reacts.

1. Add `Area2D` nodes to the `Events` container with shapes from the sizing table
2. Attach `Level_1.gd` to the Level_1 root node
3. Connect all signals from the Signal Wiring Master Table
4. Verify: walk into `HanaSpawnTrigger` → GloomMeter appears
5. Verify: take enemy damage → HealthBar decreases
6. Verify: leave Hana's light → GloomMeter fills
7. Verify: dialogue text appears at each trigger, disappears after correct delay
8. Verify: reaching `LevelEnd` transitions scene (even to a placeholder Level_2 scene)
9. Verify: Gloom at 100% triggers scene reload

**Gate check:** All 7 dialogue lines fire. Both HUD bars react. Level transition works. Death reloads.

---

### Phase D — Polish, Pacing & Atmosphere `(~1 hour)`
**Goal:** The full experience. Emotional arc lands.

1. Replace placeholder tiles with Visual Artist's final tileset
2. Add `KaitoHeadband` and `GraveMarkers` Sprite2Ds to `Props` node
3. Tune enemy positions for pacing — Ash_1 patrol zone may need narrowing if the level is too long
4. Tune corridor width — the BambooLurker corridor should feel claustrophobic, not impossible
5. Full playthrough timer: complete the level, note duration. If > 4 minutes, the tilemap is too long.
6. Emotional check: pause at Beat 6. Does the silence feel earned after the Wisp chase?
7. Run all items from the Level 1 Complete Checklist (from `Level_1_Progression.md`)

**Gate check:** Full Level 1 Complete Checklist green. Level completable in 3–4 minutes. No console errors.

---

## X. Validation & Playtesting Guide

### Phase A Tests
- [ ] Run scene. Is screen completely dark (near-total black)?
- [ ] Can Ren move left and right?
- [ ] Does HUD appear at top of screen (HealthBar left, GloomMeter right)?
- [ ] No console errors (check Output tab in Godot)

### Phase B Tests
- [ ] Does Ren spawn at the bottom of the level (Y ≈ 5472)?
- [ ] Does the camera scroll upward as Ren climbs?
- [ ] Can Ren jump up through the grave ceiling gap into Beat 1?
- [ ] Can Ren hop between the staggered Beat 2 platforms (L→C→R) without falling to bottom?
- [ ] Does `HollowedAsh_1` patrol back and forth at Beat 3 floor level?
- [ ] Does `HollowedAsh_1` chase Ren when within 200px?
- [ ] Does `BambooLurker_1` snap forward when Ren enters 100px range in the shaft?
- [ ] Do both `GloomWisp_1` and `GloomWisp_2` move toward Hana's position?
- [ ] Does `HollowedAsh_2` immediately chase (no patrol)?
- [ ] Can the level be climbed top-to-bottom in **under 4 minutes**?

### Phase C Tests
- [ ] Enter `HanaSpawnTrigger` area → does `GloomMeter` become visible?
- [ ] Move Ren 200px from Hana → does GloomMeter fill?
- [ ] Return Ren to Hana → does GloomMeter drain?
- [ ] Take hit from Ash → does HealthBar decrease?
- [ ] Health hits 0 → does scene reload?
- [ ] Each of the 7 dialogue lines fires with correct text at correct location?
- [ ] Kaito's second dialogue fires 2 seconds after the first?
- [ ] Climax dialogue stays visible and does NOT auto-hide?
- [ ] Reaching `LevelEnd` → scene changes?

### Phase D — Story Beat Verification
Run the level as if you've never played it. Ask:
- [ ] Beat 0: Did the darkness make you feel lost?
- [ ] Beat 1: Did Hana's light feel like relief?
- [ ] Beat 2: Did you notice the Gloom meter tick up during jumps?
- [ ] Beat 3: Did you understand the Ash before it attacked you?
- [ ] Beat 4: Did the Lurker surprise you?
- [ ] Beat 5: Did you feel responsible for protecting Hana?
- [ ] Beat 6: Did you pause at the headband?
- [ ] Beat 7: Were you stressed during the Gloom climb?
- [ ] Beat 8: Did you exhale when it ended?

---

## XI. Common Mistakes & Fixes

| Mistake | Symptom | Fix |
|---------|---------|-----|
| Two people editing `Level_1.tscn` | Git merge conflict on `.tscn` file | Only the World Builder edits Level_1.tscn. Always `git pull` first. |
| Player embedded instead of instanced | No blue link icon; Architect's changes to Player.tscn don't appear | Delete and re-drag Player.tscn from FileSystem dock |
| Dialogue fires infinitely on repeated entry | Dialogue box keeps reopening | Add `has_triggered` bool guards (already in Level_1.gd above) |
| LevelEnd fires for enemies too | Scene changes when Ash walks near the exit | Always check `if body.is_in_group("player")` before `change_scene_to_file` |
| GloomMeter doesn't fill | Gloom visible but shows 0 | Verify `gloom_changed` signal is connected to `HUD.update_gloom` |
| HUD renders behind tiles | HUD bars appear but are occluded | HUD root must be `CanvasLayer`, not `Control` or `Node2D` |
| Ash doesn't patrol | Enemy just stands still | Check `left_patrol_marker` and `right_patrol_marker` are assigned in Inspector |
| BambooLurker detects Ren too early | Lurker springs before player reaches mid-corridor | Reduce `trigger_radius` in Inspector (default 100; try 80) |
| Corridor Gloom trigger fires in open areas | Gloom fills in wrong sections | Verify `GloomTrigger_Corridor` CollisionShape only covers the corridor ceiling zone |
| Wisp moves toward Ren instead of Hana | Wisp runs past Hana to chase Ren | This is a script issue, not a World Builder issue — report to Architect |
| Area2D triggers don't detect player | `body_entered` never fires | Check Collision Mask includes Layer 2 (Player's physics layer) |

---

## XII. What NOT to Do

These are Level 2+ features. Do not implement them now:

- ❌ `ShadowGate` or any soul-collection mechanic
- ❌ Boss fights (`TheCapitan.tscn` is not a Level 1 asset)
- ❌ `CrimsonArcher` or `PhasedAshigaru` instances (Level 2+ enemy types)
- ❌ More than 4 enemy instances (HollowedAsh_1, BambooLurker_1, GloomWisp_1, GloomWisp_2 + HollowedAsh_2)
- ❌ Attack input teaching (Ren's combat combo is not introduced until Level 2)
- ❌ Save/checkpoint system
- ❌ Camera zones, cutscene cameras, or region-triggered camera transitions (a simple follow Camera2D on the Player IS required and allowed)
- ❌ Editing any `.gd` scripts (Player, Hana, HollowedAsh, BambooLurker, GloomWisp)
- ❌ Letting the level take more than 4 minutes to complete
- ❌ Adding background music (Level 1 is silence only — ambient SFX only per design)

---

## XIII. Files You'll Create / Edit

| File | Action | Who Else Touches It |
|------|--------|---------------------|
| `Scenes/Level_1.tscn` | **Create.** You own this file. | Nobody else — coordinate before opening |
| `Scenes/UI/HUD.tscn` | **Create** (if missing) | Architect may add UI features later |
| `Scripts/HUD.gd` | **Extend** — add dialogue functions | Architect owns base; you add `show_dialogue()`, `hide_dialogue()` |
| `Scripts/Level_1.gd` | **Create** — root script for this level | Nobody else |
| `Assets/Tiles/` | **Receive** from Visual Artist | Visual Artist delivers tileset; you import and apply |
| All other `.gd` scripts | **Read-only** — never edit | Architect only |

---

## XIV. The North Star

When in doubt about any design decision, return to the core question:

> *"Will you stay with her, or leave her behind?"*

Every tile placed, every trigger positioned, every enemy spawned should make the answer to that question feel meaningful. The mechanics say: you need her light to survive. The level design says: she needs you to move forward. That mutual dependency — fragile, gold, always lagging just a half-second behind — is the entire game.

Build the world that makes that question impossible to ignore.
