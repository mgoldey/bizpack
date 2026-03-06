---
name: wiki-init
description: Initialize a GitHub wiki as a git submodule at docs/ — auto-creates the wiki if it doesn't exist
argument-hint: "[force]"
---

# Wiki Init

Set up the project's GitHub wiki as a git submodule at `docs/`. Auto-creates the wiki repo if it doesn't exist yet.

## Arguments

- `$ARGUMENTS` — Optional. `force` re-initializes even if `docs/` already exists.

## Instructions

### Step 1: Verify prerequisites

Run these checks:

1. Confirm `gh` CLI is installed and authenticated: `gh auth status`
2. Detect the GitHub remote: `gh repo view --json nameWithOwner -q '.nameWithOwner'`
3. If either fails, stop and tell the user what's needed.

Store the owner/repo (e.g. `mgoldey/myproject`) for later steps.

### Step 2: Check if docs/ submodule already exists

- If `docs/` exists and is a submodule (check `.gitmodules`), and `$ARGUMENTS` is not `force`, say it's already set up and stop.
- If `$ARGUMENTS` is `force`, remove the existing submodule first:
  ```bash
  git submodule deinit -f docs
  git rm -f docs
  rm -rf .git/modules/docs
  ```

### Step 3: Ensure wiki is enabled on the repo

```bash
gh api repos/{owner}/{repo} --jq '.has_wiki'
```

If false, enable it:

```bash
gh api repos/{owner}/{repo} -X PATCH -f has_wiki=true
```

### Step 4: Auto-create the wiki if it doesn't exist

Try cloning the wiki to a temp dir to see if it exists:

```bash
git clone --depth 1 "https://github.com/{owner}/{repo}.wiki.git" /tmp/wiki-probe-$$ 2>/dev/null
```

If that fails (wiki repo doesn't exist yet), bootstrap it:

```bash
TMPDIR=$(mktemp -d)
cd "$TMPDIR"
git init
git checkout -b master
cat > Home.md << 'WIKI_EOF'
# {repo name} Documentation

Welcome to the project wiki. Documentation lives here and syncs to the GitHub wiki.

## Getting Started

This wiki is managed as a git submodule at `docs/` in the main repository.
WIKI_EOF
git add Home.md
git commit -m "Initialize wiki"
git remote add origin "https://github.com/{owner}/{repo}.wiki.git"
git push -u origin master
cd -
rm -rf "$TMPDIR"
```

Clean up the probe dir too: `rm -rf /tmp/wiki-probe-$$`

### Step 5: Add the submodule

```bash
git submodule add "https://github.com/{owner}/{repo}.wiki.git" docs
```

### Step 6: Configure submodule for easy sync

Set the submodule to always track master and rebase on pull (reduces merge conflicts across branches):

```bash
git config -f .gitmodules submodule.docs.branch master
git config submodule.docs.update rebase
```

### Step 7: Set up .gitattributes for clean merges

Append a merge strategy for the submodule pointer so that branch merges don't conflict on the `docs` line in the tree:

Check if `.gitattributes` already has a docs entry. If not:

```bash
echo 'docs merge=ours' >> .gitattributes
```

This tells git: when merging branches that disagree on the submodule pointer, keep ours — the wiki-sync command will update it to the latest anyway.

### Step 8: Create initial structure in docs/

If `docs/Home.md` already exists (from the bootstrap), leave it. Otherwise create it.

Also create a `docs/_Sidebar.md` for GitHub wiki navigation:

```markdown
## Navigation

- [[Home]]
```

Commit inside the submodule:

```bash
cd docs
git add -A
git commit -m "Add sidebar navigation" || true
git push origin master
cd ..
```

### Step 9: Commit in parent repo

Stage and commit the submodule addition:

```bash
git add .gitmodules .gitattributes docs
git commit -m "Add GitHub wiki as docs/ submodule"
```

### Step 10: Summary

Tell the user:
- Wiki is live at `https://github.com/{owner}/{repo}/wiki`
- Documentation goes in `docs/` — each `.md` file becomes a wiki page
- Use `/wiki-sync` to push doc changes to the wiki
- GitHub wiki sidebar is at `docs/_Sidebar.md`
- Remind them to run `git submodule update --init` after cloning the repo

## Error Handling

- If `git push` to the wiki fails with 403/404, the user may need to enable wikis in repo Settings > Features, or check their `gh` auth scopes include `repo`.
- If the submodule add fails because `docs/` exists as a regular directory, offer to migrate: move existing files into the wiki submodule after init.
