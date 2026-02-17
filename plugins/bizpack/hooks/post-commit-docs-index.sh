#!/bin/bash
# PostToolUse hook: after a git commit, remind Claude to update the docs index.
# Only fires on git commit Bash calls. Outputs a nudge that Claude sees in context.
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

# Only trigger on git commit commands
if [[ "$COMMAND" == *"git commit"* ]]; then
  CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || true)
  CLAUDE_MD="${CWD:-.}/CLAUDE.md"

  # Only nudge if the project has a Docs Index section to update
  if [ -f "$CLAUDE_MD" ] && grep -q "^## Docs Index" "$CLAUDE_MD" 2>/dev/null; then
    echo "Commit complete. The Docs Index in CLAUDE.md may be stale — run /docs-index rebuild if files were added, removed, or renamed."
  fi
fi

exit 0
