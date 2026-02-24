# Agent Teams Patterns

Reference for brainstorm, investigate, and roborev-review skills.
Use when Claude Code's experimental agent teams feature stabilizes
(currently behind `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS`).

## When to use teams vs subagents vs solo

| Signal | Use |
|--------|-----|
| Single thread to pull, clear next step | Solo session |
| Focused helper that reports back, no discussion needed | Subagent (`Task` tool) |
| Multiple perspectives must challenge each other | Agent team |
| Parallel work on independent files/modules | Agent team |

Rules of thumb (from official docs):
- 3-5 teammates per team
- 5-6 tasks per teammate
- Each teammate owns distinct files — two teammates editing the same file causes overwrites

## Patterns

### 1. Debate (for brainstorm)

Stress-test a milestone draft through adversarial evaluation.

**Setup**:
1. Define evaluation lenses with the user (e.g., feasibility, user impact, technical debt)
2. Get user approval on lenses before spawning — missing a lens wastes the entire run
3. Write the milestone draft to a shared file

**Team structure**:
- Lead creates the team and writes the draft
- One teammate per evaluation lens
- Each teammate critiques from their lens, writes findings to a shared file
- Teammates challenge each other's findings via direct messages
- Lead synthesizes into the final issue set

**Convergence**: Stop when no teammate raises issues above severity threshold, or max rounds hit (cap at 5-8).

**Integration point**: `/brainstorm` detects when the user says "debate this" / "challenge this", or when the topic is contentious. Falls back to solo brainstorm otherwise. Output format (milestone with issues) stays the same.

### 2. Competing hypotheses (for investigate)

Test multiple theories in parallel with adversarial scrutiny.

**Setup**:
1. Identify 3-5 plausible hypotheses
2. Create a shared findings file

**Team structure**:
- Lead spawns one teammate per hypothesis
- Each investigates independently, writes findings to shared file
- Teammates then challenge each other's conclusions via messages
- The theory that survives adversarial scrutiny is the answer

**Why this beats sequential investigation**: A single agent anchors on the first plausible explanation. Multiple investigators actively trying to disprove each other avoid this bias.

**Integration point**: `/investigate` branches when the user provides multiple possible causes or says "not sure what's wrong" / "investigate all angles". Falls back to subagent investigation otherwise. Findings report format stays the same.

### 3. Multi-lens review (for roborev-review)

Parallel review with distinct, non-overlapping concerns.

**Setup**:
1. Define review lenses (e.g., security, performance, test coverage, correctness)
2. Each reviewer gets the same diff but a different filter

**Team structure**:
- Lead spawns one teammate per lens
- Each reviews independently, writes findings to shared file
- Lead synthesizes a unified review

**Integration point**: `/roborev-review` uses team mode when the diff is large or the user asks for thorough review. Falls back to solo review otherwise. Review output format stays the same.

## Setup checklist (all patterns)

Before spawning any teammates:

1. **Define lenses/dimensions** — name each one. The user knows their domain; you don't.
2. **Get user approval on lenses** — use `AskUserQuestion`. Missing a lens wastes the run.
3. **Create shared state file** — write the artifact (draft, findings, diff) to a file all teammates can read. Never pass full documents in messages — pass file paths.
4. **Create tasks with dependencies** — use `TaskCreate` + `TaskUpdate(addBlockedBy)` to enforce ordering between rounds.

## Native tools to use

| Tool | Purpose |
|------|---------|
| `TeamCreate` | Create the team |
| `SendMessage` (type: message) | Direct message to one teammate |
| `SendMessage` (type: broadcast) | Message all teammates (use sparingly) |
| `TaskCreate` / `TaskUpdate` | Shared task list with dependencies |
| `TeamDelete` | Clean up when done — lead only |

## Best practices

- **File ownership**: each teammate owns distinct files. Never assign two teammates to the same file.
- **Shared files for state**: messages can be missed, files can't. Write findings to files, send paths in messages.
- **Short messages**: say "critique written to /path/findings.md" not the full critique text.
- **Monitor and steer**: check in on progress, redirect approaches that aren't working. Don't let a team run unattended.
- **Plan approval for risky work**: spawn teammates with plan approval required. The lead reviews and approves/rejects before they implement.
- **Start with research/review**: if the team hasn't worked together on this kind of task before, start with non-coding tasks to validate the pattern.

## Anti-patterns

| Don't | Do instead |
|-------|-----------|
| Create a standalone `/agent-teams` skill | Add team mode as an option to existing skills |
| Spawn teams for sequential work | Use solo session or subagents |
| Let teammates self-define their lens | Get user approval on lenses upfront |
| Pass full documents in messages | Write to shared file, send file path |
| Run without a round/time cap | Set max rounds (5-8 for debates) |
| Spawn more than 5 teammates | Start with 3, scale up only if needed |
| Assign two teammates to the same file | Each teammate owns distinct files |
