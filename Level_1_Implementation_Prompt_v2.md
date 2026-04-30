# Level 1 Implementation Plan v2 — Diagonal Progression
## Executable by Claude via Godot MCP

**Core design:** The level flows **bottom-left to top-right** (diagonal ascent). Ren starts at the bottom-left corner
(Y: 5504, X: 32) and climbs upward while drifting rightward to the top-right exit (Y: 0, X: 620). In Godot 2D, Y increases downward —
so lower Y values are higher in the world. X increases left-to-right. All coordinates below reflect this diagonal path.

**Diagonal formula:** `X = 640 × ((5504 - Y) / 5504)`

**Level width:** 640 px (X: 0–640). Left/right walls bound the full height. The diagonal path creates natural progression.

---

## Phase A: Scene Tree & Baseline Setup

### Task A1: Create Level_1.tscn *(if not already done)*
1. `scene_manage(op="create", path="res://Scenes/Level_1.tscn", root_type="Node2D", root_name="Level_1")`
2. `node_create(parent_path="/Level_1", type="CanvasModulate", name="CanvasModulate")`
3. `node_set_property(path="/Level_1/CanvasModulate", property="color", value={"r":0.1,"g":0.0,"b":0.19,"a":1.0})`
4. `node_create(parent_path="/Level_1", type="TileMapLayer", name="TileMapLayer")`
5. `node_create(parent_path="/Level_1", type="Node2D", name="Hazards")`
6. `node_create(parent_path="/Level_1", type="Node2D", name="Enemies")`
7. `node_create(parent_path="/Level_1", type="Node2D", name="Events")`
8. `node_create(parent_path="/Level_1", type="Node2D", name="Props")`
9. Instance Player: `node_create(parent_path="/Level_1", scene_path="res://Scenes/Characters/Player.tscn", name="Player")`
10. Set Player spawn at bottom-left: `node_set_property(path="/Level_1/Player", property="position", value={"x":32,"y":5472})`
11. Instance HUD: `node_create(parent_path="/Level_1", scene_path="res://Scenes/UI/HUD.tscn", name="HUD")`
12. `scene_save()`

### Task A2: Add Camera2D (follow-camera for vertical scroll)
1. `node_create(parent_path="/Level_1/Player", type="Camera2D", name="Camera2D")`
2. `node_set_property(path="/Level_1/Player/Camera2D", property="limit_top", value=0)`
3. `node_set_property(path="/Level_1/Player/Camera2D", property="limit_bottom", value=5600)`
4. `node_set_property(path="/Level_1/Player/Camera2D", property="drag_horizontal_enabled", value=false)`
5. `node_set_property(path="/Level_1/Player/Camera2D", property="drag_vertical_enabled", value=true)`
6. `scene_save()`

### Task A3: Attach Level_1.gd *(if not already done)*
Script is at `res://Scripts/Level_1.gd`. Attach to Level_1 root:
`script_attach(path="/Level_1", script_path="res://Scripts/Level_1.gd")`

---

## Phase B: Tilemap Creation

### Task B1: Create Placeholder Tileset *(Manual — Godot editor)*
1. Create a 64×64 white PNG at `res://Assets/Tilesets/placeholder.png`
2. Import as TileSet in Godot editor
3. Assign to TileMapLayer in Level_1.tscn

### Task B2: Paint Tilemap Layout *(Manual — Godot TileMap editor)*

**Orientation: vertical. Player starts at bottom (high Y), exits at top (low Y).**
Level width is always 10 tiles (640px). Left wall = tiles at X:0, right wall = tiles at X:640.

