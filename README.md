# Flow-Friction

> Flow fast. Friction for what survives.

Claude Code skills for solo research workflows. One researcher, one codebase, one agent.

---

## How it works

Skills compose flexibly. Use the full pipeline when there's a lot to build, or pick individual skills when you already know what you need.

### The full pipeline (for big builds with stacked unknowns)

```
/brainstorm    →  docs/research/what-to-build.md    (numbered questions, exit criteria)
/plan-build    →  docs/research/how-to-build.md     (layered pyramid, deliverables)
/plan-tests    →  docs/research/how-to-test.md      (pass/fail, failure modes)
/review   →  brief, teach, surface issues, trim through dialogue
/write-specs   →  docs/specs/spec-*.md               (one per plan mode session)
```

Each spec feeds a fresh Claude Code session in plan mode. Plan mode reads the spec + codebase, proposes steps, gets approval, executes. `/verify-plan` and `/implement` are available downstream.

### Partial use (most of the time)

Not every task needs the full pipeline. Common shorter paths:

- **Know what to build?** → Write a plan in `docs/plan/` → `/verify-plan` → `/implement`
- **Need to think first?** → `/brainstorm` to clarify, then plan mode directly
- **Small feature?** → Just ask Claude
- **Review docs?** → `/review docs/specs/` or `/review <any path>`

`/review` works at any point — on research docs, specs, or any file. Brief, teach, trim, or just validate.

---

```
RESEARCH      /brainstorm  /investigate  /conversation-search  /swarm-agents
PLANNING      /plan-build  /plan-tests  /write-specs  /review
BUILD         /verify-plan  /implement  /ralph
WORKTREE      /create-worktrees  /merge
REVIEW        /roborev:fix
ANALYZE       roborev analyze <type>
VISUALIZE     /walkthrough  /d2-diagram
CHECKPOINT    /checkpoint
DISTILL       /index-sync  /index-codebase  /learn  /next-prompt
```

`/index-sync` compresses docs into D2 diagrams. `/index-codebase` builds the full documentation index from scratch.

**The code is the book. Diagrams are the primary index.**

### What do I type?

```
"I know the fix"              →  Just ask Claude
"Something's wrong, not sure" →  /investigate
"New feature, need to think"  →  /brainstorm
"Continuing from last session"→  /brainstorm or /investigate (follow /next-prompt)
"Big research direction"      →  /brainstorm → /plan-build → /plan-tests → /write-specs
"Know what to build"          →  plan mode → /verify-plan → /implement
"Review my docs"              →  /review docs/specs/
"Ready to build a spec"       →  Open plan mode, paste the spec
"Set up worktrees"            →  /create-worktrees
"Done with feature"           →  /merge <name>
"Review my code"              →  /roborev:review  (branch: /roborev:review-branch)
"Design review"               →  /roborev:design-review  (branch: -branch)
"Reviews found issues"        →  /roborev:fix
"Code smells accumulating"    →  roborev analyze <type>
"Need multiple perspectives"  →  /swarm-agents
"Have a PRD to automate"     →  /ralph
"Capture what we learned"    →  /learn
"Explain how this works"      →  /walkthrough
"Create a diagram"            →  /d2-diagram
"New codebase, no docs"       →  /index-codebase
"Session ending"              →  /index-sync → /next-prompt
```

### Setup

Commands work immediately. For continuous code review: [`roborev init`](https://github.com/roborev-dev/roborev)

Recommended `~/.claude/settings.json`:

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

`ENABLE_TOOL_SEARCH` — MCP tool discovery for `/investigate`. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` — multi-agent coordination for `/investigate` and `/implement`.

Persistent tasks across sessions:

```bash
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

### File layout

| Path | Purpose |
|------|---------|
| `docs/research/*.md` | Research docs |
| `docs/specs/spec-*.md` | Spec files — one per plan mode session |
| `docs/plan/*.md` | Ephemeral plans for ad-hoc pipeline |
| `docs/diagrams/*.md` | Permanent D2 diagrams |
| `walkthrough-*.md` | D2 walkthroughs |
| `CLAUDE.md` | Agent routing table |

---

Stateless. No ceremony. No tracking files.
Built for solo researchers in robotics, ML, scientific computing.

[MIT](https://opensource.org/licenses/MIT)
