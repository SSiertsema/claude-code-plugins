# Acceptance Criteria Writing — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | acceptance-criteria-writing |
| **Version** | 1.0.0 |
| **Purpose** | Writes, audits, or splits acceptance criteria for a user story, feature, or requirement with depth beyond the happy-path AC that `user-story-generator` produces. Default format Given/When/Then (Gherkin) with rules: one When per scenario (Gherkin best practice), behavior-level language not implementation, testable per AC. Enforces systematic coverage across happy path + ≥1 negative + ≥1 edge + ≥1 boundary + accessibility + optional performance / security / data / integration. Supports scenario outlines for parametric data variations and Background for shared preconditions. Applies INVEST both at story level (Independent / Negotiable / Valuable / Estimable / Small / Testable) and at individual AC level (each AC independent, single-focus, testable). When ACs reveal a story is too big (>5 scenarios or >1 week effort), proposes split using SPIDR (Spike / Path / Interface / Data / Rule) with concrete sub-story breakdown and AC allocation per sub-story. Three modes: `write` (default — new ACs from story), `audit` (evaluate existing ACs for coverage gaps + INVEST + leakage), `split` (decompose oversized story). Supports rule-based format + mixed format when Gherkin feels awkward. Mermaid coverage pie + split-proposal diagram with PNG export. Complements `user-story-generator`. |
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

- Add depth to existing user stories (beyond happy path)
- Audit AC quality across a backlog
- Split an oversized story into INVEST-compliant sub-stories
- Coach team on writing better Gherkin
- Generate ACs for regulatory / safety features needing systematic coverage

## When not to use

- Writing the user story itself → `user-story-generator`
- Story mapping / backlog structuring → future `story-mapping` skill
- Decision rules in dense tables → `decision-table-creation`
- Full use case with actors + flows → `use-case-writing`

---

## Required input

| Field | Description |
|---|---|
| **Story / feature / requirement** | The item ACs describe |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Mode** | write / audit / split | write |
| **Existing ACs** | For audit / split | — |
| **Format** | Gherkin / rule-based / mixed | Gherkin |
| **Coverage scope** | minimal / systematic / comprehensive | systematic |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/acceptance-criteria-writing/` |

## Input schema

```
input:
  required:
    story:
      type: string | document_reference
  optional:
    mode:
      type: string
      enum: [write, audit, split]
      default: write
    existing_acs: list[string]
    format:
      type: string
      enum: [Gherkin, rule-based, mixed]
      default: Gherkin
    coverage_scope:
      type: string
      enum: [minimal, systematic, comprehensive]
      default: systematic
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
Collect story + mode + format + coverage.

### Phase 2 — Scenario coverage matrix
Happy + negative + edge + boundary + a11y + optional perf/sec/data/integration.

### Phase 3 — Gherkin conventions
Given/When/Then, one When per scenario, scenario outlines for data, Background for shared preconditions.

### Phase 4 — INVEST check
Per story + per AC.

### Phase 5 — SPIDR split
If story too large: Spike / Path / Interface / Data / Rule split with sub-stories.

### Phase 6 — Rule-based format
When Gherkin awkward.

### Phase 7 — Mixed format
Rules + scenarios combined.

### Phase 8 — Audit (audit mode)
Per existing AC: coverage / INVEST / testability / gaps / leakage.

### Phase 9 — Split (split mode)
SPIDR pattern + sub-story breakdown + AC allocation.

### Phase 10 — Diagrams
Coverage + split proposal.

### Phase 11 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 12 — Report assembly and approval
Full report; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Acceptance Criteria: [Story / Feature]

**Date**: [date]
**Mode**: [write / audit / split]
**Format**: [Gherkin / rule-based / mixed]
**Coverage**: [minimal / systematic / comprehensive]

## Scope
[Story + mode + format + coverage]

## Story (restated)
[Original]

## Acceptance Criteria
[Gherkin scenarios + rules, organized by category]

