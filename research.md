---
description: Research before planning - new features, debugging, exploration, refactoring
allowed-tools: Read, Glob, Grep, WebSearch, WebFetch, AskUserQuestion, Edit, Write, Task
---

Investigate $ARGUMENTS before planning.

## Route to methodology

| Topic type | Scout |
|------------|-------|
| How to build something | scout/technical |
| Finding libraries/tools | scout/open-source |
| Can we do this? | scout/feasibility |
| Deep understanding | scout/deep-dive |
| How others solve it | scout/competitive |
| Understanding a space | scout/landscape |
| What's been tried before | scout/history |
| Comparing options | scout/options |

**Narrow topic** (specific question, single angle) → run one scout directly.
**Broad topic** (multiple angles needed) → spawn 2-3 scouts in parallel via Task tool, then synthesize findings.

## Output

Save to `docs/plan/RESEARCH.md` (create dir if needed):

```markdown
## Original Intent
[What user asked — one line]

## Evolved Understanding
[What we now know. How understanding shifted.]

## Key Findings
[Synthesized across scouts if parallel]

## Recommendations
[What to do next]

## Handoff to Planning
[What /plan should address]

## Sources
[References used]
```
