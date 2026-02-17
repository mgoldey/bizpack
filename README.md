# bizpack

Business communication, strategy, and developer productivity tools for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Commands

| Command | What it does |
|---------|-------------|
| `/minto` | Structures any message using the [Minto Pyramid Principle](https://en.wikipedia.org/wiki/Minto_Pyramid_Principle) — lead with the answer, group arguments, support with evidence |
| `/panel` | Pitches a business idea to a panel of three experts who debate and score it |
| `/docs-index` | Scans the project file tree and regenerates a compressed docs index in CLAUDE.md ([why this works](https://vercel.com/blog/agents-md-outperforms-skills)) |

## Installation

### Plugin marketplace (recommended)

Install as a plugin from within Claude Code:

```
/plugin marketplace add mgoldey/bizpack
/plugin install bizpack@mgoldey-bizpack
```

Commands are available as `/bizpack:minto`, `/bizpack:panel`, and `/bizpack:docs-index`.

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

## Hooks

The plugin includes a **PostToolUse hook** that fires after every `git commit`. If your project's CLAUDE.md has a `## Docs Index` section, Claude gets a reminder to run `/docs-index rebuild` when files may have changed. This keeps the index fresh without you having to remember.

The hook is registered automatically when the plugin is installed.

## License

MIT
