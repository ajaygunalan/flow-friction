# Flow-Friction

> Flow fast. Friction for what survives.

Claude Code skills for solo research workflows. One researcher, one codebase, one agent.

---

## Two pipelines

### Research → Specs → Plan Mode (multi-session)

For new research directions with stacked unknowns:

```
/brain-dump    →  docs/research/what-to-build.md    (numbered questions, exit criteria)
/plan-build    →  docs/research/how-to-build.md     (layered pyramid, deliverables)
/plan-tests    →  docs/research/how-to-test.md      (pass/fail, failure modes)
/write-specs   →  docs/specs/spec-*.md               (one per plan mode session)
```

Each spec feeds a fresh Claude Code session in plan mode. Plan mode reads the spec + codebase, proposes steps, gets approval, executes.

`/review-trim` trims any doc or spec at any point — research docs, all specs, or a single file.

### Ad-hoc (single session)

For tasks where you already know what to build:

```
Write a plan in docs/plan/  →  /verify-plan  →  /implement
```

---

```
RESEARCH      /brainstorm  /investigate  /conversation-search  /swarm-agents
PLANNING      /brain-dump  /plan-build  /plan-tests  /write-specs  /review-trim
BUILD         /verify-plan  /implement  /ralph
WORKTREE      /create-worktrees  /merge
REVIEW        /roborev:fix
ANALYZE       roborev analyze <type>
VISUALIZE     /walkthrough  /d2-diagram
CHECKPOINT    /checkpoint
DISTILL       /index-sync  /index-codebase  /learn  /next-prompt
```

Research files are ephemeral — they exist to be absorbed, not maintained. `/index-sync` compresses them into D2 diagrams, then deletes the source files. `/index-codebase` builds the full documentation index from scratch.

**The code is the book. Diagrams are the primary index.**

### What do I type?

```
"I know the fix"              →  Just ask Claude
"Something's wrong, not sure" →  /investigate
"New feature, need to think"  →  /brainstorm
"Continuing from last session"→  /brainstorm or /investigate (follow /next-prompt)
"New research direction"      →  /brain-dump → /plan-build → /plan-tests → /write-specs
"Specs need trimming"         →  /review-trim docs/specs/
"Ready to build a spec"       →  Open plan mode, paste the spec
"I know what to build"        →  /verify-plan → /implement
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
| `docs/research/*.md` | Ephemeral research docs (absorbed by `/index-sync`) |
| `docs/specs/spec-*.md` | Spec files — one per plan mode session |
| `docs/plan/*.md` | Ephemeral plans for ad-hoc pipeline |
| `docs/diagrams/*.md` | Permanent D2 diagrams |
| `walkthrough-*.md` | D2 walkthroughs |
| `CLAUDE.md` | Agent routing table |

---

Stateless. No ceremony. No tracking files.
Built for solo researchers in robotics, ML, scientific computing.

[MIT](https://opensource.org/licenses/MIT)
