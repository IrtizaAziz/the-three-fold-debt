# World-Builder — Level 1 Implementation Guide
### The Three-Fold Debt | Godot 4.x

> **Your role:** You are the final assembler. The Architect has finished all the scripts. The Artist is producing sprites. Your job is to build the physical world, place the characters inside it, wire all the signals together, and make the HUD respond to the game state — without writing any GDScript.
>
> **Golden rule:** You are the **only** person allowed to save changes to `Level_1.tscn`. Never let two people edit the master scene simultaneously — it causes Git conflicts that destroy work.

---

## 🏗️ Part 0 — Before You Start

### What the Architect Has Given You
The following scripts are complete and tested:

| Script | Node Type | Key Signals It Emits |
|--------|-----------|----------------------|
| `Player.gd` | `CharacterBody2D` | `health_changed(float)`, `player_died`, `kaito_echo_triggered` |
| `Hana.gd` | `Node2D` (child of Player) | `gloom_changed(float)` |
| `HollowedAsh.gd` | `CharacterBody2D` | `soul_released` |
| `BambooLurker.gd` | `Node2D` | `soul_released` |
| `GloomWisp.gd` | `Area2D` | *(no signal — dissolves on contact)* |

Your HUD must **listen** to these signals. You never edit the scripts — you connect them in the editor.

### File Ownership Rules
| File | Who Edits It |
|------|-------------|
| `Level_1.tscn` | **You only** |
| `HUD.tscn` | **You only** |
| `Player.tscn` | Architect (logic) + Artist (sprites) |
| `HollowedAsh.tscn` | Architect + Artist |
| `*.gd` scripts | **Architect only** — never open these |

### Pull Before Every Session
Always run `git pull` before opening Godot so you have the latest `.tscn` files from the Architect and Artist.

---

## 📁 Part 1 — Building the Scene Tree (`Level_1.tscn`)

### Step 1: Create the Scene
1. In the **FileSystem** dock, right-click the root folder → **New Scene**.
2. Choose root node type: **Node2D**. Rename it `Level_1`.
3. Save immediately: **Ctrl+S** → name it `Level_1.tscn` in the `Scenes/` folder.

### Step 2: Build the Exact Node Hierarchy
Add child nodes in this exact order. The Architect's scripts look for specific node names — do not rename them.

```
Level_1 (Node2D)          ← Root — your scene
├── CanvasModulate         ← Global darkness layer
├── TileMapLayer           ← All terrain and platforms
├── Hazards (Node2D)       ← Container for environmental dangers
│   ├── GloomTrigger_1 (Area2D)
│   ├── GloomTrigger_2 (Area2D)
│   └── BambooLurkerSpawn (Marker2D)
├── Enemies (Node2D)       ← Container for all enemy instances
│   ├── HollowedAsh_1     ← Instanced HollowedAsh.tscn
│   ├── HollowedAsh_2     ← Instanced HollowedAsh.tscn
│   └── GloomWisp_1       ← Instanced GloomWisp.tscn
├── Events (Node2D)        ← Invisible triggers that drive the story
│   ├── HanaSpawnTrigger (Area2D)
│   ├── DialogueTrigger_1 (Area2D)
│   ├── DialogueTrigger_2 (Area2D)
│   ├── DialogueTrigger_3 (Area2D)
│   ├── KaitoMemoryTrigger (Area2D)
│   └── LevelEnd (Area2D)
├── Player (instanced Player.tscn)
└── HUD (instanced HUD.tscn)
```

**How to add each node type:**
- **CanvasModulate:** Right-click `Level_1` → Add Child Node → search `CanvasModulate`
- **Node2D containers:** Add Child → `Node2D`, then rename in the Inspector
- **Area2D triggers:** Add Child → `Area2D`, then add a `CollisionShape2D` child with a `RectangleShape2D`
- **Instanced scenes:** Drag the `.tscn` file from the FileSystem dock directly onto the scene tree

### Step 3: Configure CanvasModulate
Select the `CanvasModulate` node. In the Inspector:
- **Color:** `#1A0030` (deep oppressive purple-black)

