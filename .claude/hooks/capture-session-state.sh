#!/bin/bash
# Capture Claude session state on first tool use.
#
# PreToolUse hook that writes session ID, launch directory, and metadata
# to ~/.claude/session-state/<session-id>.json. Only writes once per
# session (skips if file already exists).
#
# Also updates a 'current' pointer so the MCP server can find the
# active session without CLAUDE_SESSION_ID in its environment.
#
# Source: dotfiles/.claude/hooks/capture-session-state.sh
# Claude session: 3735a547-8244-4da9-90fd-4bd8a0f6dd04

# Consume stdin (hook protocol requires it)
cat > /dev/null

[ -z "$CLAUDE_SESSION_ID" ] && exit 0

STATE_DIR="$HOME/.claude/session-state"
STATE_FILE="$STATE_DIR/$CLAUDE_SESSION_ID.json"

# Only write once per session
[ -f "$STATE_FILE" ] && exit 0

mkdir -p "$STATE_DIR"

# Capture git branch if in a repo
git_branch=""
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    git_branch=$(git branch --show-current 2>/dev/null)
fi

# Write session state
cat > "$STATE_FILE" <<EOF
{
    "session_id": "$CLAUDE_SESSION_ID",
    "launch_dir": "$PWD",
    "project_path": "$PWD",
    "git_branch": "$git_branch",
    "started_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
    "hostname": "$(hostname -s)"
}
EOF

# Write per-process pointer keyed by Claude Code's PID.
# The hook's PPID is Claude Code (the process that spawned this hook).
# The MCP server walks up its own process tree to find the matching
# current.<pid> file, so concurrent sessions each resolve to their
# own pointer without racing.
tmp="$STATE_DIR/.current.$$"
echo "$CLAUDE_SESSION_ID" > "$tmp"
mv "$tmp" "$STATE_DIR/current.$PPID"

# Prune stale files
find "$STATE_DIR" -name '*.json' -mtime +30 -delete 2>/dev/null
find "$STATE_DIR" -name 'current.*' -mtime +1 -delete 2>/dev/null

exit 0
