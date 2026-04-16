# Software Preparation Disciplines — Timeline

All disciplines from inception to the start of technical creation/implementation, organized in optimal chronological phases with internal sequencing. Steps at the same level can run in parallel.

---

## Complete Process Timeline

```
TIME ══════════════════════════════════════════════════════════════════════════════════════════════►

PHASE 1: VISION & STRATEGY
│
├─ 1.1 ─┬─ Market Research & Analysis ─────────┐
│       └─ Stakeholder Identification ─────────┤
│                                              ▼
├─ 1.2 ── Business Case Development ───────────┤
│                                              ▼
├─ 1.3 ── Product Strategy & Roadmapping ──────┤
│                                              │
╠══════════════════════════════════════════════ GATE: Go/No-Go ═══╣
│                                                                 │
PHASE 2: EXPLORATION & VALIDATION                                 │
│                                                                 │
├─ 2.1 ─┬─ Ideation & Concept Development ────┐                  │
│       └─ User Research ──────────────────────┤                  │
│                                              ▼                  │
├─ 2.2 ─┬─ Feasibility Study ─────────────────┐│                  │
│       └─ Regulatory & Compliance Analysis ───┤│                  │
│                                              ▼│                  │
├─ 2.3 ── Risk Management ────────────────────┤│                  │
│                                              ▼│                  │
├─ 2.4 ── Proof of Concept (PoC) ─────────────┤│                  │
│                                              ││                  │
╠══════════════════════════════════ GATE: Validated Concept ═══════╣
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  PHASE 3, 4, and 5 overlap:                             │   │
│  │  • Phase 5 early work (Solution Arch) starts with 3.1   │   │
│  │  • Phase 4 starts after 3.3 (needs journeys + spec)     │   │
│  │  • Phase 5 late work (Integration, Tech Spec) needs 3.3 │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                 │
│  PHASE 3: REQUIREMENTS    PHASE 5: ARCHITECTURE (early)        │
│  │                        │                                     │
│  ├─ 3.1 ─┬─ Personas ────────► 5.1 ── Solution Arch ──────┐   │
│  │       └─ Business Req ─┐    │  (biz case + PoC + NFRs   │   │
│  │                        ▼    │   are enough to start)     │   │
│  ├─ 3.2 ── Journey Maps ─┤    │                            ▼   │
│  │                        ▼    ├─ 5.2 ─┬─ Security Arch ───┐   │
│  ├─ 3.3 ─┬─ Func. Spec ──┤    │       ├─ Data Arch ────────┤   │
│  │       └─ Non-Func Req ─┤    │       └─ Infra & Platform ─┤   │
│  │                        │    │                             │   │
│  │  PHASE 4: UX DESIGN   │    │  PHASE 5: ARCH (late)      │   │
│  │  │  (needs 3.2 + 3.3) │    │  │  (needs 3.3)            │   │
│  │  │                     ▼    │  │                          ▼   │
│  │  ├─ 4.1 ── Info Arch ──┐   │  ├─ 5.3 ── Integration Dsgn┐   │
│  │  │                     ▼   │  │                          ▼   │
│  │  ├─ 4.2 ─┬─ Interact. ─┐   │  ├─ 5.4 ── Technical Spec ─┤   │
│  │  │       └─ Accessib. ──┤   │  │                          │   │
│  │  │                      ▼   │  │                          │   │
│  │  ├─ 4.3 ── Visual/UI ──┤   │  │                          │   │
│  │  │                      ▼   │  │                          │   │
│  │  ├─ 4.4 ── Prototyping ┤   │  │                          │   │
│  │  │                      ▼   │  │                          │   │
│  │  ├─ 4.5 ── Usability ──┤   │  │                          │   │
│  │  │      ╰─ (iterate)   │   │  │                          │   │
│  │  │                     │   │  │                          │   │
│  ├─ 3.4 ── User Stories ──┤   │  │                          │   │
│  │                        ▼   │  │                          │   │
│  ├─ 3.5 ── Prioritization ┤   │  │                          │   │
│  │                        ▼   │  │                          │   │
│  ├─ 3.6 ── Traceability ──┤   │  │                          │   │
│  │                        │   │  │                          │   │
│  ╠══ GATE: Requirements ══╣   ╠══ GATE: Designs ════════════╣   │
│  │                        │   │                              │   │
│  └────────────────────────┘   ╠══ GATE: Tech Blueprint ═════╣   │
│                                                                 │
│  ── all three gates must pass before Phase 6 ──                 │
│                                                                 │
PHASE 6: PLANNING & READINESS                                     │
│                                                                 │
├─ 6.1 ─┬─ Scope Definition & WBS ────────────┐                  │
│       ├─ Legal Review ───────────────────────┤                  │
│       └─ Definition of Done / Ready ─────────┤                  │
│                                              ▼                  │
├─ 6.2 ─┬─ Estimation & Planning ─────────────┐│                  │
│       ├─ Vendor & Procurement Mgmt ──────────┤│                  │
│       └─ Quality Assurance Planning ─────────┤│                  │
│                                              ▼│                  │
├─ 6.3 ─┬─ Resource & Team Planning ──────────┐│                  │
│       └─ Documentation Strategy ─────────────┤│                  │
│                                              ▼│                  │
├─ 6.4 ─┬─ Change Management Planning ────────┐│                  │
│       └─ Stakeholder Comms Planning ─────────┤│                  │
│                                              ││                  │
╠═════════════════════════════════ GATE: Ready to Build ═══════════╣
│                                                                 │
▼                                                                 │
TECHNICAL IMPLEMENTATION BEGINS                                    │
```

