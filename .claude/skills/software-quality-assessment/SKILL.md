---
name: software-quality-assessment
description: Statically assess a codebase against the ISO/IEC 25010:2023 product quality model (9 characteristics, ~40 sub-characteristics), applying ISO/IEC 25023 measures where derivable from source. Produces a scored Markdown report + JSON scorecard with file:line evidence, severity-rated findings, recommendations, and Mermaid radar/bar diagrams.
argument-hint: "[path to repo, defaults to current] [--focus characteristic] [--metrics file]"
---

# Software Quality Assessment (ISO/IEC 25010:2023 + 25023)

Evaluate the **quality of a codebase** against the ISO/IEC 25010:2023 product quality model, using ISO/IEC 25023 measures wherever they can be derived from static evidence (source, tests, config, CI, dependency manifests, docs). Output a scored report and a machine-readable scorecard. **Stack-agnostic** — works on any repository.

This skill **assesses**; it does not modify code, enforce gates, or run the application.

## When this skill activates

- "Assess / evaluate the software quality of this codebase"
- "How does this project score against ISO 25010?"
- Baseline quality, pre-release quality review, or due-diligence audit
- Re-run to track quality trend over time

## When NOT to use (hand off instead)

| Request | Use instead |
|---|---|
| Define enforceable pass/fail pipeline gates | `quality-gate-definition` |
| Plan performance / security tests | `non-functional-test-planning` |
| Vue/Nuxt implementation-time QA | `vue-development` |
| Security pentest / formal security audit | `owasp-security-audit` / `ncsc-security-audit` |
| Maintainability CI thresholds only | `maintainability-criteria` |
| Evaluate a requirements/spec doc (no built system) | Out of scope — state this |

## Input

| Field | Required | Default |
|---|---|---|
| Target codebase path | Yes | Current repository |
| `--focus` characteristic(s) | No | All 9 |
| `--metrics` file (runtime data: coverage %, p99, incidents) | No | None — runtime-only measures marked not statically measurable |
| Stack hints / path exclusions | No | Auto-detect; exclude vendored/build dirs |
| `render_mode` (`code` \| `image`) | No | `code` (see diagram rendering) |

If no path is given and the current directory is not a code repository, enter interview mode to obtain the target. If a target is supplied but unreadable/empty, emit the structured `## Cannot proceed` error.

## Process

```
1. DETECT    → languages, framework, test + CI tooling, docs, dependency manifests
2. GATHER    → evidence per characteristic (source, tests, config, CI, deps, docs)
3. RATE      → each applicable sub-characteristic: Pass / Partial / Fail, with file:line evidence
4. MEASURE   → apply ISO/IEC 25023 measures where statically derivable;
               mark runtime-only measures "not statically measurable" (unless --metrics supplied)
5. SCORE     → per-characteristic 0–10 (N/A excluded); roll up to overall with rating band
6. FINDINGS  → severity-rate gaps (Critical / Warning / Info) with actionable recommendations
7. DIAGRAM   → Mermaid radar (9 scores) + bar (sub-characteristic coverage)
8. EMIT      → Markdown report + JSON scorecard
```

**See `reference/iso-25010-25023.md`** for the full characteristic → sub-characteristic → static evidence → 25023 measure mapping. Assess every characteristic against that reference; never assess from memory alone.

## Scoring

- Each applicable sub-characteristic is rated: **Pass = 1.0**, **Partial = 0.5**, **Fail = 0.0**.
- Characteristic score = `(sum of sub-characteristic ratings ÷ applicable sub-characteristics) × 10`.
- **N/A sub-characteristics are excluded** from the denominator — never counted as failures. Record them in `na`.
- Overall score = mean of the 9 characteristic scores (equal weight by default; honor user-supplied weights if given).

**Rating bands:**

| Score | Band |
|---|---|
| 9.0–10 | Excellent |
| 7.0–8.9 | Good |
| 5.0–6.9 | Adequate |
| 0–4.9 | Inadequate |

## Findings & severity (per assessment rules)

Every gap is a finding with **specific `file:line` evidence**, a fixed severity, and an actionable recommendation.

| Severity | Use for |
|---|---|
| **Critical** | Security vulnerability, data-loss risk, broken core functionality, safety/compliance violation |
| **Warning** | Missing error handling, poor testability, performance concern, maintainability debt |
| **Info** | Style inconsistency, minor optimization, documentation gap |

