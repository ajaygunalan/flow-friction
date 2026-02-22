# Flow-Friction

> Flow fast. Friction for what survives.

Coding agents are extraordinary when the problem looks like problems they've seen before. But some work lives outside that distribution — you're building something genuinely new, where the first step is figuring out what the first step is. The agent doesn't know the answer any more than you do. You figure it out together.

That "together" is the hard part. Without guidance, the agent charges ahead when you need it to think with you. It asks permission when you need it to just go dig. It dumps a wall of text when you needed a conversation. Every session, you re-explain how you want to collaborate.

Flow-friction encodes those collaboration patterns as reusable Claude Code skills — so your energy goes into the problem, not into steering the agent. The *flow* is the speed of working with an agent that already knows how to match your rhythm. The *friction* is the deliberate pushback at decision points — challenging your assumptions, forcing you to name what "done" looks like, catching drift before you've built the wrong thing.

## What it feels like

You type `/brainstorm` and describe what you're trying to build. The agent doesn't immediately propose a solution. It reads what you have, asks what you actually need, and starts a conversation:

```
> /brainstorm force-sensing calibration pipeline

I read your sensor code. You have raw wrench data coming in but
no transform to the tool frame. Before we scope this — is the
goal end-to-end calibration, or are you validating the sensor
model first?

> sensor model first. calibration is phase 2.

Got it. So the question is whether the current model is accurate
enough to build on. What's your ground truth — do you have
reference data, or are we establishing that too?

> we have reference data from last week but haven't compared yet

That comparison is the first thing to resolve. If the model is
off, everything downstream changes. What error margin would make
you confident enough to move to phase 2?
```

It pushes back. It reads the room. When you're uncertain, it explores with you. When you're confident, it plays devil's advocate. It doesn't rush to a document — it *dances* with you until the picture is clear. Then it crystallizes the conversation into numbered research questions with exit criteria, and you move on.

That's one skill. Each one has this kind of judgment built in.

## Where you are → what you type

There's no prescribed order. You enter wherever you are:

- **Don't know what to build yet** → `/brainstorm` — thinks with you, crystallizes when ready
- **Something's broken, not sure what** → `/investigate` — goes away, spawns subagents, comes back with answers
- **Vision needs structure** → `/brainstorm` → `/plan-build` → `/plan-tests` → `/write-specs`
- **Know exactly what to do** → Just ask Claude
- **Plan needs a sanity check** → `/verify-plan`
- **Docs need a fresh eye** → `/review` — reads silently, briefs you, follows your lead
- **Something works, mark it** → `/checkpoint` — your save point amid dozens of agent commits
- **Session ending** → `/next-prompt` — ready-to-paste prompt for the next session
- **New session** → Paste the prompt from `/next-prompt`

Most days you grab one or two skills and go. The full pipeline is there when you're facing a big build with stacked unknowns.

## Core skills

**`/brainstorm`** — Adaptive thinking partner. Matches your energy: explores when you're uncertain, challenges when you're confident, offers options when you're stuck. Produces a research document when the picture is clear — not before.

**`/investigate`** — Autonomous. Spawns subagents, traces code, searches the web. No check-ins, no permission gates. Maintains a scratchpad of hypotheses — confirmed, ruled out, still open. Picks up where it left off across sessions.

**`/plan-build`** → **`/plan-tests`** → **`/write-specs`** — The structuring pipeline. Takes your brainstorm output and turns it into a layered build pyramid, then testable pieces, then self-contained spec files. Each spec feeds a fresh plan mode session.

**`/checkpoint`** — Your save point. Agents make dozens of atomic commits you can't remember. Checkpoints are milestones *you* name. `git log --grep="checkpoint:"` gives you the project's narrative arc.

**`/next-prompt`** — Session continuity. Distills what happened into a prompt for the next session — what to do, what's been decided, where to start, which skill to invoke.

<details>
<summary><strong>All skills</strong></summary>

| Skill | What it does |
|-------|-------------|
| `/brainstorm` | Think together — adaptive partner that crystallizes research questions |
| `/investigate` | Autonomous investigation — subagents dig, come back with answers |
| `/plan-build` | Layer pieces into a build pyramid with dependencies and risks |
| `/plan-tests` | Decompose pieces into smallest testable items with pass/fail |
| `/write-specs` | One self-contained spec file per piece for plan mode |
| `/verify-plan` | Read plan against original request, catch drift |
| `/implement` | Orchestrate subagents to build the plan, each commits atomically |
| `/review` | Read docs, brief you, then follow your lead — teach, trim, or validate |
| `/checkpoint` | Mark a human-verified milestone with a named commit |
| `/next-prompt` | Distill session into a ready-to-paste prompt for the next one |
| `/conversation-search` | Search past sessions for decisions, findings, dead ends |
| `/index-sync` | Compress docs into D2 diagrams — code is the book, diagrams are the index |
| `/index-codebase` | Build full documentation index from scratch |
| `/walkthrough` | Generate a D2 diagram explaining a flow or architecture |
| `/create-worktrees` | Set up parallel worktree slots |
| `/merge` | Squash-merge a worktree branch back into main |
| `/roborev:review` | Trigger a code review (supports `--branch`, `--type`) |
| `/roborev:fix` | Batch-fix all unaddressed review findings |
| `/ralph` | Convert a PRD to Ralph's JSON format for autonomous execution |

</details>

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
