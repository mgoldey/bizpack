---
name: wiki-sync
description: Sync local docs/ changes to the GitHub wiki — pull, commit, push, update submodule ref
argument-hint: "[message]"
---

# Wiki Sync

Commit and push local documentation changes from `docs/` to the GitHub wiki, handling cross-branch sync.

## Arguments

- `$ARGUMENTS` — Optional commit message. Defaults to "Update documentation".

## Instructions

### Step 1: Verify docs/ is a submodule

Check that `docs/` exists and is listed in `.gitmodules`. If not, tell the user to run `/wiki-init` first and stop.

### Step 2: Check for changes

```bash
cd docs
git status --porcelain
```

If there are no changes (no untracked, modified, or staged files), say "docs/ is already up to date" and stop.

### Step 3: Pull latest from wiki (absorb other branches' changes)

This is critical for cross-branch sync. Other feature branches may have pushed docs since we last synced.

```bash
cd docs
git fetch origin master
git rebase origin/master
```

If the rebase has conflicts:
1. Show the user which files conflict
2. Ask if they want to keep their version (`git checkout --theirs`), keep the wiki version (`git checkout --ours`), or resolve manually
3. After resolution: `git rebase --continue`

### Step 4: Commit local changes

```bash
cd docs
git add -A
git commit -m "${ARGUMENTS:-Update documentation}"
```

### Step 5: Push to wiki

```bash
cd docs
git push origin HEAD:master
```

If push fails (someone pushed between our fetch and push), retry once:

```bash
cd docs
git pull --rebase origin master
git push origin HEAD:master
```

### Step 6: Update submodule ref in parent repo

```bash
cd ..
git add docs
git commit -m "docs: sync wiki submodule ref"
```

This updates the parent repo's pointer to the latest wiki commit.

### Step 7: Summary

Tell the user:
- How many files were changed
- The wiki URL where changes are now live
- Remind them that other branches will pick up these doc changes on their next `/wiki-sync` (via the rebase in step 3)

## Cross-Branch Sync Explained

When multiple feature branches write to `docs/`:

1. Branch A writes `docs/architecture.md`, runs `/wiki-sync` — pushed to wiki master
2. Branch B writes `docs/api.md`, runs `/wiki-sync` — step 3 pulls A's architecture.md first, then pushes both
3. When B merges to main, the submodule pointer includes everything

The wiki repo is always linear (rebased). The parent repo's submodule pointer may differ between branches, but `.gitattributes merge=ours` prevents conflicts — the next `/wiki-sync` on any branch will update to the true latest.
