# Skill-Type Extension: Transformation

Applies to skills with `primary_category: transformation`.
Inherits all rules from `shared-foundation.md`. This extension adds transformation-specific rules.

---

## Purpose

Transformation skills change the form of input while preserving defined aspects. Examples: rewriting, translating, reformatting, converting, summarizing.

## Preservation policy

Every transformation skill MUST declare what must be preserved:

| Aspect | Options |
|---|---|
| **Facts** | All facts / Named facts only / Not applicable |
| **Meaning** | Exact meaning / Approximate meaning / Gist only |
| **Structure** | Preserve structure / Restructure allowed |
| **Tone** | Preserve tone / Change to [specified tone] |
| **Terminology** | Preserve domain terms / Simplify allowed |
| **Named entities** | Must preserve exactly / May normalize |
| **Formatting** | Preserve / Adapt to output format |

### Preservation mode

Declared per skill from the controlled vocabulary:

- `strict` — preserve everything unless explicitly allowed to change
- `balanced` — preserve meaning and facts, allow form changes
- `flexible` — preserve core intent only, wide freedom in form

## What may change

The skill must also declare what is ALLOWED to change:
- Structure
- Length
- Tone
- Level of detail
- Language
- Format

If something is not listed as "may change," it must be preserved.

## Evidence rules

- When preservation is non-obvious, show the mapping (source segment → transformed segment)
- Flag any segment where meaning may have shifted during transformation
- If content was omitted (e.g., in summarization), state what was omitted and why

## Output contract (default)

Transformation skills produce the transformed content directly, optionally preceded by:

```markdown
## Transformation

### Parameters
- **Source**: [what was transformed]
- **Preservation mode**: [strict / balanced / flexible]
- **Changes applied**: [what was changed and why]

### Result
[transformed content]

### Notes (if applicable)
- [any segments where preservation was uncertain]
- [any content omitted and why]
```

## Self-check

```
□ Does the output preserve what the skill declares must be preserved?
□ Were only declared-allowed aspects changed?
□ Are uncertain preservation segments flagged?
□ Is omitted content stated (for summarization)?
□ Does the output match the declared output format?
```

## Test requirements (in addition to foundation §14)

- **Meaning preservation**: Transform and back-transform — verify core meaning survives
- **Fact preservation**: Check that specific facts from input appear in output
- **Named entity preservation**: Verify names, dates, numbers are intact
- **Instruction following**: Verify that declared changes were actually made
