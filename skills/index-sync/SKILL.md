---
description: Sync the documentation index against current codebase state — README, diagrams, markdown files, AGENTS.md
argument-hint: [specific doc name or leave blank for all]
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Index Sync: $ARGUMENTS

Compare existing documentation against the current codebase. Report what's accurate, outdated, should be removed, trimmed, merged, or is missing. You are an orchestrator — spawn subagents for comparison work, synthesize, and talk to the user.

## Core Principle

A wrong document is worse than no document. Delete before you let it go stale.

Progressive disclosure: AGENTS.md (5 sec) → diagrams + markdown files (2-5 min) → code (source of truth). Each layer adds depth. A developer stops at the layer that answers their question. Sync must preserve this hierarchy.

Four formats to sync:

| Format | Lives in | Sync question |
|--------|----------|---------------|
| **README.md** | repo root | Are install steps, commands, flags, and project structure still accurate? |
| **AGENTS.md** | repo root | Are file paths, routing entries still valid? |
| **Mermaid diagrams** | `docs/diagrams/` | Do nodes, edges, constants, and labels match current code? |
| **Markdown files** | `docs/` | Are checklists, values, procedures, and traps still accurate? Is the topic still relevant? |

**Accuracy is the primary sync criterion.** Does the document still match current code? Accurate documents that compress cross-file knowledge or capture trap knowledge are kept — diagrams are ~50 lines and maintenance cost is near-zero. Only recommend **Remove** when the underlying code was deleted, the knowledge was fully absorbed elsewhere, or the document is so stale that fixing it costs more than recreating it. For **section-level trimming**, ask: does this section add value beyond what the code shows on its own?

## Phase 1: Orient

1. Inventory existing docs:
   - Read `AGENTS.md` to understand current structure and references
   - List all files in `docs/diagrams/` and `docs/`
   - If `$ARGUMENTS` names a specific doc → scope the sync to just that doc
   - If no arguments → sync everything

2. Check for ephemeral research docs in `docs/research/` and `docs/plan/`. Skip files prefixed with `TODO-` — these are pending future work and must survive indexing. Flag the rest for the absorption step.

3. If no docs exist → you're probably looking for `/index-codebase` instead. Tell the user.

## Phase 2: Evaluate

Batch related documents into 2-4 subagents by category and spawn in parallel:
- **Diagrams agent(s):** all diagrams (split into 2 agents if >6 diagrams)
- **Markdown agent:** all markdown reference docs + research docs
- **README + AGENTS agent:** both root files together

Each subagent evaluates its documents as follows:

### For diagrams:
1. **Read the diagram** — understand what it claims to show and which code files it covers.
2. **Read the current code** — check every node, edge, label, and constant against the actual codebase.
3. **Check if the diagram's subject still exists** — was the code it covers deleted, merged, or simplified beyond recognition? If the code still exists and the diagram is accurate, keep it.
4. **Check for merge candidates** — are two diagrams now covering overlapping territory? Could they be consolidated?
5. **Count nodes** — if >12, report as **Oversized** with a recommended split boundary (e.g., "split into X + Y").

### For markdown files:
1. **Read the file** — understand what topic it covers.
2. **Evaluate each section independently** — apply the litmus test per section. A document may earn its keep overall while specific sections are code-readable and should be cut.
3. **Check every specific value** — file paths, constants, thresholds, commands, procedures against current code and environment.

### For README.md:
1. **Check every command** — do flags, arguments, and examples still work?
2. **Check project structure** — does the tree match actual directories/files?
3. **Check install steps** — still accurate for current dependencies?

### For AGENTS.md:
1. **Check every file path** in "by task" routing — does the file still exist? Is it still the right entry point?
2. **Check every debugging symptom** — still valid? Missing new common failures?
3. **Check deep dive references** — do all linked docs still exist? Any orphaned?
4. **Check narrative claims** — statements like "Two reference docs remain" must match actual file counts.

### For all documents, report one of:
- **Accurate** — matches current code
- **Outdated** — content is stale (wrong names, missing nodes, changed values, broken paths) but still earns its keep. List specific deltas.
- **Trim** — document earns its keep but specific sections don't. List sections to cut and why each fails the litmus test.
- **Oversized** — diagram exceeds 12 nodes. Report node count and recommended split boundary.
- **Remove** — underlying code was deleted, or knowledge fully absorbed into another document
- **Merge** — two documents overlap and should be consolidated into one

