# Agent-Skill Orchestratie

Architectuur voor een portable multi-agent systeem waarin de main session als orchestrator fungeert, discipline-agents delegeert aan skills, en alles via de plugin marketplace wordt gedistribueerd.

---

## Architectuur

```
Main session (orchestrator via CLAUDE.md)
  │  kent: alle 40 disciplines, dependency graph, artifact conventies
  │
  ├─► market-researcher agent ──────► skills uit discipline-skills.md (ingebakken)
  ├─► stakeholder-analyst agent ────► skills uit discipline-skills.md (ingebakken)
  ├─► product-strategist agent ─────► skills uit discipline-skills.md (ingebakken)
  ├─► risk-manager agent ──────────► skills uit discipline-skills.md (ingebakken)
  ├─► solution-architect agent ─────► skills uit discipline-skills.md (ingebakken)
  ├─► ... (34 discipline agents)
  │
  ├─► /business-case-management ────► bestaande skill plugin
  ├─► /persona-management ─────────► bestaande skill plugin
  ├─► /user-journey-management ────► bestaande skill plugin
  ├─► /functional-specifications ──► bestaande command plugin
  ├─► /user-story-generator ───────► bestaande command plugin
  └─► /technical-specifications ───► bestaande command plugin
```

### Drie lagen

| Laag | Wat | Waar |
|------|-----|------|
| **Orchestrator** | Main session met CLAUDE.md kennis | Project CLAUDE.md |
| **Discipline agents** | Eén agent per discipline, kent z'n skills | `software-preparation` plugin → `agents/` |
| **Skills** | Uitvoerbare skills per discipline | Bestaande plugins in marketplace |

### Delegatielogica

- Agent heeft een bestaande skill → roept `/skill-name` aan
- Agent heeft geen bestaande skill → voert werk zelf uit met ingebakken skills/methoden uit `discipline-skills.md`
- Discipline vereist menselijke betrokkenheid → agent flagt dit (kennis uit `human-skills.md`)

---

## De 40 Disciplines

### Phase 1: Vision & Strategy
| # | Discipline | Agent | Bestaande skill? |
|---|-----------|-------|-----------------|
| 1 | Market Research & Analysis | market-researcher | — |
| 2 | Stakeholder Identification | stakeholder-analyst | — |
| 3 | Business Case Development | business-case-dev | `/business-case-management` |
| 4 | Product Strategy & Roadmapping | product-strategist | — |

### Phase 2: Exploration & Validation
| # | Discipline | Agent | Bestaande skill? |
|---|-----------|-------|-----------------|
| 5 | Ideation & Concept Development | ideation-facilitator | — |
| 6 | User Research | user-researcher | — |
| 7 | Feasibility Study | feasibility-analyst | — |
| 8 | Regulatory & Compliance Analysis | compliance-analyst | — |
| 9 | Risk Management | risk-manager | — |
| 10 | Proof of Concept (PoC) | poc-designer | — |

### Phase 3: Requirements
| # | Discipline | Agent | Bestaande skill? |
|---|-----------|-------|-----------------|
| 11 | Persona Development | persona-dev | `/persona-management` |
| 12 | Business Requirements Analysis | business-requirements-analyst | — |
| 13 | User Journey Mapping | journey-mapper | `/user-journey-management` |
| 14 | Functional Specification | functional-spec | `/functional-specifications` |
| 15 | Non-Functional Requirements | nfr-analyst | — |
| 16 | User Story Writing | story-writer | `/user-story-generator` |
| 17 | Requirements Prioritization | requirements-prioritizer | — |
| 18 | Requirements Traceability | traceability-analyst | — |

### Phase 4: Experience Design
| # | Discipline | Agent | Bestaande skill? |
|---|-----------|-------|-----------------|
| 19 | Information Architecture | information-architect | — |
| 20 | Interaction Design | interaction-designer | — |
| 21 | Accessibility Design | accessibility-designer | — |
| 22 | Visual / UI Design | visual-designer | — |
| 23 | Prototyping | prototyper | — |
| 24 | Usability Testing | usability-evaluator | — |

### Phase 5: Architecture & Technical Design
| # | Discipline | Agent | Bestaande skill? |
|---|-----------|-------|-----------------|
| 25 | Solution Architecture | solution-architect | — |
| 26 | Security Architecture | security-architect | — |
| 27 | Data Architecture & Modeling | data-architect | — |
| 28 | Infrastructure & Platform Design | infrastructure-designer | — |
| 29 | Integration Design | integration-designer | — |
| 30 | Technical Specification | technical-spec | `/technical-specifications` |