This plunges the entire level into darkness. The Atmosphere Lead's `PointLight2D` on Hana becomes the only light source. Do this before any gameplay testing.

---

## 🗺️ Part 2 — Building the Tilemap

### Setting Up TileMapLayer
1. Select the `TileMapLayer` node.
2. In the Inspector → **Tile Set** → click `[empty]` → **New TileSet**.
3. Open the TileSet editor at the bottom. Add a new atlas source by clicking **+**.
4. Drag in your tile texture atlas from `/Assets/Tiles/`.

> **If the Artist hasn't delivered tiles yet:** Use Godot's built-in solid colors as placeholder tiles. Right-click the TileSet → Add Atlas → create a single 64×64 white square PNG as a placeholder. Paint the level now; the Artist can swap the texture later without changing the tile layout.

### The 4 Tile Types You Need
Create and name these tile types inside the TileSet:

| Tile Name | Placeholder Color | Physics | Purpose |
|-----------|------------------|---------|---------|
| `SolidGround` | Grey `#555555` | Full collision | Main walkable floor |
| `Platform` | Dark grey `#333333` | One-way collision | Floating ledges for jumps |
| `Wall` | Dark grey `#222222` | Full collision | Horizontal blockers |
| `HazardZone` | Red `#AA0000` | No collision (visual only) | Marks Gloom pit zones |

**Setting one-way collision on Platform tiles:**
1. In TileSet editor, select the Platform tile.
2. Click the **Physics** tab in the tile properties.
3. Add a polygon covering the tile.
4. Check **One Way** — Ren can jump up through it but lands on top.

### The Golden Path Layout
Build the level as a **left-to-right then upward** route. Target: completable in 3 minutes at walking pace.

```
[START]──flat clearing──[BEAT 1: Hana spawn]──3 ascending ledges──
──[BEAT 2: first enemy]──[BEAT 3: narrow corridor + BambooLurker]──
──[BEAT 4: open zone + 2 Wisps]──[BEAT 5: Kaito headband]──
──[CLIMAX: rising Gloom corridor]──[LEVEL END gate]
```

**Beat-by-beat design specs:**

| Beat | Platform Layout | Enemy Placement | Notes |
|------|----------------|-----------------|-------|
| **Start** | Flat ground, ~10 tiles wide | None | Enclosed; Ren wakes here |
| **Beat 1** | Gentle ramp or 2 low steps | None | Place `HanaSpawnTrigger` Area2D at the base of the first tree |
| **Beat 2** | 3 ascending ledges, each slightly wider than Ren's jump range | None | Gap must require Hana to be nearby (Gloom fills if Ren rushes alone) |
| **Beat 3** | Wide open flat section, ~20 tiles | `HollowedAsh_1` patrolling | Give Ren 3-4 tiles of roll space |
| **Beat 4** | Narrow corridor, 3-4 tiles wide, 12 tiles long | `BambooLurker_1` mid-corridor | Place a `GloomTrigger` Area2D covering the corridor ceiling |
| **Beat 5** | Open section, ~15 tiles wide | `GloomWisp_1` + `GloomWisp_2` | Wide enough to dodge; Wisps start on opposite sides |
| **Memory** | Single flat platform, no enemies | None | Place `KaitoMemoryTrigger` here |
| **Climax** | Narrow upward-sloping corridor | `HollowedAsh_2` blocking the exit | Place `GloomTrigger` at the bottom — fills if Ren lingers |
| **End** | Small landing platform | None | Place `LevelEnd` Area2D here |

---

## 👾 Part 3 — Placing and Configuring Enemies

### Instancing an Enemy Scene
1. In the FileSystem dock, find `HollowedAsh.tscn`.
2. Drag it into the Scene dock, onto the `Enemies` node. It becomes `HollowedAsh_1`.
3. Repeat for a second instance: `HollowedAsh_2`.
4. Position each in the 2D viewport by dragging them to the correct beat location.

### Configuring Hollowed Ash Patrol Markers
The Architect's script reads two `Marker2D` nodes to set the patrol range. You must set these up per-enemy:

