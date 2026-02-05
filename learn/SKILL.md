---
description: Analyze conversation for learnings and save to docs folder
argument-hint: [optional topic hint]
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

Extract reusable, non-obvious, project-specific insights from this conversation. Focus on: $ARGUMENTS

Only capture what would help in future similar situations. Skip if nothing valuable was learned.

Save to `docs/` . Match existing doc style. Propose new kebab-case file if no existing doc fits.

Present what you found and where you'll save it. **Wait for explicit user approval before writing.**
