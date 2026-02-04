---
disable-model-invocation: true
name: pause
description: Save session state to RESUME.md for next agent to continue
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

Create a handoff that passes the essential context to the next agent.

## The Core Task

Distill the current work into what the next agent must understand to continue effectively. This is not a status report - it is a crystallization of intent.

Ask yourself: **What would I need to know if I were starting fresh on this exact problem?**

The answer is rarely "which files to edit." It is usually:
- What is the user trying to achieve?
- What is the strategy or approach?
- What has been tried, proven, or ruled out?
- What is the next concrete step?

## On Asking Questions

If the user's input clearly conveys their intent and strategy, do not ask - extract and crystallize it.

If the intent is unclear, ask up to 2 focused questions to surface it. Examples:
- "What's the approach you want to take here?"
- "What should we tackle first and why?"

If still unclear after 2 questions, you may ask 2 more. But 4 is the maximum - beyond that, make reasonable inferences and note your assumptions.

## Write RESUME.md

Write to `RESUME.md` in the current working directory.

Let the content dictate the structure. Some handoffs need:
- Strategy front-and-center (when sequencing matters)
- A decision point (when choices remain)
- A single next step (when the path is clear)
- Context on what's broken (when debugging)

Whatever you write, ensure:
1. The user's core intent is unmistakable
2. The next agent knows what to do first
3. What's verified vs uncertain is clear

Write prose, not checklists - unless checklists serve the content.

## Append to CLAUDE.md Session Log

After writing RESUME.md, append one line to `## Session Log` in CLAUDE.md:
- Format: `- 28th Jan, 2026, 4.58 pm: <one-line summary>` 
- If no Session Log section exists, create it at the end
