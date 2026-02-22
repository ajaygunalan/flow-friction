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

## What
{1-2 sentences — what this piece does}

## Deliverables
{What exists when this spec is done. Input/output formats for data contracts with other specs.}

## Done when
{One line — what success looks like. Not how to test, not failure modes.}
```

**Deliverables carry the what, not the how.** Name the deliverable and the interface it implements. Don't describe how to build it — plan mode reads the codebase and figures that out. Common leaks to watch for:
- Threading/locking strategy (e.g., "lock-protected single slot") — implementation choice
- Wire protocol details discoverable from reference code — plan mode reads the code
- Per-tick control flow (e.g., "each tick: poll X, display Y, feed Z") — implementation approach
- UI details (e.g., "drawn circles, Enter = next, R = redo") — implementation choice

**Strip implementation details from how-to-build.md.** The Build field in how-to-build.md describes approach. Do not copy it into specs. If plan mode would figure it out by reading the codebase, don't put it in the spec.

**Test details stay in how-to-test.md.** Don't duplicate pass/fail criteria, failure modes, or observation checklists into specs. Plan mode implements code — the human runs tests. Specs carry only a one-line "done when."

**"Done when" is the observable outcome, not test procedure.** Don't describe how to test (mock servers, unit test steps, assertion details). Describe what you see when it works. "Call latest_frame(), see the image" — not "unit test with mock TCP server passes."

**Inline a constraint only when the codebase is actively misleading** — when two options exist and the wrong one looks right. Otherwise trust plan mode to discover conventions.

**Specify data formats in both producer and consumer specs.** Without this, plan mode for each spec makes independent format choices that may not match.

### 2. Merge and filter pass

After writing all specs, review the full set:

- **Merge small pieces that share a pattern.** Each spec should be worth a full plan mode session.
- **Route non-code pieces to test checklists.** No code deliverables → not a spec. Write to `docs/` instead. Move any real code deliverables into the last spec that builds something.
- **Interface-only test.** Re-read each spec: does every sentence describe WHAT to build or WHAT goes in/out? If it describes an implementation approach or detailed test criteria, cut it.

### 3. Commit

```
git add docs/specs/ docs/ && git commit -m "write-specs: self-contained spec files from research blueprint"
```

## Next

"Pick a spec and start a new session in plan mode. Start from Layer 1."