**For each HollowedAsh instance:**
1. Add two `Marker2D` nodes as children (inside the `Enemies` container, NOT inside the ash itself).
2. Name them descriptively: `AshPatrolLeft_1` and `AshPatrolRight_1`.
3. Position `AshPatrolLeft_1` at the left edge of the patrol zone.
4. Position `AshPatrolRight_1` at the right edge of the patrol zone.
5. Select `HollowedAsh_1` in the Scene dock.
6. In the Inspector, find **`left_patrol_marker`** (exported variable from the script).
7. Click the field → drag `AshPatrolLeft_1` from the Scene dock into it.
8. Repeat for **`right_patrol_marker`** → `AshPatrolRight_1`.

> If you skip this step, the Ash will still work — it defaults to patrolling ±100px from its starting position.

### Placing Gloom Wisps
1. Drag `GloomWisp.tscn` onto the `Enemies` node twice.
2. Position them at opposite ends of Beat 5 (the open section).
3. No configuration needed — the script auto-seeks Hana.

### Placing the Bamboo Lurker
1. Drag `BambooLurker.tscn` onto the `Hazards` node (not Enemies — it's a hazard).
2. Position it mid-corridor in Beat 4. It must be flush with a wall so it looks like real bamboo.
3. In the Inspector, confirm **`trigger_radius`** is set to `100.0` (default). Adjust if the corridor is narrower.

---

## 🖥️ Part 4 — Building the HUD (`HUD.tscn`)

### Create the HUD Scene
1. **FileSystem** → New Scene → root node: **CanvasLayer**. Name it `HUD`. Save as `HUD.tscn`.
2. A `CanvasLayer` always renders above all world elements — the HUD will never be hidden behind tiles.

### HUD Node Tree
Build this exact hierarchy inside `HUD`:

```
HUD (CanvasLayer)
├── HealthBar (ProgressBar)
├── GloomMeter (ProgressBar)
└── DialogueBox (PanelContainer)
    └── DialogueLabel (Label)
```

### Configuring HealthBar
1. Select `HealthBar`.
2. **Inspector → Layout → Anchors:** Top-left corner. Set **Position** to `Vector2(16, 16)`.
3. Set **Size:** `Vector2(200, 20)`.
4. **Min Value:** `0` | **Max Value:** `100` | **Value:** `100`.
5. **Theme Overrides → Styles → Fill:** Add a `StyleBoxFlat`. Set **BG Color** to `#440000` (dark red). Set **Fill Color** to `#CC0000` (bright red).

### Configuring GloomMeter
1. Select `GloomMeter`.
2. **Layout → Anchors:** Top-right. Set **Position** to `Vector2(-216, 16)` (16px from right edge).
3. **Size:** `Vector2(200, 20)`.
4. **Min Value:** `0` | **Max Value:** `100` | **Value:** `0`.
5. **Theme Overrides → Fill:** `StyleBoxFlat` — BG Color `#000000`, Fill Color `#4B0082` (deep purple).
6. **Fill Mode:** Left to Right.

### Configuring DialogueBox
1. Select `DialogueBox`.
2. **Layout → Anchors:** Bottom-center. Set **Position** to `Vector2(-300, -100)` (centered, near bottom).
3. **Size:** `Vector2(600, 80)`.
4. **Theme Overrides → Styles → Panel:** `StyleBoxFlat` — BG Color `#000000` at 75% opacity.
5. **Visible:** `false` (hidden by default — it only appears when a trigger fires).

### Configuring DialogueLabel
1. Select `DialogueLabel` (child of `DialogueBox`).
2. **Text:** *(leave blank — will be set by script)*.
3. **Layout → Anchors:** Full rect (fills the PanelContainer).
4. **Theme Overrides → Font Color:** `#FFFFFF`.
5. **Horizontal Alignment:** Center. **Vertical Alignment:** Center.
6. **Autowrap Mode:** Word (so long lines wrap).

### Adding the HUD Script
The HUD needs a small script to respond to signals. Ask the Architect to write this, or create `HUD.gd` yourself:

```gdscript
extends CanvasLayer

func update_health(new_health: float):
    $HealthBar.value = new_health

func update_gloom(value: float):
    $GloomMeter.value = value

func show_dialogue(text: String):
    $DialogueBox/DialogueLabel.text = text
    $DialogueBox.visible = true

func hide_dialogue():
    $DialogueBox.visible = false
```

Attach this script to the `HUD` root node.

---

## 🔌 Part 5 — Wiring All the Signals

This is the most important step. All inter-scene communication uses Godot signals — never hardcoded references.

### How to Connect a Signal in the Editor
1. Select the **source node** (the one that emits the signal).
2. Open the **Node** tab (next to Inspector tab).
3. Find the signal name in the list. Double-click it.
4. In the "Connect Signal" window, select the **receiver node** (the one that should react).
5. Choose or type the function name to call.
6. Click **Connect**.

### Signal Wiring Table — Do All of These

| Signal Source | Signal Name | Receiver | Function to Call | Notes |
|--------------|-------------|----------|-----------------|-------|
| `Player` | `health_changed(float)` | `HUD` | `update_health` | HealthBar updates on damage/heal |
| `Hana` (inside Player) | `gloom_changed(float)` | `HUD` | `update_gloom` | GloomMeter fills when Ren leaves light |
| `Player` | `player_died` | `Level_1` (root) | `_on_player_died` | Show game over / reload scene |

**For `player_died`**, add a one-liner to `Level_1.tscn`'s root script (ask Architect, or add a script yourself):
```gdscript
extends Node2D
func _on_player_died():
    get_tree().reload_current_scene()
```

### Wiring Dialogue Triggers
Each `DialogueTrigger_X` Area2D needs its own connection:

1. Select `DialogueTrigger_1` in the Scene dock.
2. In the **Node** tab → `body_entered` signal → double-click.
3. Receiver: select `HUD`. Function: type `_on_dialogue_trigger_1_body_entered`.
4. In `HUD.gd`, add the function:
```gdscript
func _on_dialogue_trigger_1_body_entered(body):
    if body.is_in_group("player"):
        show_dialogue("The mud is cold. The bamboo is silent. Something is wrong with the sky.")
        await get_tree().create_timer(4.0).timeout
        hide_dialogue()
```

Repeat this pattern for each of the 8 dialogue trigger points from the Atmosphere Lead's script:

| Trigger Node | Dialogue Text |
|-------------|--------------|
| `HanaSpawnTrigger` | *"Ren... I found you. Don't let go of the lantern. Please."* — **Hana** |
| `DialogueTrigger_1` | *"The mud is cold. The bamboo is silent. Something is wrong with the sky."* — [Environmental] |
| `DialogueTrigger_2` | *"They're still here. The soldiers who killed us. Their grudge won't let them rest."* — **Ren** |
| `DialogueTrigger_3` | *"Stay close. The Gloom feeds on loneliness — it always has."* — **Hana** |
| `DialogueTrigger_4` | *"Hana — hold on! Don't let them snuff you out!"* — **Ren** |
| `KaitoMemoryTrigger` | *"...Kaito. He died right here. Right on this ground."* then *"Move, little brother. Grieve later."* — **Kaito** |
| `GloomClimaxTrigger` | *"It knows we're here. REN — RUN!"* — **Hana** |

### Wiring LevelEnd
1. Select `LevelEnd` Area2D.
2. Add a `CollisionShape2D` child with a `RectangleShape2D` spanning the exit gate.
3. Connect `body_entered` signal. Receiver: `Level_1` root. Function: `_on_level_end_body_entered`.
4. Add to your root script:
```gdscript
func _on_level_end_body_entered(body):
    if body.is_in_group("player"):
        get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")
```

---

## 📐 Part 6 — Positioning All Trigger Area2Ds

Every `Area2D` trigger needs a `CollisionShape2D` child. Here are the recommended sizes:

| Trigger | Shape | Size | Notes |
|---------|-------|------|-------|
| `HanaSpawnTrigger` | RectangleShape2D | 64 × 128 px | Spans the tree roots at Beat 1 |
| `DialogueTrigger_1` | RectangleShape2D | 128 × 128 px | First thing Ren walks into at the start |
| `DialogueTrigger_2` | RectangleShape2D | 96 × 128 px | Just before Beat 3 (first enemy) |
| `DialogueTrigger_3` | RectangleShape2D | Width of corridor × 96 px | Entrance to Beat 4 corridor |
| `DialogueTrigger_4` | RectangleShape2D | 128 × 128 px | Near the Gloom Wisps in Beat 5 |
| `KaitoMemoryTrigger` | RectangleShape2D | 64 × 128 px | Over the Kaito headband prop |
| `GloomClimaxTrigger` | RectangleShape2D | Full corridor width × 64 px | Start of the upward climax corridor |
| `LevelEnd` | RectangleShape2D | 32 × 200 px | Vertical strip at the right edge of the final platform |
| `GloomTrigger_1` | RectangleShape2D | Width of pit | Over each bottomless pit / dark zone |

> **Collision Layer/Mask:** Set all trigger Area2Ds to detect **Layer 1** (player). Go to Inspector → CollisionObject2D → Collision. Set Layer to `0` (no layer), Mask to `1` (player layer).

---

## ✅ Part 7 — Final World-Builder Checklist

Run `Level_1.tscn` from start to end. Verify:

### Scene Architecture
- [ ] Scene tree matches the exact hierarchy from Part 1
- [ ] `CanvasModulate` color is `#1A0030` — screen is dark without Hana's light
- [ ] `Player.tscn` is instanced (not embedded) — the Scene dock shows a blue link icon

### Tilemap
- [ ] Level is walkable from Start to LevelEnd at a 3-minute walking pace
- [ ] All platforms have one-way collision (Ren can jump up through them)
- [ ] No tile gaps where Ren can clip through the floor
- [ ] `GloomTrigger` Area2Ds cover all bottomless pits

### Enemies
- [ ] `HollowedAsh_1` patrols its zone left/right
- [ ] `HollowedAsh_2` patrols near the climax exit
- [ ] Both Ash enemies have patrol markers correctly assigned in the Inspector
- [ ] `GloomWisp_1` and `GloomWisp_2` move toward Hana's lantern
- [ ] `BambooLurker_1` is positioned flush against a bamboo wall

### HUD
- [ ] HealthBar visible in the top-left, starts full (100/100)
- [ ] GloomMeter visible in the top-right, starts empty (0/100)
- [ ] HealthBar decreases when Ren takes damage from an enemy
- [ ] GloomMeter fills when Ren walks away from Hana's light
- [ ] GloomMeter drains back when Ren returns to Hana's light
- [ ] DialogueBox is hidden by default
- [ ] DialogueBox appears (with correct text) when Ren enters trigger zones

### Signals
- [ ] `health_changed` → HealthBar updates
- [ ] `gloom_changed` → GloomMeter updates
- [ ] `player_died` → scene reloads
- [ ] All 7 dialogue triggers fire with correct text
- [ ] `LevelEnd` loads Level 2 when Ren reaches the exit gate

---

## 🚨 Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Two people editing `Level_1.tscn` simultaneously | Always `git pull` first; announce in Discord when you're opening the master scene |
| Signal connected to wrong function name | Open Node tab, check signal connections list — red means broken |
| Patrol markers not assigned | Select each Ash instance → Inspector → set `left_patrol_marker` and `right_patrol_marker` NodePaths |
| Dialogue fires infinitely (loops) | Add `queue_free()` or a `has_triggered` bool to the trigger — or use `body_entered` + disconnect after first fire |
| LevelEnd fires for enemies too | Always check `if body.is_in_group("player")` before changing scene |
| HUD renders behind tiles | Ensure HUD root is `CanvasLayer` — a plain `Control` node can be occluded by world geometry |
| GloomTrigger Area2D not detecting player | Check Collision Mask includes Layer 1 (player's physics layer) |
