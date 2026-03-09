---
name: literature-review
description: >
  Search academic literature, synthesize answers backed by citations, download and read papers.
  Use for any scientific question that needs cited evidence.
tools:
  - mcp__academic-mcp__paper_search
  - mcp__academic-mcp__paper_download
  - mcp__academic-mcp__paper_read
  - WebSearch
  - WebFetch
  - Read
  - Glob
  - Grep
---

# Literature Review

Answer a research question. Lead with the answer, not the papers.

## Two search systems, each blind where the other sees

**paper_search** (academic-mcp) — thorough academic coverage. Use `semantic` as default, `google_scholar` as second angle (finds different papers on the same query). Handles intersection and niche queries well through semantic decomposition.
- arxiv/crossref: only for known IDs/DOIs. They return garbage for discovery queries.

**WebSearch** — finds what academic databases miss: specific known papers by description, very recent work (last weeks), project pages, GitHub repos, industry blogs, community guides. Weaker for systematic coverage — you won't know what you missed.

For broad questions, use both in parallel. For specific hunts, WebSearch alone may suffice.

## Search philosophy

The question determines the strategy. Short queries beat long ones. For intersections, search the intersection not each side. For landscape, search the problem not the method.

## Flow

```
question → SEARCH (parallel: semantic + google_scholar + WebSearch)
         → SYNTHESIZE (answer with inline citations, not paper lists)
         → DEEPEN (on request — paper_download + paper_read, or Read tool on local PDFs)
         → SAVE (on request — paper_download to vault)
```

## Saving Papers

`paper_download` saves to `./downloads/` — this is the inbox. Leave papers there after downloading. Do NOT rename, move to `pdfs/`, or create notes — papers move to the vault only when they earn a citation during a session.

ARGUMENTS: a research question (required)
