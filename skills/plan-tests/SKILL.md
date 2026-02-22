---
name: plan-tests
description: Decompose build pieces into smallest testable items — each with pass/fail, failure modes, observability
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Plan Tests: $ARGUMENTS

## Prerequisite

Both must exist in `docs/research/`:
- `what-to-build.md` (sharp, with Q1/Q2 structure)
- `how-to-build.md` (layered pyramid with pieces defined)

If missing, tell the user which skill to run and stop.

## Output

`docs/research/how-to-test.md` — smallest testable pieces. What to test and how to judge pass/fail — not how to build.

## How this works

1. Read both research docs.
2. Reflect back: key test boundaries, appropriate granularity, which pieces carry the most verification risk. Let the user steer before writing.
3. Synthesize into smallest testable pieces, each with:
   - What it proves
   - Pass/fail criteria (binary where possible — state computable checks directly)
   - Failure modes — only domain knowledge a developer wouldn't infer from pass/fail
   - Dependencies on other pieces
4. Organize tests by phase, matching the phase sequence from `what-to-build.md`. End with a dependency graph.
5. Write `docs/research/how-to-test.md`
6. AskUserQuestion: revise or continue?

## Commit

`git add docs/research/how-to-test.md && git commit -m "plan-tests: testable pieces from sharp questions"`

## Next

"Next: `/review-trim docs/research/` to audit the 3 research docs together, then `/write-specs` to produce spec files."
