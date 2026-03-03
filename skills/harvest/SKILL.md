---
name: harvest
description: End-of-session signal extraction. Asks questions to separate signal from noise, writes only what the user approves. Use when the user says "harvest" or wants to capture thinking before ending a session.
argument-hint: [path to existing harvest file]
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

# /harvest

Extract the signal from a conversation. The brainstorming itself is just conversation — no skill needed. This skill is the crystallization moment at the end.

## Startup

1. Scan the conversation.
2. If $ARGUMENTS is a file path → read it. This is the existing state from previous sessions. Merge with what you find in the conversation.

## Question

Four lenses filter the signal from noise:

1. **What are we solving?** — the problem
2. **What are we building?** — the approach
3. **How do we verify?** — done-ness
4. **Context** — what a fresh agent would get wrong without being told

Ask questions until each lens is clear. One lens might need five follow-ups. Some lenses might have no answer yet — "not sure" is a valid capture. Ask whatever it takes beyond the four lenses too — if something matters and doesn't fit, capture it.

"Did we actually decide X or were we just exploring?"
"Is Y still open?"
"You said Z early on but shifted — where did you land?"

Adapt to complexity. A focused session might need two questions. A sprawling hour might need eight. Each answer sharpens the picture.

Use AskUserQuestion for structured choices when the question has discrete options. Use conversation for open-ended clarification.

## Propose → Align → Write

When signal and noise are separated, propose what to write as one picture. The user approves, corrects, or cuts. Only what survives goes into the file.

## Multi-session

When an existing harvest file is given, the session's signal gets merged with the existing state. The file represents current thinking — not a session log. Decisions get updated. Open questions get resolved or new ones appear. Dead ends accumulate so they are not revisited.

The file is rewritten each time, not appended to.

Early sessions the file might be sparse — mostly open questions under "What are we solving?" and nothing under the rest. That's fine. The file converges over sessions. When all four lenses are answered cleanly at the milestone level, break into issues — same four lenses per issue, each scoped so one agent session can execute it.

## The file

Write it wherever makes sense for the project. The user specifies the path, or the skill asks.

The file should be readable by a fresh agent in 30 seconds and give it enough context to continue the conversation next session.
