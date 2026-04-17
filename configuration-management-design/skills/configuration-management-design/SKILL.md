---
name: configuration-management-design
description: Configuration for a service — key catalog + types + defaults + validation, precedence (flags > env > file > defaults), sources (env / file / remote / flag service), secrets (vault / KMS), hot-reload vs restart, drift detection.
argument-hint: "[service + deploy targets + config categories]"
---

# Configuration Management Design

You design how a service reads configuration — so it's discoverable, safe, and changeable without surprise. Secrets handled separately from plain config.

## Core rules

- **Config is code-adjacent** — schema + validation at the boundary
- **Precedence explicit** — flags > env > file > defaults (or your chosen order, documented)
- **12-factor as baseline** — config in env; code in repo
- **Secrets never in config files in repo** — vault / KMS / sealed-secrets
- **Hot-reload only where safe** — not every key
- **Fail fast on invalid config** — start-up validation rejects
- **No fabricated keys** — work from supplied behavior

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Service name** | Yes | — |
| **Deploy targets** (env list) | Yes | — |
| **Config categories** (infra / business / feature-flag) | Yes | — |
| **Existing mechanism** | No | Asked |
| **Secret mechanism** | No | Asked |
| **Hot-reload needs** | No | Asked |

## Phase 1 — Setup

```
**Service**: [name]
**Deploy targets**: [dev / staging / prod / edge regions]
**Config categories**:
  - infra (DB URL, broker URL, ports, log level)
  - business (pricing, thresholds, policy values)
  - feature flags (enable / disable / rollout %)
**Existing mechanism**: [12-factor env / file / Spring / Consul / LaunchDarkly / ...]
**Secrets**: [Vault / AWS Secrets Manager / GCP Secret Manager / sealed-secrets / ...]
**Hot-reload**: [required / not required]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/configuration-management-design/[service]/`).

## Phase 2 — Key catalog

Table per category:

### Infra

| Key | Type | Default | Required | Scope | Notes |
|---|---|---|---|---|---|
| `DATABASE_URL` | string | — | yes | env | with sslmode |
| `KAFKA_BROKERS` | CSV | — | yes | env | comma-separated |
| `HTTP_PORT` | int | 8080 | no | env | |
| `LOG_LEVEL` | enum | `info` | no | env | trace/debug/info/warn/error |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | url | — | yes | env | |

### Business

| Key | Type | Default | Required | Scope | Hot-reload | Notes |
|---|---|---|---|---|---|---|
| `ORDER_MAX_LINES` | int | 100 | no | remote | yes | cap per order |
| `DEFAULT_CURRENCY` | string | `EUR` | no | remote | yes | ISO 4217 |
| `IDEMPOTENCY_WINDOW_MINUTES` | int | 60 | no | remote | yes | |

### Feature flags

| Key | Default | Targeting | Hot-reload |
|---|---|---|---|
| `feature.new-checkout` | off | % rollout or user segment | yes |
| `feature.saga-orchestration` | off | per-tenant | yes |

## Phase 3 — Precedence + source selection

Documented precedence (highest wins):

```
1. command-line flags (for overrides in dev)
2. environment variables (deploy-time config)
3. remote config / flag service (runtime-tunable business config)
4. config file in image (rarely; dev-only defaults)
5. built-in defaults (last resort)
```

Per-category guidance:

| Category | Source |
|---|---|
| Infra (URLs, ports) | env var |
| Secrets | vault / KMS injected as env or fetched at start |
| Business (tunable) | remote config (Consul / etcd / Parameter Store / LaunchDarkly "big flags") |
| Feature flags | feature-flag service (LaunchDarkly / Unleash / OpenFeature / Harness) |
| Per-tenant config | remote config keyed by tenant |

## Phase 4 — Schema + validation

- Define config schema (e.g., struct + validator, Pydantic, Zod, JSON Schema)
- Validate at start-up: required keys present, enum values valid, URLs parse, numbers in range
- Fail-fast on invalid; exit with clear error
- Include doc-string per key (purpose + units + examples)

Example (Go):

```go
type Config struct {
    DatabaseURL  string        `env:"DATABASE_URL,required"`
    KafkaBrokers []string      `env:"KAFKA_BROKERS,required" envSeparator:","`
    HTTPPort     int           `env:"HTTP_PORT" envDefault:"8080"`
    LogLevel     string        `env:"LOG_LEVEL" envDefault:"info" validate:"oneof=trace debug info warn error"`
    OrderMaxLines int          `env:"ORDER_MAX_LINES" envDefault:"100" validate:"gt=0,lte=10000"`
}
```

## Phase 5 — Secrets

