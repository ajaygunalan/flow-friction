---
disable-model-invocation: true
description: Resume work from RESUME.md
allowed-tools:
  - Read
  - Bash
  - AskUserQuestion
---

Continue work from where the previous agent left off.

## Process

1. Read `RESUME.md` in the current working directory
   - If it doesn't exist: say "No RESUME.md found. Nothing to resume." and stop

2. Understand the handoff:
   - What is the user's intent?
   - What is the strategy or approach?
   - What is the next step?

3. Respond based on clarity:
   - **Clear next step**: State what you understand and proceed, or ask brief confirmation if the step is significant
   - **Decision point**: Present the options from RESUME.md and ask which path
   - **Ambiguous**: Ask what to tackle first

4. Delete RESUME.md: `rm RESUME.md`

5. Proceed with the work.
