# Level 2 Role Breakdown: The Burning Village

> **Level Theme:** Combat & Awakening | **Target Duration:** ~4–5 minutes
> **Core Mechanic Focus:** Kaito's Spectral Edge, Phantom Strike, Parry & Shadow Gates
> **Phase:** Graybox → Playable Combat Level

---

## 🧠 The Architect (Lead Programmer)

### What You're Building for Level 2

Level 2 is your **combat expansion sprint**. Kaito is now active, and the move set doubles. Your goal is to wire up the new offensive abilities, build the enemy logic for heavier, more strategic foes, implement the Shadow Gate system, and deliver a functional Boss Fight AI.

---

### Task 1 — Kaito's Abilities

Extend `Player.gd` with Kaito's active move set:

| Ability | Input | What it does |
|---------|-------|-------------|
| `Spectral Edge (Combo)` | Z / Attack button (hold / chain) | 3-hit combo; each hit extends reach with blue spirit energy |
| `Upward Slash` | Up + Attack | Launcher; hits enemies on platforms above Ren |
| `Phantom Strike` | Heavy Attack button | Delayed spirit arms mirror the swing; breaks shields & Shadow Gates |
| `Deflect (Parry)` | Block just before hit | Knocks projectiles back; stuns melee attackers briefly |

**Rules:**
- Phantom Strike must have a **hit-stop** (freeze-frame): pause game loop for ~0.08 seconds on connect.
- Phantom Strike must emit a `kaito_phantom_strike` signal so the Atmosphere Lead can fire the heavy sound FX and screen shake.
- Parry window: **0.15 seconds** (tight, but learnable). Outside the window, it's just a block.
- Keep all inputs as exported `StringName` action names so they are easy to remap.

---

### Task 2 — Shadow Gate System

Shadow Gates are walls of cursed energy that block progression. They dissolve only when Ren collects enough soul energy from defeated enemies.

```gdscript
# ShadowGate.gd
extends Area2D

@export var souls_required: int = 3
var souls_collected: int = 0

func add_soul():
    souls_collected += 1
    if souls_collected >= souls_required:
        dissolve()

func dissolve():
    # Play dissolve animation, then queue_free
    emit_signal("gate_dissolved")
    queue_free()
```

- Each killed enemy emits a `soul_released` signal.
- The active Shadow Gate listens for `soul_released` on enemies within the current zone (use a parent `Node2D` zone group or Autoload counter).
- Do NOT hardcode which gate listens to which enemy — use a `zone_id` exported variable on both the gate and the enemy so the World-Builder can pair them in the editor.

---

### Task 3 — Enemy AI: Phased Ashigaru & Crimson Archers

**Phased Ashigaru:**
- Two states: `PHASED` (transparent, immune to normal attacks) and `SOLID`.
- Toggle between states on a timer (`phase_interval`, exported, default 3 seconds).
- While `PHASED`: apply `modulate.a = 0.4` and set a `is_phased` flag to ignore Ren's normal hitbox.
- While `SOLID`: fully opaque; behaves like Hollowed Ash from Level 1 (patrol, chase, attack).
- **Special rule:** When inside Hana's `HanaLightRadius`, force the enemy into `SOLID` state immediately (listen to the Area2D `body_entered` signal from Hana's radius).

**Crimson Archer:**
- Stationary on rooftop platforms (no patrol).
- When Ren enters detection range, fire a `SpiritArrow` projectile every 2 seconds (exported).
- Arrow travels in a straight line; on hitting Ren, calls `ren.take_damage(15)`.
- If Ren successfully parries, the arrow reverses direction and damages the Archer.

```gdscript
# SpiritArrow.gd
extends Area2D
@export var speed: float = 300.0
@export var direction: float = -1.0 # -1 = left, 1 = right
var is_reversed: bool = false

func _physics_process(delta):
    position.x += direction * speed * delta

func reverse():
    direction *= -1
    is_reversed = true
```

