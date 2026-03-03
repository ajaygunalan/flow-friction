---
name: harvest
description: End-of-session signal extraction. Asks questions to separate signal from noise, writes only what the user approves. Use when the user says "harvest" or wants to capture thinking before ending a session.
argument-hint: "[optional: query to focus on]"
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

Ask 1-4 AskUserQuestion to scope what matters — which threads to keep, what to drop, what stage the thinking is at. If $ARGUMENTS is a query, use it to focus.

Read the conversation through four lenses and draft what fits. Drop exploration, tangents, and dead ends.

1. What are we solving? — the problem
2. What are we building? — the approach
3. How do we verify? — done-ness
4. Context — what a fresh agent would get wrong without being told

Present the draft. The user approves, corrects, or cuts.

Write to the existing harvest file if one was referenced, otherwise create a new file.
