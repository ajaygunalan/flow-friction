---
description: Execute a plan using subagent delegation
allowed-tools: Task, TaskCreate, TaskList, TaskUpdate, Read, Glob, Grep, Bash
---

## What's the plan?

!`cat docs/plan/*.md 2>/dev/null || echo "NO PLAN FOUND in docs/plan/ — tell user and stop."`

## Who does what?

If the plan contains unresolved TBD/TODO markers or is older than the most recent research scratchpad, warn the user before proceeding. If no `/verify-plan` run is evident in recent history, suggest it before proceeding.

Create a task (TaskCreate) for each plan item before spawning subagents. Mark tasks in_progress when the subagent starts, completed when it finishes.

Implement the plan — one general-purpose subagent per task via Task tool. For each subagent, pass: the relevant plan section, file paths the task touches, and any constraints or conventions from CLAUDE.md.

Each subagent commits atomically after completing its task — small, self-contained commits with clear messages.

For large plans, don't spawn every task at once. Work in batches — launch a few subagents, wait for results, then continue.
