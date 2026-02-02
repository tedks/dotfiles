# CLAUDE.md - Dotfiles Repository Guide

## Overview

Personal dotfiles repository for a Linux desktop environment. Files mirror their installation destinations under `$HOME` or `/`.

## Structure

```
.config/           → ~/.config/        (XDG config: i3, i3status, gnome-session)
.emacs             → ~/.emacs          (Main Emacs config)
.emacs.d/          → ~/.emacs.d/       (Custom elisp modules)
.bin/              → ~/.bin/           (User scripts)
.xsession          → ~/.xsession       (X session init)
usr/               → /usr/             (System-level files, requires sudo)
scripts/           → Not installed     (Meta scripts for managing this repo)
```

## Key Components

### GNOME+i3 Session
Hybrid desktop: GNOME Flashback services + i3 window manager.

**Session files:**
- `usr/share/gnome-session/sessions/gnome-plus-i3.session` - RequiredComponents list
- `usr/share/xsessions/gnome-plus-i3.desktop` - GDM session entry
- `usr/lib/systemd/user/gnome-session@gnome-plus-i3.target.d/session.conf` - systemd target (required for Ubuntu 24.04)
- `.config/gnome-session/sessions/gnome-plus-i3.session` - user-level override

**Install:** Run `scripts/install/install-gnome-i3` then select "GNOME + i3" from GDM.

### i3 Config (`.config/i3/config`)
- **Mod key**: Super (Mod4)
- **Movement**: j/n/p/; for focus (Emacs-style: j=left, n=down, p=up, ;=right)
- **Resize mode**: j/n/p/; (j=grow width, n=grow height, p=shrink height, ;=shrink width)
- **Focus mode toggle**: Mod+Shift+Return (switch between tiling/floating focus)
- **Launcher**: Mod+D runs Kupfer
- **Kill window**: Alt+F4

### Emacs (`.emacs`, `.emacs.d/`)
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

## Nix / Home Manager Setup

This repo integrates with [Home Manager](https://github.com/nix-community/home-manager) for declarative package management on NixOS or standalone Nix installations.

### Configuration Location
- Home Manager config: `~/.config/home-manager/home.nix`
- Uses **flakes** (`nix run github:nix-community/home-manager -- --flake ... switch`)
- The HM config directory should be a git repo

### Using `hm-add`

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

### Key Features
- **Transactional**: Changes are reverted if the build fails
- **Duplicate detection**: Won't re-add packages already in the list
- **Format detection**: Handles both `with pkgs; [ ... ]` and `[ pkgs.foo ... ]` styles
- **Git integration**: Only commits after successful switch

### Unfree Packages
For proprietary packages (vscode, slack, etc.), add to your home.nix:
```nix
nixpkgs.config.allowUnfree = true;
```

## Common Tasks

### Adding a new dotfile
1. Place file in repo mirroring its destination path
2. If it's a script, add a symlink in `.bin/` pointing to `../scripts/<script>`
3. Commit and push

### Installing on a new machine
```bash
git clone <repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./scripts/install/install-all                    # Basic install (scripts + Claude config)
./scripts/install/install-all --with-gnome-i3   # Include GNOME+i3 session (graphical machines)
./scripts/install/install-all --with-nix        # Include Nix + Home Manager bootstrap
```

### Syncing changes from system to repo
Copy modified files manually to their mirrored paths in the repo, then commit.

## Chrome Integration

This repo supports Claude Code's Chrome integration for browser-based testing and debugging.

### Setup
1. Install the [Claude in Chrome extension](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)
2. Launch Claude Code with: `claude --chrome`
3. Verify connection with: `/chrome`

### Usage
Chrome integration enables testing of X11/GNOME configurations in browser-based tools, debugging web-based settings, and automating browser tasks.

## Beads Issue Tracker

This repo uses [Beads](https://github.com/steveyegge/beads) (`bd` command) for task tracking. Beads is a git-backed issue tracker designed for AI coding agents.

### Key Commands

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

### Best Practices for Claude

1. **Use `bd` commands** - Never manually edit `.beads/issues.jsonl`
2. **Close issues with `bd close <id>`** - This properly updates timestamps and events
3. **Track work in progress** - Use `bd update <id> -s in_progress` when starting work
4. **Add comments** - Use `bd comment <id> "message"` for notes and progress updates
5. **Check status** - Run `bd status` to see overview before starting work

### File Structure
- `.beads/issues.jsonl` - Issue database (do not edit directly)
- `.beads/last-touched` - Currently active issue ID

## Night Light / Color Management

GNOME's built-in Night Light doesn't work with i3 because it requires mutter to apply gamma shifts. This setup uses two tools instead:

### xiccd
Registers X11 displays with colord so they appear in GNOME Settings → Color. Without this, colord (and gsd-color) can't see your displays.

### redshift
Actually applies the color temperature shift via xrandr gamma. Uses geoclue for location.

**i3 config:**
```
exec --no-startup-id xiccd
exec --no-startup-id redshift
```

**Manual control:**
```bash
redshift -p                    # Print current status
redshift -O 3500               # One-shot: set to 3500K
redshift -x                    # Reset to neutral
pkill redshift                 # Stop redshift
redshift -l LAT:LON            # Manual coordinates fallback
```

### Geoclue Setup (Ubuntu 24.04)

Mozilla Location Service was retired, breaking geoclue's WiFi-based location.
Configure BeaconDB as a replacement:

```bash
# /etc/geoclue/conf.d/90-beacondb.conf
sudo tee /etc/geoclue/conf.d/90-beacondb.conf << 'EOF'
[wifi]
url=https://beacondb.net/v1/geolocate
EOF

# /etc/geoclue/conf.d/99-redshift.conf
sudo tee /etc/geoclue/conf.d/99-redshift.conf << 'EOF'
[redshift]
allowed=true
system=false
users=
EOF

sudo systemctl restart geoclue
```

**Why GNOME Night Light fails:** gsd-color detects night time and sets temperature, but relies on mutter's DisplayConfig D-Bus interface to apply gamma. Without mutter (we use i3), the gamma commands go nowhere.

## Notes

- Emacs config assumes Source Code Pro font and solarized-light theme
- i3 movement keys use Dvorak home row (j/n/p/;), not vim-style (h/j/k/l)
- `.xsession` sets up GNOME+i3 hybrid session and runs kbd-setup
- Journal files stored in `~/Documents/.journal/` with Muse markup
