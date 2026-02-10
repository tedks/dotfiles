#!/bin/bash
# Block destructive commands even in bypass permissions mode.
# Claude Code PreToolUse hook — exits with deny JSON to block, exits 0 to allow.

INPUT=$(cat)
COMMAND=$(jq -r '.tool_input.command' <<< "$INPUT")

DANGEROUS_PATTERNS=(
  'rm -rf'
  'rm -fr'
  'git clean -f'
  'git checkout \.'
  'git restore \.'
  'git reset --hard'
  'git push.*--force[^-]'
  'git push.*-f[^o]'
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    jq -n --arg reason "Blocked by hook: '$pattern' matched. Ask the user to run this manually." '{
      hookSpecificOutput: {
        hookEventName: "PreToolUse",
        permissionDecision: "deny",
        permissionDecisionReason: $reason
      }
    }'
    exit 0
  fi
done

exit 0
