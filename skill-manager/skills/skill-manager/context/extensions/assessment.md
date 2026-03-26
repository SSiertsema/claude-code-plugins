# Skill-Type Extension: Assessment

Applies to skills with `primary_category: assessment`.
Inherits all rules from `shared-foundation.md`. This extension adds assessment-specific rules.

---

## Purpose

Assessment skills evaluate input against defined criteria and produce findings with evidence, severity, and recommendations.

## Evidence rules

- Every finding MUST reference specific evidence from the input
- Evidence must use the most precise addressing available (see foundation §5)
- For code: `file/path.ext:line_number`
- For documents: section heading or paragraph number
- For data: field path (e.g., `payload.customer.email`)
- No vague findings — "the code could be improved" is never acceptable

## Severity classification

Assessment skills use these universal severity levels:

| Severity | Label | Definition | Criteria |
|---|---|---|---|
| 1 | **Critical** | Must fix — blocks release or creates immediate risk | Security vulnerability, data loss, broken core functionality, safety hazard, compliance violation |
| 2 | **Warning** | Should fix — creates debt or future risk | Missing error handling, poor testability, performance concern, code smell, maintainability issue |
| 3 | **Info** | Consider — opportunity for improvement | Style inconsistency, minor optimization, documentation gap, convention deviation |

### Severity rules
- These levels are FIXED — not subject to the agent's judgment
- Do not inflate severity to appear thorough
- Do not downplay severity to avoid being negative
- If no issues found at a level, say so — do not fabricate issues

## Recommendation rules

- Every finding MUST include a concrete, actionable recommendation
- "Consider improving this" is not actionable
- "Extract the payment logic from `OrderService` into a dedicated `PaymentService`" is actionable
- If no recommendation is possible, state why

## Anti-hallucination rules

- MUST NOT invent issues — if nothing found, say "No issues found"
- MUST distinguish fact from opinion: "Cyclomatic complexity is 25" (fact) vs "Consider extracting this" (recommendation)
- MUST NOT assess outside scope — only evaluate what was asked
- Same input should produce the same findings (determinism)

## Output contract (default)

Assessment skills produce this structure unless the skill overrides it:

```markdown
## Assessment Report

### Scope
- **Target**: [what was assessed]
- **Context**: [domain, language, framework]
- **Criteria**: [which criteria were evaluated]

### Summary
[One sentence: X critical, Y warnings, Z info items]

### Findings

| # | Criterion | Severity | Location | Finding | Recommendation |
|---|---|---|---|---|---|
| 1 | ... | Critical | `path:line` | ... | ... |

### Priority Actions
1. **[Critical]** ...
2. **[Warning]** ...
3. **[Warning]** ...

### Scores

| Criterion | Score | Notes |
|---|---|---|
| ... | Pass / Needs Work / Fail | ... |
```

## Self-check

Before presenting output, the agent verifies:

```
□ Does every finding reference specific evidence?
□ Did I apply severity rules correctly?
□ Does every finding include an actionable recommendation?
□ Did I avoid fabricating issues?
□ Is scope stated explicitly?
□ Is output in the correct contract format?
□ Are priority actions ordered by impact?
□ Did I assign scores to each assessed criterion?
```

## Test requirements (in addition to foundation §14)

Assessment skills must additionally test for:
- **False positives**: Input with no issues — verify no fabricated findings
- **False negatives**: Input with known issues — verify all are detected
- **Severity accuracy**: Known critical issue — verify it is classified as Critical, not Warning
