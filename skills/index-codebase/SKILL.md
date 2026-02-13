---
description: Build the documentation index for a codebase from scratch — diagrams, markdown files, CLAUDE.md
argument-hint: [scope or directory to index]
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Index Codebase: $ARGUMENTS

Build the documentation index from scratch. You are an orchestrator — spawn subagents for heavy reading, collect results, synthesize, and talk to the user.

## Core Principle

Code is the source of truth. Documentation exists to show what code cannot.

Three formats, each with a job:

| Format | Lives in | Job | Litmus |
|--------|----------|-----|--------|
| **CLAUDE.md** | repo root | Routing table. "What is this? Where do I go for X?" Scannable in 30 seconds. One-liners and table rows, never deep explanations. | Can you say it in one line or table row? |
| **Mermaid diagrams** | `docs/diagrams/` | Structural knowledge. "How do things connect/flow?" Relationships between components — dependencies, signal paths, algorithm decomposition. | Can you draw it with nodes and edges? Does it span 3+ files? |
| **Markdown files** | `docs/` | Domain knowledge. "What do I need to know about this topic?" Checklists, procedures, reference values, external system traps. Too detailed for CLAUDE.md, not structural enough for a diagram. | Does it span multiple files AND involve external systems, procedures, or empirical values not in code? |
| **Nothing** | — | Code is enough. Single-file logic, self-documenting patterns, sequential code readable top-to-bottom. | Can a competent dev understand this in <5 min by reading the code? |

Progressive disclosure: CLAUDE.md (5 sec) → diagrams + markdown files (2-5 min) → code (source of truth). Each layer adds depth. A developer stops at the layer that answers their question.

### Diagram Types (max 3-6 per codebase)

- **Topology** (`graph TD`) — Module dependencies. Reveals convergence hubs, tiers, coupling. One per codebase max.
- **Dataflow** (`flowchart TD`) — How data transforms across files. Include constants if they're tuning/debugging targets.
- **Decomposition** (`graph TD` with subgraphs) — Breaks dense logic into named semantic blocks. For math, optimization, complex algorithms.

### Markdown File Criteria

Create a standalone markdown file when the knowledge is:
- A checklist or procedure (setup steps, deployment runbook)
- About external systems (hardware, third-party APIs, network config, packaging traps)
- Empirical reference values not stored in code (calibration baselines, threshold justifications)
- A topic that spans multiple code files but is prose/tables, not a flow diagram
- A trap list — framework gotchas too small for a diagram but too important to lose

Do NOT create a markdown file when:
- The knowledge naturally lives in one code file
- It would just restate what code already says
- It fits in a CLAUDE.md table row

## Phase 1: Orient

1. Check if `docs/diagrams/`, `docs/`, and `CLAUDE.md` already exist.
   - If they exist → you're probably looking for `/index-sync` instead. Warn the user and confirm before proceeding.
   - If not → fresh start. Create directories as needed.

2. Check for ephemeral research docs in `docs/research/` and `docs/plan/`. These are temporary knowledge captured by `/learn` — absorb their content into the permanent docs you generate, then delete the ephemeral files.

3. Use Glob to get a quick sense of codebase size and structure — this determines how many exploration agents to spawn.

## Phase 2: Explore and Evaluate

Spawn subagents based on codebase complexity (2 for small, up to 5 for complex). Each subagent must cite specific files and lines — no shallow analysis.

Subagents execute this evaluation process:

### For diagrams:
1. **Map the modules** — list every package/module and its dependencies. 10+ nodes → topology candidate. Under 10 → skip.
2. **Identify cross-file flows** — features where data transforms across 3+ files. These are dataflow candidates. Look for: request pipelines, sensor-to-actuator chains, data ingestion paths, event processing, build/deploy pipelines.
3. **Find the dense spots** — files with complex math, optimization, or algorithmic logic that takes >5 min to understand. These are decomposition candidates.
4. **Collect framework traps** — "learned this the hard way" knowledge about hidden framework behavior. These go as warning notes on relevant diagrams, or as a standalone trap list markdown file if no parent diagram fits.

### For markdown files:
5. **Identify external system knowledge** — deployment procedures, hardware setup, third-party API quirks, network configuration, packaging traps. These don't belong in code or diagrams.
6. **Find checklists and procedures** — multi-step processes that span files (calibration workflows, setup sequences, troubleshooting decision trees).
7. **Spot empirical reference values** — calibration baselines, threshold justifications, tuning guidelines that aren't stored in code constants.

### For CLAUDE.md:
8. **Catalog entry points** — commands to run, modes, CLI flags.
9. **Map the "by task" routing** — for each common task a developer would do, which file should they read?
10. **Identify debugging symptoms** — common failure modes and where to start investigating.

Apply the litmus test to every candidate. Discard anything that fails.

## Phase 3: Propose

Present the filtered candidate list to the user via AskUserQuestion:

**Diagrams:**
- For each: proposed type (Topology/Dataflow/Decomposition), filename, what it shows, which files it covers, why it passes the litmus test

**Markdown files:**
- For each: filename, what topic it covers, why it can't be a CLAUDE.md row or a diagram

**CLAUDE.md structure:**
- Proposed sections and what goes in each

User approves, removes, or adds. Adjust before generating.

## Phase 4: Generate

One subagent per approved artifact, parallel where possible.

### Diagram format

File: `docs/diagrams/{name}.md`

```
# {Title}

{One sentence: what this shows and when to read it.}

\`\`\`mermaid
{content}
\`\`\`

{Optional: framework traps, non-obvious details as highlighted callouts}
```

Rules:
- Use exact function/class names from code where they add clarity
- Semantic names over variable names
- Each diagram <= 60 nodes; split if larger
- Data dimensions and types on edges
- Framework-specific warnings as highlighted notes — highest-value content
- Leave out: implementation internals, 1:1 code duplication, obvious control flow

### Markdown file format

File: `docs/{descriptive-name}.md`

```
# {Title}

{One sentence: what this covers and when to read it.}

{Content: checklists, tables, reference values, procedures, trap lists}
```

Rules:
- Actionable, not narrative. Checklists > paragraphs. Tables > prose.
- Include specific values, commands, and file paths — these are what people search for.
- Link to code files where the implementation lives.

### CLAUDE.md format

Structure (adapt sections to the project):
- Project overview (1-3 sentences)
- Commands (runnable examples)
- Stack (tools, versions, rates)
- Docs — "by task" routing table: task → file to read
- Debugging by symptom table: symptom → where to start
- Deep dive references: links to diagrams and markdown files

## Phase 5: Verify

After generation, do a quick consistency check:
- Every diagram and markdown file referenced in CLAUDE.md actually exists
- Every "by task" entry in CLAUDE.md points to a real file
- No orphan docs (files in `docs/` not linked from CLAUDE.md)
