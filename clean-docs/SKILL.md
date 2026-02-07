---
description: Clean project documentation — find contradictions, redundancy, and stale claims across all docs. Fix the spec to be the source of truth. Triggers include "clean docs", "clean up docs", "docs are messy", "fix documentation".
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write
---

## Why

Documentation accumulates as you work. Each doc is correct when written. Over time they drift — the spec says X, a later doc says not-X, a third repeats half of each. The spec stops being the source of truth. Agents read the wrong doc and waste hours on assumptions that were already corrected somewhere else.

Clean-docs reads the corpus as a whole and makes it tell one coherent story. The spec is always the source of truth. Everything else either gets absorbed into it or deleted.

## Scope

Read all markdown files in `docs/`. **Exclude `docs/diagrams/` and `docs/plan/`** — diagrams are generated representations, plans are ephemeral. Only read the actual documentation.

## Analyze

Cross-check the corpus. Identify:
- **Contradictions** — doc A says X, doc B says not-X
- **Redundancy** — same knowledge in multiple places
- **Stale claims** — superseded by later work but never updated
- **Disconnection** — knowledge that exists but isn't referenced

## Align

Ask the user high-level questions via AskUserQuestion — project direction, architecture priorities, what's still relevant. Not tactical questions about files or paragraphs. Only what's needed to understand the user's vision.

## Propose

Present an executive summary of proposed changes — what will be merged, cut, renamed, restructured, and why.

## Execute

**Small changes** (a few edits, 1-2 files): make the changes directly after approval.

**Large changes** (restructuring, merging/splitting files, 3+ files): write a plan to `docs/plan/` and tell the user to run `/refine` then `/implement`.

## Principles

- File names emerge from content. If a name doesn't match what's inside, rename it.
- File count emerges from content. Merge or split as needed.
- Ephemeral docs (insights, research) get absorbed into the spec, then deleted.
- Strategic decisions are the user's. Tactical decisions are yours.
