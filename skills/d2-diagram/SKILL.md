---
name: d2-diagram
description: Create D2 diagrams. Triggers on "create a diagram," "visualize," "draw architecture," "show relationships."
---

# D2 Diagram Skill

Style guide and rules for creating D2 diagrams. You already know D2 syntax — this tells you *how to style*, not how to write D2.

**Other skills that generate D2 diagrams** (`walkthrough`, `index-codebase`, `index-sync`) must follow these rules for visual consistency.

## Mandatory Defaults

Every diagram starts with this skeleton:

```d2
vars: {
  d2-config: {
    layout-engine: elk
    theme-id: 0
  }
}

direction: down

classes: {
  # Define one class per semantic group — see Color Palette below
}
```

## Style Rules

1. **Layout**: Always ELK. Always theme 0 (Neutral Default).
2. **Classes**: Define one class per semantic group. Every container/node gets a class. Never inline `style.*` on individual nodes.
3. **Labels**: Single-line `"name — short role"`. Never use `|md ... |` markdown blocks — they bloat nodes.
4. **Border-radius**: Always `border-radius: 8` on classes.
5. **Colors**: Each class gets a `fill` (light), `stroke` (saturated), `font-color` (dark) from the same hue. Max 5-6 colors per diagram.
6. **Infrastructure noise**: Omit config/utility connections that go everywhere. Mention them in prose below the diagram instead.
7. **Independent containers**: When containers have no natural connections, add light guide connections to force vertical stacking: `A -> B: "label" {style.stroke-dash: 3; style.opacity: 0.4}`
8. **Container size**: 3-7 nodes per container. Fewer than 3 = unnecessary grouping. More than 7 = split into sub-containers.
9. **Shapes**: Use `oval` for start/end, `diamond` for decisions, `rectangle` (default) for everything else. Don't over-differentiate.
10. **Connection labels**: 1-4 words max. Omit labels on obvious connections.
11. **Title**: Every diagram gets a title: `title: Name — Subtitle { shape: text; near: top-center; style.font-size: 24; style.bold: true }`

## Color Palette

Reusable hues — pick what fits, stay consistent within a diagram:

| Name | fill | stroke | font-color | Use for |
|------|------|--------|------------|---------|
| Blue | #DBEAFE | #2563EB | #1E40AF | Core/control, primary subsystems, model/compute |
| Green | #DCFCE7 | #16A34A | #166534 | Simulation, plant, success, output/results |
| Amber | #FEF3C7 | #D97706 | #92400E | Hardware, actuators, warnings, monitoring |
| Purple | #F3E8FF | #9333EA | #6B21A8 | Visualization, orchestration, inference |
| Slate | #F1F5F9 | #64748B | #334155 | Entry points, terminals, neutral, raw input |
| Teal | #CCFBF1 | #0D9488 | #115E59 | Geometry, secondary compute, calibration |
| Rose | #FFE4E6 | #E11D48 | #9F1239 | Safety-critical, force control, error paths |
| Indigo | #E0E7FF | #4338CA | #3730A3 | Low-level tracking, secondary pipelines |

## Domain Color Mappings

When working in these domains, prefer these semantic color assignments:

**Robotics (perception-planning-action):**
| Layer | Color | Rationale |
|-------|-------|-----------|
| Sensors / perception | Green | Input/plant data |
| Planning / decision | Blue | Core compute |
| Control / actuation | Amber | Hardware-facing |
| Safety / barriers | Rose | Critical path |
| Visualization / logging | Purple | Observation |

**ML / Deep Learning pipelines:**
| Stage | Color | Rationale |
|-------|-------|-----------|
| Data ingestion / raw input | Slate | Neutral entry |
| Preprocessing / features | Teal | Transform step |
| Model / training | Blue | Core compute |
| Evaluation / output | Green | Results |
| Monitoring / experiment tracking | Amber | Observation |
| Inference / serving | Purple | Deployment |

**Scientific computing / simulation:**
| Component | Color | Rationale |
|-----------|-------|-----------|
| Physics plant / environment | Green | Physical system |
| Solver / optimizer | Blue | Core compute |
| Sensor / measurement | Teal | Observation |
| Low-level tracking / integration | Indigo | Secondary pipeline |
| Hardware interface | Amber | Physical I/O |
| Visualization | Purple | Logging |

## Domain Shape Conventions

Beyond the basic shapes (rule 9), these shapes carry specific meaning in technical domains:

| Shape | Use for | Domain |
|-------|---------|--------|
| `rectangle` | Processing block, module, layer, system | All |
| `oval` | Start/end state, terminal | State machines |
| `diamond` | Decision, branch, choice | State machines, pipelines |
| `cylinder` | Data store, database, feature store, model registry | ML, data systems |
| `hexagon` | Fusion node, gateway, load balancer | Perception, distributed |
| `queue` | Message queue, buffer, FIFO | Real-time systems |
| `parallelogram` | I/O data, raw sensor stream | Dataflow diagrams |

Don't use more than 3 shape types per diagram. Shapes distinguish *categories*, not individuals.

## Class Template

```d2
classes: {
  my_class: {
    style: {
      fill: "#DBEAFE"
      stroke: "#2563EB"
      border-radius: 8
      font-color: "#1E40AF"
    }
  }
}
```

For state machines, add `shape: oval` or `shape: diamond` inside the class.

## Icons

Only use URLs from `references/d2_validated_icons_list.md`. Use sparingly — icons on key external-facing nodes only, not on every box.

## Syntax Reference

See `references/d2_syntax_reference.md` for shapes, connections, grids, and advanced features. Only consult when you need a specific syntax pattern.
