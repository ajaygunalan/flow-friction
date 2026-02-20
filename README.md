# Flow-Friction

> Flow fast. Friction for what survives.

Claude Code skills for solo research workflows. One researcher, one codebase, one agent.

---

```
RESEARCH      /brainstorm  /investigate  /conversation-search  /swarm-agents
PLAN          /plan  /verify-plan
BUILD         /implement  /ralph
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
"I know what to build"        →  /plan → /verify-plan → /implement
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
| `docs/research/*.md` | Ephemeral findings (absorbed by `/index-sync`) |
| `docs/plan/*.md` | Ephemeral plans (deleted after build) |
| `docs/diagrams/*.md` | Permanent D2 diagrams |
| `walkthrough-*.md` | D2 walkthroughs |
| `CLAUDE.md` | Agent routing table |

---

Stateless. No ceremony. No tracking files.
Built for solo researchers in robotics, ML, scientific computing.

[MIT](https://opensource.org/licenses/MIT)
