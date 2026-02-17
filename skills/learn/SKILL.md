---
name: learn
description: Analyze conversation for learnings and save to docs/research/ for later placement by /index-sync
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

If `$ARGUMENTS` provided, focus on that topic. Otherwise, analyze the full conversation.

## What did we learn?

Identify insights that are **reusable**, **non-obvious**, and **project-specific**:
- Traps or pitfalls encountered
- Architecture decisions and rationale
- New patterns/approaches discovered
- Conventions established
- Troubleshooting solutions

If nothing valuable was learned, say so and exit.

## Does the user approve?

Present: what insights were captured and the exact content. **Wait for explicit approval before saving.**

## Where does it go?

Write to `docs/research/<topic-slug>.md`. Create `docs/research/` if needed. This file is **ephemeral** — `/index-sync` will later place each insight at the right level of the hierarchy (CLAUDE.md, diagram, reference doc, or code comment) and delete the file.

Don't try to place knowledge in its permanent home — that's `/index-sync`'s job. `/learn` captures quickly, nothing more.

When done, suggest: "To integrate these learnings into permanent docs, run `/index-sync`."
