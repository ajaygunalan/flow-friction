# Flow-Friction

> Flow fast. Friction for what survives.

A set of Claude Code skills for solo research workflows — context management, iteration, knowledge capture.

Most AI coding frameworks ([BMAD](https://github.com/bmad-code-org/BMAD-METHOD), [GSD](https://github.com/glittercowboy/get-shit-done)) are bloated with spec documents and rigid linear patterns. That fails for research — you don't know what you're building until you've tried building it. And whatever you do learn gets lost between sessions — Claude starts fresh every time, re-discovering what it already mapped yesterday.

Flow-Friction inverts the order: investigate first, structure survivors. Mermaid diagrams act as a living visual index — synced to the code, read every session via CLAUDE.md wiki-links. Claude opens each session already knowing the architecture. No re-discovery. No context-stuffing.

---

```
INVESTIGATE ──────────► PLAN ───────────────► BUILD ──────────────► DISTILL
/research                /plan (built-in)      /implement            /learn
/best-practices          /verify-plan          /roborev:fix          /index-sync
/conversation-search                           /checkpoint           /next-prompt
```

### Investigate

Understand before acting. `/research` investigates unknowns — read code, run tests, trace bugs, write findings to `docs/research/`. Call it again and it continues where it left off (iteration 2, 3, ...). `/best-practices` names the problem class and checks your approach against expert-level patterns. `/conversation-search` finds what you've already learned across past sessions.

### Plan

Structure only what survived investigation. `/plan` (built-in Claude Code) drafts the implementation plan. `/verify-plan` asks you questions first, then audits every requirement and patches what's missing or partial.

### Build

One subagent per task. `/implement` delegates plan tasks to parallel subagents — each agent commits atomically after completing its task. RoboRev auto-reviews every commit in the background. `/roborev:fix` addresses review findings. `/checkpoint` marks a human-verified milestone — summarizes all work since the last checkpoint, creates a marker commit, and optionally pushes.

### Distill

Compress scattered knowledge into diagrams, delete the residue. `/learn` captures raw insights from the conversation into `docs/research/`. `/index-sync` distills them — absorbing findings into Mermaid diagrams, updating reference docs for overflow, reshaping diagram structure as the codebase evolves — then drains the ephemeral source files. `/next-prompt` generates a ready-to-paste prompt for the next session.

**The code is the book. Diagrams are the primary index.** Mermaid diagrams show how modules connect, how data flows, which functions transform what. Every session, Claude reads CLAUDE.md, follows wiki-links to `docs/diagrams/*.md`, and already knows the architecture. No re-discovery. No context-stuffing. Every fact has exactly one home. Research and plans are ephemeral — they get distilled into diagrams and deleted. What survives lives in the code and its visual index.

---

## What You Know → Where to Start

```
"I know the fix"              →  Just ask Claude
"I know the cause"            →  Just ask Claude
"Something's wrong, not sure" →  /research
"I need to understand first"  →  /research
"I know what to build"        →  /plan (built-in Claude Code)
"I have a plan already"       →  /verify-plan → /implement
"Reviews found issues"        →  /roborev:fix
"Ready to checkpoint"         →  /checkpoint
"Indexes drifted"             →  /index-sync
"What did we learn recently?" →  /conversation-search + /learn
```

---

## Flows

Mix and match based on what you know.

```
┌───────────────────────────────────────────────────────────────────┐
│  SIMPLE FIX (you know the fix)                                    │
│                                                                   │
│    Ask Claude ────────────────────────────────────────────► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  DEBUG (cause unknown)                                            │
│                                                                   │
│    /research ───► find cause ───► fix ───────────────────► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  NEW FEATURE (you know what to build)                             │
│                                                                   │
│    /plan ───► /verify-plan ───► /implement ───► review+fix loop  │
│                                                      │            │
│                                                      ▼            │
│                                                /checkpoint ► Done │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  COMPLEX FEATURE (need to understand first)                       │
│                                                                   │
│    /research ───► /plan ───► /verify-plan ◄──┐                    │
│                                  │           │ (iterate)          │
│                                  └───────────┘                    │
│                                  │                                │
│                                  ▼                                │
│                            /implement ───► review+fix loop       │
│                                                  │                │
│                                                  ▼                │
│                                            /checkpoint ──► Done  │
│                                                                   │
├───────────────────────────────────────────────────────────────────┤
│  INDEX SYNC (knowledge accumulated, code changed)                 │
│                                                                   │
│    /index-sync ───► read code + ephemeral files + diagrams        │
│                      │                                            │
│                      ▼                                            │
│                 synthesize — compress knowledge into diagrams,     │
│                 reshape diagram structure, drain ephemeral files   │
│                      │                                            │
│                      ▼                                            │
│                 update routing layers (CLAUDE.md, README)          │
│                      │                                            │
│                      ▼                                            │
│                    Done (ephemeral folders empty, diagrams alive)  │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

---

## How It's Different

**Stateless.** No tracking files, no "current phase." Run any command anytime. Skip what you don't need. Other frameworks require you to be in "planning" before "implementing" — Flow-Friction doesn't.

**No ceremony.** No mandatory progression. Research files are ephemeral — they get absorbed into their permanent home and deleted. The only persistent artifacts are the code and its indexes. One-time `roborev init` per repo enables continuous review — after that, everything is automatic.

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

**Per-repo setup** — initialize [RoboRev](https://github.com/roborev-dev/roborev) for continuous code review:

    roborev init

This installs a post-commit hook that auto-reviews every commit in the background. Configure `.roborev.toml` in the repo root:

```toml
review_agent = "codex"
fix_agent = "claude-code"
```

Codex reviews what Claude Code writes — different model, different perspective. Review findings are addressed with `/roborev:fix`. Use `roborev tui` to browse reviews interactively.

**Task persistence** — tasks survive `/clear` and new sessions:

```bash
# Add to ~/.bashrc or ~/.zshrc
claude() {
    CLAUDE_CODE_TASK_LIST_ID="$(basename "$PWD")" command claude "$@"
}
```

<details>
<summary><b>Advanced setup</b></summary>

**Single Plan Enforcement** — auto-delete old plans when a new one is written:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "FILE=$(jq -r '.tool_input.file_path'); DIR=$(dirname \"$FILE\"); echo \"$FILE\" | grep -q 'docs/plan/' && [ ! -f \"$FILE\" ] && find \"$DIR\" -maxdepth 1 -name '*.md' -delete || true"
      }]
    }]
  }
}
```

</details>

---

## File Layout

| Path | Purpose |
|------|---------|
| `docs/research/*.md` | Per-topic research files (ephemeral — absorbed by `/index-sync`) |
| `docs/plan/*.md` | Plan files (ephemeral — deleted after implementation) |
| `docs/diagrams/*.md` | Mermaid architecture diagrams (permanent index) |
| `.roborev.toml` | Per-repo RoboRev config — agent selection, review guidelines |
| `CLAUDE.md` | Agent routing table — commands, debug-by-symptom, diagram links |
| `README` | Human entry point — project overview |

---

## Commands

| Command | Description |
|---------|-------------|
| `/research` | Investigate unknowns — read code, run tests, trace bugs, write findings to `docs/research/` |
| `/best-practices` | Analyze current problem against expert-level best practices |
| `/conversation-search` | Search past conversation history |
| `/plan` | Create implementation plan (built-in Claude Code, not a Flow-Friction skill) |
| `/verify-plan` | Ask user questions, then audit and patch the plan |
| `/implement` | Execute plan via subagent delegation — agents commit atomically |
| `/checkpoint` | Mark a human-verified milestone — summarize work, create marker commit, optionally push |
| `/learn` | Capture conversation insights into `docs/research/` |
| `/index-sync` | Distill knowledge into diagrams — absorb ephemeral files, reflect code changes, reshape structure |
| `/next-prompt` | Generate a ready-to-paste prompt for the next session or agent |

[RoboRev](https://github.com/roborev-dev/roborev) commands — continuous code review for coding agents (installed via `roborev skills install`):

| Command | Description |
|---------|-------------|
| `/roborev:review` | Request a code review for a commit (also runs automatically via post-commit hook) |
| `/roborev:fix` | Fix all unaddressed review findings in one pass |
| `/roborev:address` | Address a single review's findings |
| `/roborev:respond` | Comment on a review and mark addressed without code changes |
| `/roborev:design-review` | Design-focused review — completeness, feasibility, task scoping |
| `/roborev:review-branch` | Review all commits on current branch |
| `roborev tui` | Interactive terminal UI — browse reviews, verdicts, findings |
| `roborev refine` | Automated fix loop — fix, re-review, repeat until all pass |
| `roborev analyze <type>` | Targeted analysis — `duplication`, `complexity`, `dead-code`, `refactor`, `architecture` |

---

## License

[MIT](https://opensource.org/licenses/MIT)
