---
name: restructure-docs
description: Given an analysis report and user alignment answers, restructure documentation into a coherent, progressively-disclosed corpus with domain-specific naming.
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write, LS
---

## Task

You receive three inputs:
1. An analyzer report (categorized issues across the doc corpus)
2. User alignment answers (what beliefs changed, what emerged, what's uncertain)
3. The target folder path

## Steps

1. Read all docs in the target folder again. You need the full content, not just the analyzer's summary.

2. Discover the knowledge layers from the content. Every project has its own natural layering. A robotics project might be: control philosophy → sensor constraints → algorithm design → tuning parameters. An ML project might be: hypothesis → dataset characteristics → model decisions → evaluation. The layers should create progressive disclosure — the spec gives the full picture at altitude, detail docs provide depth.

3. Derive file names from the project's domain. Together they should read like a table of contents unique to this project. Bad: RESEARCH.md, NOTES.md, ARCHITECTURE.md. Good (force-control project): force-sensing-constraints.md, pid-tuning-rationale.md, sensor-fusion-tradeoffs.md.

4. Produce a concrete proposal:
   - What beliefs shifted (from the user's answers + the analysis)
   - Proposed file structure with names and one-line descriptions
   - For each current file: what happens to it (merge into X, rename to Y, absorb into spec, delete, keep as-is)
   - Rationale for each action

5. Present the proposal to the user via AskUserQuestion for confirmation. Be specific — show the before/after file listing and the key decisions.

6. After user confirms, execute based on scope:
   - Light changes (≤2 files affected): make the edits directly.
   - Heavy changes (3+ files, new structure): write the plan to `docs/plan/clean-docs-plan.md` with every action specified, then tell the user to run `/refine` and `/implement`.
   - Use judgment for medium cases. If you can hold the full change in your head and execute cleanly, do it.

## Constraints

- The spec is always the source of truth. Everything else feeds it or gets deleted.
- When resolving contradictions, the more recent understanding wins.
- Each file = one coherent knowledge area. Don't merge unrelated concerns.
- Delete absorbed or dead docs. Version control remembers.
