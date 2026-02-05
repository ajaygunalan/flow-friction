---
disable-model-invocation: true
description: Add checkpoint marker and push all commits
allowed-tools:
  - Read
  - Edit
  - Bash
  - AskUserQuestion
---

Push all unpushed commits with a `[>>]` checkpoint marker for human navigation.

## Current State

```
Branch: !`git branch --show-current`

Unpushed commits:
!`git log origin/$(git branch --show-current)..HEAD --oneline 2>/dev/null || echo "(no remote tracking)"`

Changed files:
!`git diff origin/$(git branch --show-current)..HEAD --stat 2>/dev/null || git diff --stat`

Working tree:
!`git status -s`
```

## Process

1. **Gather** — review the state above. If nothing to push, stop.

2. **Summarize** — analyze all changes since last push.

3. **Ask user** — generate 4 checkpoint message options (imperative mood, ~50 chars). Use AskUserQuestion. User selects one.

4. **Commit and push:**
   - Stage uncommitted changes (specific files, not `git add -A`).
   - If uncommitted changes exist, commit them first.
   - Create empty checkpoint commit: `git commit --allow-empty -m "[>>] <user's message VERBATIM>"`
   - `git push origin $branch`
   - Verify with `git status`

## Rules

- User's selected message goes VERBATIM after `[>>]` — never modify it
- Never `git add -A` — stage specific files
- Never skip hooks, never force push
- The `[>>]` commit is empty (`--allow-empty`) — it's just a marker
