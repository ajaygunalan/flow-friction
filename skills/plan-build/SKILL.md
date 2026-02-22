---
name: plan-build
description: Decide build order — layer the pieces into a pyramid with dependencies and risks
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Plan Build: $ARGUMENTS

## Prerequisite

`docs/research/what-to-build.md` must exist with sharp Q structure.

If it's missing: "Run `/brainstorm <your topic>` first." Stop.

## What this produces

`docs/research/how-to-build.md` — layered build pyramid.

## Boundary

Don't reproduce what AGENTS.md already covers. No Layer 0 inventory of existing code. No premature sections about future phases or tooling. Stay focused on what's being built now.

## How this works

The heavy thinking already happened in `/brainstorm`. Here you're structuring — taking sharp questions and organizing them into a layered build pyramid with dependencies. The back-and-forth is shorter and more focused than brainstorm.

1. Read `what-to-build.md`
2. Reflect understanding back to the user. Surface dependency tensions, ordering disagreements, pieces that might be parallelizable. Let the user steer.
3. Converge on the build order through discussion — not one round, but not a full dance either. A few focused exchanges about what layers on what.
4. Write `docs/research/how-to-build.md` — layered pyramid with per-piece:
   - **What**: what this piece does
   - **Depends on**: which pieces must be built first
   - **Build**: what exists when this piece is done — deliverables and data contracts only. Plan mode reads the codebase and figures out how to implement. Common leaks to avoid:
     - Threading/locking strategy ("lock-protected slot, no queue")
     - API choices ("OpenCV setMouseCallback", "cv2.imshow")
     - Per-tick/per-step flow ("each tick: poll X, display Y, feed Z")
     - UI details ("green circles, Enter = next, R = redo")
     - Pattern references ("same pattern as rtde_connection.py")
   - **Test**: one sentence — the observable outcome when it works. Not test procedure, not assertions, not mock strategies. Full test plan comes in `/plan-tests`.
   - **Risk**: what can go wrong and how to detect/mitigate early
5. End with: build order diagram, merge points, and milestone markers.
6. AskUserQuestion: revise or accept?

## Commit

`git add docs/research/how-to-build.md && git commit -m "plan-build: layered build pyramid"`

## Next

"Next: `/plan-tests` to write tests for each piece."
