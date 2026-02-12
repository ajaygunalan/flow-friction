---
description: Commit and push — analyzes changes, offers commit message options, pushes
allowed-tools:
  - Read
  - Bash
  - AskUserQuestion
---

## What changed?

```
Branch: !`git branch --show-current`

Unpushed commits:
!`git log origin/$(git branch --show-current)..HEAD --oneline 2>/dev/null || echo "(no remote tracking)"`

Changed files:
!`git diff --stat`

Untracked:
!`git status -s`
```

Review the state above. If nothing to commit and nothing to push, stop. Read the diffs and understand what changed.

## Why did it change?

Understand the purpose from the diffs and conversation context. This informs the commit message.

## What do we call it?

Write the commit message:
- **Subject line** (~50-72 chars): High-level *what and why* — strategy, not tactics. Written as a command ("Fix X by doing Y", "Add X for Y"). A stranger reading just this line should understand the purpose.
- **Body** (if multiple changes): One blank line after subject, then bullet points for the key tactical changes. Each bullet is a specific *what you did*, not a restatement of the subject.

Present 4 options via the ask_user_question tool: same intent, four distinct phrasings. Each option captures the change from a fresh angle — different words, different rhythm, different emphasis. User picks or writes their own. Stage changed files by name. Commit with the user's chosen message exactly as they picked it. Push to origin. Verify with git status.

---

- Use the user's selected message exactly as-is. If they pick a multi-line message, use a heredoc for the commit.
- Stage specific files by name.
