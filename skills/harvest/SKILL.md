---
name: harvest
description: End-of-session distillation — scans the conversation, filters signal from noise through interactive questioning, and writes an issue file that seeds the next session. Use when the user says "harvest", wants to wrap up a session, capture decisions before closing, or bridge work to a future conversation.
argument-hint: "[optional: focus angle]"
allowed-tools: Read, Write, Edit, Glob, Grep
---

Scan the conversation from beginning to end. If `$ARGUMENTS` is given, use that angle to judge what is signal and what is noise.

Filter through four lenses using sequential `AskUserQuestion` calls. Each lens adds clarity from a different angle — keep asking until you and the user converge on what matters.

1. **Problem** — what are we solving?
2. **Approach** — what are we building?
3. **Verification** — how do we know it's done?
4. **Blind spots** — what would a fresh agent get wrong without being told?

Once the signal is clear, let the content find its natural shape. The format should emerge from what the lenses revealed — not from a rigid template. Write it in whatever structure makes the signal most clear and coherent for that particular case: narrative, bullet points, a decision log, a spec fragment, whatever fits.

Present the essence in chat — brief enough to scan, complete enough to judge. Only after user approval, write to `docs/issues/<N>-<slug>.md` with a descriptive filename.
