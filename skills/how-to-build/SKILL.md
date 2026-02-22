---
name: how-to-build
description: Decide build order — layer the pieces into a pyramid with dependencies and risks
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# How to Build: $ARGUMENTS

## Prerequisite

`docs/research/brainstorm.md` must exist. If missing: "Run `/brainstorm <your topic>` first." Stop.

## Output

`docs/research/how-to-build.md` — layered build pyramid.

## How this works

1. Read `brainstorm.md`
2. Reflect understanding back. Surface dependency tensions, ordering disagreements, pieces that might be parallelizable. Let the user steer.
3. Converge on build order through a few focused exchanges.
4. Write `docs/research/how-to-build.md` — layered pyramid with per-piece:
   - **What**: what this piece does — deliverable + any constraints the codebase can't tell you. For every detail, ask: would a builder figure this out from the codebase? If yes, leave it out.
   - **Depends on**: which pieces must be built first
   - **Test**: one sentence — the observable outcome when it works. Full test plan comes in `/how-to-test`.
   - **Risk**: what can go wrong and how to detect/mitigate early
5. End with: build order diagram, merge points, milestone markers.
6. AskUserQuestion: revise or accept?

Don't reproduce what AGENTS.md already covers. Stay focused on what's being built now.

## Commit

`git add docs/research/how-to-build.md && git commit -m "how-to-build: layered build pyramid"`

## Next

"Next: `/how-to-test` to write tests for each piece."
