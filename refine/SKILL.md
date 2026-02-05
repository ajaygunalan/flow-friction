---
description: Verify and refine a plan before implementation
allowed-tools: Read, Glob, Grep, AskUserQuestion, Edit, Write
---

## Current Plan

!`cat docs/plan/*.md 2>/dev/null || echo "NO PLAN FOUND in docs/plan/ — tell user and stop."`

---

Audit the plan above against the original request in this conversation. For each requirement: Covered / Partial / Missing. Patch gaps with minimal changes (preserve structure, don't rewrite). Append a refinement log entry with coverage score and what changed. The original request is the source of truth, not the plan.