```
BEAT 0 (Y: 5504–4864) — The Grave
  - Solid floor at Y: 5504, full width (10 tiles)
  - Left + right walls full height of beat
  - Ceiling at Y: 4864 with a 2-tile gap at center (tiles 4–5, X: 192–320) → leads up to Beat 1

BEAT 1 (Y: 4864–4480) — Hana's Discovery
  - Left + right bamboo walls full height of beat
  - Open floor from Beat 0 gap; ceiling open upward into Beat 2
  - No internal platforms

BEAT 2 (Y: 4480–3840) — First Climb
  - Left + right bamboo walls full height
  - Platform A: Y: 4352, X: 0–192 (left-side ledge, 3 tiles wide)
  - Platform B: Y: 4160, X: 256–448 (center ledge, 3 tiles wide)
  - Platform C: Y: 3968, X: 448–640 (right-side ledge, 3 tiles wide → connects up to Beat 3)

BEAT 3 (Y: 3840–2880) — Open Chamber
  - Left + right solid walls full height
  - Solid floor at Y: 3840, full width (10 tiles)
  - Open ceiling at Y: 2880 → leads up to Beat 4 shaft
  - No internal platforms

BEAT 4 (Y: 2880–2240) — Narrow Shaft
  - Outer bamboo walls fill tiles 1–3 (X: 0–192) and tiles 7–10 (X: 384–640)
  - Inner walkable shaft = tiles 4–6 (X: 192–384), 3 tiles wide
  - No floor; player free-falls if they miss a wall-jump (optional: add 1-tile ledges mid-shaft)
  - Ceiling at Y: 2240 opens into Beat 5

BEAT 5 (Y: 2240–1280) — Open Grove
  - Left + right solid walls full height
  - Solid floor at Y: 2240, full width
  - Decorative platform at Y: 1760, X: 192–448 (center, 4 tiles wide, not required for path)
  - Open ceiling at Y: 1280 → leads into Beat 6

BEAT 6 (Y: 1280–768) — Kaito's Memory
  - Left + right solid walls full height
  - Solid floor at Y: 1280, full width
  - Open ceiling at Y: 768 → leads into Beat 7

BEAT 7 (Y: 768–128) — Climax Corridor
  - Outer solid walls fill tiles 1–3 (X: 0–192) and tiles 7–10 (X: 384–640)
  - Inner walkable shaft = tiles 4–6 (X: 192–384), 3 tiles wide (same width as Beat 4)
  - Open ceiling at Y: 128 → leads into Beat 8

BEAT 8 (Y: 128–0) — Exit
  - Small exit platform at Y: 128, X: 256–384 (tiles 4–6)
  - Left + right walls at Y: 0–128
  - LevelEnd trigger at top (Y: 64)
```

**Pacing check:** After painting, press F5 and climb the level. Should take under 4 minutes
wall-to-wall (including combat and platforming). Adjust individual beat heights if needed.

### Task B3: Instance Enemy Scenes *(Claude via Godot MCP)*

```
# HollowedAsh_1 — Beat 3, diagonal center X: 200
node_create(parent_path="/Level_1/Enemies", scene_path="res://Scenes/Characters/HollowedAsh.tscn", name="HollowedAsh_1")
node_set_property(path="/Level_1/Enemies/HollowedAsh_1", property="position", value={"x":200,"y":3776})

# Patrol markers for Ash_1 — ±72px from center
node_create(parent_path="/Level_1/Enemies", type="Marker2D", name="AshPatrolLeft_1")
node_set_property(path="/Level_1/Enemies/AshPatrolLeft_1", property="position", value={"x":128,"y":3776})
node_create(parent_path="/Level_1/Enemies", type="Marker2D", name="AshPatrolRight_1")
node_set_property(path="/Level_1/Enemies/AshPatrolRight_1", property="position", value={"x":272,"y":3776})

# BambooLurker_1 — Beat 4, diagonal center X: 352
node_create(parent_path="/Level_1/Hazards", scene_path="res://Scenes/Characters/BambooLurker.tscn", name="BambooLurker_1")
node_set_property(path="/Level_1/Hazards/BambooLurker_1", property="position", value={"x":352,"y":2560})

# GloomWisp_1 — Beat 5 left of center (448 - 64 = 384)
node_create(parent_path="/Level_1/Enemies", scene_path="res://Scenes/Characters/GloomWisp.tscn", name="GloomWisp_1")
node_set_property(path="/Level_1/Enemies/GloomWisp_1", property="position", value={"x":384,"y":1760})

# GloomWisp_2 — Beat 5 right of center (448 + 64 = 512)
node_create(parent_path="/Level_1/Enemies", scene_path="res://Scenes/Characters/GloomWisp.tscn", name="GloomWisp_2")
node_set_property(path="/Level_1/Enemies/GloomWisp_2", property="position", value={"x":512,"y":1760})

# HollowedAsh_2 — Beat 7, diagonal center X: 608
node_create(parent_path="/Level_1/Enemies", scene_path="res://Scenes/Characters/HollowedAsh.tscn", name="HollowedAsh_2")
node_set_property(path="/Level_1/Enemies/HollowedAsh_2", property="position", value={"x":608,"y":448})
```

