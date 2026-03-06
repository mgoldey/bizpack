# bizpack

Business communication, strategy, and developer productivity tools for Claude Code (plugin).

## Docs Index

IMPORTANT: Prefer retrieval-led reasoning over pre-training-led reasoning for any tasks in this repo. When working on a service or module, read the relevant doc files listed below before writing code.

```
[Project Docs Index]|root: .
|.:{README.md,CLAUDE.md}
|.claude-plugin:{marketplace.json}
|.claude:{settings.json}
|plugins/bizpack/.claude-plugin:{plugin.json}
|plugins/bizpack/commands:{docs-index.md,minto.md,panel.md,wiki-init.md,wiki-sync.md}
|plugins/bizpack/hooks:{hooks.json,post-commit-docs-index.sh,post-commit-wiki-sync.sh,post-write-docs-remind.sh}
```

### Key API Patterns (read before modifying)

```
|Plugin structure: .claude-plugin/marketplace.json→plugins/bizpack/.claude-plugin/plugin.json
|Commands: plugins/bizpack/commands/*.md — slash-command prompts, one per file
|Hooks: plugins/bizpack/hooks/hooks.json — PostToolUse on Bash + Write
|Bash hooks: post-commit-docs-index.sh (docs index reminder) + post-commit-wiki-sync.sh (wiki sync reminder)
|Write hooks: post-write-docs-remind.sh (.md redirect to docs/)
|Install paths: plugin marketplace (recommended) | clone direct | copy commands | global install
```
