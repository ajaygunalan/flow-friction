# Flow-Friction

> Flow fast. Friction for what survives.

Coding agents are extraordinary when the problem looks like problems they've seen before. But some work lives outside that distribution — you're building something genuinely new, where the first step is figuring out what the first step is. The agent doesn't know the answer any more than you do. You figure it out together.

Flow-friction is scaffolding for that collaboration. A set of Claude Code skills that save you from re-explaining the same patterns every session — how to think together, when to challenge vs. explore, how to structure what you've learned, when to go build. Each skill is a reusable collaboration mode that adapts to where you are in the work, so your energy goes into the problem, not into steering the agent.

## The skills

**Think together**

- `/brainstorm` — Adaptive thinking partner. Matches your energy: explores when you're uncertain, challenges when you're confident, offers options when you're stuck. Produces a research document when the picture is clear — not before.
- `/review` — Reads your docs, briefs you, then asks what you want. Teach me? Trim this? Is this good? Follows your lead.

**Go dig alone**

- `/investigate` — Autonomous. Spawns subagents, traces code, searches the web, comes back with answers. No check-ins, no permission gates. You fire it and it reports back.

**Structure when you're ready**

- `/plan-build` — Takes your brainstorm output and layers it into a build pyramid. Dependencies, risks, ordering.
- `/plan-tests` — Decomposes each piece into smallest testable items. Pass/fail criteria, failure modes.
- `/write-specs` — One self-contained spec file per piece. Each spec is the input to a fresh plan mode session.
- `/verify-plan` — Reads a plan against your original request. Catches drift.

**Build**

- `/implement` — Reads the plan, spawns subagents, each commits atomically. Orchestration, not hand-holding.

**Keep moving across sessions**

- `/checkpoint` — Your save point. Milestones you name and remember, amid dozens of agent commits you don't.
- `/next-prompt` — Distills the current session into a ready-to-paste prompt for the next one. Picks up where you left off.
- `/conversation-search` — Searches past sessions. What did we try? What broke? What did we decide?

**Maintain the codebase knowledge**

- `/index-sync` — Compresses docs into D2 diagrams. Code is the book, diagrams are the index.
- `/index-codebase` — Builds the full documentation index from scratch for a new codebase.
- `/walkthrough` — Generates a D2 diagram explaining a flow or architecture. Visual mental model in under 2 minutes.

**Worktree workflow**

- `/create-worktrees` — Sets up parallel worktree slots for a repo.
- `/merge` — Squash-merges a worktree branch back into main.

**External review**

- `/roborev:review` — Triggers a code review via roborev. Supports `--branch`, `--type design|security`.
- `/roborev:fix` — Batch-fixes all unaddressed review findings.

**Automation**

- `/ralph` — Converts a PRD into Ralph's JSON format for autonomous execution.

## How it actually gets used

There's no prescribed order. You enter wherever you are:

- You don't know what to build yet → `/brainstorm`
- You know something's broken but not what → `/investigate`
- You have a vision and need to structure it → `/brainstorm` then `/plan-build` → `/plan-tests` → `/write-specs`
- You know exactly what to do → Just ask Claude
- You wrote a plan and want a sanity check → `/verify-plan`
- Your docs are bloated → `/review`
- Something works and you want to mark it → `/checkpoint`
- Session ending → `/next-prompt`
- New session → Paste the prompt from `/next-prompt`

The full pipeline exists for when you're facing a big build with stacked unknowns. Most days you grab one or two skills and go.

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

For continuous code review: [`roborev init`](https://github.com/roborev-dev/roborev)

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
