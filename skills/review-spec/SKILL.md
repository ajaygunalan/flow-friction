---
name: review-spec
description: Walk through a spec with the user — explain what it builds, surface ambiguities, refine before implementing
argument-hint: <path to spec file>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Review Spec: $ARGUMENTS

$ARGUMENTS is mandatory — path to the spec file (e.g., `docs/specs/spec-1a-usstream.md`).

## What this produces

A refined spec the human understands and is ready to `/implement`.

## Steps

### 1. Build context

Read:
- The spec file ($ARGUMENTS)
- The 3 research docs it references (`docs/research/what-to-build.md`, `how-to-test.md`, `how-to-build.md`)
- Every source file the spec references (the files it will create or modify)
- Specs it depends on (read the "depends on" line, then read those spec files)
- Specs that depend on it (grep other specs for this spec's ID)

### 2. Explain in plain language

Walk the human through:
- What this spec changes and where (files, functions, CLI flags)
- Why — which research question it serves, what it unblocks
- What the human will need to do (hardware setup, keypresses, judgment calls)
- What the AI does autonomously
- What "done" looks like

Keep it concrete. No jargon the spec doesn't already use.

### 3. Surface issues

Flag:
- **Ambiguities** — vague criteria ("reasonable", "roughly", "if needed"), undefined thresholds, unclear ownership of shared code
- **Misalignments** — contradictions between this spec and its dependencies (e.g., spec A says data goes to path X, spec B says path Y)
- **Stale references** — files, functions, or classes the spec mentions that don't exist in the current codebase or have changed since the spec was written
- **Missing context** — things a new session would need to know to implement this but the spec doesn't say
- **Claims vs reality** — for each source file the spec references, check whether the spec's description of that file matches what the file actually does. If the spec says "model on X's pattern" or "port protocol from Y", read X and Y and verify the pattern/protocol exists as described. Flag mismatches.
- **Fresh-agent test** — ask: "If a new agent got this spec with zero prior context, what would they have to guess?" Flag unspecified file paths, implicit decisions, and ownership questions that aren't written down.
- **Cross-doc convention check** — compare naming conventions (file paths, entity names, API signatures, data formats) across this spec, its dependencies, and its research docs. Flag anywhere two documents disagree about the same thing.

### 4. Refine with user

AskUserQuestion with the issues found. Let the human decide what to fix, what to leave, what to clarify.

Update the spec file with any changes.

## Commit

If spec was edited:
`git add <spec-file> && git commit -m "review-spec: refine <spec-id> before implementation"`

## Next

"Ready to build. Run `/implement <spec-file>`."
