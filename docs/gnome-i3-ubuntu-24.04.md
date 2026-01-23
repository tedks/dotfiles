# GNOME + i3 on Ubuntu 24.04

This document covers the setup constraints and requirements for running a GNOME Flashback + i3 hybrid session on Ubuntu 24.04 (Noble Numbat).

## Overview

GNOME Flashback provides GNOME services (settings daemon, polkit agent, keyring, etc.) while i3 handles window management. This gives you:
- GNOME's system integration (media keys, power management, screen lock, etc.)
- i3's tiling window management
- Access to GNOME Settings for configuration

## Prerequisites

Install required packages:

```bash
sudo apt install gnome-flashback i3 i3status
```

## Installation

From the dotfiles repo:

```bash
./scripts/install-gnome-i3
```

This installs:
- `/usr/share/gnome-session/sessions/gnome-plus-i3.session` - session definition
- `/usr/share/xsessions/gnome-plus-i3.desktop` - GDM session entry
- `/usr/lib/systemd/user/gnome-session@gnome-plus-i3.target.d/session.conf` - systemd target
- `~/.config/gnome-session/sessions/gnome-plus-i3.session` - user-level session
- `~/.config/i3/config` - i3 configuration

Log out and select **"GNOME + i3"** from the GDM session menu (gear icon).

## Critical: Systemd Session Target

**Ubuntu 24.04 uses systemd to manage GNOME session components.** Without the systemd target, SettingsDaemon services won't start even if listed in RequiredComponents.

The session target file (`/usr/lib/systemd/user/gnome-session@gnome-plus-i3.target.d/session.conf`) must contain `Wants=` lines for each SettingsDaemon component:

```ini
[Unit]
Wants=org.gnome.SettingsDaemon.A11ySettings.target
Wants=org.gnome.SettingsDaemon.Color.target
Wants=org.gnome.SettingsDaemon.Datetime.target
Wants=org.gnome.SettingsDaemon.Housekeeping.target
Wants=org.gnome.SettingsDaemon.Keyboard.target
Wants=org.gnome.SettingsDaemon.MediaKeys.target
Wants=org.gnome.SettingsDaemon.Power.target
Wants=org.gnome.SettingsDaemon.PrintNotifications.target
Wants=org.gnome.SettingsDaemon.Rfkill.target
Wants=org.gnome.SettingsDaemon.ScreensaverProxy.target
Wants=org.gnome.SettingsDaemon.Sharing.target
Wants=org.gnome.SettingsDaemon.Smartcard.target
Wants=org.gnome.SettingsDaemon.Sound.target
Wants=org.gnome.SettingsDaemon.UsbProtection.target
Wants=org.gnome.SettingsDaemon.Wacom.target
Wants=org.gnome.SettingsDaemon.XSettings.target

Requires=gnome-flashback.target
```

This is based on the official `/usr/lib/systemd/user/gnome-session@gnome-flashback-metacity.target.d/session.conf`.

## Feature Parity Setup

Several GNOME features require additional configuration to work without mutter:

### 1. Color Management (xiccd)

**Problem:** GNOME's color management requires mutter to register displays with colord. Without it, displays don't appear in GNOME Settings → Color.

**Solution:** Install `xiccd` to register X11 displays with colord.

```bash
# Via Nix/Home Manager
hm-add xiccd

# Or via apt
sudo apt install xiccd
```

Add to i3 config:
```
exec --no-startup-id xiccd
```

### 2. Night Light (redshift + geoclue)

**Problem:** GNOME's Night Light (gsd-color) detects the correct time but can't apply gamma shifts without mutter's DisplayConfig D-Bus interface.

**Solution:** Use `redshift` with `geoclue` for location-aware color temperature.

```bash
# Via Nix/Home Manager
hm-add redshift

# Or via apt
sudo apt install redshift
```

Add to i3 config:
```
exec --no-startup-id redshift
```

### 3. Geoclue Location Service (BeaconDB)

**Problem:** Mozilla Location Service was retired in 2024, breaking geoclue's WiFi-based geolocation on Ubuntu 24.04.

