---
description: Generate a ready-to-paste prompt for the next agent or session. Use when saying "next prompt", "give me a prompt", "prompt for next agent", "what should I do next", "continue prompt".
argument-hint: [optional: specific focus or skill to target, e.g. "/research", "/implement"]
allowed-tools: Read, Glob, Grep, AskUserQuestion
---

## 1. Understand Intent

- If `$ARGUMENTS` is provided and clear → use as direction, go to step 2
- If conversation has clear momentum (one obvious next step) → infer, go to step 2
- Otherwise → **AskUserQuestion** with 2-4 questions: what should the next agent focus on, what's the priority, whether to target a specific skill

Check for active research:
```bash
awk '/^---/{c++; next} c==1 && /^status:/ && !/complete/{print FILENAME}' docs/research/*.md 2>/dev/null
```

If active research relates to this session's work, reference it in the prompt.

## 2. Synthesize the Prompt

Read the conversation. Extract decisions, findings, dead ends, file paths. Write a single prompt using these sections:

```markdown
## What am I supposed to produce?

## What's the current state?

## What didn't work?

## Where exactly do I start?
```

Rules:
- **Self-contained.** The next agent has zero conversation history.
- **Specific.** File paths, line numbers, command outputs — not vague summaries.
- **One prompt.** Don't offer options. Pick the best next step.
- If `$ARGUMENTS` names a skill (e.g. "/research", "/implement"), format for that skill's expected input style.

## 3. Output

Present exactly:

```
### Next Prompt

<the prompt, ready to copy-paste>
```

Then a 1-line note on which skill or workflow it's designed for.

No preamble. No options. One prompt. Done.
