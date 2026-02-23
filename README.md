# Flow-Friction

> Flow fast. Friction for what survives.

[![Flow Friction](assets/flow_frcition.png)](https://github.com/ajaygunalan/flow-friction/releases/download/v0.1.0/Flow_Friction_Collaborative_AI_Development.mp4)

Coding agents are extraordinary when the problem resembles problems they've seen before. But some work lives outside that distribution — where the first step is figuring out what the first step is. The agent doesn't know the answer any more than you do. You figure it out together.

Flow-Friction is scaffolding for that collaboration. A set of Claude Code skills that save you from re-explaining the same patterns every session: how to think together, when to challenge versus explore, how to structure what you've learned, when to stop talking and go build. Each skill is a reusable collaboration mode that adapts to where you are in the work, so your energy goes into the problem — not into re-explaining how to work together.
 
The flow is the speed of working with an agent that already knows your rhythm. The friction is deliberate pushback at decision points: challenging your assumptions, forcing you to name what done looks like, catching drift before you've built the wrong thing.

<details>
<summary><strong>How this differs from other frameworks</strong></summary>

Meta-prompting frameworks for coding agents already exist, and some are good.

[BMAD](https://github.com/bmad-code-org/BMAD-METHOD) adapts traditional agile for the agent era — roles, sprints, storyboards. Too many phases, and each phase took too long. Even the brainstorming felt exhausting — the prompts and skills were so rigid that the agent was constrained rather than liberated. Hard to steer, hard to make agile. And it kept pulling toward web and app development patterns. For domains like robotics, machine learning, game development, graphics — where the work is math-heavy, algorithmic, and the constraints are fundamentally different — it just didn't gel.

[GSD](https://github.com/gsd-build/get-shit-done) is the closest in spirit — I drew inspiration from it. It separates discuss, plan, execute, and verify into distinct steps per phase, which is smart. But GSD front-loads the full roadmap in one session: questions, research, requirements, all phases scoped upfront. Its own tagline says it — *"if you know clearly what you want, this WILL build it for you."* When you don't know yet, that upfront scoping is where things go wrong. Flow-Friction keeps brainstorming, build planning, and test planning as separate sessions so understanding can shift between them in a nonlinear way. GSD also has no step to review and trim planning docs — `/gsd:verify-work` checks if code works, not if your specs are bloated. Flow-Friction has `/review` specifically to catch bloat before you build.

[Gastown](https://github.com/steveyegge/gastown) goes the other direction — orchestrating 20-30 agents in parallel with persistent state via git hooks. Impressive infrastructure, but it's solving coordination, not alignment. Agents are context-sensitive — one small misalignment at a foundational level propagates through everything built on top of it. With 20-30 parallel agents, if one drifts, the drift multiplies across codepaths. You end up untangling spaghetti instead of shipping. Personally, I work with two-three agents per project, maybe two projects at a time — four to six agents total. Beyond that, context-switching degrades, and the coordination overhead outweighs the parallelism.

[Spec-Kit](https://github.com/github/spec-kit) has good ideas but the command names never clicked — `speckit.constitution`, `speckit.specify` — too esoteric to reach for instinctively. [Ralph](https://github.com/snarktank/ralph) loops the agent until the spec is done, but assumes the spec is right before the first loop starts.

What these frameworks share is an assumption: you know what you're building. When you do, they work. But when you're on the cutting edge — building something that has never existed, or putting your own spin on something that has — you can't write the perfect spec at the start. You find out what to build by building. And a wrong assumption in your spec or your CLAUDE.md doesn't stay small. The agent builds on it, generates more context from it, and the drift compounds every turn. The heavier the upfront ceremony, the faster it spreads.

Flow-Friction doesn't organize work. It organizes understanding.

Other frameworks hand the agent tasks, milestones, roles — units of work to execute. Flow-Friction hands it questions. A brainstorm produces research questions, not a spec. An investigation produces hypotheses — not deliverables. A plan surfaces dependencies and risks, not sprint items. The code comes last, after the understanding is there. And when the understanding changes — and it will — you throw away the code and rebuild from what you now know.

Code is cheap. It's just tokens. Understanding is what's expensive, and you can't spec it upfront. Staying small — small assumptions, small builds, small specs — means when you're wrong, the cost stays small too.

</details>

<details>
<summary><strong>How to use these skills</strong></summary>

These skills are shoes. Good shoes help you play football, but shoes don't score goals. The player's rhythm determines the shoe, never the other way around.

Your rhythm is something you find by playing. There's no book for it. Every project is different, every domain is different, every person thinks differently. You use the agent on real problems, you notice where it drifts, you learn when to trust it and when to steer — and over time, patterns start to surface. Those are your skills. Not these.

These might help you get there. Read them, pull them apart, let them shape how you think about your own patterns. But running someone else's skills on your problems won't get you far — the same way wearing another player's shoes won't teach you their game. What matters is the play. The energy. Knowing when you need grip and when you need speed. That comes from being on the field, not from the gear.

What worked for me wasn't downloading other people's setups. It was studying their workflows, understanding the choices behind them, then rebuilding from scratch to fit my own taste. You have to feel the skill, not just run it.

</details>

## The skills

There's no prescribed order. You enter wherever you are. Most days you grab one or two skills and go.

**Think together**

- `/brainstorm` — Adaptive thinking partner. Dances with you until the picture is clear — explores when you're uncertain, challenges when you're confident, offers options when you're stuck. Crystallizes research questions when ready, not before.
- `/review` — Reads your docs silently, forms a picture, then asks what you want. Teach me? Trim this? Is this good? Follows your lead.

**Go dig alone**

- `/investigate` — Autonomous. Spawns subagents, traces code, searches the web, comes back with answers. No check-ins, no permission gates. You fire it and it reports back.

**Structure when you're ready**

- `/how-to-build` — Takes your brainstorm output and layers it into a build pyramid. Dependencies, risks, ordering — surfaced through dialogue before you commit to a direction.
- `/how-to-test` — Decomposes each piece into smallest testable items. Pass/fail criteria, failure modes.
- `/write-specs` — One self-contained spec file per piece. Each spec is the input to a fresh plan mode session.
- `/verify-plan` — Reads a plan against your original request. Catches drift.

**Build**

- `/implement` — Reads the plan, spawns subagents, each commits atomically. Orchestration, not hand-holding.

**Keep moving across sessions**

- `/checkpoint` — Your save point. Agents make dozens of atomic commits you can't remember. Checkpoints are milestones *you* name — the project's narrative arc.
- `/next-prompt` — Distills the current session into a ready-to-paste prompt for the next one. Picks up where you left off.
- `/conversation-search` — Searches past sessions. What did we try? What broke? What did we decide?

**Maintain the codebase knowledge**

- `/index-sync` — Compresses docs into D2 diagrams. Code is the book, diagrams are the index.
- `/index-codebase` — Builds the full documentation index from scratch for a new codebase.
- `/walkthrough` — Generates a D2 diagram explaining a flow or architecture. Visual mental model in under 2 minutes.

**Worktree workflow**

- `/create-worktrees` — Sets up parallel worktree slots for a repo.
- `/merge` — Squash-merges a worktree branch back into main.

<details>
<summary><strong>Setup</strong></summary>

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

</details>

<details>
<summary><strong>File layout</strong></summary>

| Path | Purpose |
|------|---------|
| `docs/research/*.md` | Working research docs — brainstorm output, investigation scratchpads |
| `docs/specs/spec-*.md` | Spec files — one per plan mode session |
| `docs/plan/*.md` | Plans for `/verify-plan` and `/implement` |
| `docs/diagrams/*.md` | D2 diagrams — the persistent index |

</details>

---

Built for people who build what hasn't been built yet.

[MIT](https://opensource.org/licenses/MIT)