### For ephemeral research docs (`docs/research/`, `docs/plan/`, excluding `TODO-*`):
1. **Read each research doc** — understand what knowledge it captured.
2. **Identify the absorption target** — which permanent doc (diagram, markdown file, or AGENTS.md section) should this knowledge merge into? Or does it warrant a new permanent doc?
3. **Report as:** **Absorb** — `research-doc` → `target-doc` with a summary of what gets absorbed.
4. **If research contradicts current code, code wins** — discard the contradicting content. Research docs capture point-in-time observations; code is the source of truth.

## Phase 2b: Gap Scan (optional, best-effort)

After evaluation completes, do a light scan for new documentation candidates. This is separate from evaluation — don't burden evaluation agents with it. Scan the codebase structure and recent changes for (see [references/format-rules.md](references/format-rules.md) for diagram types and markdown file criteria):
- New modules with non-trivial interconnections spanning 3+ files (→ topology update or new diagram; split if >12 nodes; keep each under 12)
- New cross-file flows (3+ files → dataflow candidate)
- New dense logic (>5 min to grok → decomposition candidate)
- New external system knowledge (deployment, hardware, third-party → markdown file candidate)
- New common failure modes (→ AGENTS.md debugging table update)

Report as: **New candidate** with type, proposed name, and why it passes the litmus test. If nothing found, skip this section in the report.

## Phase 3: Report

Present a consolidated status to the user:

```
README.md:
  {Accurate | Outdated — what changed}

Diagrams:
  Accurate:       diagram1, diagram2
  Outdated:       diagram3 — {what changed}
  Trim:           diagram4 — {which sections to cut}
  Oversized:      diagram5 — {node count, recommended split}
  Remove:         diagram6 — {what was deleted or absorbed}
  Merge:          diagram7 + diagram8 — {why they overlap}

Markdown files:
  Accurate:       file1
  Outdated:       file2 — {what changed}
  Trim:           file3 — {sections to cut, why each fails litmus test}

Absorb (ephemeral → permanent):
  docs/research/foo.md → docs/diagrams/bar.md — {what knowledge gets merged}

AGENTS.md:
  Stale entries:  {list of broken paths, outdated commands, missing routes}

New candidates:
  {proposed name} ({diagram|markdown}) — {why it passes the litmus test}
```

**AskUserQuestion** — user selects what to act on:
- Which outdated docs to update
- Which docs to trim (and confirm sections to cut)
- Whether to split oversized diagrams
- Whether to delete recommended removals
- Whether to merge recommended consolidations
- Whether to generate new candidates
- Which AGENTS.md entries to fix

## Phase 4: Execute

For simple edits (field name fixes, line deletions, reference updates, section removals), edit directly — don't spawn subagents for trivial changes. Spawn subagents only for complex rewrites (rewriting a full diagram from code, merging two documents, generating new docs).

- **Update:** rewrite stale content against current code. Preserves the filename for link stability.
- **Trim:** delete the specified sections from the document. Update the document's header description if it no longer matches.
- **Oversized split:** rewrite the diagram as 2+ focused diagrams, each under 12 nodes. Update AGENTS.md and any cross-references.
- **Remove:** grep for the deleted filename across all files in `docs/`, `docs/diagrams/`, `README.md`, and `AGENTS.md` to find every reference. Remove all references, then delete the file.
- **Merge:** read both source documents + current code, write consolidated document under the surviving filename. Delete the other. Update AGENTS.md references.
- **New:** read source files, generate document following the format rules below.
- **Absorb:** read the ephemeral research doc + the target permanent doc + current code. Merge the knowledge into the target. Delete the ephemeral file. Update AGENTS.md if the target is new.
- **AGENTS.md fix:** update stale paths, commands, routing entries, debugging symptoms, deep dive references, narrative claims.

### Diagram and markdown file format

See [references/format-rules.md](references/format-rules.md) for diagram and markdown file format specifications, node ceiling (12), chunking rules (2-4 subgroups), and file layout templates.

## Phase 5: Verify

After all actions complete:
- Every diagram and markdown file referenced in AGENTS.md actually exists
- Every "by task" entry points to a real file
- No orphan docs (files in `docs/` not linked from AGENTS.md)
- No dead links in AGENTS.md deep dive references
- No dead links between docs (grep for any `.md` references and verify targets exist)
- README.md and AGENTS.md cross-reference each other (no duplicated commands)
- Narrative claims in AGENTS.md match reality (e.g., doc counts)
