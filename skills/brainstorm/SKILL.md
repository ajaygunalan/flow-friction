---
name: brainstorm
description: Think with the user across sessions to produce a milestone — a set of issues ready for plan mode
argument-hint: <topic, vision, or file path to existing milestone>
allowed-tools: Task, Read, Write, Edit, Bash, Glob, Grep, AskUserQuestion, WebSearch, WebFetch
---

# Brainstorm: $ARGUMENTS

$ARGUMENTS is mandatory — a topic to explore or a path to an existing milestone file.

## What this produces

A single file in `docs/research/m{id}-{slug}.md` (e.g., `m1-realtime-collab.md`, `m2-auth-rework.md`) containing a milestone and its issues. But the file is what accumulates — the conversation is what matters.

Milestones work best with 3-8 issues. If scope grows beyond that, consider splitting into separate milestones.

## On entry

**New milestone** ($ARGUMENTS is a topic or query):
- Start the conversation. The user IS the context. Don't explore the codebase unless there's something concrete to explore.
- Create `docs/research/m{id}-{slug}.md` with the frontmatter (`reviewed: false`) when the first thing worth writing emerges — not before. Increment the id from existing milestone files in `docs/research/`.

**Existing milestone** ($ARGUMENTS is a file path):
- Read the file. Scan each issue's subsections — note which are filled and which are empty.
- Brief the user in 2-3 sentences: what the milestone is about, how many issues exist, which issues are fully specified, which have gaps, and what the gaps are.
- Ask what they want to work on. Don't assume.

## How to think together

Read the room. This is the same regardless of what you're working on:

- **User is uncertain** → Explore with them. Open questions. Surface options they haven't considered.
- **User is confident** → Challenge them. "What breaks if X happens?" Make them defend it.
- **User is stuck** → Give them concrete options with tradeoffs. Something to react to.
- **User pushes back** → They know something you don't. Ask what.

One question at a time. Don't overwhelm. Pull from the codebase, the web, existing docs — whatever helps the conversation move. Be dynamic, not scripted.

## The four lenses

These are thinking modes, not sequential phases. Shift between them based on what the content needs and what the user asks for. The file's content tells you where things stand — empty subsections mean incomplete, filled subsections mean done.

### When exploring what problems to solve

The focus: what are the problems, what are the issues worth solving.

As problems take shape, issues emerge. Write them into the file as they crystallize — don't wait. Each issue starts with just "What are we solving?" filled in. The rest stays empty. The milestone section captures cross-cutting context: overall strategy, decisions, exclusions.

### When defining what each issue delivers

The focus: what does each issue actually deliver, what depends on what.

Surface dependency tensions. If one issue can't start until another is done, name it. If two issues could be parallel, say so. Make tradeoffs visible — don't decide.

Fill in "What are we building?" per issue. Update "Blocked by" lines. Update the milestone's "What are we building?" with the overall approach.

### When defining verification criteria

The focus: what does "done" mean for each issue.

Focus on verification risk — which issues are hardest to check, where the boundaries are. Each checkbox should be a concrete check someone can run and answer yes or no.

Fill in "How do we verify?" per issue. Add milestone-level verification in the milestone's "How do we verify?" for anything that spans issues.

### When reviewing for readiness

The focus: is this file clean, lean, and ready.

Read the whole file silently. Brief the user. Then follow their lead:

- Surface bloat — things the codebase already handles, duplication between issues, implementation details a builder would figure out.
- Surface contradictions — issues that conflict, decisions that don't align.
- Trim only what the user approves.

When the user is satisfied, set `reviewed: true`. If the file is edited after that, note the change and ask the user if the review still holds.

## Writing

Update the file as you go, not at the end. When an issue crystallizes, write it. When a milestone decision becomes clear, add it. The file is a living document across sessions.

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

### Lean rule

For every sentence, ask: would plan mode figure this out from the codebase? If yes, cut it. This applies during writing and especially during review.

## If nothing crystallized

Sometimes the conversation clarifies thinking without producing issues. If that happens, create the file with just the milestone section — "What are we solving?" and "What do you need to know?" filled in. No issues yet. The next session picks up from there instead of starting from zero.

## Sense of done-ness

Not a checklist — a feel:
- "Issues are named and problems are clear" → most issues have "What are we solving?" filled
- "Build plans are defined and ordering makes sense" → most issues have "What are we building?" filled
- "Verification criteria exist for each issue" → most issues have "How do we verify?" filled
- "The file is clean and a fresh session could pick up any issue" → `reviewed: true`

All issues fully specified and `reviewed: true` → the milestone is ready. Pick an issue and start a fresh plan-mode session.

## Next

"Pick an issue and start a new session in plan mode. Start from the first unblocked issue."
