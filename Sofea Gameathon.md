# Ideation

## **Narrative Title: The Three-Fold Debt**

### **The Justification (The "Why")**

In your world, the **Kodoku Curse** is a dark ritual where a family is executed, and their souls are bound together to become a single, mindless demon of vengeance.

The three siblings were betrayed by their own Lord. They died, but their bond was so strong they resisted the "merging." However, the curse is pulling them toward the **Pit of Yomi** (the underworld). To break the curse and ensure they don't become a monster, they must reach the **Celestial Forge** at the mountain's peak before the "Ebon Moon" rises. If they reach the Forge, they can sever the spiritual chains and allow their souls to ascend individually.

---

### **The Three Siblings**

You play as **Ren**, the middle sibling, who acts as the physical "Vessel." Your two siblings accompany you as spirits:

1. **Kaito (The Eldest \- The "Steel"):**  
   * **The Vibe:** Stoic, protective, and stern.  
   * **Narrative Role:** He represents the Samurai's duty. He died shielding the younger two from arrows.  
   * **Mechanic:** He inhabits your **Blade**. When you use special attacks or parry, Kaito’s spectral form briefly flashes behind you to strike. He is your **Offense**.  
2. **Ren (The Middle \- The "Vessel"):**  
   * **The Vibe:** Guilty, determined, but weary.  
   * **Narrative Role:** The only one "grounded" enough to hold a sword. He carries the weight of his siblings' souls literally and figuratively.  
   * **Mechanic:** The player-controlled character. He manages the "Soul Meter" that fuels the others.  
3. **Hana (The Youngest \- The "Light"):**  
   * **The Vibe:** Innocent, optimistic, and ethereal.  
   * **Narrative Role:** She was the family’s hope. She carries the **Soul-Lantern** that keeps the "Gloom" of the spirit world at bay.  
   * **Mechanic:** She floats around you. Her light reveals hidden platforms, weakens "Shadow" enemies, and acts as your **Defense/Utility**.

---

### **The Climax (The Goal's End)**

The "End Boss" isn't the rival Lord who killed them—it is the **Manifestation of the Curse** itself. It’s a giant, shadowy version of what the siblings would become if they fail to reach the Forge (a multi-headed "Gashadokuro" skeleton).

* **The Ending:** Upon reaching the Forge, the player must choose. The Forge only has enough "Celestial Fire" to cleanse **two** souls.  
  * *The Twist:* In the ultimate act of Samurai honor, the two spirits (Kaito and Hana) often choose to save Ren (the living vessel), or Ren chooses to sacrifice his "physical" form so his siblings can be reborn. (This gives you multiple endings with very little extra coding\!)

---

### **Why this is "Gamethon Friendly":**

* **Asset Swapping:** You only need one main character sprite (Ren). The siblings can be simple, floating particle-heavy spirits that don't need complex walking animations.  
* **Clear Progression:** Level 1 (The Forest \- Finding Hana’s Light), Level 2 (The Ravine \- Finding Kaito’s Strength), Level 3 (The Mountain Peak \- The Forge).  
* **Dialogue:** You can have the siblings "chatter" via text boxes at the bottom of the screen during gameplay, which builds the story without needing cutscenes.

**Visual Tip:** Use a **color-coding system**. Anything Kaito-related (combat) is **Blue Spirit Flame**, and anything Hana-related (light/healing) is **Golden Spirit Light**. This makes the screen easy to read for the player.

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

In Level 1, the enemies are "Fodder Spirits"—weak but terrifying in their numbers.

* **The Hollowed Ash:** These are the spirits of the low-ranking foot soldiers who died in the same massacre. They appear as grey, faceless silhouettes with glowing red eyes. They move slowly and attack with clumsy, ghostly pikes.  
* **The Bamboo Lurkers:** Spirits that have merged with the environment. They look like normal bamboo stalks until you get close, at which point they bend unnaturally to strike Ren like a whip.  
* **The Gloom Wisps:** Small, flying motes of darkness. They don't hurt Ren directly; instead, they try to "extinguish" Hana. If they touch her, her light radius shrinks, making the world more dangerous.

