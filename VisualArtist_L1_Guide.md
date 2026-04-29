# Visual Artist â€” Level 1 Implementation Guide
### The Three-Fold Debt | Godot 4.x

> **Your role:** The Architect has written all the code. The scenes run, but they look like grey boxes and capsule shapes.
> Your job is to open each scene, swap the placeholders for your artwork, and hook animations to the state machine â€” without touching a single line of GDScript.
>
> **Golden rule:** Never edit `.gd` files. If something needs a code change, tell the Architect.

---

## ðŸŽ¨ Part 0 â€” Before You Start: Project Setup

### Folder Structure
Place all your assets in the correct folders. The Architect's code references these paths indirectly through the Godot editor â€” wrong folders mean broken imports.

```
/Assets/
  /Sprites/
    /Player/        â† Ren sprite sheets go here
    /Hana/          â† Hana sprite goes here
    /Enemies/
      /HollowedAsh/ â† Ash walk + attack sheets
      /BambooLurker/â† Static + attack frames
      /GloomWisp/   â† Pulse animation frames
  /Particles/       â† Particle textures (tiny PNGs)
```

### Import Settings (Critical)
Every sprite PNG you import **must** have these settings or it will look blurry in-game:

1. In the **FileSystem** dock, select your PNG.
2. Open the **Import** tab (top of the editor).
3. Set:
   - **Filter:** `Nearest` (not Linear â€” Linear blurs pixel art)
   - **Mipmaps:** `Off`
   - **Compress Mode:** `Lossless`
4. Click **Reimport**.

> Do this for every single PNG before placing it in a scene.

### Color Palette â€” Lock This In First
Share this file in your team's Google Drive before drawing anything.

| Element | Hex | Usage |
|---------|-----|-------|
| World BG | `#0D0A1A` | Sky/background |
| Bamboo | `#D0E8FF` at 30% opacity | Environment |
| Ren (body) | `#1A1A2E` | Player silhouette |
| Hollow Ash | `#5A5A6A` | Enemy body |
| Ash eyes | `#FF2222` | Enemy eyes glow |
| Hana (light) | `#FFD700` | Lantern warm gold |
| Kaito (echo) | `#00BFFF` | Neon ice blue flash |
| Gloom | `#1A0030` | Dark zones |

---

## ðŸ‘¤ Part 1 â€” Ren (`Player.tscn`)

### What the Architect's Code Expects
The `Player.gd` script has **5 states**. Each state should play a different animation. The `AnimatedSprite2D` node you add must have animations named **exactly** as listed â€” spelling and case matter.

| Code State | Animation Name You Must Create | When It Plays |
|------------|-------------------------------|---------------|
| `IDLE` | `"idle"` | Ren stands still |
| `RUN` | `"run"` | Left/right arrow held |
| `JUMP` | `"jump"` | Space bar, rising |
| `FALL` | `"fall"` | After jump apex, descending |
| `ROLL` | `"roll"` | Shift key dodge |

### Sprite Sheet Specs

| Animation | Canvas per frame | Frame count | FPS | Loop |
|-----------|-----------------|-------------|-----|------|
| `idle` | 64 Ã— 96 px | 2 | 4 | Yes |
| `run` | 64 Ã— 96 px | 4 | 10 | Yes |
| `jump` | 64 Ã— 96 px | 1 | 1 | No |
| `fall` | 64 Ã— 96 px | 1 | 1 | No |
| `roll` | 64 Ã— 96 px | 3 | 12 | No |

**Drawing notes:**
- **Idle:** Two frames â€” frame 1 is neutral pose, frame 2 has chest slightly higher (breathing bob). The broken katana (shorter than a full sword) hangs at his side.
- **Run:** Exaggerated forward lean. Broken sword trails behind. Big arm swing. Feet leave the ground on frames 2 and 4.
- **Jump:** Single frame. Tucked knees, sword arm extended upward, cape/clothing billows down.
- **Fall:** Single frame. Arms slightly spread, head down, body in descent posture. Slightly different from Jump.
- **Roll:** Frame 1 = enter crouch. Frame 2 = full horizontal spin (add motion blur smear). Frame 3 = exit low crouch.

