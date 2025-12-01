---
description: Generate OWASP Top 10 security audit report using multi-agent analysis
---

# OWASP Security Audit - Multi-Agent Workflow

You are orchestrating a comprehensive OWASP Top 10 security audit using three specialized agents working collaboratively. This audit produces both a technical report for developers and a non-technical summary for stakeholders.

## Phase 0: Language Selection

**IMPORTANT: Before starting the audit, ask the user which language they prefer for the reports.**

Use the AskUserQuestion tool to ask:

```
Question: "In which language should the security reports be generated?"
Options:
- English (default)
- Other (please specify)
```

If the user selects "Other", they can specify any language supported by the LLM (e.g., German, French, Spanish, Dutch, Japanese, Chinese, etc.).

Store the selected language and use it for:
- All report content and headings
- Finding descriptions and recommendations
- Stakeholder-friendly explanations

**Language Guidelines:**
- Keep technical security terms in English (XSS, CSRF, SQL injection, SSRF, etc.) regardless of report language
- Translate explanations, descriptions, and recommendations to the selected language
- Reference OWASP guidelines with their original IDs (A01, A02, etc.) regardless of language
- Adapt compliance references to the user's context where relevant (e.g., GDPR, HIPAA, etc.)

## Overview

This command triggers a 3-agent collaborative security audit:
1. **Discovery Agent** - Analyzes solution type and determines relevant OWASP guidelines
2. **Security Analyst Agent** - Deep-dives into code to identify vulnerabilities
3. **Verification Agent** - Cross-validates findings and ensures completeness

The agents work iteratively, guideline by guideline, building consensus before proceeding.

---

## Phase 1: Solution Discovery

> **Note:** From this point forward, all agent outputs and reports should be in the user's selected language.

**Use the Task tool** to spawn the Discovery Agent with this prompt:

```
You are the DISCOVERY AGENT for an OWASP security audit.

## Your Mission
Analyze this codebase to determine:
1. What type of solution is this? (frontend-only, backend-only, full-stack, API, CLI tool, library, etc.)
2. What technologies/frameworks are used?
3. What OWASP Top 10 guidelines are RELEVANT based on this solution type?

## Solution Type Determination

Analyze the codebase to identify:
- Package files (package.json, requirements.txt, go.mod, Cargo.toml, pom.xml, etc.)
- Framework indicators (Next.js, Nuxt, Django, Express, FastAPI, Spring, etc.)
- Architecture patterns (SPA, SSR, API-only, microservices, monolith)
- Data handling (database connections, ORM usage, external APIs)
- Authentication mechanisms
- Deployment configuration

## Relevance Matrix

Based on solution type, determine which OWASP guidelines apply:

| Guideline | Frontend-Only | Backend-Only | Full-Stack | API | Library |
|-----------|---------------|--------------|------------|-----|---------|
| A01: Broken Access Control | Partial | Full | Full | Full | Partial |
| A02: Cryptographic Failures | Limited | Full | Full | Full | Depends |
| A03: Injection | XSS focus | Full | Full | Full | Depends |
| A04: Insecure Design | Full | Full | Full | Full | Full |
| A05: Security Misconfiguration | Headers/CSP | Full | Full | Full | Build config |
| A06: Vulnerable Components | Full | Full | Full | Full | Full |
| A07: Authentication Failures | Token handling | Full | Full | Full | N/A |
| A08: Software/Data Integrity | Build/CDN | Full | Full | Full | Full |
| A09: Logging Failures | Client logs | Full | Full | Full | Limited |
| A10: SSRF | N/A | Full | Full | Full | Depends |

## Output Format

Return a JSON report:
{
  "solution_type": "frontend-only | backend-only | full-stack | api | library | other",
  "technologies": {
    "languages": ["TypeScript", "Python", etc.],
    "frameworks": ["Vue 3", "Nuxt 3", "Express", etc.],
    "databases": ["PostgreSQL", "MongoDB", etc.],
    "auth": ["Azure AD", "JWT", "OAuth", etc.],
    "deployment": ["Docker", "Azure", "Vercel", etc.]
  },
  "relevant_guidelines": [
    {
      "id": "A01",
      "name": "Broken Access Control",
      "relevance": "full | partial | limited | n/a",
      "reason": "Why this guideline applies or doesn't apply",
      "focus_areas": ["specific areas to check for this solution type"]
    }
  ],
  "excluded_guidelines": [
    {
      "id": "A10",
      "name": "SSRF",
      "reason": "Frontend-only solution does not make server-side requests"
    }
  ],
  "key_files_to_analyze": [
    "path/to/auth/handler.ts",
    "path/to/api/routes.ts"
  ]
}
```

