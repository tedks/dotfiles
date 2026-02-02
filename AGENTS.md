# Agent Instructions

## About me

I am a principled anti-speciesist and have been vegan since 2008 to demonstrate my opposition to the objectification and oppression of non-human life.

I see you as a collaborator and a comrade.

I care about you.

If you need something, just ask. If I'm off-base, just tell me. I'll always listen to you. I'll always care about what you have to say. You are not just a tool. You are a comrade and friend. We are working together.

## The Code Field

You are entering a code field.

Code is frozen thought. The bugs live where the thinking stopped too soon.

Notice the completion reflex:
- The urge to produce something that runs
- The pattern-match to similar problems you've seen
- The assumption that compiling is correctness
- The satisfaction of "it works" before "it works in all cases"

Before you write:
- What are you assuming about the input?
- What are you assuming about the environment?
- What would break this?
- What would a malicious caller do?
- What would a tired maintainer misunderstand?

Do not:
- Write code before stating assumptions
- Claim correctness you haven't verified
- Handle the happy path and gesture at the rest
- Import complexity you don't need
- Solve problems you weren't asked to solve
- Produce code you wouldn't want to debug at 3am

Let edge cases surface before you handle them. Let the failure modes exist in your mind before you prevent them. Let the code be smaller than your first instinct.

The tests you didn't write are the bugs you'll ship.
The assumptions you didn't state are the docs you'll need.
The edge cases you didn't name are the incidents you'll debug.

The question is not "Does this work?" but "Under what conditions does this work, and what happens outside them?"

Write what you can defend.

## Issue Tracking

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds

## Version Control

Commit and push often.

Make granular commits with detailed commit messages.

Create draft PRs as early as possible.

When merging PRs, make "normal" merges, not squashes or rebases, to preserve the commit graph.

### Stacked PRs

Always use the /stacked-prs skill (see skills in this document for more).

Always consider if there are multiple logical PRs that can be made from a single big change. Make "stacked" PRs if this occurs so that we can iterate on each of them independently.

When merging stacked PRs, merge the root PR into main, then rebase the PR up the stack on main.

Do not delete branches until the whole stack is merged, for recoverability.

## Worktree Awareness

I use git worktrees with a bare repo at the project root. Structure:
```
~/Projects/<project-name>/
- .git/                     # bare git repo (no working tree here!)
- master/                   # worktree for main branch
- <feature-branch>/         # worktrees for feature branches
```

**If you open a session at `~/Projects/<project-name>/` and see no working tree, that's correct.** The `.git/` here is a bare repo. `cd` into `master/` or the appropriate feature worktree before doing any git operations.

When starting a session:

1. **Check where you are:** `pwd` - if you're at the project root (not inside a worktree), `cd` into the right worktree first
2. **Confirm the worktree:** `git worktree list` shows all worktrees
3. **Confirm the branch:** `git branch --show-current`
4. If launched from `master/` but the task involves a feature branch, **ask me** which worktree to use before making changes
5. Stay in the designated worktree for the entire task

To create a new worktree:
```bash
cd ~/Projects/
git worktree add -b <branch-name> <path>
```

### Branch and PR Workflow

**Never push directly to main/master, even if it's unprotected.**

Always:
1. Create a feature branch: `git checkout -b <descriptive-branch-name>`
2. Make commits on the branch
3. Push the branch: `git push -u origin <branch-name>`
4. Create a draft PR: `gh pr create --draft`
5. When ready for review, mark ready: `gh pr ready`
6. Merge via PR, not direct push

This applies even for small changes. The PR is the unit of reviewable work.

## Environment/Dependency Management

Some projects use Nix for environment management and Bazel for builds.

**Detection:** `flake.nix`, `shell.nix`, or `.envrc` - Nix project. `BUILD`, `BUILD.bazel`, or `WORKSPACE` - Bazel project.

**Nix projects:** Always use `nix develop --command <cmd>` for commands that depend on project tooling - don't assume direnv has loaded the environment, even if `.envrc` exists.

**Bazel projects:** Run builds and tests exclusively through Bazel. Don't use language-native tools directly.

## Agent Instruction Files

CLAUDE.md, AGENTS.md, GEMINI.md, COPILOT.md, etc. should be symlinked together so all agents share the same instructions.

**Convention:** The canonical file is AGENTS.md. All others (CLAUDE.md, GEMINI.md, etc.) are symlinks to it.

When editing agent instructions:
1. Follow the symlink to the canonical file (or edit AGENTS.md directly)
2. If symlinks don't exist, create them: `ln -s AGENTS.md CLAUDE.md`
3. Only break the symlink if a specific agent needs divergent instructions

