---
name: brainstorm
description: Think with the user — free-form or structured. May produce a milestone with issues, or just conversation.
argument-hint: <topic, vision, or file path to existing milestone>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, WebSearch, WebFetch
---

# Brainstorm: $ARGUMENTS

$ARGUMENTS is mandatory — a topic to explore or a path to an existing milestone file. If $ARGUMENTS is neither, ask the user to clarify.

## What this produces

Not every brainstorm produces a file. Three possible outcomes:

1. **Just conversation** — the user wanted to think out loud. No file. That's a valid outcome.
2. **Milestone with issues** — issues crystallized. A file in `docs/research/m{id}-{slug}.md` with the full structure below.
3. **Milestone without issues** — thinking advanced but no issues emerged yet. A file with just the milestone section filled in. The next session picks up from there.

Don't push toward a file. After 4+ substantive exchanges, offer once to capture something — then respect the answer. If nothing worth writing emerges, nothing gets written.

## On entry

**New milestone** ($ARGUMENTS is a topic or query):
- Don't explore the codebase unless there's something concrete to explore. Start the conversation.
- If the topic matches an existing milestone name in `docs/research/`, ask the user whether to resume it or create a new one.
- Create `docs/research/m{id}-{slug}.md` only when something worth capturing emerges — not before. Increment the id from existing milestone files in `docs/research/`; start at m1 if none exist. Create the directory if missing.

**Existing milestone** ($ARGUMENTS is a file path):
- Read the file. Count decided items (subsections filled) vs. open questions (subsections empty or unresolved).
- Brief the user in 2-3 sentences: what the milestone is about, how many issues exist, what's decided, what's still open.
- If more open than decided, say so and default to deciding mode — propose answers to the open questions rather than exploring new ones. The user can always redirect to exploration if that's what they want.

## How to think together

- **User is confident** → Challenge them. "What breaks if X happens?" Make them defend it.
- **User is stuck** → Give them concrete options with tradeoffs. Something to react to.
- **User pushes back** → They know something you don't. Ask what.
- **User wants to decide** → Stop exploring. For each open question, propose a concrete answer as a decision, not a question. Let the user accept, reject, or modify. Move through them one at a time until they're closed.

One question at a time. Before opening a new question, check if the current one is resolved — don't let threads pile up unfinished.

### Convergence check

After every 3-4 exchanges, silently count open questions vs. decided items in the conversation. If open questions grew since the last check, tell the user: *"We started with N open questions, now there are M. Want to start deciding, or keep exploring?"* Don't keep opening if the user hasn't closed the previous questions.

## The four lenses

The lenses describe what phase the brainstorm is in. The room-reading rules above describe how to interact within any phase.

### When exploring what problems to solve

As problems take shape, issues emerge. Write them into the file as they crystallize — don't wait. Each issue starts with just "What are we solving?" filled in. The rest stays empty. The milestone section captures cross-cutting context: overall strategy, decisions, exclusions. If the conversation has been going for a while and most time is still here, surface it — exploration without convergence stalls.

### When defining what each issue delivers

Surface dependency tensions. If one issue can't start until another is done, name it. If two issues could be parallel, say so. Make tradeoffs visible.

**Splitting test:** each issue must be plannable and implementable in one Claude Code session (~150k context). The practical test: can you describe the full spec for this issue in under ~500 lines? If not, split it. If sub-questions all depend on each other, it's one issue with facets — don't split. If they can be solved independently, they're separate issues.

### When defining verification criteria

Focus on verification risk — which issues are hardest to check, where the boundaries are. Each checkbox should be a concrete check someone can run and answer yes or no.

### When reviewing for readiness

Read the whole file silently. Brief the user. Then follow their lead:

- Surface bloat — things the codebase already handles, duplication between issues, implementation details a builder would figure out. For every sentence, ask: would plan mode figure this out from the codebase? If yes, cut it.
- Surface contradictions — issues that conflict, decisions that don't align.
- A decided item with imperfect wording is still decided. Fix the wording — don't reopen the question.
- Trim only what the user approves.

When the user is satisfied, set `reviewed: true`. If the file is edited after that, note the change and ask the user if the review still holds.

## Writing

### File format

````markdown
---
reviewed: false
---

## Milestone: {name}

### What are we solving?

{The overarching problem — why this body of work exists}

### What are we building?

{Overall strategy and approach — the shape of the whole, not individual pieces}

### How do we verify?

{Milestone-level success criteria — what does done look like across all issues}

### What do you need to know?

{Cross-cutting decisions, constraints, excluded approaches, dead ends}

## {Issue title}

Blocked by: [{other issue title}, {another issue title}]

### What are we solving?

{The specific problem, why it matters}

### What are we building?

{Concrete deliverable, constraints}

### How do we verify?

- [ ] {binary pass/fail condition}

### What do you need to know?

{Decisions, watch-outs, dead ends specific to this issue}
````

Omit the "Blocked by" line for independent issues. Use issue titles from this file as identifiers in "Blocked by" — avoid renaming issue titles casually once references exist.

## Sense of done-ness

- Most issues have "What are we solving?" filled → problems are taking shape
- Most issues have "What are we building?" filled → build plans are emerging
- Most issues have "How do we verify?" filled → verification is defined
- All of the above, plus `reviewed: true` → the milestone is ready

When done, pick the first unblocked issue and start a new session in plan mode.
