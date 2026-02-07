---
name: update-lessons
description: Search recent conversation history for key insights and create a plan to update docs/lessons-learned.md. Run daily or after productive sessions. Triggers include "update lessons", "what did we learn", "add to lessons learned".
allowed-tools: Bash, Read, Glob, Grep, AskUserQuestion, Write
---

## Purpose

Distill recent work into insights that make tomorrow easier. Search conversation history, confirm what matters with the user, and produce a plan for updating `docs/lessons-learned.md`.

## Guiding Principle

Lessons-learned captures what saves the next person hours. Think published papers, not lab notebooks. Look at the past to refine the present to impact the future.

## Search History

Pull recent conversations. Default to yesterday; adjust if the user specifies a date.

```bash
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest yesterday
```

For deeper context, read the full session JSONL for relevant sessions:
```bash
cat ~/.claude/projects/<encoded-path>/<session-id>.jsonl
```

## Identify Insights

Scan for moments where something important was learned — patterns discovered, problems solved, decisions made, gotchas encountered. For each, extract: **what was learned**, **why it matters**, and **what to do about it**.

## Confirm with User

Present candidates concisely via AskUserQuestion. One line per insight. Ask which ones belong in lessons-learned. Let the user cut, add context, or reframe. This step is mandatory.

## Read Existing Doc

Read `docs/lessons-learned.md`. Understand the current structure, numbering, and format. New sections must match the existing style.

## Create Plan

Write to `docs/plan/` following this structure:

```
# Plan: Update lessons-learned with [Date] Insights
## Context — what work produced these insights (2-3 sentences)
## Changes — new sections matching existing format + updates to any reference tables or diagrams
## Verification — checklist for completeness and consistency
```

Tell the user: "Plan created. Run `/refine` to verify coverage, then implement."
