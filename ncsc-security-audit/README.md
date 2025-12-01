# NCSC Security Audit Plugin

Multi-agent NCSC ICT-beveiligingsrichtlijnen voor webapplicaties audit voor Claude Code. Produceert zowel technische als stakeholder-vriendelijke rapporten.

## Features

- **Multi-agent architectuur**: Drie gespecialiseerde agents werken samen voor uitgebreide analyse
- **Solution-aware**: Bepaalt automatisch welke NCSC richtlijnen relevant zijn op basis van solutietype
- **Dual reporting**: Genereert zowel technische ontwikkelaarsrapporten als niet-technische stakeholder samenvattingen
- **Iteratieve validatie**: Elke richtlijn wordt geanalyseerd en kruisgevalideerd voordat naar de volgende wordt gegaan
- **Nederlandse standaard**: Gebaseerd op de officiële NCSC richtlijnen (Juli 2024)

## Usage

```
/ncsc-security-audit
```

The command will first ask you to select a report language. English is the default, but you can specify any language supported by the LLM (Dutch, German, French, Spanish, Japanese, etc.).

## How It Works

### Fase 1: Discovery

De **Discovery Agent** analyseert de codebase om te bepalen:
- Solutietype (frontend, backend, full-stack, API, library)
- Gebruikte technologieën
- Welke van de 26 NCSC richtlijnen relevant zijn

Bijvoorbeeld, een frontend-only applicatie wordt niet geaudit op SSRF (U/WA.07) omdat er geen server-side requests zijn.

### Fase 2: Richtlijn Analyse

Voor elke relevante richtlijn werken twee agents parallel:

1. **Security Analyst Agent**: Diepgaande code-analyse op zoek naar kwetsbaarheden
2. **Verification Agent**: Kruisvalidatie van bevindingen en controle op gemiste issues

De agents bouwen consensus over bevindingen voordat ze doorgaan naar de volgende richtlijn.

### Fase 3: Rapport Generatie

Twee rapporten worden gegenereerd in `security-reports/`:

| Rapport | Doelgroep | Inhoud |
|---------|-----------|--------|
| `ncsc-audit-technical.md` | Ontwikkelaars | Code-locaties, remediatiestappen, PoC details |
| `ncsc-audit-summary.md` | Stakeholders | Begrijpelijke taal, zakelijke impact, prioriteiten |

## NCSC Richtlijnen Dekking

### U/TV - Toegangsvoorzieningsmiddelen

| ID | Richtlijn | Beschrijving |
|----|-----------|--------------|
| U/TV.01 | Authenticatie | Gebruikersauthenticatie en identiteitsvaststelling |

### U/WA - Webapplicaties

| ID | Richtlijn | Beschrijving |
|----|-----------|--------------|
| U/WA.01 | Sessiemanagement | Server-side sessiebeheer |
| U/WA.02 | Invoervalidatie | Server-side validatie van alle invoer |
| U/WA.03 | Uitvoerbeveiliging | XSS-preventie, CSP |
| U/WA.04 | SQL/NoSQL-injectie | Parameterized queries |
| U/WA.05 | OS command injection | Shell command beveiliging |
| U/WA.06 | Path traversal | Bestandstoegang beveiliging |
| U/WA.07 | SSRF | Server-side request forgery preventie |
| U/WA.08 | CSRF | Cross-site request forgery bescherming |
| U/WA.09 | API-beveiliging | API authenticatie en autorisatie |

### U/PW - Platformen en Webservers

| ID | Richtlijn | Beschrijving |
|----|-----------|--------------|
| U/PW.01 | HTTPS/TLS | TLS configuratie |
| U/PW.02 | Security headers | HTTP security headers |
| U/PW.03 | Foutafhandeling | Geen gevoelige info in errors |
| U/PW.04 | Logging | Security event logging |
| U/PW.05 | Server hardening | Server configuratie |
| U/PW.06 | Bestandsbeheer | Veilige file uploads |
| U/PW.07 | Dependencies | Dependency management |
| U/PW.08 | Secrets management | Veilig secrets beheer |

### U/NW - Netwerken

