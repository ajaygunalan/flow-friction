---
description: Commit and push — analyzes changes, offers commit message options, pushes
allowed-tools:
  - Read
  - Bash
  - AskUserQuestion
---

Commit all changes and push.

## Current State

```
Branch: !`git branch --show-current`

Unpushed commits:
!`git log origin/$(git branch --show-current)..HEAD --oneline 2>/dev/null || echo "(no remote tracking)"`

Changed files:
!`git diff --stat`

Untracked:
!`git status -s`
```

## Process

1. Review the state above. If nothing to commit and nothing to push, stop.

2. Read the diffs and understand what changed and why.

3. Generate 4 commit message options (~50 chars, written as commands like "Add login validation", "Fix memory leak"). Use AskUserQuestion so the user picks one or writes their own.

4. Stage changed files by name. Commit with the user's chosen message exactly as they picked it. Push to origin. Verify with git status.

## Rules

- Ask the user to pick a commit message before committing.
- Use the user's selected message exactly as-is.
- Stage specific files by name.
