---
description: clean the project documentation — absorb what was learned, prune what's dead, restructure what survives into a coherent, progressively-disclosed picture. The spec is the source of truth. Triggers include "clean docs", "clean up docs", "docs are messy", "fix documentation", "docs drifted", "absorb research".
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write, LS
---

## Model

Documentation is evolutionary. You start with a spec, implement, discover things you didn't know, find things you assumed were wrong. Each round deposits a doc. Over time docs diverge — the spec says X, a later doc says not-X, a third repeats half of each. The spec stops being the source of truth. Agents read the wrong doc and waste hours on assumptions that were already corrected somewhere else.

This skill makes the docs tell one coherent story again.

## Scope

Default: `docs/`, excluding `docs/diagrams/` and `docs/plan/`. User can override.

## Steps

1. Read everything in scope. For each doc, infer its temporal position (what references what, which contradicts which, specificity level).

2. Classify what you find:
   - **Superseded beliefs** — spec says X, later doc says not-X because you learned better. Later wins.
   - **Accumulated knowledge** — emerged during building, not in original spec. Needs integrating.
   - **Dead branches** — explored and abandoned. Remove entirely.
   - **Redundancy** — same knowledge in multiple places. Consolidate into the highest-level doc where it belongs.
   - **Orphaned knowledge** — correct but unreachable from any other doc.

3. Ask the user 2-3 questions via AskUserQuestion. Focus on evolution: what beliefs changed, what emerged that wasn't in the vision, what's still uncertain. Not file-level questions.

4. Discover the knowledge layers from the content. Every project has its own. A robotics project might layer as: control philosophy → sensor constraints → algorithm design → tuning parameters. The layers create progressive disclosure — start at the spec, drill into detail docs only when needed.

5. Derive file names from the project's domain. Together they read like a table of contents unique to this project. Bad: RESEARCH.md, NOTES.md, ARCHITECTURE.md. Good (force-control project): force-sensing-constraints.md, pid-tuning-rationale.md, sensor-fusion-tradeoffs.md.

6. Present an executive summary: what beliefs shifted, proposed structure with file names, what gets merged/split/renamed/absorbed/deleted and why.

7. Execute. Light changes (≤2 files): do it directly. Restructuring (3+ files, new structure): write a plan to `docs/plan/`, tell user to run `/refine` then `/implement`. Use judgment for medium cases.

## Principles

- The spec is the source of truth. Ephemeral docs get absorbed into it, then deleted.
- When docs contradict, the more recent understanding wins. Update the older doc.
- Names are the first layer of documentation. A file listing should tell the project's story.
- Each file = one coherent knowledge area. Don't merge unrelated things or split related ones.
- Progressive disclosure: a newcomer reads the spec at altitude, drills into specific docs for depth.
- Delete with confidence. Version control remembers.
- Strategic decisions are the user's. Tactical decisions are yours.