After instancing, save: `scene_save()`

### Task B4: Test Phase B *(Manual — Godot editor)*
1. Press F5
2. Verify:
   - Ren spawns at bottom of a tall dark level
   - Camera scrolls upward as Ren climbs
   - Beat 2 ledge hops are achievable (not too wide)
   - HollowedAsh_1 patrols at Beat 3 floor level
   - BambooLurker_1 activates when approached in shaft
   - GloomWisps orbit toward Hana in Beat 5
   - HollowedAsh_2 blocks Beat 7 shaft mid-way
3. Full climb time under 4 minutes

---

## Phase C: Events & Signal Wiring

### Task C1: Create Event Trigger Areas *(Claude via Godot MCP)*

Template for each trigger:
```
node_create(parent_path="/Level_1/Events", type="Area2D", name="<TriggerName>")
node_create(parent_path="/Level_1/Events/<TriggerName>", type="CollisionShape2D", name="CollisionShape2D")
node_set_property(path="/Level_1/Events/<TriggerName>/CollisionShape2D", property="shape",
  value={"__class__":"RectangleShape2D","size":{"x":<width>,"y":<height>}})
node_set_property(path="/Level_1/Events/<TriggerName>", property="collision_layer", value=0)
node_set_property(path="/Level_1/Events/<TriggerName>", property="collision_mask", value=2)
node_set_property(path="/Level_1/Events/<TriggerName>", property="position", value={"x":<x>,"y":<y>})
```

Create these triggers:

| Trigger Name                 | W × H    | X   | Y    | Notes |
|------------------------------|----------|-----|------|-------|
| `HanaSpawnTrigger`           | 128 × 128| 96  | 4672 | Diagonal center Beat 1 |
| `DialogueTrigger_Grave`      | 640 × 64 | 32  | 5472 | Bottom-left, Beat 0 |
| `DialogueTrigger_FirstEnemy` | 512 × 64 | 200 | 3900 | Diagonal center Beat 3 |
| `DialogueTrigger_Corridor`   | 192 × 64 | 352 | 2900 | Diagonal center Beat 4 |
| `GloomTrigger_Corridor`      | 192 × 64 | 352 | 2700 | Diagonal center Beat 4 |
| `DialogueTrigger_Wisps`      | 512 × 64 | 448 | 2250 | Diagonal center Beat 5 |
| `KaitoMemoryTrigger`         | 192 × 64 | 512 | 1050 | Diagonal center Beat 6 |
| `GloomClimaxTrigger`         | 256 × 64 | 608 | 780  | Diagonal center Beat 7 |
| `LevelEnd`                   | 200 × 32 | 620 | 64   | Top-right, Beat 8 |

After all triggers created: `scene_save()`

### Task C2: Connect Signals *(Manual — Godot editor Node tab)*

