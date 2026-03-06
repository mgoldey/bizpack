# bizpack

Business communication, strategy, and developer productivity tools for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Commands

| Command | What it does |
|---------|-------------|
| `/minto` | Structures any message using the [Minto Pyramid Principle](https://en.wikipedia.org/wiki/Minto_Pyramid_Principle) — lead with the answer, group arguments, support with evidence |
| `/panel` | Pitches a business idea to a panel of three experts who debate and score it |
| `/docs-index` | Scans the project file tree and regenerates a compressed docs index in CLAUDE.md ([why this works](https://vercel.com/blog/agents-md-outperforms-skills)) |
| `/wiki-init` | Sets up the GitHub wiki as a git submodule at `docs/`, auto-creating the wiki if needed |
| `/wiki-sync` | Syncs local `docs/` changes to the GitHub wiki with cross-branch rebase |

## Installation

### Plugin marketplace (recommended)

Install as a plugin from within Claude Code:

```
/plugin marketplace add mgoldey/bizpack
/plugin install bizpack@mgoldey-bizpack
/plugin install wikidocs@mgoldey-bizpack
```

Commands are available as `/bizpack:minto`, `/bizpack:panel`, `/bizpack:docs-index`, `/wikidocs:wiki-init`, and `/wikidocs:wiki-sync`.

### Clone and use directly

```bash
git clone https://github.com/mgoldey/bizpack.git
cd bizpack
claude  # commands auto-register as /minto and /panel
```

### Copy to an existing project

```bash
mkdir -p your-project/.claude/commands
cp bizpack/plugins/bizpack/commands/*.md your-project/.claude/commands/
```

### Install globally

```bash
mkdir -p ~/.claude/commands
cp bizpack/plugins/bizpack/commands/*.md ~/.claude/commands/
```

## Usage

### /minto

Structure any communication — emails, Slack messages, proposals, presentations — using Barbara Minto's Pyramid Principle. Give it rough notes and it produces a structured outline and a ready-to-send written version.

```
/minto We should switch to weekly releases because monthly releases cause too many merge conflicts, QA bottlenecks, and customer complaints about stale bugs
```

```
/minto I need to tell my VP that we're 2 weeks behind on the project but have a plan to catch up
```

### /panel

Stress-test a business idea with three experts who evaluate from radically different angles:

- **Mr. Wonderful** — cold, numbers-driven, asks "what are your sales?"
- **Mr. Beast** — high-energy, audience-obsessed, asks "would anyone actually care?"
- **Mr. Bean** — lateral thinker who stumbles into the insight everyone else missed

They debate, score, and deliver a verdict (IN / OUT / CONDITIONAL) with actionable next steps.

```
/panel A SaaS tool that turns meeting transcripts into structured action items using AI
```

```
/panel Mobile app for dog owners to find and book nearby dog walkers
```

### /docs-index

Generate a compressed docs index for any project's CLAUDE.md. Based on [Vercel's research](https://vercel.com/blog/agents-md-outperforms-skills) showing that a static docs index in AGENTS.md achieves 100% agent task pass rate vs 53% for skills.

The command scans your project's file tree, builds a compressed pipe-delimited index of all important files and API patterns, and embeds it in `## Docs Index` in your CLAUDE.md. This gives Claude always-on awareness of your codebase structure without needing to invoke any tools.

```
/docs-index rebuild
```

```
/docs-index check
```

### /wiki-init

Set up the GitHub wiki as a git submodule at `docs/`. The command auto-detects your GitHub remote, creates the wiki if it doesn't exist, and configures the submodule for cross-branch sync.

```
/wiki-init
```

```
/wiki-init force
```

Prerequisites: `gh` CLI installed and authenticated.

### /wiki-sync

Push local documentation changes to the GitHub wiki. Handles cross-branch sync by rebasing on the wiki's master before pushing — so docs written on different feature branches merge cleanly.

```
/wiki-sync
```

```
/wiki-sync "Add API reference docs"
```

**How cross-branch sync works:**
1. Branch A writes `docs/architecture.md` and runs `/wiki-sync` — pushed to wiki
2. Branch B writes `docs/api.md` and runs `/wiki-sync` — pulls A's changes first via rebase, then pushes both
3. The wiki stays linear; the parent repo's submodule pointer updates on each branch independently

## Hooks

Hooks are registered automatically when each plugin is installed.

### bizpack hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| **docs-index reminder** | `git commit` (PostToolUse on Bash) | If the project has a `## Docs Index` section in CLAUDE.md, reminds Claude to run `/docs-index rebuild` when files may have changed |

### wikidocs hooks

| Hook | Trigger | What it does |
|------|---------|-------------|
| **docs/ redirect** | Write tool (PostToolUse on Write) | When Claude writes a `.md` file outside `docs/`, reminds it to use the wiki submodule instead (only if the project has a `docs/` submodule) |
| **wiki sync reminder** | `git commit` (PostToolUse on Bash) | If `docs/` has uncommitted changes after a commit, reminds Claude to run `/wiki-sync` |

## License

MIT
