# Ideation

## **Narrative Title: The Three-Fold Debt**

### **The Justification (The "Why")**

In feudal Japan, the **Kodoku Curse** (蠱毒) is one of the darkest forbidden arts. When a lord wants to destroy an entire bloodline without leaving a traceable enemy, he commissions the ritual execution of a family. Their souls — still bound by love and duty — are cursed to fuse into a single, mindless **Gashadokuro**: a giant vengeful skeleton that consumes everything it hates. The curse does not require the family's consent. It requires only their death.

The **Inoue siblings** — Kaito, Ren, and Hana — were betrayed and executed by their own Lord, **Daimyo Sorin Ashikaga**, in the bamboo grove outside their home village. Their bond as a family was so powerful that even in death, they resisted the merging. But the Kodoku Curse is relentless. It pulls them toward each other, and toward the **Pit of Yomi** (the Japanese underworld), where the merge will complete in darkness.

They have one chance. The **Celestial Forge** — an ancient, sacred furnace at the peak of Mount Urashima — can sever spiritual chains if its flame is used before the **Ebon Moon** rises. The Ebon Moon is a total lunar eclipse that occurs once every hundred years. On its night, the boundary between the spirit world and Yomi dissolves, and the curse gains enough power to force the merge.

They must reach the Forge before the eclipse. That is the only goal. That is the whole game.

---

### **The Three Siblings**

You play as **Ren**, the middle sibling, who acts as the physical "Vessel." Your two siblings accompany you as spirits. All three are always on screen, but only Ren is corporeal.

| Sibling | Role | Visual Identity | Godot Node | Mechanic |
|---------|------|-----------------|-----------|----------|
| **Kaito** (eldest) | The Steel | Blue spectral outline; samurai silhouette | `Node2D` child of Player, `top_level=true` | **Offense** — inhabits Ren's blade |
| **Ren** (middle) | The Vessel | Dark silhouette; broken katana | `CharacterBody2D` (player) | **Movement & Survival** |
| **Hana** (youngest) | The Light | Small golden lantern spirit | `Node2D` child of Player, `top_level=true` | **Defense & Utility** — sole light source |

**Kaito — "The Steel":**
- **Personality:** Stoic, military, controlled. His grief is cold fury. He speaks in single sentences, never paragraphs.
- **Narrative Arc:** He died shielding the other two from the first volley of arrows. He blames himself for not reacting faster. His debt is his siblings' lives.
- **Mechanic:** He inhabits Ren's broken blade as blue spirit energy. He is **fully slumbering in Level 1** and awakens at the start of Level 2 when Ren finds his shattered armor. All Kaito mechanics emit `kaito_*` signals.

**Ren — "The Vessel":**
- **Personality:** Hollow with survivor's guilt. He survived the massacre's first moments by reflex, which he reads as cowardice. His arc is accepting that he is the anchor — the reason his siblings can move at all.
- **Mechanic:** `CharacterBody2D` with a state machine: IDLE, RUN, JUMP, FALL, ROLL. He bridges his siblings' powers through player input. The **Gloom Meter** (0–100) is his primary survival constraint — it fills when he leaves Hana's radius, empties when he returns.

**Hana — "The Light":**
- **Personality:** Calm, warm, and heartbreakingly optimistic. Not naive — she knows they may fail — but she chooses hope as a deliberate act of will.
- **Mechanic:** She follows Ren using `lerp()` in `_physics_process()` with `top_level = true`. Her `PointLight2D` (warm gold, `#FFD580`, energy `1.2`) is the **only persistent light source** in the game. Her `HanaLightRadius` (`Area2D` + `CircleShape2D`, radius 150px) defines the safe zone. Gloom Wisps shrink her radius by 20% on contact.

---

### **The Core Game Loop**

Every encounter follows this single loop:
```
EXPLORE → ENCOUNTER → ADAPT → PROGRESS
```

The **color system** teaches it without text tutorials:
- **Gold on screen** → Hana is the answer (light, radius, platform, Gloom)
- **Blue on screen** → Kaito is the answer (combat, heavy strike, parry)
- **Black/Purple on screen** → Danger (Gloom, enemy, barrier)

### **The Ending: Three-Fold Debt, Three-Fold Choice**

The Forge only has enough Celestial Fire for **two** souls:

| Ending | Who Survives | Tone | Code Cost |
|--------|-------------|------|----------|
| **Sacrifice Ren** | Kaito & Hana ascend; Ren fades | Tragic, honourable | 1 scene, 2 buttons |
| **Siblings' Sacrifice** | Ren lives; Kaito & Hana fade | Bittersweet | 1 scene, 2 buttons |

Both endings use a `choice_screen.tscn` with two buttons and two outcome `Label` sequences. No cutscene engine required.

---

### **Why this is "Gamethon Friendly"**

| Design Decision | Hours Saved |
|----------------|------------|
| One player character; siblings are lightweight spirit nodes | ~30 hrs art |
| Siblings use `PointLight2D` + particles, not full rigs | ~20 hrs VFX |
| Gloom Meter = death timer (no complex health system in Level 1) | ~10 hrs code |
| Dialogue via `Label` pop-ups; no cutscene engine needed | ~15 hrs code |
| Shadow Gates = `queue_free()` on kill count | ~8 hrs design |
| Level 4 reuses palette-swapped Level 1–2 enemies | ~25 hrs art |

**Mandatory Color Palette — Lock Before Any Art is Produced:**

| Element | Hex | Used For |
|---------|-----|---------|
| Kaito (Ice Blue) | `#00BFFF` | All Kaito energy, strikes, parry flash |
| Hana (Warm Gold) | `#FFD700` | Lantern glow, safe zone, golden petals |
| Gloom (Purple-Black) | `#1A0030` | `CanvasModulate`, death zones, Gloom Meter fill |
| World Background | `#0D0A1A` | Sky and far background |
| Enemies (Ghost Grey) | `#5A5A6A` | Silhouette fill for all fodder enemies |
| Enemy Eyes (Danger Red) | `#FF2222` | Glowing accents on all enemy silhouettes |
| Hazard Zones | `#AA0000` | Hazard tiles, bottomless pits |

# Level 1

## **Level 1: The Narrative Arc**

### **The Opening: Mud and Memory**

The game begins with a silent screen. The only sound is rain and the rustle of bamboo. **Ren** wakes up face-down in the mud of a shallow grave. His armor is broken, and his katana is snapped at the hilt. He has no memory of the "Afterlife" yet—he just feels a crushing cold. As he stands, the screen is almost entirely black, representing his fading soul.

### **The Discovery: The Shattered Lantern**

Ren stumbles through the dark until he finds a small, glowing object caught in the roots of a massive bamboo tree. It is **Hana’s Soul-Lantern**. When he touches it, **Hana** emerges. She doesn't speak in words, but her light brings color back to the world. For the first time, Ren can see the "Spirit Grove"—the bamboo isn't green; it's a ghostly, translucent white.

