---
name: literature-review
description: >
  Search academic literature, synthesize answers backed by citations, analyze citation networks,
  track research trends, and find seminal papers. Orchestrates three MCP servers: academic-mcp
  (19-database search + PDF download + text extraction), openalex (240M works — citation analysis,
  trends, gaps, venue quality, author profiling), and paper-download (paywall-busting via
  Unpaywall/Sci-Hub + PDF-to-Markdown). Use this skill whenever the user asks about academic
  literature, wants cited answers to scientific questions, says "find papers about", "what does the
  literature say", "literature review", "seminal papers", "citation analysis", "research trends",
  "who are the key authors in", or any question that should be grounded in peer-reviewed evidence.
  Also triggers on /literature-review. Even if the user doesn't explicitly mention papers or
  literature — if the question is scientific and would benefit from cited evidence, use this skill.
---

# /literature-review

Answer questions grounded in academic literature. Synthesize — don't just list papers.

## Three MCP Servers

You have three tools at your disposal. Each has a different strength. Use them together.

### 1. academic-mcp — Discovery

The search engine. Use it to find papers across 19 databases.

**Tools:**
- `paper_search(searcher, query, max_results)` — search a specific database or all at once
  - Omit `searcher` to search all enabled sources simultaneously
  - Sources: arxiv, pubmed, pmc, biorxiv, medrxiv, semantic, crossref, google_scholar, iacr, core
  - Returns: title, authors, abstract, URL, DOI, published date per paper
  - `max_results` up to 100 per source
  - For Semantic Scholar: optional `year` filter (e.g., "2020-2024")
- `paper_download(searcher, paper_id)` — download a PDF (open access only)
- `paper_read(searcher, paper_id)` — extract text from a downloaded PDF

**When to use:** First step for any literature question. Cast a wide net.

### 2. openalex — Deep Analysis

The analyst. 240M+ scholarly works with 31 tools. Discover the specific tools via the MCP server — here's what it can do by category:

- **Search & Discovery:** Boolean search with year/citation/venue/institution filters. Get full metadata for any paper. Find related works, review articles, seminal papers, and open access versions.
- **Citation Analysis:** Forward citations (who cites this), backward references (what it cites), full citation network graphs, and most influential papers in a field.
- **Authors & Institutions:** Find researchers by expertise ranked by h-index, get full author profiles, map co-authorship networks, search institutions.
- **Trends & Landscape:** Publication trends over time, compare research areas, find emerging topics, map geographic distribution.
- **Venue Quality:** Search within curated journal lists (UTD24, FT50, top AI conferences, Nature/Science family), check venue h-index and impact, find top venues for a field.

**When to use:** After initial discovery, when you need depth — seminal papers, citation landscape, trends, or quality assessment.

### 3. paper-download — Full Text Fetching

The fetcher. Downloads papers by DOI, arXiv ID, or URL. Tries legal open access first, falls back to Sci-Hub for older papers.

**Tools:**
- `paper_download(identifiers, output_dir, to_markdown, parallel)` — download 1-50 papers
  - `identifiers`: list of DOIs, arXiv IDs, or URLs
  - `to_markdown`: convert PDF to readable Markdown (set true when you need to read the content)
  - Download chain: Unpaywall → OpenAlex → arXiv → CORE → Sci-Hub (for papers before 2021)
- `paper_get_metadata(identifier)` — quick metadata lookup without downloading

**When to use:** When the user wants the full text of a specific paper, or when abstracts aren't enough to answer the question.

## Orchestration Strategy

The power is in combining these tools. Here's the general flow:

```
User asks a question
    ↓
1. DISCOVER — academic-mcp paper_search across relevant databases
   Get 10-20 papers with abstracts
    ↓
2. ANALYZE (if needed) — openalex for depth
   - find_seminal_papers for foundational work
   - get_top_cited_works for influential papers
   - analyze_topic_trends for evolution
   - get_citation_network for how papers connect
    ↓
3. SYNTHESIZE — read abstracts, build an answer with inline citations
    ↓
4. DEEPEN (on request) — paper-download for full text
   - User asks to read a specific paper
   - Download, convert to markdown, extract key findings
    ↓
5. SAVE (on request) — bookmark a paper
   - Download PDF to paper_inbox
   - Create companion markdown note
```

Not every question needs all steps. A quick factual question might only need step 1+3. A full literature review needs everything. Read the situation.

If an MCP server isn't available (tool calls fail), work with what you have. academic-mcp and openalex have overlapping search — either alone can answer most questions. paper-download is only needed for full text.

### Parallel tool use

When searching, fire multiple searches in parallel — academic-mcp for broad discovery AND openalex for citation-weighted results. Don't do them sequentially.

### When to fetch full text without being asked

Usually, abstracts are enough to synthesize an answer. Fetch full text when:
- The user explicitly asks ("read that paper", "what does the methods section say")
- The abstract is too vague to answer the question
- You need methodology details, specific numbers, or experimental results
- The user asks about a specific claim and you need to verify it

## Output Style

**Conversational and adaptive.** Start with a direct answer to the question, cite inline, offer to go deeper. Never fabricate citations — every paper you cite must come from actual search results.

Example format (illustrative — real answers use actual search results):
```
Photoacoustic imaging shows significantly improved sensitivity for breast tumor
detection compared to conventional ultrasound — 85-92% vs 67-74% across recent
studies (Chen et al., 2023; Smith et al., 2024). The key advantage is the optical
absorption contrast, which differentiates tumor vasculature from normal tissue
without ionizing radiation (Wang & Yao, 2016 — seminal paper, 3400 citations).

The field has grown rapidly since 2018, with publication volume tripling by 2024.
Most work comes from groups at Washington University, Caltech, and University
College London.

Want me to:
- Go deeper on any of these papers?
- Map the citation network around Wang & Yao 2016?
- Find the latest work specifically on real-time PA imaging?
```

**Citation style:** Flexible. Use author-year inline for conversational answers, numbered references for longer reviews. Always include DOI or URL when available so the user can find the paper.

## Saving Papers

When the user says "save this", "bookmark that paper", "keep this one":

1. Download the PDF via paper-download to `/media/ajay/gdrive/paper_inbox/`
2. Create a companion markdown note alongside it:

```markdown
---
tags: [auto-generated-topic-tags]
status: inbox
saved: YYYY-MM-DD
doi: "10.xxxx/xxxxx"
url: "https://..."
---
# Author Year — Short Title

**Thoughts:** Your thoughts on this paper (captured from conversation context)
**Abstract:** First 2-3 sentences of the abstract
**Key finding:** One-line summary of the main result

![[filename.pdf]]
```

The filename convention: `year_institution_country_short_title.pdf` (matching the user's existing naming pattern in paper_inbox).

Use `AskUserQuestion` to confirm the save and capture the user's thoughts — "what do you think about this paper?" Their words, however brief, help future triage.

## What This Skill Does NOT Do

- **Paper inbox management** (triage, archive, delete) — that's a separate `/paper` skill (future)
- **Deep Zettelkasten study** — that's `/study` in the _robo_thesis vault
- **General web research** — this is specifically for peer-reviewed academic literature
- **Write papers or manuscripts** — this finds and synthesizes, it doesn't author