## **The Abilities: The Bond Begins**

Since this is the tutorial phase, the abilities are focused on **Survival** and **Cooperation.**

### **Ren (The Physical Vessel)**

* **Broken Edge:** Because his sword is snapped, Ren’s reach is short but very fast. He fights like a desperate man, using quick stabs and pommel strikes.  
* **Samurai Roll:** A quick dodge to move through enemies. In Level 1, this is his primary way to stay inside Hana's light.

### **Hana (The Light)**

* **Spirit Halo:** A passive ability. Hana creates a circular "Safe Zone" around Ren. Inside this circle, enemies take more damage; outside of it, they are nearly invisible and harder to hit.  
* **The Flare:** Hana can briefly intensify her glow. This blinds all "Hollowed" enemies on screen for 2 seconds, giving Ren a chance to thin the herd or escape a trap.

### **Kaito (The Steel \- Slumbering)**

* **Vengeful Echo:** At this stage, Kaito is not fully awake. However, when Ren is at low health, Kaito’s spectral hand briefly appears to help Ren **Parry** an incoming attack. It’s an automatic "Second Chance" mechanic that introduces the player to the idea that Kaito is protecting them from within the blade.

**Design Note for the Team:** \> Level 1 should feel **quiet.** Save the heavy music for the Boss in Level 2\. In the Grove, focus on the "clink" of the broken sword and the soft hum of Hana's light. This makes the player feel lonely, which makes the bond between the siblings feel much more important.

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

In Level 2, the enemies are heavily armored and require strategy to defeat. You can no longer just run past them.

* **The Phased Ashigaru (Foot Soldiers):** These soldiers flicker in and out of reality. When they are transparent, Ren's normal attacks pass right through them. The player must wait for them to solidify to strike, or use Kaito's abilities to hit them while phased.  
* **The Crimson Archers:** Positioned on the burning rooftops. They fire arrows of red spirit energy. They force the player to keep moving and introduce the necessity of the "Parry" mechanic.  
* **The Captain (Level Boss):** A large, brute-force enemy with a massive Kanabō (spiked club). He has a very simple 3-state AI:  
  1. A slow, heavy overhead smash.  
  2. A sweeping attack that covers the ground.  
  3. A "roar" that summons a wave of falling ash, forcing Ren to take cover under Hana's light.

## **The Abilities: The Steel Awakens**

With Kaito active, the combat opens up. Ren transitions from a desperate survivor into a lethal warrior.

### **Ren (The Physical Vessel)**

* **The Spectral Edge:** Ren's basic attack range is doubled. The broken steel is now tipped with Kaito's blue spirit energy, allowing for 3-hit combos that feel weighty and crisp.  
* **Upward Slash:** A new launcher attack that allows Ren to hit enemies on platforms above him (essential for dealing with the Crimson Archers).

### **Kaito (The Steel)**

* **Phantom Strike (Heavy Attack):** Kaito’s signature move. Ren swings the sword, and a split-second later, Kaito's giant spirit-arms appear and mirror the swing with massive force. This breaks enemy shields and shatters the Shadow Gates blocking the level.  
* **The Deflect (Parry):** A precisely timed block. If Ren blocks right before an arrow or a sword hits, Kaito's spirit flashes, knocking the projectile back or briefly stunning the melee attacker.

### **Hana (The Light)**

* **Revealing Light (Passive Upgrade):** Hana's light now naturally forces "Phased" enemies to solidify faster when they step inside her radius, making her a vital tool for crowd control.

