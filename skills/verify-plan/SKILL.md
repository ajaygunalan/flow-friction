---
name: verify-plan
description: Verify and refine a plan before implementation.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
---

Read `docs/plan/<>.md`. If no plan exists, tell the user and stop.

The original request in this conversation is the source of truth.

Read the plan against the original request. Identify ambiguities, missing requirements, and unclear design decisions. Also read `docs/research/*.md` — if scratchpads exist, check that the plan doesn't contradict confirmed findings. Use the ask_user_question tool to ask specific questions about what you found.

Then send the plan for external review:

```bash
roborev run --wait "Review the plan in <plan_file_path> for feasibility, missing edge cases, alignment with the codebase architecture, and completeness"
```

Combine your own findings with the roborev review findings. Then fix the plan — keep changes minimal, preserve structure rather than rewrite.
