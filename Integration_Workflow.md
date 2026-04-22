# The Integration Workflow: Putting It All Together

> **Goal:** Combine the work of all four team members into a single playable build without breaking the game or causing Git merge conflicts.

This document outlines the **"Russian Doll" Scene Architecture** and the **Weekly Merge Rhythm** to ensure smooth integration.

---

## 🏗️ 1. The "Russian Doll" Scene Architecture

Godot's superpower is its node and scene system. To avoid Git merge conflicts (where two people edit the same file and break the project), **never have two people working on the same `.tscn` file at the same time.**

Think of the project like Russian Nesting Dolls. Everyone works on a smaller, independent "doll" (scene), and the World-Builder puts them all inside the biggest "doll" (`Level_1.tscn`).

### The Independent Scenes (Who Owns What)

1. **`Player.tscn` (Owned by Architect & Artist)**
   - **Architect:** Edits the `CharacterBody2D` script, hitboxes, and logic.
   - **Artist:** Swaps the placeholder squares with the final `Sprite2D` frames and `GPUParticles2D`.
   - **Atmosphere:** Adds the `PointLight2D` (Hana's light) and `AudioStreamPlayer2D` (footsteps).
   - *Integration:* The Architect finishes the logic. Then, they tell the Artist/Atmosphere to jump in and add their nodes. Only one person edits `Player.tscn` at a time.

2. **`HollowedAsh.tscn` (Owned by Architect & Artist)**
   - Built the same way as `Player.tscn`. The Architect makes the graybox move; the Artist makes it look like a ghost.

3. **`HUD.tscn` (Owned by World-Builder)**
   - A `CanvasLayer` scene containing the health bar, Gloom meter, and dialogue box.
   - *Integration:* This is instanced into the level later.

4. **`AudioManager.tscn` (Owned by Atmosphere Lead)**
   - An Autoload (Singleton) that holds all global sound effects.

### The Master Scene

5. **`Level_1.tscn` (Owned exclusively by World-Builder)**
   - The World-Builder is the **ONLY** person allowed to save changes to `Level_1.tscn`.
   - The World-Builder opens this scene and **instances** (drags and drops) `Player.tscn`, `HollowedAsh.tscn`, and `HUD.tscn` into the level.
   - If the Architect updates Ren's jump height in `Player.tscn`, the World-Builder doesn't need to do anything; it automatically updates inside `Level_1.tscn`.

---

## 🔌 2. Wiring It Up (The Signal System)

Because everyone is building separate scenes, you cannot use direct node references (e.g., `get_parent().get_node("HUD/HealthBar")`). This will crash the game when the scene tree changes.

**Use Signals to communicate between scenes.**

### Example: The Gloom Meter Integration
1. **Architect (in `Player.tscn`):** Writes the Gloom math. When Gloom increases, the script says: `emit_signal("gloom_changed", current_gloom_value)`.
2. **World-Builder (in `HUD.tscn`):** Writes a script on the UI that says: `func update_gloom_ui(value): $ProgressBar.value = value`.
3. **The Integration (in `Level_1.tscn`):** The World-Builder clicks on the instanced `Player` node, goes to the "Node" tab, double-clicks the `gloom_changed` signal, and connects it to the `HUD`'s `update_gloom_ui` function.

### Example: The Dialogue Integration
1. **Atmosphere Lead:** Writes the script in Google Docs.
2. **World-Builder (in `Level_1.tscn`):** Places an `Area2D` (DialogueTrigger) in the level.
3. **The Integration:** When `Player` enters the `Area2D`, it emits a signal to the `HUD` to display the specific text string from the Atmosphere Lead's script.

---

## 🔄 3. The Weekly Merge Rhythm

With everyone only working 1 hour a day, you need a strict schedule for combining work via Git/GitHub.

### Monday – Wednesday: Deep Work (Separate Branches)
- Everyone works on their local computers.
- **Architect:** Works in `Player.tscn` and `HollowedAsh.tscn`.
- **Artist:** Draws sprites and saves them to the `/Assets/Sprites/` folder.
- **World-Builder:** Paints tiles in `Level_1.tscn`.
- **Atmosphere:** Collects sounds and saves them to `/Assets/Audio/`.

### Thursday: Asset Handoff
- The Artist and Atmosphere Lead push their new files (`.png`, `.wav`) to GitHub.
- They announce in Discord: *"Assets pushed!"*

### Friday: Implementation & Wiring
- The Architect pulls the new `.png` files and updates `Player.tscn` and `HollowedAsh.tscn` with the final art.
- The Architect ensures `Player.tscn` works perfectly, then pushes it to GitHub.
- The Atmosphere Lead updates the `AudioManager` with the new `.wav` files and pushes.

### Saturday: The Master Assembly
- The World-Builder pulls everyone's finished work from GitHub.
- The World-Builder drags the updated `Player.tscn` and `HollowedAsh.tscn` into `Level_1.tscn`.
- The World-Builder connects the Signals (e.g., wiring the Player's health to the HUD).
- The World-Builder pushes the final `Level_1.tscn` to GitHub.

### Sunday: Playtest & Triage
- Everyone downloads the main branch and plays `Level_1.tscn`.
- Take 15 minutes to write down bugs in Trello/Discord.
- **No new features on Sunday.** Only bug fixes.

---

## 🚀 4. Step-by-Step: The Level 1 Final Integration

Here is the exact order of operations to make the Level 1 Graybox turn into the final playable build:

1. **The World is Born:** World-Builder commits `Level_1.tscn` with the `TileMapLayer` and `CanvasModulate` (Darkness).
2. **The Hero Arrives:** Architect commits `Player.tscn` (graybox square). World-Builder drags it into `Level_1.tscn`.
3. **The Lights Turn On:** Atmosphere Lead adds Hana's `PointLight2D` to `Player.tscn`. Now the world has lighting.
4. **The World Gets Dangerous:** Architect commits `HollowedAsh.tscn`. World-Builder places 3 of them in `Level_1.tscn`.
5. **The UI Wakes Up:** World-Builder commits `HUD.tscn`. Drops it into `Level_1.tscn` and connects it to the Player's signals.
6. **The Art Replaces the Boxes:** Visual Artist provides sprite sheets. Architect replaces the gray squares in `Player.tscn` and `HollowedAsh.tscn` with the animated sprites.
7. **The Sound Drops In:** Atmosphere Lead provides `.wav` files. Architect triggers them via `AudioManager.play_footstep()` in the player code.
8. **The Story is Told:** World-Builder adds `Area2D` triggers to `Level_1.tscn` and pastes the Atmosphere Lead's dialogue text into them.

**Done. Level 1 is complete.**