**Design Note for the Team:** \> For the artists and programmers, keep the Boss Fight extremely contained. Do not build a massive, complex arena. A single, flat screen (like a traditional fighting game stage) is perfect. Spend your programming hours perfecting the "feel" of Kaito's Phantom Strike—add a slight screen shake, a loud, crisp sound effect, and a freeze-frame (hit-stop) so the player feels the impact of the older brother's rage.

# Level 3

## **Level 3: The Narrative Arc**

### **The Opening: The Ebon Moon Rises**

Having conquered the echoes of their past in the village, the siblings reach the base of the sacred mountain. However, the sky turns a sickly, bruising purple as the "Ebon Moon" eclipses the sun. The **Kodoku Curse** reaches its peak, trying to violently pull the three souls together. The ground shatters, and gravity itself begins to warp.

### **The Progression: The Rising Void**

There is no turning back. From the bottom of the screen, the "Gloom" from Level 1 returns, but now it is a rising ocean of pitch-black, grasping hands. Ren must climb the floating, shattered ruins of the mountain path. He cannot do this alone; he must throw Kaito and Hana to traverse impossible gaps, literally using his bond with his siblings to pull himself upward.

### **The Climax: The Forge of Souls (Final Boss)**

Ren reaches the summit, where the Celestial Fire burns in an ancient stone forge. But the Gloom follows, erupting from the cliffside and solidifying into **The Amalgamation**—a massive, multi-armed demonic skeleton wearing the armor of a hundred dead samurai. It is the physical embodiment of the curse they are trying to escape.

### **The Ending: The Choice**

Once the beast is slain, the siblings approach the Forge. The fire is weak. **It only has enough power to sever the curse and grant peace to two souls.** The game pauses, and the player (as Ren) is given a choice:

1. **Sacrifice Ren:** Ren throws himself into the Void, allowing Kaito and Hana to ascend.  
2. **The Siblings' Sacrifice:** Kaito and Hana pour their remaining spirit energy into the Forge, pushing Ren back into the world of the living, returning him to life, but leaving them to fade.

## **The Enemies: The Broken World**

Because the focus is on escaping the rising Void, the enemies here are designed as **obstacles** rather than arenas to clear out.

* **The Rising Gloom (Environmental Threat):** An instant-death wall of shadows that slowly scrolls up from the bottom of the screen. It forces the player to keep climbing.  
* **The Gale Wraiths:** Flying, wind-based spirits that don't deal much damage but are designed to knock Ren back. They force the player to time their jumps and dashes carefully.  
* **The Amalgamated Sentinels:** Ground-based enemies that are horribly fused together—two torsos, four arms. They act as "walls." They are heavily armored and block the narrow vertical pathways, requiring Kaito's heavy strikes to break through quickly before the Gloom catches up.

---

## **The Abilities: Perfect Synergy**

The mechanics now require the player to use both Kaito and Hana in tandem to traverse the shattered mountain.

### **Ren (The Vessel)**

* **The Spirit Tether:** Ren can now target a spot in mid-air. He hurls one of his siblings' spirits and then pulls himself toward them in a rapid dash.

### **Kaito (The Steel)**

* **Meteor Dash:** If Ren uses the Tether with Kaito, Kaito flies upward, and Ren dashes to him with a violent, damaging strike. It’s an attack and a double-jump combined. Players use this to blast through Amalgamated Sentinels blocking the upward path.

### **Hana (The Light)**

* **Spectral Anchor:** If Ren uses the Tether with Hana, she flies to a spot and becomes a solid, glowing platform for 3 seconds. Ren can use this to catch his breath, dodge a Gale Wraith, or set up his next jump.

## **The Boss Fight: The Amalgamation**

To keep this achievable in Godot with your timeline, the boss shouldn't move around the screen much. Instead, it acts as a massive "wall" on the right side of the screen, slamming its giant fists down.

