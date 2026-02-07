---
name: learn
description: Analyze conversation for learnings and save to docs folder
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# Learn from Conversation

Analyze this conversation for insights worth preserving in project documentation.
If `$ARGUMENTS` provided, focus on that topic. Otherwise, analyze the full conversation.

## Phase 1: Analyze

Identify insights that are **reusable**, **non-obvious**, and **project-specific**:
- New patterns/approaches discovered
- Gotchas or pitfalls encountered
- Architecture decisions and rationale
- Conventions established
- Troubleshooting solutions

If nothing valuable was learned, say so and exit.

## Phase 2: Locate

Read existing `docs/` folder to find the best home. If no doc fits, propose a new kebab-case file.
Never modify CLAUDE.md — all learnings go to `/docs` only.

## Phase 3: Draft

Format to match existing doc style: clear heading, concise explanation, code examples if applicable, context on when it applies.

## Phase 4: Approve (BLOCKING)

Present: what insight, where it goes, exact content. **Wait for explicit approval before saving.**

## Phase 5: Save

After approval, save and confirm.