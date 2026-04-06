# Mixin: Autonomous Research

Applies to skills that declare `mixins: [autonomous-research]`.
Loaded alongside the category extension. Does not replace it.

---

## Purpose

Standardizes autonomous web research behavior for skills that gather data themselves rather than relying on user-provided data. Covers the research protocol, fact-grounding rules, assumption handling, source tracking, and output path conventions.

---

## Research autonomy declaration

Skills including this mixin operate under this principle:

> Research data yourself — do not ask the user for data they would need to look up. Only ask the user for decisions and confirmations.

The skill uses WebSearch and WebFetch to gather information autonomously. The user provides scope and approves findings, but does not supply raw data.

---

## WebSearch/WebFetch protocol

1. Use WebSearch to find relevant sources for the skill's domain
2. Use WebFetch to retrieve detailed content from promising sources
3. Cross-reference multiple sources for important claims
4. Prefer authoritative sources: industry reports, government data, academic research, established publications
5. Note publication dates — prefer recent data over dated sources
6. If a search returns no useful results, broaden the query or try alternative terms before reporting a gap

---

## Generation rules for web-sourced facts

| Rule | Description |
|---|---|
| **Facts** | Must come from web research — never fabricate market data, statistics, financial figures, or benchmark numbers |
| **Assumptions** | Always label explicitly as `[Assumption]` — state what was assumed and why |
| **Specificity** | Use specific data points ("12% market share in EMEA") not vague claims ("strong market position") |
| **Confidence** | When data quality is low or sources conflict, state the limitation explicitly |
| **Recency** | Note when data may be outdated; prefer sources from the last 2 years |

---

## Sources section contract

Every report must include a Sources section:

```markdown
## Sources
[Numbered list of all web sources consulted]
```

Each source entry includes:
- Source name or publication
- URL (if available)
- Date accessed or publication date
- Brief description of what was sourced from it

---

## Assumptions & Limitations section contract

Every report must include:

```markdown
## Assumptions & Limitations
[Explicit list of assumptions made and data gaps encountered]
```

---

## Output path convention

During setup, ask where to save the report:

> "Where should I save the report? Default: `/documentation/[case]/[skill-name]/`"

- Accept a custom path from the user
- Default to `/documentation/[case]/[skill-name]/` where `[case]` is the project/subject name and `[skill-name]` is the skill being executed
- Create the directory if it does not exist

---

## Failure behavior

| Situation | Behavior |
|---|---|
| Web search returns no results | Broaden query, try alternatives; if still nothing, state the gap and label confidence as low |
| Cannot access a specific source | Note the gap, proceed with other sources |
| Insufficient data for a section | Produce partial output, clearly label gaps and low-confidence findings |
| Conflicting sources | Present both perspectives, note the conflict, state which is more authoritative and why |

---

## Self-check additions

Skills including this mixin add these checks:

```
[] All major claims cite a web source or are labeled [Assumption]
[] Sources section lists all consulted sources with dates
[] Assumptions & Limitations section is present and complete
[] No fabricated data presented as fact
[] Specific data points used (not vague claims)
```
