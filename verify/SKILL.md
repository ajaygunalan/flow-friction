---
description: Verify implementation matches the plan
allowed-tools: Read, Glob, Grep, Bash, TaskList
---

## Plan

!`cat docs/plan/*.md 2>/dev/null || echo "NO PLAN FOUND in docs/plan/ — tell user and stop."`

---

Verify implementation against the plan above and TaskList. For each requirement: does the code exist, does it match spec, are tests passing? Report what's complete, what's missing, what diverges. Do not fix anything.