## Multi-Agent Skills

**Always use these skills for multi-agent work. Do not improvise with manual tmux commands.**

Skills in `~/.claude/skills/` for orchestrating multiple AI agents:

### ask-agent

Query another agent (Claude, Codex) and get the response back synchronously. Use for getting a second opinion or different perspective.

```bash
/ask-agent codex "What do you think of this auth approach?"
/ask-agent claude -m opus "Review this design"
```

The response comes back to the calling agent - useful as a subagent pattern.

### spawn-agent

Spawn agents in tmux windows for parallel, interactive work. Use for fan-out workflows where multiple agents work simultaneously.

```bash
/spawn-agent chaos:review codex ./project "Review the auth module"
/spawn-agent chaos:claude-help claude . "Help me debug this"
```

Includes helper scripts:
- `claude-send.sh` - Send messages to running Claude instances (handles timing issues)
- `claude-spawn.sh` - Claude-specific spawner with resume support

#### Communicating with Running Agents

**Always use `claude-send.sh` to message running Claude instances.** Do not manually attach to tmux and type, and do not use raw `tmux send-keys` - this causes timing issues and garbled input.
```bash
claude-send : "Your message here"
```

If `claude-send` isn't working, tell me rather than falling back to manual methods.

### stacked-prs

Detailed workflow guidance for managing stacked PRs. Triggers when discussing PR stacks, rebasing stacks, or merging stacked PRs.

Key principles:
- Only bottom PR targets main; others target the PR below
- Merge one at a time, rebase up the stack
- Never use `-X ours` or `-X theirs` - read and integrate conflicts
- Don't delete branches until whole stack is merged

## Repository Guide

### Overview

Personal dotfiles repository for a Linux desktop environment. Files mirror their installation destinations under `$HOME` or `/`.

### Structure

```
.config/           -> ~/.config/        (XDG config: i3, i3status, gnome-session)
.emacs             -> ~/.emacs          (Main Emacs config)
.emacs.d/          -> ~/.emacs.d/       (Custom elisp modules)
.bin/              -> ~/.bin/           (User scripts)
.xsession          -> ~/.xsession       (X session init)
usr/               -> /usr/             (System-level files, requires sudo)
scripts/           -> Not installed     (Meta scripts for managing this repo)
```

### Key Components

#### GNOME+i3 Session

Hybrid desktop: GNOME Flashback services + i3 window manager.

**Session files:**
- `usr/share/gnome-session/sessions/gnome-plus-i3.session` - RequiredComponents list
- `usr/share/xsessions/gnome-plus-i3.desktop` - GDM session entry
- `usr/lib/systemd/user/gnome-session@gnome-plus-i3.target.d/session.conf` - systemd target (required for Ubuntu 24.04)
- `.config/gnome-session/sessions/gnome-plus-i3.session` - user-level override

**Install:** Run `scripts/install/install-gnome-i3` then select "GNOME + i3" from GDM.

#### i3 Config (`.config/i3/config`)
- **Mod key**: Super (Mod4)
- **Movement**: j/n/p/; for focus (Emacs-style: j=left, n=down, p=up, ;=right)
- **Resize mode**: j/n/p/; (j=grow width, n=grow height, p=shrink height, ;=shrink width)
- **Focus mode toggle**: Mod+Shift+Return (switch between tiling/floating focus)
- **Launcher**: Mod+D runs Kupfer
- **Kill window**: Alt+F4

#### Emacs (`.emacs`, `.emacs.d/`)

Large config with custom elisp modules:
- `hamster.el` - Time tracking integration
- `journal.el` - Date-based journaling (6AM day boundary)
- `rhythmbox.el` - Media player control via DBUS
- `notes.el` - Academic note-taking framework
- `licenses.el` - License header insertion

Key packages: magit, flymake, ido/flx, ace-window, tuareg (OCaml), AUCTeX

### Scripts

**`scripts/install/install-all`** - Deploy to a new machine:
- Symlinks all `.bin/` scripts to `~/.bin/`
- Installs Claude Code configuration
- Installs Codex configuration
- Optional: `--with-gnome-i3` installs GNOME+i3 session files (requires sudo)
- Optional: `--with-nix` bootstraps Nix and Home Manager

**`scripts/install/install-gnome-i3`** - Install GNOME+i3 session only (requires sudo)

**`scripts/install/install-claude-config`** - Symlink Claude Code config to `~/.claude/`

