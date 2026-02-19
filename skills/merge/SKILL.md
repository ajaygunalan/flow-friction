---
description: Squash-merge a worktree branch into main — rebase, test, merge, clean up
argument-hint: "<branch-name>"
allowed-tools:
  - Bash
  - Read
  - Grep
  - AskUserQuestion
---

Abort if `$ARGUMENTS` is empty. Find the worktree path for `$ARGUMENTS` via `git worktree list`. Abort if branch or worktree doesn't exist. Abort if worktree has dirty working directory.

## Rebase

`cd` into the worktree. Tag `backup/$ARGUMENTS` as safety net. Fetch and rebase onto `origin/main`. Conflict → `git rebase --abort`, tell user to fix in worktree, run `/merge` again. Stop.

## Test

Detect test runner in order: `package.xml` (ROS2 — run `bash ~/.claude/skills/merge/scripts/ros2-test.sh <worktree-path>`), `package.json`, Makefile `test` target, `Cargo.toml`, pytest, `go.mod`. If none found, ask user. Fail → abort.

## Squash merge

Find main worktree path via `git worktree list`. `cd` there. `git merge --squash --ff-only $ARGUMENTS`. FF-only fail → abort.

## Commit message

Read branch log and staged diff. Present 4 commit message options via ask_user_question — same intent, four distinct phrasings. User picks or writes their own. Commit.

## Push + clean up

Push main. If push fails → warn but continue.

Remove worktree, delete local branch, delete remote branch (ignore if never pushed), delete backup tag. For ROS2 packages (worktree path contains `/src/<pkg>`), also `rm -rf` the overlay workspace directory (two levels up from the git worktree path) to clean up `build/` and `install/`. Print `git log --oneline -5` to confirm.
