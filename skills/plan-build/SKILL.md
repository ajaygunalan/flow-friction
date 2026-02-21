---
name: plan-build
description: Decide build order — layer the pieces into a pyramid with dependencies and risks
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Plan Build: $ARGUMENTS

## Prerequisite

`docs/research/what-to-build.md` must exist with sharp Q structure.

If it's missing: "Run `/brain-dump <your topic>` first." Stop.

## What this produces

`docs/research/how-to-build.md` — layered build pyramid.

## Boundary

Don't reproduce what AGENTS.md already covers. No Layer 0 inventory of existing code. No premature sections about future phases or tooling. Stay focused on what's being built now.

## Steps

1. Read `what-to-build.md`
2. Discuss with user first — reflect understanding, identify tensions
3. Scale the debate by complexity:
   - **Few pieces (< 5):** single agent synthesizes the build order
   - **Many pieces (5+):** spawn 3 lens agents + 1 moderator:
     - Lens 1: Scope & Boundaries
     - Lens 2: Stacking Order
     - Lens 3: Risks & Mitigations
     - Moderator: synthesize into layered pyramid
4. Write `docs/research/how-to-build.md` — layered pyramid with per-piece:
   - **What**: what this piece does
   - **Depends on**: which pieces must be built first
   - **Build**: what exists when this piece is done — deliverables only. Not how to implement them. Implementation belongs in plan mode, not here.
   - **Test**: how to verify it works
   - **Risk**: what can go wrong and how to detect/mitigate early
5. End with: build order diagram, merge points, and milestone markers.
6. AskUserQuestion: revise or accept?

## Commit

`git add docs/research/how-to-build.md && git commit -m "plan-build: layered build pyramid"`

## Next

"Next: `/plan-tests` to write tests for each piece."
