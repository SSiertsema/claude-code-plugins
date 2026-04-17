# Team Topology Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | team-topology-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs team structure using Team Topologies (Skelton & Pais). Four team types only: stream-aligned (end-to-end value delivery for a domain / product area, 5–9 engineers), platform (self-service internal developer platform / shared infra), enabling (time-boxed capability coaching to stream teams), complicated-subsystem (deep specialist subsystem ownership — compiler / ML pipeline / pricing engine). Three interaction modes only: collaboration (short + intense + high-friction — use sparingly), X-as-a-Service (consumer + provider with contract — default for platform), facilitating (enabling team helps others adopt a practice — temporary). Cognitive-load assessment per stream team across intrinsic (unavoidable domain complexity) / extraneous (accidental tooling/env complexity — extract to platform) / germane (learning load). Signals of over-loaded teams: firefighting, release coordination days, knowledge silos, can't-whiteboard-the-system, 3+ month onboarding. Aligns team boundaries with bounded contexts (DDD hand-off to `ddd-strategic-modeling`). Avoids feature teams spanning contexts + functional teams splitting contexts. Publishes Team API per team (purpose + services + APIs + on-call + contact + office hours + SLO + intake + interaction modes with others). Reverse-Conway maneuver pattern: restructure teams to produce desired architecture when current structure blocks it. Team-of-teams patterns at scale (Spotify chapters/tribes/guilds principles; SAFe ART; simple team-of-teams). Collaboration tool stack deliberately chosen (chat / docs / tickets / diagrams / video / async decisions + ADRs). Anti-patterns flagged (platform as ticket-desk, permanent feature team, too-wide stream scope, permanent enabling team, too many collaboration pairs, generic "complicated-subsystem" misuse, 6-month reorg thrash). Metrics (cognitive-load quarterly survey, cycle time, dependency graph, Team API freshness, team tenure, collaboration-to-X-as-a-Service ratio trend). Mermaid team-type map + cognitive-load trend with PNG export. Hand-offs to `ddd-strategic-modeling`, `raci-responsibility-definition`, `onboarding-plan`, `change-impact-assessment`. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `professional` |
| **Audience** | `mixed` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Org scaling (more teams needed)
- Platform adoption decision
- Persistent delivery friction / handoff pain
- Post-merger / re-org
- DDD context discovery finished → structure teams

## When not to use

- DDD context discovery → `ddd-strategic-modeling`
- RACI matrix only → `raci-responsibility-definition`
- Onboarding specifically → `onboarding-plan`
- Change-management of reorg itself → `change-impact-assessment`

---

## Required input

| Field | Description |
|---|---|
| **Organization** | Size + product |
| **Domains** | Contexts / product areas |
| **Current teams** | List with roles + sizes |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Pain points** | Bottlenecks / cognitive load | Asked |
| **Constraints** | Budget / hiring / geography | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/team-topology-design/` |

## Input schema

```
input:
  required:
    organization: string
    domains: array[string]
    current_teams: array[object]
  optional:
    pain_points: array[string]
    constraints: object
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Organization + domains + current teams + pain + constraints.

### Phase 2 — Team types
Four types only.

### Phase 3 — Interaction modes
Three modes only.

### Phase 4 — Cognitive load
Intrinsic / extraneous / germane + signals.

### Phase 5 — Domain alignment
Bounded-context-based boundaries.

### Phase 6 — Team API
Per team.

### Phase 7 — Reverse-Conway
When needed.

### Phase 8 — Team-of-teams
Scale patterns.

### Phase 9 — Tool selection
Deliberate stack.

### Phase 10 — Anti-patterns
Catalog + fixes.

### Phase 11 — Metrics + health
Surveys + cycle time + dependencies.

### Phase 12 — Diagrams
Team map + load trend.

### Phase 13 — Diagram rendering
Per mixin.

### Phase 14 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Team Topology Design: [Organization]

**Date**: [date]
**Organization**: [...]
**Version**: v1.0

## Scope
## Team Types
## Interaction Modes
## Cognitive Load Assessment
## Team Boundaries + Domain Alignment
## Team APIs
## Reverse-Conway Maneuvers
## Team-of-Teams Structure
## Collaboration Tool Selection
## Anti-Patterns to Avoid
## Metrics + Health
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Team type map** — Mermaid `graph TD`
- **Cognitive load trend** — Mermaid `xychart-beta`

---

## Assessment and planning policy

- Four team types only
- Three interaction modes only
- Cognitive load assessed
- Domain-aligned
- Team API required
- Anti-patterns addressed
- Metrics tracked
- No fabricated teams

---

## Self-check

```
[] Four team types
[] Three interaction modes
[] Cognitive load per stream team
[] Domain-aligned boundaries
[] Team API per team
[] Reverse-Conway if needed
[] Team-of-teams at scale
[] Tooling consolidated
[] Anti-patterns
[] Metrics
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No org context | Interview mode (§7) |
| Feature-team everywhere | Challenge |
| Platform ticket-desk | Recommend X-as-a-Service |
| Permanent enabling | Time-box / convert |
| DDD deep | Redirect |
| RACI deep | Redirect |
| mmdc failure | See `diagram-rendering` mixin |

---

## Quality checks

- [ ] Team types adhere to four only
- [ ] Interaction modes within three
- [ ] Cognitive load evidenced (signals)
- [ ] Bounded-context alignment where possible
- [ ] Team API fields complete
- [ ] Reverse-Conway called when needed
- [ ] Metrics feasible to collect

---

## Examples

### Normal cases

**1. Growing SaaS (40 → 120 engineers)**
- Input: Stream teams forming around domains, first platform team
- Expected: 6 stream-aligned + 1 platform + 1 enabling (testing uplift) + 1 complicated (ML)

**2. Platform adoption**
- Input: Service desk platform team, ticket backlog
- Expected: Convert to X-as-a-Service with self-service + docs; shift cognitive load

**3. Post-merger integration**
- Input: Two orgs' teams overlapping
- Expected: Reverse-Conway to target architecture; consolidated team APIs; enabling team for tools unification

**4. DDD mapping to teams**
- Input: Bounded contexts identified
- Expected: Team boundaries per context; shared kernel teams as platform

**5. Scaling to 10+ stream teams**
- Input: Coordination overhead rising
- Expected: Team-of-teams layering; guilds/chapters for craft; explicit dependency model

### Edge cases

**6. Complicated subsystem over-used**
- Input: Teams of specialists for too many areas
- Expected: Challenge; reserve type for genuine specialist work

**7. Chronic collaboration**
- Input: Teams stuck in collaboration mode for quarters
- Expected: Define exit criteria to X-as-a-Service; acknowledge friction

**8. Cognitive overload signs**
- Input: Firefighting + silos
- Expected: Extract platform + enabling engagement + cognitive-load survey

### Failure cases

**9. No domains**
- Input: "Design our teams"
- Expected: Interview — domains + current teams + pain

**10. RACI request**
- Input: "Make a RACI matrix"
- Expected: Redirect
