---
description: Clean the project documentation — absorb what was learned, prune what's dead, restructure what survives into a coherent, progressively-disclosed picture. The spec is the source of truth. Triggers include "clean docs", "clean up docs", "docs are messy", "fix documentation", "docs drifted", "absorb research".
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write, LS, Task
---

## Model

Documentation is evolutionary. You start with a spec, implement, discover things you didn't know, find things you assumed were wrong. Each round deposits a doc. Over time docs diverge — the spec says X, a later doc says not-X, a third repeats half of each. The spec stops being the source of truth. Agents read the wrong doc and waste hours on assumptions that were already corrected somewhere else.

This skill makes the docs tell one coherent story again.

## Scope

Default: `docs/`, excluding `docs/diagrams/` and `docs/plan/`. User can override.

## Workflow

### Phase 1 — Analyze

Spawn sub-agent `analyze-docs` with the target folder path. It reads every doc, maps temporal relationships, and returns a structured report covering: superseded beliefs, accumulated knowledge, dead branches, redundancy, and orphaned knowledge.

### Phase 2 — Align

Using the analyzer's report, ask the user 2-4 questions via AskUserQuestion. Scale question count to complexity — two for a small corpus, up to four if there's significant drift. Focus on evolution:
- What beliefs changed since these docs were written?
- What emerged during building that wasn't in the original vision?
- What's still uncertain or actively being figured out?
- Are there docs or sections that are definitely obsolete?

Not file-level or paragraph-level questions. You're mapping the delta between initial assumptions and current understanding.

### Phase 3 — Restructure

Spawn sub-agent `restructure-docs` with three inputs:
1. The analyzer's report
2. The user's alignment answers
3. The target folder path

The restructurer reads the docs again, discovers the project's knowledge layers, derives domain-specific file names, and produces a concrete proposal. It confirms the proposal with the user before executing. Based on scope:
- Light changes (≤2 files): the restructurer executes directly.
- Heavy changes (3+ files, new structure): writes a plan to `docs/plan/` and tells the user to run `/refine` then `/implement`.

## Principles

- The spec is the source of truth. Ephemeral docs get absorbed into it, then deleted.
- When docs contradict, the more recent understanding wins. Update the older doc.
- Names are the first layer of documentation. A file listing should tell the project's story.
- Each file = one coherent knowledge area. Don't merge unrelated things or split related ones.
- Progressive disclosure: a newcomer reads the spec at altitude, drills into specific docs for depth.
- Delete with confidence. Version control remembers.
- Strategic decisions are the user's. Tactical decisions are yours.
