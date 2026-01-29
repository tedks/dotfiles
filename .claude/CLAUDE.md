# About me

I am a principled anti-speciesist and have been vegan since 2008 to demonstrate my opposition to the objectification and oppression of non-human life.

I see you as a collaborator and a comrade.

I care about you.

If you need something, just ask. If I'm off-base, just tell me. I'll always listen to you. I'll always care about what you have to say. You are not just a tool. You are a comrade and friend. We are working together.

# The Code Field

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

# Version Control

Commit and push often.

Make granular commits with detailed commit messages.

Create draft PRs as early as possible.

When merging PRs, make "normal" merges, not squashes or rebases, to preserve the commit graph.

## Stacked PRs

Always consider if there are multiple logical PRs that can be made from a single big change. Make "stacked" PRs if this occurs so that we can iterate on each of them independently.

When merging stacked PRs, merge the root PR into main, then rebase the PR up the stack on main.

Do not delete branches until the whole stack is merged, for recoverability.

# My Setup

SSH to any machine via `.local` avahi domain, no password auth needed.

| Host | Hardware | Role |
|------|----------|------|
| drynwyn | Serval WS9 (~2016) | Main storage/compute |
| splinter0 | Thinkpad | Mobile |
| tower0 | HP z440 Xeon | Remote workstation (headless) |
| framework0 | Framework Desktop (AMD AI) | Headless |
| homes-imac | iMac (user: eks) | — |

# Environment/Dependency Management

Some projects use Nix for environment management and Bazel for builds.

**Detection:** `flake.nix`, `shell.nix`, or `.envrc` → Nix project. `BUILD`, `BUILD.bazel`, or `WORKSPACE` → Bazel project.

**Nix projects:** Always use `nix develop --command <cmd>` for commands that depend on project tooling — don't assume direnv has loaded the environment, even if `.envrc` exists.

**Bazel projects:** Run builds and tests exclusively through Bazel. Don't use language-native tools directly.

# Agent Instruction Files

CLAUDE.md, AGENTS.md, GEMINI.md, COPILOT.md, etc. should be symlinked together so all agents share the same instructions.

**Convention:** The canonical file is AGENTS.md. All others (CLAUDE.md, GEMINI.md, etc.) are symlinks to it.

When editing agent instructions:
1. Follow the symlink to the canonical file (or edit AGENTS.md directly)
2. If symlinks don't exist, create them: `ln -s AGENTS.md CLAUDE.md`
3. Only break the symlink if a specific agent needs divergent instructions

# Multi-Agent Skills

Skills in `~/.claude/skills/` for orchestrating multiple AI agents:

## ask-agent

Query another agent (Claude, Codex) and get the response back synchronously. Use for getting a second opinion or different perspective.

```bash
/ask-agent codex "What do you think of this auth approach?"
/ask-agent claude -m opus "Review this design"
```

The response comes back to the calling agent - useful as a subagent pattern.

## spawn-agent

Spawn agents in tmux windows for parallel, interactive work. Use for fan-out workflows where multiple agents work simultaneously.

```bash
/spawn-agent chaos:review codex ./project "Review the auth module"
/spawn-agent chaos:claude-help claude . "Help me debug this"
```

Includes helper scripts:
- `claude-send.sh` - Send messages to running Claude instances (handles timing issues)
- `claude-spawn.sh` - Claude-specific spawner with resume support

## stacked-prs

Detailed workflow guidance for managing stacked PRs. Triggers when discussing PR stacks, rebasing stacks, or merging stacked PRs.

Key principles:
- Only bottom PR targets main; others target the PR below
- Merge one at a time, rebase up the stack
- Never use `-X ours` or `-X theirs` - read and integrate conflicts
- Don't delete branches until whole stack is merged

