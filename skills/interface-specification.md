# Interface Specification — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | interface-specification |
| **Version** | 1.0.0 |
| **Purpose** | Specifies an internal code-level interface (module API / library surface / port) so implementers + callers agree on meaning, not just types. Per operation: signature with language-appropriate types + docstring covering preconditions, postconditions, errors (first-class part of contract), time + space complexity, concurrency (thread-safe / re-entrant / cancellable), idempotency. Across operations: invariants, parameter + return ownership, nullability vs absence vs error, lifetime + dispose rules. Error taxonomy classified by category (conflict / transient / programmer / expected) with recovery strategy. Stability label per interface (stable / experimental / deprecated / internal) with version-bump implications. Mandatory examples: happy path + edge case + failure. Testability notes (mockability, fixtures, nondeterminism ports). Alternative designs considered with one-line rejection rationale. Distinct from `api-contract-specification` (external network APIs — OpenAPI / AsyncAPI / SDL / Proto). Mermaid collaboration sequence + lifetime state diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New internal interface / port in a service
- Library API to be published internally or externally
- Refactor that stabilizes a previously informal contract
- Reviewer-ready spec before implementation

## When not to use

- Network / HTTP / RPC contract → `api-contract-specification`
- Whole-component doc → `component-design-documentation`
- Cross-system error strategy → `system-error-handling-strategy`
- Data schema → `conceptual-data-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Interface name + owner component** | Identifier + context |
| **Language + paradigm** | e.g., TypeScript class, Go interface, Python protocol |
| **Operations** | Methods / functions to include |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Stability target** | stable / experimental / deprecated / internal | `experimental` |
| **Consumers** | Team / public | Asked |
| **Concurrency model** | Thread-safe / not | Asked |
| **Async model** | Sync / Promise / async iter | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/interface-specification/[name]/` |

## Input schema

```
input:
  required:
    interface_name: string
    owning_component: string
    language: string
    operations: array[object]
  optional:
    stability_target:
      type: string
      enum: [stable, experimental, deprecated, internal]
    consumers: array[string]
    concurrency_model: string
    async_model: string
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Interface, owner, language, stability, consumers, concurrency, async.

### Phase 2 — Interface surface
Per operation: signature with pre/post + errors + complexity + concurrency + idempotency.

### Phase 3 — Error taxonomy
Category + when + recovery.

### Phase 4 — Concurrency + threading
Safety + re-entrancy + cancellation + blocking.

### Phase 5 — Performance + complexity
Time / space / I/O / latency class.

### Phase 6 — Lifetime + ownership
Instance lifetime + create/dispose + cleanup.

### Phase 7 — Stability guarantees
Label + versioning implications.

### Phase 8 — Examples
Happy / edge / failure per non-trivial op.

### Phase 9 — Testability
Mockability + fixtures + nondeterminism ports.

### Phase 10 — Alternative designs
Rejected with one-line rationale.

### Phase 11 — Diagrams
Collaboration sequence + lifetime state.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Interface Specification: [Name]

**Date**: [date]
**Owning component**: [...]
**Language**: [...]
**Stability**: [...]

## Scope
## Interface Surface
## Invariants
## Error Taxonomy
## Concurrency + Threading
## Performance + Complexity
## Lifetime + Ownership
## Stability Guarantees
## Examples
## Testability
## Alternative Designs
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Collaboration** — Mermaid `sequenceDiagram`
- **Lifetime state** — Mermaid `stateDiagram-v2`

---

## Assessment and planning policy

- Semantics, not just types
- Errors in contract
- Stability explicit
- Examples: happy + edge + failure
- Concurrency + lifetime
- No fabricated semantics

---

## Self-check

```
[] Signatures + pre/post per op
[] Invariants
[] Error taxonomy
[] Concurrency + lifetime
[] Complexity bounds
[] Stability label
[] Examples: happy / edge / failure
[] Testability notes
[] Alternatives considered
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No operations | Interview mode (§7) |
| Types only | Prompt for pre/post |
| Network API request | Redirect to `api-contract-specification` |
| Too many operations | Recommend ISP split |
| Stability unstated | Default to `experimental` |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Each op has pre + post + errors + complexity
- [ ] Stability label present
- [ ] Error categories declared
- [ ] Examples: happy + edge + failure
- [ ] Concurrency model per op
- [ ] Lifetime + ownership explicit
- [ ] Alternatives with rejection rationale

---

## Examples

### Normal cases

**1. Repository port**
- Input: `OrderRepository` with `save` + `findById`
- Expected: Pre/post + optimistic lock error + idempotency + thread safety + examples

**2. HTTP client SDK**
- Input: SDK `PaymentsClient`
- Expected: Per-method docstrings + network errors + retry semantics + cancellation; stability `stable`

**3. Plugin interface**
- Input: Plugin API for third-party authors
- Expected: Public contract; stable label; strict invariants; examples; semver policy

**4. Async iterator**
- Input: Event-subscription iterator
- Expected: Cancellation model + completion semantics + error delivery + backpressure behavior

**5. Service port in clean-architecture**
- Input: `NotificationSender`
- Expected: Idempotency key + eventual delivery semantics + retry responsibility split

### Edge cases

**6. Ill-defined semantics**
- Input: Just signatures, no behavior specified
- Expected: Ask for pre/post/errors before producing; produce skeleton with TODOs otherwise

**7. Returns `null` vs throws**
- Input: Unclear when null vs exception
- Expected: Codify — absence is null, error is exception; state invariant clearly

**8. Deprecation planning**
- Input: Interface being retired
- Expected: Mark deprecated; reference successor; sunset date; consumer migration note

### Failure cases

**9. Network API**
- Input: "Specify this HTTP API"
- Expected: Redirect to `api-contract-specification`

**10. Implementation request**
- Input: "Spec + implementation"
- Expected: "Specification only."