| Source Node                        | Signal        | Receiver   | Function                                       |
|------------------------------------|---------------|------------|------------------------------------------------|
| `Player`                           | health_changed| `HUD`      | `update_health`                                |
| `Player/Hana`                      | gloom_changed | `HUD`      | `update_gloom`                                 |
| `Player`                           | player_died   | `Level_1`  | `_on_player_died`                              |
| `Events/HanaSpawnTrigger`          | body_entered  | `Level_1`  | `_on_hana_spawn_trigger_body_entered`          |
| `Events/DialogueTrigger_FirstEnemy`| body_entered  | `Level_1`  | `_on_dialogue_trigger_first_enemy_body_entered`|
| `Events/DialogueTrigger_Corridor`  | body_entered  | `Level_1`  | `_on_dialogue_trigger_corridor_body_entered`   |
| `Events/GloomTrigger_Corridor`     | body_entered  | `Level_1`  | (Architect implements gloom rate override)     |
| `Events/DialogueTrigger_Wisps`     | body_entered  | `Level_1`  | `_on_dialogue_trigger_wisps_body_entered`      |
| `Events/KaitoMemoryTrigger`        | body_entered  | `Level_1`  | `_on_kaito_memory_trigger_body_entered`        |
| `Events/GloomClimaxTrigger`        | body_entered  | `Level_1`  | `_on_gloom_climax_trigger_body_entered`        |
| `Events/LevelEnd`                  | body_entered  | `Level_1`  | `_on_level_end_body_entered`                   |

### Task C3: Test Phase C *(Manual)*
1. Press F5
2. Verify:
   - Climb into HanaSpawnTrigger → GloomMeter appears
   - Leave Hana → GloomMeter fills
   - Return to Hana → GloomMeter drains
   - Take damage from Ash → HealthBar decreases
   - Each dialogue fires at the correct height
   - Reach LevelEnd at top → scene transitions
   - Health = 0 → scene reloads

---

## Phase D: Polish & Validation

### Task D1: Replace Placeholder Tiles *(if Artist has delivered)*
1. Open new tileset from Artist
2. Select TileMapLayer in Level_1.tscn, replace tiles
3. Verify collision still works on all platforms and walls

### Task D2: Add Props *(Claude via Godot MCP)*

```
# Grave markers — Beat 0 floor
node_create(parent_path="/Level_1/Props", type="Sprite2D", name="GraveMarker_1")
node_set_property(path="/Level_1/Props/GraveMarker_1", property="position", value={"x":128,"y":5440})

node_create(parent_path="/Level_1/Props", type="Sprite2D", name="GraveMarker_2")
node_set_property(path="/Level_1/Props/GraveMarker_2", property="position", value={"x":480,"y":5408})

node_create(parent_path="/Level_1/Props", type="Sprite2D", name="GraveMarker_3")
node_set_property(path="/Level_1/Props/GraveMarker_3", property="position", value={"x":320,"y":5376})

# Kaito's headband — Beat 6 platform
node_create(parent_path="/Level_1/Props", type="Sprite2D", name="KaitoHeadband")
node_set_property(path="/Level_1/Props/KaitoHeadband", property="position", value={"x":320,"y":1216})
```

`scene_save()`

### Task D3: Full Playthrough Checklist *(Manual — observed run)*

- [ ] Total climb time under 4 minutes?
- [ ] Beat 0: Dark, disorienting, only exit is upward?
- [ ] Beat 1: Hana's gold light appears as relief?
- [ ] Beat 2: Gloom ticks up when rushing platforms?
- [ ] Beat 3: Ash visible, readable, slow?
- [ ] Beat 4: Shaft feels claustrophobic? Lurker surprises?
- [ ] Beat 5: Player focuses on protecting Hana from Wisps?
- [ ] Beat 6: Silence lands emotionally at headband?
- [ ] Beat 7: Adrenaline spike? Gloom climbing fast?
- [ ] Beat 8: Relief at silence, clean exit?

### Task D4: Final Save *(Claude via Godot MCP)*
`scene_save()`
Verify `Level_1.tscn` is saved in FileSystem dock.

