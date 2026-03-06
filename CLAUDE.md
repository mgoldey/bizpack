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
|plugins/bizpack/commands:{docs-index.md,minto.md,panel.md}
|plugins/bizpack/hooks:{hooks.json,post-commit-docs-index.sh}
|plugins/wikidocs/.claude-plugin:{plugin.json}
|plugins/wikidocs/commands:{wiki-init.md,wiki-sync.md}
|plugins/wikidocs/hooks:{hooks.json,post-write-docs-remind.sh,post-commit-wiki-sync.sh}
```

### Key API Patterns (read before modifying)

```
|Plugin structure: .claude-plugin/marketplace.json→plugins/{name}/.claude-plugin/plugin.json
|Commands: plugins/{name}/commands/*.md — slash-command prompts, one per file
|Hooks: plugins/{name}/hooks/hooks.json — PostToolUse definitions + shell scripts
|bizpack hooks: PostToolUse on Bash (git commit → docs-index reminder)
|wikidocs hooks: PostToolUse on Write (.md redirect to docs/) + Bash (git commit → wiki-sync reminder)
|Install paths: plugin marketplace (recommended) | clone direct | copy commands | global install
```
