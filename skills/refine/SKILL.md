---
name: refine
description: Verify and refine a plan before implementation. Audits the plan against user intent — from the current conversation or from conversation history if in a new session.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write
---

## Read the Plan

Read the plan markdown file from `docs/plan/`. If no plan exists, tell the user and stop.

## Gather Context

If the original request is in this conversation, use it directly.

If not, then find the session where this plan was created:

```bash
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest yesterday
```

This lists recent sessions with their IDs. Then read the actual conversation to see what the user requested:

```bash
cat ~/.claude/projects/<encoded-project-path>/<session-id>.jsonl
```

Focus on user messages — what they asked for, confirmed, rejected, and emphasized.

## Audit and Patch

Check each user requirement against the plan. Fix what's missing or partial. Keep changes minimal — preserve structure, don't rewrite.
