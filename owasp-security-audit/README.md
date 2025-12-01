# OWASP Security Audit Plugin

Multi-agent OWASP Top 10 security audit for Claude Code that produces both technical and stakeholder-friendly reports.

## Features

- **Multi-agent architecture**: Three specialized agents collaborate for comprehensive analysis
- **Solution-aware**: Automatically determines which OWASP guidelines are relevant based on your solution type
- **Dual reporting**: Generates both technical developer reports and non-technical stakeholder summaries
- **Iterative validation**: Each guideline is analyzed and cross-validated before proceeding

## Usage

```
/owasp-security-audit
```

The command will first ask you to select a report language. English is the default, but you can specify any language supported by the LLM (Dutch, German, French, Spanish, Japanese, etc.).

## How It Works

### Phase 1: Discovery

The **Discovery Agent** analyzes your codebase to determine:
- Solution type (frontend, backend, full-stack, API, library)
- Technologies in use
- Which of the 10 OWASP guidelines are relevant

For example, a frontend-only application won't be audited for SSRF (A10) since there are no server-side requests.

### Phase 2: Guideline Analysis

For each relevant guideline, two agents work in parallel:

1. **Security Analyst Agent**: Deep-dives into code searching for vulnerabilities
2. **Verification Agent**: Cross-validates findings and checks for missed issues

The agents build consensus on findings before proceeding to the next guideline.

### Phase 3: Report Generation

Two reports are generated in `security-reports/`:

| Report | Audience | Content |
|--------|----------|---------|
| `owasp-audit-technical.md` | Developers | Code locations, remediation steps, PoC details |
| `owasp-audit-summary.md` | Stakeholders | Plain language explanations, business impact, priorities |

## OWASP Top 10 Coverage

| ID | Guideline | Description |
|----|-----------|-------------|
| A01 | Broken Access Control | Authorization bypass, IDOR, privilege escalation |
| A02 | Cryptographic Failures | Weak encryption, exposed secrets, missing HTTPS |
| A03 | Injection | SQL, NoSQL, XSS, command injection |
| A04 | Insecure Design | Missing security controls, threat modeling gaps |
| A05 | Security Misconfiguration | Debug enabled, default credentials, missing headers |
| A06 | Vulnerable Components | Outdated dependencies, known CVEs |
| A07 | Authentication Failures | Weak auth, session issues, credential stuffing |
| A08 | Software/Data Integrity | Insecure CI/CD, unsigned updates, deserialization |
| A09 | Logging Failures | Missing audit logs, no alerting |
| A10 | SSRF | Server-side request forgery via user input |

## Solution Type Matrix

Not all guidelines apply to all solution types:

| Guideline | Frontend | Backend | Full-Stack | API | Library |
|-----------|----------|---------|------------|-----|---------|
| A01 | Partial | Full | Full | Full | Partial |
| A02 | Limited | Full | Full | Full | Depends |
| A03 | XSS | Full | Full | Full | Depends |
| A04 | Full | Full | Full | Full | Full |
| A05 | Headers | Full | Full | Full | Build |
| A06 | Full | Full | Full | Full | Full |
| A07 | Tokens | Full | Full | Full | N/A |
| A08 | CDN/SRI | Full | Full | Full | Full |
| A09 | Client | Full | Full | Full | Limited |
| A10 | N/A | Full | Full | Full | Depends |

## Report Structure

### Technical Report

```
# OWASP Top 10 Security Audit - Technical Report

## Executive Summary
- Finding counts by severity
- Overall status

## Quick Reference Matrix
- Per-guideline status overview

## Detailed Findings
- Per guideline:
  - Finding details with code locations
  - Attack vectors and PoC
  - Remediation code examples
  - Implemented controls

## Remediation Priority Matrix
- Prioritized fix list

## Appendix
- Files analyzed
- Search patterns used
- Agent consensus notes
```

### Stakeholder Report

```
# Security Assessment Summary

## Overview
- Plain language assessment status

## Risk Summary
- Business impact per severity

## Compliance Overview
- Guideline status with explanations

## Key Findings
- Non-technical explanations
- Business impact
- Recommended actions

## What's Working Well
- Positive security practices

## Recommended Actions
- Immediate / Short-term / Long-term

## Next Steps
- Action plan
```

## Requirements

- Claude Code CLI
- Access to read project files

## Installation

Add this plugin to your Claude Code configuration:

```bash
claude plugins add owasp-security-audit
```

Or reference the marketplace:

```bash
claude plugins add github:SSiertsema/claude-code-plugins/owasp-security-audit
```

## Output Location

Reports are generated in the `security-reports/` directory:

```
your-project/
├── security-reports/
│   ├── owasp-audit-technical.md
│   └── owasp-audit-summary.md
```

## Customization

The plugin uses templates in `templates/` that can be customized:

- `owasp-guidelines.md` - OWASP reference and search patterns
- `technical-report.md` - Developer report template
- `stakeholder-report.md` - Summary report template

## License

MIT
