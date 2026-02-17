---
name: verify-plan
description: Verify and refine a plan before implementation.
allowed-tools: Bash, Read, Glob, Grep, Edit, Write, AskUserQuestion
---

Read `docs/plan/<>.md`. If no plan exists, tell the user and stop.

The original request in this conversation is the source of truth.

Read the plan against the original request. Identify ambiguities, missing requirements, and unclear design decisions. Use the ask_user_question tool to ask specific questions about what you found. Then fix the plan — keep changes minimal, preserve structure rather than rewrite.
