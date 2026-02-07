---
description: Clean the project documentation — absorb what was learned, prune what's dead, restructure what survives into a coherent, progressively-disclosed picture. The spec is the source of truth. Triggers include "clean docs", "clean up docs", "docs are messy", "fix documentation", "docs drifted", "absorb research".
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write, LS, Task
---

## Model

Documentation is evolutionary. You start with a spec, implement, discover things you didn't know, find things you assumed were wrong. Each round deposits a doc. Over time docs diverge — the spec says X, a later doc says not-X, a third repeats half of each. The spec stops being the source of truth. Agents read the wrong doc and waste hours on assumptions that were already corrected somewhere else.

This skill orchestrates two subagents and owns all user interaction. Subagents cannot ask the user questions — only you can.

## Flow

### 1. Capture intent

If the user provided a query alongside the command (e.g. "clean docs, I pivoted from ROS to custom control"), note it. This intent focuses everything downstream.

### 2. Delegate to doc-analyzer

Invoke the `doc-analyzer` subagent. Pass it:
- Target folder (default `docs/`, excluding `docs/diagrams/` and `docs/plan/`, unless user overrides)
- The user's intent if provided

Wait for its structured report.

### 3. Ask the user 2-4 questions

Use AskUserQuestion. Scale to complexity — 2 for simple situations, up to 4 for complex.

First 1-2 questions: alignment — what beliefs changed, what emerged that wasn't in the original vision, what's still uncertain. Use the user's initial intent and the analyzer's conflict report to make these specific, not generic.

Next 1-2 questions: intended actions — given the conflicts and redundancy the analyzer found, what does the user want to keep, merge, or kill. Present concrete choices derived from the analyzer report.

Skip questions whose answers are obvious from the user's initial intent.

### 4. Delegate to doc-restructurer

Invoke the `doc-restructurer` subagent. Pass it:
- The analyzer's full report
- The user's answers
- The user's initial intent
- Instructions: produce a proposal, do not execute yet

Wait for its proposal.

### 5. Confirm with user

Present the restructurer's proposal as an executive summary:
- What beliefs shifted
- Proposed structure with file names and one-line descriptions
- What gets merged/split/renamed/absorbed/deleted and why

Ask the user to confirm or adjust.

### 6. Execute

After confirmation:
- Light changes (≤2 files): tell the restructurer to execute directly.
- Large restructuring (3+ files, new structure): have the restructurer write a plan to `docs/plan/`, tell the user to run `/refine` then `/implement`.
- Medium cases: use judgment. If you can hold the full change cleanly, execute. Otherwise, plan.

## Principles

- The spec is the source of truth. Ephemeral docs get absorbed into it, then deleted.
- When docs contradict, the more recent understanding wins.
- Names are the first layer of documentation. A file listing should tell the project's story.
- Each file = one coherent knowledge area.
- Progressive disclosure: spec at altitude, detail docs for depth.
- Delete with confidence. Version control remembers.
- Strategic decisions are the user's. Tactical decisions are yours.
