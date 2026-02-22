---
name: write-specs
description: Decompose research blueprint into self-contained spec files — one file per piece, minimal context for plan mode
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Write Specs

## Prerequisite

All three must exist in `docs/research/`:
- `what-to-build.md` (sharp, with Q structure)
- `how-to-build.md` (layered pyramid with pieces)
- `how-to-test.md` (tests per piece)

If any missing, tell the user which skill to run and stop.

## Output

`docs/specs/` — self-contained spec files. Each spec is the input to a fresh Claude Code session in plan mode.

## Steps

### 1. Read, reflect, and write

Read all three research docs. Print a brief summary. Then write spec files.

1. Create `docs/specs/` directory
2. Write spec files named `spec-{id}-{slug}.md` (lowercase kebab-case)
3. Use this template:

```
# Spec {ID}: {Name}

> Layer {N} — depends on: {list or "none"}

## What
{1-2 sentences — what this piece does}

## Deliverables
{What exists when done. Input/output formats for data contracts with other specs.}

## Done when
{One line — the observable outcome when it works.}
```

For every sentence in a spec, ask: would plan mode figure this out from the codebase? If yes, cut it. Inline a constraint only when the codebase is actively misleading — when two options exist and the wrong one looks right.

Specify data formats in both producer and consumer specs so plan mode sessions make compatible choices.

Test details stay in `how-to-test.md` — don't duplicate into specs.

### 2. Merge and filter pass

Review the full set:
- Merge small pieces that share a pattern — each spec should be worth a full plan mode session.
- Route non-code pieces to `docs/` instead. No code deliverables → not a spec.
- Re-read each spec: does every sentence describe what to build or what goes in/out? If it describes how, cut it.

### 3. Commit

```
git add docs/specs/ docs/ && git commit -m "write-specs: self-contained spec files from research blueprint"
```

## Next

"Pick a spec and start a new session in plan mode. Start from Layer 1."