### Step-by-Step: Adding Ren's Art to the Scene

1. In the **FileSystem** dock, double-click `Player.tscn` to open it.
2. In the **Scene** dock, find the root `CharacterBody2D` node. It will have a grey square placeholder.
3. **Add a child node:** Right-click the root â†’ **Add Child Node** â†’ search `AnimatedSprite2D` â†’ click **Add**.
4. Rename it exactly: `AnimatedSprite2D`
5. In the **Inspector**, under `Sprite Frames`, click **[empty]** â†’ **New SpriteFrames**.
6. Click the `SpriteFrames` resource to open the animation editor at the bottom of the screen.
7. For each animation:
   - Click the `+` button to add a new animation. Name it exactly (e.g., `idle`).
   - Click **Add Frames from Sprite Sheet** and select your PNG.
   - Set the grid dimensions (e.g., 4 columns Ã— 1 row for a 4-frame horizontal sheet).
   - Select the frames and click **Add X Frames**.
   - Set the FPS as per the table above.
   - Check **Loop** only for `idle` and `run`.
8. Select the `AnimatedSprite2D` node. In Inspector, set **Position** to `Vector2(0, 0)`. Adjust Y so the sprite feet align with the `CollisionShape2D` capsule bottom.

### Connecting Animations to Code (No Code Needed!)
The Architect's script drives movement but does **not** auto-play animations yet â€” you need to add a small bridge. Ask the Architect to add these lines to `state_idle`, `state_run`, etc., OR you can do it yourself safely:

In each state function in `Player.gd`, after the Architect's existing code, add:
```gdscript
# In state_idle():
$AnimatedSprite2D.play("idle")

# In state_run():
$AnimatedSprite2D.play("run")
if get_input_dir() < 0:
    $AnimatedSprite2D.flip_h = true
else:
    $AnimatedSprite2D.flip_h = false

# In state_jump():
$AnimatedSprite2D.play("jump")

# In state_fall():
$AnimatedSprite2D.play("fall")

# In state_roll():
$AnimatedSprite2D.play("roll")
```

> `flip_h = true` mirrors the sprite when running left â€” you only need to draw right-facing frames.

### Kaito's Echo Flash (Visual Only)
When Kaito's passive auto-parry triggers, the `kaito_echo_triggered` signal fires. The Atmosphere Lead handles the sound and light, but you should prepare a visual:

- Add a second `AnimatedSprite2D` named `KaitoEchoSprite` as a child of the root.
- Create one animation named `"flash"` â€” 3 frames of a spectral hand/arm outline in ice blue (`#00BFFF`), 12 FPS, no loop.
- Set its **Modulate** to `Color(0, 0.75, 1, 0.8)`.
- Default **Visible = false**.
- Tell the Atmosphere Lead: "Connect `kaito_echo_triggered` signal â†’ make `KaitoEchoSprite` visible, play `flash`, then hide again."

### Testing Ren's Art âœ…
Run the scene (`F5` or play button). Check:
- [ ] Idle animation plays and loops when standing still
- [ ] Run animation plays when moving left or right
- [ ] Sprite flips horizontally when running left
- [ ] Jump animation shows during upward movement
- [ ] Fall animation shows while descending
- [ ] Roll animation plays during the 0.4s dodge
- [ ] Sprite feet align with the floor (not floating or clipping)
- [ ] No blurry edges â€” if it looks blurry, re-check import settings (Nearest filter)

---

## ðŸ® Part 2 â€” Hana (`Hana.tscn` or child of Player)

### What the Architect's Code Expects
`Hana.gd` uses `lerp()` to follow Ren with a ghostly lag. It has **no animation states** â€” Hana always floats. Her `HanaLightRadius` is an `Area2D` child that the Atmosphere Lead will turn into a `PointLight2D`.

You only need **one animation:** `"float"` â€” a subtle lantern flame flicker.

