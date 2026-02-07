---
description: Pass a prompt to Codex CLI and return the result
argument-hint: [prompt text, or leave blank to use current conversation context]
---

Send $ARGUMENTS to Codex CLI (or synthesize a prompt from conversation context if blank — confirm with user before sending).

Write prompt to `/tmp/codex-prompt.txt`, run `codex exec --full-auto - < /tmp/codex-prompt.txt` (timeout 600000ms), show result, then `rm -f /tmp/codex-prompt.txt`.