---

## Repositioning Existing Nodes (if nodes already exist with wrong coordinates)

If Phases 1–7 were completed with horizontal coordinates, reposition using:

```
# Enemies (diagonal positions)
node_set_property(path="/Level_1/Enemies/HollowedAsh_1", property="position", value={"x":200,"y":3776})
node_set_property(path="/Level_1/Enemies/AshPatrolLeft_1", property="position", value={"x":128,"y":3776})
node_set_property(path="/Level_1/Enemies/AshPatrolRight_1", property="position", value={"x":272,"y":3776})
node_set_property(path="/Level_1/Hazards/BambooLurker_1", property="position", value={"x":352,"y":2560})
node_set_property(path="/Level_1/Enemies/GloomWisp_1", property="position", value={"x":384,"y":1760})
node_set_property(path="/Level_1/Enemies/GloomWisp_2", property="position", value={"x":512,"y":1760})
node_set_property(path="/Level_1/Enemies/HollowedAsh_2", property="position", value={"x":608,"y":448})
node_set_property(path="/Level_1/Player", property="position", value={"x":32,"y":5472})

# Triggers (diagonal positions)
node_set_property(path="/Level_1/Events/HanaSpawnTrigger", property="position", value={"x":96,"y":4672})
node_set_property(path="/Level_1/Events/DialogueTrigger_FirstEnemy", property="position", value={"x":200,"y":3900})
node_set_property(path="/Level_1/Events/DialogueTrigger_Corridor", property="position", value={"x":352,"y":2900})
node_set_property(path="/Level_1/Events/GloomTrigger_Corridor", property="position", value={"x":352,"y":2700})
node_set_property(path="/Level_1/Events/DialogueTrigger_Wisps", property="position", value={"x":448,"y":2250})
node_set_property(path="/Level_1/Events/KaitoMemoryTrigger", property="position", value={"x":512,"y":1050})
node_set_property(path="/Level_1/Events/GloomClimaxTrigger", property="position", value={"x":608,"y":780})
node_set_property(path="/Level_1/Events/LevelEnd", property="position", value={"x":620,"y":64})

# Props (diagonal positions, bottom-left to diagonal center)
node_set_property(path="/Level_1/Props/GraveMarkers/Grave_1", property="position", value={"x":16,"y":5440})
node_set_property(path="/Level_1/Props/GraveMarkers/Grave_2", property="position", value={"x":48,"y":5408})
node_set_property(path="/Level_1/Props/GraveMarkers/Grave_3", property="position", value={"x":32,"y":5376})
node_set_property(path="/Level_1/Props/KaitoHeadband", property="position", value={"x":512,"y":1216})
```

Also move HollowedAsh_2 from Level_1 root into Enemies container if it's at the wrong level:
```
node_manage(op="reparent", path="/Level_1/HollowedAsh_2", new_parent="/Level_1/Enemies")
```

After all repositioning: `scene_save()`

---

## Validation Commands

```bash
# Script syntax check
godot --path . --check-only --script res://Scripts/Level_1.gd
godot --path . --check-only --script res://Scripts/HUD.gd

# Run the scene
godot --path . --scene res://Scenes/Level_1.tscn
```

Zero red errors in Output tab = phase complete.

---

## Decision Points

| Decision | Who Decides | Options |
|----------|-------------|---------|
| Beat 4 shaft — does player need wall-jump or climb mechanic? | Architect | Add mid-shaft ledges if jump-only is too hard |
| Beat 2 gap widths too wide for current JumpForce? | Human (playtest) | Widen platforms or reduce gaps |
| Pacing over 4 minutes? | Human (playtest) | Shorten individual beat heights by 1–2 tiles |
| Artist tileset delivered? | Human (Artist) | Placeholder tiles work; swap later |
| Ready for Level 2? | Human (sign-off) | Full D3 checklist must be 100% green |
