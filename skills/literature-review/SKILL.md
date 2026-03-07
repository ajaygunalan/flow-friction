---
name: literature-review
description: >
  Search academic literature, synthesize answers backed by citations, download and read papers.
  Uses academic-mcp (Semantic Scholar + 17 databases for search, download, and text extraction).
  Use this skill whenever the user asks about academic literature, wants cited answers to scientific
  questions, says "find papers about", "what does the literature say", "literature review",
  "seminal papers", "who are the key authors in", or any question that should be grounded in
  peer-reviewed evidence. Also triggers on /literature-review. Even if the user doesn't explicitly
  mention papers or literature — if the question is scientific and would benefit from cited evidence,
  use this skill.
---

# /literature-review

Answer questions grounded in academic literature. Synthesize — don't just list papers.

## MCP Server: academic-mcp

One server. Three tools. That's all you need.

### Tools

**`paper_search(query_list)`** — Search across 18+ academic databases.
- Best searcher for robotics/CS/AI: `semantic` (Semantic Scholar — has AI-powered relevance ranking)
- Other useful searchers: `arxiv`, `ieee`, `google_scholar`, `crossref`
- Omit `searcher` to search all enabled sources at once
- `max_results`: up to 100 per source
- For Semantic Scholar: optional `year` filter (e.g., "2020-2024", "2015-")
- Returns: title, authors, abstract, URL, DOI, published date

**`paper_download(query_list)`** — Download PDFs by searcher + paper_id.
- Works for open access papers (arxiv, PubMed, bioRxiv, etc.)
- Paper ID format depends on source: arxiv ID, PMID, DOI, Semantic Scholar ID
- For paywalled papers: use `curl` with arxiv preprint URL as fallback

**`paper_read(searcher, paper_id)`** — Extract text from a downloaded paper.
- Alternative: use Claude's native PDF Read tool directly on downloaded files

### Fallback: curl + native Read

For arxiv papers (most CS/robotics papers), you can bypass the MCP entirely:
```bash
curl -sL -o /tmp/paper.pdf "https://arxiv.org/pdf/XXXX.XXXXX"
```
Then read with the Read tool. This is faster for known arxiv papers.

## Orchestration

```
User asks a question
    ↓
1. SEARCH — fire 2-3 parallel paper_search calls with different angles
   - semantic: main query (best relevance for robotics/AI)
   - arxiv: same query (catches recent preprints)
   - Vary the query phrasing across searches to cast a wider net
   - Use year filters when appropriate
    ↓
2. SYNTHESIZE — read abstracts from search results
   - Build a direct answer with inline citations
   - Lead with the answer, not the papers
   - Identify which papers are foundational vs recent vs niche
    ↓
3. DEEPEN (on request) — download + read full text
   - User asks to go deeper on a specific paper
   - paper_download or curl for arxiv
   - paper_read or native Read tool
   - Extract specific findings, methods, numbers
    ↓
4. SAVE (on request) — bookmark a paper
   - Download PDF to /media/ajay/gdrive/paper_inbox/pdfs/
   - Create companion markdown note in notes/ (if it exists)
   - Naming: year_institution_country_short_title.pdf
```

### Search tips

- **Semantic Scholar is the best searcher for robotics.** Its AI ranking understands domain relevance. Always include it.
- **Use specific, short queries.** "impedance control unknown surfaces" beats "how to do force control on unknown surface geometries in robotic manipulation."
- **Run multiple searches with different angles.** For "VLM spatial reasoning robotics" also try "vision language model 3D geometry robot" and "equivariant representation robot manipulation."
- **Year filters help.** For foundational papers: no year filter or pre-2015. For state of art: 2023+.
- **If Semantic Scholar returns nothing, try arxiv or google_scholar.** Different databases index different papers.

## Output Style

Conversational and adaptive. Start with a direct answer to the question, cite inline, offer to go deeper. Never fabricate citations — every paper you cite must come from actual search results.

Citation style: author-year inline for conversational answers. Always include DOI or URL when available.

Example:
```
VLMs fail at spatial reasoning because they're trained on 2D image-text pairs
with no 3D geometric supervision. SpatialVLM (Chen et al., 2024 —
https://doi.org/10.1109/CVPR52733.2024.01370) proved this by showing VLMs
can't answer basic quantitative spatial questions. Their fix: 2 billion
synthetic 3D spatial Q&A examples. The scale required tells you how deep
the deficit is.

Want me to go deeper on any of these?
```

## Saving Papers

When the user says "save this", "bookmark that paper", "keep this one":

1. Download the PDF to `/media/ajay/gdrive/paper_inbox/pdfs/`
2. Filename convention: `year_institution_country_short_title.pdf`
3. If `notes/` directory exists, create a companion note:

```markdown
---
status: inbox
tags: []
saved: YYYY-MM-DD
doi: "10.xxxx/xxxxx"
---
# Year Institution — Short Title

**Save context:** captured from conversation — why this paper was saved

![[filename.pdf]]
```

## What This Skill Does NOT Do

- Paper vault management (triage, sift, filter) — that's `/sift`
- Deep Zettelkasten study — that's `/study` in _robo_thesis
- General web research — this is for peer-reviewed academic literature
- Write papers or manuscripts — this finds and synthesizes, it doesn't author
