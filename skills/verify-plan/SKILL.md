---
name: verify-plan
description: Verify and refine a plan before implementation.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
---

Read `docs/plan/<>.md`. If no plan exists, tell the user and stop.

Step 1 — Use the `ask_user_question tool` : "Do you have any questions about the plan before we implement?" Let the user flag design decisions, preferences, or concerns the agent can't resolve alone.

Step 2 — Check each user requirement against the plan. Fix what's missing or partial. Keep changes minimal — preserve structure, don't rewrite.