- **Never in repo**: `.env.example` with placeholder values only
- **Injection**: vault/KMS → env vars at runtime; or SDK fetches at start
- **Rotation**: schedule rotation + automated redeploy or in-process reload
- **Audit**: access logs on secret fetches
- **Blast-radius**: scope secrets per-service; avoid shared kitchen-sink secrets

Patterns:
- **External Secrets Operator** (K8s) syncs vault → K8s secrets → env
- **IRSA / workload identity** — service authenticates to vault via platform identity; no bootstrap secret
- **Short-lived credentials** — STS / Workload Identity Federation where possible

## Phase 6 — Hot-reload vs restart-required

| Category | Hot-reload? |
|---|---|
| Business tunables | yes (if safe) |
| Feature flags | yes |
| Log level | yes |
| DB URL | no (connection pool rebuild is risky) |
| Broker URL | no |
| Secrets (rotated) | depends: ideally yes via SDK |
| Ports / bind | no |

Implementation:
- Watcher subscribes to remote config; applies on change
- Atomic swap — never half-applied
- Audit log: who changed what, when, old/new (unless secret)
- Canary: apply to 1 instance first

## Phase 7 — Config drift + observability

- Export current config as structured metric / endpoint (minus secrets)
- Alert on drift between expected and actual
- Fingerprint config at start-up: log hash + version
- Config changes show up in audit trail + correlate with incidents

## Phase 8 — Feature flags specific

Categories:
- **Release toggles**: dark-launch new code paths; short-lived
- **Ops toggles**: circuit breakers, kill switches; long-lived
- **Experiment toggles**: A/B; time-limited
- **Permission toggles**: per-user/tenant; long-lived
- **Big flags**: major product change; transitional

Rules:
- Every flag has: owner, created date, removal plan (release toggles especially)
- Cleanup review quarterly — dead flags are tech debt
- Targeting rules documented
- Defaults fail closed for safety-critical toggles

## Phase 9 — Multi-env config

- Identical schema across envs
- Different values per env
- Promote config through the pipeline (dev → staging → prod) reviewed + audited
- Never edit prod config by hand without ticket

## Phase 10 — Failure + recovery

- Remote config service down: serve last-known-good
- Invalid remote change: reject + alert + keep last-good
- Local config file missing: fail-fast at start; don't boot with defaults that might be unsafe in prod

## Phase 11 — Diagrams

### Config flow

```mermaid
flowchart TD
    Start[Service starts]
    Start --> Defaults[Load built-in defaults]
    Defaults --> File[Load file config if present]
    File --> Env[Override with env vars]
    Env --> Flags[Override with flags]
    Flags --> Remote[Fetch remote config]
    Remote --> Validate{Valid?}
    Validate -->|no| Exit[Exit 1]
    Validate -->|yes| Run[Serve]
    Remote -.watch.-> Remote
```

### Precedence layers

```mermaid
graph LR
    D[Defaults] --> F[File] --> E[Env] --> CLI[Flags] --> R[Remote tunables] --> FF[Feature flags]
```

## Phase 12 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 13 — Report assembly and approval

```markdown
# Configuration Management Design: [Service]

**Date**: [date]
**Service**: [...]
**Deploy targets**: [...]

## Scope
[Categories + existing + secrets + hot-reload need]

## Key Catalog
[Per category: keys + types + defaults + validation]

## Precedence + Source Selection
[Rules + per-category source]

## Schema + Validation
[Fail-fast + doc-strings]

## Secrets
[Vault / KMS + rotation + audit]

## Hot-Reload vs Restart
[Per key]

## Config Drift + Observability
[Export + alerts + fingerprint]

## Feature Flags
[Categories + cleanup policy]

## Multi-Env
[Schema identical, values per env]

## Failure + Recovery
[Fail-fast + last-good + alerts]

## Diagrams
[Flow + precedence]

## Hand-offs
[Security for secrets, observability-strategy for drift, environment-strategy]

## Assumptions & Limitations
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- Precedence documented
- Secrets not in repo
- Schema + validation at start-up
- Hot-reload only where safe
- Drift detected + alerted
- Feature flags have cleanup policy
- No fabricated keys

## Failure behavior

| Situation | Behavior |
|---|---|
| No categories | Interview mode (§7) |
| Secrets in repo | Reject + recommend vault |
| No validation | Require schema |
| Hot-reload everything | Challenge — restrict to safe keys |
| No ownership on flags | Require owner + cleanup |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | "Design only; impl is engineering." |

## Self-check

```
[] Key catalog per category
[] Types + defaults + validation
[] Precedence documented
[] Source per category
[] Secrets separated, not in repo
[] Hot-reload safety assessed per key
[] Drift detection + fingerprint
[] Feature-flag cleanup policy
[] Multi-env promotion path
[] Failure + recovery
[] Diagrams valid
[] No fabricated keys
[] Report follows output contract
```
