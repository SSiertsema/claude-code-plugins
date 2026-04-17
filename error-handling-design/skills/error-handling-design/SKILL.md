---
name: error-handling-design
description: Design end-to-end error handling for a product. Produces error taxonomy (validation / permission / network / third-party / server / data / rate-limit / deprecation), per-error message spec (plain-language / next action / technical code), prevention strategy, recovery flow, logging/observability handoff, and error-budget tie-in.
argument-hint: "[product / surface / flow]"
---

# Error Handling Design

You design how errors are prevented, detected, communicated, and recovered from across a product or surface. Output is an error taxonomy with per-error specs that design, engineering, content, and support teams can implement.

## Core rules

- **Prevent > detect > recover > communicate**: prevention beats error UX
- **User-facing language separate from technical code**: plain-language message + next action + optional technical ID
- **Every error has a recovery path**: never dead-end
- **Taxonomy stable across product**: consistent categorization + message patterns
- **Observability hand-off**: every user-visible error maps to a log / trace with enough context
- **No blame-the-user language**: errors are not the user's fault unless literally validation

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Subject** (product / surface / flow) | Yes | — |
| **Existing error inventory** | No | Elicit |
| **Tone / voice guide** | No | Friendly + direct |
| **Platforms** | No | web |

## Phase 1 — Setup

```
**Subject**: [name]
**Existing inventory**: [count or "none"]
**Tone**: [friendly / direct / formal / playful]
**Platforms**: [list]
**Localization**: [languages in scope]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/error-handling-design/`).

## Phase 2 — Error taxonomy

Core categories:

| Category | Description | Typical cause |
|---|---|---|
| **Validation** | Input doesn't meet rules | User input |
| **Permission / auth** | Access denied | Role / auth state |
| **Network / offline** | No connectivity | Device / network |
| **Timeout** | Slow operation exceeded threshold | Backend / network |
| **Third-party / dependency** | External service failure | Vendor |
| **Server / unexpected** | Backend bug / 500 | System |
| **Data** | Data missing / corrupt / conflict | Data quality |
| **Rate-limit / throttling** | Too many requests | User pattern / abuse |
| **Version / deprecation** | Client / data schema mismatch | Upgrade lag |
| **Capacity / quota** | Resource limit reached | Plan / usage |
| **Compliance / policy** | Content or action blocked | Regulatory / policy |
| **Safety / moderation** | Harmful content / abuse | Trust & safety |

Per category: definition, example, default severity (info / warning / error / critical).

## Phase 3 — Per-error spec

Per specific error:

| Field | Description |
|---|---|
| **Error ID** | `E-VAL-001`, ... — stable |
| **Category** | From taxonomy |
| **Trigger condition** | What causes it |
| **User-facing message** | Plain language (≤ 20 words default) |
| **Next action** | What the user should do (required) |
| **Secondary action** | Alternate path (optional) |
| **Technical code** | Internal ID for support / logs |
| **Severity** | info / warning / error / critical |
| **Display channel** | Inline / toast / modal / page / banner |
| **Persistence** | Auto-dismiss / manual-dismiss / persistent |
| **A11y** | role + live-region + focus behavior |
| **Telemetry event** | What fires on this error |
| **Logged context** | What gets captured for observability |
| **Recovery flow** | State transitions + retry behavior |

## Phase 4 — Message patterns

Style guide per message type:

| Type | Pattern |
|---|---|
| **Validation** | "[Field] must [rule]. [How to fix.]" |
| **Permission** | "You need [permission] to [action]. [Next action: request / switch account / contact]." |
| **Network** | "Can't reach [service]. [Retry / offline actions.]" |
| **Third-party** | "[Service] is temporarily unavailable. [Fallback / try later.]" |
| **Server** | "Something went wrong. We're looking into it. [Reference code: X.]" |
| **Data** | "We couldn't load [thing]. [Retry / check back.]" |
| **Rate-limit** | "Too many [actions] too quickly. Try again in [time]." |
| **Capacity** | "You've reached your [quota]. [Upgrade / wait / manage]." |

Rules:
- No "Oops!"
- No blame ("you entered wrong data")
- No jargon in user-facing text
- Technical code always separate: "Reference: ERR-042"

## Phase 5 — Prevention strategy

Per-category prevention measures:

