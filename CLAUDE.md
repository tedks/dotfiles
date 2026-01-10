# CLAUDE.md - Dotfiles Repository Guide

## Overview

Personal dotfiles repository for a Linux desktop environment. Files mirror their installation destinations under `$HOME` or `/`.

## Structure

```
.config/           → ~/.config/        (XDG config: i3, i3status, gnome-sessions)
.emacs             → ~/.emacs          (Main Emacs config)
.emacs.d/          → ~/.emacs.d/       (Custom elisp modules)
.bin/              → ~/.bin/           (User scripts)
.xsession          → ~/.xsession       (X session init)
usr/               → /usr/             (System-level files, requires sudo)
scripts/           → Not installed     (Meta scripts for managing this repo)
```

## Key Components

### GNOME+i3 Session
Hybrid desktop: GNOME Flashback services + i3 window manager. Session files live in:
- `usr/share/gnome-session/sessions/gnome-plus-i3.session`
- `usr/share/xsessions/gnome-plus-i3.desktop`

### i3 Config (`.config/i3/config`)
- **Mod key**: Super (Mod4)
- **Movement**: j/n/p/; for focus (hybrid: j=left, n=down, p=up from Emacs)
- **Resize mode**: j/k/l/; (vim-style, shifted one key right from hjkl)
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

**`scripts/copy.sh`** - Main repo management script:
- Run from anywhere in repo to sync from system
- Generates `install-all` and `install-gnome-i3` scripts
- Auto-commits changes to git

**`scripts/install-all`** - Deploy to a new machine:
- Symlinks `.bin/` scripts
- Installs GNOME+i3 session files (requires sudo)

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
2. Run `scripts/copy.sh` to regenerate install scripts
3. Commit and push

### Installing on a new machine
```bash
git clone <repo> ~/Projects/dotfiles
cd ~/Projects/dotfiles
./scripts/install-all
# Select "GNOME + i3" from login screen
```

### Syncing changes from system to repo
```bash
cd ~/Projects/dotfiles
./scripts/copy.sh
```

## Chrome Integration

This repo supports Claude Code's Chrome integration for browser-based testing and debugging.

### Setup
1. Install the [Claude in Chrome extension](https://chromewebstore.google.com/detail/claude/fcoeoabgfenejglbffodgkkbkcdhcgfn)
2. Launch Claude Code with: `claude --chrome`
3. Verify connection with: `/chrome`

### Usage
Chrome integration enables testing of X11/GNOME configurations in browser-based tools, debugging web-based settings, and automating browser tasks.

## Notes

- Emacs config assumes Source Code Pro font and solarized-light theme
- i3 movement keys use Dvorak home row (j/n/p/;), not vim-style (h/j/k/l)
- `.xsession` sets up GNOME+i3 hybrid session and runs kbd-setup
- Journal files stored in `~/Documents/.journal/` with Muse markup
