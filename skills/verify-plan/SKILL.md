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

## 3. Audit Coverage

For each major requirement inferred from the user's intent, check the plan:

| Requirement | Status | Where addressed |
|-------------|--------|-----------------|
| ... | Covered / Partial / Missing | Plan section or "—" |

Give a one-line coverage score (e.g., "4/5 requirements covered, 1 partial").

List the top gaps — requirements that are missing or only partially addressed.

## 4. Ask Clarifying Questions

If gaps exist, use AskUserQuestion (1-3 questions) before patching:
- Confirm whether the gap is intentional or an oversight
- Clarify ambiguous requirements that could be addressed multiple ways
- Ask about priorities if multiple gaps compete

If coverage is complete (all requirements covered), skip to step 5.

## 5. Patch the Plan

Produce a patched version that closes the gaps. Minimal changes — preserve the original structure. Only add or modify sections needed to address confirmed gaps. Do not rewrite sections that are already correct.

After patching, re-run the coverage table to show the improvement.
