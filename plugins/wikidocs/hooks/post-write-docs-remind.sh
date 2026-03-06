#!/bin/bash
# PostToolUse hook: when Claude writes a .md file outside docs/, remind to use the wiki.
# Only fires on Write tool calls. Outputs a nudge that Claude sees in context.
set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null || true)

# Only trigger on Write tool calls
if [[ "$TOOL" != "Write" ]]; then
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)

# Only care about .md files
if [[ "$FILE_PATH" != *.md ]]; then
  exit 0
fi

# Skip files that belong in the repo root (not documentation)
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  CLAUDE.md|README.md|AGENTS.md|CHANGELOG.md|CONTRIBUTING.md|LICENSE.md|CODE_OF_CONDUCT.md)
    exit 0
    ;;
esac

# Skip if the file is already in docs/
if [[ "$FILE_PATH" == */docs/* ]]; then
  exit 0
fi

# Check if this project has a docs/ wiki submodule
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || true)
GITMODULES="${CWD:-.}/.gitmodules"

if [ -f "$GITMODULES" ] && grep -q 'path = docs' "$GITMODULES" 2>/dev/null; then
  echo "You wrote a .md file outside docs/. This project uses a GitHub wiki submodule at docs/ for documentation. Consider moving this file to docs/ so it appears on the wiki, then run /wiki-sync."
fi

exit 0