---

## Critical Path (optimized)

The **longest serial chain** with Phase 3/4/5 overlap applied:

```
Market Research ─► Business Case ─► Product Strategy
  ─► Ideation ─► Feasibility ─► Risk Mgmt ─► PoC
  ─► Personas ─► Journey Maps ─► Functional Spec ─► User Stories ─► Prioritization ─► Traceability
       │                              │
       │ (parallel track A: UX)       │ (parallel track B: Architecture)
       │                              │
       ├─► Info Arch ─► Interaction   ├─► Solution Arch ─► Sec/Data/Infra
       │   ─► Visual ─► Prototype    │   ─► Integration Design
       │   ─► Usability Testing       │   ─► Technical Spec
       │                              │
       └──────────── both complete ───┘
                         │
  ─► WBS ─► Estimation ─► Resource Planning ─► Change Mgmt Planning
  ─► BUILD
```

**18 serial steps** on the critical path (down from 22). Architecture's first 2 steps now run "for free" alongside requirements work.

---

## Parallelism Opportunities Summary

| Opportunity | What runs in parallel | Time saved |
|---|---|---|
| Phase 1.1 | Market Research ∥ Stakeholder Identification | 1 step |
| Phase 2.1 | Ideation ∥ User Research | 1 step |
| Phase 2.2 | Feasibility ∥ Compliance Analysis | 1 step |
| Phase 3.1 | Personas ∥ Business Requirements | 1 step |
| Phase 3.3 | Functional Spec ∥ Non-Functional Req. | 1 step |
| **Phase 3+5** | **Requirements ∥ Architecture (early)** | **2 steps** |
| **Phase 3+4+5** | **Requirements (late) ∥ UX Design ∥ Architecture (late)** | **up to 6 steps** |
| Phase 5.2 | Security ∥ Data ∥ Infrastructure Arch. | 2 steps |
| Phase 6.1 | WBS ∥ Legal ∥ DoD | 2 steps |
| Phase 6.2 | Estimation ∥ Vendor ∥ QA Planning | 2 steps |
| Phase 6.3 | Resource Planning ∥ Doc Strategy | 1 step |
| Phase 6.4 | Change Mgmt ∥ Stakeholder Comms | 1 step |

The biggest win is the **three-way overlap of Phases 3, 4, and 5** — architecture starts early with the business case and PoC as input, UX design starts once journeys and specs are available, and the late requirements work (stories, prioritization, traceability) continues in parallel with both. This saves up to 6 steps compared to running them sequentially.
