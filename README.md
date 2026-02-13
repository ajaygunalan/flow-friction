# Flow-Friction

> Flow fast. Friction for what survives.

A set of Claude Code skills for solo research workflows — context management, iteration, knowledge capture.

---

```
INVESTIGATE ─► PLAN ─► BUILD ─► REVIEW ─► ANALYZE ─► CHECKPOINT ─► DISTILL

INVESTIGATE    /research, /best-practices, /conversation-search
PLAN           /plan, /verify-plan, /roborev:design-review
BUILD          /implement
REVIEW         /roborev:fix, /roborev:address, roborev refine, /roborev:respond
ANALYZE        roborev analyze <type>
CHECKPOINT     /checkpoint
DISTILL        /learn, /index-sync, /next-prompt
```

### Investigate

Understand before acting. `/research` investigates unknowns — read code, run tests, trace bugs, write findings to `docs/research/`. Call it again and it continues where it left off. `/best-practices` checks your approach against expert-level patterns. `/conversation-search` finds what you've already learned across past sessions.

### Plan

Structure only what survived investigation. `/plan` (built-in) drafts the implementation plan. `/verify-plan` asks you questions first, then audits every requirement and patches what's missing. `/roborev:design-review` sends the plan to a different model for completeness, feasibility, and task scoping validation — before you build.

### Build

One subagent per task. `/implement` delegates plan tasks to parallel subagents — each agent commits atomically after completing its task. RoboRev auto-reviews every commit in the background.

### Review

Address what the reviewer found. `/roborev:fix` discovers all unaddressed reviews and fixes them in one pass. `/roborev:address` addresses a single review. `/roborev:respond` comments on a review and marks it addressed without code changes.

| | `/roborev:fix` | `roborev refine` |
|---|---|---|
| Mode | Single pass | Automated loop |
| Scope | Fixes all unaddressed findings, one commit | Fixes → re-reviews → repeats until all pass |
| Where | In-place, you decide when to commit | Isolated worktree |

### Analyze

Targeted code analysis. `roborev analyze <type>` runs one of 7 analysis types:

`duplication` · `complexity` · `dead-code` · `refactor` · `architecture` · `test-fixtures` · `api-design`

Use `--branch` for branch-scoped analysis. Use `--fix` to auto-apply suggested changes.

### Checkpoint

Mark a milestone. `/checkpoint` summarizes all work since the last checkpoint, creates a marker commit, and optionally pushes. Run after code is reviewed and analyzed.

### Distill

Compress scattered knowledge into diagrams, delete the residue. `/learn` captures raw insights from the conversation into `docs/research/`. `/index-sync` distills them — absorbing findings into Mermaid diagrams, updating reference docs, reshaping diagram structure as the codebase evolves — then drains the ephemeral source files. `/next-prompt` generates a ready-to-paste prompt for the next session.

**The code is the book. Diagrams are the primary index.** Mermaid diagrams in `docs/diagrams/*.md` show how modules connect, how data flows, which functions transform what. Claude reads CLAUDE.md every session, follows wiki-links to diagrams, and already knows the architecture. No re-discovery. No context-stuffing.

---

## What You Know → Where to Start

```
"I know the fix"                →  Just ask Claude
"I know the cause"              →  Just ask Claude
"Something's wrong, not sure"   →  /research
"I need to understand first"    →  /research
"I know what to build"          →  /plan
"Plan needs design validation"  →  /roborev:design-review
"I have a plan already"         →  /verify-plan → /implement
"Reviews found issues"          →  /roborev:fix
"Want fully automated fixes"    →  roborev refine
"Code smells accumulating"      →  roborev analyze <type>
"Ready to checkpoint"           →  /checkpoint
"Indexes drifted"               →  /index-sync
"What did we learn recently?"   →  /conversation-search + /learn
"Starting next session"         →  /next-prompt
```

---

## Flows

Mix and match based on what you know.

**Quick Fix:** Ask Claude → Done

**Feature:** `/research` → `/plan` → `/verify-plan` → `/roborev:design-review` → `/implement` → `/roborev:fix` → `roborev analyze` → `/checkpoint`

**Session End:** `/learn` → `/index-sync` → `/next-prompt`