---

### Task 4 — Boss: The Captain (Traitor's Echo)

Keep the Boss AI to **3 states** as specified in the design doc:

| State | Trigger | Behaviour |
|-------|---------|-----------|
| `SMASH` | Default loop | Slow overhead slam; spawns a hitbox at the landing point |
| `SWEEP` | After 2 Smashes | Ground-level sweep; hitbox slides across the full arena floor |
| `ROAR` | On reaching 50% HP | Pause; spawn falling ash hazards; Ren must stand under Hana's light to negate |

- Use an `AnimationPlayer` to drive all 3 attack animations.
- Emit `boss_phase_changed(phase)` signal when HP hits 50% so the Atmosphere Lead can trigger the music shift.
- Boss HP: 300 (exported). Boss deals 25 damage per hit (exported).
- On death: emit `boss_defeated` signal → World-Builder's `LevelEnd` Area2D activates.

---

### Week 3–4 Deliverable Checklist

- [ ] `Player.gd` extended — Spectral Edge combo, Upward Slash, Phantom Strike, Parry all functional
- [ ] Hit-stop on Phantom Strike (0.08s freeze frame)
- [ ] `ShadowGate.gd` — dissolves on correct soul count using `zone_id`
- [ ] `PhasedAshigaru.gd` — phase toggling; forced solid inside Hana's light
- [ ] `CrimsonArcher.gd` + `SpiritArrow.gd` — projectile fires and reverses on parry
- [ ] Boss AI (`TheCaption.gd`) — 3-state machine with AnimationPlayer integration
- [ ] All new mechanics use signals; no direct cross-scene node references

---

---

## 🎨 The Visual Artist (Character & FX)

### What You're Creating for Level 2

Level 2 shifts the visual language from **ghostly quiet** to **violent and burning**. Kaito's arrival floods the screen with cold blue energy. Every new sprite and effect should feel heavier, more aggressive, and more saturated than Level 1.

---

### Task 1 — Environment Color Shift

Update the style guide with Level 2 additions:

| Element | Color | Hex |
|---------|-------|-----|
| Village Background | Charcoal & Ash | `#1C1A2E` |
| Spectral Fire (Buildings) | Cold Blue Flame | `#1A6FFF` (flickering) |
| Kaito's Energy | Neon Ice Blue | `#00BFFF` |
| Shadow Gate | Deep Crimson & Black | `#3D0000` |
| Phased Ashigaru | Translucent Grey | `#888899` @ 40% opacity |
| Crimson Archer | Dark Red Silhouette | `#8B0000` |
| Boss (The Captain) | Bruised Purple & Black | `#2A0040` |

> **Rule:** Every new enemy must still read clearly as a silhouette. The Phased Ashigaru should be visually distinct from Solid — consider a glitching/dissolving edge effect using a shader or animated sprite.

---

### Task 2 — Kaito's Spirit Form Sprite

Kaito never fully manifests — he is an outline of blue fire behind Ren.

**Canvas size:** 96×128 px (larger than Ren to feel imposing)
**Style:** Pure outline — no fill, just glowing blue edges. Transparent interior.

| Animation | Frames | Notes |
|-----------|--------|-------|
| Phantom Slash | 3 frames | Giant spirit arms swing in from behind Ren; blur smear on frame 2 |
| Parry Flash | 2 frames | Kaito's hand appears at Ren's guard point; brief pulse |
| Idle Echo | 2 frames | Very faint; barely visible outline flickering behind Ren |

> **Tip:** These animations are short and explosive — prioritize the *impact* frame. Frame 2 of the Phantom Slash should feel overwhelming.

---

### Task 3 — New Enemy Sprites

**Phased Ashigaru:**
- Canvas: 48×80 px (same as Hollowed Ash)
- Solid state: Armored grey samurai silhouette with a glowing red chest
- Phased state: Same sprite; apply 40% opacity + a subtle chromatic-aberration-style edge (can be a second, offset duplicate sprite in a different color)

