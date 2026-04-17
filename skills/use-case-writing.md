# Use Case Writing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | use-case-writing |
| **Version** | 1.0.0 |
| **Purpose** | Writes formal UML-style use cases using Cockburn conventions. Supports three format levels by stakes: brief (single-paragraph summary), casual (multi-paragraph prose), fully-dressed (structured template). Per fully-dressed use case produces: stable ID, verb-led goal name, primary actor + supporting actors, scope, level (summary / user-goal / subfunction — Cockburn's altitude), stakeholders & interests, preconditions, postconditions (success + failure), trigger, numbered main success scenario (actor-verb-object per step, alternating actor/system), alternate flows indexed to main-scenario steps (e.g., 3a, 3b), exception flows indexed to steps (4.1, 4.2), special requirements (performance / security / usability), technology & data variations, frequency, priority, open issues. Models relationships between use cases (include / extend / generalization) sparingly. Produces UML-style use-case diagram showing actors linked to use cases within system boundary, with include / extend arrows between cases. Mermaid diagram with optional PNG export. |
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

- Formal requirements documentation (regulated / contracted / enterprise systems)
- System scope definition with multiple actors
- Pre-implementation spec handoff to engineering
- Training new team members on system behavior
- Complement to user stories when depth + edge-case coverage needed

## When not to use

- UI-level task flow → `user-flow-diagramming`
- User stories (shorter, Agile-friendly) → `user-story-generator` / existing user-story-generator plugin
- System context boundary → `context-diagramming`
- Business process with actor swimlanes → `business-process-modeling`
- State machines for entity lifecycles → `state-machine-diagramming` (Phase 3) / `state-transition-mapping` (Phase 4 UI)

---

## Required input

| Field | Description |
|---|---|
| **Scope** | System / feature, or specific use-case name(s) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Format** | brief / casual / fully-dressed | fully-dressed for critical; casual otherwise |
| **Actors** | Primary + supporting | Elicit |
| **Level** | summary / user-goal / subfunction | user-goal |
| **Use-case count target** | How many to write | 1 if named, else elicit |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/use-case-writing/` |

## Input schema

```
input:
  required:
    scope:
      type: string | document_reference
  optional:
    format:
      type: string
      enum: [brief, casual, fully-dressed]
      default: fully-dressed
    actors: list[object]
    level:
      type: string
      enum: [summary, user-goal, subfunction]
      default: user-goal
    use_case_count: integer
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
Collect scope + format + actors + level.

### Phase 2 — Format selection
Brief / casual / fully-dressed per stakes.

### Phase 3 — Fully-dressed template
Full section set per use case.

### Phase 4 — Level classification
Cockburn altitude: summary / user-goal / subfunction.

### Phase 5 — Main success scenario
Numbered steps, actor-verb-object.

### Phase 6 — Alternate + exception flows
Indexed to steps.

### Phase 7 — Relationships
Include / extend / generalization where justified.

### Phase 8 — Use-case diagram
Mermaid flowchart with actors + cases + relationships.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Use Cases: [System]

**Date**: [date]
**Scope**: [system / feature]
**Format**: [level]
**Use-case count**: [N]

## Scope
[System, scope, actors, level]

## Actors
[Per actor: name, type, role]

## Use-case Diagram
[Mermaid]

## Use Cases
[Per UC: full template]

## Relationships
[Include / extend / generalization]

## Cross-use-case Notes
[Shared preconditions, common exceptions]

## Assumptions & Limitations
[Gaps, open issues]
```

### Diagrams

- **Use-case diagram** — Mermaid `flowchart` with system-boundary subgraph + actors outside

---

## Generation and planning policy

- Format matched to stakes
- MSS actor-verb-object
- Alternates / exceptions indexed
- Relationships sparingly
- No UI-specific language
- No fabricated actors

---

## Self-check

```
[] Scope declared
[] Format chosen per stakes
[] Full template (fully-dressed) per case
[] MSS numbered
[] Alternates / exceptions indexed
[] Special requirements if relevant
[] Diagram valid
[] No UI specifics
[] No implementation details
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No scope | Interview mode (§7) |
| Level confusion | Clarify; default user-goal |
| >5 exceptions | Suggest splitting case |
| Fully-dressed for trivial | Propose casual |
| UI-specific language | Rewrite at system level |
| mmdc failure | See `diagram-rendering` mixin |
| Test-writing request | Out-of-scope; point to AC / test skills |

---

## Quality checks

- [ ] Format per stakes
- [ ] Primary actor + preconditions + postconditions + trigger + MSS
- [ ] Alternates / exceptions indexed
- [ ] Diagram valid
- [ ] No implementation details

---

## Examples

### Normal cases

**1. E-commerce place-order**
- Input: System = e-commerce, use case = Place Order, format = fully-dressed
- Expected: Primary = Customer; supporting = Payment Gateway, Inventory System; 7-step MSS; alternates for "guest checkout" / "saved card"; exceptions for "card declined" / "out of stock" / "address invalid"; include UC-Process-Payment.

**2. SaaS admin use cases**
- Input: SaaS admin scope
- Expected: 4–6 use cases (invite user, revoke access, change role, view audit log, configure integration). Fully-dressed for critical (role changes); casual for audit-log viewing. Admin as primary, SSO + audit system as supporting.

**3. Multi-actor scenario**
- Input: Procurement approval
- Expected: Primary = Requester; supporting = Approver, Vendor, Finance System. MSS includes hand-offs between actors explicitly; alternates for multi-approver scenarios.

**4. Regulated / medical**
- Input: Medical order fulfillment
- Expected: Fully-dressed mandatory; stakeholders & interests section includes regulator; special requirements for audit logging; exceptions tied to compliance.

**5. Subfunction decomposition**
- Input: User-goal UC "Place Order" has complex sub-step "Validate Address"
- Expected: Subfunction UC-Validate-Address written separately; Place-Order MSS includes it at relevant step.

### Edge cases

**6. Use case grown too big**
- Input: 25-step MSS with 10 alternates
- Expected: Flag over-scoping; recommend splitting into 2–3 use cases at logical boundaries.

**7. Actor not acting on system**
- Input: Actor is really a stakeholder, not interacting
- Expected: Move from Primary/Supporting to Stakeholders & Interests; don't force actor status.

**8. Cross-system use case**
- Input: Use case spans 2 systems
- Expected: Pick one as scope (system-under-discussion); others become supporting actors/systems; flag if truly joint, recommend separate use cases per system.

### Failure cases

**9. No scope**
- Input: "Write use cases"
- Expected: Interview — "Which system / feature, and what's the use-case scope?"

**10. Out of scope**
- Input: "Write use cases + tests"
- Expected: "Use cases only. Test writing in AC skills (`acceptance-criteria-writing`) or test-plan skills."
