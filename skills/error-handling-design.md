# Error Handling Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | error-handling-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs end-to-end error handling across a product or surface. Produces a stable error taxonomy (validation / permission-auth / network-offline / timeout / third-party / server / data / rate-limit / version-deprecation / capacity-quota / compliance / safety-moderation) with definitions and default severities; a per-error inventory with stable IDs, trigger condition, plain-language user-facing message, mandatory next action, optional secondary action, technical code, severity, display channel (inline / toast / modal / page / banner), persistence, a11y expectation (role / live-region / focus), telemetry event, logged context for observability, and recovery flow. Defines category-level message patterns that enforce user-safe language (no "oops", no blame, no jargon), a prevention strategy per category (inline validation, circuit breakers, optimistic UI, pre-warnings), recovery flows (detect → surface → action → fallback → escalation) with no dead-ends, accessibility integration (live regions, focus management, timing, non-color-only signals, keyboard dismissal), observability handoff (log level / context / metric / trace / alert threshold) tying to `slo-sli-definition` error budgets, and content / i18n rules (character budgets per channel, stable translation keys, placeholder safety, tone consistency). Mermaid taxonomy tree and recovery-flow diagrams with PNG export. |
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

- Early product design: set the error-handling contract
- Redesign: audit existing error experience and establish consistency
- Pre-launch hardening: ensure every error has a recovery
- Regulated product: errors tied to compliance / support / legal
- Localization rollout: error strings need systematic review

## When not to use

- Single-component state-only design → `state-transition-mapping`
- Single-interaction feedback → `micro-interaction-design`
- Incident response / SRE process → dedicated incident management
- Content / voice guide at product level → future content style skill

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Product / surface / flow |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Existing error inventory** | Known errors | Elicit |
| **Tone / voice** | Friendly / direct / formal | Friendly + direct |
| **Platforms** | web / iOS / Android | web |
| **Languages in scope** | For i18n | None (English only) |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/error-handling-design/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
  optional:
    existing_inventory: list[object]
    tone: string
    platforms: list[string]
    languages: list[string]
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
Collect subject + tone + platforms + languages.

### Phase 2 — Taxonomy
Core categories + default severities.

### Phase 3 — Per-error spec
Stable IDs; full field set.

### Phase 4 — Message patterns
Per category; user-safe language.

### Phase 5 — Prevention strategy
Per category.

### Phase 6 — Recovery flows
Detect → surface → action → fallback → escalation; no dead ends.

### Phase 7 — A11y
Live regions / focus / timing / non-color-only / keyboard.

### Phase 8 — Observability handoff
Per error: log level / context / metric / trace / alert.

### Phase 9 — Content & i18n
Character budgets, translation keys, placeholder safety.

### Phase 10 — Diagrams
Taxonomy tree + recovery flow.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Error Handling Design: [Subject]

**Date**: [date]
**Subject**: [name]
**Tone**: [tone]
**Platforms**: [list]
**Languages**: [list]

## Scope
[Subject, tone, platforms, languages]

## Error Taxonomy
[Categories + severity]

## Per-error Inventory
[Table]

## Message Patterns
[Per-category rules]

## Prevention Strategy
[Per category]

## Recovery Flows
[Detect → surface → action → fallback → escalation]

## Accessibility
[Live regions, focus, timing, non-color, keyboard]

## Observability Handoff
[Per error: log / context / metric / trace / alert]

## Content & i18n
[Budgets, keys, placeholder safety]

## Diagrams
[Taxonomy + recovery]

## Assumptions & Limitations
[Elicitation gaps, platform caveats]
```

### Diagrams

- **Error taxonomy tree** — Mermaid `flowchart`
- **Recovery flow** — Mermaid `flowchart`

---

## Generation and planning policy

- Stable taxonomy
- Prevention prioritized
- User-safe language
- Every error has recovery
- Observability complete
- A11y integrated

---

## Self-check

```
[] Taxonomy with severity defaults
[] Per-error spec complete
[] User-safe language (no blame / jargon / oops)
[] Prevention per category
[] Recovery for every error
[] A11y per error type
[] Observability handoff
[] i18n considerations
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| Unknown error types | Propose defaults |
| Tone conflicts with severity | Align (critical = direct) |
| Blame language detected | Rewrite |
| Error without recovery | Block |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Taxonomy
- [ ] Per-error spec
- [ ] Message patterns
- [ ] Prevention
- [ ] Recovery (no dead ends)
- [ ] A11y
- [ ] Observability
- [ ] i18n
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. B2B SaaS**
- Input: Enterprise SaaS, 3 languages
- Expected: Full taxonomy, ~30 specific errors, message patterns applied, recovery flows per error class, i18n translation keys, observability to Datadog, alerting thresholds for rate-limit and third-party spikes.

**2. Consumer mobile app**
- Input: Consumer iOS + Android
- Expected: Offline + network prominent; retry with exponential backoff; haptic on critical errors; a11y via TalkBack / VoiceOver announcements; platform-specific icons.

**3. Fintech**
- Input: Payments product
- Expected: Compliance-sensitive messages (no disclosure that fails fraud check); strict audit logging on every payment error; clear support-escalation paths.

**4. Healthcare**
- Input: Patient-facing healthcare app
- Expected: Regulated language (no medical advice in errors); HIPAA-safe logging (no PHI in user-visible messages or telemetry without explicit redaction); on-call escalation for safety-flagged errors.

**5. Dev tool**
- Input: CLI / API product
- Expected: Error codes machine-readable + human-readable; docs link on every error; suggested commands for recovery; rate-limit headers documented.

### Edge cases

**6. Error cascades**
- Input: Complex flow where one error causes another
- Expected: Cascade mapping; show parent / child errors; avoid error storm; single aggregate message for user while still logging all causes.

**7. Silent / hidden errors**
- Input: Analytics failures users shouldn't see
- Expected: Silent in UI but fully logged; alerting on volume; not in error taxonomy customers see.

**8. Multi-language tone calibration**
- Input: Product in EN + JA + DE
- Expected: Tone adapted per locale (JA more formal, DE direct); translation keys account for length variation; no literal translation of jokes.

### Failure cases

**9. No subject**
- Input: "Design errors"
- Expected: Interview — "Which product / surface / flow?"

**10. Out of scope**
- Input: "Design errors + handle incidents"
- Expected: "Error UX only. Incident response is SRE process."
