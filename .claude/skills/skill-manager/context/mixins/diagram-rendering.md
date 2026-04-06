# Mixin: Diagram Rendering

Applies to skills that declare `mixins: [diagram-rendering]`.
Loaded alongside the category extension. Does not replace it.

---

## Purpose

Standardizes Mermaid diagram rendering across all diagram-producing skills. Covers render mode selection, mmdc tooling, code vs image output, file naming, and failure handling.

---

## Render mode input schema

Skills that include this mixin add the following to their input schema:

```
render_mode:
  type: string
  enum: [code, image]
  default: code
  dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
```

---

## Setup: render mode question

During the setup phase, after confirming scope, ask:

> "Would you like rendered diagram images in the report? This requires `@mermaid-js/mermaid-cli` (mmdc). Without it, diagrams appear as Mermaid code blocks."

Present the mode table:

| Mode | Report contains | `.mmd` source files | Requires mmdc |
|---|---|---|---|
| `code` (default) | Mermaid code blocks | No | No |
| `image` | `![](path.png)` image references only | Yes (alongside PNGs) | Yes |

If the user wants image mode:
1. Check availability: `which mmdc 2>/dev/null`
2. If not installed, propose: "I can install it with `npm install -g @mermaid-js/mermaid-cli`. Shall I proceed?"
3. Install only after explicit user approval
4. If the user declines installation, fall back to `code` mode

---

## Rendering: code mode

Include Mermaid code blocks directly in the report. No external files needed.

---

## Rendering: image mode

1. Write each diagram to `[name].mmd` in the output directory
2. Run: `mmdc -i [name].mmd -o [name].png -t neutral -b transparent`
3. Embed in report: `![Diagram Title]([name].png)`
4. Do NOT include Mermaid code blocks in the report — the `.mmd` source files serve as the editable source
5. Keep `.mmd` source files alongside `.png` for editability

---

## File naming convention

- Use kebab-case for all `.mmd` and `.png` files (e.g., `power-interest-grid.mmd`)
- The skill defines its own file name list; this mixin defines the convention only
- Files are saved in the skill's output directory

---

## Failure behavior

| Situation | Behavior |
|---|---|
| mmdc not installed and user declines install | Fall back to `code` mode |
| mmdc rendering fails for a specific diagram | Report the error, fall back to `code` mode for that diagram only |
| mmdc rendering fails for all diagrams | Report the error, fall back to `code` mode for all diagrams |

---

## Self-check additions

Skills including this mixin add these checks:

```
[] All Mermaid diagrams render valid syntax
[] Image mode: .mmd source files exist alongside .png files
[] No Mermaid code blocks in report when image mode is active
[] No ![](path.png) references in report when code mode is active
```
