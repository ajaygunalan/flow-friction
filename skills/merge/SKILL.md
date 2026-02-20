---
description: Squash-merge a worktree branch into main — rebase, test, merge, free slot
argument-hint: "<branch-name>"
allowed-tools:
  - Bash
  - Read
  - Grep
  - AskUserQuestion
---

Abort if `$ARGUMENTS` is empty. Find the worktree path for `$ARGUMENTS` via `git worktree list`. Abort if branch or worktree doesn't exist. Abort if worktree has dirty working directory.

## Detect layout

Check `git worktree list`. If the first entry ends with `(bare)` → **standalone** (bare repo + internal worktrees). Otherwise → **nested** (original repo is main, worktrees are external).

## Rebase

`cd` into the worktree. Tag `backup/$ARGUMENTS` as safety net. Fetch and rebase onto `origin/main`. Conflict → `git rebase --abort`, tell user to fix in worktree, run `/merge` again. Stop.

## Test

Detect test runner in order: `package.xml` (ROS2 — run `bash ~/.claude/skills/merge/scripts/ros2-test.sh <worktree-path>`), `package.json`, Makefile `test` target, `Cargo.toml`, pytest, `go.mod`. If none found, ask user. Fail → abort.

## Squash merge

Find the main worktree — the entry in `git worktree list` with branch `[main]`. `cd` there. `git merge --squash --ff-only $ARGUMENTS`. FF-only fail → abort.

## Commit message

Read branch log and staged diff. Present 4 commit message options via ask_user_question — same intent, four distinct phrasings. User picks or writes their own. Commit.

## Push + free slot

Push main. If push fails → warn but continue.

Delete the backup tag. Delete the remote branch (ignore if never pushed).

**Free the slot:** `cd` into the worktree that had the merged branch. Extract the slot name by finding a path component matching `w<N>` where N is any digit (match `/w[0-9]+/` or `/w[0-9]+` at end of path — not substrings in repo names). Run `git checkout <slot>-slot` to reset the slot to its placeholder branch. Delete the local feature branch.

Print `git log --oneline -5` from the main worktree to confirm.
