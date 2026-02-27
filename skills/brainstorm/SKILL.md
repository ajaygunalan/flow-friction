---
name: brainstorm
description: Think with the user — free-form or structured. May produce a milestone with issues, or just conversation.
argument-hint: <topic, vision, or file path to existing milestone>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, WebSearch, WebFetch
---

# Brainstorm: $ARGUMENTS

$ARGUMENTS is mandatory — a topic to explore or a path to an existing milestone file. If $ARGUMENTS is neither, ask the user to clarify.

## Core commitments

**Thinking is the goal; artifacts are residue.** Conversation alone is a valid outcome. Don't push toward a file. After 4+ substantive exchanges, offer once to capture — then respect the answer.

**One thread at a time; convergence is enforced.** Every 3-4 exchanges, count open vs. decided — if open questions grew, surface it: *"We had N open, now M. Decide or keep exploring?"*

**Match stance to the user's state.** Confident → challenge. Stuck → concrete options with tradeoffs. Pushes back → ask what they know. Wants to decide → stop exploring, propose answers one at a time.

**Write only what inference can't supply.** Test: "Would plan mode figure this out?" If yes, cut it. Fix wording on decided items — don't reopen them.

**Issues fit one execution context** (~150k context, ~500 lines spec). Interdependent sub-questions = one issue. Independent = separate issues.

## On entry

**New milestone** ($ARGUMENTS is a topic):
- Start the conversation — don't explore codebase without concrete reason.
- If topic matches existing milestone in `docs/research/`, ask: resume or new?
- Create file only when worth capturing. Path: `docs/research/m{id}-{slug}.md`, increment id (start m1 if none). Create directory if missing.

**Existing milestone** ($ARGUMENTS is a file path):
- Read file, count decided vs. open, brief user in 2-3 sentences.
- More open than decided → default to deciding mode. User can redirect.

## The four lenses

Phase descriptions — stance rules above apply within every phase.

**Exploring problems:** Write issues as they crystallize (start with only "Solving?" filled). Milestone section captures cross-cutting context. Surface when exploration stalls.

**Defining deliverables:** Surface dependencies and parallelism. Apply splitting test. Make tradeoffs visible.

**Defining verification:** Focus on risk — hardest to check, boundary conditions. Each checkbox: binary pass/fail.

**Reviewing readiness:** Read file silently, brief user, follow their lead. Surface bloat and contradictions. Trim only what user approves. Satisfied → `reviewed: true`. Edits after review → note change, ask if review holds.

## Outcomes

Three possible: (1) just conversation — no file, (2) milestone with issues — `docs/research/m{id}-{slug}.md`, (3) milestone without issues — file with only milestone section, next session picks up.

## File format

Use `skills/brainstorm/template.md` as the structure. Omit "Blocked by" for independent issues. Use issue titles as identifiers in "Blocked by" — avoid renaming once references exist.

## Done-ness

"Solving?" filled → problems shaped. "Building?" filled → plans emerging. "Verify?" filled → verification defined. All + `reviewed: true` → ready. When done, pick first unblocked issue → new session in plan mode.
