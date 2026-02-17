---
name: docs-index
description: Scan the project file tree and regenerate a compressed docs index in CLAUDE.md. Keeps the agent's codebase map fresh after adding/removing/renaming files.
argument-hint: "[rebuild|check]"
---

# Docs Index Generator

Regenerate the `## Docs Index` section in the project's CLAUDE.md from the current file tree.

Inspired by [Vercel's finding](https://vercel.com/blog/agents-md-outperforms-skills) that a compressed docs index embedded in AGENTS.md/CLAUDE.md achieves 100% pass rate vs 53% for skills, because passive context beats active retrieval.

## Arguments

- `$ARGUMENTS` — Optional. `rebuild` (default) regenerates the index. `check` shows what would change without writing.

## Instructions

### Step 1: Find or create the Docs Index section

Look for `## Docs Index` in the project's CLAUDE.md. If it doesn't exist, append a new section at the end.

### Step 2: Scan the file tree

Walk the project directory and build a compressed pipe-delimited index of all important files. Use this format:

```
[Project Docs Index]|root: .
|service-or-dir:{file1.py,file2.py,README.md}
|service-or-dir/subdir:{file1.py,file2.py}
```

**What to include:**
- All `.py`, `.ts`, `.js`, `.go`, `.rs` source files in key directories (not vendored/generated)
- All `.md` documentation files (not in node_modules, .venv, etc.)
- Config files that define behavior (pyproject.toml, package.json, etc.)
- Helm charts, Terraform, CI/CD workflows

**What to exclude:**
- `__pycache__/`, `.venv/`, `node_modules/`, `.git/`, build artifacts
- Generated files (lock files, compiled output)
- Test fixtures / snapshot files
- Individual `__init__.py` files (include them in directory listings though)

**Organize by service/module boundaries**, not flat file listing. Group related files under their parent directory.

### Step 3: Build the Key API Patterns block

Below the file tree index, add a `### Key API Patterns (read before modifying)` section. Summarize the project's key patterns in compressed pipe-delimited format:

```
|Pattern Name: key_function()|related_type→other_type|important constants
```

To discover patterns, read:
- Main entry points (main.py, app.py, index.ts)
- Route/endpoint definitions
- Core data models and types
- Factory/registry patterns
- Configuration/settings files

### Step 4: Add the retrieval instruction

Always include this line above the index:

```
IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for any tasks in this repo. When working on a service or module, read the relevant doc files listed below before writing code.
```

### Step 5: Replace the section in CLAUDE.md

Replace everything from `## Docs Index` to the next `## ` heading (or end of file) with the new content. Use this Python snippet for reliable replacement:

```python
import re
pattern = r'## Docs Index.*?(?=\n## [^#]|\Z)'
new_content = re.sub(pattern, replacement.rstrip(), content, count=1, flags=re.DOTALL)
```

### Step 6: Verify

- Confirm exactly one `## Docs Index` section exists (no duplicates)
- Run the replacement a second time to confirm idempotency
- Show the user a summary of what changed (files added/removed)

## Design Principles

- **Compress aggressively.** An index pointing to readable files works as well as full docs in context. Target <5KB.
- **Organize semantically.** Group by service/module boundaries, not alphabetical flat lists.
- **Include everything real, exclude everything generated.** The index should reflect files a developer would actually read or modify.
- **Idempotent.** Running twice produces identical output.
