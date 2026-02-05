---
description: Execute a plan using subagent delegation with atomic commits
allowed-tools: Task, TaskCreate, TaskList, TaskUpdate, Read, Glob, Grep, Bash, Edit, Write
---

Implement @docs/plan/*.md — one subagent per task via Task tool. Commit after each (stage specific files). Track via TaskList so it's resumable. Don't skip failures.
