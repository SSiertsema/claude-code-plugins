# Skill-Type Extension: Generation

Applies to skills with `primary_category: generation`.
Inherits all rules from `shared-foundation.md`. This extension adds generation-specific rules.

---

## Purpose

Generation skills create net-new content based on input, constraints, and context. Examples: drafting, writing, creating, composing, designing.

## Generation policy

Every generation skill MUST declare:

| Aspect | Declaration |
|---|---|
| **What may be invented** | Which parts of the output the agent may create freely |
| **What must be grounded** | Which parts must come from or be supported by the provided input |
| **What assumptions are allowed** | What the agent may assume if not stated in input |
| **What must never be fabricated** | Hard limits on invention (e.g., never invent data, quotes, citations) |

### Creativity level

Declared per skill from the controlled vocabulary:

- `none` — output is purely derived from input (borderline transformation)
- `low` — minor invention allowed (phrasing, transitions, structure)
- `medium` — content invention within declared boundaries
- `high` — creative freedom within topic and constraints

## Grounding rules

- Facts claimed in generated content must be traceable to input or declared as assumptions
- Generated opinions must be labeled as such
- When generating examples, data, or scenarios: label them as illustrative, not factual
- Never generate fake citations, references, or sources

## Constraint adherence

- The output contract and constraints take absolute precedence over creativity
- Length limits are hard limits, not suggestions
- Format requirements are mandatory
- If constraints conflict with quality, state the conflict — do not silently violate

## Output contract (default)

Generation skills produce the generated content directly, optionally preceded by:

```markdown
## Generated Output

### Parameters
- **Type**: [what was generated]
- **Creativity level**: [none / low / medium / high]
- **Grounded in**: [what input was used as basis]
- **Assumptions made**: [any assumptions, if applicable]

### Result
[generated content]
```

## Self-check

```
□ Does the output satisfy all declared constraints?
□ Are grounded claims traceable to input?
□ Are assumptions labeled as assumptions?
□ Is invented content within the declared creativity boundaries?
□ Are no fabricated facts, citations, or data presented as real?
□ Does the output match the declared format and length?
```

## Test requirements (in addition to foundation §14)

- **Constraint adherence**: Verify output respects all declared constraints (length, format, tone)
- **Hallucination checks**: Verify no fabricated facts, citations, or data
- **Grounding checks**: Verify grounded claims trace back to input
- **Boundary checks**: Verify invention stays within declared creativity boundaries
