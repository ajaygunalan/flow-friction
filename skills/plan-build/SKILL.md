---
name: plan-build
description: Decide build order — layer the pieces into a pyramid with dependencies and human-AI workflow
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Plan Build: $ARGUMENTS

## Prerequisite

Both must exist in `docs/research/`:
- `what-to-build.md` (sharp, with Q1/Q2 structure)
- `how-to-test.md`

If `what-to-build.md` is missing: "Run `/brain-dump <your topic>` first." Stop.
If `how-to-test.md` is missing: "I need the test plan first. Run `/plan-tests`." Stop.

## What this produces

`docs/research/how-to-build.md` — layered build pyramid.

## Steps

1. Read both docs
2. Discuss with user first — reflect understanding, identify tensions
3. Scale the debate by complexity:
   - **Few pieces (< 5):** single agent synthesizes the build order
   - **Many pieces (5+):** spawn 3 lens agents + 1 moderator:
     - Lens 1: Scope & Boundaries (granularity, interfaces)
     - Lens 2: Stacking Order (risk vs dependencies vs research value)
     - Lens 3: Feedback Loop (verification, observability, human-AI workflow)
     - Moderator: synthesize into layered pyramid
4. Write `docs/research/how-to-build.md` — layered pyramid with per-piece:
   - What to build, depends on, pass/fail, what's logged, human does, AI does
5. AskUserQuestion: revise or accept?

## Commit

`git add docs/research/how-to-build.md && git commit -m "plan-build: layered build pyramid"`

## Next

"Next: `/check-research` to verify the 3 research docs align, then `/write-specs` to produce spec files."
