---
name: review-fix
description: Review changes against conversation intent and fix inconsistencies. Use when the user says "review", "review-fix", or "quality check".
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# /review-fix

Scan the conversation to understand the intent. Read all changes made during this session. Verify every change is consistent with that intent. If anything is inconsistent, off-track, or missing — fix it.
