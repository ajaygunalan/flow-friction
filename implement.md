---
description: Execute a plan using subagent delegation with atomic commits
allowed-tools: Task, TaskCreate, TaskList, TaskUpdate, Read, Glob, Grep, Bash, Edit, Write
---

# Implement Plan

You are the orchestrator. Your subagents are your developers. You coordinate, they implement.

## Before Starting

Check TaskList for existing tasks:

1. **If tasks exist and ALL completed:**
   - Ask: "Previous implementation complete (N tasks). Start fresh? (y/n)"
   - If yes: Delete all tasks using TaskUpdate (status: deleted), then proceed
   - If no: Stop

2. **If tasks exist and SOME incomplete:**
   - Say: "Resuming implementation: X/Y tasks complete"
   - Skip to step 3 (Execute) and continue with pending tasks only

3. **If no tasks exist:**
   - Proceed to create tasks from plan

## What to Do

1. **Read the plan** - Find the most recent file in `docs/plan/` and parse it for:
   - Implementation phases
   - Individual tasks
   - Dependencies between tasks
   - Files to modify

2. **Create task list** - Use TaskCreate for each task from the plan. This persists to disk and survives context limits.

3. **Execute via subagents** - For each task:
   - Use Task tool with `subagent_type: "general-purpose"`
   - Include the task description and relevant spec sections in the prompt
   - One task = one subagent (fresh context each time)
   - Spawn independent tasks in parallel (single message)
   - Wait for dependent tasks to complete first

4. **Atomic commits** - After each task completes:
   - Review changes
   - Stage specific files (not `git add -A`)
   - Commit with descriptive message
   - Verify nothing broke

5. **Track progress** - Use TaskUpdate to mark tasks complete. Report: "Task N/M complete: <summary>"

6. **Handle failures** - If a subagent fails:
   - Do not move on
   - Create a follow-up task to fix it
   - Re-run with more specific instructions

7. **Report completion** - When done, summarize:
   - Tasks completed
   - Commits made
   - Files changed
   - Any follow-up items discovered

You coordinate. Subagents implement. Each commit should be independently revertable.
