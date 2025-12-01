# NCSC ICT-Beveiligingsrichtlijnen Audit - Technisch Rapport

**Gegenereerd:** {{DATE}}
**Solutietype:** {{SOLUTION_TYPE}}
**Technologieën:** {{TECHNOLOGIES}}
**Scope:** {{SCOPE_COUNT}} van 26 richtlijnen van toepassing

---

## Executive Summary

| Ernst | Aantal |
|-------|--------|
| Kritiek | {{CRITICAL_COUNT}} |
| Hoog | {{HIGH_COUNT}} |
| Midden | {{MEDIUM_COUNT}} |
| Laag | {{LOW_COUNT}} |
| Info | {{INFO_COUNT}} |

**Algehele Status:** {{OVERALL_STATUS}}

---

## Quick Reference Matrix

### U/TV - Toegangsvoorzieningsmiddelen

| # | Richtlijn | Status | Kritiek | Hoog | Midden | Laag |
|---|-----------|--------|---------|------|--------|------|
| U/TV.01 | Authenticatie | {{UTV01_STATUS}} | {{UTV01_C}} | {{UTV01_H}} | {{UTV01_M}} | {{UTV01_L}} |

### U/WA - Webapplicaties

| # | Richtlijn | Status | Kritiek | Hoog | Midden | Laag |
|---|-----------|--------|---------|------|--------|------|
| U/WA.01 | Sessiemanagement | {{UWA01_STATUS}} | {{UWA01_C}} | {{UWA01_H}} | {{UWA01_M}} | {{UWA01_L}} |
| U/WA.02 | Invoervalidatie | {{UWA02_STATUS}} | {{UWA02_C}} | {{UWA02_H}} | {{UWA02_M}} | {{UWA02_L}} |
| U/WA.03 | Uitvoerbeveiliging | {{UWA03_STATUS}} | {{UWA03_C}} | {{UWA03_H}} | {{UWA03_M}} | {{UWA03_L}} |
| U/WA.04 | SQL/NoSQL-injectie | {{UWA04_STATUS}} | {{UWA04_C}} | {{UWA04_H}} | {{UWA04_M}} | {{UWA04_L}} |
| U/WA.05 | OS command injection | {{UWA05_STATUS}} | {{UWA05_C}} | {{UWA05_H}} | {{UWA05_M}} | {{UWA05_L}} |
| U/WA.06 | Path traversal | {{UWA06_STATUS}} | {{UWA06_C}} | {{UWA06_H}} | {{UWA06_M}} | {{UWA06_L}} |
| U/WA.07 | SSRF | {{UWA07_STATUS}} | {{UWA07_C}} | {{UWA07_H}} | {{UWA07_M}} | {{UWA07_L}} |
| U/WA.08 | CSRF | {{UWA08_STATUS}} | {{UWA08_C}} | {{UWA08_H}} | {{UWA08_M}} | {{UWA08_L}} |
| U/WA.09 | API-beveiliging | {{UWA09_STATUS}} | {{UWA09_C}} | {{UWA09_H}} | {{UWA09_M}} | {{UWA09_L}} |

### U/PW - Platformen en Webservers

| # | Richtlijn | Status | Kritiek | Hoog | Midden | Laag |
|---|-----------|--------|---------|------|--------|------|
| U/PW.01 | HTTPS/TLS | {{UPW01_STATUS}} | {{UPW01_C}} | {{UPW01_H}} | {{UPW01_M}} | {{UPW01_L}} |
| U/PW.02 | Security headers | {{UPW02_STATUS}} | {{UPW02_C}} | {{UPW02_H}} | {{UPW02_M}} | {{UPW02_L}} |
| U/PW.03 | Foutafhandeling | {{UPW03_STATUS}} | {{UPW03_C}} | {{UPW03_H}} | {{UPW03_M}} | {{UPW03_L}} |
| U/PW.04 | Logging | {{UPW04_STATUS}} | {{UPW04_C}} | {{UPW04_H}} | {{UPW04_M}} | {{UPW04_L}} |
| U/PW.05 | Server hardening | {{UPW05_STATUS}} | {{UPW05_C}} | {{UPW05_H}} | {{UPW05_M}} | {{UPW05_L}} |
| U/PW.06 | Bestandsbeheer | {{UPW06_STATUS}} | {{UPW06_C}} | {{UPW06_H}} | {{UPW06_M}} | {{UPW06_L}} |
| U/PW.07 | Dependencies | {{UPW07_STATUS}} | {{UPW07_C}} | {{UPW07_H}} | {{UPW07_M}} | {{UPW07_L}} |
| U/PW.08 | Secrets management | {{UPW08_STATUS}} | {{UPW08_C}} | {{UPW08_H}} | {{UPW08_M}} | {{UPW08_L}} |

