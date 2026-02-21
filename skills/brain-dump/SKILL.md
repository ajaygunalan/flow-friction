---
name: brain-dump
description: Dump your research vision — goals, context, unknowns — into a rough what-to-build doc
argument-hint: <research topic or vision>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Brain Dump: $ARGUMENTS

$ARGUMENTS is mandatory — it's the research topic or vision to dump.

## What this produces

A rough `docs/research/what-to-build.md` — goals, existing code, what's known vs unknown. Not sharp yet. Just getting it out of your head.

## Steps

1. Spawn an Explore agent — map the codebase relevant to $ARGUMENTS
2. AskUserQuestion — 2-3 clarifying questions (scope, constraints, existing assets)
3. Create `docs/research/` if it doesn't exist
4. Write a rough `docs/research/what-to-build.md` — goals, existing code, what's known vs unknown
5. AskUserQuestion: anything missing?

This is the rough dump. Don't try to be sharp yet.

## Commit

`git add docs/research/what-to-build.md && git commit -m "brain-dump: rough what-to-build"`

## Next

"Next: `/sharpen-it` to turn this rough dump into sharp questions."
