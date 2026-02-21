---
name: check-research
description: Cross-check the 3 research docs — trace build pieces to tests to questions, find gaps
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Check Research: $ARGUMENTS

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
- Every piece in `how-to-build.md` traces to a test in `how-to-test.md`
- Every test traces to a question in `what-to-build.md`
- No orphan tests or orphan pieces
- Dependencies consistent across docs
- Build order respects test dependencies

Report gaps. Suggest fixes.

## Commit

If any docs were edited to fix gaps:
`git add docs/research/ && git commit -m "check-research: fix alignment gaps"`
