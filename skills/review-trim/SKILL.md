---
name: review-trim
description: Review docs with the user — level-set, align on direction, surface bloat, trim through dialogue
argument-hint: <path to file or directory>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Review-Trim: $ARGUMENTS

$ARGUMENTS is mandatory — path to a file or directory:
- `docs/research/` → all 3 research docs together
- `docs/specs/` → all specs together
- single file path → single file mode (detect spec vs non-spec from path)

## Principle

The user knows the vision and priorities. You know the codebase and details. Neither alone trims well. You read and compare silently. You come to the user with a picture and pointed questions. They steer. They never read the full docs.

Two levels of questions. Directional questions (keep/defer/cut?) go one at a time with context. Specific bloat items (this duplicates X — cut?) are fast yes/no. Set direction first, then surface specifics.

Don't assume context. Start high-level, go deeper only as the user wants.

---

## Mode: Research docs (`docs/research/`)

### Round 0 — Level-set

Read all 3 docs silently. Read source files they reference. Start with a 3-5 sentence summary at the highest level. If the user says "I know," move on.

### Round 1 — Direction

Surface 3-4 directional questions about scope and strategy. One at a time — context, tradeoff, let the user decide.

### Round 2 — Specific bloat

3-5 concrete bloat items as yes/no. Informed by Round 1 decisions + codebase knowledge: things that already exist, contradict another doc, are premature, or that a builder would figure out.

### Round 3 — Trim and show diff

Update files. Show compact summary of what changed and why. More rounds if needed, max 5.

---

## Mode: All specs (`docs/specs/`)

Specs are inputs to plan mode sessions. Plan mode reads the spec + codebase, proposes steps, executes. Specs carry only what plan mode can't discover: goal, interfaces, data contracts, verification. Bloat = anything plan mode figures out from the codebase.

### Round 0 — Level-set

Read all specs + source code they reference. Brief the user in 3-5 sentences. If they know, move on.

### Round 1 — Direction

Present an ASCII table (one row per spec: what it builds, new files, modifies). Surface 2-3 directional questions targeting:
- Interface-only vs implementation detail
- Session granularity (merge candidates, non-code pieces)
- Cross-spec data contract consistency

### Round 2 — Specific bloat

List bloat items with spec IDs. Focus on things plan mode discovers on its own: implementation guidance, approach prescriptions, platform caveats, workflow advice, sections plan mode ignores, premature deliverables with no downstream consumer.

### Round 3 — Trim and show changes

Update spec files. Show compact before/after summary per spec.

---

## Mode: Single spec file

Specs are inputs to plan mode. Bloat = anything plan mode discovers from the codebase.

### Round 0 — Read the spec, source code it references, upstream/downstream specs for data contracts.

### Round 1 — 3-5 line summary. Surface 1-2 directional questions if scope feels off: session sizing, interface-only check.

### Round 2 — List bloat items: implementation details, things that already exist, premature deliverables, data contract mismatches.

### Round 3 — User decides. Multiple rounds if needed. Update the file.

---

## Mode: Single file (non-spec)

### Round 0 — Read the file and source code it references.

### Round 1 — 3-5 line summary. Surface 1-2 directional questions if scope feels off.

### Round 2 — List bloat items: things that already exist, premature content, over-specification.

### Round 3 — User decides. Multiple rounds if needed. Update the file.

---

## Commit

If files were edited:

Research docs: `git add docs/research/ && git commit -m "review-trim: crystallize research docs"`

Specs: `git add docs/specs/ && git commit -m "review-trim: crystallize specs before implementation"`

Single file: `git add <file> && git commit -m "review-trim: crystallize <filename>"`
