# Run from anywhere *inside* your dotfiles repo
set -euo pipefail

DOT="$(git rev-parse --show-toplevel)"

# 1) Layout
mkdir -p \
  "$DOT/usr/share/gnome-session/sessions" \
  "$DOT/usr/share/xsessions" \
  "$DOT/.bin" \
  "$DOT/scripts"

# 2) Copy system session files into the repo (mirror their / paths)
copied_any=0
if [ -f /usr/share/gnome-session/sessions/gnome-plus-i3.session ]; then
  cp -v /usr/share/gnome-session/sessions/gnome-plus-i3.session \
        "$DOT/usr/share/gnome-session/sessions/"
  copied_any=1
else
  echo "⚠️  Missing: /usr/share/gnome-session/sessions/gnome-plus-i3.session"
fi
if [ -f /usr/share/xsessions/gnome-plus-i3.desktop ]; then
  cp -v /usr/share/xsessions/gnome-plus-i3.desktop \
        "$DOT/usr/share/xsessions/"
  copied_any=1
else
  echo "⚠️  Missing: /usr/share/xsessions/gnome-plus-i3.desktop"
fi

# 3) Version hm-add under repo /.bin if present in your home
if [ -f "$HOME/.bin/hm-add" ]; then
  install -m 0755 "$HOME/.bin/hm-add" "$DOT/.bin/hm-add"
fi

# 4) Meta scripts in scripts/
# 4a) Install just the GNOME+i3 session files to the system
cat > "$DOT/scripts/install-gnome-i3" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

sudo install -Dm644 "$ROOT/usr/share/gnome-session/sessions/gnome-plus-i3.session" \
  /usr/share/gnome-session/sessions/gnome-plus-i3.session
sudo install -Dm644 "$ROOT/usr/share/xsessions/gnome-plus-i3.desktop" \
  /usr/share/xsessions/gnome-plus-i3.desktop

echo "✔ Installed GNOME+i3 session files to /usr/share/*"
echo "Pick “GNOME + i3” from the GDM cog menu."
EOF
chmod +x "$DOT/scripts/install-gnome-i3"

# 4b) Central installer: link hm-add to ~/.bin and install the session files
cat > "$DOT/scripts/install-all" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Ensure ~/.bin and link hm-add if present in repo
mkdir -p "$HOME/.bin"
if [ -f "$ROOT/.bin/hm-add" ]; then
  ln -sf "$ROOT/.bin/hm-add" "$HOME/.bin/hm-add"
  chmod +x "$HOME/.bin/hm-add"
  echo "✔ Linked hm-add to ~/.bin/hm-add"
fi

# Install GNOME+i3 session files
"$ROOT/scripts/install-gnome-i3"

echo "✅ install-all complete."
EOF
chmod +x "$DOT/scripts/install-all"

# 5) Stage & commit only if there are changes
add_paths=( "scripts/install-gnome-i3" "scripts/install-all" )
[ -f "$DOT/.bin/hm-add" ] && add_paths+=(".bin/hm-add")
[ -f "$DOT/usr/share/gnome-session/sessions/gnome-plus-i3.session" ] && \
  add_paths+=("usr/share/gnome-session/sessions/gnome-plus-i3.session")
[ -f "$DOT/usr/share/xsessions/gnome-plus-i3.desktop" ] && \
  add_paths+=("usr/share/xsessions/gnome-plus-i3.desktop")

git -C "$DOT" add "${add_paths[@]}"

if ! git -C "$DOT" diff --cached --quiet; then
  msg="GNOME+i3 (Noble): add/refresh session files, .bin/hm-add, and scripts/"
  git -C "$DOT" commit -m "$msg"
  echo "✅ Committed to $(basename "$DOT")"
else
  echo "ℹ️ Nothing new to commit."
fi
