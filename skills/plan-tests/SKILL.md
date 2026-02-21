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

If `what-to-build.md` is missing: "Run `/brain-dump <your topic>` first." Stop.
If `how-to-build.md` is missing: "I need the build plan first. Run `/plan-build`." Stop.

## What this produces

`docs/research/how-to-test.md` — smallest testable pieces.

## Boundary

This doc describes **what to test and how to judge pass/fail** — NOT how to build. No build instructions, no file paths, no CLI flags, no code snippets. Those belong in `how-to-build.md` or specs.

## Steps

1. Read `docs/research/what-to-build.md` and `docs/research/how-to-build.md`
2. Spawn an Explore agent to map existing test/verification patterns in the codebase
3. Synthesize into smallest testable pieces — each with:
   - What it proves
   - Pass/fail criteria (binary where possible)
   - Failure modes (what to look for when it breaks)
   - How to judge — what the human observes and what computable checks verify. NOT Rerun entity paths, logging API calls, or implementation details of how to log.
   - Dependencies on other pieces
4. Organize tests by phase, matching the phase sequence from `what-to-build.md`. End with a dependency graph.
5. Write `docs/research/how-to-test.md`
6. AskUserQuestion: revise or continue?

## Commit

`git add docs/research/how-to-test.md && git commit -m "plan-tests: testable pieces from sharp questions"`

## Next

"Next: `/review-trim docs/research/` to audit the 3 research docs together, then `/write-specs` to produce spec files."