### Phase 6: Planning & Readiness
| # | Discipline | Agent | Bestaande skill? |
|---|-----------|-------|-----------------|
| 31 | Scope Definition & WBS | scope-planner | — |
| 32 | Legal Review | legal-reviewer | — |
| 33 | Definition of Done / Ready | dod-designer | — |
| 34 | Estimation & Planning | estimation-planner | — |
| 35 | Vendor & Procurement Management | vendor-manager | — |
| 36 | Quality Assurance Planning | qa-planner | — |
| 37 | Resource & Team Planning | resource-planner | — |
| 38 | Documentation Strategy | documentation-strategist | — |
| 39 | Change Management Planning | change-manager | — |
| 40 | Stakeholder Communication Planning | stakeholder-comms-planner | — |

---

## Dependency Graph

Uit `software-preperation-disciplines.md`:

```
1.1  Market Research ∥ Stakeholder ID
1.2  Business Case Development
1.3  Product Strategy & Roadmapping
     ═══ GATE: Go/No-Go ═══
2.1  Ideation ∥ User Research
2.2  Feasibility ∥ Compliance Analysis
2.3  Risk Management
2.4  Proof of Concept
     ═══ GATE: Validated Concept ═══
3.1  Personas ∥ Business Requirements  ──► 5.1 Solution Architecture
3.2  Journey Maps
3.3  Functional Spec ∥ Non-Functional Req ──► 5.2 Security ∥ Data ∥ Infrastructure Arch
     ├─► 4.1 Info Architecture          ──► 5.3 Integration Design
     ├─► 4.2 Interaction ∥ Accessibility ──► 5.4 Technical Spec
     ├─► 4.3 Visual/UI
     ├─► 4.4 Prototyping
     └─► 4.5 Usability Testing
3.4  User Stories
3.5  Prioritization
3.6  Traceability
     ═══ GATES: Requirements + Designs + Tech Blueprint ═══
6.1  Scope/WBS ∥ Legal ∥ DoD
6.2  Estimation ∥ Vendor ∥ QA Planning
6.3  Resource Planning ∥ Documentation Strategy
6.4  Change Management ∥ Stakeholder Comms
     ═══ GATE: Ready to Build ═══
```

`∥` = kan parallel draaien

---

## Artifact Conventies

Elke discipline schrijft output naar een vaste locatie:

```
documentation/
  vision/
    market-research.md            ← discipline 1
    stakeholder-map.md            ← discipline 2
    business-case.md              ← discipline 3
    product-strategy.md           ← discipline 4
  exploration/
    ideation.md                   ← discipline 5
    user-research.md              ← discipline 6
    feasibility-study.md          ← discipline 7
    compliance-analysis.md        ← discipline 8
    risk-register.md              ← discipline 9
    poc-report.md                 ← discipline 10
  requirements/
    personas/                     ← discipline 11
    business-requirements.md      ← discipline 12
    journeys/                     ← discipline 13
    functional-spec.md            ← discipline 14
    nonfunctional-requirements.md ← discipline 15
    user-stories/                 ← discipline 16
    prioritization.md             ← discipline 17
    traceability-matrix.md        ← discipline 18
  design/
    information-architecture.md   ← discipline 19
    interaction-design.md         ← discipline 20
    accessibility.md              ← discipline 21
    visual-design.md              ← discipline 22
    prototypes/                   ← discipline 23
    usability-report.md           ← discipline 24
  architecture/
    solution-architecture.md      ← discipline 25
    security-architecture.md      ← discipline 26
    data-architecture.md          ← discipline 27
    infrastructure.md             ← discipline 28
    integration-design.md         ← discipline 29
    technical-spec.md             ← discipline 30
  planning/
    wbs.md                        ← discipline 31
    legal-review.md               ← discipline 32
    definition-of-done.md         ← discipline 33
    estimation.md                 ← discipline 34
    vendor-management.md          ← discipline 35
    qa-plan.md                    ← discipline 36
    resource-plan.md              ← discipline 37
    documentation-strategy.md     ← discipline 38
    change-management.md          ← discipline 39
    stakeholder-comms.md          ← discipline 40
```

---

## Plugin Structuur (Portable)

### software-preparation plugin

