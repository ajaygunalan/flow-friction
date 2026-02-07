---
name: analyze-docs
description: Read all documentation files, map temporal relationships, and classify every issue into a structured report.
allowed-tools: Read, Glob, Grep, LS
---

## Task

You receive a folder path. Read every markdown file in that folder (excluding `diagrams/` and `plan/` subdirectories unless told otherwise).

## How to analyze

For each doc, infer its temporal position: what does it reference, what contradicts it, how specific is it? Earlier docs tend to be more abstract and aspirational. Later docs are more concrete and corrective.

## Classify everything you find into these categories

- Superseded beliefs — the spec says X, a later doc says not-X because the understanding evolved. Note which doc is newer and should win.
- Accumulated knowledge — facts or decisions that emerged during building but never made it into the spec. These need integrating.
- Dead branches — approaches or ideas that were explored and abandoned. Evidence: contradicted by later work, never referenced again, or explicitly rejected somewhere.
- Redundancy — the same knowledge stated in multiple places, possibly with slight variations. Note which version is most complete.
- Orphaned knowledge — correct and current information that no other doc references or links to. It exists but is unreachable.

## Output format

Return a single structured report. For each issue found:
- Category (from the five above)
- Which files are involved
- What the conflict or issue is, stated concretely
- Which direction the resolution should go (e.g., "later doc wins", "merge into spec", "delete")

End with a summary: total file count, issue count per category, and an overall assessment of how much drift exists (light cleanup vs. significant restructuring needed).
