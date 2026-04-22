# Architect's Guide: Starting with Git

As the **Architect**, you are the guardian of the codebase. Your first task is to set up the foundation so the rest of the team can work safely.

---

## 🚀 1. Initialization (Day 1)

Open your terminal (or Git Bash) in your project root (`c:\Users\IRTIZA\Documents\the-three-fold-debt`) and run these commands:

```bash
# 1. Initialize the local repository
git init

# 2. Add the Godot .gitignore (CRITICAL)
# This prevents huge, temporary files from bloating your repo.
# If you don't have one, create a file named '.gitignore' and paste the content below.
```

### The Standard Godot `.gitignore`
Make sure your `.gitignore` file contains at least these lines:
```text
# Godot-specific ignores
.godot/
*.import
export_presets.cfg

# System-specific ignores
.DS_Store
Thumbs.db
```

---

## ☁️ 2. Connecting to the Cloud (GitHub/GitLab)

1. Go to GitHub and create a **Private** repository named `the-three-fold-debt`.
2. Do **NOT** initialize it with a README or License (you already have a local project).
3. Copy the Remote URL (it looks like `https://github.com/YourUsername/the-three-fold-debt.git`).
4. Back in your terminal:

```bash
# 1. Add the remote
git remote add origin https://github.com/YourUsername/the-three-fold-debt.git

# 2. Stage your files
git add .

# 3. Create the first commit
git commit -m "Initial commit: Project structure and .gitignore"

# 4. Push to the main branch
git branch -M main
git push -u origin main
```

---

## 🌿 3. The Branching Strategy

To keep the `main` branch stable (playable), you will create a `dev` branch for daily integration.

```bash
# 1. Create and switch to the dev branch
git checkout -b dev

# 2. Push dev to the cloud
git push -u origin dev
```

### Who works where?
- **Main Branch:** Only contains "Release" builds (at the end of the week).
- **Dev Branch:** Where the World-Builder merges everything on Saturdays.
- **Feature Branches:** Each team member should create their own branch for their specific task.

**Example for the Architect starting on the Player:**
```bash
git checkout dev          # Start from dev
git checkout -b arch-player # Create your personal workspace
```

---

## 👥 4. Inviting the Team

1. In GitHub, go to **Settings > Collaborators** and add your team members' usernames.
2. Tell them to run this command on their machines:
   ```bash
   git clone https://github.com/YourUsername/the-three-fold-debt.git
   ```
3. **The First Instruction to the Team:** 
   > "Never push directly to `main` or `dev`. Always create a branch named `yourname-task` (e.g., `artist-sprites`), do your work there, and then tell me when you're ready for a Merge Request."

---

## 🛠️ 5. Architect's "First Code" Commit

Now that Git is ready, create your `Player.tscn` (the graybox) and commit it:

```bash
# After creating the Player scene in Godot:
git add Player.tscn Player.gd
git commit -m "feat: added basic CharacterBody2D player controller"
git push origin arch-player
```

---

### Pro Tip: GitHub Desktop
If your team members (Artist/Audio) are scared of the terminal, tell them to download **GitHub Desktop**. It makes `add`, `commit`, and `push` as simple as clicking a button.