Do not inflate or downplay severity. If a characteristic has no issues, state "No issues found" — never fabricate findings. Distinguish fact (`cyclomatic complexity is 25`) from recommendation (`extract this function`).

## Output

### 1. Markdown report

```markdown
## Software Quality Assessment — ISO/IEC 25010:2023

### Scope
- **Target**: <repo/path> (<commit/branch if known>)
- **Stack**: <languages, framework, test + CI tooling>
- **Standards**: ISO/IEC 25010:2023 (model), ISO/IEC 25023 (measures)
- **Evidence basis**: static (+ supplied metrics, if any)

### Summary
Overall: <score>/10 (<band>). <X> Critical, <Y> Warning, <Z> Info findings.

### Scorecard
| Characteristic | Score | Band | Applicable / N/A |
|---|---|---|---|
| Functional Suitability | 8.3 | Good | 3 / 0 |
| ... | ... | ... | ... |

### Diagrams
<radar of 9 scores + bar of sub-characteristic coverage>

### Findings
| # | Characteristic · Sub-char | Severity | Location | Finding | Recommendation |
|---|---|---|---|---|---|
| 1 | Security · Integrity | Critical | `src/Comment.vue:31` | Unsanitized v-html sink | Replace v-html with text binding or sanitize with DOMPurify |

### 25023 Measures
| Measure | Characteristic | Value | Basis |
|---|---|---|---|
| Test coverage (statements) | Maintainability · Testability | 62% | derived from coverage config / report |
| Mean time between failures | Reliability · Faultlessness | not statically measurable | requires runtime/incident data |

### Priority Actions
1. **[Critical]** ...
2. **[Warning]** ...

### Limitations
- Runtime-dependent measures not computed (no --metrics supplied): <list>
- <other gaps, confidence notes>
```

### 2. JSON scorecard

Write to `.quality-reports/{uuid}.software-quality-assessment.json` conforming to `reference/report-schema.json`. Generate a UUID v4; timestamp in ISO-8601.

## Diagram rendering

Two diagrams: a **radar** of the 9 characteristic scores and a **bar** of sub-characteristic coverage (passed/applicable per characteristic).

- `render_mode: code` (default) — embed Mermaid code blocks in the report.
- `render_mode: image` — requires `@mermaid-js/mermaid-cli` (mmdc). Check with `which mmdc`; offer to `npm install -g @mermaid-js/mermaid-cli` only with explicit approval. Write `.mmd` sources, render `mmdc -i quality-radar.mmd -o quality-radar.png -t neutral -b transparent`, embed `![...](quality-radar.png)`, and omit code blocks. On render failure, fall back to `code` mode for the affected diagram and report it.
- Files (kebab-case): `quality-radar.mmd`/`.png`, `subcharacteristic-coverage.mmd`/`.png`.
- If Mermaid radar is unsupported in the environment, fall back to a bar chart of the 9 scores and state the limitation.

## Failure behavior

| Situation | Behavior |
|---|---|
| No path and cwd is not a repo | Interview for the target |
| Target unreadable / empty | `## Cannot proceed` (reason / missing / action) |
| Non-code target (docs only) | Note limited assessment; assess only what evidence supports |
| Runtime-only measure, no `--metrics` | Mark "not statically measurable"; do not estimate blindly |
| `--focus` given | Assess only those characteristics; state the narrowed scope |
| mmdc unavailable / fails | Fall back to `code` mode (see diagram rendering) |

## Self-check before emitting

```
[] Every characteristic addressed (or explicitly N/A / out of --focus)
[] Every finding has file:line evidence + fixed severity + actionable recommendation
[] No fabricated findings; "No issues found" used where clean
[] Runtime-only measures labeled, not guessed
[] N/A sub-characteristics excluded from denominators and recorded
[] Scores computed by the stated formula; overall band correct
[] Markdown report + JSON scorecard both produced; JSON matches schema
[] Diagrams valid; image mode has .mmd alongside .png and no code blocks
```

## Important rules

1. **Evidence or it didn't happen** — no finding without `file:line` (or precise reference).
2. **Never invent metrics** — anything not statically derivable is labeled, not estimated.
3. **Deterministic** — same codebase → same findings and scores.
4. **No scope creep** — assess quality against the model; hand off gate/test/security-audit work.
5. **Assess, don't modify** — never change the target code.
