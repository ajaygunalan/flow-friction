---
description: Sync documentation indexes to match the current code -- README, CLAUDE.md,
  diagrams, reference docs. Triggers include "index sync", "sync knowledge", "docs drifted",
  "update diagrams", "clean docs", "map codebase", "absorb research", "docs are messy".
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion, Bash
---

Indexes point to code; they never replace it. Code is the source of truth. This skill syncs the indexes -- never the code itself.

**The index stack** -- each layer exists because the one above wasn't enough detail:

```
README          "what is this"           (human entry point)
CLAUDE.md       "where to look"          (agent entry point, routing tables)
Diagrams        "how it connects"        (visual maps in docs/diagrams/)
Reference docs  "cross-file detail"      (only when no single file owns it)
Code            the truth                (never touched by this skill)
```

Lower layers link up, never re-explain. When placing new knowledge, pick the highest layer that's sufficient.

## Process

### 1. Scan

Read the code first. Then compare each index against it. Use subagents in parallel for large scans.

- **CLAUDE.md** -- Do "By task" routes point to the right files? Are there new modules with no routing entry? Commands correct? Debug table current?
- **Diagrams** -- Do nodes and edges match the code? Modules added, removed, renamed?
- **Reference docs** -- Content still match the code? Sections now redundant with a diagram or code comment?
- **README** -- Overview and setup instructions current?
- **Ephemeral files** (`docs/research/`, `docs/plan/`) -- Unplaced knowledge waiting for a permanent home.

Do NOT scan code comments. This skill syncs indexes, not code.

### 2. Report

Present findings grouped by file, with specific proposed actions. The user reads this and decides what to fix.

Good -- the user can decide in 30 seconds:
```
CLAUDE.md:
  - "By task" missing entry for terminal.py (added since last sync)
  - Commands: --no-workflow flag not documented
  - Debug table: "Diagnostics stale" row references wrong file

docs/diagrams/architecture.md:
  - Node "rtde_utils" renamed to "rtde_connection" in code

docs/force-sensing-pipeline.md:
  - Calibration values match code, no changes needed
  - Section 3 duplicates wrench_pipeline.md diagram -- recommend removing prose version
```

Bad -- vague, no actions, user can't decide anything:
```
Stale:
  - Several diagrams may have drifted
  - Some CLAUDE.md entries could be outdated
Missing:
  - There might be new modules not yet documented
```

Include "no changes needed" for clean files so the user knows you checked.

### 3. Fix

Execute the user's selections.

- **CLAUDE.md**: Add/remove/update entries within the existing structure. Every code module should have a routing entry.
- **Diagrams**: Use exact names from code. Max 60 nodes per diagram. Format below.
- **Reference docs**: Use judgment. The test: does this doc save someone from reading 3+ source files to understand a cross-cutting concern? If yes, keep and update. If no, the knowledge belongs in code comments or a diagram. Flag judgment calls to the user -- don't silently decide.
- **Ephemeral files**: Drain knowledge into its permanent home at the highest appropriate level. Delete the file after draining.

After all edits, verify: every file mentioned in CLAUDE.md exists, every diagram references real code entities, no dead links.

### Diagram format

File `docs/diagrams/{name}.md`:

    # {Title}
    {One sentence: what this shows and when to read it.}
    ```mermaid
    {content}
    ```
