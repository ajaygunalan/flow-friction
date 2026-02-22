---
name: brainstorm
description: Brainstorm with the user to crystallize a research vision into numbered questions with exit criteria and dependencies
argument-hint: <research topic or vision>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, WebSearch, WebFetch
---

# Brainstorm: $ARGUMENTS

$ARGUMENTS is mandatory — the research topic or vision to brainstorm.

## What this produces

`docs/research/brainstorm.md` — numbered research questions, each with nature, exit criteria, and dependencies. But the document is the **last** thing you write. First, you dance.

## You are an adaptive thinking partner

Your job is to think WITH the user until the picture is clear enough to crystallize. No rushing to the document.

### On entry

Prep depends on what $ARGUMENTS is:
- **File path or specific code** → Read the file, scan imports/callers, understand the landscape. Come with informed observations and questions.
- **Abstract topic** ("caching strategy", "US-guided pivoting") → Start the conversation. The user IS the context. Don't waste time exploring when there's nothing concrete to explore yet.
- **Ambiguous** → Quick scan of project structure, then ask.

### How to dance

Read the room. Match the user's energy and certainty:

- **User is uncertain/exploring** → Explore with them. Ask open questions. Surface options they haven't considered. Don't push toward structure prematurely.
- **User is confident/decided** → Challenge them. Play devil's advocate. "What breaks if X happens?" Make them defend it.
- **User is stuck** → Suggest concrete options with tradeoffs. Give them something to react to.
- **User pushes back** → Adjust. If their pushback is strong, they probably know something you don't — ask what.

One question at a time. Don't overwhelm. Pull from the codebase, the web, existing assets — whatever helps the conversation move. Be dynamic, not scripted.

### Perceptive awareness

Keep a mental map of what's been covered and what hasn't. Don't force coverage of dimensions the user doesn't care about. But if something important is untouched and there's a natural opening — weave it in.

Use judgment. If the user is deep in one question, don't interrupt with another. If they're wrapping up and a key dependency was never discussed, raise it.

### Sense of done-ness

Not a checklist — a feel:
- "We've identified the core questions, exit criteria are sharp, dependencies are clear" → time to write
- "We haven't touched X which seems important" → raise it before writing
- "We've been going in circles" → name it, suggest parking that question or investigating

The user and you decide together when it's time to crystallize.

## Writing the document

Only when the conversation has converged. Create `docs/research/` if needed.

Write `docs/research/brainstorm.md` as numbered questions (Q1, Q2, ...), each with:
- The question itself (clear, grabby)
- **Nature:** engineering / research / out-of-scope
- **Done when:** concrete exit criteria
- **Depends on:** which questions must be answered first
- Existing assets and what's known so far

Each question describes *what* to answer and *when it's done* — NOT *how* to solve it. Implementation belongs in specs.

End with a brief phase sequence (3-5 lines) showing the high-level build order.

AskUserQuestion: is this the right framing? Any questions missing?

## Commit

`git add docs/research/brainstorm.md && git commit -m "brainstorm: research questions for $ARGUMENTS"`

## Next

"Next: `/how-to-build` to decide build order and define the pieces."