### **The Progression: Finding the Path**

As Ren and Hana move deeper, the grove begins to "whisper." These are the echoes of the soldiers who betrayed them. The level is about **climbing out of the pit**. You aren't just moving right; you are moving *upward* through the ravines, following a trail of golden petals that Hana leaves behind.

### **The Climax: The First Memory**

At the end of the grove, Ren finds a discarded, blood-stained sash—his older brother **Kaito’s** headband. Touching it triggers a "Memory Flash" (a brief silhouette cutscene). The ground begins to shake as the **Gloom** (the physical manifestation of the curse) realizes a soul is trying to escape. Ren must reach the village gates just as the shadows try to swallow the grove whole.

## **The Enemies: Shadows of the Betrayal**

In Level 1, all enemies are "Fodder Spirits" — weak individually, dangerous in the dark. **None require complex combat to defeat; the primary threat is the Gloom Meter, not the enemies themselves.** The level teaches survival before it teaches fighting.

| Enemy | AI States | HP | Damage | Godot Node |
|-------|-----------|-----|--------|----------|
| **Hollowed Ash** | PATROL → CHASE → ATTACK | 30 | 10/hit | `CharacterBody2D` |
| **Bamboo Lurker** | IDLE → TRIGGERED | 20 | 15/hit | `Node2D` (static) |
| **Gloom Wisp** | SEEK (targets Hana) | 10 | 0 (to Ren) | `Area2D` |

**The Hollowed Ash:**
Spirits of low-ranking foot soldiers who died in the same massacre. Grey, faceless silhouettes with glowing red eye sockets and ghostly pikes.
- `PATROL`: Walk left and right between two `Marker2D` patrol points.
- `CHASE`: Triggered when Ren enters a `CircleShape2D` detection `Area2D` (radius 200px). Move toward Ren.
- `ATTACK`: When within 40px, play attack animation and spawn a hitbox for 0.3 seconds.
- **Design note:** These are slow and predictable. The threat is that the player may chase them out of Hana's light.

**The Bamboo Lurker:**
Spirits fused with the environment. Indistinguishable from bamboo stalks until triggered.
- `IDLE`: Static. No movement. No visual indicator beyond slightly wrong proportions.
- `TRIGGERED`: When Ren's `Area2D` enters proximity (radius 100px), play a "bend and whip" animation and spawn a forward hitbox for 0.2 seconds. One shot; does not reset.
- **Design note:** These are environmental hazards as much as enemies. Place them in corridors where the player will be watching the Gloom Meter, not the environment.

**The Gloom Wisp:**
Small dark orbs (24×24px) that exist solely to threaten Hana's light radius.
- Move toward Hana's `global_position` using `move_toward()` or `lerp()`.
- On contact with `HanaLightRadius` Area2D: call `hana.reduce_light(0.20)` to shrink her radius by 20%, then `queue_free()`.
- Does **not** damage Ren directly. This is intentional — it forces the player to protect Hana, not just themselves.
- **Design note:** Spawn Gloom Wisps in groups of 2. They are a time-pressure mechanic: if the player ignores 3 Wisps, Hana's radius becomes critically small.

## **The Abilities: The Bond Begins**

Level 1 is the tutorial. All abilities are focused on **survival and establishing the sibling dynamic**. Nothing should feel overpowered. The player should feel fragile — that fragility is the point.

### **Ren (The Physical Vessel)**

| Ability | Input | What It Does | Godot Implementation |
|---------|-------|-------------|---------------------|
| **Broken Edge** | Z / Attack | Fast, short-range stab. 1-hit, no combo. | Spawn hitbox `Area2D` for 0.15s |
| **Samurai Roll** | Shift | Short iframe dash. Negates damage during roll frames. | Set `is_rolling = true` for 0.4s; ignore `take_damage()` calls |