## Coverage Matrix
[Category × count + gaps]

## INVEST Check
[Per-story + per-AC]

## Split Proposal (split mode)
[SPIDR + sub-stories + AC allocation]

## Audit Findings (audit mode)
[Per existing AC: analysis]

## Diagrams
[Coverage + split]

## Assumptions & Limitations
[Elicitation gaps]
```

### Diagrams

- **Coverage pie** — Mermaid `pie`
- **Split proposal** — Mermaid `flowchart` (split mode only)

---

## Generation and assessment policy

- Systematic coverage mandatory
- Gherkin: one When per scenario
- Behavior-level, not implementation
- INVEST at both levels
- SPIDR for splits
- No fabricated stories

---

## Self-check

```
[] Story stated
[] Mode + format declared
[] Systematic coverage (happy + negative + edge + boundary + a11y minimum)
[] Gherkin: one When per scenario
[] INVEST per story + per AC
[] Behavior-level, testable
[] Outlines for parametric data
[] Background for shared preconditions
[] SPIDR split if needed
[] Audit findings if audit mode
[] Diagrams valid
[] No implementation leakage
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No story | Interview mode (§7) |
| Vague story | Ask for concrete behavior |
| Implementation leakage | Rewrite |
| Story too big | Run split mode |
| Multi-When scenarios | Split |
| mmdc failure | See `diagram-rendering` mixin |
| Test automation request | Out-of-scope |

---

## Quality checks

- [ ] Systematic coverage
- [ ] INVEST verified
- [ ] Gherkin conventions
- [ ] Testability
- [ ] No implementation leakage
- [ ] Split if required
- [ ] Diagrams valid

---

## Examples

### Normal cases

**1. Write ACs for a login story**
- Input: "As a user I want to log in..."
- Expected: 6 scenarios — happy (valid creds), negative (wrong password + non-existent email), edge (case-insensitive email), boundary (max-length password), a11y (keyboard-complete + error announced via SR). INVEST passes.

**2. Audit existing backlog of 20 stories**
- Input: 20 stories with existing ACs (some thin, some leaking implementation)
- Expected: Per-story scorecard; flag 7 with implementation leakage, 4 with missing negative coverage, 2 oversized (recommend split); coverage pie shows happy-path-heavy.

**3. Split oversized "Onboarding" story**
- Input: 18-AC story for full onboarding
- Expected: SPIDR Path split into "Onboarding day 0 (signup)" + "Onboarding first session" + "Onboarding week 1 (activation)"; AC allocation per sub-story; each sub-story INVEST-compliant.

**4. Regulated feature with comprehensive coverage**
- Input: GDPR consent flow
- Expected: Coverage = comprehensive; includes audit / data / security categories; scenarios for consent given / withdrawn / updated / exported / deleted.

**5. Scenario outline for data variants**
- Input: Input validation with many valid / invalid email formats
- Expected: Scenario Outline + Examples table with ~8 rows covering valid + invalid formats; one parametric scenario replaces 8 explicit.

### Edge cases

**6. Story is really a question**
- Input: "As a user I want to know if I should upgrade"
- Expected: Ask for concrete user goal (not informational); reshape into action-oriented story before ACs.

**7. Cross-platform story**
- Input: "User completes task X" (web + iOS + Android)
- Expected: SPIDR Interface split → 3 stories, one per platform; or one story with platform-specific Background + shared scenarios.

**8. Story about non-functional requirement**
- Input: "System must handle 10k RPS at p95 <500ms"
- Expected: Mix of rule-based (NFR) + performance-category Gherkin ("When 10k concurrent requests hit endpoint X, then p95 response time < 500ms"); link to `performance-budgeting`.

### Failure cases

**9. No story**
- Input: "Write some ACs"
- Expected: Interview — "What's the story / feature / requirement?"

**10. Out of scope**
- Input: "Write ACs + implement the tests"
- Expected: "ACs only. Test automation is engineering work."
