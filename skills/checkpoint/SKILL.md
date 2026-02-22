---
description: Mark a human-verified milestone — summarizes work since last checkpoint, creates an empty checkpoint commit, pushes
allowed-tools:
  - Read
  - Bash
  - AskUserQuestion
---

## Anything uncommitted?

Check `git status -s`. If there are uncommitted changes (user hand-edits), stage all and commit them as a regular commit before proceeding. Then continue to the checkpoint.

## What happened since last checkpoint?

```
Last checkpoint:
!`git log --grep="^checkpoint:" -1 --format="%H %s" 2>/dev/null || echo "(none)"`

Branch: !`git branch --show-current`
```

Find the last `checkpoint:` commit hash. If none exists, use the merge-base with the default branch (`git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null || git rev-list --max-parents=0 HEAD`).

Show all commits since that baseline:

```bash
git log <baseline>..HEAD --oneline
```

Show the diff summary:

```bash
git diff <baseline>..HEAD --stat
```

Read the diffs and understand what changed.

## Why did it change?

Understand the purpose from the diffs and conversation context. This informs the checkpoint message.

## What do we call it?

Present 4 options via the ask_user_question tool: same intent, four distinct phrasings. Each captures the work from a fresh angle — different words, different rhythm, different emphasis. User picks or writes their own.

Create an empty commit:

```bash
git commit --allow-empty -m "checkpoint: <chosen message>" -m "Tested-by: $(git config user.name)"
```

## Push

`git push` and verify with `git status`.
