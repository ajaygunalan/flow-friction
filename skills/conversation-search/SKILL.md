---
name: conversation-search
description: Search past Claude Code conversation history. Use when asked to recall, find, or search for anything from previous conversations - including content discussed, links shared, problems solved, topics covered, things posted, or work done together.
---

# Conversation History Search

Search past Claude Code conversations for content, solutions, and topics from previous sessions.

**Important:** Never infer work history from git status alone — always search conversation history.

## Commands

### Daily Digest

```bash
# Today / Yesterday / Specific date
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest yesterday
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest 2026-01-04

# Filter to project
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today --project ~/Projects/nuxt/secondBrain
```

### Keyword Search

```bash
# With date filters
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --today "newsletter"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --yesterday "bug fix"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --days 7 "refactor"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --since 2026-01-01 "feature"

# With project + format options
python3 ~/.claude/skills/conversation-search/scripts/search_history.py "nuxt content" --project ~/Projects/nuxt/secondBrain --limit 10 --format json
```

### Options

| Flag | Description |
|------|-------------|
| `--project <path>` | Search only a specific project |
| `--limit <n>` | Max results (default: 5) |
| `--format json\|text` | Output format (default: text) |
| `--today / --yesterday` | Filter by day |
| `--days N` | Last N days |
| `--since YYYY-MM-DD` | Since date |
| `--digest [DATE]` | Daily summary (today, yesterday, or YYYY-MM-DD) |

## Workflow

- **Temporal questions** ("what did we do today?") → use `--digest`
- **Topic searches** → combine date filter + keyword (e.g., `--today "newsletter"`)
- **Need full detail** → read the raw session file:
  ```bash
  cat ~/.claude/projects/<encoded-path>/<session-id>.jsonl | head -100
  ```