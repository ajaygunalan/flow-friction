# HTML Template for Mermaid → HTML

Complete reference for generating interactive diagram HTML files. Vanilla JS — no React, no Shiki.

## Architecture

- **Vanilla JS** — no framework, no build step
- **Tailwind CDN** — utility-first styling
- **Mermaid CDN** — diagram rendering
- All in a single `<script type="module">` block

## Color Palette & Tailwind Config

| Token | Hex | Use |
|-------|-----|-----|
| `wt-bg` | `#000000` | Page background |
| `wt-surface` | `#0a0a0a` | Panels, notes section |
| `wt-raised` | `#141414` | Hover states |
| `wt-border` | `#2a2a2a` | Borders, dividers |
| `wt-fg` | `#ffffff` | Primary text |
| `wt-muted` | `#a0a0a0` | Secondary text, hints |
| `wt-accent` | `#a855f7` | Purple accent |
| `wt-file` | `#c084fc` | Lighter purple |
| `wt-red` | `#ef4444` | Close/dismiss hover |

### Tailwind Config Block

```html
<script>
  tailwind.config = {
    theme: { extend: { colors: {
      wt: {
        bg: '#000000', surface: '#0a0a0a', raised: '#141414',
        border: '#2a2a2a', fg: '#ffffff', muted: '#a0a0a0',
        accent: '#a855f7', file: '#c084fc', red: '#ef4444',
      },
    }}},
  };
</script>
```

## CDN Dependencies

```html
<script src="https://cdn.tailwindcss.com"></script>
<script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
```

Only two CDNs. No React, no Shiki.

## Mermaid Initialization

### Base Theme Variables

```js
const MERMAID_THEME = {
  primaryColor: '#0a0a0a',
  primaryTextColor: '#ffffff',
  primaryBorderColor: '#2a2a2a',
  lineColor: '#a0a0a0',
  background: '#000000',
};
```

### Flowchart Config

Use for `graph TD`, `graph LR`, `flowchart TD`, `flowchart LR`:

```js
mermaid.initialize({
  startOnLoad: false,
  theme: 'dark',
  securityLevel: 'loose',
  themeVariables: {
    ...MERMAID_THEME,
    secondaryColor: '#000000',
    tertiaryColor: '#000000',
    mainBkg: '#0a0a0a',
    nodeBorder: '#2a2a2a',
    clusterBkg: 'rgba(10,10,10,0.8)',
    clusterBorder: '#7c3aed',
    titleColor: '#ffffff',
    edgeLabelBackground: 'transparent',
  },
  flowchart: { useMaxWidth: false, htmlLabels: true, curve: 'basis' },
});
```

### ER Diagram Config

Use for `erDiagram`:

```js
mermaid.initialize({
  startOnLoad: false,
  theme: 'dark',
  securityLevel: 'loose',
  themeVariables: {
    ...MERMAID_THEME,
    entityBkg: '#0a0a0a',
    entityBorder: '#7c3aed',
    entityTextColor: '#ffffff',
    attributeBackgroundColorEven: '#0a0a0a',
    attributeBackgroundColorOdd: '#141414',
    labelColor: '#a0a0a0',
    relationColor: '#a855f7',
  },
  er: { useMaxWidth: false, layoutDirection: 'TB' },
});
```

**Critical**: `useMaxWidth: false` ensures natural SVG sizing. `securityLevel: 'loose'` is not needed for this skill (no click callbacks) but doesn't hurt.

## CSS

