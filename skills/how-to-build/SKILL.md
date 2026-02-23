---
name: how-to-build
description: Decide what to build and in what order — pieces, dependencies, risks, key decisions
argument-hint: "[optional extra context]"
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion
---

# How to Build: $ARGUMENTS

## What this produces

`docs/research/how-to-build.md` — the build pieces, their dependencies, and the decisions behind them. But the document comes after the conversation, not before it.

## On entry

Read `docs/research/brainstorm.md` if it exists:
- Reflect your understanding back. Name the problems, surface dependency tensions, flag pieces that might be parallelizable or that conflict. Let the user correct you before proposing structure.

If it doesn't exist:
- Tell the user: "No brainstorm found — I'll work from what you give me. Pieces won't link back to brainstorm problems, which means breakdown-issues will have less context. Fine to proceed."
- Ask: what are we building?

If $ARGUMENTS adds extra context beyond what brainstorm covers, incorporate it.

## How to converge

This is a conversation, not a template fill. A few focused exchanges to land on:
- What the pieces are and what each one delivers
- What order to build them in and why
- Where the risks live

Surface disagreements early. If the user wants to build X before Y but Y is a dependency, name the tension. If two pieces could be parallel, say so. Let the user steer — your job is to make the tradeoffs visible, not to decide.

When the shape is clear, write.

## Writing the document

Create `docs/research/` if needed. Write `docs/research/how-to-build.md`.

If the conversation surfaced an overall strategy or approach worth capturing, open with a brief orienting paragraph ("incremental migration", "spike first then generalize", etc.). Skip it if there's nothing to say — don't write filler.

Numbered pieces. Each piece gets a heading and three fields:

```
## 1. {piece name}

- **What:** concrete deliverable + constraints the codebase won't tell you. Reference brainstorm problems by name where meaningful — don't re-explain them. For every detail, ask: would a builder figure this out from the code? If yes, leave it out.
- **Depends on:** which other pieces must exist first (by name). "None" if independent.
- **Risk:** what can go wrong and how to detect it early. Skip if genuinely low-risk.
```

After the pieces, two closing sections:

```
## Decisions made

Key choices from the conversation. Format: "We chose X over Y because Z."
Only choices that a future session needs to know — don't log every micro-decision.

## What's still uncertain

Open items from brainstorm or the conversation that affect the build but aren't resolved.
Things someone picking up this work should know are unfinished.
```

Omit either section if empty. Don't write "None" — just leave it out.

## What NOT to include

- Test criteria — that's `/how-to-test`'s job entirely.
- Build order diagrams or milestone markers — ordering is implicit in piece numbering and "Depends on" fields.
- Implementation details a builder would figure out from the codebase.

AskUserQuestion: does this capture what we discussed? Anything to revise?

## Commit

`git add docs/research/how-to-build.md && git commit -m "how-to-build: build pieces for $ARGUMENTS"`

## Next

"Next: `/how-to-test` to define verification criteria for each piece."
