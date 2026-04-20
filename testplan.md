# End-to-end walk door alle discipline skills

## Context

De marketplace bevat nu **151 discipline-skills + 16 overige plugins = 167 total** (commits `653e610..abf0657`). Geen van die 151 skills is ooit runtime-getest; de specs zijn alleen JSON-gevalideerd.

**Doel van dit plan**: één realistisch product-idee — **accounting SaaS voor NL freelancers** — als rode draad door de volledige pipeline trekken (Phase 1 → 6) zodat:

1. Elke relevante skill minstens één keer wordt ingeroepen met representatieve input
2. De hand-offs tussen skills (output A → input B) worden geverifieerd in de praktijk
3. Na afloop een **echte ship-ready product brief** ligt, die tegelijk test-bewijs is
4. Gaps, inconsistencies, en kapotte cross-references zichtbaar worden

**Depth**: ship-ready artifacts per skill (geen smoke-only). Realistisch effort: ~50–100 uur verspreid over weken.

**Wireframing**: skip + placeholder; wirekit v0.1.0 nog niet gedeployed.

---

## Product-brief (placeholder — jij vult aan)

- **Werkende naam**: [kies — bijv. `Freelio` / `Boekin` / `WorkDeskNL`]
- **Pitch**: accounting + facturering SaaS voor Nederlandse freelancers (ZZP'ers), met focus op eenvoud, BTW-aangifte, e-facturatie (EU-mandaat 2028), en koppelingen met banken (PSD2) + Belastingdienst.
- **Kernpersona's**: creatieve freelancer (DTP/foto), tech-freelancer (dev/consultant), trade-freelancer (klusbedrijf), accountant als secundaire gebruiker.
- **Competitie**: Moneybird, Tellow, e-Boekhouden, Visma eAccounting.
- **Strategisch**: mid-market SaaS met mogelijke partner-API voor accountants + banken.

*(Deze brief wordt verfijnd tijdens Wave 1 door `xplore`.)*

---

## Artifact-root

Alle output landt onder:

```
/documentation/[product-name]/
  01-strategy/
  02-validation/
  03-experience/
  04-requirements/
  05-ux-design/
  06-solution-architecture/
  07-infrastructure/
  08-api-integration/
  09-tech-spec/
  10-planning-readiness/
  11-team-change-comms/
  12-adrs-and-review/
```

Default per skill: `/documentation/[case]/[skill-name]/` — past daarbinnen.

---

## Aanpak: 12 waves

Elke wave ≈ 1 werkdag tot 1 werkweek. Waves zijn seriëel binnen (volgorde matters voor hand-offs), parallel mogelijk tussen onafhankelijke takken.

Conventies per wave:
- **Skill**: naam in marketplace
- **Input**: upstream artifact
- **Output**: downstream artifact
- **→ hand-off**: volgende skill in keten

---

### Wave 1 — Discovery + Strategy (Phase 1 core)

Doel: van idee naar business case + marktpositionering.

| # | Skill | Input | Output artifact |
|---|---|---|---|
| 1 | `xplore` | 1-pager pitch + jouw kennis | Context-summary + open vragen |
| 2 | `stakeholder-mapping` | context + domein (NL freelancers, accountants, banken, Belastingdienst) | Stakeholder-map + RACI-hint |
| 3 | `customer-segmentation` | context + marktbuckets | Segment-profielen (creatief / tech / trade / hybride) |
| 4 | `market-sizing` | segmenten + NL ZZP-statistieken | TAM/SAM/SOM + groeiprojectie |
| 5 | `competitive-analysis` | Moneybird / Tellow / e-Boekhouden / Visma | SWOT + Porter's Five Forces + TOWS |
| 6 | `trend-analysis` | PESTEL-scan (e-facturatie EU 2028, Belastingdienst API, PSD2) | Trends + megatrends + weak signals |
| 7 | `industry-benchmarking` | SaaS accounting benchmarks | Gap + P25/P50/P75 + maturity |
| 8 | `business-case-management` | alles hierboven | One-pager + Lean Canvas (full komt Wave 2) |

**Verificatie**: bestaat er nu een one-pager die sponsor-reviewable is? Dekt die markt + persona + voorlopige financials?

---

### Wave 2 — Validation (Phase 1 tail + Phase 2)

Doel: one-pager hardmaken met data, feasibility, risico.

| # | Skill | Input | Output |
|---|---|---|---|
| 9 | `survey-design` (optioneel) | segmenten | Enquête-ontwerp (Qualtrics/XLSForm) |
| 10 | `ideation` / `brainstorming` | personas + jobs-to-be-done | Feature shortlist |
| 11 | `empathy-mapping` | segmenten | Empathy-maps per persona |
| 12 | `affinity-diagramming` | research notes | Themes + insights |
| 13 | `feasibility-analysis` (technical / economic / operational) | feature-list | Feasibility-rapport |
| 14 | `regulatory-review` (GDPR / EU e-factuur / Belastingdienst OB-aangifte) | domain | Compliance-map |
| 15 | `risk-register-creation` | alles | Risk register (prob × impact + mitigaties) |
| 16 | `fmea` (optioneel) | kritieke flows | Failure modes-analyse |
| 17 | `poc-planning` (optioneel) | kritieke risicogebieden | PoC-plan per hypothese |
| 18 | `business-case-management` (full-form) | Wave 1 + bovenstaande | Full business case doc |
| 19 | `roadmapping` | objectives + releases | 12–18-maands roadmap |

**Verificatie**: kan de business case door een exec sponsor worden goedgekeurd? Zijn risico's expliciet?

---

### Wave 3 — Personas, Journeys, Business Processes

Doel: van segment naar concrete gebruikers + bestaande/gewenste flows.

| # | Skill | Input | Output |
|---|---|---|---|
| 20 | `persona-management` | segmenten + empathy-maps | 3–4 personas (bijv. Lisa de tech-freelancer) |
| 21 | `user-journey-management` | personas + jobs | Journeys (maandelijks factureren, BTW-aangifte Q1, bankreconciliatie) |
| 22 | `business-process-modeling` | journeys + Belastingdienst-cycle | BPMN-achtige processen (invoicing, OB-aangifte, IB-aangifte, reconciliatie) |

**Verificatie**: voelt een freelancer zich herkend? Staan top-5 pains expliciet?

---

### Wave 4 — Requirements (Phase 3)

Doel: testbare specificatie + story backlog.

| # | Skill | Input | Output |
|---|---|---|---|
| 23 | `business-requirements` | business case + journeys | Business requirements doc |
| 24 | `functional-specifications` | personas + journeys | Functional spec met use cases |
| 25 | NFR skills (performance / availability / a11y / security / i18n / privacy) | specifications | NFR-set met thresholds |
| 26 | `accessibility-requirements` | NFR security | WCAG 2.2 AA + NL-overheid a11y |
| 27 | `decision-table-creation` | complexe regels (BTW-tarieven, kleinschalig OB-regeling) | Decision tables |
| 28 | `example-mapping` | user stories (per feature-area) | Rules + examples + questions |
| 29 | `user-story-generator` | functional spec + personas | Backlog met stories |
| 30 | `acceptance-criteria-writing` | stories | Given-When-Then AC per story |
| 31 | `story-point-estimation` + `t-shirt-sizing` (indien apart) + `three-point-estimation` voor kritieke | backlog | Schattingen |
| 32 | `cost-estimation` + `timeline-estimation` | sizing | Budget + timing ranges |
| 33 | `traceability` | reqs ↔ stories ↔ tests (nog leeg) | Traceability matrix |
| 34 | `baseline-management` | goedgekeurde set | v1.0 baseline |
| 35 | `ab-hypothesis-framing` (voor top-3 onzekere features) | hypothesen | A/B frame per hypothese |

**Verificatie**: kan een nieuw team member de backlog begrijpen zonder jouw hulp?

---

### Wave 5 — Experience Design (Phase 4 partial)

Doel: IA + task flows + usability-plan. **Wireframing SKIP** (wirekit paused).

| # | Skill | Input | Output |
|---|---|---|---|
| 36 | `content-inventory-audit` | scope | Content-inventaris |
| 37 | IA skills (informatie-architectuur / card-sorting / tree-testing) | content + personas | Navigation + IA |
| 38 | `task-flow-diagramming` | journeys | Task flows per journey |
| 39 | `concept-sketching` (low-fi handschets in tekst) | IA + flows | Skribbles per scherm (tekstueel) |
| 40 | **[SKIP] `wireframing`** | — | Placeholder: `wirekit-pending.md` — revisit na wirekit v0.1.0 |
| 41 | `prototype-planning` | flows | Plan: wat Figma-prototype, welke flows |
| 42 | `cognitive-walkthrough` | IA + flows | Walkthrough-rapport |
| 43 | `usability-testing` | flows | Test plan + tasks + scenarios |

**Verificatie**: bestaat er een concrete UX-richting zonder pixelperfecte wireframes?

---

### Wave 6 — Solution Architecture (Phase 5 — solution + data + security)

Doel: architectonische kern.

| # | Skill | Input | Output |
|---|---|---|---|
| 44 | `architecture-pattern-selection` | context (team size, scale, regulatory) | Pattern keuze (modular monolith waarschijnlijk) |
| 45 | `architecture-tradeoff-analysis` | alternatives | Trade-offs per pattern |
| 46 | `ddd-strategic-modeling` | domain | Bounded contexts: Invoicing / Contacts / VAT / Bank / Identity |
| 47 | `context-diagramming` | contexts | C4-style context diagram |
| 48 | `adr-writing` (eerste batch) | major decisions | ADR-001..010 |
| 49 | `dependency-mapping` | contexts | Runtime + build dependencies |
| 50 | `build-vs-buy-analysis` (per component: auth / payments / email / OCR) | requirements | Buy/build beslissingen |
| 51 | `cost-benefit-analysis` + `financial-forecasting` | build/buy | 3-jaars TCO |
| 52 | `conceptual-data-modeling` | DDD | Entiteiten + relaties |
| 53 | `data-dictionary-definition` | model | Data dictionary |
| 54 | `data-flow-diagramming` | processen | DFD's |
| 55 | `database-technology-selection` | CAP + scale | Postgres + Redis keuze |
| 56 | `master-data-management` | Contacts / VAT codes | MDM strategie |
| 57 | `data-governance-policy` | GDPR + retentie | Data governance doc |
| 58 | `data-migration-strategy` (als freelancers van Moneybird/Tellow komen) | | Migratie plan |
| 59 | `event-sourcing-cqrs-design` (optioneel — vermoedelijk overkill) | | Beslissing: niet gebruiken, gemotiveerd in ADR |
| 60 | `threat-modeling` (STRIDE) | architectuur | Threat model |
| 61 | `attack-surface-analysis` | | Attack surface inventaris |
| 62 | `authentication-strategy-design` | | OAuth2 + passkey-ready |
| 63 | `authorization-modeling` | | RBAC + tenant isolation |
| 64 | `encryption-strategy` | | In-transit + at-rest + field-level voor BSN |
| 65 | `control-framework-mapping` | GDPR + ISO 27001 | Control matrix |
| 66 | `zero-trust-architecture` (light — SMB scope) | | Beperkte zero-trust review |

**Verificatie**: kan een nieuwe architect de keuzes uitleggen op basis van ADRs?

---

### Wave 7 — Infrastructure + Platform

Doel: runtime platform.

| # | Skill | Input | Output |
|---|---|---|---|
| 67 | `cloud-architecture-design` | Wave 6 | AWS eu-west-1 / GCP europe-west-4 choice + Well-Architected scan |
| 68 | `iac-planning` | cloud keuze | Terraform + layered modules + OIDC federation |
| 69 | `environment-strategy` | iac | dev / staging / prod / preview |
| 70 | `networking-design` | iac | VPC + subnets + hub-spoke (indien) |
| 71 | `cicd-pipeline-design` | envs | Pipeline met quality gates |
| 72 | `observability-strategy` | services | 3 pillars + SLO-burn alerts |
| 73 | `disaster-recovery-planning` | tiers | RPO/RTO + backup + failover |

**Verificatie**: kun je morgen een dev-omgeving spinnen op basis van het IaC-plan?

---

### Wave 8 — API + Integration

Doel: contracten + externe koppelingen.

| # | Skill | Input | Output |
|---|---|---|---|
| 74 | `api-design` | domeinen | REST voor extern + gRPC intern (waarschijnlijk REST-only gezien schaal) |
| 75 | `api-contract-specification` | design | OpenAPI 3.1 |
| 76 | `event-schema-design` | async flows (bank-webhook, factuur-publicatie) | CloudEvents + JSON Schema |
| 77 | `message-broker-selection` | events | SQS+SNS (AWS) of Pub/Sub (GCP) — geen Kafka nodig voor SMB |
| 78 | `integration-pattern-selection` | per koppeling | Outbox + saga/choreografie beslissingen |
| 79 | `third-party-api-evaluation` (batch): Stripe, Mollie, AdyenFlex, bank-PSD2-aggregatoren (Tink / Budget Insight), Belastingdienst-API, e-facturatie Peppol access point | per integratie | Per-vendor scorecard |
| 80 | `webhook-design` | inkomende + uitgaande | Webhook spec (HMAC + retry + replay) |
| 81 | `rate-limiting-throttling-strategy` | public + partner API | Ratelimit tiers |
| 82 | `api-versioning-strategy` | evolutie | URL-path + date-pinned hybrid |

**Verificatie**: kan een partner zonder jou gegaan een OpenAPI-contract lezen en starten?

---

### Wave 9 — Technical Specification

Doel: component-niveau.

| # | Skill | Input | Output |
|---|---|---|---|
| 83 | `component-design-documentation` (per major component — ~6 docs) | Wave 6/7/8 | Per-component design |
| 84 | `interface-specification` (ports + adapters) | componenten | Interface specs |
| 85 | `algorithm-design` (BTW-calculatie met rounding + suppletie + ICP; bankmatching) | | Algoritme-specs |
| 86 | `sequence-diagramming` (top-5 flows: place-invoice, bank-reconcile, VAT-filing, signup, password-reset) | | Sequence diagrams |
| 87 | `class-module-diagramming` | componenten | Class + module diagrammen |
| 88 | `system-error-handling-strategy` | systeem | Error classification + DLQ + retries |
| 89 | `logging-tracing-design` | | OpenTelemetry config |
| 90 | `configuration-management-design` | | Config + secrets plan |
| 91 | `dependency-injection-planning` | stack-keuze | DI plan |

**Verificatie**: kan een engineer een component bouwen op basis van de design doc + interface spec?

---

### Wave 10 — Planning & Readiness

Doel: leveringsplan + kwaliteit.

| # | Skill | Input | Output |
|---|---|---|---|
| 92 | `scope-statement-writing` | business case + waves hierboven | Scope statement v1.0 |
| 93 | `work-breakdown-structure` | scope | WBS met 100% rule + milestones |
| 94 | `license-compatibility-analysis` | dependencies | SBOM + compatibiliteit |
| 95 | `definition-of-ready-done` | team-context | DoR + DoD |
| 96 | `quality-gate-definition` | pipeline | Pipeline gates |
| 97 | `release-planning` | WBS + estimates | Gantt + CP |
| 98 | `vendor-evaluation-matrix` | outsourced components (email, OCR, bank-aggr) | Weighted scorecards |
| 99 | `rfp-rfi-creation` (voor 1–2 vendors) | vendor-shortlist | RFP draft |
| 100 | `test-strategy-plan` | architectuur | Test strategy |
| 101 | `test-automation-strategy` | strategy | Automation plan |
| 102 | `test-data-management-strategy` | data + GDPR | Synthetic + masking |
| 103 | `non-functional-test-planning` | SLOs + threats | Perf + security test plan |

**Verificatie**: is het plan credible? Past het binnen budget/timeline?

---

### Wave 11 — Team, Change, Comms

Doel: mensen + rollout.

| # | Skill | Input | Output |
|---|---|---|---|
| 104 | `team-topology-design` | scope + domeinen | Stream + platform split |
| 105 | `raci-responsibility-definition` | activities | RACI voor key activities, RAPID voor decisions |
| 106 | `onboarding-plan` | roles | Template + per-hire plan |
| 107 | `documentation-strategy` | audiences | Docs strategy (Diátaxis) |
| 108 | `documentation-tooling-selection` | strategy | Tool choice (Docusaurus + Redoc likely) |
| 109 | `change-impact-assessment` (voor launch) | plan | Impact matrix |
| 110 | `training-adoption-planning` | segmenten + features | Adoption plan |
| 111 | `support-rollback-planning` | launch | L1/L2/L3 + rollback |
| 112 | `communication-plan` | stakeholders | Comm matrix + templates |
| 113 | `demo-showcase-planning` | launch | Demo plan + follow-up template |

**Verificatie**: is het team klaar voor dag 1 na launch?

---

### Wave 12 — ADR-round + Security audits + Review

Doel: backfill + onafhankelijke review.

| # | Skill | Input | Output |
|---|---|---|---|
| 114 | `adr-writing` (tweede batch — decisions die in waves 6–11 ontstonden) | | ADR-011..030+ |
| 115 | `owasp-security-audit` | alle tech output | OWASP Top 10 rapport |
| 116 | `ncsc-security-audit` | idem | NCSC ICT-beveiliging rapport |
| 117 | `documentation-generator` | hele project | Project README + docs snapshot |
| 118 | `readme-generator` | repo-structuur | README per package |

**Verificatie**: zouden externe reviewers dit begrijpen + goedkeuren?

---

## Skills buiten de keten

Sommige skills fitten niet natuurlijk in dit product:

- `vue-development-skill`, `vue-reorder`, `vue-refactor-logic`, `ts-refactor-logic`, `js-refactor-logic`, `front-end-engineering` — dit zijn implementation-skills, niet discovery/design. Pas relevant als je daadwerkelijk code schrijft (buiten scope).
- `skill-manager` — meta-skill voor skills bouwen (niet testen). Gebruiken we alleen als er tijdens de walk bugs in bestaande skills opduiken.
- `agent-meeting-room` — orchestratie-plugin.
- Specifieke herhaling: sommige skills (bv. `survey-design`, `poc-planning`, `rfp-rfi-creation`) alleen runnen als hun context applicable is (anders skip + annoteer).

---

## Sessiestrategie

**Pragmatisch**:
- Eén wave per sessie van 2–4 uur (intens)
- Of één skill per kortere sit-down (30–60 min elk)
- Save-before-continue: elke skill eindigt met approval + save naar output-folder
- Elke sessie eindigt met een **wave-review**: wat werkte, welke skill bleek onduidelijk, welke output ontbrak

**Parallelle tracks** mogelijk:
- Wave 7 (Infrastructure) kan tegelijk met Wave 8 (API) nadat Wave 6 klaar is
- Wave 11 (Team) kan tegelijk met Wave 12 (ADRs) nadat Wave 10 klaar is

**Totaal (ship-ready)**:
- Waves 1–3: ~2 werkweken (dagdeel per dag)
- Waves 4–6: ~3–4 weken
- Waves 7–9: ~3 weken
- Waves 10–12: ~2 weken
- **Totaal: ~10–12 weken deeltijd** of ~4–5 weken fulltime

---

## Testverslag bijhouden

Tijdens de walk per skill registreren (dedicated file: `/documentation/[product]/00-skill-test-log.md`):

| Kolom | Voorbeeld |
|---|---|
| Skill | `business-case-management` |
| Wave | 1 |
| Gedraaid op | 2026-04-17 |
| Input kwaliteit | goed / marginaal / onvolledig |
| Output kwaliteit | 1–5 |
| Hand-off werkte | ja / nee / gedeeltelijk |
| Bugs / onduidelijkheden | wat miste / wat was fout |
| Fix nodig in skill? | ja (specifiek veld) / nee |

Na afloop: totaaloverzicht — welke skills werkten 1e keer, welke moesten geüpdated.

---

## Blockers + placeholders

1. **Wireframing** — `wirekit` v0.1.0 nog niet gedeployed. Placeholder-doc in Wave 5 plaatsen; skill draaien zodra wirekit live is.
2. **Echte freelancer-interviews** (Wave 2 survey-design) — optioneel; anders synthetisch uit jouw domain-kennis.
3. **Belastingdienst/Peppol sandbox-toegang** (Wave 8 third-party-api-evaluation) — vereist registratie; kan `[unknown]` blijven voor testrun.
4. Sommige skills uit memory bestaan mogelijk niet als aparte plugin (bijv. `business-requirements` / `roadmapping` / `story-point-estimation`). Tijdens Wave 4 ontdekken we precieze namen; ontbrekende skills → genereren via `skill-manager` of substitueren.

---

## Verificatie eind-oplevering

Na Wave 12 moet bestaan:

- `/documentation/[product]/` met ~100+ artifacts gestructureerd per wave
- `00-skill-test-log.md` met bevindingen per skill
- `adrs/` index van alle architecture-decisions
- `index.md` in root die het hele verhaal bindt (business case → launch)
- Lijst van skills die aangepast moeten worden (input voor follow-up sessie via `skill-manager`)

---

## Begin-prompt voor Wave 1

Jij (of Claude) start met:

```
/xplore

Ik heb een idee voor een accounting SaaS voor Nederlandse freelancers.
Werkende naam: [kies]. Ik wil dit idee uitwerken tot een ship-ready
product brief. Stel me de vragen om de context compleet te krijgen.
```

Dat stuurt Wave 1 in gang. De rest volgt de tabel.
