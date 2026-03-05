---
name: harvest
description: End-of-session distillation — scans the conversation and existing issues, filters signal from noise through adaptive questioning, then creates, updates, or closes issues. Use when the user says "harvest", wants to wrap up a session, capture decisions before closing, or bridge work to a future conversation.
argument-hint: "[optional: focus angle]"
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

## Phase 1: SCAN

Read the conversation from beginning to end. Read open issues in `docs/issues/` (skip `status: done`). If `$ARGUMENTS` is given, use it to focus.

Build a mental map: what was done, what changed, what broke, what was decided, what's still open.

## Phase 2: FUNNEL

Present a short summary of what you extracted — threads, decisions, open questions. Then ask the user what matters using `AskUserQuestion`.

This is adaptive, not fixed. Keep filtering until the user says that's enough. One round may suffice for a focused session. Five rounds may be needed for a sprawling brainstorm. Draw from these angles as needed — they are prompts, not a mandatory sequence:

- What are we solving?
- What are we building?
- How do we know it's done?
- What would a fresh agent get wrong?

Stop when the signal is clear.

## Phase 3: DECIDE

Based on the filtered signal + existing issues, propose a set of actions. Present them as a list for user approval:

- **Create** `<slug>` — new problem/deliverable surfaced
- **Update** `<slug>` — what changed and why
- **Rewrite** `<slug>` — understanding changed fundamentally
- **Split** `<slug>` into `<slug-a>` + `<slug-b>` — one issue is actually two problems
- **Merge** `<slug-a>` + `<slug-b>` into `<slug>` — two issues are actually one problem
- **Promote** `<slug>` from draft to open — clear enough to build
- **Close** `<slug>` — resolved or no longer relevant
- **No issue** — nothing to file

Multiple actions in one harvest is normal.

Do NOT write anything yet. Get explicit approval on the action list first.

## Phase 4: WRITE

Execute the approved actions. Edit existing files or create new ones. Let the content find its natural shape — narrative, bullets, decision log, spec fragment, whatever makes the signal clearest.

Follow the issue conventions defined in global CLAUDE.md (location, header format, statuses, types).
