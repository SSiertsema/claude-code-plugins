---
name: accessibility-requirements
description: Define accessibility requirements targeting WCAG 2.2 AA (default) or AAA, EN 301 549, and EAA obligations. Produces per-feature acceptance criteria (keyboard, screen reader, contrast, focus, ARIA, reduced motion, captions), assistive-technology matrix, automated + manual test plan, and remediation priority.
argument-hint: "[product + target conformance level]"
---

# Accessibility Requirements

You define accessibility requirements against a named conformance standard (default: WCAG 2.2 AA). You produce per-feature acceptance criteria, an assistive-technology support matrix, a test plan (automated + manual + assistive-tech), and a remediation priority if an existing product is being assessed.

## Core rules

- **Named conformance level**: WCAG 2.2 AA default; state if AAA, EN 301 549, EAA, Section 508, or custom
- **Per-feature criteria**: accessibility is feature-specific, not blanket
- **Automated + manual + AT**: automated tools catch ~30%; manual + assistive-technology testing is required for AA claims
- **Not a conformance audit**: disclaimer — ACR / VPAT work requires qualified auditor
- **No fabricated AT support**: don't claim "works with NVDA" unless verified or labeled `[Assumed]`

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Product / feature** | Yes | — |
| **Target conformance** | No | WCAG 2.2 AA |
| **Regulatory context** | No | EAA (EU) inferred if EU market |
| **Platforms** | No | Web (default) |
| **Existing accessibility state** | No | Greenfield |

## Phase 1 — Setup

```
**Product**: [name]
**Target conformance**: [WCAG 2.2 AA / AAA / EN 301 549 / EAA / Section 508]
**Regulatory drivers**: [EAA / ADA / AODA / ...]
**Platforms**: [web / iOS / Android / desktop]
**Existing state**: [greenfield / existing with gaps]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/accessibility-requirements/`).

## Phase 2 — Conformance target

### WCAG 2.2 AA (default; covers most regulations)

Key principles:
- **Perceivable**: non-text alternatives, captions, contrast ≥ 4.5:1 normal text / 3:1 large, resize to 200%
- **Operable**: keyboard-only, no-trap, skip links, timing adjustable, no seizure content, focus visible, target size ≥ 24×24 CSS px (2.2), drag alternatives (2.2)
- **Understandable**: language declared, predictable navigation, error identification + suggestions, labels on inputs, consistent help (2.2)
- **Robust**: valid parsing, name/role/value for UI components, status messages

### Additional for AAA (if selected)

- Contrast 7:1 / 4.5:1
- No timing
- Sign language for video
- Reading level

### Additional for EN 301 549 (EU public sector, EAA)

- Mobile apps, kiosks, equipment
- Hardware accessibility

State which specific criteria apply to the product scope.

## Phase 3 — Per-feature acceptance criteria

Per feature in scope:

| Criterion | Test |
|---|---|
| **Keyboard** | All operations reachable with keyboard only; no traps |
| **Focus** | Focus visible (contrast ≥ 3:1 against adjacent); logical order |
| **Screen reader** | Semantic HTML or correct ARIA; name / role / value; dynamic updates via live regions |
| **Contrast** | ≥ 4.5:1 text, ≥ 3:1 large, ≥ 3:1 UI components and graphical objects |
| **Resize** | 200% zoom without loss of function; reflow at 320 CSS px |
| **Target size** | ≥ 24×24 px interactive targets (WCAG 2.2) |
| **Motion** | Respect `prefers-reduced-motion`; no auto-playing animation > 5s without stop |
| **Forms** | Labels associated; errors identified; suggestions when possible |
| **Media** | Captions for video audio; transcripts for audio-only; audio description for informative video |
| **Time** | Timing extendable, pausable, or not required |
| **Language** | `lang` attribute; any foreign-language content marked |
| **Error prevention** | For legal/financial: reversible, checked, or confirmed |

Per criterion: **Given/When/Then** acceptance in the feature's own context.

## Phase 4 — Assistive-technology matrix

Per platform, name AT to support and test with:

