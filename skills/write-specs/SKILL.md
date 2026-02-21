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

## What this produces

`docs/specs/` — self-contained spec files. Each spec is the input to a fresh Claude Code session in plan mode. The spec carries only what plan mode can't discover from the codebase: the goal, the interfaces, the data contracts between specs, and the verification criteria.

## Steps

### 1. Read, reflect, and write

Read all three research docs. Print a brief summary. Then immediately start writing spec files.

1. Create `docs/specs/` directory
2. Write spec files named `spec-{id}-{slug}.md` (lowercase kebab-case)
3. Use this template:

```
# Spec {ID}: {Name}

> Layer {N} — depends on: {list or "none"}

## What & Why
{2-3 sentences — the goal and the research question this serves}

## Deliverables
{What exists when this spec is done. Input/output formats for data contracts with other specs.}

## Test criteria
{Pass/fail criteria, failure modes, what a human observes vs what's computable.}
```

**Deliverables carry the what, not the how.** Name the deliverable and the interface it implements. Don't describe how to build it — plan mode reads the codebase and figures that out.

**Strip implementation details from how-to-build.md.** The Build field in how-to-build.md describes approach. Do not copy it into specs. If plan mode would figure it out by reading the codebase, don't put it in the spec.

**Inline a constraint only when the codebase is actively misleading** — when two options exist and the wrong one looks right. Otherwise trust plan mode to discover conventions.

**Specify data formats in both producer and consumer specs.** Without this, plan mode for each spec makes independent format choices that may not match.

### 2. Merge and filter pass

After writing all specs, review the full set:

- **Merge small pieces that share a pattern.** Each spec should be worth a full plan mode session.
- **Route non-code pieces to test checklists.** No code deliverables → not a spec. Write to `docs/` instead. Move any real code deliverables into the last spec that builds something.
- **Interface-only test.** Re-read each spec: does every sentence describe WHAT to build, WHAT goes in/out, or HOW TO VERIFY? If it describes an implementation approach, cut it.

### 3. Commit

```
git add docs/specs/ docs/ && git commit -m "write-specs: self-contained spec files from research blueprint"
```

## Next

"Pick a spec and start a new session in plan mode. Start from Layer 1."
