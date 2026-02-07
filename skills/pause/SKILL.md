---
name: pause
description: Save session state to docs/RESUME.md for next agent to continue
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

Write `docs/RESUME.md`. Distill: what is the user trying to achieve, what's the approach, what's been tried/proven/ruled out, and what's the next concrete step. Write prose, not checklists — unless checklists serve the content.

If intent is unclear from conversation, ask up to 2 focused questions. If still unclear, 2 more max — then infer and note assumptions.
