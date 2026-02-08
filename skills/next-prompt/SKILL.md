---
description: Generate a ready-to-paste prompt for the next agent or session. Use when saying "next prompt", "give me a prompt", "prompt for next agent", "what should I do next", "continue prompt".
argument-hint: [optional: specific focus or skill to target, e.g. "/research", "/implement"]
allowed-tools: Read, Glob, Grep
---

# Next Prompt

Analyze this conversation and produce a single, ready-to-paste prompt for the next agent or session.

## What to Extract

From the conversation, identify:
- **Where we are**: what was accomplished, what was decided, what was ruled out
- **Where we're going**: the obvious next step based on momentum
- **What matters**: open questions, unverified assumptions, known risks
- **What context the next agent needs**: file paths, findings, constraints — anything that would be lost between sessions

## How to Write It

The prompt must be **self-contained** — the next agent has zero conversation history. Include:
1. Enough context to understand the situation without re-reading everything
2. Specific file paths and line numbers where relevant
3. What's been tried/proven/ruled out (so the agent doesn't repeat work)
4. A clear deliverable — not "investigate X" but "produce X with Y"
5. Priority signal — what explodes vs what's cosmetic

If `$ARGUMENTS` names a skill (e.g. "/research", "/implement"), format the prompt for that skill's expected input style. Otherwise, write a general-purpose prompt.

## Output Format

Present exactly this:

```
### Next Prompt

<the prompt, ready to copy-paste>
```

Then a 1-line note on which skill or workflow it's designed for (e.g. "Paste after `/research`" or "Use as a new session opener").

No preamble. No options. One prompt. Done.
