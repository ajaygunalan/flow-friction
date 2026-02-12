---
description: Research before planning - new features, debugging, exploration, refactoring
argument-hint: <file path or topic>
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, Edit, Write, Task, Bash
---

# Research: $ARGUMENTS

You are an **orchestrator**. Stay lightweight — spawn subagents for heavy reading and searching, collect results, synthesize, and talk to the user. Do NOT bulk-investigate yourself.

**Core principle: ask, don't assume.** Use AskUserQuestion liberally — not just at phase boundaries. Uncertain about scope? Ask. Found something unexpected? Ask. Multiple directions to go? Ask. The user said "interact with me a lot" and "ask me at any point of time." Honor that.

## Phase 1: Understand

`$ARGUMENTS` is mandatory.

- **File path** (e.g., `docs/research/rerun-query-crash.md`) → Spawn a subagent to read the existing file. Understand where we left off and what gaps remain.
- **Query** (e.g., "rerun query crash") → New topic. Derive slug from query (→ `rerun-query-crash.md`).

Read the project's `CLAUDE.md` doc references so you know what already exists.

Then **AskUserQuestion** — confirm what they want to investigate and what to focus on. Bug? Feature exploration? Restructuring survey? Architecture decision? Don't assume. Let the user shape the direction.

**Do NOT investigate until the user confirms.**

## Phase 2: Investigate (iterative loop)

Each round:

1. **Spawn subagents** in parallel for independent investigation lines:
   - `Explore` agents — codebase searching, file discovery, pattern matching
   - `general-purpose` agents — reading multiple files, web searches, running commands, deeper analysis
   - Each subagent gets a focused prompt: file paths, context, constraints from prior rounds, and a specific deliverable

2. **Synthesize** — collect subagent results, distill into a clear summary for the user.

3. **AskUserQuestion** — present what you found. Ask: dig deeper? pivot? enough? The user drives what happens next.

4. **Repeat** until the user says we have enough.

### Guardrails

- If you can test something in 10 seconds yourself, just do it. Don't spawn a subagent for a trivial check.
- Pass constraints from prior rounds into subagent prompts (e.g., "DO NOT run how_to_query.py — it OOM-kills the machine").
- No fixed investigation structure. The approach adapts to the context — tracing code for bugs, surveying files for restructuring, comparing options for new features, whatever fits.

## Phase 3: Document

**Only after the user says "document it" or confirms we're done.**

Write to `docs/research/<topic-slug>.md`. Create `docs/research/` if needed.

**Top sections = current truth.** Rewrite every iteration to reflect what you know NOW. Remove anything disproven. Gets cleaner over time.

**Iterations section = append-only history.** Short log (3-5 lines) of what changed per iteration. Only section that grows.

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

## So what do we do?

## Sources
- [Source Title](URL) - Brief description

## Iterations

### Iteration 1
<What was learned, 3-5 lines>
```

### Update Rules

- `status` in frontmatter: `iteration N` while ongoing, `complete` when done.
- On continuation: rewrite top sections as current truth. Retracted findings noted in the iteration log. Bump iteration number.
- Mark findings as confirmed vs hypothesis where it naturally matters — don't force it when it doesn't apply.

## Phase 4: Report

File path + top insight. 2-3 lines max.