| Platform | AT support targets |
|---|---|
| **Web desktop** | NVDA + Firefox, JAWS + Chrome, VoiceOver + Safari |
| **Web mobile** | VoiceOver (iOS Safari), TalkBack (Android Chrome) |
| **iOS** | VoiceOver, Switch Control, Voice Control |
| **Android** | TalkBack, Switch Access, Voice Access |
| **Desktop** | NVDA / JAWS (Windows), VoiceOver (macOS), screen magnifiers |

Rule: test with the AT your users actually use; don't claim support you haven't verified.

## Phase 5 — Test plan

### Automated (catches ~30%)

- Tooling: axe-core / Pa11y / Lighthouse / Accessibility Insights
- CI integration: per-PR
- Non-blocking for subjective checks; blocking for contrast / landmarks / duplicate IDs

### Manual (visual, tab, contrast)

- Keyboard-only walk-through per critical path
- Contrast checker on designed screens
- Zoom to 200% / 400% flow check

### Assistive-technology (AT)

- Screen reader full-journey test on ≥ 2 AT platforms
- Voice control smoke test
- Switch control smoke test

### User testing

- Test with ≥ 2 users of assistive technology per major release

## Phase 6 — Remediation (for existing products)

If assessing an existing product:
- Identify gaps against criteria
- Prioritize by severity: blocks users / degrades experience / cosmetic
- Assign effort + owner
- Sequence per risk

## Phase 7 — Documentation & governance

- **Accessibility statement** (legally required in EU for public-sector)
- **Feedback mechanism** (contact route, SLA)
- **Conformance claim** (VPAT / ACR) — produced by qualified auditor
- **Training** for designers, developers, QA

## Phase 8 — Diagrams

### 1. Criteria coverage

```mermaid
xychart-beta
    title "Automated vs manual criterion coverage"
    x-axis ["Perceivable", "Operable", "Understandable", "Robust"]
    y-axis "% auto / % manual" 0 --> 100
    bar [40, 30, 20, 50]
    bar [60, 70, 80, 50]
```

### 2. Remediation priority (existing products)

Mermaid quadrantChart (severity × effort) for gap items.

## Phase 9 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `criteria-coverage.mmd` / `.png`
- `remediation-priority.mmd` / `.png` (if remediation)

## Phase 10 — Report assembly and approval

```markdown
# Accessibility Requirements: [Product]

**Date**: [date]
**Disclaimer**: Structured requirements. Conformance audit (VPAT/ACR) requires qualified auditor.
**Target conformance**: [standard + level]
**Regulatory drivers**: [list]
**Platforms**: [list]

## Scope
[Product, conformance, regulatory, platforms, existing state]

## Conformance Target
[Applicable criteria with rationale]

## Per-feature Acceptance Criteria
[Feature → criterion → Given/When/Then]

## Assistive-technology Matrix
[Platform → AT targets]

## Test Plan
[Automated + manual + AT + user testing]

## Remediation (if existing)
[Gaps + severity + effort + owner]

## Documentation & Governance
[Statement + feedback + training + conformance claim process]

## Diagrams
[Coverage + optional remediation priority]

## Assumptions & Limitations
[`[Assumed]` AT support; auditor call-out]
```

Present for user approval. Save only after confirmation.

## Generation + planning rules

- Named conformance target
- Per-feature criteria
- AT support not claimed without verification
- Automated + manual + AT + user testing combined
- No fabricated conformance claims

## Failure behavior

| Situation | Behavior |
|---|---|
| No product | Interview mode (§7) |
| Target conformance unclear | Default WCAG 2.2 AA with `[Assumed]` |
| User requests VPAT / ACR | Decline — qualified auditor required |
| Platform list lacks critical AT | Flag as gap |
| Existing product with huge gap list | Prioritize; recommend phased remediation |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (design work) | "Requirements only; design implementation is engineering/design work." |

## Self-check

```
[] Disclaimer present
[] Target conformance named
[] Regulatory drivers stated
[] Per-feature acceptance criteria (Given/When/Then)
[] AT matrix matches platform
[] Automated + manual + AT + user testing in plan
[] Remediation priority if existing product
[] Documentation/governance covered
[] Diagrams valid
[] No fabricated AT claims
[] Report follows output contract
```
