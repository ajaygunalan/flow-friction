---
name: breakdown-issues
description: Break down research artifacts into session-sized issue files — one issue per Claude Code session
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Breakdown Issues

## On entry

Read whatever exists in `docs/research/`:
- `brainstorm.md` → problem descriptions (feeds "What are we solving?" + "What do you need to know?")
- `how-to-build.md` → build pieces (feeds "What are we building?" + "What do you need to know?")
- `how-to-test.md` → verification checks (feeds "How do we verify?")

If none exist, tell the user and stop. At minimum one research doc should exist — otherwise there's nothing to break down.

Print a brief summary of what you read.

## Output

`docs/issues/` — one issue file per session-sized unit of work. Each issue is the input to a fresh Claude Code session in plan mode.

## How to break down

1. Create `docs/issues/` directory
2. Map build pieces to issues. Each piece from how-to-build is typically one issue. Merge small pieces that share a pattern — each issue should be worth a full plan mode session. Split large pieces if they'd take more than one session.
3. Write issue files named `{id}-{slug}.md` (lowercase kebab-case, e.g., `01-session-state-layer.md`)
4. Use this template:

```markdown
---
status: open
label: feature
---

## What are we solving?

{From brainstorm — the problem this issue addresses. Reference the brainstorm problem by name. Why it matters, what's the gap.}

## What are we building?

{From how-to-build — the concrete deliverable. Include constraints the codebase won't tell you. Mention dependencies on other issues if any.}

## How do we verify?

{From how-to-test — copy the checkboxes directly.}
- [ ] {condition}
- [ ] {condition}

## What do you need to know?

{Aggregated from all three docs — risks, decisions made, what's known, what's still uncertain, watch-outs, dead ends. Only what's relevant to THIS issue.}
```

For `label`, choose: `feature` | `bug` | `chore` | `research` — infer from context.

## Sizing pass

Review the full set:
- Each issue should be completable in one Claude Code plan-mode session.
- If a piece is too small to justify a session, merge it with a related piece.
- If a piece is too large, split it and note dependencies between the resulting issues.
- Non-code work (documentation, research) gets issues too — use `label: chore` or `label: research`.

For every sentence in an issue, ask: would plan mode figure this out from the codebase? If yes, cut it. Keep issues lean.

## Commit

```
git add docs/issues/ && git commit -m "breakdown-issues: session-sized issues from research docs"
```

## Next

"Pick an issue and start a new session in plan mode. Start from issue 01."
