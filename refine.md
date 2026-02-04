---
description: Verify and refine a plan before implementation
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write
---

# Refine Plan

Verify the plan captures the user's intent, patch gaps, clarify ambiguities.

## Phase 1: Read

Find the most recent plan in `docs/plan/` (excluding RESEARCH.md) and read it completely.

## Phase 2: Coverage Audit

Using the original request in this conversation as source of truth:

1. Infer major requirements from the request
2. For each requirement:
   - Mark: Covered / Partial / Missing
   - Cite where addressed (section name or short quote)
   - If no evidence, treat as Partial or Missing

3. Output:
   - Coverage score (0-100)
   - 1-2 sentence rationale
   - Top gaps prioritized by impact

## Phase 3: Patch

If gaps exist, produce a patched plan:

- Close gaps with minimal changes
- Preserve original structure
- Add/adjust sections rather than rewriting
- Update the plan file directly

After patching, append to the plan file:

```markdown
## Refinement Log

### [date, time]
- Coverage: [before]% → [after]%
- Gaps patched: [what was missing]
- Changes: [what was added/modified]
```

If Refinement Log section exists, append a new entry. This tracks evolution across multiple refinement rounds.

## Phase 4: Clarify

If ambiguities remain after patching:

- Use AskUserQuestion for edge cases, dependencies, verification criteria
- Ask 2-4 focused questions at a time
- Update plan with answers

## Phase 5: Confirm

When coverage is complete and ambiguities resolved, confirm the plan is ready. The user will run `/implement` when ready.

## Guidelines

- The original request is the source of truth, not the plan
- A plan can be internally coherent but miss the user's intent
- Multiple refinement sessions are normal