| ID | Richtlijn | Beschrijving |
|----|-----------|--------------|
| U/NW.01 | Netwerksegmentatie | Scheiding van componenten |
| U/NW.02 | WAF/Reverse proxy | Extra beschermingslaag |
| U/NW.03 | DNS-beveiliging | DNSSEC, CAA records |
| U/NW.04 | Ingress/Egress filtering | Verkeersfiltering |
| U/NW.05 | Load balancing | Beschikbaarheid |
| U/NW.06 | Service mesh | mTLS voor microservices |
| U/NW.07 | API Gateway | Centrale security controls |
| U/NW.08 | Container security | Container netwerkbeveiliging |

## Solution Type Matrix

Niet alle richtlijnen zijn van toepassing op alle solutietypes:

| Richtlijn | Frontend | Backend | Full-Stack | Library |
|-----------|----------|---------|------------|---------|
| U/TV.01 | Partial | Full | Full | N/A |
| U/WA.01-09 | Varies | Full | Full | Depends |
| U/PW.01-08 | Limited | Full | Full | Partial |
| U/NW.01-08 | N/A | Full | Full | N/A |

## Prioriteit Levels

De NCSC richtlijnen kennen drie prioriteitsniveaus:

| Prioriteit | Beschrijving | Actie |
|------------|--------------|-------|
| **Hoog** | Fundamentele beveiligingsmaatregel | Direct implementeren |
| **Midden** | Belangrijke verbetering | Plannen binnen 30 dagen |
| **Laag** | Best practice | Opnemen in roadmap |

## Report Structure

### Technisch Rapport

```
# NCSC ICT-Beveiligingsrichtlijnen Audit - Technisch Rapport

## Executive Summary
- Bevindingen per ernst

## Quick Reference Matrix
- Per-richtlijn status overzicht

## Gedetailleerde Bevindingen
- Per richtlijn:
  - Bevinding details met code-locaties
  - Aanvalsvectoren en PoC
  - Remediation code voorbeelden
  - Geïmplementeerde controls

## Prioriteringsmatrix Remediatie
- Geprioriteerde fix lijst

## Appendix
- Geanalyseerde bestanden
- Gebruikte zoekpatronen
- Agent consensus notities
- NCSC naar OWASP/ASVS mapping
```

### Stakeholder Rapport

```
# Beveiligingsbeoordeling Samenvatting

## Overzicht
- Begrijpelijke beoordeling status

## Risico Samenvatting
- Zakelijke impact per ernst

## Compliance Overzicht
- Richtlijn status met uitleg

## Belangrijkste Bevindingen
- Niet-technische uitleg
- Zakelijke impact
- Aanbevolen acties

## Wat Goed Gaat
- Positieve beveiligingspraktijken

## Aanbevolen Acties
- Direct / Korte termijn / Lange termijn

## Volgende Stappen
- Actieplan
```

## Requirements

- Claude Code CLI
- Toegang om projectbestanden te lezen

## Installation

Voeg deze plugin toe aan je Claude Code configuratie:

```bash
claude plugins add ncsc-security-audit
```

Of refereer naar de marketplace:

```bash
claude plugins add github:SSiertsema/claude-code-plugins/ncsc-security-audit
```

## Output Location

Rapporten worden gegenereerd in de `security-reports/` directory:

```
your-project/
├── security-reports/
│   ├── ncsc-audit-technical.md
│   └── ncsc-audit-summary.md
```

## Customization

De plugin gebruikt templates in `templates/` die aangepast kunnen worden:

- `ncsc-guidelines.md` - NCSC referentie en zoekpatronen
- `technical-report.md` - Ontwikkelaar rapport template
- `stakeholder-report.md` - Samenvatting rapport template

## Cross-Standard Mapping

De NCSC richtlijnen zijn gekoppeld aan andere standaarden via OpenCRE:

| NCSC | OWASP Top 10 | ASVS | ISO 27001 |
|------|--------------|------|-----------|
| U/TV.01 | A07 | V2, V3 | A.9 |
| U/WA.02-05 | A03 | V5 | A.14 |
| U/WA.07 | A10 | V11 | A.14 |
| U/PW.01 | A02 | V9 | A.10 |
| U/PW.07 | A06 | V14 | A.12 |

## Compliance Context

Deze plugin ondersteunt compliance met:

- **AVG/GDPR** - Europese privacywetgeving
- **BIO** - Baseline Informatiebeveiliging Overheid
- **NIS2** - Europese cybersecurity richtlijn
- **Wbni** - Wet beveiliging netwerk- en informatiesystemen

## License

MIT
