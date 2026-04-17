# Baseline Management — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | baseline-management |
| **Version** | 1.0.0 |
| **Purpose** | Captures, compares, releases, and (carefully) rolls back named baselines of a requirements / artifact set. A baseline is an immutable-once-released snapshot tied to a milestone (release, audit date, phase gate). Supports operations `capture` (draft) / `release` (promote) / `compare` (diff two baselines) / `rollback` (create a reversion baseline — not deletion) / `list` (timeline). Every baseline includes stable ID, type (Draft / Candidate / Released / Superseded), timestamps, author, approvers, artifact snapshots with content hashes for tamper-detection, evidence links (tests run, reviews, external approvals), parent-baseline link, and rationale. Diffs classify every change as backward-compatible / breaking / editorial, with breaking changes flagged for stakeholder communication. Evidence bundle attached per released baseline per regulatory retention. Audit trail is append-only. Release requires documented approvals and clean acceptance evidence. Mermaid timeline and diff-view diagrams with PNG export. |
| **Primary category** | `extraction` |
| **Secondary category** | `planning` |
| **Output mode** | `human_readable` |
| **Tone** | `formal` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Capture a release baseline before shipping
- Audit snapshot (ISO 13485, IEC 62304, FDA, aerospace, automotive, SOX)
- Phase gate sign-off
- Diff between two releases or two audit snapshots
- Rollback to a previously released baseline with rationale

## When not to use

- Building the traceability graph → `traceability-matrix`
- Change-impact analysis → `impact-analysis`
- Coverage analysis → `coverage-analysis`
- Version control of code artifacts → git / SCM
- Approval workflow orchestration → workflow tool

---

## Required input

| Field | Description |
|---|---|
| **Subject** | Baselined artifact set (program / product / release) |
| **Operation** | capture / compare / release / rollback / list |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Baseline name** | Human-readable | Required for capture / release / rollback |
| **Artifact types in scope** | Subset of RTM | All |
| **Source** | RTM / spec docs / other | Required for capture |
| **Comparison pair** | Baseline A + Baseline B | Required for compare |
| **Rollback rationale** | Reason + approver | Required for rollback |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/baseline-management/` |

## Input schema

```
input:
  required:
    subject:
      type: string | document_reference
    operation:
      type: string
      enum: [capture, compare, release, rollback, list]
  optional:
    baseline_name: string
    artifact_types: list[string]
    source: string | document_reference
    comparison_pair: object
    rollback_rationale: object
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
Collect subject + operation; interview mode (§7) if missing.

### Phase 2 — Schema
Baseline metadata, artifact snapshots, evidence links.

### Phase 3 — Operations
- **Capture** creates draft
- **Release** locks with approvals + hashes; supersedes prior
- **Compare** classifies changes (backward-compat / breaking / editorial)
- **Rollback** creates a new reversion baseline from a prior released baseline
- **List** shows timeline

### Phase 4 — Diff impact metrics
Counts + breaking-change ratio + downstream impact via RTM.

### Phase 5 — Evidence bundle
Approver sign-offs, test results, reviews, risk snapshot — retained per regulation.

### Phase 6 — History & audit trail
Append-only.

### Phase 7 — Governance integration
Change control + hotfix path + retention.

### Phase 8 — Diagrams
Baseline timeline + diff view (if compare).

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Baseline Management: [Subject]

**Date**: [date]
**Operation**: [op]
**Baseline**: [name]

## Scope
[Subject, operation, baseline, types]

## Operation Output
[capture / release / compare / rollback / list specifics]

## History
[Audit trail]

## Governance
[Change-control + retention]

## Diagrams
[Timeline + optional diff]

## Assumptions & Limitations
[Source gaps, approval evidence, retention]
```

### Diagrams

- **Baseline timeline** — Mermaid `timeline`
- **Diff view** — Mermaid `xychart-beta` (optional)

---

## Extraction and planning policy

- Stable baseline IDs
- Immutability of released baselines
- Deterministic diffs
- Append-only audit trail
- Rollback is a new baseline, not deletion

---

## Self-check

```
[] Operation declared
[] Baseline has name + type + approver + content hashes
[] Released baselines immutable
[] Diff classifies changes
[] Breaking flagged
[] Evidence bundle present (released)
[] Append-only history
[] Governance integration
[] Regulatory retention respected
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| Release without approvals | Block |
| Release with open critical issues | Block; allow explicit waiver |
| Rollback without rationale | Require |
| Diff between unrelated subjects | Block |
| Edit released baseline | Block — new baseline instead |
| mmdc failure | See `diagram-rendering` mixin |
| "Approve this for me" | Decline — human decision |

---

## Quality checks

- [ ] Stable baseline IDs
- [ ] Released baselines locked
- [ ] Diff classification
- [ ] Breaking flagged
- [ ] Evidence bundle
- [ ] Append-only trail
- [ ] Regulatory retention
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Release capture**
- Input: Subject = product X, operation = release, baseline = "v2.1 Release"
- Expected: Verify approvals + evidence, lock content hashes, supersede prior v2.0 baseline, attach evidence bundle (tests passed, reviewer sign-offs), timeline updated.

**2. Audit snapshot**
- Input: Operation = capture, baseline = "Audit 2026-Q1"
- Expected: Draft baseline with all in-scope artifacts, evidence links, not auto-released (audit team may require review).

**3. Compare v2.0 to v2.1**
- Input: Operation = compare, pair = v2.0 + v2.1
- Expected: Diff with counts, breaking-change list, downstream impact from RTM, classification per change.

**4. Rollback after defect**
- Input: Operation = rollback, source = v2.0, rationale = "Data corruption bug in v2.1"
- Expected: New reversion baseline v2.1.1-rollback cloning v2.0 content, rationale recorded, v2.1 marked Superseded (not deleted), communication plan pointer.

**5. List**
- Input: Operation = list
- Expected: Timeline of all baselines for subject with type, date, approver, short rationale.

### Edge cases

**6. Partial approvals**
- Input: Release request but one approver missing
- Expected: Block release; list missing approvals; recommend candidate-baseline until complete.

**7. Editorial-only diff**
- Input: Compare shows only typo fixes and formatting
- Expected: All changes classified editorial; no breaking changes; communication plan may be skipped.

**8. Regulatory retention triggered**
- Input: Subject under IEC 62304, baseline archive for 15 years
- Expected: Retention policy applied; cannot auto-delete; archival location noted.

### Failure cases

**9. Release without approvals**
- Input: Release attempt on a draft without sign-offs
- Expected: Block; list missing approvers.

**10. Edit released baseline**
- Input: User tries to modify a released baseline
- Expected: Block — "Released baselines are immutable. Capture a new baseline with the desired change."