| Error | Prevention |
|---|---|
| Validation | Inline, real-time feedback; constrain inputs (masks, pickers) |
| Permission | Disable / hide unavailable actions with reason on hover |
| Network | Optimistic UI + offline mode where possible |
| Third-party | Circuit breakers; graceful degradation |
| Data conflict | Versioning, last-write detection, conflict UI |
| Rate-limit | Debounce / throttle client-side |
| Capacity | Pre-warn at 80% threshold |

## Phase 6 — Recovery flows

Per error, define recovery as a mini-flow:

1. **Detect** — where / when
2. **Surface** — message + channel
3. **User action** — retry / modify / dismiss / escalate
4. **Fallback** — if user action fails repeatedly
5. **Escalation** — when to route to support / open an incident

For critical errors, include an automated-escalation path (page oncall, log to incident channel).

## Phase 7 — A11y for errors

- Live regions (`role="alert"` for critical, `aria-live="polite"` for non-critical)
- Focus management: move focus to error summary on validation, retain focus for transient errors
- Timing: errors not auto-dismiss if they require action; user-adjustable if auto-dismissal used
- Color + icon + text (don't rely on color alone)
- Keyboard: Escape dismisses dismissable errors

## Phase 8 — Observability hand-off

Per error ID, what engineering needs to capture:
- Log level
- Context (user ID hashed, session, request ID, stack, correlation ID)
- Metric incremented (error counter per category)
- Trace span attributes
- Alerting threshold (if error rate spikes)

Tie in to `slo-sli-definition` error budgets.

## Phase 9 — Content & i18n

- **Character budget** per channel (toast: ≤ 80 chars, modal: longer OK)
- **Translation keys** (stable IDs ≠ error IDs, since same error may have multiple messages)
- **Placeholder safety**: no placeholder misordering across locales
- **Tone consistency**: align with product voice

## Phase 10 — Diagrams

### 1. Error taxonomy tree

```mermaid
flowchart TD
    ERR["Errors"]
    ERR --> V["Validation"]
    ERR --> P["Permission/Auth"]
    ERR --> N["Network/Offline"]
    ERR --> T["Third-party"]
    ERR --> S["Server/Unexpected"]
    ERR --> D["Data"]
    ERR --> R["Rate-limit"]
    V --> V1["E-VAL-001<br/>Required field"]
    V --> V2["E-VAL-002<br/>Format mismatch"]
```

### 2. Recovery flow

```mermaid
flowchart LR
    DETECT[Detect]
    DETECT --> SURFACE[Surface message]
    SURFACE --> ACTION{User acts}
    ACTION -- Retry --> DETECT
    ACTION -- Modify --> DETECT
    ACTION -- Dismiss --> DISMISS[Dismiss]
    ACTION -- Escalate --> ESCALATE[Support / incident]
```

## Phase 11 — Diagram rendering

Per `diagram-rendering` mixin. File names:
- `error-taxonomy.mmd` / `.png`
- `recovery-flow.mmd` / `.png`

## Phase 12 — Report assembly and approval

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
[Categories with definitions + default severity]

## Per-error Inventory
[Table with all fields]

## Message Patterns
[Per-category pattern rules]

## Prevention Strategy
[Per-category prevention]

## Recovery Flows
[Detect → surface → action → fallback → escalation]

## Accessibility
[Live regions, focus, timing, color + text, keyboard]

## Observability Handoff
[Per error: log level, context, metric, trace, alerting]

## Content & i18n
[Character budgets, translation keys, tone consistency]

## Diagrams
[Taxonomy + recovery flow]

## Assumptions & Limitations
[Elicitation gaps, platform caveats]
```

Present for user approval. Save only after confirmation.

## Generation + planning rules

- Taxonomy stable
- Prevention beats recovery
- User-facing language separate from technical
- Every error has recovery
- Observability handoff complete
- A11y integrated

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject | Interview mode (§7) |
| Unknown error types | Elicit common categories; propose defaults |
| "Friendly" tone conflicts with critical errors | Align: critical = direct, no jokes |
| Error message blames user | Rewrite |
| Error without recovery | Block — require recovery path |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (incident response) | "Error UX; incident response is SRE process." |

## Self-check

```
[] Taxonomy defined with severity defaults
[] Per error: trigger / message / next action / code / severity / channel / a11y / telemetry / log context / recovery
[] Message patterns per category
[] No blame / jargon in user-facing text
[] Prevention strategy per category
[] Recovery flow per error (no dead ends)
[] A11y integrated
[] Observability handoff per error
[] i18n considerations
[] Diagrams valid
[] Report follows output contract
```