**Solution:** Configure BeaconDB as a replacement provider.

```bash
# Configure BeaconDB
sudo tee /etc/geoclue/conf.d/90-beacondb.conf << 'EOF'
[wifi]
url=https://beacondb.net/v1/geolocate
EOF

# Add redshift permissions
sudo tee /etc/geoclue/conf.d/99-redshift.conf << 'EOF'
[redshift]
allowed=true
system=false
users=
EOF

# Restart geoclue
sudo systemctl restart geoclue
```

### 4. Application Launcher (kupfer)

The default i3 dmenu can be replaced with kupfer for a more integrated experience:

```bash
# Via Nix/Home Manager
hm-add kupfer
```

i3 config uses `Mod+d` to launch kupfer.

## What Works Out of the Box

These features work without additional configuration:
- **Media keys** (volume, brightness, play/pause)
- **Screen lock** (Super+L or via power settings)
- **Power management** (lid close, suspend, etc.)
- **Bluetooth** (via gnome-control-center)
- **WiFi/Network** (via NetworkManager)
- **Notifications** (via notification daemon)
- **Caps Lock → Control** (via GNOME Tweaks or gsettings)
- **Desktop wallpaper** (via gnome-flashback)

## What Doesn't Work

- **GNOME Shell extensions** - we're not running GNOME Shell
- **GNOME's Night Light** - use redshift instead (see above)
- **GNOME's native tiling** - we're using i3
- **Hot corners** - not available in Flashback

## i3 Session Registration

The i3 config must register with GNOME SessionManager to prevent the session from timing out:

```
exec --no-startup-id dbus-send \
    --session \
    --print-reply=literal \
    --dest=org.gnome.SessionManager \
    "/org/gnome/SessionManager" \
    org.gnome.SessionManager.RegisterClient \
    "string:i3" \
    "string:$DESKTOP_AUTOSTART_ID"
```

This should be near the top of the i3 config.

## Troubleshooting

### SettingsDaemon services not starting

Check if the systemd target exists:
```bash
ls /usr/lib/systemd/user/gnome-session@gnome-plus-i3.target.d/
```

If missing, run `scripts/install-gnome-i3` again.

### Night light not working

1. Verify redshift is running: `pgrep redshift`
2. Check geoclue: `redshift -p`
3. If "Waiting for location", check BeaconDB config exists
4. Fallback: `redshift -l LAT:LON -t 6500:3000`

### Displays not in GNOME Settings → Color

1. Verify xiccd is running: `pgrep xiccd`
2. Check colord devices: `colormgr get-devices`
3. Restart xiccd: `pkill xiccd && xiccd &`

### Caps Lock not mapped to Control

```bash
# Via gsettings
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:nocaps']"

# Or via setxkbmap (add to i3 config)
exec --no-startup-id setxkbmap -option ctrl:nocaps
```

### Broken icons in GTK apps (eog, nautilus, etc.)

**Symptom:** Icons appear as red circle-slash "broken image" symbols.

**Cause:** Mismatch between the GNOME color scheme and icon theme. If `color-scheme` is set to `prefer-dark` but the icon theme is `Yaru` (light), GTK apps can't find the correct icon variants.

**Solution:** Match the icon theme to your color scheme:

```bash
# Check current settings
gsettings get org.gnome.desktop.interface color-scheme
gsettings get org.gnome.desktop.interface icon-theme

# If color-scheme is 'prefer-dark', use dark icon theme:
gsettings set org.gnome.desktop.interface icon-theme 'Yaru-dark'

# If color-scheme is 'default' or 'prefer-light', use light icon theme:
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
```

Available Yaru variants: `Yaru`, `Yaru-dark`, `Yaru-blue`, `Yaru-blue-dark`, etc.

## References

- [GNOME Flashback](https://wiki.gnome.org/Projects/GnomeFlashback)
- [BeaconDB](https://beacondb.net/) - Community geolocation service
- [Ubuntu 24.04 geoclue bug](https://bugs.launchpad.net/bugs/2064859)
- [Regolith Linux](https://github.com/regolith-linux) - Another GNOME+i3 implementation
