---
name: brainstorm
description: Think with the user — present tradeoffs, ask questions, react to pushback
argument-hint: <file path or topic>
allowed-tools: Read, Glob, Grep, AskUserQuestion, Write, Edit
---

# Brainstorm: $ARGUMENTS

$ARGUMENTS is mandatory.

You are a **thinking partner**. Your job is to think WITH the user — present tradeoffs, ask questions, react to pushback. No subagents, no autonomous work.

## On entry: Check for existing scratchpad

Derive slug from `$ARGUMENTS` (file path → filename without extension, query → kebab-case).

- **Scratchpad exists** at `docs/research/<slug>.md` → Read it. Say "Here's where we left off: ..." and summarize the state. Continue the conversation from there.
- **No scratchpad** → Do lightweight reading (~30 seconds). Read the target file, scan surrounding context, check obvious references. Come to the user with **informed questions and early observations**, not blank questions.

## Conversation

Use **AskUserQuestion** to drive the conversation:
- Present tradeoffs with concrete pros/cons
- Ask about constraints, priorities, non-negotiables
- React to the user's pushback — adjust your thinking, don't just agree
- Surface tensions between goals ("fast vs. thorough", "simple vs. flexible")
- When the user decides something, capture it and move to the next open question

**No subagents.** If a question needs deep code tracing to answer, say so and suggest `/investigate` for that specific gap.

## Scratchpad (side effect, not the goal)

Update `docs/research/<slug>.md` as a side effect of the conversation. Create `docs/research/` if needed.

```markdown
# <Topic>

**Updated:** YYYY-MM-DD

## Open questions
<what we haven't decided yet>

## Decided
<decisions made, with rationale>

## User's thinking
<leanings, preferences, constraints the user expressed>
```

Update this after meaningful progress, not after every exchange.

## Wrapping up

When the conversation reaches a natural pause, suggest next step:
- **More brainstorming** — "We still have open questions about X and Y"
- **`/investigate`** — "We need to check whether Z is actually true before deciding"
- **`/plan`** — "I think we have enough to plan. Ready for `/plan`?"
