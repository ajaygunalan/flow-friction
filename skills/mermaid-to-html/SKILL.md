---
name: mermaid-to-html
description: Converts a Mermaid diagram markdown file (from /index-codebase) into a self-contained interactive HTML file with dark mode, pan/zoom, and hover highlights.
compatibility: Designed for Claude Code. Requires a browser to open generated HTML files.
allowed-tools: Bash Read Write Glob Grep
---

# Mermaid → Interactive HTML

Convert a `docs/diagrams/*.md` file into a self-contained interactive HTML page with dark mode, pan/zoom, and node hover highlights. No React, no Shiki — just vanilla JS + Tailwind CDN + Mermaid CDN.

## Input Format

The markdown file follows the `/index-codebase` diagram format:

```
# {Title}

{One sentence: what this shows and when to read it.}

\`\`\`mermaid
{diagram content — flowchart, erDiagram, etc.}
\`\`\`

{Optional: callout notes, framework traps, non-obvious details}
```

## Workflow

### Step 1: Accept input

The user provides a path to a `docs/diagrams/*.md` file. If no path given, use Glob to find candidates under `docs/diagrams/` and ask which one.

### Step 2: Parse the markdown

Read the file and extract four parts:

1. **Title** — the `# H1` line (strip the `#`)
2. **Description** — the first paragraph after the H1 (one sentence)
3. **Mermaid block** — content between ` ```mermaid ` and ` ``` ` fences
4. **Callout notes** — any content after the closing fence (may be empty)

### Step 3: Detect diagram type

Check how the mermaid content starts to select the correct Mermaid config:

| Starts with | Type | Config to use |
|-------------|------|---------------|
| `graph TD`, `graph LR`, `flowchart TD`, `flowchart LR` | Flowchart | Flowchart config |
| `erDiagram` | ER Diagram | ER config |
| Anything else | Default | Flowchart config |

### Step 4: Generate HTML

Create a **single self-contained HTML file** following the template in [references/html-template.md](references/html-template.md).

Inject:
- `{TITLE}` — from Step 2
- `{DESCRIPTION}` — from Step 2
- `{DIAGRAM}` — the raw mermaid block content from Step 2
- `{NOTES_HTML}` — callout notes rendered as HTML paragraphs (or omit the notes section if empty)
- Mermaid config — flowchart or ER based on Step 3

**Important generation rules:**
- Escape backticks in the diagram string if injecting into a JS template literal
- If the diagram already has `classDef` lines, keep them as-is
- If it has no `classDef`, don't add any — let Mermaid's dark theme handle colors
- The HTML must be fully self-contained (CDN links only, no local deps)

### Step 5: Write output

Write to the same directory as the input, with `.html` extension:
- `docs/diagrams/overview.md` → `docs/diagrams/overview.html`

### Step 6: Open in browser

```bash
# Linux
xdg-open docs/diagrams/overview.html

# macOS
open docs/diagrams/overview.html
```

## Quality Checklist

Before finishing, verify:
- [ ] Title and description appear in the header
- [ ] Mermaid diagram renders without syntax errors
- [ ] Dark mode: black background, white text, purple accents
- [ ] Pan/zoom works: scroll to zoom, drag to pan
- [ ] Zoom controls work: +, −, fit buttons
- [ ] Diagram auto-fits on load
- [ ] Node hover highlights work (brightness increase)
- [ ] If callout notes exist, they appear in a toggleable section
- [ ] HTML is fully self-contained (opens in any browser without a server)

## References

- [references/html-template.md](references/html-template.md) — Complete HTML template with all CSS and JavaScript