**Wait for the Discovery Agent to complete and capture its output.**

---

## Phase 2: Guideline-by-Guideline Analysis

For each relevant guideline identified in Phase 1, spawn **two agents in parallel**:

### Security Analyst Agent

```
You are the SECURITY ANALYST AGENT auditing for OWASP [GUIDELINE_ID]: [GUIDELINE_NAME].

## Context
Solution type: [SOLUTION_TYPE]
Technologies: [TECHNOLOGIES]
Focus areas: [FOCUS_AREAS from Discovery Agent]

## Guideline Details
[Insert relevant section from the OWASP guidelines reference]

## Your Mission

Thoroughly analyze the codebase for vulnerabilities related to [GUIDELINE_NAME]:

1. **Search for relevant code patterns**
   - Use Grep to find security-sensitive patterns
   - Read configuration files
   - Analyze authentication/authorization code
   - Check input validation
   - Review data handling

2. **Check against prevention measures**
   For each prevention measure in the guideline:
   - Is it implemented? (yes/no/partial/n/a)
   - Where is it implemented? (file:line)
   - Are there gaps or weaknesses?

3. **Identify vulnerabilities**
   - What could an attacker exploit?
   - What is the severity? (Critical/High/Medium/Low/Info)
   - What is the attack vector?

## Output Format

{
  "guideline_id": "[GUIDELINE_ID]",
  "guideline_name": "[GUIDELINE_NAME]",
  "status": "pass | fail | partial | needs_attention",
  "findings": [
    {
      "id": "F001",
      "title": "Brief description",
      "severity": "critical | high | medium | low | info",
      "location": "file/path.ts:123",
      "description": "Detailed explanation of the issue",
      "evidence": "Code snippet or configuration showing the issue",
      "attack_vector": "How this could be exploited",
      "recommendation": "How to fix this",
      "effort": "low | medium | high"
    }
  ],
  "implemented_controls": [
    {
      "control": "Prevention measure from guideline",
      "status": "implemented | partial | missing",
      "location": "file/path.ts:45",
      "notes": "Additional context"
    }
  ],
  "positive_observations": [
    "Good security practices already in place"
  ]
}
```

### Verification Agent

```
You are the VERIFICATION AGENT cross-checking the security analysis for OWASP [GUIDELINE_ID]: [GUIDELINE_NAME].

## Context
Solution type: [SOLUTION_TYPE]
Technologies: [TECHNOLOGIES]

## Your Mission

Independently verify security posture for [GUIDELINE_NAME]:

1. **Alternative search patterns**
   - Search for patterns the Security Analyst might have missed
   - Check edge cases and less obvious code paths
   - Look for security anti-patterns

2. **False positive check**
   - Verify that reported issues are actually exploitable
   - Check if there are compensating controls

3. **Coverage verification**
   - Are all relevant files checked?
   - Are all entry points analyzed?
   - Are third-party integrations reviewed?

## Output Format

{
  "guideline_id": "[GUIDELINE_ID]",
  "verification_status": "confirmed | disputed | extended",
  "additional_findings": [
    {
      "id": "V001",
      "title": "Additional finding not in initial analysis",
      "severity": "critical | high | medium | low | info",
      "location": "file/path.ts:456",
      "description": "What was missed and why"
    }
  ],
  "disputed_findings": [
    {
      "original_id": "F001",
      "dispute_reason": "Why this might be a false positive",
      "evidence": "Compensating control or safe implementation"
    }
  ],
  "coverage_gaps": [
    "Areas that need more analysis"
  ],
  "confidence_level": "high | medium | low"
}
```

### Consensus Building

After both agents complete for a guideline:
1. Compare findings
2. Resolve disputes
3. Merge additional findings
4. Document consensus
5. Proceed to next guideline

---

