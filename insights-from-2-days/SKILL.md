---
description: Gather key insights from recent conversations that matter for the project's future. Searches today and yesterday by default. Triggers include "insights from today", "recent insights", "insights from 2 days", "what did we learn recently".
allowed-tools: Bash, Read, Glob, Grep, AskUserQuestion, Write
---

Search recent conversation history for reusable, non-obvious, project-specific insights — things that will shape how the project evolves. Default range is today and yesterday. Adjust if the user specifies differently.

```bash
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest yesterday
```

For deeper context, read the full session JSONL for relevant sessions:
```bash
cat ~/.claude/projects/<encoded-path>/<session-id>.jsonl
```

Find what matters — decisions made, problems solved, patterns discovered, traps hit, architecture changes. Skip the obvious. Only capture what helps the project move forward.

Present candidates via AskUserQuestion. One line per insight. Let the user cut, add, or reframe. This step is mandatory.

Save to `docs/INSIGHTS.md`. This file is ephemeral — `/clean-docs` absorbs it into the spec and deletes it.
