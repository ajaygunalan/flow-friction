---
name: pause
description: Save session state to docs/RESUME.md for next agent to continue
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

## 1. Update Active Research (if any)

Check for active research files:
```bash
awk '/^---/{c++; next} c==1 && /^status:/ && !/complete/{print FILENAME}' docs/research/*.md 2>/dev/null
```

If an active file exists and the session produced findings related to that topic, update the research file — revise Key Findings, Codebase Patterns, Recommended Approach, and Sources as needed. Append a new iteration if significant progress was made, or update the current iteration with new learnings.

If no active research exists, skip this step.

## 2. Write RESUME.md

Write `docs/RESUME.md`. Distill: what is the user trying to achieve, what's the approach, what's been tried/proven/ruled out, and what's the next concrete step. Write prose, not checklists — unless checklists serve the content.

If intent is unclear from conversation, ask up to 2 focused questions. If still unclear, 2 more max — then infer and note assumptions.
