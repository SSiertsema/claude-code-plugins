# Micro-interaction Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | micro-interaction-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs the smallest UX units (toggles, form validation, save buttons, pull-to-refresh, notifications, empty-state prompts) using Dan Saffer's four-part model: Trigger → Rules → Feedback → Loops & Modes. Per interaction: multiple triggers (click / keyboard / voice / sensor / system) each with discoverability and accessibility equivalents; rules covering input constraints, state transitions, side effects, timing (debounce / throttle / delay / timeout), preconditions, postconditions, and concurrency; multi-channel feedback (visual / auditory / haptic / text) timed across immediate / short / long and designed per state (idle / hover / focus / active / loading / success / error / disabled); loops (short / long / decay or evolution) and modes (spring-loaded / toggle / quasi-mode) with required entry / indicator / exit triplet. Includes accessibility checks, performance budget awareness (idle cost / slow-network / low-end device), and Given/When/Then acceptance criteria per scenario. Mermaid state diagram and optional feedback-timing strip with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Designing a specific interaction in depth (e.g., the save button's full behavior)
- Making implicit UX explicit for design handoff or component library spec
- Auditing existing micro-interaction (consistency, a11y, feedback gaps)
- Pre-wireframing detail work that screen layout alone can't capture

## When not to use

- Full screen / flow layout → `wireframing`
- Multi-step task flow → `user-flow-diagramming`
- App-level state model → `state-transition-mapping`
- Error-taxonomy / recovery across product → `error-handling-design`

---

## Required input

| Field | Description |
|---|---|
| **Interaction name** | Named unit |
| **Job (one sentence)** | What it does |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Context** | Where it appears | Elicit |
| **Platforms** | web / iOS / Android / desktop | web |
| **Existing patterns** | To align / diverge | — |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/micro-interaction-design/` |

## Input schema

```
input:
  required:
    interaction_name:
      type: string
    job:
      type: string
  optional:
    context:
      type: string
    platforms:
      type: list[string]
    existing_patterns:
      type: string
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup
Collect interaction + job + context + platforms.

### Phase 2 — Trigger
Per trigger: condition, discoverability, a11y equivalents.

### Phase 3 — Rules
Input / state transitions / side effects / timing / pre- + post-conditions / concurrency.

### Phase 4 — Feedback
Per channel and per state; timing bands.

### Phase 5 — Loops & modes
Loops (short / long / decay); modes with entry / indicator / exit.

### Phase 6 — Accessibility
Keyboard / SR / focus / motion / contrast / target / timing.

### Phase 7 — Performance
Idle + action cost; slow network + low-end paths.

### Phase 8 — Acceptance criteria
Given/When/Then covering normal + error + a11y + reduced-motion + repeat + modes.

### Phase 9 — Diagrams
State diagram + optional timing strip.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Micro-interaction: [Name]

**Date**: [date]
**Job**: [sentence]
**Platforms**: [list]

## Scope
[Interaction, job, context, platforms]

## Trigger
[Per trigger]

## Rules
[Complete rule spec]

## Feedback
[Channel × state × timing]

## Loops & Modes
[Or N/A note]

## Accessibility
[Per criterion]

## Performance
[Idle / action / slow / low-end]

## Acceptance Criteria
[Given/When/Then]

## Diagrams
[State + optional timing]

## Assumptions & Limitations
[Platform caveats]
```

### Diagrams

- **Interaction state** — Mermaid `stateDiagram-v2`
- **Feedback timing strip** — Mermaid `xychart-beta` (optional)

---

## Generation and planning policy

- 4-part model followed
- Feedback per state
- A11y first-class
- Modes justified
- No fabricated APIs

---

## Self-check

```
[] One job
[] Triggers with a11y
[] Complete rules
[] Feedback per state
[] Loops / modes or N/A
[] A11y checks
[] Performance considered
[] Given/When/Then
[] Diagrams valid
[] Modes have exit
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No interaction | Interview mode (§7) |
| >1 job | Split |
| A11y missing | Block |
| Mode without exit | Require exit |
| Visual-only feedback | Recommend multi-channel |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Single job
- [ ] Triggers + discoverability + a11y
- [ ] Rules complete
- [ ] Feedback per state
- [ ] Loops / modes
- [ ] A11y per criterion
- [ ] Performance
- [ ] Acceptance criteria
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Save button**
- Input: "Save form data"
- Expected: Click / Cmd+S / Enter-on-submit triggers; rules for debounce + retry + idempotency; states idle → loading → success/error; toast + inline text feedback + haptic (mobile); a11y full.

**2. Pull-to-refresh**
- Input: "Refresh feed"
- Expected: Drag-down beyond threshold triggers; spring resistance; haptic + visual; reduced-motion alternative (button); loading spinner with accessible label.

**3. Form validation**
- Input: "Validate email field"
- Expected: Blur + submit triggers; rules for format + uniqueness; inline feedback immediate on blur; aria-invalid + aria-describedby.

**4. Toggle switch**
- Input: "Enable notifications"
- Expected: Click / Space / Enter; immediate visual + haptic + aria-pressed; reduced-motion alternative (no slide, instant).

**5. Notification toast**
- Input: "Show success toast"
- Expected: System-initiated; auto-dismiss timing (user-adjustable per a11y); aria-live polite; manual close; stacking rules for multiple.

### Edge cases

**6. Mode-creating interaction**
- Input: "Enter edit mode for table row"
- Expected: Mode with clear entry (double-click / edit button) + indicator (border change + save/cancel buttons visible) + exit (Escape + Save + Cancel + focus-shift-away). Quasi-mode preferred over persistent.

**7. Long-running interaction**
- Input: "Upload large file"
- Expected: Progress feedback, cancel capability, network-loss handling, resume-upload behavior.

**8. Spring-loaded modifier**
- Input: "Shift-click to extend selection"
- Expected: Temporary mode while key held; clear cursor / visual change; release = exit automatically.

### Failure cases

**9. No interaction**
- Input: "Design something"
- Expected: Interview — "Which interaction, and what's its one-sentence job?"

**10. Out of scope**
- Input: "Design the full screen around this button"
- Expected: "Micro-interaction only. Full screen in `wireframing`."
