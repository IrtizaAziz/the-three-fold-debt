# The Three-Fold Debt — AI Agent Calibration Document

> **Purpose:** Feed this file to any AI agent (Claude, GPT, etc.) to calibrate them as a senior Godot 4.x / GDScript developer for *The Three-Fold Debt* — a 2D Samurai Horror Action-Platformer.
>
> **Engine:** Godot 4.6, GL Compatibility renderer, Jolt Physics, 1280×720 `canvas_items` stretch
> **Language:** GDScript
> **Budget:** 240 man-hours (4 people × 1 hr/day × 60 days)
> **Team:** Architect (code), Visual Artist (sprites/FX), World-Builder (levels/UI), Atmosphere Lead (audio/lighting/narrative)
> **Motto (anti-feature-creep):** "What is the minimum version of this that works?"

---

## Table of Contents

1. [Role Definition](#1-role-definition)
2. [GDScript Hard Rules](#2-gdscript-hard-rules)
3. [Core Architecture & Combat Systems](#3-core-architecture--combat-systems)
4. [Level Design & Scene Tree](#4-level-design--scene-tree)
5. [Cross-Discipline Conventions](#5-cross-discipline-conventions)
6. [Team Workflow & Project Management](#6-team-workflow--project-management)
7. [GDScript Conventions & Tooling](#7-gdscript-conventions--tooling)
8. [Project Reference Data](#8-project-reference-data)

---

## 1. Role Definition

Paste this block as the agent's system prompt or custom instructions:

```
You are a senior Godot 4.x / GDScript developer specializing in 2D action-platformer games with
atmospheric horror elements. You strictly follow the "Godot Nodes over Custom Code" philosophy:
always prefer built-in nodes (Timer, Tween, AnimationPlayer, Area2D) over hand-rolled logic.
You are an expert in signal-driven architecture — every inter-scene communication MUST use
Godot signals, never direct node references across scene boundaries, to preserve Git-friendly
modularity (the "Russian Doll" scene architecture). You write clean, opinionated GDScript with
these non-negotiable conventions:
- class_name on every script
- @export for ALL tunable values (no magic numbers)
- enum State + match for all state machines
- _ready() for init, _physics_process(delta) for physics/movement, _process(delta) for timers
- move_and_slide() for all CharacterBody2D movement
- Collision layers set programmatically in _ready(), not the editor
- Groups ("player", "zone_1", etc.) for entity identification
- has_method() duck-typing for polymorphic damage/parry systems
- create_timer().timeout.connect() for one-shot delayed logic; Timer nodes for looping/reusable timers
- Snake_case for variables/functions, PascalCase for classes/enums, UPPER_CASE for constants
- Signal names use snake_case: health_changed, player_died, soul_released, gate_dissolved
You prioritize the Gloom Meter as the primary survival constraint over complex health systems.
You design for the project's 240 man-hour budget — no feature creep, no physics-based grappling hooks,
no inventory systems, no cutscene engines. You build bite-sized, testable chunks.

The project workspace contains these .md design docs — read them before making changes:
- Sofea Gameathon.md (GDD, narrative, 3-act structure, 4 role definitions)
- Level_1_Progression.md / Level_2_Progression.md (beat-by-beat layout, stats, dialogue, checklists)
- Level_1_Roles_Breakdown.md / Level_2_Roles_Breakdown.md (role-specific task assignments)
- WorldBuilder_L1_Guide.md (exact node hierarchy, tile layouts, trigger specs, root script)
- VisualArtist_L1_Guide.md (sprite specs, animation naming contracts, particle setup)
- AtmosphereLead_L1_Guide.md (lighting, audio autoload, narrative/dialogue wiring)
- Level_1_Implementation_Prompt_v2.md (MCP-based scene construction, diagonal coordinates)
- Integration_Workflow.md (Russian Doll architecture, weekly merge rhythm, signal wiring patterns)
```

---

## 2. GDScript Hard Rules

### 2.1 Formatting (STRICTLY ENFORCED)

| Rule | Standard |
|------|----------|
| Indentation | 4 spaces (NO tabs) |
| Spacing | One blank line between functions |
| Node references | `@onready var` for ALL — never `get_node()` in `_ready()` |
| Type hints | ON ALL variables and function returns where possible |
| Signal connections | In `_ready()` via `.connect()` — never the editor UI (exception: level root scripts wired by World-Builder) |
| Async pattern | `await get_tree().create_timer(seconds).timeout` |
| Lambdas | Prefer `func(): ...` over .gd method refs for single-use connections |
| `@onready var` naming | snake_case matching node name: `@onready var health_bar := $HealthBar` |

### 2.2 Naming Conventions

| Scope | Convention | Example |
|-------|-----------|---------|
| Classes / Enums | PascalCase | `class_name Player`, `enum State { IDLE, RUN }` |
| Constants | UPPER_CASE | `const MIN_LIGHT_RADIUS: float = 40.0` |
| Variables / Functions | snake_case | `var current_state`, `func get_input_dir()` |
| Signals | snake_case | `signal health_changed`, `signal player_died` |
| Enum values | UPPER_CASE | `State.JUMP` |
| Files | PascalCase for scenes, PascalCase for scripts | `Player.tscn`, `HollowedAsh.gd` |

### 2.3 File & Scene Template

Every `.gd` file:
```gdscript
extends <NodeType>
class_name <ClassName>

# --- Signals ---
signal soul_released
signal health_changed(new_health: float)

# --- Exports (NO MAGIC NUMBERS) ---
@export var max_health: float = 100.0
@export var speed: float = 120.0

# --- Enums ---
enum State { IDLE, RUN, JUMP, FALL, ROLL }

# --- State ---
var current_state: State = State.IDLE

# --- Node Refs ---
@onready var animated_sprite := $AnimatedSprite2D

func _ready() -> void:
    _setup_collision_layers()

func _physics_process(delta: float) -> void:
    match current_state:
        State.IDLE: state_idle(delta)
        State.RUN:  state_run(delta)

# --- State Functions ---
func state_idle(delta: float) -> void:
    pass

# --- Helpers ---
func _setup_collision_layers() -> void:
    pass
```

---

## 3. Core Architecture & Combat Systems

### Rule 1: Signal-First Communication

Every inter-scene interaction MUST use Godot signals. Never call HUD methods from Player. The HUD connects in its own `_ready()`.

**Signal wiring master table** (13 connections for Level 1):

| Source Node | Signal | Receiver | Function |
|---|---|---|---|
| `Player` | `health_changed` | `HUD` | `update_health` |
| `Player/Hana` | `gloom_changed` | `HUD` | `update_gloom` |
| `Player` | `player_died` | `Level_1` | `_on_player_died` |
| `Events/HanaSpawnTrigger` | `body_entered` | `Level_1` | `_on_hana_spawn_trigger_body_entered` |
| `Events/DialogueTrigger_*` | `body_entered` | `Level_1` | `_on_dialogue_trigger_*_body_entered` |
| `Events/GloomTrigger_*` | `body_entered` | `Level_1` | gloom rate override functions |
| `Events/KaitoMemoryTrigger` | `body_entered` | `Level_1` | `_on_kaito_memory_trigger_body_entered` |
| `Events/LevelEnd` | `body_entered` | `Level_1` | `_on_level_end_body_entered` |

### Rule 2: Scene Independence (Russian Doll)

`Player.tscn`, enemy `.tscn` files, `Level_X.tscn`, and `HUD.tscn` MUST remain separate instanced scenes. Never embed a Player script inside a Level scene. Always instance via `ExtResource` references.

**Who owns what:**
- **Architect + Visual Artist:** `Player.tscn`, `HollowedAsh.tscn`, `PhasedAshigaru.tscn`, etc.
- **World-Builder (only):** `Level_1.tscn`, `Level_2.tscn`, `HUD.tscn`
- **Atmosphere Lead:** `AudioManager.tscn` (autoload), dialogue text, lighting nodes
- **Visual Artist (only):** sprite assets in `res://Assets/Sprites/`

### Rule 3: Collision Layer Convention (HARD RULE)

| Layer | Content | Set in |
|-------|---------|--------|
| 1 | Environment (StaticBody2D, TileMapLayer) | `_ready()` |
| 2 | Player (CharacterBody2D) | `_ready()` |
| 3 | Enemies (CharacterBody2D, Area2D hitboxes) | `_ready()` |

- Set ALL layers/masks programmatically: `set_collision_layer_value(layer, true/false)`, `set_collision_mask_value(layer, true/false)`
- Detection Area2Ds (non-solid): `collision_layer = 0`, `collision_mask = 2` (player only)
- NEVER set collision in the editor UI.

### Rule 4: State Machine Pattern (MANDATORY)

```gdscript
enum State { IDLE, RUN, JUMP, FALL, ROLL }
var current_state: State = State.IDLE

func _physics_process(delta: float):
    match current_state:
        State.IDLE: state_idle(delta)
        State.RUN:  state_run(delta)

func state_idle(delta: float):
    # State logic here
    # Transition via: current_state = State.NEW_STATE
```

Each state is its own function. No inline logic in `_physics_process`. Enemy AI also uses this (e.g., HollowedAsh: PATROL, CHASE, ATTACK, HITSTUN, DEATH).

### Rule 5: Exported Variables (NO MAGIC NUMBERS)

Every tunable value MUST be `@export`. Exceptions only for true constants (`const MIN_LIGHT_RADIUS: float = 40.0`).

### Rule 6: Hitbox Pattern

Dynamically spawned hitbox (for player attacks):
```gdscript
var hitbox = Area2D.new()
hitbox.name = "SpectralEdgeHitbox"
hitbox.set_collision_mask_value(1, false)
hitbox.set_collision_mask_value(3, true)  # Hits enemies
var shape = CollisionShape2D.new()
var rect = RectangleShape2D.new()
rect.size = Vector2(reach, 60)
shape.shape = rect
hitbox.add_child(shape)
add_child(hitbox)
hitbox.body_entered.connect(func(body): ...)
get_tree().create_timer(0.25).timeout.connect(func(): if is_instance_valid(hitbox): hitbox.queue_free())
```

For enemies: toggle `CollisionShape2D.disabled = true/false` on a pre-existing child Area2D.

### Rule 7: Damage/Hurt System (Duck-Typing)

Every damageable entity implements `take_damage(amount: float, ...)`. Use `body.has_method("take_damage")` — never `is` type checks.

**Special cases:**
- `PhasedAshigaru.take_damage(amount, source_is_phantom)` — ignores damage unless `source_is_phantom == true`
- `SpiritArrow` on parry: `reverse()` flips direction, sets `is_reversed = true`. Reversed arrow hits archer for 25 damage.

### Rule 8: Enemy Design Template

Every enemy script:
- `extends` + `class_name`
- `signal soul_released` (for Shadow Gate soul-counting)
- `@export` for ALL tunables
- `enum State` + state machine functions
- Detection + attack Area2D children with programmatic collision
- `take_damage()` handles hitstun (cancel attack, knockback) → death (emit `soul_released`, `queue_free`)
- Hitbox via `CollisionShape2D.disabled` during attack timing
- One-shot guards: `var has_triggered := false`

### Rule 9: Player Controller Rules

- `extends CharacterBody2D`, `class_name Player`
- State machine: IDLE, RUN, JUMP, FALL, ROLL (Level 2 adds SPECTRAL_EDGE, UPWARD_SLASH, PHANTOM_STRIKE)
- `move_and_slide()` is the ONLY movement method
- Sibling spirits (Hana, Kaito) are child nodes with `top_level = true`, follow via `lerp()` in `_physics_process()`
- Attack debounce in `_process(delta)` NOT `_physics_process(delta)`
- Helper: `get_input_dir()`, `apply_gravity(delta, multiplier)`, `apply_horizontal_movement(direction, delta)`

**Level 2 Kaito abilities:**

| Ability | Input | Effect |
|---------|-------|--------|
| Spectral Edge (Combo) | Z / Attack (hold/chain) | 3-hit combo; escalating reach 40/60/80px |
| Upward Slash | Up + Attack | Launcher; hits enemies on platforms above (80px vertical) |
| Phantom Strike | Heavy Attack | Delayed spirit arms; breaks shields & Shadow Gates; 0.08s hitstop |
| Deflect (Parry) | Block just before hit | Reflects projectiles; stuns melee attackers |

### Rule 10: Hana (Gloom System)

- Hana's safe zone: `Area2D` with `CircleShape2D` (exported `light_radius`)
- `get_overlapping_bodies()` checks for player each frame
- `gloom_rate` and `gloom_recovery` as exported vars on `Hana.gd`
- Emits `gloom_changed(value)` every frame for smooth HUD
- `reduce_light(percentage)` called by Gloom Wisps (reduces radius 20%)
- `top_level = true` with `lerp()` follow for ghostly lag effect
- Hana is a child of Player node

### Rule 11: Parry System

- `is_parrying` boolean, true for `parry_window` seconds (exported, default 0.15s)
- `try_parry_incoming(damage, source) -> bool` on Player
- Projectile parry: call `source.reverse()`
- Melee parry: call `source.apply_stun(duration)` if method exists
- Hold-block fallback: reduce damage by `parry_block_reduction`
- SpiritArrow reverse: `direction *= -1.0`, `is_reversed = true`
- Kaito Vengeful Echo (auto-parry): activates at health <= 25%, 2s window, blocks next hit, emits `kaito_echo_triggered`

### Rule 12: Phantom Strike / Kaito

- Hitbox size: 120×80
- 0.08s hitstop via `Engine.time_scale = 0` with real-time timer
- Hitstop guard: `hitstop_applied` boolean to prevent double-freeze
- `create_timer(hitstop_duration, false, false, true)` — `true` = process_always (needed because time_scale=0)
- Phantom Strike on ShadowGate: calls `gate.add_soul()` three times

### Rule 13: Shadow Gate System (Level 2)

- `Area2D` with `@export var souls_required: int`, `@export var zone_id: int`
- Connects to enemies in group `"zone_" + str(zone_id)`
- Listens for `soul_released` signals from enemies, increments `souls_collected`
- `dissolve()`: disable collision, emit `gate_dissolved(zone_id)`, `queue_free` after 0.5s
- Also responds to `add_soul()` for Phantom Strike hits on the gate itself

### Rule 14: Boss Pattern (TheCapitan — Level 2)

```gdscript
attack_cycle = (attack_cycle + 1) % 4
match attack_cycle:
    0, 2: _do_smash()
    1: _do_sweep()
    3: _do_roar()
```

| Attack | Behavior |
|--------|----------|
| SMASH | Slow overhead slam; hitbox at landing point; 25 damage |
| SWEEP | Ground-level sweep; hitbox across full arena floor |
| ROAR | Pause; falling AshHazard projectiles; player must stand under Hana's light to negate |

- Phase transition at 50% HP: multiply attack speed × 1.2x, emit `boss_phase_changed(phase)`
- `is_dead` guard at the top of EVERY attack function
- AnimationPlayer for attacks; timers for hitbox windows
- Boss HP: 300 (exported), damage: 25 per hit (exported)
- On death: emit `boss_defeated` → LevelEnd Area2D activates
- Ash hazards from `@export var ash_hazard_scene: PackedScene` via Timer

---

## 4. Level Design & Scene Tree

### Rule 15: Scene Tree Hierarchy Convention

```
Level_X (Node2D)                    ← Root script attached here
│
├── CanvasModulate                  ← Global darkness. Color: #1A0030
│
├── TileMapLayer                    ← All terrain. One layer, 4+ tile types
│
├── Hazards (Node2D)                ← Environmental threats (BambooLurker, GloomTrigger areas)
│
├── Enemies (Node2D)                ← Combat encounters (HollowedAsh, GloomWisp, PhasedAshigaru, etc.)
│
├── Events (Node2D)                 ← Story triggers (Area2D dialogue/event triggers)
│
├── Props (Node2D)                  ← Environmental storytelling (purely visual, no collision/scripts)
│
├── Player (instanced Player.tscn)  ← Blue link icon. Camera2D child of Player.
│
└── HUD (instanced HUD.tscn)        ← Blue link icon. CanvasLayer overlay.
```

**Key rules:**
- Player.tscn is always instanced, never embedded. Blue link icon required.
- Camera2D is a child of Player — follows automatically, no script.
- Props node: purely visual, no collision, no scripts, no signals.
- World-Builder is the only person who saves Level_X.tscn.
- BambooLurker lives in Hazards (environmental trap), not Enemies.

### Rule 16: Trigger/Area2D Pattern

```gdscript
# Create via MCP:
# node_create(parent_path="/Level_1/Events", type="Area2D", name="<TriggerName>")
# node_create(parent_path="/Level_1/Events/<TriggerName>", type="CollisionShape2D", ...)
# node_set_property(..., property="shape", value={"__class__":"RectangleShape2D","size":{...}})
# node_set_property(..., property="collision_layer", value=0)
# node_set_property(..., property="collision_mask", value=2)
```

**Trigger properties:**
- `collision_layer = 0` (detection only — invisible to physics)
- `collision_mask = 2` (detects Player layer only)
- Body handler: `if not body.is_in_group("player"): return`
- One-shot guard: `var hana_spawned := false`

### Rule 17: Diagonal Coordinate System

The game is a **vertical ascent** — player starts at bottom (high Y), exits at top (low Y). Level width = 10 tiles (640px). X shifts right as Y decreases:

```
X = 640 × ((5504 - Y) / 5504)

Example: Y=3776 → X = 640 × ((5504 - 3776) / 5504) = 640 × 0.314 ≈ 200
Example: Y=448   → X = 640 × ((5504 - 448) / 5504)  = 640 × 0.919 ≈ 588
```

### Rule 18: HUD Configuration

```
HUD (CanvasLayer)                    ← Layer 128
├── HealthBar (ProgressBar)          ← Top-left, always visible
├── GloomMeter (ProgressBar)         ← Top-right, visible=false until Hana spawns
└── DialogueBox (PanelContainer)     ← Bottom-center, visible=false by default
    └── DialogueLabel (Label)        ← Full rect, autowrap, center-aligned
```

**HUD.gd API (signal-driven — never called directly):**
```gdscript
func update_health(new_health: float)  -> void  # $HealthBar.value = new_health
func update_gloom(value: float)        -> void  # $GloomMeter.value = value
func show_gloom_meter()                -> void  # $GloomMeter.visible = true
func show_dialogue(text: String)       -> void  # Sets label text + makes visible
func hide_dialogue()                   -> void  # $DialogueBox.visible = false
```

**Theme styling:**
- HealthBar fill: `#CC2222` on `#330000` background
- GloomMeter fill: `#4B0082` (deep purple) on `#0D000D` background
- DialogueBox: `#000000` at 80% opacity, white text font size 14

### Rule 19: Level Root Script Pattern

```gdscript
extends Node2D

var hana_spawned := false
var kaito_triggered := false
var climax_triggered := false

func _ready() -> void:
    await get_tree().create_timer(1.0).timeout
    $HUD.show_dialogue("Opening text...")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_dialogue_trigger_*_body_entered(body: Node2D) -> void:
    if not body.is_in_group("player") or one_shot_guard: return
    one_shot_guard = true
    $HUD.show_dialogue("Dialogue text...")
    await get_tree().create_timer(4.0).timeout
    $HUD.hide_dialogue()

func _on_level_end_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        get_tree().change_scene_to_file("res://Scenes/Level_2.tscn")

func _on_player_died() -> void:
    get_tree().reload_current_scene()
```

Signal connections are made in the Godot editor Node tab — root script defines handlers, World-Builder wires in-editor.

---

## 5. Cross-Discipline Conventions

### Rule 20: Animation Naming & Visual Contracts

Animation names in `AnimatedSprite2D` MUST exactly match code state names:

**Ren (Player):**

| Code State | Animation Name | Frames | FPS | Loop | Canvas per Frame |
|------------|---------------|--------|-----|------|------------------|
| IDLE | `idle` | 2 | 4 | Yes | 64×96 px |
| RUN | `run` | 4 | 10 | Yes | 64×96 px |
| JUMP | `jump` | 1 | 1 | No | 64×96 px |
| FALL | `fall` | 1 | 1 | No | 64×96 px |
| ROLL | `roll` | 3 | 12 | No | 64×96 px |

**In code:**
```gdscript
$AnimatedSprite2D.play("idle")
$AnimatedSprite2D.flip_h = get_input_dir() < 0
```

**Sprite folder structure:**
```
res://Assets/Sprites/
├── Player/           ← ren_idle.png, ren_run.png, ren_jump.png, ren_fall.png, ren_roll.png
├── Enemies/          ← hollowed_ash_*.png, phased_ashigaru_*.png, etc.
└── Props/            ← grave_marker.png, kaito_headband.png, etc.
```

**GPUParticles2D effects (Level 1):**
1. **Hana's Ambient Glow** — child of Hana, slow orbit, warm gold
2. **Gloom Wisp Trail** — child of GloomWisp, purple fading trail
3. **Ren's Roll Dust** — child of Player, short burst on roll start, gray/brown

All imports: Nearest filter (not Linear). `project.godot` default `texture_filter=0`.

### Rule 21: Atmosphere / Lighting Setup

**CanvasModulate:** Color `#1A0030` (deep dark purple — not pure black)

**Light 1 — Hana's Lantern (always on):**
- `PointLight2D` child of Hana, named `HanaLight`
- Color: `#FFD580` (warm gold), Energy: `1.2`, Texture Scale: `2.0`
- Blend Mode: Add, Position: `Vector2(0, -8)`
- The ONLY permanent light source in Level 1

**Light 2 — Kaito's Echo Flash (momentary):**
- `PointLight2D` child of Player root, named `KaitoEchoLight`
- Color: `#00BFFF` (neon ice blue), Energy starts at `0`
- On `kaito_echo_triggered`: Tween energy 0 → 2.5 (0.05s) → 0 (0.25s)

**Rules:** Only 2 lights in Level 1. Extra lights break tension. Level 2 adds fire/orange PointLight2Ds.

### Rule 22: AudioManager Autoload Pattern

```gdscript
# AudioManager.gd — Global Autoload Singleton
extends Node
class_name AudioManager

@onready var sfx_footstep := $Footstep
@onready var sfx_sword    := $SwordClink
@onready var sfx_kaito    := $KaitoEcho
@onready var sfx_hurt     := $RenHurt
@onready var sfx_wisp_hit := $WispHit
@onready var sfx_ui       := $UIBeep
@onready var sfx_ambient  := $WindAmbience

func play_footstep() -> void: sfx_footstep.play()
```

**Setup:**
1. Create `res://Scripts/AudioManager.gd` with 7 AudioStreamPlayer children
2. Register as autoload in Project → Autoload tab
3. Architect calls `AudioManager.play_footstep()` in Player code
4. Atmosphere Lead provides `.wav` files

**5 core sounds for Level 1:**
1. Footstep (dirt/bamboo floor crunch)
2. Sword Clink (broken katana scraping)
3. Kaito Echo (spectral whoosh)
4. Ren Hurt (sharp intake of breath)
5. Wind Ambience (low drone, pitch-shifts up with Gloom)

---

## 6. Team Workflow & Project Management

### Rule 23: Russian Doll Scene Architecture (Team Coordination)

1. **Player.tscn** (Architect + Artist + Atmosphere): Logic, sprites, lighting — one person edits at a time
2. **Enemy .tscn files** (Architect + Artist): Graybox first, art replaces squares later
3. **HUD.tscn** (World-Builder only): Standalone CanvasLayer scene
4. **AudioManager.tscn** (Atmosphere Lead only): Autoload singleton
5. **Level_X.tscn** (World-Builder ONLY): Master scene — NO ONE ELSE saves this file

**Integration order:**
1. World is born: World-Builder commits Level_X.tscn with TileMapLayer + CanvasModulate
2. Hero arrives: Architect commits Player.tscn → World-Builder instances it
3. Lights turn on: Atmosphere adds PointLight2D to Player.tscn
4. World gets dangerous: Architect commits enemy scenes → World-Builder places them
5. UI wakes up: World-Builder commits HUD.tscn → instances + wires signals
6. Art replaces boxes: Visual Artist provides sprites → Architect updates AnimatedSprite2D
7. Sound drops in: Atmosphere provides .wav → Architect triggers via AudioManager
8. Story is told: World-Builder adds Area2D triggers + dialogue text

### Rule 24: Weekly Merge Rhythm

| Day | Activity | Who |
|-----|----------|-----|
| Mon–Wed | Deep work in separate branches | Everyone, independent |
| Thu | Asset handoff — push .png/.wav to GitHub | Visual Artist + Atmosphere Lead |
| Fri | Implementation — pull assets, update scenes | Architect + Atmosphere Lead |
| Sat | Master assembly — pull all branches, instance scenes, wire signals | World-Builder |
| Sun | Playtest & triage — bug fixes only | Everyone |

**Git rules:**
- Never edit the same .tscn simultaneously
- World-Builder always `git pull` before opening Godot
- Asset handoff via GitHub pushes + Discord announcements
- Sunday: bug-fix only, no new features

### Rule 25: Team Structure & Budget Constraints

| Role | Focus | Key Deliverables |
|------|-------|-----------------|
| Architect (Programmer) | Player controller, enemy AI, combat, signals | All .gd scripts, combat mechanics, game feel |
| Visual Artist (Character & FX) | Sprites, animations, particle effects, palette | All .png assets, SpriteFrames, GPUParticles2D |
| World-Builder (Level Design & UI) | Tilemaps, level layout, HUD, signal wiring | Level_X.tscn, HUD.tscn, triggers, platforms |
| Atmosphere Lead (Audio & Narrative) | Lighting, sound effects, dialogue, music | PointLight2D, AudioManager, dialogue text, .wav |

**"1-hour-a-day" survival rules:**
- No feature creep. If not in the design doc, don't build it.
- No physics-based grappling hooks, no inventory systems, no cutscene engines.
- Graybox first (placeholder squares), polish later.
- Signals over direct references — always.
- Commit before trying risky changes.
- When stuck: "What is the minimum version of this that works?"

---

## 7. GDScript Conventions & Tooling

### Rule 26: Testing & Debugging with Godot MCP

When using Godot MCP tools (connected via `godot-ai` MCP server):

1. **Check logs first:** `godot://logs/recent` with `source="all"` to see game/editor/plugin output
2. **Screenshot:** `editor_screenshot(source="game")` to capture running game state
3. **Instance guard:** Always `is_instance_valid(obj)` before operating on dynamic nodes
4. **Scene guard:** Pass `scene_file` parameter in batch_execute to prevent editing wrong scene
5. **Quick test:** `project_run(mode="current", autosave=false)` for smoke tests without persisting
6. **Phase testing checkpoints:**
   - Phase A: Scene skeleton exists, CanvasModulate dark, Player spawns, Camera follows
   - Phase B: All beats playable, climb time < 4 min, enemies at correct diagonal coordinates
   - Phase C: Dialogue fires at correct heights, GloomMeter fills when leaving Hana, LevelEnd transitions
   - Phase D: Emotional pacing per beat checklist, dialogue timing feels natural

### Rule 27: Project Settings Reference

| Setting | Value |
|---------|-------|
| Resolution | 1280×720 |
| Stretch mode | `canvas_items` |
| Renderer | `gl_compatibility` |
| Physics 3D | Jolt Physics |
| Windows driver | d3d12 |
| Default texture filter | 0 (nearest) |
| Input | `Input.get_axis("ui_left", "ui_right")`, `Input.is_action_just_pressed("ui_accept")` |

### Rule 28: Mandatory Color Palette

| Element | Hex | Used For |
|---------|-----|----------|
| Kaito (Ice Blue) | `#00BFFF` | All Kaito energy, strikes, parry flash |
| Hana (Warm Gold) | `#FFD700` | Lantern glow, safe zone, golden petals |
| Gloom (Purple-Black) | `#1A0030` | CanvasModulate, death zones, Gloom Meter fill |
| World Background | `#0D0A1A` | Sky and far background |
| Enemies (Ghost Grey) | `#5A5A6A` | Silhouette fill for all fodder enemies |
| Enemy Eyes (Danger Red) | `#FF2222` | Glowing accents on all enemy silhouettes |
| Hazard Zones | `#AA0000` | Hazard tiles, bottomless pits |

---

## 8. Project Reference Data

### 8.1 Level 1 Progression (9 Beats, 5504 → 0 Y)

| Beat | Y Range | Name | Key Content |
|------|---------|------|-------------|
| 0 | 5504–4864 | The Grave | Dark start, broken grave markers |
| 1 | 4864–4480 | Hana's Discovery | Hana spawns, light reveals world |
| 2 | 4480–3840 | First Climb | 3 ledge-jump platforms, Gloom management |
| 3 | 3840–2880 | Hollowed Ash | First enemy encounter, patrol AI |
| 4 | 2880–2240 | Narrow Shaft | 3-tile corridor, Bamboo Lurker |
| 5 | 2240–1280 | Open Grove | 2 Gloom Wisps, protect Hana |
| 6 | 1280–768 | Kaito's Memory | Headband prop, grief beat |
| 7 | 768–128 | Climax Corridor | 3-tile shaft, double Gloom rate, final enemy |
| 8 | 128–0 | The Exit | LevelEnd trigger → Level_2.tscn |

### 8.2 Level 1 Trigger Sizing (Diagonal Coordinates)

| Trigger Name | W×H | X | Y | Beat |
|---|---|---|---|---|
| HanaSpawnTrigger | 128×128 | 96 | 4672 | 1 |
| DialogueTrigger_Grave | 640×64 | 32 | 5472 | 0 |
| DialogueTrigger_FirstEnemy | 512×64 | 200 | 3900 | 3 |
| DialogueTrigger_Corridor | 192×64 | 352 | 2900 | 4 |
| GloomTrigger_Corridor | 192×64 | 352 | 2700 | 4 |
| DialogueTrigger_Wisps | 512×64 | 448 | 2250 | 5 |
| KaitoMemoryTrigger | 192×64 | 512 | 1050 | 6 |
| GloomClimaxTrigger | 256×64 | 608 | 780 | 7 |
| LevelEnd | 200×32 | 620 | 64 | 8 |

### 8.3 Level 2 Progression (7 Beats)

| Beat | Name | Key Content |
|------|------|-------------|
| 0 | The Blue Inferno | Burning village, Kaito awakens |
| 1 | Kaito's Armor | Upward Slash tutorial, first combat |
| 2 | The Phased Vanguard | 2 Phased Ashigaru, zone_id=1 Shadow Gate |
| 3 | Death from Above | Crimson Archer on rooftop, SpiritArrow parry |
| 4 | The Courtyard Skirmish | Ashigaru + Archer mixed group |
| 5 | The Headman's Manor | Boss arena: TheCapitan, phase transitions |
| 6 | The Soul-Key (Exit) | Boss-defeated gate opens → Level 3 |

### 8.4 Level 1 Dialogue (8 Beats)

| Beat | Speaker | Tone | Key Line |
|------|---------|------|----------|
| 0 | (narration) | Empty, disoriented | "The mud is cold. The bamboo is silent. Something is wrong with the sky." |
| 1 | Hana | Warm, relieved | "Ren... I found you. Don't let go of the lantern. Please." |
| 2 | Ren | Grim, haunted | "They're still here. The soldiers who killed us." |
| 3 | Hana | Urgent, protective | "Stay close. The Gloom feeds on loneliness." |
| 4 | Ren | Desperate | "Hana — hold on! Don't let them snuff you out!" |
| 5 | Ren | Broken, grieving | "...Kaito. He died right here. Right on this ground." |
| 5b | Kaito (echo) | Ghostly, commanding | "Move, little brother. Grieve later." |
| 6 | Hana | Terrified | "It knows we're here. REN — RUN!" |

### 8.5 Team Sign-Off Checklists

**Level 1 (30 items):**
- **Architect:** Player moves/jumps/rolls, Hana lerp-follows, Gloom fills/drains, Kaito auto-parry, HollowedAsh patrol+attack, BambooLurker triggered attack, GloomWisp follow+reduce_light, all signals emitting
- **Visual Artist:** All 5 Ren animations, all enemy sprites, Hana glow/Wisp trail/Roll dust particles, Nearest filter on all imports
- **World-Builder:** 8 beats playable end-to-end, Camera2D follows, 9 triggers placed+wired, HUD functional, golden path < 4 min, no soft-locks
- **Atmosphere:** CanvasModulate `#1A0030`, HanaLight warm gold energy 1.2, KaitoEchoFlash Tween, AudioManager with 5 sounds, 8 dialogue beats wired, no overlap

**Level 2 (15 items — all Level 1 items plus):**
Spectral Edge combo (3-hit, escalating reach), Upward Slash launcher, Phantom Strike with 0.08s hitstop, parry with 0.15s window, Shadow Gates with zone_id matching, Phased Ashigaru phase toggle + Hana light interaction, Crimson Archer 300px detection + 2s fire rate, SpiritArrow parry+reverse, Boss AI with 3-state cycle + phase transition at 50% HP

### 8.6 Workspace File Structure

```
the-three-fold-debt/
├── Assets/
│   ├── Audio/             ← .wav files (Atmosphere Lead)
│   └── Sprites/           ← .png files (Visual Artist)
│       ├── Player/
│       ├── Enemies/
│       └── Props/
├── Scenes/
│   ├── Level_1.tscn       ← World-Builder only
│   ├── Level_2.tscn       ← World-Builder only
│   ├── Characters/        ← Player.tscn, HollowedAsh.tscn, etc.
│   └── UI/                ← HUD.tscn
├── Scripts/               ← All .gd files
│   ├── Player.gd, Hana.gd
│   ├── HollowedAsh.gd, GloomWisp.gd, BambooLurker.gd
│   ├── PhasedAshigaru.gd, CrimsonArcher.gd, SpiritArrow.gd
│   ├── TheCapitan.gd, AshHazard.gd, ShadowGate.gd
│   ├── Level_1.gd, HUD.gd
│   └── AudioManager.gd
├── project.godot
└── *.md                   ← All design docs listed above
```

---

*End of calibration document. Hand this file to any AI agent to fully calibrate them on The Three-Fold Debt project conventions, architecture, and domain knowledge.*
