---
description: Generate a ready-to-paste prompt for the next agent or session. Use when saying "next prompt", "give me a prompt", "prompt for next agent", "what should I do next", "continue prompt".
argument-hint: "[optional: specific focus]"
allowed-tools: Read, Glob, Grep, AskUserQuestion
---

## 1. Understand Intent

- If `$ARGUMENTS` is provided and clear → use as direction, go to step 2
- If conversation has clear momentum (one obvious next step) → infer, go to step 2
- Otherwise → **AskUserQuestion** with 2-4 questions: what should the next agent focus on, what's the priority

## 2. Synthesize the Prompt

Distill the current conversation — decisions, findings, dead ends, file paths — into a prompt for a fresh Claude Code session entering plan mode.

```markdown
## What am I supposed to produce?
<the goal — what the next agent should build or solve>

## What's the current state?
<decisions made, findings so far, where things stand>

## What didn't work?
<dead ends and failed approaches to avoid>

## Where exactly do I start?
< source files, entry points, and paths to read for implementation>
```

Rules:
- **Read the research file.** If `docs/research/` has an active file, read it. Focus on: "So what do we do?", "What don't we know?", and "What exists already?"
- **From conversation.** The conversation already contains the research and context. Distill it.
- **Specific.** File paths, line numbers, command outputs — not vague summaries.
- **Frame, don't plan.** The next agent enters plan mode. State the problem and point to files, not implementation details.
- **One prompt.** Pick the best next step.

## 3. Output

Present exactly:

```
### Next Prompt

<the prompt, ready to copy-paste>
```

No preamble. No options. One prompt. Done.