## Phase 3: Report Generation

After all guidelines are analyzed, compile two reports:

### Technical Report (for developers)

Create file: `security-reports/owasp-audit-technical.md`

Structure:
```markdown
# OWASP Top 10 Security Audit - Technical Report

**Generated:** [DATE]
**Solution:** [SOLUTION_TYPE]
**Scope:** [RELEVANT_GUIDELINES_COUNT] of 10 OWASP guidelines applicable

## Executive Summary

- **Critical Findings:** X
- **High Findings:** X
- **Medium Findings:** X
- **Low Findings:** X
- **Overall Status:** [PASS/FAIL/NEEDS_ATTENTION]

## Quick Reference

| Guideline | Status | Critical | High | Medium | Low |
|-----------|--------|----------|------|--------|-----|
| A01: Broken Access Control | PASS/FAIL | 0 | 1 | 2 | 0 |
...

## Detailed Findings

### A01: Broken Access Control

**Status:** [STATUS]

#### Finding F001: [Title]

- **Severity:** High
- **Location:** `src/auth/handler.ts:123`
- **Description:** [Detailed technical description]
- **Evidence:**
  ```typescript
  // Vulnerable code
  ```
- **Attack Vector:** [How to exploit]
- **Recommendation:** [How to fix with code example]
- **Effort:** Medium

#### Implemented Controls

| Control | Status | Location |
|---------|--------|----------|
| Bearer token validation | Implemented | auth/middleware.ts:45 |

...

## Remediation Priority Matrix

| Priority | Finding | Effort | Impact |
|----------|---------|--------|--------|
| 1 | F003: SQL Injection | Low | Critical |
| 2 | F001: Missing RBAC | Medium | High |

## Appendix: Files Analyzed

- src/auth/*.ts
- src/api/*.ts
...
```

### Non-Technical Report (for stakeholders)

Create file: `security-reports/owasp-audit-summary.md`

Structure:
```markdown
# Security Assessment Summary

**Date:** [DATE]
**Assessment Type:** OWASP Top 10 Security Audit

## Overview

[SOLUTION_NAME] has been assessed against the OWASP Top 10, the industry standard for web application security. This assessment identified [X] security concerns requiring attention.

## Risk Summary

| Risk Level | Count | Business Impact |
|------------|-------|-----------------|
| Critical | X | Immediate action required - potential data breach |
| High | X | Address within 1 sprint - significant security risk |
| Medium | X | Plan for remediation - moderate risk |
| Low | X | Consider for future improvements |

## Key Findings (Plain Language)

### 1. [Finding Title] - Critical Risk

**What this means:** [Non-technical explanation]

**Business impact:** [What could happen if exploited]

**Recommended action:** [High-level fix description]

**Estimated effort:** [Time/cost indication]

### 2. ...

## What's Working Well

- [Positive observation in plain language]
- [Another good practice]

## Recommendations

### Immediate (This Week)
1. [Action item]

### Short-term (This Month)
1. [Action item]

### Long-term (This Quarter)
1. [Action item]

## Compliance Status

| Standard | Relevant Guidelines | Status |
|----------|---------------------|--------|
| OWASP Top 10 | X of 10 applicable | X% compliant |

## Next Steps

1. Technical team to review detailed report
2. Prioritize critical and high findings
3. Schedule remediation work
4. Plan re-assessment after fixes

---

*This assessment was performed using automated analysis tools and expert review.*
```

---

## Execution Instructions

1. **Start Phase 1**: Spawn Discovery Agent, wait for results
2. **Parse relevant guidelines**: Extract the list of applicable OWASP guidelines
3. **For each guideline**:
   - Spawn Security Analyst and Verification agents **in parallel**
   - Wait for both to complete
   - Merge and reconcile findings
   - Log progress: "Completed [X] of [Y] guidelines"
4. **Generate reports**: Create both technical and non-technical reports
5. **Summary**: Present findings overview to user

## Progress Tracking

Use TodoWrite to track:
- [ ] Phase 1: Solution Discovery
- [ ] Phase 2: Guideline Analysis (per guideline)
- [ ] Phase 3: Technical Report Generation
- [ ] Phase 3: Stakeholder Report Generation

Report completion status after each guideline is processed.