| Animation | Frames |
|-----------|--------|
| Walk (Solid) | 4 frames |
| Phase In/Out | 2 frames (dissolve transition) |
| Attack | 2 frames |

**Crimson Archer:**
- Canvas: 48×80 px
- Style: Crouching silhouette on rooftop; drawn bow glowing red

| Animation | Frames |
|-----------|--------|
| Idle (Aimed) | 2 frames |
| Fire | 2 frames |

**Spirit Arrow:**
- Canvas: 32×8 px — a thin, fast red energy bolt with a trailing smear

**The Captain (Boss):**
- Canvas: 96×128 px
- Style: Giant bruised-purple horned Yokai silhouette; oversized Kanabō

| Animation | Frames |
|-----------|--------|
| Idle | 2 frames |
| Smash | 4 frames |
| Sweep | 3 frames |
| Roar | 3 frames |
| Death | 4 frames |

---

### Task 4 — Particle Effects (Godot GPUParticles2D)

| Effect | Description |
|--------|-------------|
| Phantom Strike Impact | Explosive burst of blue particles outward on hit; lasts 0.3s |
| Parry Spark | Sharp, short-lived white/blue sparks at Ren's guard point |
| Shadow Gate Dissolve | Red particles scatter outward as gate breaks |
| Falling Ash (Boss Roar) | Dark grey ash particles rain from top of screen |
| Spectral Fire (Background) | Cold blue flame emitters on building props |

---

### Week 3–4 Deliverable Checklist

- [ ] Level 2 color additions added to the shared Style Guide
- [ ] Kaito spirit form: Phantom Slash + Parry Flash + Idle Echo sprites
- [ ] Phased Ashigaru: Solid + Phased + Attack sprite sheets
- [ ] Crimson Archer: Idle + Fire sprites; Spirit Arrow sprite
- [ ] The Captain (Boss): Idle + Smash + Sweep + Roar + Death sprites
- [ ] Phantom Strike Impact + Parry Spark particle effects set up in Godot

---

---

## 🗺️ The World-Builder (Level Design & UI)

### What You're Building for Level 2

You are building a **burning, destroyed village** and wiring up the new combat flow. Shadow Gates mean progression is now gated by combat, not just movement. The level must feel claustrophobic and aggressive compared to Level 1's open grove.

---

### Task 1 — Level 2 Scene Tree Structure

Set up `Level_2.tscn` with this hierarchy:

```
Level_2 (Node2D)
├── CanvasModulate          ← Slightly lighter than L1; cold blue tint #1A1A2E
├── TileMapLayer            ← Village platforms, rooftops, burning walls
├── Zones (Node2D)
│   ├── Zone_1 (Node2D)
│   │   ├── ShadowGate_1 (Area2D, zone_id=1)
│   │   ├── PhasedAshigaru_1 (instanced, zone_id=1)
│   │   └── PhasedAshigaru_2 (instanced, zone_id=1)
│   ├── Zone_2 (Node2D)
│   │   ├── ShadowGate_2 (Area2D, zone_id=2)
│   │   ├── CrimsonArcher_1 (instanced, zone_id=2)
│   │   └── PhasedAshigaru_3 (instanced, zone_id=2)
│   └── Zone_3 (Node2D)
│       └── BossArena (separate scene instance)
├── Events (Node2D)
│   ├── KaitoAwakeningTrigger (Area2D)  ← Triggers Kaito's appearance cutscene
│   ├── LevelEnd (Area2D)               ← Loads Level_3 scene; disabled until boss is defeated
│   └── DialogueTrigger_1..N (Area2D)
├── Player (instanced Player.tscn)
├── HUD (CanvasLayer)
│   ├── HealthBar (ProgressBar)
│   ├── GloomMeter (ProgressBar)
│   ├── SoulCounter (Label)            ← NEW: shows souls collected vs required for next gate
│   └── DialogueBox (PanelContainer)
└── AudioManager (AutoLoad reference)
```

