---
name: verify-plan
description: Verify a plan before implementation. Audits coverage against user intent, asks clarifying questions about gaps, patches the plan. Triggers include "verify plan", "check the plan", "verify-plan", "is the plan ready", "audit plan".
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
---

## 1. Read the Plan

Read the plan markdown file from `docs/plan/`. If no plan exists, tell the user and stop.

## 2. Gather Intent

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

## 3. Audit Coverage (internal)

For each requirement from step 2, check whether the plan addresses it. Track this internally — do NOT show the raw table to the user.

## 4. Synthesize

Present a plain-English summary to the user:
- **What the plan covers** — one paragraph, high-level
- **Gaps** (if any) — for each gap, explain in simple terms: what's missing, why it matters, and whether it needs a code change or is just a docs/notes issue
- If no gaps: say the plan is solid and move to step 6

Keep it concise. No tables, no jargon, no "Covered/Partial/Missing" labels.

## 5. Clarify Gaps

If gaps exist, use AskUserQuestion (1-3 questions):
- Is the gap intentional or an oversight?
- If ambiguous, what does the user prefer?

If no gaps, skip to step 6.

## 6. Patch the Plan

Minimal changes to close confirmed gaps. Preserve original structure. Do not rewrite sections that are already correct.
