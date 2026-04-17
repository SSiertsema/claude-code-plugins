# Traceability Matrix — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | traceability-matrix |
| **Version** | 1.0.0 |
| **Purpose** | Builds a requirements traceability matrix (RTM) linking artifacts across the delivery chain: goals → requirements → stories → tests → deployed artifacts, plus ADRs, risks, and regulated-context artifacts. Assigns stable ID schemes (G- / R- / S- / T- / ADR- / RR- / D-) that persist across changes. Captures links with a controlled type vocabulary (`derives-from` / `implements` / `verifies` / `validates` / `satisfies` / `mitigates` / `decided-by`), source attribution, rationale, and confidence. Produces forward-trace and backward-trace views, coverage computation per direction with explicit orphan lists (orphan goals / orphan requirements / orphan stories / unvalidated goals / homeless tests), change-impact helpers per artifact (upstream / downstream / risk), a regulatory overlay if in scope (ISO 13485, IEC 62304, FDA, SOC 2, aerospace, automotive), and Markdown + CSV exports. Feeds `impact-analysis`, `coverage-analysis`, and `baseline-management`. Mermaid coverage summary + sample-trace-chain diagrams with PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `planning` |
| **Output mode** | `hybrid` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Establish an RTM for a program or regulated product
- Audit preparation (ISO 13485, IEC 62304, FDA, SOC 2, aerospace)
- Cross-artifact coverage analysis before release
- Change impact baseline (feed `impact-analysis`)
- Surface orphans in an existing delivery pipeline

## When not to use

- Requirements elicitation → `functional-specifications` / `user-story-generator`
- Test planning → future QA skills
- Change-impact depth analysis → `impact-analysis`
- Coverage deep analysis → `coverage-analysis`
- Versioned baseline snapshots → `baseline-management`

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Program / product / release |
| **Artifact types** | Types in scope |
| **Sources** | Where artifacts live |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Regulatory context** | ISO 13485 / IEC 62304 / FDA / SOC 2 / none | None |
| **ID scheme** | Custom or default G/R/S/T/... | Default |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/traceability-matrix/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    artifact_types:
      type: list[string]
    sources:
      type: list[string]
  optional:
    regulatory_context: list[string]
    id_scheme: object
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
Collect subject + types + sources; interview mode (§7) if missing.

### Phase 2 — Artifact inventory
Stable IDs per type.

### Phase 3 — Link types
Controlled vocabulary with source + rationale + confidence.

### Phase 4 — Matrix views
Forward + backward + compact.

### Phase 5 — Coverage computation
Per-direction percentages + orphan lists.

### Phase 6 — Change impact helpers
Upstream / downstream / risk per artifact.

### Phase 7 — Regulatory overlay
Required traces + orphan severity if applicable.

### Phase 8 — Exports
Markdown + CSV.

### Phase 9 — Diagrams
Coverage summary + sample chain + optional orphan view.

### Phase 10 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 11 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Traceability Matrix: [Subject]

**Date**: [date]
**Subject**: [subject]
**Artifact types**: [list]
**Regulatory context**: [list or "none"]

## Scope
[Subject, types, sources, regulatory]

## Artifact Inventory
[Per type: prefix + count]

## Links
[Table per link]

## Forward Trace
[Goal → Req → Story → Test → Deployed]

## Backward Trace
[Test → Story → Req → Goal]

## Coverage
[Per-direction % + orphans]

## Change Impact Helpers
[Per artifact]

## Regulatory Overlay
[If applicable]

## Diagrams
[Coverage + sample chain + optional orphan view]

## Exports
[Markdown + CSV]

## Assumptions & Limitations
[Source gaps, confidence, retention]
```

### Diagrams

- **Coverage summary** — Mermaid `xychart-beta`
- **Sample trace chain** — Mermaid `flowchart`
- **Orphan view** — Mermaid `flowchart` (optional)

---

## Extraction and planning policy

- Stable IDs
- Controlled link vocabulary
- Source attribution
- Confidence labels
- Orphans surfaced

---

## Self-check

```
[] Stable IDs with prefix
[] Link types from vocabulary
[] Forward + backward views
[] Coverage per direction
[] Orphans surfaced
[] Change-impact helper
[] Regulatory overlay if applicable
[] Source + confidence per link
[] Markdown + CSV
[] Diagrams valid
[] No fabricated links
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject / sources | Interview mode (§7) |
| Existing IDs unclear | Propose scheme; confirm |
| Partial data | Process available, flag gaps |
| Regulated context + high orphan rate | Audit finding, not footnote |
| Tool-specific link formats | Normalize, preserve original |
| mmdc failure | See `diagram-rendering` mixin |
| Out-of-scope (impact depth) | Pointer to `impact-analysis` |

---

## Quality checks

- [ ] Stable IDs
- [ ] Typed links
- [ ] Forward + backward views
- [ ] Per-direction coverage
- [ ] Orphan lists
- [ ] Change-impact helpers
- [ ] Regulatory overlay
- [ ] CSV export
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. SaaS product release**
- Input: Release with 6 goals, 40 requirements, 120 stories, 300 tests
- Expected: Full matrix, 4 orphan requirements (stories without tests), 1 orphan goal (no E2E), coverage 95% reqs→stories, 78% stories→tests, CSV export.

**2. Medical device (IEC 62304)**
- Input: Class B software, 12 software requirements, 40 units, 150 tests
- Expected: Regulatory overlay triggered; orphans flagged as audit findings; software requirement → software unit → unit test → integration test chain verified.

**3. FinTech PCI program**
- Input: Compliance program with mappings to PCI-DSS v4 controls
- Expected: Controls as additional artifact type; traces from requirements to PCI clauses; evidence-type per link.

**4. Mid-project audit prep**
- Input: Existing project with lots of linking in various tools (Jira + Confluence + TestRail)
- Expected: Normalize link formats, produce unified matrix, CSV export for the auditor, orphan list as action items.

**5. Cross-team impact for an ADR change**
- Input: "What would changing ADR-017 impact?"
- Expected: Upstream + downstream for ADR-017 → affected requirements → affected stories → affected tests → affected deployed artifacts.

### Edge cases

**6. Many-to-many links**
- Input: Requirement satisfied by multiple deployed services
- Expected: Multiple `satisfies` links; compact matrix handles multi-value cells; CSV one row per link.

**7. ID collision risk**
- Input: Old IDs reused after deletion
- Expected: Flag as audit risk; propose de-duplication; never reuse going forward.

**8. Link confidence low**
- Input: Link inferred by heuristic (not explicitly asserted)
- Expected: Confidence label `low`; recommend human confirmation before accepting.

### Failure cases

**9. No sources**
- Input: "Build a traceability matrix"
- Expected: Interview — "Where do the artifacts live? What types are in scope?"

**10. Out of scope**
- Input: "Build matrix + do deep impact analysis for every requirement"
- Expected: "Matrix here; deep impact analysis in `impact-analysis`. The matrix feeds that skill."
