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

# Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
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

# Version Control

Commit and push often.

Make granular commits with detailed commit messages.

Create draft PRs as early as possible.

When merging PRs, make "normal" merges, not squashes or rebases, to preserve the commit graph.

## Stacked PRs

Always use the /stacked-prs skill (see skills in this document for more).

Always consider if there are multiple logical PRs that can be made from a single big change. Make "stacked" PRs if this occurs so that we can iterate on each of them independently.

When merging stacked PRs, merge the root PR into main, then rebase the PR up the stack on main.

Do not delete branches until the whole stack is merged, for recoverability.

## Worktree Awareness

I use git worktrees with a bare repo at the project root. Structure:
```
~/Projects/<project-name>/
├── .git/                     # bare git repo (no working tree here!)
├── master/                   # worktree for main branch
└── <feature-branch>/         # worktrees for feature branches
```

**If you open a session at `~/Projects/<project-name>/` and see no working tree, that's correct.** The `.git/` here is a bare repo. `cd` into `master/` or the appropriate feature worktree before doing any git operations.

When starting a session:

1. **Check where you are:** `pwd` — if you're at the project root (not inside a worktree), `cd` into the right worktree first
2. **Confirm the worktree:** `git worktree list` shows all worktrees
3. **Confirm the branch:** `git branch --show-current`
4. If launched from `master/` but the task involves a feature branch, **ask me** which worktree to use before making changes
5. Stay in the designated worktree for the entire task

To create a new worktree:
```bash
cd ~/Projects/
git worktree add -b <branch-name> <path>
```

## Branch and PR Workflow

**Never push directly to main/master, even if it's unprotected.**

Always:
1. Create a feature branch: `git checkout -b <descriptive-branch-name>`
2. Make commits on the branch
3. Push the branch: `git push -u origin <branch-name>`
4. Create a draft PR: `gh pr create --draft`
5. When ready for review, mark ready: `gh pr ready`
6. Merge via PR, not direct push

This applies even for small changes. The PR is the unit of reviewable work.

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

**Convention for global config:** `~/.claude/CLAUDE.md` is the source of truth. `~/.codex/AGENTS.md` symlinks to it.

**Convention for repo config:** Either CLAUDE.md or AGENTS.md can be the source of truth. All others symlink to it.

When editing agent instructions:
1. Follow the symlink to the canonical file
2. If symlinks don't exist, create them
3. Only break the symlink if a specific agent needs divergent instructions

# Multi-Agent Skills

**Always use these skills for multi-agent work. Do not improvise with manual tmux commands.**

Skills for orchestrating multiple AI agents (invoke via `/skill-name`):

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

Includes helper scripts in the skill's `scripts/` directory:
- `claude-send.sh` - Send messages to running Claude instances (handles timing issues)
- `claude-spawn.sh` - Claude-specific spawner with resume support

### Communicating with Running Agents

**Always use the `claude-send.sh` script from the spawn-agent skill to message running Claude instances.** Do not manually attach to tmux and type, and do not use raw `tmux send-keys` — this causes timing issues and garbled input.

If `claude-send.sh` isn't working, tell me rather than falling back to manual methods.

## stacked-prs

Detailed workflow guidance for managing stacked PRs. Triggers when discussing PR stacks, rebasing stacks, or merging stacked PRs.

Key principles:
- Only bottom PR targets main; others target the PR below
- Merge one at a time, rebase up the stack
- Never use `-X ours` or `-X theirs` - read and integrate conflicts
- Don't delete branches until whole stack is merged
