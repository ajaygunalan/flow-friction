---
name: how-to-test
description: Define pass/fail checks for each build piece — binary, checkable, copy-pasteable into issues
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# How to Test: $ARGUMENTS

## On entry

Read `docs/research/how-to-build.md` if it exists. Also read `docs/research/brainstorm.md` if present — it gives problem context. If how-to-build is missing, tell the user you expected it and ask what they're testing. Proceed either way.

Reflect back: which pieces carry the most verification risk, where the test boundaries are, whether the granularity feels right. Let the user steer before writing.

## Output

`docs/research/how-to-test.md` — verification checks per build piece.

If the document benefits from a brief orienting sentence at the top, write one. No section heading for it.

Organize by build piece. Per piece:

```
## {Piece name}

- [ ] {specific, binary pass/fail condition}
- [ ] {another condition}

**Watch out:** {non-obvious failure mode — only if one exists}
```

Each checkbox should be a concrete check someone can run and answer yes or no. State computable checks directly. Skip "Watch out" unless there's domain knowledge a builder wouldn't infer from the check itself.

Don't redefine what a piece does — that's in how-to-build.

After all pieces, two closing sections:

```
## Integration checks

- [ ] {cross-piece verification that doesn't belong to any single piece}

## Not testing

{Deliberate exclusions with one-line reasons. Prevents scope creep in later sessions.}
```

Omit either section if empty.

AskUserQuestion: revise or accept?

## Commit

`git add docs/research/how-to-test.md && git commit -m "how-to-test: verification checks for build pieces"`

## Next

"Next: `/breakdown-issues` to produce issue files from the research docs."
