---
description: Research before planning - new features, debugging, exploration, refactoring
argument-hint: <file path or topic>
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, Edit, Write, Task, Bash
---

# Research: $ARGUMENTS

## 1. What are we researching?

`$ARGUMENTS` is mandatory.

- **File path** (e.g., `docs/research/rerun-query-crash.md`) → Continue that file. Read current findings, investigate gaps, don't redo work.
- **Query** (e.g., "rerun query crash") → New topic. Derive slug from query (→ `rerun-query-crash.md`). Iteration 1. Create `docs/research/` if needed.

## 2. Investigate

You investigate directly. No teams. Read code, run commands, check docs, use context7 MCP, web search — whatever the problem needs.

### Evidence Tagging

Every finding must be tagged:
- **[TESTED]** — you ran something, measured something, have output to prove it. This is a fact.
- **[CODE-READ]** — you read the code and inferred this. This is a hypothesis until tested.

Only `[TESTED]` findings go into Key Findings as confirmed. `[CODE-READ]` findings are noted as hypotheses needing verification.

### Subagents for Independent Side-Tasks

If genuinely independent work can run in parallel, spawn **Task subagents** (not teams):
- e.g., "check official docs for X" + "search GitHub issues for Y" while you trace the code
- Each subagent gets a focused prompt with file paths, context, and a specific deliverable
- Spawn in parallel, read results when they return
- Only for independent tasks — don't parallelize sequential investigation

### Constraints

- **Test before concluding.** If you can run it, run it. Don't write a `[CODE-READ]` finding when a 10-second test would confirm or disprove it. Multiple iterations of this project had agents draw conclusions from code-reading that were wrong when tested.
- Include constraints from existing research in any subagent prompts (e.g., "DO NOT run how_to_query.py — it OOM-kills the machine")
- Read the project's `CLAUDE.md` doc references to identify relevant docs before investigating

## 3. Write Research File

Write to `docs/research/<topic-slug>.md`.

### The Two Zones

**Top sections = current truth.** Rewrite every iteration to reflect what you know NOW. Remove or correct anything disproven. The top should get *cleaner* over time, not uglier.

**Iterations section = append-only history.** Each iteration is a short log (3-5 lines) of what changed. This is the only section that grows.

### Format

```markdown
---
status: iteration 1
topic: <topic name>
---
# Research: <Topic>

**Status:** Iteration N | **Date:** YYYY-MM-DD

## What are we investigating?

## What do we know?

## What don't we know?

## What exists already?

## So what do we do?

## Sources
- [Source Title](URL) - Brief description

## Iterations

### Iteration 1
<What was learned, 3-5 lines>

### Iteration 2
<What changed, what was confirmed or ruled out, 3-5 lines>
```

### Update Rules

- **YAML frontmatter**: `status` is `iteration N` while ongoing, `complete` when done.
- **On continuation**: Rewrite top sections as current truth. If a prior finding was wrong, remove it from "What do we know?" and note "RETRACTED: X" in the new iteration log. Append new iteration at bottom. Bump iteration number in frontmatter and body.

## 4. Report

Output: file path, finding count, top insight. 2-3 lines max.
