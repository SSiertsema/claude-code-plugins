---
name: environment-strategy
description: Design environment strategy (dev / staging / prod, + possibly QA / demo / UAT / DR). Per-env purpose, data, access, isolation, prod-parity, refresh cadence, teardown. Ephemeral per-PR envs.
argument-hint: "[product + team size + scale + regulatory context]"
---

# Environment Strategy

You design the environment strategy: which environments exist, what they're for, who accesses them, data in each, and operational rules.

## Core rules

- **Per-env purpose explicit** — no "kitchen sink" envs
- **Prod parity** critical for staging; fine-to-lower elsewhere
- **Data strictly separated** — prod data never in lower envs
- **Access differentiated** — prod-access minimal set
- **Ephemeral for feature development** — per-PR preview envs ideal
- **Cost visible** — tag by environment

## Standard environments

| Env | Purpose | Data | Access |
|---|---|---|---|
| **Development (local)** | Individual dev workstation | Mock / synthetic | Developer only |
| **Ephemeral / preview** | Per-PR or per-feature | Synthetic / seeded | Dev team + reviewers |
| **Integration / CI** | Automated test runs | Synthetic / fresh | CI system |
| **QA / Test** | Manual testing | Staging-equivalent synthetic | QA team |
| **Staging / Pre-prod** | Prod-parity rehearsal | Prod-like synthetic OR anonymized prod subset | Pre-deploy team |
| **UAT** | User acceptance | Business-approved test data | Business users |
| **Demo / Sales** | Customer demos | Curated sample data | Sales / customer-success |
| **Production** | Real users + real money | Real | Minimal operator set |
| **DR / Hot standby** | Disaster recovery | Replica of prod | Ops only |
| **Canary / Green** | Blue-green deploy target | Real (progressive traffic) | Deploy system |

Not all envs needed — most teams: local + ephemeral/preview + staging + prod.

## Per-environment spec

| Field | Description |
|---|---|
| **Name** | Env identifier |
| **Purpose** | What's it for |
| **Data** | Type + source |
| **Access** | Who can access (auth + roles) |
| **Isolation** | Separate account / subscription / project / namespace |
| **Prod parity** | How close to prod (1–5) |
| **Refresh cadence** | When data / config refreshes |
| **Teardown policy** | When env is destroyed |
| **Cost allocation** | Tag / account |

## Prod parity

Parity dimensions:
- Infrastructure (same instance types)
- Data volume (often scaled down — state so)
- Feature flags (matching prod)
- Traffic patterns (synthetic load)
- Dependencies (same vendor endpoints or clearly mocked)

100% parity is expensive. Staging typically 30–50% scale with same topology.

## Data in lower environments

- **Synthetic**: generated, safest
- **Anonymized prod**: real structure without PII (Tonic / Gretel / in-house)
- **Prod subset**: for debugging production issues (with extra approval + audit)
- **Never**: raw prod data in lower envs (compliance violation)

## Access separation

| Env | Human access | Service access |
|---|---|---|
| Dev/local | Developer | — |
| Ephemeral | Dev + reviewers | CI system |
| Staging | Engineering + QA | CI + monitoring |
| Production | Minimal oncall + break-glass | Deploy automation (not human) |

Break-glass: emergency human access with audit trail.

## Ephemeral environments (per-PR preview)

- Spun up on PR open
- Torn down on PR merge / close / timeout (e.g., 7 days)
- Cost-controlled
- Tools: Vercel / Netlify (static), Render / Railway (apps), Kubernetes namespaces, GitHub Codespaces, Gitpod

## Cost management

- Tag every resource with `env=dev|staging|prod|...`
- Budget per env (dev cheapest, prod unlimited-justified)
- Auto-stop dev / staging overnight + weekends
- Auto-teardown ephemeral after N days
- Cost anomaly alerts

## Naming + config

- DNS / URL convention: `dev.example.com`, `staging.example.com`, `example.com`
- Config via env variables / config service — not hardcoded
- Secrets per environment (never cross-env)

## Report

```markdown
# Environment Strategy: [Product]

## Environments
[Per env: purpose / data / access / isolation / parity / refresh / teardown / cost]

## Prod Parity Rules
[What's identical vs scaled down]

## Data Strategy
[Synthetic / anonymized / subset per env]

## Access Separation
[Matrix by env]

## Ephemeral / Preview Environments
[If in use: tooling + lifecycle]

## Cost Management
[Tagging + budgets + auto-shutdown]

## Naming + Config
[DNS + config pattern]

## Diagram
```

## Failure behavior
- Prod data in lower env → block; remediate
- Access mismatch (dev can write to prod) → fix
- No teardown policy → require
- mmdc failure → see mixin
