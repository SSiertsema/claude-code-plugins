# Decision Table Creation — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | decision-table-creation |
| **Version** | 1.0.0 |
| **Purpose** | Expresses complex business rules as decision tables where conditions (top rows) × rules (columns) map to actions (bottom rows). Supports three table types: limited-entry (boolean conditions with Y/N/don't-care values), extended-entry (conditions with ranges or enumerated values), and mixed (some boolean + some valued). Per condition captures name, data type, value domain, source. Per action captures name, effect, mutual-exclusivity, and compatibility. Systematically verifies completeness (every combination of condition values covered by at least one rule OR explicitly declared impossible), consistency (no overlapping rules with different actions), and redundancy (no duplicate rules). Always adds an explicit default / otherwise rule to prevent implicit fallbacks. Optionally emits DMN XML (Decision Model and Notation) with declared hit policy (UNIQUE / FIRST / PRIORITY / ANY / COLLECT / RULE ORDER / OUTPUT ORDER) for import into dedicated decision engines. Optional Mermaid flowchart rendering the same rules for non-table-literate audiences. |
| **Primary category** | `generation` |
| **Secondary category** | `extraction` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Complex conditional logic with multiple factors (loan approval, pricing rules, eligibility, routing)
- Rules where completeness matters (regulatory, safety, financial)
- Replacing tangled if-then-else prose with compact tabular form
- DMN-capable decision engine integration (Camunda DMN, Drools)
- Business-rule review with non-developer stakeholders

## When not to use

- Simple if-then rules (< 3 conditions) → prose or inline rule
- State-dependent logic → `state-machine-diagramming` (actions depend on state)
- UI-level conditional rendering → component-spec skills
- Workflow with sequence / actors → `business-process-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Decision scope** | What's being decided |
| **Conditions** | ≥2 factors |
| **Actions** | ≥1 outcomes |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Table type** | limited-entry / extended-entry / mixed | limited-entry |
| **DMN output** | Emit DMN XML | false |
| **Hit policy** (if DMN) | UNIQUE / FIRST / PRIORITY / ANY / COLLECT / ... | UNIQUE |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/decision-table-creation/` |

## Input schema

```
input:
  required:
    decision_scope:
      type: string
    conditions:
      type: list[object]
      min: 2
    actions:
      type: list[object]
      min: 1
  optional:
    table_type:
      type: string
      enum: [limited-entry, extended-entry, mixed]
      default: limited-entry
    emit_dmn: boolean
    hit_policy:
      type: string
      enum: [UNIQUE, FIRST, PRIORITY, ANY, COLLECT, RULE-ORDER, OUTPUT-ORDER]
      default: UNIQUE
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
Collect scope + conditions + actions + table type.

### Phase 2 — Table type selection
Boolean / value-based / mixed.

### Phase 3 — Condition + action spec
Data types, value domains, effects, compatibility.

### Phase 4 — Rule enumeration
Per rule: condition values + actions; use don't-care to collapse.

### Phase 5 — Completeness check
Cover every combination or mark impossible.

### Phase 6 — Consistency check
No overlapping rules with different outcomes.

### Phase 7 — Redundancy check
No duplicate rules; merge.

### Phase 8 — Default rule
Explicit otherwise / fallback.

### Phase 9 — DMN (if requested)
XML with hit policy.

### Phase 10 — Diagrams
Table + optional flowchart rendering.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Decision Table: [Scope]

**Date**: [date]
**Scope**: [description]
**Table type**: [type]
**Rules**: [count]

## Scope
[Decision, conditions, actions, type]

## Conditions
[Per condition]

## Actions
[Per action]

## Decision Table
[Table]

## Completeness Check
[Max space + rule count + gaps or coverage]

## Consistency Check
[Inconsistencies or "none"]

## Redundancy Check
[Redundancies or "none"]

## Default / Otherwise Rule
[Explicit fallback]

## DMN Export (if requested)
[XML reference + hit policy]

## Rule Flowchart (optional)
[Mermaid]

## Assumptions & Limitations
[Elicitation gaps, edge cases]
```

### Diagrams

- **Decision table** — Markdown table
- **Rule flowchart** — Mermaid `flowchart` (optional)

---

## Generation and extraction policy

- Conditions + actions fully specified
- Completeness / consistency / redundancy verified
- Default explicit
- DMN hit policy if emitting XML
- No fabricated rules

---

## Self-check

```
[] Scope declared
[] Table type chosen
[] Conditions + actions specified
[] Rules enumerated
[] Completeness verified
[] Consistency verified
[] Redundancy verified
[] Default rule explicit
[] DMN hit policy if DMN output
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| <3 conditions | Maybe overkill; recommend if-then |
| >8 conditions | Decompose into multiple tables |
| Infinite value domain | Bucket or flag |
| Completeness claim without check | Run full check |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out-of-scope |

---

## Quality checks

- [ ] Table type appropriate
- [ ] Conditions complete
- [ ] Actions complete
- [ ] Rules enumerated
- [ ] Completeness verified
- [ ] Consistency verified
- [ ] Redundancy addressed
- [ ] Default rule
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Loan approval**
- Input: Scope = loan approval, conditions = credit-score bucket + income-bucket + has-collateral + loan-to-income ratio, actions = approve / deny / manual-review
- Expected: Extended-entry table with ~12 rules; completeness verified; 1 inconsistency found between R3 and R7 (both match high-score + low-income but different actions) — resolved by narrowing R3.

**2. Shipping rate**
- Input: Conditions = order value, region, weight; action = rate tier
- Expected: Extended-entry with value ranges; 9 rules; 3 consolidated via don't-care; explicit default for unrecognized region.

**3. Email routing**
- Input: Conditions = subject keywords, sender domain, priority flag; action = queue assignment
- Expected: Limited-entry + extended-entry mixed; FIRST hit policy (priority-ordered); DMN export for workflow engine.

**4. Discount eligibility**
- Input: Conditions = customer tier, order value, season, new-customer; action = discount %
- Expected: Extended-entry; PRIORITY hit policy (best discount wins); consistency check flags overlap between "new customer" and "seasonal" discounts that compound.

**5. Compliance decision**
- Input: KYC compliance with multiple risk factors
- Expected: Limited-entry; complete coverage mandatory (regulated); any gap = compliance risk; explicit "manual review" for edge cases.

### Edge cases

**6. Continuous condition value**
- Input: "Age" as a continuous number
- Expected: Bucket into ranges (< 18, 18–64, ≥ 65); decision table on buckets; note continuous-to-bucket transformation.

**7. Conditions with history dependency**
- Input: "Customer has ordered in last 30 days"
- Expected: Accept as boolean condition; note "source" is a query (vs immediate field); idempotency considerations.

**8. Many actions can fire simultaneously**
- Input: Multiple discounts can apply
- Expected: COLLECT hit policy; actions listed with aggregation rule (stack / best-wins / sum).

### Failure cases

**9. No conditions**
- Input: "Make a decision table"
- Expected: Interview — "What's the decision scope, conditions, and actions?"

**10. Out of scope**
- Input: "Make decision table + code the rule engine"
- Expected: "Modeling only. Implementation is engineering (use a DMN engine like Camunda or Drools)."
