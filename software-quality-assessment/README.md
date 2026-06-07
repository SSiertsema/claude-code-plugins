# Software Quality Assessment

A Claude Code skill that **statically assesses a codebase against the ISO/IEC 25010:2023 product quality model**, applying **ISO/IEC 25023** measures wherever they can be derived from source. Stack-agnostic — point it at any repository.

## What it does

- Evaluates all **9 ISO/IEC 25010:2023 characteristics** (~40 sub-characteristics) from static evidence: source, tests, config, CI, dependency manifests, docs.
- Rates each applicable sub-characteristic **Pass / Partial / Fail** with `file:line` evidence.
- Scores each characteristic **0–10** (N/A excluded) and rolls up to an overall score with a rating band.
- Produces **severity-rated findings** (Critical / Warning / Info) with actionable recommendations.
- Applies **ISO/IEC 25023 measures**; runtime-only measures are labeled "not statically measurable" unless metrics are supplied.
- Emits a **Markdown report + JSON scorecard**, plus a **Mermaid radar + bar** (optional PNG export).

## The 9 characteristics

| # | Characteristic | Sub-characteristics |
|---|----------------|---------------------|
| 1 | Functional Suitability | completeness, correctness, appropriateness |
| 2 | Performance Efficiency | time behaviour, resource utilization, capacity |
| 3 | Compatibility | co-existence, interoperability |
| 4 | Interaction Capability | recognizability, learnability, operability, error protection, engagement, inclusivity, assistance, self-descriptiveness |
| 5 | Reliability | faultlessness, availability, fault tolerance, recoverability |
| 6 | Security | confidentiality, integrity, non-repudiation, accountability, authenticity, resistance |
| 7 | Maintainability | modularity, reusability, analysability, modifiability, testability |
| 8 | Flexibility | adaptability, scalability, installability, replaceability |
| 9 | Safety | operational constraint, risk identification, fail safe, hazard warning, safe integration |

## Usage

```
software-quality-assessment [path]            # defaults to current repo
software-quality-assessment . --focus security maintainability
software-quality-assessment . --metrics metrics.json   # compute runtime measures
```

## Scoring

`characteristic_score = ((passed×1 + partial×0.5) ÷ applicable) × 10`, overall = mean of the 9.

| Score | Band |
|---|---|
| 9.0–10 | Excellent |
| 7.0–8.9 | Good |
| 5.0–6.9 | Adequate |
| 0–4.9 | Inadequate |

## Boundaries

This skill **assesses** — it does not modify code, enforce pipeline gates, or run the app. For gates use `quality-gate-definition`; for NFR testing use `non-functional-test-planning`; for security audits use `owasp-security-audit` / `ncsc-security-audit`.

## Files

- `skills/software-quality-assessment/SKILL.md` — executable skill
- `skills/software-quality-assessment/reference/iso-25010-25023.md` — characteristic → measure mapping
- `skills/software-quality-assessment/reference/report-schema.json` — JSON scorecard schema

## License

MIT
