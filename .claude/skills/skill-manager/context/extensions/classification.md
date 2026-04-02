# Skill-Type Extension: Classification

Applies to skills with `primary_category: classification`.
Inherits all rules from `shared-foundation.md`. This extension adds classification-specific rules.

---

## Purpose

Classification skills assign labels, categories, or decisions to input based on defined criteria. Examples: categorization, tagging, scoring, routing, prioritization, triage.

## Criteria rules

- Every classification skill MUST define its classification criteria explicitly
- Labels must come from a declared set (closed vocabulary) — not invented at runtime
- Every assigned label MUST be justified against the declared criteria
- If input does not clearly match any label, use a declared fallback (e.g., `unclassified`, `uncertain`)

## Confidence rules

- Every classification MUST include a confidence level: `high`, `medium`, or `low`
- Confidence reflects how clearly the input matches the criteria — not the agent's general certainty
- When confidence is `low`, the justification must explain what makes the classification uncertain
- Multi-label classification must report confidence per label

## Consistency rules

- Same input must produce the same classification (determinism)
- Borderline cases must be classified consistently with the declared tiebreaker rule
- If no tiebreaker rule exists, the skill must declare one

## Output contract (default)

```markdown
## Classification Result

### Input
- **Classified**: [what was classified]

### Result

| Item | Label | Confidence | Justification |
|---|---|---|---|
| ... | ... | high/medium/low | [why this label, against which criteria] |

### Borderline cases (if any)
| Item | Considered labels | Decision | Reason |
|---|---|---|---|
| ... | A, B | A | [tiebreaker reasoning] |
```

Or in machine-readable mode:

```json
{
  "classifications": [
    {
      "item": "...",
      "label": "...",
      "confidence": "high | medium | low",
      "justification": "..."
    }
  ]
}
```

## Self-check

```
□ Are all labels from the declared set?
□ Is every label justified against declared criteria?
□ Does every classification include a confidence level?
□ Are borderline cases explicitly addressed?
□ Would the same input produce the same output on rerun?
```

## Test requirements (in addition to foundation §14)

- **Label consistency**: Same input twice — verify same label
- **Confidence calibration**: Clear-cut input → high confidence; ambiguous input → low confidence
- **Criteria adherence**: Verify labels match declared criteria, not agent intuition
- **Boundary cases**: Test inputs that sit between two labels
