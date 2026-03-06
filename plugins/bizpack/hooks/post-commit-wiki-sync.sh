#!/bin/bash
# PostToolUse hook: after a git commit, remind to sync docs if the wiki submodule has changes.
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

# Only trigger on git commit commands
if [[ "$COMMAND" != *"git commit"* ]]; then
  exit 0
fi

CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || true)
DOCS_DIR="${CWD:-.}/docs"
GITMODULES="${CWD:-.}/.gitmodules"

# Check if docs/ wiki submodule exists
if [ ! -f "$GITMODULES" ] || ! grep -q 'path = docs' "$GITMODULES" 2>/dev/null; then
  exit 0
fi

# Check if there are uncommitted changes in docs/
if [ -d "$DOCS_DIR" ]; then
  CHANGES=$(cd "$DOCS_DIR" && git status --porcelain 2>/dev/null || true)
  if [ -n "$CHANGES" ]; then
    echo "The docs/ wiki submodule has uncommitted changes. Run /wiki-sync to push them to the GitHub wiki."
  fi
fi

exit 0
