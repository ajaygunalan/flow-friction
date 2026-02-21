---
name: brain-dump
description: Dump your research vision into numbered questions with exit criteria and dependencies
argument-hint: <research topic or vision>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Brain Dump: $ARGUMENTS

$ARGUMENTS is mandatory — it's the research topic or vision to dump.

## What this produces

`docs/research/what-to-build.md` — numbered research questions, each with nature, exit criteria, and dependencies.

## Steps

1. Spawn an Explore agent — map the codebase relevant to $ARGUMENTS
2. AskUserQuestion — 2-3 clarifying questions:
   - What's the goal? What exists already?
   - What's engineering (clear path) vs research (unknown)?
   - What depends on what? What's the stacked unknowns?
3. Create `docs/research/` if it doesn't exist
4. Write `docs/research/what-to-build.md` as numbered questions (Q1, Q2, ...), each with:
   - The question itself (clear, grabby — "Where is the US image plane relative to the probe?")
   - **Nature:** engineering / research / out-of-scope
   - **Done when:** concrete exit criteria
   - **Depends on:** which questions must be answered first
   - Existing assets and what's known so far
5. Each question describes *what* to answer and *when it's done* — NOT *how* to solve it. Implementation steps, sub-procedures, and solver details belong in specs, not here.
6. End with a brief phase sequence (3-5 lines) showing the high-level build order — what comes first, what depends on what, where the milestone is.
7. AskUserQuestion: is this the right framing? Any questions missing?

## Commit

`git add docs/research/what-to-build.md && git commit -m "brain-dump: research questions for $ARGUMENTS"`

## Next

"Next: `/plan-build` to decide build order and define the pieces."