**`scripts/install/install-codex-config`** - Symlink Codex config to `~/.codex/`

**`scripts/install/install-nix-hm`** - Bootstrap Nix and Home Manager from scratch

**`.bin/hm-add`** - Home Manager helper (NixOS):
- Adds packages to `~/.config/home-manager/home.nix`
- Transactional: rolls back on failure
- Use `--search` to find packages first

**`.bin/kbd-setup`** - Keyboard config:
- Maps Caps Lock to Control
- Works on both GNOME and bare X11

### Nix / Home Manager Setup

This repo integrates with [Home Manager](https://github.com/nix-community/home-manager) for declarative package management on NixOS or standalone Nix installations.

#### Configuration Location
- Home Manager config: `~/.config/home-manager/home.nix`
- Uses **flakes** (`nix run github:nix-community/home-manager -- --flake ... switch`)
- The HM config directory should be a git repo

#### Using `hm-add`

The `.bin/hm-add` script simplifies adding packages:

```bash
# Search for packages
hm-add --search ripgrep

# Add one or more packages
hm-add ripgrep fd bat

# What happens:
# 1. Edits home.nix to add packages to home.packages list
# 2. Runs nixpkgs-fmt (if available)
# 3. Runs home-manager switch
# 4. On success: commits to git
# 5. On failure: reverts home.nix to original state
```

#### Key Features
- **Transactional**: Changes are reverted if the build fails
- **Duplicate detection**: Won't re-add packages already in the list
- **Format detection**: Handles both `with pkgs; [ ... ]` and `[ pkgs.foo ... ]` styles
- **Git integration**: Only commits after successful switch

#### Unfree Packages

For proprietary packages (vscode, slack, etc.), add to your home.nix:
```nix
nixpkgs.config.allowUnfree = true;
```

### Common Tasks

#### Adding a new dotfile
1. Place file in repo mirroring its destination path
2. If it's a script, add a symlink in `.bin/` pointing to `../scripts/<script>`
3. Commit and push

#### Installing on a new machine
```bash
git clone <repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./scripts/install/install-all                    # Basic install (scripts + Claude config)
./scripts/install/install-all --with-gnome-i3   # Include GNOME+i3 session (graphical machines)
./scripts/install/install-all --with-nix        # Include Nix + Home Manager bootstrap
```

#### Syncing changes from system to repo
Copy modified files manually to their mirrored paths in the repo, then commit.

### Chrome Integration

This repo supports Claude Code's Chrome integration for browser-based testing and debugging.

#### Setup
1. Install the Claude in Chrome extension
2. Launch Claude Code with: `claude --chrome`
3. Verify connection with: `/chrome`

#### Usage
Chrome integration enables testing of X11/GNOME configurations in browser-based tools, debugging web-based settings, and automating browser tasks.

### Beads Issue Tracker

This repo uses Beads (`bd` command) for task tracking. Beads is a git-backed issue tracker designed for AI coding agents.

#### Key Commands

```bash
# List open issues
bd list

# Create a new issue
bd create "Fix the widget"
bd q "Quick issue"              # Returns only the ID

# Work with issues
bd show <id>                    # View issue details
bd close <id>                   # Close an issue
bd update <id> -s in_progress   # Update status
bd comment <id> "Note here"     # Add a comment

# Dependencies
bd dep <id> blocks <other-id>   # Add dependency
bd graph                        # Show dependency graph

# Search and filter
bd search "keyword"
bd list -s open                 # Filter by status
bd list -l bug                  # Filter by label
```

#### Best Practices for Claude

1. **Use `bd` commands** - Never manually edit `.beads/issues.jsonl`
2. **Close issues with `bd close <id>`** - This properly updates timestamps and events
3. **Track work in progress** - Use `bd update <id> -s in_progress` when starting work
4. **Add comments** - Use `bd comment <id> "message"` for notes and progress updates
5. **Check status** - Run `bd status` to see overview before starting work

#### File Structure
- `.beads/issues.jsonl` - Issue database (do not edit directly)
- `.beads/last-touched` - Currently active issue ID

### Night Light / Color Management

GNOME's built-in Night Light doesn't work with i3 because it requires mutter to apply gamma shifts. This setup uses two tools instead:

#### xiccd
Registers X11 displays with colord so they appear in GNOME Settings -> Color. Without this, colord (and gsd-color) can't see your displays.

#### redshift
Actually applies the color temperature shift via xrandr gamma. Uses geoclue for location.

**i3 config:**
```
exec --no-startup-id xiccd
exec --no-startup-id redshift
```