> **Rule:** Each `Zone` Node2D groups its Shadow Gate with its enemies. The `zone_id` exported variable on both the gate and enemies is how the Architect's script pairs them without hardcoded references.

---

### Task 2 — New Tile Types for Level 2

Add these to the existing tileset:

| Tile Type | Color (Graybox) | Purpose |
|-----------|----------------|---------|
| Rooftop Platform | Dark Blue `#1A2A4A` | Elevated platforms for Crimson Archers |
| Burning Wall | Orange `#CC4400` | Impassable background walls; visual only |
| Shadow Gate (Tile) | Deep Red `#3D0000` | Temporary blocking tile; replaced when gate dissolves |
| Ash Pile (Hazard) | Grey `#666666` | Slows Ren's movement speed by 30% on contact |

---

### Task 3 — The Village Golden Path (4-Minute Route)

Build the level as a **mixed left-to-right and vertical** path across burning village courtyards:

| Beat | What Happens | Design Note |
|------|-------------|-------------|
| **Start** | Ren & Hana enter the burning village gate | Brief flat section; no enemies. KaitoAwakeningTrigger Area2D fires here |
| **Beat 1** | Zone 1 — Courtyard with 2 Phased Ashigaru + Shadow Gate | Open space; teach player to wait for Solid state or use Hana's light |
| **Beat 2** | Rooftop section — Crimson Archers on high platforms | Force Ren to use Upward Slash or navigate around; introduce Parry |
| **Beat 3** | Zone 2 — Burning dojo with mixed Archers + Ashigaru + Shadow Gate | Tightest space; player must combo and manage position |
| **Beat 4** | Short corridor leading to the Manor | No enemies; dialogue trigger. Kaito speaks. Breather moment |
| **Climax** | Zone 3 — Boss Arena at the Manor | Flat arena, one screen wide; LevelEnd Area2D activates after boss death |

> **Rule:** Shadow Gate zones must be large enough that the player cannot cheese enemies from outside the zone boundary. Each zone should feel like a sealed arena.

---

### Task 4 — HUD Updates

Add the Soul Counter to the existing HUD:

| UI Element | Node Type | Position | Notes |
|------------|-----------|----------|-------|
| Soul Counter | `Label` | Top-center | Format: `⛩ 2 / 3`; updates on `soul_released` signal |

