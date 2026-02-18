---
description: Create a git worktree + branch for isolated work
argument-hint: "<branch-name>"
allowed-tools:
  - Bash
---

Abort if not in a git repo, `$ARGUMENTS` is empty, or branch already exists.

Ensure `.worktrees/` is in `.gitignore` at repo root. If missing, append and stage it.

Run `git worktree add .worktrees/$ARGUMENTS -b $ARGUMENTS`. Confirm with path, remind user to `cd` into it.
