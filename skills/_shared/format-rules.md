## Diagram types

- **Topology** (`direction: down`) — Module dependencies. Reveals convergence hubs, tiers, coupling. One overview topology, plus sub-topologies for complex subsystems.
- **Dataflow** (`direction: down` or `direction: right`) — How data transforms across files. Include constants if they're tuning/debugging targets.
- **Decomposition** (`direction: down` with containers) — Breaks dense logic into named semantic blocks. For math, optimization, complex algorithms.

## Diagram levels

**Overview** (one per codebase) — The system at a glance. Major subsystems and how they connect. 5-10 nodes, plain English labels. First diagram any developer reads. Always a Topology. Links to detail diagrams via "See [subsystem detail](./subsystem.md)".

**Detail** (as many as earned) — Zooms into one area. Can be Topology (subsystem internals), Dataflow (a cross-file pipeline), or Decomposition (dense algorithm). 7-12 nodes, code names where they add clarity.

AGENTS.md routes to the overview. The overview routes to details. Details route to code.

Diagram count scales with structural complexity, not lines of code:
- Small codebase (under 50K, few boundaries): 2-5 diagrams
- Medium codebase (50K-200K, multiple modules): 5-12 diagrams
- Large codebase (200K+, many subsystems): 10-25 diagrams

More small diagrams, not fewer big ones. Diagrams are lightweight — typically 40-60 lines of D2 + callouts. Add diagrams at framework boundaries — where connections are implicit (port wiring, entity hierarchies, config-driven behavior) and can't be traced with grep. Direct function call chains don't need diagrams.

## Diagram file format

File: `docs/diagrams/{name}.md`

```
# {Title}

{One sentence: what this shows and when to read it.}

\`\`\`d2
{content}
\`\`\`

{Optional: framework traps, non-obvious details as highlighted callouts}
```

Rules:
- Use exact function/class names from code where they add clarity
- Semantic names over variable names
- Each diagram: 5-12 nodes. Hard ceiling 12 — split if larger.
- Diagrams with 7+ nodes: organize into 2-4 containers of 2-5 nodes each. Each container = one working-memory chunk.
- Data dimensions and types on edge labels
- Framework-specific warnings as highlighted notes — highest-value content
- Leave out: implementation internals, 1:1 code duplication, obvious control flow

### D2 styling

Follow the `d2-diagram` skill's style rules for all generated diagrams — ELK layout, theme 0, color-coded classes with `border-radius: 8`, single-line labels, titles. Use its color palette and domain color mappings. This ensures visual consistency across all diagrams regardless of which skill generates them.

### D2 syntax quick reference

```d2
direction: down

# Nodes with labels
node_id: "Display Label"

# Multi-line labels use markdown blocks
node_id: |md
  First line
  Second line
|

# Containers (grouping)
group_name: "Group Label" {
  child1: Child One
  child2: Child Two
  child1 -> child2
}

# Connections
A -> B: label
A -> B: "optional label" {
  style.stroke-dash: 3
}

# Cross-container connections use fully qualified paths
group1.child -> group2.child: label

# Shapes
start_node: Start {
  shape: oval
}
decision: "Choice?" {
  shape: diamond
}
```

D2 gotchas:
- `vars` is a reserved keyword — don't use it as a node ID
- `|` inside markdown blocks conflicts with block string delimiters — use `||md ... ||` if content contains `|`, or `|||md ... |||` if content contains `||`
- Cross-container references require fully qualified dot paths (unlike Mermaid's flat namespace)

## Markdown file criteria

Create a standalone markdown file when the knowledge is:
- A checklist or procedure (setup steps, deployment runbook)
- About external systems (hardware, third-party APIs, network config, packaging traps)
- Empirical reference values not stored in code (calibration baselines, threshold justifications)
- A topic that spans multiple code files but is prose/tables, not a flow diagram
- A trap list — framework gotchas too small for a diagram but too important to lose
- Trap knowledge (silent failures, framework quirks, threading gotchas) is the highest-value documentation — it's invisible from code and prevents costly debugging. Prioritize capturing it.

Do NOT create a markdown file when:
- The knowledge naturally lives in one code file
- It would just restate what code already says
- It fits in an AGENTS.md table row

## Markdown file format

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

## README.md format

Structure (adapt to the project):
- Project description (1-3 sentences)
- Setup / install steps
- Run commands with examples (grouped by mode if applicable)
- Project structure tree
- Links to docs for deeper reading, agent instructions in AGENTS.md

## AGENTS.md format

Structure (adapt sections to the project):
- Project overview (1-3 sentences)
- Stack (tools, versions, rates)
- Docs — "by task" routing table: task → file to read
- Debugging by symptom table: symptom → where to start
- Deep dive references: links to diagrams and markdown files

AGENTS.md references README for setup/commands — no duplication between the two.
