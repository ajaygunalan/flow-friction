---
name: check-the-blueprint
description: Cross-check the full research blueprint — trace bricks to tests to questions, find gaps
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Check The Blueprint: $ARGUMENTS

## Prerequisite

All three must exist in `docs/research/`:
- `what-to-build.md`
- `how-to-test.md`
- `how-to-build.md`

If any are missing, tell the user which one and which skill to run. Stop.

## What this produces

A gap report — output to user, no new file.

## Steps

Read all three docs. Check:
- Every brick in `how-to-build.md` traces to a test in `how-to-test.md`
- Every test traces to a question in `what-to-build.md`
- No orphan tests or orphan bricks
- Dependencies consistent across docs
- Build order respects test dependencies

Report gaps. Suggest fixes.
