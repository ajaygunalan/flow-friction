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

## Process

1. **Gather** — run in parallel: `git status`, `git branch --show-current`, `git log origin/$branch..HEAD --oneline`, `git diff origin/$branch..HEAD --stat`. If nothing to push, stop.

2. **Summarize** — analyze all changes since last push.

3. **Clear session log** — remove all entries from `## Session Log` in CLAUDE.md (keep the heading). Skip if no section exists.

4. **Ask user** — generate 4 checkpoint message options (imperative mood, ~50 chars). Use AskUserQuestion. User selects one.

5. **Commit and push:**
   - Stage uncommitted changes (specific files, not `git add -A`). Include CLAUDE.md if session log was cleared.
   - If uncommitted changes exist, commit them first.
   - Create empty checkpoint commit: `git commit --allow-empty -m "[>>] <user's message VERBATIM>"`
   - `git push origin $branch`
   - Verify with `git status`

## Rules

- User's selected message goes VERBATIM after `[>>]` — never modify it
- Never `git add -A` — stage specific files
- Never skip hooks, never force push
- The `[>>]` commit is empty (`--allow-empty`) — it's just a marker
