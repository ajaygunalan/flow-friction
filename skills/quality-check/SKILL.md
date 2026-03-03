---
name: quality-check
description: Check modified files against conversation intent. Fix what's clear, ask about what's ambiguous.
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

Check all modified files against the user's intention from the conversation. If the intention is clear, fix issues directly. If ambiguous, ask before changing.
