---
name: verify-plan
description: Verify a plan before implementation. Audits coverage against user intent, asks clarifying questions about gaps, patches the plan. Triggers include "verify plan", "check the plan", "verify-plan", "is the plan ready", "audit plan".
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
---

## What does the plan say?

Read the plan from `docs/plan/`. If no plan exists, tell the user and stop.

## What did the user actually want?

If the original request is in this conversation, use it directly.

If not, find the session where this plan was created:

```bash
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest yesterday
```

Then read the conversation to extract what the user requested:

```bash
cat ~/.claude/projects/<encoded-project-path>/<session-id>.jsonl
```

Extract from user messages: what they asked for, what they confirmed, what they rejected, what they emphasized.

## What's covered and what's missing?

Audit every requirement from the previous step against the plan. Track this internally — do NOT show the raw table to the user.

Present a plain-English summary:
- **What the plan covers** — one paragraph, high-level
- **Gaps** (if any) — for each gap, explain in simple terms: what's missing, why it matters, and whether it needs a code change or is just a docs/notes issue
- If no gaps: say the plan is solid and move on

Keep it concise. No tables, no jargon, no "Covered/Partial/Missing" labels.

## How do we close the gaps?

If gaps exist, use AskUserQuestion (1-3 questions):
- Is the gap intentional or an oversight?
- If ambiguous, what does the user prefer?

If no gaps, skip this step.

Patch the plan with minimal changes to close confirmed gaps. Preserve original structure. Do not rewrite sections that are already correct.
