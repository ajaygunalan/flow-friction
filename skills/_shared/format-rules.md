### Diagram format

File: `docs/diagrams/{name}.md`

```
# {Title}

{One sentence: what this shows and when to read it.}

\`\`\`mermaid
{content}
\`\`\`

{Optional: framework traps, non-obvious details as highlighted callouts}
```

Rules:
- Use exact function/class names from code where they add clarity
- Semantic names over variable names
- Each diagram: 5-12 nodes. Hard ceiling 12 — split if larger.
- Diagrams with 7+ nodes: organize into 2-4 subgroups of 3-5 nodes each. Each subgroup = one working-memory chunk.
- Data dimensions and types on edges
- Framework-specific warnings as highlighted notes — highest-value content
- Leave out: implementation internals, 1:1 code duplication, obvious control flow

### Markdown file format

File: `docs/{descriptive-name}.md`

```
# {Title}

{One sentence: what this covers and when to read it.}

{Content: checklists, tables, reference values, procedures, trap lists}
```

Rules:
- Actionable, not narrative. Checklists > paragraphs. Tables > prose.
- Include specific values, commands, and file paths — these are what people search for.
- Link to code files where the implementation lives.
