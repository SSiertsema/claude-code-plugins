# Environment Strategy — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | environment-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Design environment strategy (local dev / ephemeral-preview / integration-CI / QA / staging / UAT / demo / production / DR / canary). Per env: purpose, data type + source, access (human + service), isolation level (account / subscription / namespace), prod-parity score (1–5), refresh cadence, teardown policy, cost allocation. Data strategy enforces strict separation (synthetic / anonymized / prod-subset-with-audit / never-raw-prod-in-lower-envs). Access separation with break-glass for emergencies. Ephemeral per-PR preview environments via Vercel / Netlify / Render / K8s namespaces / Gitpod / Codespaces with auto-teardown. Cost management via tagging, per-env budgets, overnight auto-stop, anomaly alerts. Naming conventions + config via env variables + per-env secrets. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- New team setting up envs
- Audit environment sprawl
- Cost reduction pass
- Compliance review (data separation)

## When not to use
- Infra design → `cloud-architecture-design` / `iac-planning`
- CI/CD pipeline → `cicd-pipeline-design`
- DR specifics → `disaster-recovery-planning`

## Required input
- **Product + team + scale + regulatory context**

## Output contract
Env inventory + prod-parity rules + data strategy + access separation + ephemeral setup + cost mgmt + naming + diagram.

## Failure behavior
- Prod data in lower env → block
- Access mismatch → fix
- No teardown policy → require

## Examples
1. Small team — local + ephemeral PR previews + staging + prod (4 envs, cost-lean).
2. Regulated — extra UAT + DR; anonymized data in staging; strict audit.
3. Large B2B SaaS — multi-tenant dev/staging/prod + per-customer demo envs.
4. Cost optimization — audit finds orphan envs; teardown saves 30%.
5. Prod-data-in-dev incident — remediation plan; data rotation + anonymization.
