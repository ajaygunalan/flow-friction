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

Ask questions to separate signal from noise. The goal is to figure out — together with the user — what actually matters from this session.

"Did we actually decide X or were we just exploring?"
"Is Y still open?"
"You said Z early on but shifted — where did you land?"

Adapt to complexity. A focused 20-minute session might need two questions. A sprawling hour across multiple tangents might need eight. Each answer sharpens the picture. Keep going until the signal is clear.

Use AskUserQuestion for structured choices when the question has discrete options. Use conversation for open-ended clarification.

## Propose → Align → Write

When signal and noise are separated, propose what to write as one picture. The user approves, corrects, or cuts. Only what survives goes into the file.

No predetermined structure. No template. The shape of the file follows the shape of the thinking — whatever structure fits what the user is actually working through. It could be three bullet points. It could be a page of decisions with reasoning. It could be a single open question that the next session needs to resolve.

## Multi-session

When an existing harvest file is given, the session's signal gets merged with the existing state. The file represents current thinking — not a session log. Decisions get updated. Open questions get resolved or new ones appear. Dead ends accumulate so they are not revisited.

The file is rewritten each time, not appended to.

## The file

Write it wherever makes sense for the project. The user specifies the path, or the skill asks. No fixed location, no naming convention.

The only rule: the file should be readable by a fresh agent in 30 seconds and give it enough context to continue the conversation next session.