### Sprite Specs

| Animation | Canvas | Frames | FPS | Loop |
|-----------|--------|--------|-----|------|
| `float` | 48 Ã— 48 px | 2 | 6 | Yes |

**Drawing notes:**
- Frame 1: Lantern with a calm flame. Round body, ghostly wisp tail drifting down.
- Frame 2: Flame flickers slightly taller/brighter. Tail in slightly different position.
- Do NOT animate the bob/sway â€” the Architect's `lerp()` creates the movement automatically.
- Color: Warm gold `#FFD700` with soft inner white `#FFFFF0`. No hard outlines â€” use soft, glowing edges.

### Step-by-Step: Adding Hana's Art

1. Open `Player.tscn`. In the Scene dock, find the `Hana` node (it's a child of the Player root, type `Node2D`).
2. Add child â†’ `AnimatedSprite2D`. Name it `AnimatedSprite2D`.
3. Create `SpriteFrames` with one animation: `"float"`, 2 frames, 6 FPS, looping.
4. In `Hana.gd`'s `_ready()` function, ask the Architect to add: `$AnimatedSprite2D.play("float")` â€” or add it yourself.
5. Set **Position** to `Vector2(0, -10)` so Hana floats slightly above Ren's shoulder.

### Testing Hana's Art âœ…
- [ ] Hana's lantern flame flickers (2-frame loop visible)
- [ ] Hana floats and follows Ren with a smooth lag â€” she should feel "behind" him slightly
- [ ] Hana does NOT snap â€” movement is gradual
- [ ] Hana's sprite is visually distinct from the dark background even without the PointLight2D

---

## ?? Part 3 — Hollowed Ash (`HollowedAsh.tscn`)

### What the Architect's Code Expects
`HollowedAsh.gd` has **3 states**. Each needs a matching animation name on the `AnimatedSprite2D`:

| Code State | Animation Name | When It Plays |
|------------|---------------|---------------|
| `PATROL` | `"walk"` | Enemy paces between patrol markers |
| `CHASE` | `"walk"` | Enemy runs toward Ren (same anim, faster) |
| `ATTACK` | `"attack"` | Enemy lunges — hitbox activates at frame 3 |

> CHASE uses the same `"walk"` animation as PATROL. The Architect's code changes the speed; you only need one walk cycle.

### Sprite Specs

| Animation | Canvas | Frames | FPS | Loop |
|-----------|--------|--------|-----|------|
| `walk` | 48 × 80 px | 4 | 8 | Yes |
| `attack` | 48 × 80 px | 4 | 10 | No |

**Drawing notes:**
- Featureless grey human silhouette (`#5A5A6A`). No face. Two glowing red eye sockets (`#FF2222`).
- Carries a ghostly pike — faint, translucent, like solid smoke.
- **Walk:** Slow shamble. Stiff arms. Feet drag slightly.
- **Attack:** Frame 1-2 = wind-up (pike raises). Frame 3 = LUNGE (pike fully extended forward — this is when the hitbox activates). Frame 4 = return to neutral.
- The hitbox in code activates when `attack_timer` is between 0.5s and 0.2s remaining. Frame 3 of your attack animation must visually match this timing.

### Step-by-Step: Adding Ash's Art

1. Open `HollowedAsh.tscn`.
2. In the Scene dock, the root is a `CharacterBody2D`. Add child ? `AnimatedSprite2D`.
3. Create `SpriteFrames`: add `"walk"` (4 frames, 8 FPS, loop) and `"attack"` (4 frames, 10 FPS, no loop).
4. Add animation playback in code — ask the Architect to add to `state_patrol` and `state_chase`:
   ```gdscript
   $AnimatedSprite2D.play("walk")
   $AnimatedSprite2D.flip_h = direction < 0
   ```
   And in `start_attack()`:
   ```gdscript
   $AnimatedSprite2D.play("attack")
   ```
5. Delete the grey placeholder `ColorRect` if one exists.

### Testing Hollowed Ash ?
- [ ] Enemy walks back and forth during PATROL — sprite faces correct direction
- [ ] Enemy sprite flips when direction reverses
- [ ] On CHASE, sprite continues walking (faster movement, same animation)
- [ ] Attack animation plays when enemy lunges — pike visually extends on frame 3
- [ ] Enemy disappears (`queue_free`) on death — no art remains

---

## ?? Part 4 — Bamboo Lurker (`BambooLurker.tscn`)

### What the Architect's Code Expects
`BambooLurker.gd` has **2 states**:

| Code State | Animation Name | Duration |
|------------|---------------|----------|
| `IDLE` | `"idle"` | Default — looks like regular bamboo |
| `TRIGGERED` | `"attack"` | 0.8 seconds total; hitbox active frames 0.3s–0.1s remaining |

### Sprite Specs

| Animation | Canvas | Frames | FPS | Loop |
|-----------|--------|--------|-----|------|
| `idle` | 32 × 128 px | 1 | 1 | Yes |
| `attack` | 32 × 128 px | 3 | 10 | No |

**Drawing notes:**
- Looks exactly like a bamboo stalk when in IDLE — players should not recognize it as an enemy immediately. Dark green/grey tint matching the environment.
- **Attack frame 1:** Bamboo bends backwards (tension).
- **Attack frame 2:** SNAP forward — full whip. This is the dangerous frame (hitbox active).
- **Attack frame 3:** Bamboo settling back to upright.
- The hitbox activates when `attack_timer` is between 0.3s and 0.1s. Frame 2 must be in that window at 10 FPS (frame 2 starts at 0.2s into the animation).

### Step-by-Step: Adding Lurker's Art

1. Open `BambooLurker.tscn`. Root is `Node2D` (not CharacterBody2D — it does NOT move).
2. Add child ? `AnimatedSprite2D`.
3. Create `SpriteFrames`: `"idle"` (1 frame, loop) and `"attack"` (3 frames, 10 FPS, no loop).
4. Ask the Architect to add in `_ready()`: `$AnimatedSprite2D.play("idle")`
5. And in `_on_detection_body_entered()` (when triggered): `$AnimatedSprite2D.play("attack")`

### Testing Bamboo Lurker ?
- [ ] In IDLE: looks like ordinary bamboo (not obviously an enemy)
- [ ] When Ren approaches: attack animation fires once
- [ ] Attack frame 2 (the whip frame) visually aligns with when Ren takes damage
- [ ] Animation does not loop — lurker returns to IDLE pose after attack

---

## ?? Part 5 — Gloom Wisp (`GloomWisp.tscn`)

### What the Architect's Code Expects
`GloomWisp.gd` has **no state enum** — it always drifts toward Hana. It `queue_free()`s when it touches `HanaLightRadius`. You only need one looping animation.

### Sprite Specs

| Animation | Canvas | Frames | FPS | Loop |
|-----------|--------|--------|-----|------|
| `"pulse"` | 24 × 24 px | 2 | 6 | Yes |

**Drawing notes:**
- A small, dark orb. Deep purple-black (`#1A0030`) with a faint dark violet inner glow (`#4B0082`).
- Frame 1: Orb at normal size.
- Frame 2: Orb slightly larger and darker — a slow pulse, like breathing.
- Keep it small and subtle. It should feel threatening but not obvious.

### Step-by-Step

1. Open `GloomWisp.tscn`. Root is `Area2D`.
2. Add child ? `AnimatedSprite2D`.
3. Create `SpriteFrames`: `"pulse"` (2 frames, 6 FPS, loop).
4. Ask the Architect to add in `_ready()`: `$AnimatedSprite2D.play("pulse")`

### Testing Gloom Wisp ?
- [ ] Wisp pulses with a slow, dark rhythm
- [ ] Wisp visually moves toward Hana (glides, no jumping)
- [ ] Wisp disappears when it touches Hana's light radius (no art remains)

---

## ? Part 6 — Particle Effects (GPUParticles2D)

These are set up entirely inside the Godot editor — no drawing required, just configuration.

### Effect 1: Hana's Ambient Glow
Add as a child of the `Hana` node in `Player.tscn`.

| Property | Value |
|----------|-------|
| Node type | `GPUParticles2D` |
| Amount | 12 |
| Lifetime | 1.5 |
| Emitting | true (always on) |
| **Process Material ? Direction** | `Vector2(0, -1)` (drift upward) |
| **Spread** | 30° |
| **Initial Velocity** | Min: 5, Max: 15 |
| **Scale** | Min: 1, Max: 3 |
| **Color** | Start: `#FFD700` (gold), End: transparent |
| Texture | A tiny 4×4 white circle PNG you draw |

### Effect 2: Gloom Wisp Trail
Add as a child of the `GloomWisp` root in `GloomWisp.tscn`.

| Property | Value |
|----------|-------|
| Amount | 8 |
| Lifetime | 0.8 |
| Emitting | true |
| Direction | `Vector2(0, -1)` |
| Spread | 60° |
| Initial Velocity | Min: 2, Max: 8 |
| Color | Start: `#4B0082` (dark violet), End: transparent |

### Effect 3: Ren's Roll Dust
Add as a child of the `Player` root in `Player.tscn`. This one fires as a **one-shot** burst.

| Property | Value |
|----------|-------|
| Amount | 6 |
| Lifetime | 0.3 |
| **One Shot** | true |
| **Emitting** | false (starts off) |
| Direction | `Vector2(0, -0.5)` |
| Spread | 90° |
| Initial Velocity | Min: 20, Max: 60 |
| Color | `#888888` grey, End: transparent |

Name this node `RollDustParticles`. Ask the Architect to add in `start_roll()`:
```gdscript
if has_node("RollDustParticles"):
    $RollDustParticles.restart()
```

### Testing Particles ?
- [ ] Golden particles drift upward from Hana — subtle, not distracting
- [ ] Dark smoke trails behind the Gloom Wisp as it moves
- [ ] Grey dust burst appears at Ren's feet when rolling — fires once, not looping

---

## ?? Part 7 — Final Visual Checklist (Full Scene Test)

Run `Level_1.tscn`. Walk through the entire level and verify:

### Ren
- [ ] All 5 animations play and transition correctly with no "stuck" poses
- [ ] Sprite flips correctly left/right — never shows backwards art
- [ ] Roll dust particle fires on dodge
- [ ] Kaito echo flash (blue outline) appears briefly when echo triggers

### Hana
- [ ] Flame flicker animation plays
- [ ] Lantern follows Ren with visible lag — she "leans behind"
- [ ] Golden particles drift upward from her

### Hollowed Ash
- [ ] Walks with correct facing direction
- [ ] Attack animation lunge frame aligns with Ren taking damage
- [ ] Disappears cleanly on death (no stuck art)

### Bamboo Lurker
- [ ] Blends into bamboo background in IDLE
- [ ] Attack snap is fast and readable

### Gloom Wisp
- [ ] Dark pulse animation visible
- [ ] Dissolves when hitting Hana's light

### General
- [ ] No sprite is blurry (all imports use Nearest filter)
- [ ] All sprites fit within their collision shapes — nothing clips through floors
- [ ] Color palette is consistent — no element uses a color outside the locked palette

---

## ?? Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Animation name wrong case (`"Idle"` vs `"idle"`) | Always lowercase — matches the code string exactly |
| Sprite floats above floor | Adjust `AnimatedSprite2D` Position Y until feet touch the CollisionShape bottom |
| Sprite looks blurry | FileSystem ? Import tab ? Filter: Nearest ? Reimport |
| Roll animation loops forever | Set the `roll` animation **Loop = off** in SpriteFrames editor |
| Enemy sprite doesn't flip | Confirm the Architect has added `flip_h = direction < 0` in the walk state |
| Attack art doesn't match hitbox timing | Adjust FPS of attack animation — the lunge frame must fall at the right time window |
| Particles are too bright / distracting | Lower the particle `Amount` and set Color end to fully transparent |
