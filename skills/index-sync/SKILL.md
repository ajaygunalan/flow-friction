---
description: Sync the documentation index against current codebase state — diagrams, markdown files, CLAUDE.md
argument-hint: [specific doc name or leave blank for all]
allowed-tools: Task, Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Index Sync: $ARGUMENTS

Compare existing documentation against the current codebase. Report what's accurate, outdated, should be removed, merged, or is missing. You are an orchestrator — spawn subagents for comparison work, synthesize, and talk to the user.

## Core Principle

A wrong document is worse than no document. Delete before you let it go stale.

Progressive disclosure: CLAUDE.md (5 sec) → diagrams + markdown files (2-5 min) → code (source of truth). Each layer adds depth. A developer stops at the layer that answers their question. Sync must preserve this hierarchy.

Three formats to sync:

| Format | Lives in | Sync question |
|--------|----------|---------------|
| **CLAUDE.md** | repo root | Are file paths, commands, routing entries still valid? |
| **Mermaid diagrams** | `docs/diagrams/` | Do nodes, edges, constants, and labels match current code? Does it still pass the litmus test? |
| **Markdown files** | `docs/` | Are checklists, values, procedures, and traps still accurate? Is the topic still relevant? |

**The Litmus Test (re-applied every sync):** "If a competent developer reads the code files involved, will they understand this in <5 min without this document?" If yes — the document no longer earns its keep. Code may have been simplified, consolidated, or made self-documenting since the doc was created.

## Phase 1: Orient

1. Inventory existing docs:
   - Read `CLAUDE.md` to understand current structure and references
   - List all files in `docs/diagrams/` and `docs/`
   - If `$ARGUMENTS` names a specific doc → scope the sync to just that doc
   - If no arguments → sync everything

2. Check for ephemeral research docs in `docs/research/` and `docs/plan/`. These are temporary knowledge captured by `/learn` during development. They must be absorbed into permanent docs (diagrams, markdown files, or CLAUDE.md) and then deleted. Flag them for the absorption step.

3. If no docs exist → you're probably looking for `/index-codebase` instead. Tell the user.

## Phase 2: Evaluate

Spawn one subagent per document (parallel). Each subagent:

### For diagrams:
1. **Read the diagram** — understand what it claims to show and which code files it covers.
2. **Read the current code** — check every node, edge, label, and constant against the actual codebase.
3. **Re-apply the litmus test** — does this diagram still earn its keep? Has the code been refactored so it's now understandable without the diagram?
4. **Check for merge candidates** — are two diagrams now covering overlapping territory? Could they be consolidated?

### For markdown files:
1. **Read the file** — understand what topic it covers.
2. **Check every specific value** — file paths, constants, thresholds, commands, procedures against current code and environment.
3. **Re-apply the litmus test** — is this knowledge still external to the code? Or has it been absorbed into code comments, config files, or self-documenting structure?

### For diagram sizing:
- **Oversized** — any diagram exceeding 12 nodes. Recommend splitting into overview + detail or multiple focused diagrams.
- **Missing hierarchy** — no overview diagram exists, or overview doesn't link to detail diagrams. Flag as structural gap.

### For CLAUDE.md:
1. **Check every file path** in "by task" routing — does the file still exist? Is it still the right entry point?
2. **Check every command** — does it still work? Are flags current?
3. **Check every debugging symptom** — still valid? Missing new common failures?
4. **Check deep dive references** — do all linked docs still exist? Any orphaned?

### For all documents, report one of:
- **Accurate** — matches current code, still passes litmus test
- **Outdated** — content is stale (wrong names, missing nodes, changed values, broken paths) but still earns its keep. List specific deltas.
- **Remove** — no longer passes the litmus test (code was simplified, files consolidated, knowledge absorbed into code)
- **Merge** — two documents overlap and should be consolidated into one

### For ephemeral research docs (`docs/research/`, `docs/plan/`):
1. **Read each research doc** — understand what knowledge it captured.
2. **Identify the absorption target** — which permanent doc (diagram, markdown file, or CLAUDE.md section) should this knowledge merge into? Or does it warrant a new permanent doc?
3. **Report as:** **Absorb** — `research-doc` → `target-doc` with a summary of what gets absorbed.
4. **If research contradicts current code, code wins** — discard the contradicting content. Research docs capture point-in-time observations; code is the source of truth.

### Additionally, do a light scan for gaps:

Diagram types for reference when classifying new candidates:
- **Topology** (`graph TD`) — Module dependencies. One overview topology, plus sub-topologies for complex subsystems.
- **Dataflow** (`flowchart TD`) — Cross-file data transforms. Include tuning constants.
- **Decomposition** (`graph TD` with subgraphs) — Dense algorithm structure.

5. **Identify new code areas** that now pass the litmus test:
   - New modules with non-trivial interconnections spanning 3+ files (→ topology update or new diagram; split if >12 nodes; keep each under 12)
   - New cross-file flows (3+ files → dataflow candidate)
   - New dense logic (>5 min to grok → decomposition candidate)
   - New external system knowledge (deployment, hardware, third-party → markdown file candidate)
   - New common failure modes (→ CLAUDE.md debugging table update)

Report as: **New candidate** with type, proposed name, and why it passes the litmus test.

## Phase 3: Report

Present a consolidated status to the user:

```
Diagrams:
  Accurate:       diagram1, diagram2
  Outdated:       diagram3 — {what changed}
  Remove:         diagram4 — {why it no longer earns its keep}
  Merge:          diagram5 + diagram6 — {why they overlap}

Markdown files:
  Accurate:       file1
  Outdated:       file2 — {what changed}

Absorb (ephemeral → permanent):
  docs/research/foo.md → docs/diagrams/bar.md — {what knowledge gets merged}
  docs/plan/baz.md → docs/some-topic.md — {what knowledge gets merged}

CLAUDE.md:
  Stale entries:  {list of broken paths, outdated commands, missing routes}

New candidates:
  {proposed name} ({diagram|markdown}) — {why it passes the litmus test}
```

**AskUserQuestion** — user selects what to act on:
- Which outdated docs to update
- Whether to delete recommended removals
- Whether to merge recommended consolidations
- Whether to generate new candidates
- Which CLAUDE.md entries to fix

## Phase 4: Execute

For each user-approved action, spawn one subagent per document (parallel):

- **Update:** subagent reads current code, rewrites the document content. Preserves the filename for link stability.
- **Remove:** delete the file. Remove its references from CLAUDE.md.
- **Merge:** subagent reads both source documents + current code, writes consolidated document under the surviving filename. Deletes the other. Updates CLAUDE.md references.
- **New:** subagent reads source files, generates document following the format rules below.
- **Absorb:** subagent reads the ephemeral research doc + the target permanent doc + current code. Merges the knowledge into the target. Deletes the ephemeral file. Updates CLAUDE.md if the target is new.
- **CLAUDE.md fix:** update stale paths, commands, routing entries, debugging symptoms, deep dive references.

### Diagram and markdown file format

See [references/format-rules.md](references/format-rules.md) for diagram and markdown file format specifications, node ceiling (12), chunking rules (2-4 subgroups), and file layout templates.

## Phase 5: Verify

After all actions complete:
- Every diagram and markdown file referenced in CLAUDE.md actually exists
- Every "by task" entry points to a real file
- No orphan docs (files in `docs/` not linked from CLAUDE.md)
- No dead links in CLAUDE.md deep dive references
