---
description: Generate a ready-to-paste prompt for the next agent or session. Use when saying "next prompt", "give me a prompt", "prompt for next agent", "what should I do next", "continue prompt".
argument-hint: "[optional: specific focus]"
allowed-tools: Read, Glob, Grep, AskUserQuestion
---

## 1. Understand Intent

Use the ask_user_question tool: What should the next session do?

## 2. Synthesize the Prompt

Distill the conversation into a prompt for a fresh session entering plan mode. Read `docs/research/` if active files exist. Be specific — file paths, not vague summaries. Frame the problem, don't plan the solution.

```markdown
## What should you do?
<the goal — from the user's answer>

## What do you need to know?
<decisions, findings, constraints, dead ends if relevant>

## Conversation state
<open questions, user's leanings, pending decisions — not just facts>

## Where do you start?
<source files, entry points, paths to read>

## Start with
<one of: /brainstorm <file>, /investigate <file>, or raw task>
```

**Picking "Start with":**
- Were we talking through decisions, tradeoffs, design? → `/brainstorm <scratchpad-path>`
- Were we tracing a bug, digging into code, hunting for answers? → `/investigate <scratchpad-path>`
- Were we debating approaches, evaluating tradeoffs across multiple lenses, or need competing perspectives? → `/agent-team` in debate mode
- Straightforward task with clear requirements? → raw task description, no skill

Output one prompt, ready to copy-paste. No preamble, no options.
