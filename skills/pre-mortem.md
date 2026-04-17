# Pre-mortem — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | pre-mortem |
| **Version** | 1.0.0 |
| **Purpose** | Facilitates a Gary Klein pre-mortem for a project or initiative. Premise: fast-forward to a horizon where the project has failed; retrospectively identify why. Writes a short imagined-failure narrative, elicits 10–20 failure modes across categories (strategic / execution / market-customer / technical / organizational / regulatory / external / team-people / measurement), clusters into 5–8 named groups (no "Other"), scores each cluster on Impact × Likelihood (1–5 each; composite 1–25), and produces preventive actions per top cluster with leading indicator, preventive action, contingency, and owner. Exports failure modes as "If X then Y" risk statements to feed `risk-register`, `mitigation-strategy-planning`, or `fmea`. Two modes: `autonomous` (the model enumerates failures) and `facilitation` (produces a facilitator guide for a team session with timeboxes and artifacts). Mermaid diagrams for cluster priority quadrant, failure-by-category pie, and optional leading-indicators timeline with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Creativity level** | `medium` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Kickoff or pre-launch moment — surface failure modes before committing
- Periodic checkpoints during long initiatives
- Complement qualitative risk analysis with imagination-led elicitation
- Input to `risk-register` and `mitigation-strategy-planning` with a rich failure-mode catalogue
- When forward-looking risk analysis feels shallow or over-optimistic

## When not to use

- Qualitative scoring alone → `risk-matrix`
- Failure-mode analysis at process/system level → `fmea`
- Probabilistic modeling → `monte-carlo-simulation`
- Persistent inventory → `risk-register`
- Mitigation action design → `mitigation-strategy-planning`

---

## Required input

| Field | Description |
|---|---|
| **Project / initiative** | Subject |
| **Horizon** | Date at which failure is stipulated |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Failure framing(s)** | How the failure is visible | Multiple framings applied |
| **Mode** | `autonomous` / `facilitation` | `autonomous` |
| **Participants** | For facilitation mode | — |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/pre-mortem/` |

## Input schema

```
input:
  required:
    project:
      type: string | document_reference
    horizon:
      type: string
  optional:
    framings:
      type: list[string]
    mode:
      type: string
      enum: [autonomous, facilitation]
      default: autonomous
    participants:
      type: list[string]
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
Collect project + horizon; detect framings and mode.

### Phase 2 — Imagined state
Short narrative stipulating failure.

### Phase 3 — Failure mode elicitation
10–20 modes across ≥4 categories.

### Phase 4 — Clustering
5–8 named clusters; no "Other".

### Phase 5 — Scoring
Impact × Likelihood per cluster (1–5 each). Composite max 25.

### Phase 6 — Preventive actions
Per top 3–5 clusters: leading indicator, preventive action, contingency, owner.

### Phase 7 — Risk export
Convert retained modes to "If X then Y" risks with inherent L/I and suggested response.

### Phase 8 — Diagrams
Cluster priority quadrant, failure-by-category pie, optional leading-indicators timeline.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Pre-mortem: [Project]

**Date**: [date]
**Horizon**: [date]
**Failure framings**: [list]
**Mode**: [autonomous / facilitation]
**Failure modes elicited**: [N]
**Clusters**: [N]

## Imagined State
[Narrative]

## Failure Modes
[Table]

## Clusters
[Per cluster: name, rationale, members]

## Scoring
[Impact × Likelihood × composite]

## Preventive Actions
[Per top cluster: leading indicator, action, contingency, owner]

## Risk Export
[Table for downstream]

## Diagrams
[Cluster priority + category pie + optional timeline]

## Facilitator Guide (if facilitation mode)
[Agenda + timeboxes + artifacts]

## Assumptions & Limitations
[No new data introduced]
```

### Diagrams

- **Cluster priority quadrant** — Mermaid `quadrantChart`
- **Failure modes by category** — Mermaid `pie`
- **Leading indicators timeline** — Mermaid `timeline` (optional)

---

## Generation and assessment policy

- Failure modes imagined but plausible given supplied context
- No fabricated events presented as facts
- `[Assumed]` on context inferences
- Scoring deterministic

---

## Self-check

```
[] Imagined state stated
[] 10–20 modes
[] ≥4 categories
[] 5–8 clusters, no "Other"
[] Impact × Likelihood per cluster
[] Top clusters have leading indicator + action + contingency + owner
[] Risks exported "If X then Y"
[] `[Assumed]` labels
[] No fabricated events
[] Diagrams valid
[] Facilitator guide if facilitation mode
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No project | Interview mode (§7) |
| No horizon | Ask; default 12 months with `[Assumed]` |
| Team resists stipulated failure | Reinforce premise |
| <10 failure modes | Prompt additional categories |
| All modes external / blameless | Challenge — often hides internal factors |
| Scoring converges on one cluster | Surface concentration |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Imagined state
- [ ] 10–20 modes
- [ ] Category diversity
- [ ] Clusters
- [ ] Scoring
- [ ] Top-cluster actions
- [ ] Risk export
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Product launch at 12 months**
- Input: "Launching new SaaS in 12 months"
- Expected: 15 failure modes across all categories, 6 clusters (e.g., "Product-market mismatch", "Execution velocity", "GTM readiness"), top cluster "Product-market mismatch" with leading indicator "low activation in early beta", preventive action "weekly usage review + kill criteria", contingency "pivot playbook", owner "PM".

**2. Platform migration at 9 months**
- Input: "Migrating monolith to microservices, 9-month program"
- Expected: Heavy Technical + Organizational categories, clusters include "Data migration scope", "Operational learning curve", "Team burnout". Actions target leading indicators like "error-rate trend during cutovers".

**3. Regulatory program at 18 months**
- Input: "Achieve ISO 27001 certification in 18 months"
- Expected: Organizational + Regulatory dominant. Clusters include "Insufficient evidence collection", "Scope-creep into non-essentials", "Auditor alignment". Leading indicators: evidence-collection velocity, open-finding count.

**4. Facilitation guide**
- Input: Mode = facilitation, 8 participants
- Expected: Full guide with timeboxes (5/10/15/15/10/15 min), artifacts (cards/board/dot-voting), rules reinforcement, exit criteria.

**5. Chain to risk-register**
- Input: Pre-mortem done, user wants to add risks to register
- Expected: Export table translates failure modes to "If X then Y" risks with inherent L/I and suggested response; feeds `risk-register` via its ingest.

### Edge cases

**6. Optimism-heavy team**
- Input: User notes team is over-confident
- Expected: Multiple framings used (e.g., "launched-but-unused", "never-launched", "shipped-then-killed") to broaden elicitation; facilitator guide emphasizes silent writing to counter groupthink.

**7. Very early-stage initiative**
- Input: Initiative still in shaping; limited context
- Expected: Strategic + market categories dominate; many `[Assumed]` context inferences; recommendation: repeat pre-mortem after initial scoping firms up.

**8. One cluster dominates scoring**
- Input: "Product-market mismatch" composite = 25, all others < 10
- Expected: Flag concentration; recommend decomposing the dominant cluster into 3–5 sub-clusters to surface distinct actions.

### Failure cases

**9. No project**
- Input: "Run a pre-mortem"
- Expected: Interview — "Which project or initiative? What horizon?"

**10. Out of scope**
- Input: "Pre-mortem and write the mitigation plan"
- Expected: "Pre-mortem elicits and prioritizes. For detailed action planning, see `mitigation-strategy-planning`."