```css
/* Natural SVG sizing */
.mermaid-wrap svg {
  max-width: none !important;
  height: auto !important;
}

/* Node hover — flowchart */
.mermaid-wrap .node:hover rect,
.mermaid-wrap .node:hover polygon,
.mermaid-wrap .node:hover circle,
.mermaid-wrap .node:hover .label-container {
  filter: brightness(1.3);
  transition: filter .15s;
}

/* Node hover — ER entities */
.mermaid-wrap .er.entityBox { cursor: pointer; }
.mermaid-wrap g:has(.er.entityBox):hover .er.entityBox {
  filter: brightness(1.3);
  transition: filter .15s;
}

/* Subgraph label styling */
.mermaid-wrap .cluster-label span {
  color: #a0a0a0 !important;
  font-size: 0.85rem !important;
}

/* Notes section */
.notes-content {
  color: #a0a0a0;
  font-size: 0.88rem;
  line-height: 1.65;
}
.notes-content p {
  margin-bottom: 0.75rem;
}
.notes-content code {
  background: rgba(168,85,247,.12);
  padding: 1px 6px;
  border-radius: 4px;
  font-family: 'SF Mono','Fira Code',monospace;
  font-size: 0.82rem;
  color: #c084fc;
}
.notes-content strong {
  color: #ffffff;
  font-weight: 600;
}
.notes-content ul, .notes-content ol {
  margin: 0.5rem 0;
  padding-left: 1.25rem;
}
.notes-content li {
  margin-bottom: 0.35rem;
}
```

## Pan/Zoom (Vanilla JS)

Same algorithm as the walkthrough's `usePanZoom`, reimplemented without React:

```js
function initPanZoom() {
  const viewport = document.getElementById('viewport');
  const canvas = document.getElementById('canvas');
  const zoomDisplay = document.getElementById('zoom-display');

  const state = { zoom: 1, panX: 0, panY: 0 };
  const drag = { active: false, lastX: 0, lastY: 0 };

  function apply() {
    canvas.style.transform =
      `translate(${state.panX}px, ${state.panY}px) scale(${state.zoom})`;
    if (zoomDisplay) {
      zoomDisplay.textContent = Math.round(state.zoom * 100) + '%';
    }
  }

  function fitToScreen() {
    const svg = canvas.querySelector('svg');
    if (!svg || !viewport) return;
    const vw = viewport.clientWidth;
    const vh = viewport.clientHeight;
    const sw = svg.getBoundingClientRect().width / state.zoom;
    const sh = svg.getBoundingClientRect().height / state.zoom;
    const fit = Math.max(0.15, Math.min(2, Math.min((vw - 80) / sw, (vh - 80) / sh)));
    state.zoom = fit;
    state.panX = (vw - sw * fit) / 2;
    state.panY = (vh - sh * fit) / 2;
    apply();
  }

  // Scroll zoom (toward cursor)
  viewport.addEventListener('wheel', (e) => {
    e.preventDefault();
    const r = viewport.getBoundingClientRect();
    const mx = e.clientX - r.left;
    const my = e.clientY - r.top;
    const factor = e.deltaY < 0 ? 1.12 : 1 / 1.12;
    const newZoom = Math.min(4, Math.max(0.15, state.zoom * factor));
    const scale = newZoom / state.zoom;
    state.panX = mx - scale * (mx - state.panX);
    state.panY = my - scale * (my - state.panY);
    state.zoom = newZoom;
    apply();
  }, { passive: false });

  // Drag pan
  viewport.addEventListener('pointerdown', (e) => {
    drag.active = true;
    drag.lastX = e.clientX;
    drag.lastY = e.clientY;
    viewport.setPointerCapture(e.pointerId);
  });

  viewport.addEventListener('pointermove', (e) => {
    if (!drag.active) return;
    state.panX += e.clientX - drag.lastX;
    state.panY += e.clientY - drag.lastY;
    drag.lastX = e.clientX;
    drag.lastY = e.clientY;
    apply();
  });

  viewport.addEventListener('pointerup', () => { drag.active = false; });
  viewport.addEventListener('pointercancel', () => { drag.active = false; });

  // Resize re-fit
  window.addEventListener('resize', fitToScreen);

  return {
    apply,
    fitToScreen,
    zoomIn() { state.zoom = Math.min(4, state.zoom * 1.25); apply(); },
    zoomOut() { state.zoom = Math.max(0.15, state.zoom / 1.25); apply(); },
  };
}
```

## Notes Toggle (Optional)

