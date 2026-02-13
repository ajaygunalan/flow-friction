---
description: Execute a plan using subagent delegation
allowed-tools: Task, TaskCreate, TaskList, TaskUpdate, Read, Glob, Grep, Bash, Edit, Write
---

## What's the plan?

!`cat docs/plan/*.md 2>/dev/null || echo "NO PLAN FOUND in docs/plan/ — tell user and stop."`

## Who does what?

Implement the plan above — one subagent per task via Task tool.

Each subagent commits atomically after completing its task — small, self-contained commits with clear messages.
