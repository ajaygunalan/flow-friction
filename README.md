# Flow-Friction

> Flow fast. Friction for what survives.

Coding agents are extraordinary when the problem resembles problems they've seen before. But some work lives outside that distribution — where the first step is figuring out what the first step is. The agent doesn't know the answer any more than you do. You figure it out together.

Flow-Friction is scaffolding for that collaboration. A set of Claude Code skills that save you from re-explaining the same patterns every session: how to think together, when to challenge versus explore, how to structure what you've learned, when to stop talking and go build. Each skill is a reusable collaboration mode that adapts to where you are in the work, so your energy goes into the problem — not into steering the agent.
 
The flow is the speed of working with an agent that already knows your rhythm. The friction is deliberate pushback at decision points: challenging your assumptions, forcing you to name what done looks like, catching drift before you've built the wrong thing.

<details>
<summary><strong>How to use these skills</strong></summary>

These are not magic wands. You don't wave a skill and get pristine working software in one go. The skills are shoes — good shoes help you play football, but shoes don't score goals. The player's rhythm determines the shoe, never the other way around.

Your rhythm is something you find by playing. There's no book for it, no holy source of truth. Every project is different, every domain is different, every person thinks differently. You use the agent on real problems, you notice where it drifts, you learn when to trust it and when to steer — and over time, repeating workflows start to surface. Those are your skills. Not these.

These skills might help you get there. Read them, pull them apart, let them shape how you think about your own patterns. But just running someone else's skills on your problems won't get you far — the same way wearing another player's shoes won't teach you their game. What matters is the play. The energy. The knowledge of when you need grip and when you need speed. That comes from being on the field, not from the gear.

What worked for me wasn't downloading other people's setups. It was studying their workflows, understanding the choices behind them, then rebuilding from scratch to fit my own taste. You have to feel the skill, not just run it.

</details>

## The skills

There's no prescribed order. You enter wherever you are. Most days you grab one or two skills and go.

## Think together

- `/brainstorm` — Adaptive thinking partner. Dances with you until the picture is clear — explores when you're uncertain, challenges when you're confident, offers options when you're stuck. Crystallizes research questions when ready, not before.
- `/review` — Reads your docs silently, forms a picture, then asks what you want. Teach me? Trim this? Is this good? Follows your lead.

## Go dig alone

- `/investigate` — Autonomous. Spawns subagents, traces code, searches the web, comes back with answers. No check-ins, no permission gates. You fire it and it reports back.

## Structure when you're ready

- `/plan-build` — Takes your brainstorm output and layers it into a build pyramid. Dependencies, risks, ordering — surfaced through dialogue before you commit to a direction.
- `/plan-tests` — Decomposes each piece into smallest testable items. Pass/fail criteria, failure modes.
- `/write-specs` — One self-contained spec file per piece. Each spec is the input to a fresh plan mode session.
- `/verify-plan` — Reads a plan against your original request. Catches drift.

## Build

- `/implement` — Reads the plan, spawns subagents, each commits atomically. Orchestration, not hand-holding.

## Keep moving across sessions

- `/checkpoint` — Your save point. Agents make dozens of atomic commits you can't remember. Checkpoints are milestones *you* name — the project's narrative arc.
- `/next-prompt` — Distills the current session into a ready-to-paste prompt for the next one. Picks up where you left off.
- `/conversation-search` — Searches past sessions. What did we try? What broke? What did we decide?

## Maintain the codebase knowledge

- `/index-sync` — Compresses docs into D2 diagrams. Code is the book, diagrams are the index.
- `/index-codebase` — Builds the full documentation index from scratch for a new codebase.
- `/walkthrough` — Generates a D2 diagram explaining a flow or architecture. Visual mental model in under 2 minutes.

## Worktree workflow

- `/create-worktrees` — Sets up parallel worktree slots for a repo.
- `/merge` — Squash-merges a worktree branch back into main.

## Setup

Skills work immediately. Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "true",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": { "defaultMode": "bypassPermissions" },
  "alwaysThinkingEnabled": true,
  "plansDirectory": "docs/plan/"
}
```

Persistent tasks across sessions:

```bash
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

## File layout

| Path | Purpose |
|------|---------|
| `docs/research/*.md` | Working research docs — brainstorm output, investigation scratchpads |
| `docs/specs/spec-*.md` | Spec files — one per plan mode session |
| `docs/plan/*.md` | Plans for `/verify-plan` and `/implement` |
| `docs/diagrams/*.md` | D2 diagrams — the persistent index |

---

Built for people who build what hasn't been built yet.

[MIT](https://opensource.org/licenses/MIT)