---

## How It's Different

**Stateless.** No tracking files, no "current phase." Run any command anytime. Skip what you don't need.

**No ceremony.** No mandatory progression. Research files are ephemeral — they get absorbed into their permanent home and deleted. The only persistent artifacts are the code and its indexes. One-time `roborev init` per repo enables continuous review and analysis.

**Built for solo researchers** in robotics, ML, scientific computing, data science, optimization, algorithm development. Not for teams needing sprint tracking or enterprises needing audit trails.

---

## Quick Start

Commands work immediately. Just use them.

**Recommended settings** — `~/.claude/settings.json`:

```json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "true",
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "defaultMode": "bypassPermissions"
  },
  "alwaysThinkingEnabled": true,
  "plansDirectory": "docs/plan/"
}
```

| Setting | Why |
|---------|-----|
| `ENABLE_TOOL_SEARCH` | Deferred tool loading — lets `/research` discover MCP tools on the fly |
| `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` | Multi-agent coordination — used by `/research` and `/implement` |
| `bypassPermissions` | Skip confirmation prompts (solo use only — don't enable on shared machines) |
| `alwaysThinkingEnabled` | Always-on extended thinking |
| `plansDirectory` | Store plans in `docs/plan/` instead of `~/.claude/plans/` |

**Per-repo setup** — initialize [RoboRev](https://github.com/roborev-dev/roborev) for continuous code review and analysis:

    roborev init

**Task persistence** — tasks survive `/clear` and new sessions:

```bash
# Add to ~/.bashrc or ~/.zshrc
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

---

## File Layout

| Path | Purpose |
|------|---------|
| `docs/research/*.md` | Per-topic research files (ephemeral — absorbed by `/index-sync`) |
| `docs/plan/*.md` | Plan files (ephemeral — deleted after implementation) |
| `docs/diagrams/*.md` | Mermaid architecture diagrams (permanent index) |
| `CLAUDE.md` | Agent routing table — commands, debug-by-symptom, diagram links |

---

## Commands

**Flow-Friction** — by phase:

| Command | Phase | Description |
|---------|-------|-------------|
| `/research` | Investigate | Investigate unknowns — read code, run tests, trace bugs, write findings |
| `/best-practices` | Investigate | Analyze current problem against expert-level best practices |
| `/conversation-search` | Investigate | Search past conversation history |
| `/plan` | Plan | Create implementation plan (built-in Claude Code) |
| `/verify-plan` | Plan | Ask user questions, then audit and patch the plan |
| `/implement` | Build | Execute plan via subagent delegation — agents commit atomically |
| `/checkpoint` | Checkpoint | Mark a milestone — summarize work, create marker commit, optionally push |
| `/learn` | Distill | Capture conversation insights into `docs/research/` |
| `/index-sync` | Distill | Distill knowledge into diagrams — absorb ephemeral files, reshape structure |
| `/next-prompt` | Distill | Generate a ready-to-paste prompt for the next session |

**[RoboRev](https://github.com/roborev-dev/roborev)** — by capability:

*Review:*

| Command | Description |
|---------|-------------|
| `/roborev:review` | Request a code review (also runs automatically via post-commit hook) |
| `/roborev:review-branch` | Review all commits on current branch |
| `/roborev:fix` | Fix all unaddressed findings in one pass |
| `/roborev:address` | Address a single review's findings |
| `/roborev:respond` | Comment on a review and mark addressed without code changes |
| `roborev refine` | Automated fix loop — fix, re-review, repeat until all pass |
| `roborev tui` | Interactive terminal UI — browse reviews, verdicts, findings |

*Design Review:*

| Command | Description |
|---------|-------------|
| `/roborev:design-review` | Design-focused review — completeness, feasibility, task scoping |
| `/roborev:design-review-branch` | Design review all commits on current branch |

*Analysis:*

| Command | Description |
|---------|-------------|
| `roborev analyze <type>` | `duplication` · `complexity` · `dead-code` · `refactor` · `architecture` · `test-fixtures` · `api-design`. Use `--branch` for branch-scoped, `--fix` to auto-apply. |

---

## License

[MIT](https://opensource.org/licenses/MIT)