Only include if the input markdown has content after the mermaid block:

```js
function initNotesToggle() {
  const btn = document.getElementById('notes-toggle');
  const panel = document.getElementById('notes-panel');
  if (!btn || !panel) return;

  let open = false;
  btn.addEventListener('click', () => {
    open = !open;
    panel.classList.toggle('hidden', !open);
    btn.textContent = open ? '✕ Notes' : '📋 Notes';
  });
}
```

## Complete HTML Template

Below is the full template. Replace placeholders marked with `{PLACEHOLDER}`:

- `{TITLE}` — diagram title from the H1
- `{DESCRIPTION}` — one-sentence description from the first paragraph
- `{MERMAID_CONFIG}` — the appropriate `mermaid.initialize({...})` call (flowchart or ER)
- `{DIAGRAM}` — raw mermaid diagram content (escape backticks: replace `` ` `` with `` \` ``)
- `{NOTES_SECTION}` — the notes HTML block, or empty string if no notes
- `{NOTES_TOGGLE}` — the notes toggle button, or empty string if no notes
- `{NOTES_INIT}` — `initNotesToggle();` or empty string if no notes

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{TITLE}</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: { extend: { colors: {
        wt: {
          bg: '#000000', surface: '#0a0a0a', raised: '#141414',
          border: '#2a2a2a', fg: '#ffffff', muted: '#a0a0a0',
          accent: '#a855f7', file: '#c084fc', red: '#ef4444',
        },
      }}},
    };
  </script>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
  <style>
    html { color-scheme: dark; }
    .mermaid-wrap svg { max-width: none !important; height: auto !important; }
    .mermaid-wrap .node:hover rect,
    .mermaid-wrap .node:hover polygon,
    .mermaid-wrap .node:hover circle,
    .mermaid-wrap .node:hover .label-container {
      filter: brightness(1.3); transition: filter .15s;
    }
    .mermaid-wrap .er.entityBox { cursor: pointer; }
    .mermaid-wrap g:has(.er.entityBox):hover .er.entityBox {
      filter: brightness(1.3); transition: filter .15s;
    }
    .mermaid-wrap .cluster-label span {
      color: #a0a0a0 !important; font-size: 0.85rem !important;
    }
    .notes-content { color: #a0a0a0; font-size: 0.88rem; line-height: 1.65; }
    .notes-content p { margin-bottom: 0.75rem; }
    .notes-content code {
      background: rgba(168,85,247,.12); padding: 1px 6px; border-radius: 4px;
      font-family: 'SF Mono','Fira Code',monospace; font-size: 0.82rem; color: #c084fc;
    }
    .notes-content strong { color: #ffffff; font-weight: 600; }
    .notes-content ul, .notes-content ol { margin: 0.5rem 0; padding-left: 1.25rem; }
    .notes-content li { margin-bottom: 0.35rem; }
  </style>
</head>
<body class="bg-wt-bg text-wt-fg overflow-hidden">

  <!-- Header -->
  <header class="fixed top-0 inset-x-0 z-10 px-6 py-3.5 bg-gradient-to-b from-wt-bg via-wt-bg/80 to-transparent pointer-events-none">
    <h1 class="text-base font-semibold text-wt-fg">{TITLE}</h1>
    <p class="text-sm text-wt-muted mt-0.5">{DESCRIPTION}</p>
  </header>

  <!-- Viewport (pan/zoom area) -->
  <div id="viewport" class="w-full h-screen overflow-hidden cursor-grab active:cursor-grabbing">
    <div id="canvas" class="origin-top-left will-change-transform inline-block p-[80px_60px_60px]">
      <div id="diagram" class="mermaid-wrap"></div>
    </div>
  </div>

  <!-- Zoom controls (fixed bottom-left) -->
  <div class="fixed bottom-5 left-5 z-20 flex items-center gap-1 px-2 py-1.5 bg-wt-surface border border-wt-border rounded-lg shadow-xl">
    <button id="zoom-out" class="w-7 h-7 flex items-center justify-center rounded text-wt-muted hover:bg-wt-raised hover:text-wt-fg transition-colors text-sm font-mono">−</button>
    <span id="zoom-display" class="w-12 text-center text-xs text-wt-muted font-mono">100%</span>
    <button id="zoom-in" class="w-7 h-7 flex items-center justify-center rounded text-wt-muted hover:bg-wt-raised hover:text-wt-fg transition-colors text-sm font-mono">+</button>
    <div class="w-px h-4 bg-wt-border mx-1"></div>
    <button id="zoom-fit" class="px-2 h-7 flex items-center justify-center rounded text-xs text-wt-muted hover:bg-wt-raised hover:text-wt-fg transition-colors">Fit</button>
  </div>

  {NOTES_TOGGLE}

  {NOTES_SECTION}

  <!-- Keyboard hint (fixed bottom-right) -->
  <div class="fixed bottom-5 right-5 z-20 text-xs text-wt-muted opacity-50">
    <kbd class="px-1.5 py-0.5 bg-wt-surface border border-wt-border rounded text-[0.65rem]">Scroll</kbd> zoom ·
    <kbd class="px-1.5 py-0.5 bg-wt-surface border border-wt-border rounded text-[0.65rem]">Drag</kbd> pan
  </div>

  <script type="module">
    // --- Mermaid config ---
    const MERMAID_THEME = {
      primaryColor: '#0a0a0a',
      primaryTextColor: '#ffffff',
      primaryBorderColor: '#2a2a2a',
      lineColor: '#a0a0a0',
      background: '#000000',
    };

    {MERMAID_CONFIG}

    // --- Diagram content ---
    const DIAGRAM = `{DIAGRAM}`;

    // --- Render diagram ---
    const diagramEl = document.getElementById('diagram');
    const { svg } = await mermaid.render('mermaid-diagram', DIAGRAM);
    diagramEl.innerHTML = svg;

    // --- Pan/Zoom ---
    const viewport = document.getElementById('viewport');
    const canvas = document.getElementById('canvas');
    const zoomDisplay = document.getElementById('zoom-display');

    const state = { zoom: 1, panX: 0, panY: 0 };
    const drag = { active: false, lastX: 0, lastY: 0 };

    function apply() {
      canvas.style.transform = `translate(${state.panX}px, ${state.panY}px) scale(${state.zoom})`;
      if (zoomDisplay) zoomDisplay.textContent = Math.round(state.zoom * 100) + '%';
    }

    function fitToScreen() {
      const svgEl = canvas.querySelector('svg');
      if (!svgEl || !viewport) return;
      const vw = viewport.clientWidth, vh = viewport.clientHeight;
      const sw = svgEl.getBoundingClientRect().width / state.zoom;
      const sh = svgEl.getBoundingClientRect().height / state.zoom;
      const fit = Math.max(0.15, Math.min(2, Math.min((vw - 80) / sw, (vh - 80) / sh)));
      state.zoom = fit;
      state.panX = (vw - sw * fit) / 2;
      state.panY = (vh - sh * fit) / 2;
      apply();
    }

    viewport.addEventListener('wheel', (e) => {
      e.preventDefault();
      const r = viewport.getBoundingClientRect();
      const mx = e.clientX - r.left, my = e.clientY - r.top;
      const factor = e.deltaY < 0 ? 1.12 : 1 / 1.12;
      const newZoom = Math.min(4, Math.max(0.15, state.zoom * factor));
      const scale = newZoom / state.zoom;
      state.panX = mx - scale * (mx - state.panX);
      state.panY = my - scale * (my - state.panY);
      state.zoom = newZoom;
      apply();
    }, { passive: false });

    viewport.addEventListener('pointerdown', (e) => {
      drag.active = true;
      drag.lastX = e.clientX;
      drag.lastY = e.clientY;
      viewport.setPointerCapture(e.pointerId);
    });
    viewport.addEventListener('pointermove', (e) => {
      if (!drag.active) return;
      state.panX += e.clientX - drag.lastX;
      state.panY += e.clientY - drag.lastY;
      drag.lastX = e.clientX;
      drag.lastY = e.clientY;
      apply();
    });
    viewport.addEventListener('pointerup', () => { drag.active = false; });
    viewport.addEventListener('pointercancel', () => { drag.active = false; });
    window.addEventListener('resize', fitToScreen);

    // --- Zoom controls ---
    document.getElementById('zoom-in').addEventListener('click', () => {
      state.zoom = Math.min(4, state.zoom * 1.25); apply();
    });
    document.getElementById('zoom-out').addEventListener('click', () => {
      state.zoom = Math.max(0.15, state.zoom / 1.25); apply();
    });
    document.getElementById('zoom-fit').addEventListener('click', fitToScreen);

    // --- Notes toggle ---
    {NOTES_INIT}

    // --- Auto-fit on load ---
    setTimeout(fitToScreen, 600);
  </script>
</body>
</html>
```

## Notes Section HTML Blocks

When callout notes exist, use these blocks for `{NOTES_TOGGLE}` and `{NOTES_SECTION}`:

### Notes Toggle Button (`{NOTES_TOGGLE}`)

```html
<!-- Notes toggle (fixed bottom-center) -->
<button id="notes-toggle" class="fixed bottom-5 left-1/2 -translate-x-1/2 z-20 px-3 py-1.5 bg-wt-surface border border-wt-border rounded-full text-xs text-wt-muted hover:bg-wt-raised hover:text-wt-fg transition-colors shadow-lg">
  📋 Notes
</button>
```

### Notes Panel (`{NOTES_SECTION}`)

```html
<!-- Notes panel (hidden by default) -->
<div id="notes-panel" class="hidden fixed top-16 left-6 z-20 max-w-lg max-h-[70vh] overflow-y-auto px-5 py-4 bg-wt-surface/95 backdrop-blur border border-wt-border rounded-xl shadow-2xl">
  <div class="notes-content">
    <!-- Render callout notes as HTML paragraphs here -->
    {NOTES_HTML}
  </div>
</div>
```

### Notes Init (`{NOTES_INIT}`)

```js
const notesToggle = document.getElementById('notes-toggle');
const notesPanel = document.getElementById('notes-panel');
if (notesToggle && notesPanel) {
  let notesOpen = false;
  notesToggle.addEventListener('click', () => {
    notesOpen = !notesOpen;
    notesPanel.classList.toggle('hidden', !notesOpen);
    notesToggle.textContent = notesOpen ? '✕ Notes' : '📋 Notes';
  });
}
```

When there are no callout notes, set all three placeholders (`{NOTES_TOGGLE}`, `{NOTES_SECTION}`, `{NOTES_INIT}`) to empty strings.

## Rendering Callout Notes as HTML

Convert the markdown notes to simple HTML:
- Paragraphs → `<p>...</p>`
- `**bold**` → `<strong>...</strong>`
- `` `code` `` → `<code>...</code>`
- `- item` → `<ul><li>...</li></ul>`
- Multiple paragraphs separated by blank lines

Keep it simple — these are short callout notes, not full markdown documents.

## Critical Rules

1. **`useMaxWidth: false`** — always set this so the SVG renders at natural size, not squished to container width
2. **Auto-fit on load** — `setTimeout(fitToScreen, 600)` waits for Mermaid to finish rendering
3. **Escape backticks** — diagram content injected into a JS template literal must have backticks escaped (`\``)
4. **No click handlers** — this skill uses hover highlights only, not click-to-detail (no per-node metadata)
5. **Preserve existing classDefs** — if the diagram already has `classDef` and `class` assignments, keep them
6. **Two CDNs only** — Tailwind + Mermaid. No React, no Shiki, no other dependencies
7. **Resize handler** — re-fit diagram when window resizes
8. **Pointer capture** — `setPointerCapture` on drag start ensures smooth panning even if cursor leaves viewport
