---
name: sharpen-it
description: Sharpen a rough brain dump into numbered research questions with dependencies and exit criteria
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Sharpen It: $ARGUMENTS

## Prerequisite

`docs/research/what-to-build.md` must exist (rough — no Q1/Q2 structure yet).

If it's missing, tell the user: "I need `docs/research/what-to-build.md` before I can sharpen it. Run `/brain-dump <your topic>` first." Then stop.

If it already has numbered Q1/Q2 structure, tell the user it looks sharp already and suggest `/break-into-bricks`.

## What this produces

A sharp `docs/research/what-to-build.md` — rewritten in place with numbered questions.

## Steps

1. Read `docs/research/what-to-build.md`
2. Reflect back to user: "Here's what I see — N goals, these unknowns, these dependencies"
3. AskUserQuestion: what's engineering vs research? What are the stacked unknowns?
4. Rewrite `docs/research/what-to-build.md` into sharp numbered questions (Q1, Q2, ...) with:
   - **Nature:** engineering / research / out-of-scope
   - **Done-when:** concrete exit criteria
   - **Dependencies:** which questions stack on which
5. AskUserQuestion: is this the right framing?

## Next

"Next: `/break-into-bricks` to decompose these questions into testable pieces."
