---
description: Generate or update architecture diagrams at emergent abstraction levels
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Map Codebase

Generate or update mermaid diagrams in `diagrams/`. These enable fast travel for Claude.

## Phase 1: Assess

1. Check if `diagrams/` exists and CLAUDE.md has "Deep Dive References"
   - Both exist → UPDATE mode
   - Otherwise → FRESH mode

2. Use Glob/Read to understand codebase size and structure manually
   - This determines how many exploration agents to spawn

## Phase 2: Explore

Spawn agents based on codebase complexity (could be 2, could be 5 - not fixed).

Goal: understand surface area
- File structure and dependencies
- Entry points and routing
- Key classes and data models
- Runtime patterns and data flows

Consolidate findings before proceeding.

## Phase 3: Propose Levels

From findings, propose levels that naturally emerge. Reference questions (guidance, not rigid):

| Question | Typical Level |
|----------|---------------|
| What exists and how organized? | Static Structure |
| How does execution begin? | Entry Points |
| How are components connected? | Wiring |
| What happens per tick/request? | Data Flow |
| How does computation work inside? | Algorithm Internals |

- Small codebase: maybe 2 levels. Complex system: maybe 5.
- For each level, propose diagrams with filenames.
- Present to user via AskUserQuestion. Adjust if needed.

## Phase 4: Generate or Update

### Fresh Mode

One agent per diagram, parallel where possible. Each agent receives:
- Filename and title
- Level question it answers
- Specific source files to read

Agent reads the files, then writes diagram to `diagrams/`.

### Update Mode

Compare codebase against existing diagrams. Report to user:
- ✓ Accurate: [[name1]], [[name2]]
- ⚠ Outdated: [[name3]], [[name4]]
- + Missing: [[name5]]

User selects what to update. Preserve existing filenames for wiki link stability.
One agent per selected diagram.

## Phase 5: Update CLAUDE.md

Add or update "Deep Dive References" section:

```
## Deep Dive References

All [[name]] links resolve to `diagrams/name.md`.

| Level | Focus | Diagrams |
|-------|-------|----------|
| L1 -- {Label} | {Question} | [[diagram1]], [[diagram2]] |
| L2 -- {Label} | {Question} | [[diagram3]] |
```

If section exists, update it. If not, create it before Gotchas or Session Log.

## Diagram Format

File: `diagrams/{name}.md`

```
# {Title}

{One sentence: what this shows and when to read it.}

```mermaid
{content}
```

{Optional notes for non-obvious details}
```

## Guidelines

- Levels emerge from analysis, not hardcoded
- Use exact function/class/variable names from code
- Wiki links [[name]] stay stable across updates
- Each diagram ≤60 nodes; split if larger
- If diagrams/ doesn't exist, create it
