# Story Splitting — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | story-splitting |
| **Version** | 1.0.0 |
| **Purpose** | Splits oversized user stories into INVEST-compliant vertically-sliced sub-stories using SPIDR (Spike / Path / Interface / Data / Rule) as default mnemonic or Richard Lawrence's 9-pattern catalog (workflow steps / business-rule variations / simple-first / data variations / data-entry methods / defer performance / CRUD operations / break-out spikes / major effort) as superset. Every sub-story must deliver user value independently (vertical slice end-to-end: data → logic → UI) — not horizontal technical layers that only work when assembled. Per sub-story captures ID (related to parent), story in As-a-I-want-so-I-can form, pattern used + rationale, parent-slicing rationale, user value delivered independently, size estimate, dependencies, risk-reduction contribution. Runs post-split INVEST check with "V-test" as critical gate (if a sub-story fails Valuable = it's a technical slice, reject and re-slice). Recommends order (walking skeleton first → risk-reducing → high-value → quick wins → polish/edges). Explicitly flags when NOT to split (already small, all slices too coupled, ceremony overhead). Mermaid split-tree + optional pattern-usage pie with PNG export. Feeds `user-story-generator`, `planning-poker-protocol`, `acceptance-criteria-writing`. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `neutral` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Story estimated at 13+ points or obviously > 1 sprint
- Story with 7+ acceptance criteria covering varied concerns
- After `example-mapping` reveals multiple rules making story too big
- Risk-reduction slicing (ship walking skeleton first)
- Cross-platform / multi-region / multi-rule story needing incremental delivery

## When not to use

- Story already ≤5 points + clear AC → no split needed
- Research spike → it's a spike, not a story; don't pretend
- Horizontal technical split already happening (refactor vs feature) → different decomposition
- Backlog prioritization across many stories → `prioritization`
- Estimation itself → `story-point-estimation` / `planning-poker-protocol`

---

## Required input

| Field | Description |
|---|---|
| **Parent story** | Oversized story to split |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Why splitting** | Reason | Inferred |
| **Existing AC** | Helps identify split lines | — |
| **Target count** | N sub-stories | 2–4 |
| **Preferred pattern family** | SPIDR / Lawrence | SPIDR (default mnemonic) |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/story-splitting/` |

## Input schema

```
input:
  required:
    parent_story:
      type: string
  optional:
    reason: string
    existing_ac: list[string]
    target_count:
      type: integer
      min: 2
    pattern_family:
      type: string
      enum: [SPIDR, Lawrence-9]
      default: SPIDR
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
Collect parent + reason + existing AC + target count.

### Phase 2 — Pattern catalog
SPIDR (compact) or Lawrence 9-pattern (expanded).

### Phase 3 — Split proposal
Per sub-story: ID / story / pattern / rationale / value / size / deps / risk.

### Phase 4 — Post-split INVEST
Per sub-story, all 6 aspects; fail-V rejects split.

### Phase 5 — Value-slicing verification
"What does user get from this alone?" — must answer for each.

### Phase 6 — Recommended order
Walking skeleton → risk-reducing → high-value → quick wins → edges.

### Phase 7 — When not to split
Flag if splitting is wrong call.

### Phase 8 — Diagrams
Split tree + pattern-usage pie.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Story Splitting: [Parent story]

**Date**: [date]
**Parent story**: [yellow text]
**Original size**: [points]
**Sub-story count**: [N]
**Primary pattern(s)**: [SPIDR / Lawrence]

## Scope
[Parent, reason, AC, target]

## Split Pattern Used
[Pattern(s) + rationale]

## Sub-stories
[Per sub-story: full detail]

## Post-split INVEST
[Per sub-story: each aspect]

## Value-slicing Verification
[Each standalone user value]

## Recommended Order
[Sequence + rationale]

## When NOT to Split
[If flagging]

## Diagrams
[Split tree + pattern usage]

## Next Steps
[Feed sub-stories to user-story-generator + planning-poker-protocol]

## Assumptions & Limitations
[Caveats]
```

### Diagrams

- **Split tree** — Mermaid `flowchart`
- **Pattern usage** — Mermaid `pie` (optional)

---

## Generation and planning policy

- Vertical slicing
- INVEST post-split with V-test as critical gate
- Pattern declared per split
- Order recommended
- No fake splits (horizontal technical layers)

---

## Self-check

```
[] Parent story stated
[] Pattern declared per split
[] Per sub-story complete
[] Post-split INVEST verified
[] V-test passes for each
[] Order recommended
[] When-not-to-split addressed if applicable
[] Diagrams valid
[] No fake splits
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No parent story | Interview mode (§7) |
| Story already small | Flag; don't split |
| All slices fail V | Re-slice with different pattern |
| No pattern fits | Story may be atomic or need discovery |
| User wants 10 tiny stories | Flag ceremony overhead |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope | Pointer to correct skill |

---

## Quality checks

- [ ] Pattern declared
- [ ] Sub-stories INVEST-compliant
- [ ] V-test passes
- [ ] Recommended order
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Checkout story (13pts) split by Rule pattern**
- Input: "As a shopper I want to check out so I can buy" — 13pts, covers guest / loyalty / discount / split-payment
- Expected: 4 sub-stories — Guest checkout (5, walking skeleton), Saved card (3, Data), Discount code (5, Rule), Split payment (8, may need further split — flag). Order: walking skeleton → saved card → discount → split payment.

**2. Multi-region launch (Path + Data)**
- Input: "As a user I want to use [product] in my region"
- Expected: Sub-stories per region (US / UK / EU), using Data pattern. Walking skeleton = US; US delivers value standalone. UK / EU add regulatory-specific rules incrementally.

**3. Feature with research spike**
- Input: Story requires technical discovery
- Expected: Spike sub-story first (explicit, timeboxed), implementation sub-stories after. Spike doesn't pass V-test alone but is acknowledged exception.

**4. Multi-platform story (Interface pattern)**
- Input: "As a user I want [X] on web, iOS, Android"
- Expected: 3 sub-stories per platform. Walking skeleton = highest-traffic platform. Each platform slice independently valuable.

**5. Large rule-heavy story (Lawrence Business-rule variations)**
- Input: "As a finance team I want the tax engine to handle all EU VAT rules"
- Expected: Progressive sub-stories — simple case (basic VAT) → reverse-charge → OSS / IOSS → B2B vs B2C → one-stop-shop reporting. Each handles more rules incrementally.

### Edge cases

**6. Horizontal slicing attempt**
- Input: User proposes splits like "Build backend API" + "Build frontend" + "Add tests"
- Expected: Reject; V-test fails; re-slice vertically; each slice needs end-to-end delivery.

**7. Story really is atomic**
- Input: "As a user I want to log in with Google SSO"
- Expected: Honest "cannot split further without dark slices"; story is single atomic capability. Size may be larger but uncompromised.

**8. Overly-aggressive splitting**
- Input: User wants to split 5-point story into 10 1-point stories
- Expected: Flag ceremony overhead; 5 points is already well-understood; splitting into 10 increases sprint-planning cost without proportional benefit.

### Failure cases

**9. No parent story**
- Input: "Help me split stories"
- Expected: Interview — "Which story needs splitting?"

**10. Out of scope**
- Input: "Split + estimate + plan sprints"
- Expected: "Splitting only. Estimation: `planning-poker-protocol` / `story-point-estimation`. Sprint planning: backlog / capacity work."
