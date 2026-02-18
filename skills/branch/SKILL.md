---
description: Create a git worktree + branch for isolated work
argument-hint: "<branch-name>"
allowed-tools:
  - Bash
---

Abort if not in a git repo, `$ARGUMENTS` is empty, or branch already exists.

Detect the repo name from the current directory basename. Create the worktrees folder `../<repo-name>-worktrees/` if it doesn't exist. Run `git worktree add ../<repo-name>-worktrees/$ARGUMENTS -b $ARGUMENTS`. Confirm with the full path, remind user to `cd` into it and run `claude` there.
