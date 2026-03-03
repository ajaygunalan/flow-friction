---
name: check
description: Check plans or modified files against conversation intent. Fix what's clear, ask about what's ambiguous.
argument-hint: "[optional: what to focus on]"
allowed-tools: Read, Write, Edit, Glob, Grep, AskUserQuestion
---

Compare whatever exists — plan files, modified code, or both — against the user's intention from the conversation. If $ARGUMENTS is given, focus the check on that. Fix what's clear, ask about what's ambiguous.
