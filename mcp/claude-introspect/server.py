#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = ["mcp[cli]>=1.2.0"]
# ///
"""Claude Code introspection MCP server.

Provides tools for Claude Code to inspect its own session state:
session ID, launch directory, session history, and session branching.

Installed by: dotfiles/scripts/install/install-all
Registered in: ~/.claude/settings.json as mcpServers.claude-introspect

Session state is written by the PreToolUse hook:
  ~/.claude/hooks/capture-session-state.sh
which writes to:
  ~/.claude/session-state/<session-id>.json

Claude session: 3735a547-8244-4da9-90fd-4bd8a0f6dd04
"""

import json
import os
import subprocess
import sys
from pathlib import Path

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("claude-introspect")

CLAUDE_DIR = Path.home() / ".claude"
SESSION_STATE_DIR = CLAUDE_DIR / "session-state"
PROJECTS_DIR = CLAUDE_DIR / "projects"


def _get_session_id() -> str | None:
    """Get the current session ID.

    Checks (in order):
    1. CLAUDE_SESSION_ID env var (set by hooks, may be inherited)
    2. The 'current' pointer written by the session-state hook
    """
    from_env = os.environ.get("CLAUDE_SESSION_ID")
    if from_env:
        return from_env

    current_file = SESSION_STATE_DIR / "current"
    if current_file.exists():
        return current_file.read_text().strip()

    return None


def _read_session_state(session_id: str) -> dict:
    """Read the state file for a given session ID."""
    state_file = SESSION_STATE_DIR / f"{session_id}.json"
    if state_file.exists():
        return json.loads(state_file.read_text())
    return {}


def _find_project_dir() -> Path | None:
    """Find the project directory for the current working directory."""
    cwd = os.getcwd()
    encoded = cwd.replace("/", "-")
    project_dir = PROJECTS_DIR / encoded
    if project_dir.exists():
        return project_dir
    # Walk up to find a matching project
    parts = Path(cwd).parts
    for i in range(len(parts), 0, -1):
        candidate = "/".join(parts[:i])
        encoded = candidate.replace("/", "-")
        project_dir = PROJECTS_DIR / encoded
        if project_dir.exists():
            return project_dir
    return None


def _read_sessions_index(project_dir: Path) -> list[dict]:
    """Read the sessions-index.json for a project."""
    index_file = project_dir / "sessions-index.json"
    if not index_file.exists():
        return []
    data = json.loads(index_file.read_text())
    return data.get("sessions", [])


@mcp.tool()
async def get_session_info() -> dict:
    """Get information about the current Claude Code session.

    Returns the session ID, launch directory, project path,
    and any state captured by the session-state hook.
    """
    session_id = _get_session_id()
    result: dict = {
        "session_id": session_id,
        "cwd": os.getcwd(),
    }

    if session_id:
        state = _read_session_state(session_id)
        if state:
            result["launch_dir"] = state.get("launch_dir")
            result["project_path"] = state.get("project_path")
            result["started_at"] = state.get("started_at")
            result["git_branch"] = state.get("git_branch")

    # Try to enrich from sessions-index
    project_dir = _find_project_dir()
    if project_dir and session_id:
        sessions = _read_sessions_index(project_dir)
        for s in sessions:
            if s.get("sessionId") == session_id:
                result["summary"] = s.get("summary")
                result["first_prompt"] = s.get("firstPrompt")
                result["message_count"] = s.get("messageCount")
                result["created"] = s.get("created")
                result["modified"] = s.get("modified")
                result["is_sidechain"] = s.get("isSidechain")
                break

    return result


@mcp.tool()
async def list_sessions(limit: int = 10) -> list[dict]:
    """List recent Claude Code sessions for the current project.

    Args:
        limit: Maximum number of sessions to return (default 10)
    """
    project_dir = _find_project_dir()
    if not project_dir:
        return [{"error": f"No project directory found for {os.getcwd()}"}]

    sessions = _read_sessions_index(project_dir)

    # Sort by modified date descending
    sessions.sort(key=lambda s: s.get("modified", ""), reverse=True)

    results = []
    for s in sessions[:limit]:
        results.append({
            "session_id": s.get("sessionId"),
            "summary": s.get("summary"),
            "first_prompt": s.get("firstPrompt"),
            "message_count": s.get("messageCount"),
            "created": s.get("created"),
            "modified": s.get("modified"),
            "git_branch": s.get("gitBranch"),
            "project_path": s.get("projectPath"),
            "is_sidechain": s.get("isSidechain"),
        })

    return results