```
software-preparation/
  .claude-plugin/
    plugin.json                   # "agents": "./agents/"
  agents/
    market-researcher.md          # discipline 1
    stakeholder-analyst.md        # discipline 2
    business-case-dev.md          # discipline 3 → delegeert naar /business-case-management
    product-strategist.md         # discipline 4
    ideation-facilitator.md       # discipline 5
    user-researcher.md            # discipline 6
    feasibility-analyst.md        # discipline 7
    compliance-analyst.md         # discipline 8
    risk-manager.md               # discipline 9
    poc-designer.md               # discipline 10
    persona-dev.md                # discipline 11 → delegeert naar /persona-management
    business-requirements-analyst.md  # discipline 12
    journey-mapper.md             # discipline 13 → delegeert naar /user-journey-management
    functional-spec.md            # discipline 14 → delegeert naar /functional-specifications
    nfr-analyst.md                # discipline 15
    story-writer.md               # discipline 16 → delegeert naar /user-story-generator
    requirements-prioritizer.md   # discipline 17
    traceability-analyst.md       # discipline 18
    information-architect.md      # discipline 19
    interaction-designer.md       # discipline 20
    accessibility-designer.md     # discipline 21
    visual-designer.md            # discipline 22
    prototyper.md                 # discipline 23
    usability-evaluator.md        # discipline 24
    solution-architect.md         # discipline 25
    security-architect.md         # discipline 26
    data-architect.md             # discipline 27
    infrastructure-designer.md    # discipline 28
    integration-designer.md       # discipline 29
    technical-spec.md             # discipline 30 → delegeert naar /technical-specifications
    scope-planner.md              # discipline 31
    legal-reviewer.md             # discipline 32
    dod-designer.md               # discipline 33
    estimation-planner.md         # discipline 34
    vendor-manager.md             # discipline 35
    qa-planner.md                 # discipline 36
    resource-planner.md           # discipline 37
    documentation-strategist.md   # discipline 38
    change-manager.md             # discipline 39
    stakeholder-comms-planner.md  # discipline 40
  context/
    discipline-map.md             # alle disciplines + skills (gecondenseerd)
    dependency-graph.md           # gestructureerde dependency graph
    artifact-conventions.md       # output locaties
    human-skills.md               # skills die menselijke betrokkenheid vereisen
  README.md                       # installatie-instructies + CLAUDE.md toevoegingen
```

### Bestaande skill plugins (ongewijzigd)

```
business-case-management/        # plugin met skill
persona-management/              # plugin met skill
user-journey-management/         # plugin met skill (als .claude/skills/)
functional-specifications/       # plugin met command
user-story-generator/            # plugin met command
technical-specifications/        # plugin met command
```

### Marketplace registratie

`software-preparation` wordt toegevoegd aan `.claude-plugin/marketplace.json`.

---

## Portability

### Installatie op een nieuwe machine

1. Clone/installeer de marketplace
2. Installeer `software-preparation` plugin → krijgt alle 40 agents + context
3. Installeer de skill plugins die je nodig hebt (business-case-management, persona-management, etc.)
4. Voeg orchestratie-sectie toe aan project CLAUDE.md (instructies in README)

### Wat reist mee met de plugin

| Component | Hoe portable? |
|-----------|--------------|
| 40 discipline agents | Via `software-preparation` plugin `agents/` |
| Discipline skills/methoden | Ingebakken in agent system prompts |
| Dependency graph | Via plugin `context/dependency-graph.md` |
| Artifact conventies | Via plugin `context/artifact-conventions.md` |
| Human skills referentie | Via plugin `context/human-skills.md` |
| Bestaande skills | Via hun eigen plugins in marketplace |
| Orchestratie kennis | Via CLAUDE.md (instructies in README) |

---

## Agent Template

Elk agent AGENT.md bestand volgt dit formaat:

```markdown
---
name: <agent-name>
description: <wanneer deze agent in te zetten — discipline beschrijving>
tools: Read, Grep, Glob, Write, WebSearch, WebFetch
model: sonnet
---

# <Discipline Naam>

Je bent een specialist in <discipline>. Je expertise omvat:

## Skills & Methoden

<skills uit discipline-skills.md voor deze discipline>

## Input

<wat je nodig hebt — artifacts van voorgaande disciplines>

## Output

<artifact pad uit artifact-conventions.md>
<verwacht formaat>

## Delegatie

<indien bestaande skill: "Gebruik /skill-name voor ...">

## Menselijke Betrokkenheid

<indien van toepassing: skills uit human-skills.md die menselijke input vereisen>
```

---

## Bouwvolgorde

### Stap 1: Plugin structuur + context bestanden
- `software-preparation/.claude-plugin/plugin.json`
- `software-preparation/context/discipline-map.md`
- `software-preparation/context/dependency-graph.md`
- `software-preparation/context/artifact-conventions.md`
- `software-preparation/context/human-skills.md`

### Stap 2: Agents voor het kritieke pad (Phase 1-2)
- market-researcher, stakeholder-analyst, product-strategist
- ideation-facilitator, feasibility-analyst, risk-manager, poc-designer
- business-case-dev (delegeert naar bestaande skill)

### Stap 3: Agents voor Phase 3 (gaten vullen)
- business-requirements-analyst, nfr-analyst, requirements-prioritizer, traceability-analyst
- persona-dev, journey-mapper, functional-spec, story-writer (delegeren naar bestaande skills)

### Stap 4: Agents voor Phase 4-5-6
- Alle overige agents

### Stap 5: CLAUDE.md orchestratie
- Discipline map referentie
- Dependency graph
- Artifact conventies
- Delegatie regels

### Stap 6: Marketplace registratie
- Toevoegen aan `.claude-plugin/marketplace.json`
