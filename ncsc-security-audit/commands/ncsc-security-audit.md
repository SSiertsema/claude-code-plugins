---
description: Generate NCSC ICT-beveiligingsrichtlijnen security audit with technical and stakeholder reports
---

# NCSC ICT-Beveiligingsrichtlijnen Security Audit

You are initiating a multi-agent security audit based on the **NCSC ICT-beveiligingsrichtlijnen voor webapplicaties (Juli 2024)**. This audit will produce two reports: a technical report for developers and a non-technical summary for stakeholders.

## Phase 0: Language Selection

**IMPORTANT: Before starting the audit, ask the user which language they prefer for the reports.**

Use the AskUserQuestion tool to ask:

```
Question: "In which language should the security reports be generated?"
Options:
- English (default)
- Other (please specify)
```

If the user selects "Other", they can specify any language supported by the LLM (e.g., German, French, Spanish, Japanese, Chinese, etc.).

Store the selected language and use it for:
- All report content and headings
- Finding descriptions and recommendations
- Stakeholder-friendly explanations

**Language Guidelines:**
- Keep technical security terms in English (XSS, CSRF, SQL injection, SSRF, etc.) regardless of report language
- Translate explanations, descriptions, and recommendations to the selected language
- Reference NCSC guidelines with their original Dutch IDs (U/TV.01, U/WA.01, etc.) regardless of language
- Adapt compliance references to the user's context where relevant

## Reference Documents

Before proceeding, read the guidelines reference:
- `templates/ncsc-guidelines.md` - Full NCSC guidelines with search patterns

## Phase 1: Discovery

> **Note:** From this point forward, all agent outputs and reports should be in the user's selected language.

### Discovery Agent Task

Launch a **Discovery Agent** to analyze the solution and determine:

1. **Solution Type Classification**
   - Frontend-only (SPA, static site)
   - Backend-only (API, microservice)
   - Full-stack (frontend + backend)
   - Library/Package

2. **Technology Stack Detection**
   - Programming languages
   - Frameworks (Vue, React, Express, Django, etc.)
   - Databases
   - Authentication mechanisms
   - External integrations

3. **Guideline Relevance Matrix**

   Based on solution type, determine which NCSC domains and guidelines apply:

   | Domain | Description | Frontend | Backend | Full-Stack | Library |
   |--------|-------------|----------|---------|------------|---------|
   | U/TV | Toegangsvoorzieningsmiddelen | Partial | Full | Full | N/A |
   | U/WA | Webapplicaties | Full | Full | Full | Partial |
   | U/PW | Platformen en webservers | N/A | Full | Full | N/A |
   | U/NW | Netwerken | N/A | Full | Full | N/A |

**Output Required:**
```markdown
## Discovery Report

### Solution Type: [TYPE]

### Technologies Detected:
- [LIST]

### Applicable Guidelines:
| ID | Guideline | Relevance | Reason |
|----|-----------|-----------|--------|
| U/TV.01 | ... | Full/Partial/N/A | ... |
| U/WA.01 | ... | Full/Partial/N/A | ... |
...
```

## Phase 2: Guideline-by-Guideline Analysis

For each applicable guideline, launch TWO agents in parallel:

### Security Analyst Agent

Deep-dive analysis for each guideline:

1. **Search Phase**
   - Use the search patterns from `templates/ncsc-guidelines.md`
   - Identify all relevant code locations
   - Document file paths and line numbers

2. **Analysis Phase**
   - Evaluate implementation against NCSC requirements
   - Identify vulnerabilities or gaps
   - Assess severity (Kritiek/Hoog/Midden/Laag)
   - Document evidence with code snippets

3. **Recommendation Phase**
   - Provide specific remediation steps
   - Include code examples where applicable
   - Reference NCSC measure numbers

### Verification Agent

Cross-validate the Security Analyst's findings:

1. **Verification Phase**
   - Review analyst findings for accuracy
   - Check for false positives
   - Identify any missed vulnerabilities

2. **Consensus Building**
   - Confirm or dispute each finding
   - Add additional context if needed
   - Agree on final severity rating

### Iteration Protocol

For each guideline:

1. Both agents analyze independently
2. Compare findings
3. Build consensus on:
   - Confirmed vulnerabilities
   - Severity ratings
   - Remediation priorities
4. Document consensus before proceeding to next guideline

**Progress Tracking:**
```markdown
## Guideline Progress

| ID | Analyst | Verifier | Consensus | Status |
|----|---------|----------|-----------|--------|
| U/TV.01 | ✓ | ✓ | ✓ | Complete |
| U/WA.01 | ✓ | ✓ | In Progress | ... |
```

## Phase 3: Report Generation

After all applicable guidelines are analyzed, generate two reports:

### Technical Report (`security-reports/ncsc-audit-technical.md`)

Use template: `templates/technical-report.md`

Content:
1. Executive Summary with finding counts
2. Quick Reference Matrix (all guidelines)
3. Detailed Findings per guideline:
   - Finding ID and severity
   - Code location (file:line)
   - Evidence (code snippets)
   - Attack vector description
   - Remediation code examples
   - NCSC measure references
4. Implemented Controls (positive findings)
5. Remediation Priority Matrix
6. Appendix with search patterns used

### Stakeholder Report (`security-reports/ncsc-audit-summary.md`)

Use template: `templates/stakeholder-report.md`

Content:
1. Plain language overview
2. Risk summary (Critical/High/Medium/Low counts)
3. Compliance status per security domain
4. Key findings in non-technical language:
   - What the issue means
   - Business impact
   - Recommended action
5. What's working well (positive security practices)
6. Prioritized action items:
   - Immediate (this week)
   - Short-term (30 days)
   - Long-term (90 days)
7. FAQ section

## Execution Instructions

1. **Start Discovery Phase**
   ```
   Launch Discovery Agent with prompt:
   "Analyze this codebase to determine solution type, technologies,
   and which NCSC guidelines (U/TV, U/WA, U/PW, U/NW) are applicable.
   Reference templates/ncsc-guidelines.md for the full guideline list."
   ```

2. **Execute Guideline Analysis**
   For each applicable guideline, launch parallel agents:
   ```
   Security Analyst: "Analyze [GUIDELINE_ID]: [GUIDELINE_NAME] using
   search patterns from templates/ncsc-guidelines.md. Document all
   findings with file:line locations and severity ratings."

   Verification Agent: "Verify findings for [GUIDELINE_ID]. Check for
   false positives and missed vulnerabilities. Build consensus with
   the Security Analyst."
   ```

3. **Generate Reports**
   ```
   Create security-reports/ directory if it doesn't exist.
   Generate both reports using the templates.
   ```

## Quality Checklist

Before completing the audit:

- [ ] All applicable guidelines analyzed
- [ ] Consensus reached on all findings
- [ ] Technical report includes code locations
- [ ] Stakeholder report uses plain language
- [ ] Both reports saved to security-reports/
- [ ] Priority matrix is actionable

## Notes

- Focus on the NCSC priority levels: Hoog, Midden, Laag
- Reference OpenCRE mappings where applicable for cross-standard alignment
- Consider Dutch compliance context (AVG/GDPR, BIO)
- The NCSC guidelines are specifically designed for Dutch government and critical infrastructure
