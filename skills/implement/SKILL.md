---
description: Execute a plan using subagent delegation with atomic commits
allowed-tools: Task, TaskCreate, TaskList, TaskUpdate, Read, Glob, Grep, Bash, Edit, Write
---

## Plan

!`cat docs/plan/*.md 2>/dev/null || echo "NO PLAN FOUND in docs/plan/ — tell user and stop."`

---

Implement the plan above — one subagent per task via Task tool. Commit after each (stage specific files). Track via TaskList so it's resumable. Don't skip failures.