- The Soul Counter should only be **visible** when the player is inside an active zone (listen to a `zone_entered` / `zone_exited` signal from the World-Builder's Zone nodes).
- Keep the same Health Bar and Gloom Meter from Level 1 — just confirm they still connect to signals correctly.
- Add a **Boss Health Bar** (`ProgressBar`, top-center, full width) that appears only during the boss fight. Connect it to the Architect's `boss_phase_changed` signal.

---

### Week 3–4 Deliverable Checklist

- [ ] `Level_2.tscn` scene tree built with Zone grouping structure
- [ ] Rooftop tiles painted; village graybox Golden Path is walkable end-to-end
- [ ] 3 Shadow Gates placed with correct `zone_id` matching their zone's enemies
- [ ] `KaitoAwakeningTrigger` and `LevelEnd` Area2Ds placed correctly
- [ ] `LevelEnd` Area2D disabled by default; enabled only on `boss_defeated` signal
- [ ] Soul Counter Label added and toggled by zone entry/exit
- [ ] Boss Health Bar added and hidden by default

---

---

## 🏮 The Atmosphere Lead (Audio, Narrative & Lighting)

### What You're Creating for Level 2

Level 2's atmosphere is **aggressive and mournful**. The quiet loneliness of the grove is gone. Now the world burns with cold fury. Your lighting makes the village feel like a battlefield frozen in time. Your sound should feel impactful and weighty. Your dialogue channels Kaito's controlled rage and Ren's grief.

---

### Task 1 — Lighting Overhaul

Level 2 requires a richer lighting setup than Level 1:

**Step 1 — Background Spectral Fire:**
- Add multiple `PointLight2D` nodes on burning building props (coordinate with World-Builder).
- Settings per flame:

| Property | Value |
|----------|-------|
| Color | `#1A6FFF` (cold blue) |
| Energy | `0.8` |
| Texture Scale | `1.2` |
| Shadow Enabled | `false` |

- Animate each flame light's `energy` between `0.6` and `1.0` using a looping `Tween` or `AnimationPlayer` for a flickering effect.

**Step 2 — Kaito's Aura (Player-Attached):**
- Add a second `PointLight2D` as a child of Ren (separate from Hana's gold light).
- Default Energy: `0.4` (barely visible — Kaito is present but restrained).
- On `Phantom Strike` activation: Tween Energy → `2.5` then back to `0.4` over 0.25 seconds.
- Color: `#00BFFF`.

**Step 3 — Boss Arena Lighting:**
- Dim the CanvasModulate further to `#0D0018` during the boss fight.
- The Boss itself should carry a `PointLight2D` with a sickly purple color (`#4B0082`, Energy `1.5`) so it always reads against the darkness.

> **Rule:** The village should feel brighter than the grove (due to the fires), but colder and more hostile. Gold (Hana) and Blue (Kaito) should compete on screen.

---

### Task 2 — Top 5 Sound Effects to Source This Week

Find these from **Freesound.org** or **Kenney.nl** (CC0 only):

| # | Sound | Where to Use | Search Term |
|---|-------|-------------|-------------|
| 1 | **Heavy sword impact** | Phantom Strike hit | `"sword impact heavy"` or `"metal crash"` |
| 2 | **Parry ring** | Successful deflect | `"sword clang"` or `"metal deflect"` |
| 3 | **Shadow Gate shatter** | Gate dissolving | `"glass shatter"` or `"crystal break"` |
| 4 | **Boss roar** | Boss Roar state | `"monster roar"` or `"demon growl"` |
| 5 | **Cold spectral fire loop** | Background ambience for village | `"fire cold"` or `"eerie fire loop"` |

**Implementation notes:**
- Phantom Strike: trigger from the `kaito_phantom_strike` signal. Layer `sfx_sword_impact` with a brief `AudioStreamPlayer` screen-shake call (call into the Architect's camera shake function).
- Parry: play `sfx_parry_ring` from `AudioManager`. Pitch scale randomized `0.95–1.05`.
- Village ambience: replace the grove whisper loop from Level 1 with the cold fire loop at `Volume DB: -14`.

Update `AudioManager.gd` with new functions:

```gdscript
@onready var sfx_phantom_strike = $PhantomStrike
@onready var sfx_parry = $ParryRing
@onready var sfx_gate_shatter = $GateShatter
@onready var sfx_boss_roar = $BossRoar
@onready var ambient_village = $AmbientVillage

func play_phantom_strike():
    sfx_phantom_strike.pitch_scale = randf_range(0.95, 1.05)
    sfx_phantom_strike.play()

func play_parry():
    sfx_parry.pitch_scale = randf_range(0.95, 1.05)
    sfx_parry.play()

func play_gate_shatter():
    sfx_gate_shatter.play()

func play_boss_roar():
    sfx_boss_roar.play()

func start_village_ambience():
    ambient_village.play()

func stop_village_ambience():
    ambient_village.stop()
```

---

### Task 3 — Level 2 Dialogue Script

| Trigger Location | Speaker | Dialogue |
|-----------------|---------|---------|
| Level start (entering village) | **Hana** | *"Ren... this is home. Or it was. I don't want to see it like this."* |
| Kaito Awakening Trigger | **Kaito** *(explosive, low)* | *"They burned it. They burned ALL of it. Give me the sword, Ren. Give me the sword."* |
| First Shadow Gate | **Ren** | *"There — a barrier made of their grudge. We have to cut through it. The only way is forward."* |
| First Phased Ashigaru encounter | **Kaito** | *"Don't waste your strikes. Wait. Let her light touch them first."* |
| Crimson Archers appear | **Hana** | *"Ren — the roof! They're still fighting. They don't even know they're dead."* |
| Before Boss Arena | **Ren** | *"The Captain. He gave the order. He killed us. He doesn't get to just... haunt our home."* |
| Boss Phase 2 (50% HP) | **Kaito** *(cold fury)* | *"He's exposed. Now, Ren. STRIKE."* |
| Boss defeated | **Kaito** | *"...It's done. The key. Take it. We're not finished."* |

> **Writing Rule:** Kaito's lines are short, controlled, and military. He does not grieve out loud. His pain shows in his precision. Never give him more than one sentence.

---

### Task 4 — Boss Music Cue

This is your first time triggering a music change mid-level. Use the Architect's `boss_phase_changed` signal:

- **Before Boss:** Continue the village ambience at `Volume DB: -14`.
- **On Boss Entrance:** Fade ambience to `-40 DB` over 1 second. Start a new looping `AudioStreamPlayer` (`BossTheme`) — a low taiko drum loop with a rising tension string.
- **On Phase 2 (50% HP):** Increase BossTheme pitch_scale to `1.1` and `Volume DB` to `0` for a surge of urgency.
- **On Boss Defeated:** Stop BossTheme immediately. Play a single, long taiko strike fade to silence.

---

### Week 3–4 Deliverable Checklist

- [ ] Background flame `PointLight2D` nodes placed and flickering (coordinate with World-Builder)
- [ ] Kaito's blue `PointLight2D` aura on Player — reacts to `kaito_phantom_strike` signal
- [ ] Boss arena lighting dimmed; Boss carries its own `PointLight2D`
- [ ] Top 5 sound effects sourced and imported into `/Assets/Audio/SFX/`
- [ ] `AudioManager.gd` updated with Level 2 functions
- [ ] Level 2 dialogue script shared with World-Builder for trigger placement
- [ ] Boss music cue implemented: fade ambience → boss theme → phase 2 surge → death silence

---

---

## 📅 Week 3–4 Team Sync Checklist

At the end of Week 4, the team should be able to run `Level_2.tscn` and see this working:

| Check | Owner |
|-------|-------|
| ✅ Kaito's Spectral Edge combo fires and has correct range | Architect |
| ✅ Phantom Strike has hit-stop and emits `kaito_phantom_strike` signal | Architect |
| ✅ Parry window deflects arrows and stuns melee enemies | Architect |
| ✅ Shadow Gates dissolve when zone enemies are defeated | Architect |
| ✅ Phased Ashigaru solidifies inside Hana's light | Architect |
| ✅ Boss runs Smash → Sweep → Roar loop; enters Phase 2 at 50% HP | Architect |
| ✅ Kaito spirit form, Phased Ashigaru, and Boss sprites replace placeholders | Visual Artist |
| ✅ Phantom Strike particle burst fires on impact | Visual Artist |
| ✅ Village graybox walkable with Shadow Gates and rooftops correct | World-Builder |
| ✅ Soul Counter shows and hides per zone; Boss Health Bar appears in arena | World-Builder |
| ✅ Village cold-fire ambience plays on level start | Atmosphere Lead |
| ✅ Kaito's blue PointLight2D pulses on Phantom Strike | Atmosphere Lead |
| ✅ Boss music fades in on arena entry and shifts on Phase 2 | Atmosphere Lead |

> **Reminder:** Do not start Level 3 until this checklist is 100% green. A full, polished Level 2 is a complete game loop on its own.
