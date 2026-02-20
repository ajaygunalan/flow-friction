---
name: walkthrough
description: Generate a D2 diagram that explains how a codebase feature, flow, or architecture works. Designed for fast onboarding — a visual mental model readable in under 2 minutes. Use when asked to walkthrough, explain a flow, trace a code path, show how something works, or explain the architecture.
allowed-tools: Read Glob Grep Task Write
---

# Codebase Walkthrough Generator

Generate a D2 diagram in markdown that gives someone a **quick mental model** of how a feature or system works. Fast onboarding — a rough map of concepts and connections, readable in under 2 minutes.

## Step 1: Understand the scope

Clarify what the user wants explained:
- A specific feature flow (e.g., "how does canvas drawing work")
- A data flow (e.g., "how does state flow from composable to component")
- An architectural overview (e.g., "how are features organized")
- A request lifecycle (e.g., "what happens when a user clicks draw")

Frame the walkthrough as a **mental model for someone new**. Think: "What are the 5-12 key concepts, and how do they connect?"

If the request is vague, ask one clarifying question. Otherwise proceed.

## Step 2: Explore the codebase with parallel subagents

**Always read real source files before generating.** Never fabricate code paths.

**Use the Task tool to delegate exploration to subagents.** This keeps the main context clean and parallelizes the research phase.

1. **Identify areas** — do a quick Glob/Grep yourself (1-2 calls max) to find relevant directories and file groups.
2. **Launch parallel Explore subagents** — split into 2-4 independent research tasks. Each agent investigates one area and reports back:
   - What the piece does (purpose) and why it exists (role in the system)
   - How it connects to other pieces (imports, calls, data flow)
   - A suggested node ID (snake_case) and plain-English label
   - The primary file path(s)
3. **Synthesize** — once all subagents return, combine into:
   - **Node list** — ID, plain-English label, primary file(s), 1-sentence purpose
   - **Edge list** — which nodes connect, with plain verb labels ("triggers", "feeds into", "reads")
   - **Container groupings** — 2-4 groups with approachable labels ("User Input", "Processing", "Output")

**Do NOT read files yourself** — let subagents do it. If a subagent's report is missing info, drop that node rather than reading files yourself.

## Step 3: Generate the diagram

**Styling**: Follow the `d2-diagram` skill's style rules — ELK layout, theme 0, color-coded classes with `border-radius: 8`, single-line labels. Use its color palette and domain mappings for consistent visuals across all project diagrams.

**Keep to 5-12 nodes** grouped into **2-4 containers**.

Set the diagram direction:
- `direction: down` for hierarchical flows
- `direction: right` for sequential pipelines

**Node labels**: plain English — "Drawing Interaction", "Canvas Rendering" — not function names or file names.

**Edge labels**: plain verbs — "triggers", "feeds into", "reads", "produces", "watches". Not API method names.

**Edge styles**:
- `->` for direct calls
- `-> { style.stroke-dash: 3 }` for reactive/watch relationships
- `-> { style.stroke-width: 3 }` for events/emissions

**Container labels**: approachable mental-model labels ("User Input", "Core Logic") — not technical layer names ("Composable Layer").

## Step 4: Write the output

Write to `walkthrough-{topic}.md` in the project root. Use kebab-case for the topic slug.

Format:

```markdown
# Walkthrough: {Title}

{2-3 sentence TL;DR — what this system does at the highest level}

\`\`\`d2
direction: down

input: "User Input" {
  ...
}

...
\`\`\`

## Node details

| Node | Purpose | Files |
|------|---------|-------|
| Drawing Interaction | Converts pointer events into shape data | `app/features/tools/useDrawingInteraction.ts` |
| ... | ... | ... |
```

The node details table captures purpose and file paths per node. To preview the diagram, open the file in VS Code and press `Ctrl+Shift+V` (requires the d2-markdown-preview extension), or extract the D2 block to a `.d2` file and run `d2 --watch file.d2 output.svg`.

## Quality Checklist

Before finishing, verify:
- [ ] Diagram has **5-12 nodes** (not more)
- [ ] Every node label is plain English (no function signatures or file names)
- [ ] Every node maps to a real file in the codebase
- [ ] The diagram accurately represents the real code flow
- [ ] TL;DR summary is present and 3 sentences or fewer
- [ ] Container labels are approachable ("User Input") not technical ("Composable Layer")
- [ ] Edge labels are plain verbs ("triggers") not method names ("handlePointerDown()")
- [ ] Node details table has an entry for every node in the diagram
- [ ] D2 validates without errors (`d2 validate file.d2`)
