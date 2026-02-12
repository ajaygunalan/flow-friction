---
description: Sync all knowledge indexes to match the current code — README, CLAUDE.md,
  Mermaid diagrams, reference docs, code comments. Triggers include "index sync",
  "sync knowledge", "docs drifted", "update diagrams", "clean docs", "map codebase",
  "absorb research", "docs are messy".
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion, Bash
---

## Philosophy

The book is the code. Everything else is an index into the book.

```
README             →  "what is this" (human entry point)
CLAUDE.md          →  "where to look" (agent entry point, read every session)
  ↓
Mermaid diagrams   →  "how it connects" (visual indexes)
  ↓
Reference docs     →  "cross-file detail" (rare — only when no single file owns it)
  ↓
Code comments      →  "what will bite you here" (margin notes, last resort)
  ↓
Code               →  the book (source of truth)
```

**Every fact has exactly one home.** Redundancy causes drift — when the same
fact lives in 3 places, they eventually contradict each other. Lower levels
link to higher levels (`# See docs/diagrams/wrench_pipeline.md`), never
re-explain.

**Comments only prevent misunderstanding.** The moment you comment everything,
comments become noise and the real traps disappear. A function called
`compute_rcm_error` doesn't need a comment saying "computes the RCM error."
Comment only when someone will misunderstand without it:
- **Trap** — code is correct but misleading; without the comment, someone will "fix" it and break things
- **Non-obvious constraint** — ordering/timing/sign dependency invisible from code structure
- **Design rationale** — "why A not B" when genuinely non-obvious

Not every file. Not every function. Not every class. Only where it prevents harm.

## Process

### Phase 1: Analyze

Code is the source of truth. This skill works anytime — after a research cycle,
after code changes, or just to check for drift. Ephemeral files are optional;
the other indexes always get checked.

Read and compare each index against the code:

| Index | Compare against | Looking for |
|---|---|---|
| README | Code + project structure | Stale overview, wrong setup instructions, missing entry points |
| CLAUDE.md | File structure + code | Dead links, outdated routing/debug tables, missing entries |
| Mermaid diagrams | Actual code structure (classes, functions, data flow) | Drift — modules added/removed/renamed |
| Reference docs | Code + ephemeral files | Stale content, new info from research, redundancy with diagrams |
| Code comments | Higher-level indexes | Duplicates to remove (already in a diagram/doc), missing trap comments to add |
| Ephemeral files (research/, plan/) | — (these ARE new knowledge) | Findings needing permanent homes |

Use subagents in parallel for large analyses.

### Phase 2: Executive Summary

Present findings to the user, grouped:
- **Stale** — drifted from code
- **Missing** — code has it, indexes don't
- **Redundant** — same fact in multiple places (violates one-home rule)
- **New** — unplaced knowledge from ephemeral files

### Phase 3: Options

Present specific, actionable choices. Not "fix everything" — user picks:
- Which diagrams to update/create
- Which reference docs to refine/delete
- Which ephemeral files to drain and where
- Which code comments to add/move/remove
- What to update in CLAUDE.md and README

### Phase 4: Execute

Based on user selections:
1. Update/create Mermaid diagrams (one subagent per diagram, max 60 nodes,
   exact function/class/variable names from code)
2. Refine or delete reference docs
3. Place ephemeral knowledge in its permanent home (pick the highest
   appropriate level in the hierarchy)
4. Add/remove code comments — only traps, only where needed
5. Update CLAUDE.md routing tables and README
6. Delete drained ephemeral files (keep empty folders as placeholders)

### Diagram format

File `docs/diagrams/{name}.md`:

    # {Title}
    {One sentence: what this shows and when to read it.}
    ```mermaid
    {content}
    ```
