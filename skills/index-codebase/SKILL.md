---
description: Build the documentation index for a codebase from scratch — README, diagrams, markdown files, AGENTS.md
argument-hint: [scope or directory to index]
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Index Codebase: $ARGUMENTS

Build the documentation index from scratch. You are an orchestrator — spawn subagents for heavy reading, collect results, synthesize, and talk to the user.

## Core Principle

Code is the source of truth. Documentation compresses cross-file knowledge and captures what code cannot show — traps, conventions, and implicit connections.

Five format choices, each with a litmus test:

| Format | Lives in | Litmus |
|--------|----------|--------|
| **README.md** | repo root | Is this for a human who just cloned the repo? |
| **AGENTS.md** | repo root | Can you say it in one line or table row? |
| **Mermaid diagrams** | `docs/diagrams/` | Can you draw it with nodes and edges? Does it span 3+ files? |
| **Markdown files** | `docs/` | Does it span multiple files AND involve external systems, procedures, or empirical values not in code? |
| **Nothing** | — | Can a competent dev understand this in <5 min by reading the code? |

Progressive disclosure: AGENTS.md (5 sec) → diagrams + markdown files (2-5 min) → code (source of truth). Each layer adds depth. A developer stops at the layer that answers their question.

See [references/format-rules.md](references/format-rules.md) for diagram types, levels, sizing, markdown file criteria, and all file format templates.

## Phase 1: Orient

1. Check if `docs/diagrams/`, `docs/`, and `AGENTS.md` already exist.
   - If they exist → you're probably looking for `/index-sync` instead. Warn the user and confirm before proceeding.
   - If not → fresh start. Create directories as needed.

2. Check for ephemeral research docs in `docs/research/` and `docs/plan/`. Skip files prefixed with `TODO-` — these are pending future work and must survive indexing. Absorb the rest into the permanent docs you generate, then delete the absorbed files.
   If a research doc contradicts current code, code wins — discard the contradicting content. Research docs capture point-in-time observations; code is the source of truth.

3. Use Glob to get a quick sense of codebase size and structure — this determines how many exploration agents to spawn.

4. If `$ARGUMENTS` specifies a scope (directory or module), limit exploration to that scope. Diagrams and docs generated should cover only the scoped area. AGENTS.md is still updated globally (adding routes to the new scoped docs).

## Phase 2: Explore and Evaluate

Spawn subagents based on codebase complexity (2 for small, up to 5 for complex). Each subagent must cite specific files and lines — no shallow analysis.

### For diagrams:
1. **Map the modules** — list every package/module and its dependencies. Non-trivial interconnections spanning 3+ files → topology candidate. Exceeds 12 nodes → split into overview + sub-topologies.
2. **Identify cross-file flows** — features where data transforms across 3+ files (request pipelines, sensor-to-actuator chains, data ingestion paths, event processing, build/deploy pipelines). These are dataflow candidates.
3. **Find the dense spots** — files with complex math, optimization, or algorithmic logic that takes >5 min to understand. These are decomposition candidates.
4. **Collect framework traps** — "learned this the hard way" knowledge about hidden framework behavior. Goes as warning notes on relevant diagrams, or as a standalone trap list markdown file if no parent diagram fits.

### For markdown files:
1. **Identify external system knowledge** — deployment procedures, hardware setup, third-party API quirks, network configuration, packaging traps.
2. **Find checklists and procedures** — multi-step processes that span files.
3. **Spot empirical reference values** — calibration baselines, threshold justifications, tuning guidelines not stored in code constants.

### For README.md:
1. **Catalog entry points** — commands to run, modes, CLI flags, install/setup steps, project structure.

### For AGENTS.md:
1. **Map the "by task" routing** — for each common task a developer would do, which file should they read?
2. **Identify debugging symptoms** — common failure modes and where to start investigating.

Apply the litmus test to every candidate. Discard anything that fails.

## Phase 3: Propose

Present the filtered candidate list to the user via AskUserQuestion:

**Diagrams (present overview first, then details):**
- **Overview diagram:** proposed filename, which major subsystems it shows (5-10 nodes), why it earns a diagram
- **Detail diagrams:** for each: type (Topology/Dataflow/Decomposition), filename, what it shows, which files it covers, why it passes the litmus test

**Markdown files:**
- For each: filename, what topic it covers, why it can't be an AGENTS.md row or a diagram

**AGENTS.md structure:**
- Proposed sections and what goes in each

User approves, removes, or adds. Adjust before generating.

## Phase 4: Generate

Batch related artifacts into subagents (2-4 total). Generate the overview diagram first. Detail diagrams and other artifacts can be generated in parallel after the overview exists, so they can link back to it.

All format templates are in [references/format-rules.md](references/format-rules.md).

## Phase 5: Verify

After generation, do a quick consistency check:
- Every diagram and markdown file referenced in AGENTS.md actually exists
- Every "by task" entry in AGENTS.md points to a real file
- No orphan docs (files in `docs/` not linked from AGENTS.md)
- README.md and AGENTS.md cross-reference each other (no duplicated commands)