### U/NW - Netwerken

| # | Richtlijn | Status | Kritiek | Hoog | Midden | Laag |
|---|-----------|--------|---------|------|--------|------|
| U/NW.01 | Netwerksegmentatie | {{UNW01_STATUS}} | {{UNW01_C}} | {{UNW01_H}} | {{UNW01_M}} | {{UNW01_L}} |
| U/NW.02 | WAF/Reverse proxy | {{UNW02_STATUS}} | {{UNW02_C}} | {{UNW02_H}} | {{UNW02_M}} | {{UNW02_L}} |
| U/NW.03 | DNS-beveiliging | {{UNW03_STATUS}} | {{UNW03_C}} | {{UNW03_H}} | {{UNW03_M}} | {{UNW03_L}} |
| U/NW.04 | Ingress/Egress filtering | {{UNW04_STATUS}} | {{UNW04_C}} | {{UNW04_H}} | {{UNW04_M}} | {{UNW04_L}} |
| U/NW.05 | Load balancing | {{UNW05_STATUS}} | {{UNW05_C}} | {{UNW05_H}} | {{UNW05_M}} | {{UNW05_L}} |
| U/NW.06 | Service mesh | {{UNW06_STATUS}} | {{UNW06_C}} | {{UNW06_H}} | {{UNW06_M}} | {{UNW06_L}} |
| U/NW.07 | API Gateway | {{UNW07_STATUS}} | {{UNW07_C}} | {{UNW07_H}} | {{UNW07_M}} | {{UNW07_L}} |
| U/NW.08 | Container security | {{UNW08_STATUS}} | {{UNW08_C}} | {{UNW08_H}} | {{UNW08_M}} | {{UNW08_L}} |

**Legenda:** PASS | FAIL | PARTIAL | N/A

---

## Gedetailleerde Bevindingen

<!-- Herhaal deze sectie voor elke van toepassing zijnde richtlijn -->

### {{GUIDELINE_ID}}: {{GUIDELINE_NAME}}

**Status:** {{GUIDELINE_STATUS}}
**Relevantie:** {{RELEVANCE_LEVEL}}
**Reden:** {{RELEVANCE_REASON}}

#### Bevindingen

<!-- Herhaal voor elke bevinding -->

##### {{FINDING_ID}}: {{FINDING_TITLE}}

| Eigenschap | Waarde |
|------------|--------|
| **Ernst** | {{SEVERITY}} |
| **Locatie** | `{{FILE_PATH}}:{{LINE_NUMBER}}` |
| **Inspanning** | {{EFFORT}} |
| **NCSC Maatregel** | {{NCSC_MEASURE}} |

**Beschrijving:**
{{DESCRIPTION}}

**Bewijs:**
```{{LANGUAGE}}
{{CODE_SNIPPET}}
```

**Aanvalsvector:**
{{ATTACK_VECTOR}}

**Proof of Concept:**
{{POC_STEPS}}

**Aanbeveling:**
{{RECOMMENDATION}}

**Remediation Code:**
```{{LANGUAGE}}
{{REMEDIATION_CODE}}
```

**Referenties:**
- {{REFERENCE_LINKS}}
- OpenCRE: {{OPENCRE_LINK}}

---

#### Geïmplementeerde Controls

| Control | Status | Locatie | Opmerkingen |
|---------|--------|---------|-------------|
| {{CONTROL_NAME}} | {{CONTROL_STATUS}} | `{{CONTROL_LOCATION}}` | {{CONTROL_NOTES}} |

