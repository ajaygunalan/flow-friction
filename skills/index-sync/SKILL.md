---
description: Distill knowledge into diagrams. Triggers include "index sync", "sync
  knowledge", "distill", "update diagrams", "absorb research", "clean docs", "compress
  knowledge".
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion, Bash
---

Knowledge lives in two places: the code and the diagram layer. This skill keeps the diagram layer alive -- absorbing new knowledge, reflecting code changes, and reshaping structure as the codebase evolves.

## Sources

1. **Ephemeral files** -- `docs/research/` and `docs/plan/` accumulate notes and decisions during development. This skill drains them.
2. **Code changes** -- new modules, renames, deletions, restructured logic. Code is always the source of truth.

## Output stack

Place knowledge at the highest level that captures it faithfully:

```
Mermaid diagrams    primary -- compress knowledge visually       docs/diagrams/{name}.md
Reference docs      overflow -- cross-file detail only           docs/*.md
CLAUDE.md           routing -- "where to look" tables            CLAUDE.md
README              routing -- "what is this" + setup            README.md
```

## Process

### 1. Read everything

Read code, ephemeral files, existing diagrams, and reference docs. Use subagents in parallel for large scans.

### 2. Synthesize

Compress knowledge into diagrams. This is creative work -- not mechanical diffing.

**Diagrams are alive.** Expand, create, split, merge, rename, or delete them as the codebase evolves. A diagram that no longer fits gets restructured, not patched. When restructuring, tell the user what you're doing and why.

**Ephemeral files get drained.** Extract their knowledge into diagrams (or reference docs when diagrams genuinely can't capture it). Delete the file after draining. For notes with unresolved questions, extract what's solid and flag the open questions to the user. Dead ends get deleted with nothing extracted.

**Reference docs hold overflow.** The test: does this knowledge span 3+ source files AND resist visual representation? Checklists, exact numeric values, and deployment traps needing prose all qualify. Everything else belongs in a diagram or in the code itself. Reference docs can also be created, merged, or deleted as the codebase evolves.

**Code changes update diagrams.** Renamed module? Rename the node. New subsystem? New diagram or expanded existing one. Deleted code? Remove it from all diagrams and routing. When code and docs conflict, code wins.

Not all diagram files are strictly Mermaid -- some (like `viz_conventions.md`) are bullet-point references. That's fine when the content is a list of traps rather than a graph.

### 3. Update routing layers

After diagrams and reference docs are current:

- **CLAUDE.md** -- every code module has a routing entry. "By task" table points to the right places. Commands and debug table reflect current code.
- **README** -- overview and setup stay current. Points to docs, never duplicates them.

### 4. Verify

A healthy documentation system satisfies all of these:

1. Ephemeral folders are drained -- `docs/research/` and `docs/plan/` contain no `.md` files after sync (except files with flagged open questions)
2. Diagrams use real names -- every node and label corresponds to an actual code entity
3. Routing is complete -- every code module in `rcm_qp/` is reachable from CLAUDE.md
4. Routing is valid -- every file path mentioned in CLAUDE.md and README exists on disk
5. No redundancy across layers -- knowledge lives in one place; routing layers point, never re-explain
6. Reference docs earn their keep -- each captures cross-cutting knowledge no diagram or single file owns
7. Diagrams stay focused -- no diagram exceeds ~60 nodes; split when they grow

## Diagram format

File: `docs/diagrams/{name}.md`

```
# {Title}
{One sentence: what this shows and when to read it.}
\```mermaid
{content -- use exact names from code}
\```
```
