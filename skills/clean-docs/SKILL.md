---
description: Clean the project documentation — absorb what was learned, prune what's dead, restructure what survives. Triggers include "clean docs", "clean up docs", "docs are messy", "fix documentation", "docs drifted", "absorb research".
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write, LS, Bash
---

Code is the documentation. Docs exist only for knowledge no single file owns.

## Process

1. **Drain ephemeral folders.** Read `docs/plan/` and `docs/research/`. These are the source of new knowledge — findings, decisions, dead ends. Everything in them must be placed somewhere permanent or deleted.

2. **Ask the user 1-2 strategic questions.** What changed? What's dead? Don't ask more than 2.

3. **Place knowledge where it survives:**
   - **Traps + design rationale** → code comments next to the code they protect.
   - **Routing tables, debug-by-symptom** → CLAUDE.md.
   - **Architecture + dataflow** → Mermaid diagrams (`docs/diagrams/`). Merge, split, or create as the codebase shape demands.
   - **Reference docs** — knowledge that spans many files and no single file owns (e.g., hydroelastic checklist spans 6 files). Keep these rare.
   - **Everything else** → delete. Version control remembers.

4. **Update CLAUDE.md routing.** If files moved, appeared, or disappeared — update the by-task and debug-by-symptom tables so they point to the right places.

5. **Delete the sources.** Remove absorbed plan/research files. Keep the empty folders as placeholders.

6. **Execute directly.** No plan file, no proposal step. Just do the edits.

## Principles

- CLAUDE.md is the ONLY thing read every session. Everything else is pulled on demand.
- If a doc restates what the code says, delete the doc.
- If a trap lives in a doc instead of next to the code, move it to the code.
- Diagrams replace prose for architecture.
- Delete aggressively. The goal is less docs, not better docs.