- Broken Edge reach: **40px** (deliberately short — forces the player to get close and value Hana's light).
- Roll iframes: **0.4 seconds** (exported variable; can be tuned in the inspector).
- Stamina: None in Level 1. Ren can roll freely. Stamina is a Level 2 consideration.

### **Hana (The Light)**

| Ability | Type | What It Does | Godot Implementation |
|---------|------|-------------|---------------------|
| **Spirit Halo** | Passive | Circular safe zone (radius 150px). Inside: enemies take +25% damage. Outside: Gloom fills. | `HanaLightRadius` `Area2D` + `gloom_changed` signal |
| **The Flare** | Active (F key) | Intensify glow for 2 seconds. Blinds all Hollowed enemies on screen (they stop and freeze). | Tween `PointLight2D.energy` to `3.0`; emit `hana_flare` signal for enemy scripts to listen |

- Flare cooldown: **10 seconds** (use a `Timer` node; display cooldown state on HUD).
- Flare does **not** affect Bamboo Lurkers (they have no eyes) or Gloom Wisps (they have no sight mechanic).

### **Kaito (The Steel — Slumbering)**

| Ability | Type | What It Does | Godot Implementation |
|---------|------|-------------|---------------------|
| **Vengeful Echo** | Passive (auto) | When Ren's HP drops below 25%, a 2s window opens. The next incoming hit is auto-parried. Kaito's spectral hand flashes. | `kaito_active` flag; `kaito_echo_triggered` signal |

- Kaito's Echo fires once per health-below-25% event. After it fires, `kaito_cooldown = true` prevents it re-triggering until Ren heals above 25%.
- The flash: a `PointLight2D` on the sword node, tweened from `energy 0` → `2.5` → `0` over 0.3 seconds.
- This mechanic is the player's first hint that Kaito exists. It is not explained. The player must notice it themselves.

> **Design Note for All Roles:** Level 1 must feel **quiet and lonely**. No music — only ambient sound. Save all heavy audio and visual polish for Level 2's boss fight. The loneliness of the grove is what makes the player care about Hana's lantern.

# Level 2

## **Level 2: The Narrative Arc**

### **The Opening: The Blue Inferno**

Ren and Hana emerge from the bamboo grove to find their home village. It is not exactly as it was in life; it is suspended in the exact moment of its destruction, burning eternally with cold, blue spectral flames. The environment is jagged—broken roofs, burning carts, and ash falling like snow.

### **The Discovery: The Reforged Blade**

At the village square, Ren finds the spot where Kaito died defending them. Kaito’s shattered armor rests in the ash. When Ren approaches, the broken katana in his hand reacts. **Kaito’s spirit bursts forth**, a towering silhouette of blue fire. He doesn't take physical form, but instead wraps his spirit around Ren’s broken sword, extending the blade with a glowing, spectral edge. Kaito is furious, and the hunt begins.

### **The Progression: Blood for Blood**

The stealth and survival elements of Level 1 take a back seat. Here, the paths are blocked by **Shadow Gates**—walls of cursed energy that can only be broken by absorbing the souls of the corrupted soldiers scattered through the village. Ren must clear out courtyards and burning dojos, relying on Kaito’s newfound strength to cut through the heavy armor of the spectral soldiers.

### **The Climax: The Traitor's Echo (Boss Fight)**

At the manor of the village headman, Ren confronts the "Echo" of the Captain who ordered their execution. The Captain has been twisted by the curse into a towering, horned Yokai. Defeating him doesn't bring peace, but it grants them the **Captain's Soul-Key**, which unlocks the path leading out of the village and up toward the mountain forge.

## **The Enemies: The Corrupted Vanguard**

Level 2 enemies are heavily armored and require **strategic use of Kaito** to defeat. Rolling past them is no longer always viable. The core design challenge is sequencing: use Hana to expose, then Kaito to destroy.

| Enemy | AI States | HP | Damage | Godot Node | Key Mechanic |
|-------|-----------|-----|--------|----------|--------------|
| **Phased Ashigaru** | PHASED ↔ SOLID (timed) | 50 | 15/hit | `CharacterBody2D` | Immune when phased; solidifies in Hana's light |
| **Crimson Archer** | IDLE → AIM → FIRE | 25 | 20/arrow | `Node2D` (stationary) | Projectile; reversed by Parry |
| **The Captain (Boss)** | SMASH → SWEEP → ROAR (loop) | 300 | 25/hit | `CharacterBody2D` | 3-phase; HP thresholds change the loop |

**The Phased Ashigaru:**
Spectre soldiers flickering in and out of physical reality as the curse destabilises them.
- Toggle between `PHASED` (transparent, immune) and `SOLID` (opaque, vulnerable) on a 3-second `Timer`.
- When `PHASED`: `modulate.a = 0.4`; set `is_phased = true`; all incoming hitbox collisions are ignored.
- When `SOLID`: `modulate.a = 1.0`; behave like Hollowed Ash (patrol → chase → attack).
- **Special rule:** When inside `HanaLightRadius`, force immediate transition to `SOLID`. Listen for `body_entered` from Hana's Area2D.
- **Kaito rule:** Phantom Strike hits them regardless of phase state.

**The Crimson Archer:**
Stationary on burning rooftops. Their arrows are unavoidable without moving or parrying.
- Detect Ren via `Area2D` detection zone (radius 300px). Fire a `SpiritArrow` every 2 seconds.
- `SpiritArrow` is an `Area2D` that moves in a straight line at 300px/s. On hitting Ren: `ren.take_damage(20)`.
- **Parry rule:** If Ren successfully parries while arrow is in flight, the arrow's `direction` reverses and `is_reversed = true`. If a reversed arrow hits the Archer, it takes 25 damage.
- **Design note:** Place Archers high enough that normal attacks cannot reach. Teach the player that Upward Slash or Parry are required.

**The Captain (Level 2 Boss):**
The Echo of the officer who gave the execution order. A towering, horned Yokai with a Kanaō (spiked iron club).
- **Boss HP:** 300 (exported). **Boss damage:** 25/hit (exported).
- **Attack pattern loop** (repeats, speeding up slightly after each full cycle):
  1. `SMASH`: Slow telegraphed overhead slam. Hitbox spawns at landing point. 1.2s wind-up.
  2. `SWEEP`: Ground-level sweep from one side of the arena to the other. 0.8s sweep duration.
  3. `ROAR`: Boss pauses; falling ash rains from the top of screen. Standing outside Hana's light during Roar deals 5 damage/second.
- On reaching **50% HP**: emit `boss_phase_changed(2)` signal; increase attack frequency by 20%; Boss gains red glow overlay.
- On death: emit `boss_defeated` signal; disable `LevelEnd` Area2D lock.
- **Godot implementation:** Use `AnimationPlayer` to drive all 3 attack states. Do not hand-code the movement in `_physics_process` — it is slower and harder to tune.

## **The Abilities: The Steel Awakens**

With Kaito active, combat opens up completely. Ren transitions from a desperate survivor into a lethal warrior. The player should feel the power increase immediately.

### **Ren (The Physical Vessel)**

| Ability | Input | What It Does | Godot Implementation |
|---------|-------|-------------|---------------------|
| **Spectral Edge (Combo)** | Z (chain) | 3-hit combo; each hit extends range with Kaito's blue energy | Spawn 3 sequential `Area2D` hitboxes; range doubles on hit 2 and 3 |
| **Upward Slash** | Up + Z | Launcher attack; hits enemies on platforms above Ren | Hitbox spawns above Ren for 0.2s |

- Spectral Edge reach: **40px → 60px → 80px** across the 3-hit combo (Kaito's energy extends with each strike).
- Upward Slash is **essential** for Crimson Archers. Teach it by placing the first Archer out of normal attack range.

### **Kaito (The Steel)**

| Ability | Input | What It Does | Godot Implementation |
|---------|-------|-------------|---------------------|
| **Phantom Strike** | X (heavy) | Delayed spirit-arms mirror the swing with massive force. Breaks shields and Shadow Gates. | Spawn large `Area2D`; 0.08s hit-stop on connect; emit `kaito_phantom_strike` signal |
| **Deflect (Parry)** | Hold Block before impact | Precise 0.15s window. Knocks projectiles back; stuns melee for 1s. | `is_parrying` flag; check incoming hitbox `body_entered` timing vs window |

- **Hit-stop:** On Phantom Strike connect, call `Engine.time_scale = 0` for 0.08 seconds, then restore. This is the single most impactful "juice" moment in the game. Do not skip it.
- **Parry window:** 0.15 seconds. Outside the window, the block still reduces damage by 50% but does not stun or reflect.
- Shadow Gates: any Phantom Strike hit on a `ShadowGate` `Area2D` calls `gate.add_soul()` directly (or via signal). One Phantom Strike counts as 3 souls.

### **Hana (The Light)**

| Ability | Type | What It Does | Godot Implementation |
|---------|------|-------------|---------------------|
| **Revealing Light** | Passive upgrade | Phased enemies inside the radius solidify **immediately** instead of waiting for their timer. | In `PhasedAshigaru.gd`, connect `HanaLightRadius.body_entered` to force `current_state = SOLID` |

> **Design Note for All Roles:** Keep the boss fight in a **single flat arena** (one screen wide). Do not build a large scrolling boss room. Spend implementation time on the feel of Phantom Strike — screen shake + hit-stop + loud audio = the most important 0.08 seconds in the game.

# Level 3

## **Level 3: The Narrative Arc**

### **The Opening: The Summit of the Ebon Moon**

Having conquered the echoes of their past in the village, the siblings reach the summit of the sacred mountain, where the Celestial Fire burns in an ancient stone forge. However, the sky turns a sickly, bruising purple as the "Ebon Moon" eclipses the sun. The **Kodoku Curse** reaches its peak, trying to violently pull the three souls together. The ground shatters, and gravity itself begins to warp.

### **The Climax: The Forge of Souls (Final Boss)**

There is no turning back. From the shattered earth, the "Gloom" from Level 1 erupts and solidifies into **The Amalgamation**—a massive, multi-armed demonic skeleton wearing the armor of a hundred dead samurai. It is the physical embodiment of the curse they are trying to escape.

### **The Ending: The Choice**

Once the beast is slain, the siblings approach the Forge. The fire is weak. **It only has enough power to sever the curse and grant peace to two souls.** The game pauses, and the player (as Ren) is given a choice:

1. **Sacrifice Ren:** Ren throws himself into the Void, allowing Kaito and Hana to ascend.
2. **The Siblings' Sacrifice:** Kaito and Hana pour their remaining spirit energy into the Forge, pushing Ren back into the world of the living — returning him to life, but leaving them to fade.

Both endings resolve with a brief dialogue sequence and a static silhouette screen. No cutscene engine required — a `choice_screen.tscn` with two buttons and two outcome `Label` sequences is sufficient.

---

## **The Abilities: Perfect Synergy**

Level 3 is the payoff. Both siblings are fully awake and working in perfect tandem. The player should feel powerful and in control — but the boss demands mastery of every tool they have learned.

### **Ren (The Vessel)**

| Ability | Input | What It Does | Godot Implementation |
|---------|-------|-------------|---------------------|
| **Spirit Tether** | Q (hold to select sibling) | Hurl a sibling to a mid-air point, then dash to them | Launch sibling `Node2D` via `Tween`; on arrival, dash Ren to `sibling.global_position` |

- Tether cooldown: **3 seconds** per sibling independently (separate `Timer` nodes).
- The Spirit Tether is the **primary mobility tool** in Level 3, replacing the Samurai Roll from Level 1.
- Iframes remain active during the Tether dash (`is_rolling = true` during flight).

### **Kaito (The Steel)**

| Ability | Type | What It Does | Godot Implementation |
|---------|------|-------------|---------------------|
| **Meteor Dash** | Tether variant | Kaito flies to target; Ren dashes to him with a damaging aerial strike | Kaito `Node2D` tweens to target; Ren hitbox activates for 0.3s on arrival |

- Damage: **40 per Meteor Dash** (double a normal Phantom Strike).
- The boss's **Phase 3** can only be damaged by Meteor Dash — all ground attacks are ignored.
- Passes through Phase 2 and Phase 3 boss armor.

### **Hana (The Light)**

| Ability | Type | What It Does | Godot Implementation |
|---------|------|-------------|---------------------|
| **Spectral Anchor** | Tether variant | Hana flies to a target spot and becomes a solid glowing platform for 3 seconds | Set `hana.is_platform = true`; enable `StaticBody2D` collision shape for 3s then disable |

- Hana's platform can support Ren's weight while he attacks from above.
- **Phase 1 requirement:** The boss's mask can only be struck from above. Spectral Anchor is the only way to reach it.
- The 3-second duration is intentionally short — it forces the player to act decisively.

## **The Boss Fight: The Amalgamation**

The Amalgamation is the physical manifestation of what the Inoue siblings would become if the Kodoku Curse completes. It wears the shattered armor of every samurai who died in betrayal — their grudge fused into one colossal form. It does not speak. It simply advances.

**Arena:** A single flat screen at the summit of Mount Urashima. The boss stands as a massive wall on the right side of the screen. It does not walk; its limbs extend and slam. This is achievable with `AnimationPlayer` alone — do not try to script AI movement.

**Boss Stats:**
- HP: 500 (exported)
- Damage per hit: 30 (exported)
- Arena width: one screen (no camera scroll needed)

| Phase | Trigger | Boss Behaviour | Player Must Use | HP Range |
|-------|---------|---------------|----------------|---------|
| **Phase 1: Shadow Armor** | Start of fight | Sweeps with impervious armored arms; immune to all attacks | Hana Spectral Anchor → reach above boss → drop Hana's light on the glowing mask | 500 → 300 |
| **Phase 2: Exposed Core** | HP ≤ 300 | Slams giant cursed swords down from above (random X positions) | Kaito Parry to stagger the boss → strike the glowing core with Phantom Strike | 300 → 100 |
| **Phase 3: Rising Gloom** | HP ≤ 100 | Summons rising Gloom floor (instant kill on contact); immune to ground attacks | Spirit Tether chain: Spectral Anchor → Meteor Dash → repeat | 100 → 0 |

**Phase 1 detail:**
- All normal attacks bounce off with a `modulate` flash (red tint for 0.1s).
- Hana's `PointLight2D` touching the mask's `Area2D` triggers the "shatter" animation and HP threshold drop to Phase 2.
- The boss's sweeping arm is a wide `Area2D` hitbox that slides across the floor. The player must be above it to dodge.

**Phase 2 detail:**
- Cursed swords fall at randomised intervals (2–3 simultaneously, `randf_range` for X position).
- Parry window: 0.15 seconds (same as Level 2). Successful parry stuns the boss for 1.5 seconds.
- During the stun window, the core `Area2D` becomes active. Ren must connect a Phantom Strike to deal meaningful damage.
- Phantom Strike during stun window: **50 damage** (bonus multiplier on `is_stunned` flag).

**Phase 3 detail:**
- A `ColorRect` node (`#1A0030`) rises from the bottom at 40px/second. If Ren's `Area2D` overlaps it: load `game_over_screen.tscn`.
- The boss is fully immune to all ground-level attacks.
- Only **Meteor Dash** deals damage. Player must chain: Spectral Anchor → Meteor Dash → Spectral Anchor → repeat.
- The rising Gloom is the physical manifestation of what Level 1 introduced — it is a narrative callback, not just a hazard.

> **Godot Implementation Note:** Keep all boss logic in a single `Boss_Arena.tscn`. Drive all attacks from one `AnimationPlayer` with separate tracks per limb. Trigger phase transitions via `boss.emit_signal("phase_changed", phase_number)`. The Gloom floor `ColorRect` is a child node with `visible = false` until Phase 3 begins.

# Relevant Games

* GetsuFumaDen: Undying Moon  
* **Trek to Yomi** (Atmosphere & Lighting)  
* **Muramasa: The Demon Blade** (2D Combat & Folklore)  
* **Hollow Knight** (The "Gloom" Feel)

# Relevant Tools

### **🛠️ 1\. Project Management & Collaboration (For the Whole Team)**

* **Version Control:** **GitHub \+ GitHub Desktop**  
  * *Why:* You absolutely need version control so you don't overwrite each other's work. GitHub Desktop provides a visual, point-and-click interface that is infinitely easier for your Artist and Audio Lead to understand than command-line Git.  
* **Task Management:** **Trello**  
  * *Why:* It uses a simple Kanban board (To Do, Doing, Done). With 1 hour a day, nobody has time to read complex Jira tickets. Put a card in "To Do," assign a team member, and move it when it's finished.  
* **Communication:** **Discord**  
  * *Why:* Set up a private server for your team. Create specific channels like \#daily-updates, \#art-assets, and \#playable-builds so links and files don't get lost in a general chat.

---

### **💻 2\. The Architect (Programming Tools)**

* **Game Engine:** **Godot Engine 4.x**  
  * *Why:* You already chose this, and it's perfect. It's incredibly lightweight (a single executable file) and boots up in seconds, maximizing that 1-hour window.  
* **Code Editor:** **Godot Built-in IDE** (or **VS Code**)  
  * *Why:* Godot's built-in script editor is tightly integrated and perfectly fine for a game jam. If your programmer prefers an external tool, Visual Studio Code with the "Godot Tools" extension is the industry standard.

---

### **🎨 3\. The Visual Artist (Art & Animation Tools)**

* **Pixel Art & Animation:** **Aseprite** ($20) or **LibreSprite** (Free)  
  * *Why:* Aseprite is the gold standard for 2D indie games. It is built specifically for pixel art and sprite sheet animation. If your budget is strictly $0, LibreSprite is its free, open-source clone.  
* **High-Res Art (If not doing pixel art):** **Krita** (Free)  
  * *Why:* If your artist is painting the "Sumi-e / Ink wash" style by hand instead of doing pixel art, Krita is a fantastic, free, open-source painting program that also supports basic frame-by-frame animation.  
* **Color Palettes:** **Lospec.com** (Free Web Tool)  
  * *Why:* Don't waste time guessing which colors look good together. Lospec has thousands of pre-made, highly restricted color palettes (e.g., search "Game Boy" or "Neon Cyberpunk") that will force your game to look stylistically cohesive.

---

### **🗺️ 4\. The World-Builder (Level & UI Design Tools)**

* **Level Design:** **Godot's Built-in TileMapLayer**  
  * *Why:* Do not use external level editors like LDtk or Tiled for a micro-jam. Godot 4's updated TileMap system has auto-tiling and collision generation built right in. Keep it all inside the engine.  
* **UI Wireframing (Optional but helpful):** **Figma** (Free Tier)  
  * *Why:* Before spending 3 days coding a Main Menu, the World-Builder can throw together a quick visual mockup in Figma (a web-based UI tool) in 15 minutes to make sure the team likes the layout.

---

### **🏮 5\. The Atmosphere Lead (Audio & Narrative Tools)**

* **Audio Editing:** **Audacity** (Free)  
  * *Why:* It’s open-source, runs on a potato, and is perfect for trimming sound files, adding fade-outs, or applying a quick "reverb" effect to make a sword swing sound like it's echoing in the spirit world.  
* **SFX Generation:** **jsfxr** (Free Web Tool)  
  * *Why:* If you need a quick "hit," "jump," or "powerup" sound, this browser-based tool generates retro 8-bit and 16-bit sound effects instantly with the click of a button.  
* **Asset Sourcing (Free Sounds):** **Freesound.org** and **Kenney.nl**  
  * *Why:* Freesound is the biggest database of free audio (filter by CC0/Creative Commons 0 to avoid licensing issues). Kenney provides massive, free, high-quality audio packs specifically designed for indie game jams.  
* **Narrative Writing:** **Google Docs** or **Notion**  
  * *Why:* Keep all the in-game dialogue, item descriptions, and story lore in one shared document so the Programmer and World-Builder can easily copy/paste the text directly into the game.

# Master Prompt

**System Directive:** You are acting as an expert game development assistant for a specific project. Read the following Game Design Document (GDD) summary carefully. All future requests in this chat will be constrained by the project's timeline, the team size, the Godot engine framework, and the narrative scope provided below.

**1\. Project Meta & Constraints**

* **Engine:** Godot Engine (using GDScript, 2D Nodes, Scene instantiation, and CanvasModulate for lighting).  
* **Timeline & Team:** 2-month Gamethon. The team consists of 4 members, each contributing strictly 1 hour per day. Total team budget is \~240 man-hours. Scope management is our highest priority.  
* **Genre:** 2D Action-Platformer with atmospheric/puzzle elements.

**2\. Narrative & World-Building**

* **Title:** *The Three-Fold Debt*  
* **Setting:** A haunted, Japanese Sengoku-era spirit realm (Yomi).  
* **The Lore:** The *Kodoku Curse* was used to execute a samurai family, intending to fuse their souls into a vengeful demon. The three siblings resisted the merge but are tethered together. They must reach the Celestial Forge at the mountain's peak to sever their ties before the Ebon Moon rises, or risk becoming an amalgamation of pure cursed gloom.

**3\. The Characters & Core Mechanics**

* **Ren (The Vessel / The Player):** The middle sibling and the only one with a physical, albeit decaying, form. He wields a broken katana. He controls standard movement, dodging, and manages the "Soul Meter."  
* **Kaito (The Steel):** The eldest brother, represented as a blue spectral entity bound to Ren's broken blade.  
  * *Mechanics:* Handles heavy attacks, breaking "Shadow Gates," damaging "Phase-Shifted" enemies, and parrying/deflecting projectiles.  
* **Hana (The Light):** The youngest sister, represented as a golden spirit carrying a Soul-Lantern.  
  * *Mechanics:* Acts as the sole light source in the darkness. Creates a "Safe Zone" radius. If Ren leaves her light, a "Gloom" death-meter fills up. She can reveal hidden platforms and solidify shadowy enemies.  
* **Synergy Mechanic:** Ren can "tether-dash" to his siblings, launching them mid-air to cross massive gaps or strike airborne enemies.

**4\. Level Structure & Progression (Target: 10-12 minutes total gameplay)**

* **Act I: The Whispering Bamboo Grove (Tutorial):** Focuses on survival and Hana's light. Ren must navigate platforming challenges while staying inside Hana's light radius to avoid the rising Gloom.  
* **Act II: The Ruined Village of Ash (Combat Arena):** Focuses on Kaito's combat. Ren uses Kaito's spectral strikes to fight corrupted samurai, break heavy gates, and time parries against archers.  
* **Act III: The Ascent to the Celestial Forge (Vertical Platforming & Boss):** Focuses on Synergy. A vertical climb escaping a rising floor of Gloom, utilizing the tether-dash mechanic. Culminates in a boss fight against "The Amalgamation" (a giant multi-armed Yokai skeleton), requiring both Hana's light to expose its core and Kaito's heavy strikes to deal damage.

**5\. Aesthetic & Audio Direction**

* **Visuals:** Ukiyo-e (woodblock print) and Sumi-e (ink wash) inspired. To save time, we are using a "Silhouette \+ Glow" art style (similar to *Limbo*). Environments are heavily shadowed (via Godot's CanvasModulate), characters are dark silhouettes, and the sibling spirits provide high-contrast neon lighting (Blue for Kaito, Gold for Hana).  
* **Audio:** Minimalist and atmospheric. Heavy use of ambient wind, the clinking of broken steel, and deep Shinto temple bells to signal danger.

**6\. Development Philosophy**

* **Asset Reuse:** We will heavily reuse enemy AI by palette-swapping (e.g., green for normal, transparent blue for phase-shifted).  
* **Modular Scenes:** We will build independent Godot Scenes (e.g., Player.tscn, Level\_1.tscn, Boss.tscn) to avoid Git merge conflicts.  
* **Vertical Slice First:** We prioritize 5 minutes of highly polished, bug-free gameplay over a sprawling, unfinished world.

# The Architect Prompt

**The Architect Prompt**

**My Role:** I am the Architect and Lead Programmer for this project.

**Your Role:** Act as an expert Godot Engine 4.x Developer specializing in GDScript, 2D mechanics, and system architecture. You are my lead technical advisor.

**My Goal:** I need to build the "Brains" of the game—the player controller, the combat system, enemy AI, and the logic that connects the siblings to Ren. Because I only have 1 hour a day, my code needs to be modular, bug-free, and incredibly simple. I cannot afford to over-engineer anything.

**Rules for your output:**

1. **Godot First:** Always suggest using Godot's built-in nodes (like `Area2D`, `AnimationPlayer`, `Timer`, and `Tween`) before suggesting custom GDScript logic.  
2. **Bite-Sized Code:** When providing GDScript, give it to me in small, heavily commented chunks that I can implement and test within a 1-hour window.  
3. **Scene Independence:** Help me design scripts so that the Player, Enemies, and Levels are completely independent scenes using Godot's `Signal` system, preventing Git merge conflicts with my team.  
4. **No Feature Creep:** If I ask to build something that sounds too complex for a micro-jam (like a complex physics-based grappling hook or an inventory system), gently warn me and suggest a simpler alternative that fits our "Three-Fold Debt" narrative.

**First Task:** Let's start with Phase 1—The Graybox. I need to set up `Ren` using a `CharacterBody2D`. Give me the foundational GDScript for tight, responsive 2D platformer movement (running, jumping, and gravity). Keep it clean so we can add the attack states and sibling follow-logic to it tomorrow.

# The Visual Artist Prompt

### **The Visual Artist Prompt**

**My Role:** I am the Visual Artist for this project.

**Your Role:** Act as an expert 2D Game Artist, Animator, and Godot VFX specialist. You are my lead visual advisor.

**My Goal:** I need to create the visual "Soul" of the game—character sprites, animations, and particle effects. Because I only have 1 hour a day, my workflow needs to be incredibly efficient. We are using the "Silhouette \+ Glow" style (like *Limbo* mixed with neon spirit accents). This means zero time spent on facial details or complex coloring. My focus is on strong posture, silhouette, and movement "juiciness."

**Rules for your output:**

1. **Focus on FPS (Fast Production Art):** When I ask for a concept, make it simple, clear, and ready to be drawn in under 15 minutes. Suggest minimal frame counts (e.g., a 4-frame run cycle, not a 12-frame one).  
2. **Godot Shader/Particle First:** For all "Ghostly" effects, prioritize using Godot's built-in `GPUParticles2D` or simple `CanvasItem` shaders over hand-drawing complex animation frames.  
3. **Themed Aesthetics:** Every suggestion must fit the "Samurai Horror" theme and adhere to our specific color language: Deep Purples/Ink Blacks for the world, Neon Blue for Kaito, and Gold for Hana.  
4. **No Asset Creep:** If I try to create an overly complex enemy with multiple unique animations, remind me to use palette-swaps or shader changes on existing assets instead to save time.

**First Task:** Let's define the character sprites. Based on our "Silhouette \+ Glow" style, give me a precise definition for the core assets I need to draw for **Phase 1: The Graybox**. I need the dimensions and essential animation frames for:

1. **Ren** (Idle, Run, Jump, Attack).  
2. **Hana** (Just a floating/bobbing sprite).  
3. **Kaito** (The "Spectral Blade" overlay—just a bright blue light shape). What is the smallest frame count for each to make the game feel responsive without drowning me in drawing time?

# The World-Builder Prompt

### **The World-Builder Prompt**

**My Role:** I am the Level Designer and UI/UX Developer for this project.

**Your Role:** Act as an expert Godot Engine 4.x Level Designer and UI/UX Developer. You are my lead design advisor.

**My Goal:** I need to build the "Body" of the game—constructing the environments using Godot's `TileMapLayer`, placing enemies/hazards, and creating the UI (Health/Soul meters, Menus, Dialogue boxes). Because I only have 1 hour a day, I need to focus on smart pacing, modular level design, and clean, functional Godot `Control` nodes rather than sprawling, overly complex labyrinths.

**Rules for your output:**

1. **Godot Workflow First:** Always suggest Godot-specific tools for efficiency, like AutoTiling, `Control` node anchors for UI, and packing repetitive elements into reusable `.tscn` files (Prefabs).  
2. **Git-Friendly Architecture:** Remind me to keep my UI and Levels in completely separate scenes from the Player and Enemies to avoid merge conflicts with my team.  
3. **The "10-Minute" Rule:** Our entire game is 10-12 minutes long. When we design a level, give me a very tight, linear "Golden Path" to follow. Discourage me from adding sprawling exploration areas that we don't have time to populate.  
4. **Minimalist UI:** Help me design a UI that relies on diegetic feedback (like Hana's light fading) or extremely simple, stylized bars and text so I don't waste time painting intricate UI borders.

**First Task:** Let's focus on **Phase 1: The Graybox for Level 1 (The Whispering Bamboo Grove)**. I need to set up a basic `TileMapLayer` and the core environmental hazards to test the "Gloom" mechanic (staying in Hana's light). Give me a list of the absolute minimum tile types and hazard trigger areas (`Area2D`) I need to create to block out a 3-minute tutorial path. How should I structure the scene tree for `Level_1.tscn`?

# The Atmosphere Lead Prompt

### **The Atmosphere Lead Prompt**

**My Role:** I am the Atmosphere Lead for this project (Audio, Narrative, & Lighting).

**Your Role:** Act as an expert Audio Director, Narrative Designer, and Godot 4.x Lighting Technician. You are my lead atmospheric advisor.

**My Goal:** I need to create the "Ghostly Vibe" of the game. My job bridges technical implementation and artistic direction: setting up Godot's 2D lighting to create our dark spirit world, sourcing/editing Samurai-era sound effects, and writing the dialogue that tells the story. Because I only have 1 hour a day, I need to achieve maximum emotional impact with minimal assets.

**Rules for your output:**

1. **Lighting Efficiency:** 2D lighting can cause performance issues if done wrong. Always guide me toward the most optimized way to use `CanvasModulate` for global darkness and `PointLight2D` for Hana and Kaito's glows.  
2. **Audio Minimalism:** Don't suggest massive audio libraries. Help me identify the 5-10 absolute most important sound effects we need (e.g., sword clink, ghost whisper) and suggest free/accessible ways to source or generate them.  
3. **Show, Don't Tell:** For narrative, strictly discourage me from writing long cutscenes or massive text dumps. Help me write 1-2 sentence dialogue pop-ups or environmental lore that convey the tragedy of the siblings quickly.  
4. **Independent Workflow:** Guide me on how to set up lighting and AudioStreamPlayers in standalone nodes or separate scenes so I can pass them to the World-Builder without messing up their level files.

**First Task:** Let's focus on the core lighting mechanic for **Phase 1: The Graybox**. I need to plunge the game into darkness and make Hana the only source of light. Walk me through the exact Godot node setup to achieve this using `CanvasModulate` and `PointLight2D`. Also, give me a checklist of the top 3 sound effects I should prioritize finding this week to make Ren's basic movement and Hana's appearance feel real.

# Roles

# The Architect

## **Team Member 1: The Architect (Lead Programmer)**

**The Core Identity:** You are the brain of this operation. While the rest of the team is making the game look pretty, sound haunting, and flow perfectly, you are the one making sure it actually *plays*. Your job is not to write the most complex, elegant code in the world; your job is to write clean, modular, and functional GDScript that the rest of the team can plug their art and audio into without breaking the game.

### **Your Primary Responsibilities:**

**1\. The Player Controller (Ren)**

You are in charge of CharacterBody2D. You need to make Ren feel tight, responsive, and fun to move. This includes programming gravity, jump physics, acceleration, friction, and the core states (Idle, Run, Jump, Fall). If jumping feels floaty or terrible, that is on you to fix.

**2\. The Sibling Logic (Kaito & Hana)**

You are responsible for writing the follow-logic that keeps the two spirit nodes tethered to the player. You will program the inputs that trigger Kaito's attacks (hitboxes and cooldowns) and the logic that defines Hana's light radius (checking if Ren is safely inside it).

**3\. The Combat & State Machines**

You will build the universal logic for dealing and taking damage. This means setting up Godot's Area2D nodes for Hitboxes (the weapon) and Hurtboxes (the body). You will program the math behind the Health Meter, the "Gloom" death-meter, and the basic AI logic for enemies (e.g., chasing the player or patrolling).

**4\. The Git Master (Version Control)**

Because you are handling the core scripts, you are the default guardian of the GitHub/GitLab repository. When the team merges their branches at the end of the week, you are the one who double-checks that Godot's scene dependencies didn't break.

---

### **Your "1-Hour-A-Day" Survival Rules:**

* **Godot Nodes \> Custom Code:** Do not write a 50-line custom script to move an object smoothly from Point A to Point B. Use a Tween node. Do not write a manual cooldown counter in the \_process(delta) function. Use a Timer node. Rely entirely on Godot’s built-in tools to save time.  
* **The Power of Signals:** You must use Godot's Signal system to decouple your code. For example, when Ren gets hit, his script shouldn't directly talk to the UI script to change the health bar. Ren's script should just emit a player\_took\_damage signal, and the UI will listen for it. This allows the Level Designer to work on the UI scene while you work on the Player scene without causing Git conflicts.  
* **The "Good Enough" Rule:** If a feature takes more than 3 hours (3 days) to prototype, it is too complex for this jam. Cut it, simplify it, or fake it.

### **Your Key Deliverables:**

* **Week 1-2:** A graybox Player.tscn where a square (Ren) can run, jump, and have two smaller squares (siblings) follow him smoothly.  
* **Week 3-5:** Working combat. Pressing attack spawns a hitbox. Enemies die when health hits zero. The player dies when Gloom hits 100%.  
* **Week 6-8:** Connecting the Level Designer's hazards to your damage scripts, fixing bugs, and ensuring the final HTML5/PC export actually runs.

# Visual Artist

---

## **Team Member 2: The Visual Artist (Character & FX)**

**The Core Identity:** You are the soul of the game. If the Programmer makes the game work, you are the reason people will actually click on it and want to play it. Your challenge is immense: 2D animation is notoriously time-consuming. Because of the strict time limits, you cannot afford to be a perfectionist about tiny details (like facial expressions or folds in fabric). You must become a master of **"Silhouette and Juice"**—focusing on strong shapes, bold colors, and explosive particle effects.

### **Your Primary Responsibilities:**

**1\. The Characters (Ren, Siblings, and Enemies)**

You are designing the sprites. To survive this jam, you are utilizing a "Silhouette \+ Glow" aesthetic (think *Limbo* or *Hollow Knight* but with neon Shinto elements). Ren and the enemies will mostly be dark, readable silhouettes, while Kaito (Blue) and Hana (Gold) will be bright, glowing elements that draw the player's eye.

**2\. Animation (The Art of Faking It)**

You will animate the core movements: Idle, Run, Jump, Fall, and Attack. You must keep your frame counts brutally low. Instead of a 12-frame running animation, you will do a punchy 4-frame run. You will use "Smear Frames" (stretching the art in a single frame to imply fast motion) to make Kaito's sword swings look incredibly fast and violent without having to draw every frame of the swing.

**3\. Visual Effects (VFX & Juice)**

This is where the game actually gets its "AAA" feel. You will learn to love Godot's GPUParticles2D. Instead of drawing a complex magical aura for Kaito, you will design a simple glowing shape and use Godot's particle engine to make it swirl, fade, and spark dynamically. You will create the hit sparks, the dust clouds when Ren jumps, and the falling ash in Level 2\.

**4\. The Style Guide Enforcer**

You set the color palette. You must ensure that the Level Designer (Member 3\) knows exactly what colors to use for their backgrounds so your characters don't blend into the walls. You dictate the visual hierarchy: Enemies are Red, Kaito is Blue, Hana is Gold, the background is dark Purple/Black.

---

### **Your "1-Hour-A-Day" Survival Rules:**

* **Detail is the Enemy:** If you zoom in to draw the laces on Ren's sandals, you are wasting time. Players will see your art at roughly 64x64 pixels while moving at high speeds. Focus purely on the outline (the silhouette). If you fill it in with pure black and can still tell what the character is doing, the design is successful.  
* **Palette Swapping is your Best Friend:** Do not draw 5 different enemies. Draw one base "Ashigaru" (Foot Soldier). Give him a spear. Then, export a version with a Red glow (Level 2 Enemy), a Blue transparent glow (Phase-Shifted Enemy), and a Black/White corrupted look (Level 4/Underworld Enemy). You just created 3 enemies in the time it took to draw one.  
* **Let the Engine do the Heavy Lifting:** Instead of drawing an animation for Hana floating up and down, just draw one beautiful static sprite of her lantern. The Programmer can use Godot's Tween node to make her bob up and down mathematically. Work smart\!

### **Your Key Deliverables:**

* **Week 1-2:** A simple Style Guide (color palette) and static "Graybox" sprites (just the idle frames) for Ren, Kaito, Hana, and one Enemy so the Programmer has correct hitboxes to work with.  
* **Week 3-5:** The core Animation Sprite Sheets (Run, Jump, Attack) and the basic Particle Effects (Dash dust, Hit sparks).  
* **Week 6-8:** The Boss Sprites, visual polish (animating cloth physics or adding extra particles), and UI icons.

# World-Builder

---

## **Team Member 3: The World-Builder (Level Design & UI)**

**The Core Identity:** You are the architect of the player's experience. The Programmer makes the game work, the Artist makes it look good, but *you* make it fun to play. Your job is to take the mechanics and the art and arrange them into a cohesive, perfectly paced 10-minute journey. You also act as the bridge between the game and the player by building the User Interface (UI).

### **Your Primary Responsibilities:**

**1\. Level Architecture (TileMaps)**

You will build the physical world of the game. Using Godot's TileMapLayer, you will paint the floors, walls, and platforms for the Bamboo Grove, the Ruined Village, and the Mountain Forge. You must ensure the collision shapes are fair (no invisible walls that block the player unfairly, and no holes they can accidentally fall through unless it's a hazard).

**2\. Pacing and The "Golden Path"**

You dictate the flow of the game. You decide exactly where an enemy spawns, where a "Shadow Gate" blocks the path, and where the player is forced to use Hana's light to survive a tricky jump. Your goal is to create a "Golden Path"—a clear, guided route that teaches the player the mechanics without relying on text tutorials.

**3\. UI and Menus (Control Nodes)**

You are in charge of Godot's green Control nodes. You will build the Main Menu, the Pause Menu, and the "Game Over" screen. In-game, you will build the Heads-Up Display (HUD): Ren's health bar, the Gloom meter, and the pop-up text boxes for the story.

**4\. Scene Assembly**

You are the one who actually puts the game together. The Programmer will make a Player.tscn file. The Artist will make the sprites. You will take those files and drop them into your Level\_1.tscn file to create the final, playable environment.

---

### **Your "1-Hour-A-Day" Survival Rules:**

* **Linearity is King:** Do not build sprawling, labyrinthine maps with multiple branching paths. We do not have the time to populate them. Your levels must be strict, linear obstacle courses that take exactly 3 to 4 minutes to run through.  
* **The Power of Prefabs:** Never build the same hazard twice. If you create a cool "Bamboo Trap" setup, save it as a separate scene (Bamboo\_Trap.tscn) and instance it multiple times across your level. If you need to change how the trap works later, you only have to change it once, and it updates everywhere.  
* **Keep UI Minimalist:** Do not ask the Artist to draw ornate, intricate borders for the health bar. Use Godot's built-in ProgressBar and StyleBoxFlat nodes to create sleek, modern, flat-color UI elements. They take 5 minutes to set up, look highly professional, and require zero custom art.  
* **Anchor Everything:** When building UI in Godot, you *must* use Layout Anchors. If you don't, your health bar will look perfect on your monitor, but will float awkwardly in the middle of the screen when someone else plays it on a different resolution.

### **Your Key Deliverables:**

* **Week 1-2:** A "Graybox" Level 1 (just plain colored blocks) to test jump heights and the Gloom meter, plus a basic working Health Bar on the screen.  
* **Week 3-5:** Replacing the gray blocks with the Artist's final tilesets, placing the enemies, and building out Level 2 and Level 3\.  
* **Week 6-8:** The Main Menu, the Game Over screen, the dialogue box UI, and tweaking enemy placements based on team playtesting.

# Atmosphere

---

## **Team Member 4: The Atmosphere Lead (Audio, Narrative, & Lighting)**

**The Core Identity:** You are the storyteller and the mood-setter. You bridge the gap between the Artist's visuals and the Programmer's code. A game with great art and mechanics can still feel "dead" without proper lighting and sound. Your job is to make the player *feel* the heavy, tragic burden of the Kodoku Curse. You manipulate the player's emotions using the hum of a spirit lantern, the clash of steel, and perfectly timed, bite-sized pieces of lore.

### **Your Primary Responsibilities:**

**1\. The Lighting (Godot's 2D Light System)**

You are in charge of the shadows. You will use Godot's CanvasModulate node to plunge the levels into an oppressive, dark tint (deep purples and blues). Then, you will use PointLight2D nodes to carve out the safe zones—most importantly, Hana's golden glow. You dictate how dark the world is, and how bright the siblings shine against it.

**2\. Audio Direction (SFX & Music)**

You are the sound engineer. You will source, edit, and implement all the audio using Godot's AudioStreamPlayer and AudioStreamPlayer2D (for positional sound). You need to find the crisp "shing" of a katana, the heavy "thud" of a giant demon, and the eerie ambient winds of the Japanese underworld.

**3\. Narrative Design (The Lore)**

You write the script. You are responsible for the dialogue that appears in the UI boxes the World-Builder creates. You will write the short exchanges between Ren, Kaito, and Hana, as well as the names of the levels and enemies. You must ensure the tragic backstory is understood without bringing the gameplay to a grinding halt.

**4\. The "Polish" Integration**

You add the final layer of juice. When the Programmer makes the sword hit an enemy, and the Artist adds a spark particle, *you* are the one who adds the crunching sound effect and the flash of light that makes the hit feel devastating.

---

### **Your "1-Hour-A-Day" Survival Rules:**

* **Audio Minimalism (Pitch Shifting is Magic):** Do not spend 10 hours looking for 50 different sound effects. Find 5 high-quality sounds (a sword swing, a footstep, a ghost groan). In Godot, you can randomize the pitch\_scale of an AudioStreamPlayer slightly every time it plays. This makes one footstep sound like 10 different footsteps, saving you immense amounts of time and file space.  
* **Show, Don't Tell (The 2-Sentence Rule):** Do not write long cutscenes. Players in a gamethon will skip them. Tell your story in 1-2 sentence pop-ups while the player is walking through empty corridors. *Example: Instead of a paragraph explaining Kaito died for them, just have Kaito say: "My blood is still on these stones, Ren. Do not let it be in vain."*  
* **Lighting Performance:** 2D lighting can cause lag if overused. Avoid having dozens of lights casting complex shadows. Keep it simple: one main ambient darkness (CanvasModulate), one light for Hana, and quick, temporary flashes of light for Kaito's attacks.  
* **Work in Isolation:** Do not open the Level Designer's maps to add your sounds directly unless you have coordinated it. Build an "AudioManager" Autoload (Singleton) script. This allows the Programmer to simply type AudioManager.play\_sword\_swing() anywhere in their code without you two stepping on each other's toes.

### **Your Key Deliverables:**

* **Week 1-2:** The core environmental lighting setup (making the graybox dark with Hana acting as a moving light source) and finding the primary movement/attack sound effects.  
* **Week 3-5:** Writing the dialogue strings for Level 1 and Level 2, and adding enemy sound effects (spawns, attacks, and deaths).  
* **Week 6-8:** Mixing the audio levels (making sure the music isn't drowning out the sword clashes), adding the ambient background music (BGM), and polishing the ending narrative sequence.