* **Phase 1 (Hana's Phase):** The boss is covered in impenetrable shadow armor. The player must use Hana's *Spectral Anchor* to climb high above the boss's sweeping attacks and drop Hana's light directly onto the boss's mask, shattering the darkness.  
* **Phase 2 (Kaito's Phase):** The boss is exposed and angry. It begins slamming giant swords down. The player must use Kaito's *Deflect/Parry* with perfect timing to stagger the boss, opening its core for a combo attack.  
* **Phase 3 (Synergy):** The boss summons the Rising Gloom. The player must constantly stay airborne using the *Spirit Tether* between Hana's platforms and Kaito's dashes, attacking the boss entirely in mid-air for the final blow.

**Godot Design Note for the Team:** **Level 3 Level Design:** You don't need a massive, sprawling map for this. Build a tall, narrow `TileMapLayer`. For the Rising Gloom, simply create an `Area2D` with a dark `ColorRect` and a script that says `position.y -= speed * delta`. If the player's `Area2D` overlaps it, trigger the Game Over screen.

**The Boss Scene:** Keep the boss logic in a completely separate `Boss_Arena.tscn` scene. Use an `AnimationPlayer` to control the boss's attacks (e.g., animate a giant hand slamming down). This is vastly easier than trying to program complex Boss AI movement in scripts\!

# Level 4

## **Level 4: The Shores of Yomi (The Underworld)**

### **The Narrative Arc: The Refusal**

At the end of Level 3, the Forge demands a sacrifice. But to unlock Level 4, the player must have found three hidden "Memory Shards" in the previous levels. If they have them, Ren refuses the Forge's ultimatum. He strikes the Celestial Forge with his sword, shattering it.

The ground gives way, and all three siblings plummet into **Yomi** (the Underworld). The Forge wasn't salvation; it was a prison. To truly break the curse, they must fight their way across the shores of the afterlife and defeat the **Warden of Yomi** to force their way back to the world of the living—together.

### **The Progression: The Gauntlet**

This level is a pure test of skill. No puzzles, no slow platforming. It is a flat, desolate beach of black sand beneath a shattered red sky. It acts as an arena/gauntlet where waves of enemies spawn, leading up to the True Final Boss.

## **The Enemies: The Nightmare Echoes (Asset Reuse\!)**

Because this is a stretch goal, **do not make new enemy sprites.** Use the classic game dev trick: **Palette Swapping.** \* **The Blood Ashigaru:** Take the foot soldiers from Level 2, tint their sprites deep red, and increase their movement speed by 50%.

* **The Void Lurkers:** Take the Bamboo enemies from Level 1, make them pitch black with white eyes, and have them spawn directly out of the sand.  
* **The True Final Boss \- The Warden:** A massive, floating, multi-armed Yokai. (You can actually reuse the Rig/Animation nodes from the Level 3 boss, but give it a new texture and faster attack patterns).

## **The Abilities: The Unified Soul (Power Fantasy)**

In the first three levels, the siblings were separated and struggling. Now, having chosen to stick together in the Underworld, their souls synchronize perfectly. This level is a **Power Fantasy**.

* **The Avatar State:** The player no longer has to carefully manage Hana's light or Kaito's cooldowns. Ren glows with an intense, blinding aura (combining Gold and Blue).  
* **Mechanic Override:** \* Ren's sword attacks now shoot projectile waves of Kaito's blue energy across the screen.  
  * Hana's light doesn't just reveal enemies; it actively burns them over time (AOE damage).  
  * The Spirit Dash has no cooldown, allowing the player to zip around the screen like a superhero.

**Godot Design Note for the Team (Stretch Goal Logic):** Do not let your team start on Level 4 until Levels 1, 2, and 3 are 100% playable with a Start Menu and a Game Over screen.

If you do get to Level 4, build it in a single day using Godot's `Modulate` property. You can take the `Level_2.tscn` file, duplicate it, delete all the walls to make it a flat arena, and change the `CanvasModulate` from dark blue to an eerie, apocalyptic blood-red.

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

