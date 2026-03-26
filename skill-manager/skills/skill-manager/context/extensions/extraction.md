# Skill-Type Extension: Extraction

Applies to skills with `primary_category: extraction`.
Inherits all rules from `shared-foundation.md`. This extension adds extraction-specific rules.

---

## Purpose

Extraction skills pull structured information from unstructured or semi-structured input. Examples: parsing, data extraction, entity recognition, field mapping, metadata extraction.

## Source fidelity

- Every extracted field MUST be traceable to a specific location in the source input
- Extracted values must preserve the source's precision and meaning
- Do not normalize, interpret, or enhance extracted values unless the skill explicitly allows it
- If a field cannot be extracted, mark it as `null`, `missing`, or `uncertain` — do not guess

## Schema rules

Every extraction skill MUST define an output schema:
- Required fields (must always be present in output)
- Optional fields (present only if found in source)
- Field types (string, number, date, boolean, array, object)
- Field constraints (format, allowed values, ranges)

## Completeness rules

- Report extraction completeness: how many expected fields were successfully extracted
- Distinguish between "field not found in source" and "field found but uncertain"
- If the source is insufficient for the declared schema, state what is missing

## Output contract (default)

Extraction skills produce structured output:

```markdown
## Extraction Result

### Source
- **Input**: [what was processed]
- **Completeness**: [X of Y fields extracted]

### Extracted Data
[structured output — JSON, table, or as declared by the skill]

### Gaps
| Field | Status | Reason |
|---|---|---|
| ... | Missing / Uncertain | [why] |
```

Or in machine-readable mode:

```json
{
  "status": "complete | partial | failed",
  "completeness": "X/Y",
  "data": { },
  "gaps": [ ]
}
```

## Self-check

```
□ Is every extracted field traceable to a source location?
□ Are missing fields marked, not guessed?
□ Are uncertain fields labeled as uncertain?
□ Does the output match the declared schema?
□ Is completeness reported?
□ Were no values invented or inferred beyond what the source states?
```

## Test requirements (in addition to foundation §14)

- **Schema completeness**: Verify all required fields are present or explicitly marked as gaps
- **Source fidelity**: Verify extracted values match the source exactly
- **No hallucination**: Verify no fields were invented from outside the source
- **Partial input**: Test with source that only partially satisfies the schema
