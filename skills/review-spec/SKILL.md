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
- Every source file the spec references (the files it will create or modify)
- Specs it depends on (read the "depends on" line, then read those spec files)
- Specs that depend on it (grep other specs for this spec's ID)

Do NOT read research docs (`docs/research/`). They are upstream planning artifacts — the spec supersedes them. Cross-checking against stale research docs produces false issues.

### 2. Review

**Orient** (2-3 sentences): what this spec changes and where. The user wrote it — don't explain it back to them. Just enough to confirm you're on the same page.

**Issues** — primary lens: "Would a fresh agent stall or guess wrong?"

- **Blockers**: missing info, contradictions between docs, or ambiguities that force an agent to guess (undefined API shape, disagreeing paths/names across specs, references to code that doesn't exist or works differently than described)
- **Nits**: things a competent agent would figure out — mention in one line each, don't belabor

Use the blocker/nit split to keep the list short. Internally check for stale references, cross-doc naming conflicts, and claims-vs-reality mismatches — but only surface what actually matters.

### 3. Refine with user

Present blockers and nits. Let the human decide what to fix. Update the spec file.

## Commit

If spec was edited:
`git add <spec-file> && git commit -m "review-spec: refine <spec-id> before implementation"`

## Next

"Ready to build. Run `/implement <spec-file>`."