#### Positieve Observaties

- {{POSITIVE_OBSERVATION}}

---

## Prioriteringsmatrix Remediatie

| Prioriteit | Bevinding ID | Titel | Ernst | Inspanning | Impact |
|------------|--------------|-------|-------|------------|--------|
| 1 | {{FINDING_ID}} | {{TITLE}} | {{SEVERITY}} | {{EFFORT}} | {{IMPACT}} |

### Prioriteitsberekening

Prioriteit wordt bepaald door:
1. **Ernst** - Kritiek > Hoog > Midden > Laag
2. **Inspanning** - Lage inspanning fixes geprioriseerd voor quick wins
3. **Impact** - Business impact van de kwetsbaarheid
4. **NCSC Prioriteit** - Hoog > Midden > Laag uit de richtlijnen

---

## Technische Schuld Items

Niet-kritieke beveiligingsverbeteringen voor toekomstige overweging:

| Item | Richtlijn | Beschrijving | Inspanning |
|------|-----------|--------------|------------|
| {{ITEM}} | {{GUIDELINE}} | {{DESCRIPTION}} | {{EFFORT}} |

---

## Geanalyseerde Bestanden

### Hoog-risico Bestanden (handmatig gereviewed)

| Bestand | Risico Reden | Bevindingen |
|---------|--------------|-------------|
| {{FILE_PATH}} | {{RISK_REASON}} | {{FINDING_COUNT}} |

### Geautomatiseerde Scan Dekking

- Totaal gescande bestanden: {{TOTAL_FILES}}
- Configuratiebestanden: {{CONFIG_FILES}}
- Bronbestanden: {{SOURCE_FILES}}
- Testbestanden uitgesloten: {{TEST_FILES}}

---

## Tool Outputs

### Dependency Audit

```
{{NPM_AUDIT_OUTPUT}}
```

### Security Header Check

```
{{SECURITY_HEADERS_OUTPUT}}
```

---

## Appendix A: Gebruikte Zoekpatronen

```bash
# Patronen gebruikt tijdens analyse
{{SEARCH_PATTERNS}}
```

## Appendix B: Agent Consensus Notities

| Richtlijn | Analyst Bevinding | Verifier Bevinding | Consensus |
|-----------|-------------------|--------------------|-----------|
| {{GUIDELINE}} | {{ANALYST}} | {{VERIFIER}} | {{CONSENSUS}} |

---

## Appendix C: Woordenlijst

| Term | Definitie |
|------|-----------|
| IDOR | Insecure Direct Object Reference |
| XSS | Cross-Site Scripting |
| CSRF | Cross-Site Request Forgery |
| SSRF | Server-Side Request Forgery |
| CSP | Content Security Policy |
| HSTS | HTTP Strict Transport Security |
| JWT | JSON Web Token |
| SRI | Subresource Integrity |
| mTLS | Mutual TLS |
| WAF | Web Application Firewall |
| AVG/GDPR | Algemene Verordening Gegevensbescherming |
| BIO | Baseline Informatiebeveiliging Overheid |

---

## Appendix D: NCSC Compliance Mapping

| NCSC Richtlijn | OWASP Top 10 | ASVS | ISO 27001 |
|----------------|--------------|------|-----------|
| U/TV.01 | A07 | V2, V3 | A.9 |
| U/WA.01 | A07 | V3 | A.9 |
| U/WA.02 | A03 | V5 | A.14 |
| U/WA.03 | A03 | V5 | A.14 |
| U/WA.04 | A03 | V5 | A.14 |
| U/WA.05 | A03 | V5 | A.14 |
| U/WA.06 | A01 | V12 | A.14 |
| U/WA.07 | A10 | V11 | A.14 |
| U/WA.08 | A01 | V4 | A.14 |
| U/WA.09 | A01, A07 | V4 | A.9, A.14 |
| U/PW.01 | A02 | V9 | A.10 |
| U/PW.02 | A05 | V14 | A.14 |
| U/PW.07 | A06 | V14 | A.12 |
| U/PW.08 | A02 | V6 | A.10 |

---

*Rapport gegenereerd door NCSC Security Audit Plugin met multi-agent analyse.*
