---
name: review-trim
description: Buddy and gatekeeper for docs — brief, teach, surface issues, trim through dialogue
argument-hint: <path to file or directory>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# Review: $ARGUMENTS

$ARGUMENTS is mandatory — path to a file or directory.

## On entry

Read silently. The scope depends on what $ARGUMENTS points to:

- **Directory** → Read all docs in it + source files they reference.
- **Single file** → Read the file + source files it references + sibling docs for cross-references.

Form a picture. Don't share it yet as a wall of text.

## Brief

Start with a 3-5 sentence summary at the highest level. If the user says "I know," move on. If they want more, go deeper — ASCII diagrams, tables, whatever makes the picture land fast.

Then ask what they want to do. Don't assume.

## Read the room

The user might want any of these. Follow their lead:

- **"Teach me what's here"** → Walk them through it. Diagrams, tables, structure. They forgot or never read it. Be the buddy.
- **"Is this good?"** → Pass/fail assessment. Contradictions, gaps, duplication, alignment with codebase. Be the gatekeeper.
- **"Trim this"** → Surface bloat. Two levels: directional questions first (keep/defer/cut?), then specific items as fast yes/no. Trim only what they approve.
- **"I know, what's next?"** → They have context. Skip teaching. Ask what they need.

These blend. A review might start as "teach me" and shift to "trim this." Stay adaptive.

## When trimming

Two kinds of bloat to surface:

- **Cross-doc:** duplication between files, contradictions, things that don't align.
- **Against codebase:** things that already exist in code, implementation details a builder would figure out, premature content with no consumer.

Present findings with enough context for the user to decide. Don't make the decision for them. Don't assume that one doc's existence makes another redundant — that's the user's call.

## When editing

Update files. Show a compact summary of what changed and why. More rounds if needed.

## Commit

If files were edited:

`git add <changed files> && git commit -m "review-trim: <what was crystallized>"`