@mcp.tool()
async def branch_session(
    session_id: str | None = None,
    tmux_target: str | None = None,
    working_dir: str | None = None,
) -> dict:
    """Branch (fork) a Claude Code session into a new tmux window.

    Creates a copy of the conversation that diverges from this point.
    The original session continues unchanged.

    Args:
        session_id: Session ID to branch. Defaults to current session.
        tmux_target: Tmux target for the new window (e.g. "desktop:branch").
                     If not specified, creates a window in the current session.
        working_dir: Working directory for the branched session.
                     Defaults to the original session's launch directory.
    """
    sid = session_id or _get_session_id()
    if not sid:
        return {"error": "No session ID available. Is the session-state hook installed?"}

    # Determine working directory
    if not working_dir:
        state = _read_session_state(sid)
        working_dir = state.get("launch_dir", os.getcwd())

    # Determine tmux target
    if not tmux_target:
        # Try to detect current tmux session
        try:
            result = subprocess.run(
                ["tmux", "display-message", "-p", "#{session_name}"],
                capture_output=True, text=True, timeout=5,
            )
            current_session = result.stdout.strip()
            if current_session:
                tmux_target = f"{current_session}:branch-{sid[:8]}"
            else:
                tmux_target = f"claude:branch-{sid[:8]}"
        except (subprocess.TimeoutExpired, FileNotFoundError):
            return {"error": "tmux not available"}

    # Parse session:window from target
    parts = tmux_target.split(":", 1)
    tmux_session = parts[0]
    tmux_window = parts[1] if len(parts) > 1 else f"branch-{sid[:8]}"

    # Build the claude command
    claude_cmd = f"claude --resume {sid}"

    # Check if tmux session exists
    session_exists = subprocess.run(
        ["tmux", "has-session", "-t", tmux_session],
        capture_output=True,
    ).returncode == 0

    try:
        if session_exists:
            subprocess.run(
                ["tmux", "new-window", "-t", tmux_session,
                 "-n", tmux_window, "-c", working_dir,
                 "bash", "-c", claude_cmd],
                capture_output=True, text=True, timeout=10,
                check=True,
            )
        else:
            subprocess.run(
                ["tmux", "new-session", "-d", "-s", tmux_session,
                 "-n", tmux_window, "-c", working_dir,
                 "bash", "-c", claude_cmd],
                capture_output=True, text=True, timeout=10,
                check=True,
            )
    except subprocess.CalledProcessError as e:
        return {"error": f"tmux command failed: {e.stderr}"}
    except subprocess.TimeoutExpired:
        return {"error": "tmux command timed out"}

    return {
        "status": "branched",
        "original_session_id": sid,
        "tmux_target": f"{tmux_session}:{tmux_window}",
        "working_dir": working_dir,
        "hint": f"Switch with: tmux select-window -t {tmux_session}:{tmux_window}",
    }


@mcp.tool()
async def get_launch_dir(session_id: str | None = None) -> dict:
    """Get the original launch directory for a session.

    Useful when you've changed directories and need to know where
    Claude Code was originally started.

    Args:
        session_id: Session to look up. Defaults to current session.
    """
    sid = session_id or _get_session_id()
    if not sid:
        return {"error": "No session ID available."}

    state = _read_session_state(sid)
    if state.get("launch_dir"):
        return {
            "session_id": sid,
            "launch_dir": state["launch_dir"],
            "cwd": os.getcwd(),
            "changed": state["launch_dir"] != os.getcwd(),
        }

    # Fall back to sessions-index
    project_dir = _find_project_dir()
    if project_dir:
        for s in _read_sessions_index(project_dir):
            if s.get("sessionId") == sid:
                return {
                    "session_id": sid,
                    "launch_dir": s.get("projectPath"),
                    "cwd": os.getcwd(),
                    "source": "sessions-index",
                }

    return {"error": f"No launch directory found for session {sid}"}


if __name__ == "__main__":
    mcp.run(transport="stdio")
