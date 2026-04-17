# Configuration Management Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | configuration-management-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs configuration management for a service. Catalogs keys per category (infra — DB URL, broker URL, ports, log level; business tunables — order limits, defaults; feature flags — rollouts, targeting) with type, default, required flag, scope, hot-reload tolerance, documentation. Precedence explicit (flags > env > remote > file > built-in defaults with per-category guidance: infra → env, secrets → vault/KMS injected as env or fetched, business tunables → remote config, feature flags → flag service OpenFeature/LaunchDarkly/Unleash/Harness, per-tenant → remote keyed by tenant). Schema + validation at start-up: required keys present, enums valid, ranges respected, URLs parse, fail-fast with clear error on invalid. Secrets handling: never in repo, `.env.example` placeholder only, injection via External Secrets Operator / workload identity / IRSA, rotation schedule, access audit, blast-radius scoped per service. Hot-reload vs restart-required per key (safe: log level, tunables, flags; unsafe: DB URL, broker URL, ports). Atomic application + canary + audit log. Config drift detection (current config endpoint, fingerprint at start-up, alert on drift). Feature-flag categories (release / ops / experiment / permission / big-flag) with owner + cleanup review + targeting + safety defaults. Multi-env: identical schema + reviewed promotion (dev → staging → prod). Failure + recovery (last-known-good, reject invalid, fail-fast at start). Mermaid config-flow + precedence-layers diagrams with PNG export. Hand-offs to security skills (secrets), `observability-strategy` (drift alerts), `environment-strategy`. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New service config design
- Moving from ad-hoc to structured config
- Adopting feature flags
- Multi-env promotion work

## When not to use

- Secret vault selection only → security skills
- Drift alerting only → `observability-strategy`
- Environment strategy → `environment-strategy`
- Deployment pipelines → `cicd-pipeline-design`

---

## Required input

| Field | Description |
|---|---|
| **Service name** | Identifier |
| **Deploy targets** | Envs |
| **Config categories** | infra / business / flags |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Existing mechanism** | 12-factor / Spring / Consul / ... | Asked |
| **Secret mechanism** | Vault / Secrets Manager | Asked |
| **Hot-reload needs** | Per category | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/configuration-management-design/[service]/` |

## Input schema

```
input:
  required:
    service: string
    deploy_targets: array[string]
    config_categories: array[string]
  optional:
    existing_mechanism: string
    secret_mechanism: string
    hot_reload_needs: array[string]
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
Service, envs, categories, existing, secrets, hot-reload.

### Phase 2 — Key catalog
Per category: type, default, required, scope, reload, notes.

### Phase 3 — Precedence + source
Documented order + per-category source.

### Phase 4 — Schema + validation
Start-up validation, fail-fast.

### Phase 5 — Secrets
Vault / KMS / injection / rotation / audit.

### Phase 6 — Hot-reload vs restart
Per key safety.

### Phase 7 — Drift + observability
Export + fingerprint + alerts.

### Phase 8 — Feature flags
Categories + cleanup.

### Phase 9 — Multi-env
Schema identical, values promoted.

### Phase 10 — Failure + recovery
Last-known-good + reject invalid.

### Phase 11 — Diagrams
Config flow + precedence.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Configuration Management Design: [Service]

**Date**: [date]
**Service**: [...]
**Deploy targets**: [...]

## Scope
## Key Catalog
## Precedence + Source Selection
## Schema + Validation
## Secrets
## Hot-Reload vs Restart
## Config Drift + Observability
## Feature Flags
## Multi-Env
## Failure + Recovery
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Config flow** — Mermaid `flowchart TD`
- **Precedence layers** — Mermaid `graph LR`

---

## Assessment and planning policy

- Precedence documented
- Secrets not in repo
- Schema + validation at start-up
- Hot-reload only where safe
- Drift detected + alerted
- Feature flags have cleanup policy
- No fabricated keys

---

## Self-check

```
[] Key catalog per category
[] Types + defaults + validation
[] Precedence documented
[] Source per category
[] Secrets separated
[] Hot-reload safety per key
[] Drift detection + fingerprint
[] Feature-flag cleanup policy
[] Multi-env promotion path
[] Failure + recovery
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No categories | Interview mode (§7) |
| Secrets in repo | Reject + recommend vault |
| No validation | Require schema |
| Hot-reload everything | Challenge |
| No ownership on flags | Require owner + cleanup |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Every key typed + validated
- [ ] Precedence documented
- [ ] Secrets pathway separate from config
- [ ] Hot-reload marked explicitly per key
- [ ] Drift fingerprint in observability
- [ ] Feature flags have owner + removal plan
- [ ] Failure modes covered

---

## Examples

### Normal cases

**1. New Go service, AWS**
- Input: Env + Parameter Store + Secrets Manager
- Expected: 12-factor env; Parameter Store for tunables; Secrets Manager for secrets; schema via `envconfig`; start-up validation

**2. Kubernetes service, multi-tenant**
- Input: Helm values + External Secrets + OpenFeature
- Expected: Helm values per env; ESO syncs from vault → K8s secret → env; OpenFeature provider for flags; per-tenant tunables via remote config

**3. Feature-flag rollout**
- Input: New checkout flow
- Expected: Release toggle with owner + 2-month removal date; % rollout targeting; fallback to old path; audit log

**4. Legacy config refactor**
- Input: Config-in-Git monolith
- Expected: Migration plan — separate secrets to vault; business config to remote; code-in-repo + config-out; schema validation added

**5. Regulated service**
- Input: PCI service
- Expected: Secrets rotation; access audit; no secret in logs; tight scope per service; change-management process

### Edge cases

**6. Hot-reload of DB URL requested**
- Expected: Challenge — pool rebuild risky; restart-only; propose zero-downtime rolling restart

**7. Flag explosion (hundreds)**
- Expected: Quarterly cleanup process; owner + creation date enforced; removal PR workflow

**8. Multi-region config divergence**
- Expected: Per-region overrides allowed for regulatory reasons; drift monitoring per region

### Failure cases

**9. Secrets committed**
- Input: Found `.env` with real keys in repo
- Expected: Immediate rotation; remove from history; move to vault; post-mortem + prevention

**10. No schema**
- Input: "Just read env vars"
- Expected: Challenge — schema + validation mandatory; typos in prod are outages
