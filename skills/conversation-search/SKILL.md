---
name: conversation-search
description: Search past Claude Code conversation history. Use when asked to recall, find, or search for anything from previous conversations - including content discussed, links shared, problems solved, topics covered, things posted, or work done together. Triggers include "what did we do today", "summary of our work", "what did we work on", "from our conversations", "what did we discuss", "which X was about Y", "recall when we", "find where we talked about", "search history", "what did I share/post/send you about", "how did we fix", or any reference to past sessions or collaborative work.
---

**Important:** Never infer work history from git status alone — always search conversation history.

## What is the user looking for?

Determine the query type:
- **Temporal** ("what did we do today?", "summary of this week") → use digest mode
- **Specific topic** ("how did we fix X?", "find where we discussed Y") → use keyword search
- Combine date filters with keywords when possible for speed

## How do we find it?

### Digest Mode (temporal questions)

```bash
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest yesterday
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest 2026-01-04
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --digest today --project ~/Projects/nuxt/secondBrain
```

### Keyword Search (specific topics)

```bash
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --today "newsletter"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --yesterday "bug fix"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --days 7 "refactor"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py --since 2026-01-01 "feature"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py "EMFILE error"
python3 ~/.claude/skills/conversation-search/scripts/search_history.py "nuxt content" --project ~/Projects/nuxt/secondBrain
```

### Options

| Flag | Description |
|------|-------------|
| `--project <path>` | Search only a specific project |
| `--limit <n>` | Maximum results (default: 5) |
| `--format json\|text` | Output format (default: text) |
| `--today` | Only sessions from today |
| `--yesterday` | Only sessions from yesterday |
| `--days N` | Sessions from last N days |
| `--since YYYY-MM-DD` | Sessions since date |
| `--digest [DATE]` | Show daily digest (today, yesterday, or YYYY-MM-DD) |

### If more detail needed

Read the full JSONL file:
```bash
cat ~/.claude/projects/<encoded-path>/<session-id>.jsonl | head -100
```

## What do the results look like?

### Digest Mode

```
## January 04, 2026 - 4 sessions

### 1. Newsletter System Implementation
   Session: `2da9ab0b`
   Branch: `main`
   Files: content.config.ts, NewsletterCard.vue, NewsletterHeader.vue
   Commands: 6 executed
```

### Search Mode

Results include:
- **Score**: Relevance ranking
- **Problem**: The original issue or request
- **Solution**: How it was resolved
- **Commands Run**: Bash commands executed during the fix
- **Session ID**: For locating the full conversation

## Tips

- Use `--digest` for temporal questions — much faster than keyword search
- Combine date filters with keywords for speed
- Use specific technical terms (error messages, tool names)
- Try broader terms if specific search fails
