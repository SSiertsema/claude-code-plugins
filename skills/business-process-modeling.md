# Business Process Modeling — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | business-process-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Models business processes using BPMN 2.0 conventions. Produces structured specs with events (start / intermediate / end with subtypes: message / timer / signal / error / escalation / cancel / compensation / conditional / link), activities (task / subprocess / call-activity / service / user / manual / send / receive), gateways (exclusive / parallel / inclusive / event-based) with explicit conditions, flows (sequence / message / association), pools + lanes per actor or system, data objects + stores, and annotations. Per activity captures lane, type, verb-object description, inputs, outputs, SLA, exceptions. Per gateway captures type, condition, branches, data source. Supports three modes: `as-is` (current-state), `to-be` (future-state proposed), `gap` (delta comparison between both). Exception handling as alternative branches or error-boundary events with trigger / handler / compensation. Renders Mermaid flowchart (swimlane subgraphs approximating BPMN) and optionally emits BPMN 2.0 XML for Camunda / bpmn.io import. |
| **Primary category** | `generation` |
| **Secondary category** | `extraction` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Documenting current-state (as-is) business processes for audit / handover / training
- Designing future-state (to-be) processes for transformation or automation
- Process re-engineering — gap analysis between as-is and to-be
- Pre-automation discovery (RPA / workflow engines) — BPMN XML feeds into Camunda, etc.
- Cross-team process alignment where swim-lanes surface handoffs

## When not to use

- UI-level user flows → `user-flow-diagramming`
- Data flow between systems → `data-flow-diagramming`
- Strategic goals / objectives → `goal-decomposition`
- System context → `context-diagramming`
- Architecture component design → Phase 5 skills

---

## Required input

| Field | Description |
|---|---|
| **Process name** | Named process |
| **Mode** | as-is / to-be / gap |
| **Actors / roles / systems** | Pool + lane participants |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Process steps** | If known | Elicit |
| **Start + end events** | Scope boundaries | Elicit |
| **Exceptions in scope** | happy / selective / comprehensive | happy + selective |
| **BPMN XML output** | Emit `.bpmn` file | false |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/business-process-modeling/` |

## Input schema

```
input:
  required:
    process:
      type: string | document_reference
    mode:
      type: string
      enum: [as-is, to-be, gap]
    actors:
      type: list[object]
  optional:
    steps: list[object]
    start_end_events: object
    exceptions_scope:
      type: string
      enum: [happy, selective, comprehensive]
      default: selective
    emit_bpmn_xml:
      type: boolean
      default: false
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
Collect process + mode + actors + scope.

### Phase 2 — BPMN vocabulary
Events / activities / gateways / flows / pools-lanes / artifacts.

### Phase 3 — Per-activity spec
ID / lane / type / description / I/O / SLA / exceptions.

### Phase 4 — Per-gateway spec
Type / condition / branches / data source.

### Phase 5 — Exceptions
Trigger / handler / compensation.

### Phase 6 — Gap analysis (gap mode only)
As-is vs to-be delta per aspect + per-activity category.

### Phase 7 — Mermaid rendering
Swimlane flowchart approximating BPMN.

### Phase 8 — BPMN XML (optional)
`.bpmn` file with process definition.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Business Process Model: [Process]

**Date**: [date]
**Mode**: [as-is / to-be / gap]
**Actors**: [list]

## Scope
[Process, mode, actors, scope, exceptions]

## Actors / Pools / Lanes
[Pool + lane]

## Activities
[Table]

## Gateways
[Table]

## Flows
[Summary]

## Exception Handling
[Per exception]

## Diagram
[Mermaid swimlane flowchart]

## Gap Analysis (gap mode)
[Delta + per-activity category]

## BPMN XML (if requested)
[File reference]

## Assumptions & Limitations
[Coverage gaps, Mermaid-vs-BPMN fidelity notes]
```

### Diagrams

- **Process diagram** — Mermaid `flowchart` with subgraphs per pool/lane
- **Gap diagram** — Mermaid `flowchart` side-by-side (gap mode)

---

## Generation and extraction policy

- BPMN vocabulary strict
- Gateway semantics explicit
- As-is / to-be separated
- No fabricated activities

---

## Self-check

```
[] Process + mode declared
[] Actors + lanes
[] Scope start → end
[] BPMN vocabulary
[] Activities with I/O + lane
[] Gateways with condition + branches
[] Exceptions covered
[] Flows typed
[] Gap analysis if gap
[] Diagram valid
[] XML if requested
[] No fabricated activities
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No process | Interview mode (§7) |
| No actors | Ask |
| Unclear gateway condition | Require before diagramming |
| As-is + to-be mixed | Split |
| Scope wants exceptions but happy-path only | Expand or defer |
| mmdc failure | See `diagram-rendering` mixin |
| Automation request | Out-of-scope |

---

## Quality checks

- [ ] Mode declared
- [ ] BPMN vocabulary
- [ ] Per-activity complete
- [ ] Gateways with condition
- [ ] Exceptions
- [ ] Gap if gap mode
- [ ] Diagram valid

---

## Examples

### Normal cases

**1. Customer onboarding as-is**
- Input: Onboarding process, as-is mode, actors = customer + agent + KYC system + CRM
- Expected: 4 pools (with CRM + KYC as systems), ~12 activities, 3 gateways (KYC pass? / risk-score? / document complete?), exception paths for rejected KYC. Message flows customer ↔ agent.

**2. Purchase-to-pay to-be**
- Input: To-be procurement process
- Expected: Streamlined 8-activity flow (was 18 in as-is); 2 service-task automations; 1 intermediate timer event (approval SLA). BPMN XML emitted for Camunda.

**3. Gap analysis for claims handling**
- Input: Gap mode, insurance claims
- Expected: Side-by-side diagram; delta table (-5 handoffs, -3 days cycle time); per-activity: "Manual validation" removed / "Auto-fraud-check" added.

**4. Multi-system integration**
- Input: Process spanning 3 systems + 2 human roles
- Expected: 5 pools/lanes; message flows between systems; data objects shown; integration touch-points annotated.

**5. Simple approval workflow**
- Input: 3-step approval with escalation
- Expected: 3 lanes (requester / approver / escalation-target), 1 XOR gateway (approved?), 1 timer event (escalation after 24h), 2 end events (approved / rejected).

### Edge cases

**6. Process with parallel branches**
- Input: Steps can happen concurrently
- Expected: Parallel gateway (AND) clearly marked; merge waits for all branches; if incorrect AND/OR used, flag and propose correction.

**7. Long process (>30 activities)**
- Input: End-to-end order fulfillment
- Expected: Suggest decomposing into subprocesses (e.g., "Fulfill order" subprocess contains pick/pack/ship); show top-level + one drill-down.

**8. Process changes across regions**
- Input: Same process, different steps in EU vs US due to regulation
- Expected: Either two separate models OR one model with conditional region-specific branches; recommend based on variation density.

### Failure cases

**9. No process**
- Input: "Model a process"
- Expected: Interview — "Which process, and what mode?"

**10. Out of scope**
- Input: "Model + automate the process"
- Expected: "Modeling only; automation (RPA / workflow engine) is engineering work. BPMN XML from this skill feeds into those tools."
