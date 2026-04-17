# Authorization Modeling — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | authorization-modeling |
| **Version** | 1.0.0 |
| **Purpose** | Designs authorization (what-can-you-do) model — distinct from authentication (who-are-you). Selects among RBAC (role-based, simple hierarchies), ABAC (attribute-based, complex context rules), ReBAC (relationship-based, à la Zanzibar / SpiceDB / OpenFGA for collaboration products), PBAC (policy-as-code with OPA / Cedar / Rego). Per resource type × action × subject specifies allowed conditions. Covers role hierarchy + permission assignment + scoping (org / tenant / project) + separation of duties for RBAC; attribute policies for ABAC; tuples `object#relation@user` for ReBAC; Rego / Cedar policies for PBAC. Architectural separation of PDP (decision) / PEP (enforcement) / PAP (administration) / PIP (attribute source) with central-vs-distributed trade-off analysis. Common patterns: tenant isolation, delegation, break-glass with audit, GDPR purpose-based access. Mermaid PDP/PEP flow diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- New product authz design
- Migrating from ad-hoc permissions to structured model
- Complex authz surfacing (collaboration / marketplace / multi-tenant)
- Pre-compliance audit

## When not to use
- Authentication → `authentication-strategy-design`
- Security classification of data → `security-requirements-classification`
- Framework mapping → `control-framework-mapping`

## Required input
- **System** + **Resources** + **Actors**

## Processing
1. Model selection (RBAC / ABAC / ReBAC / PBAC)
2. Resource × action × subject matrix
3. Model-specific detail (hierarchy / policies / tuples / code)
4. PDP / PEP / PAP / PIP architecture
5. Patterns (tenant / delegation / break-glass / consent)
6. Audit logging spec

## Output contract
Model + matrix + detail + architecture + patterns + audit + diagram.

## Failure behavior
- Model mismatch → propose alternative
- No default-deny → push back
- mmdc failure → see mixin

## Examples
1. Enterprise SaaS — RBAC with hierarchy + tenant scoping + separation of duties.
2. Google Docs-like collaboration — ReBAC (Zanzibar); tuples for ownership / sharing / parent-folder.
3. Compliance-heavy — PBAC with OPA policies; every decision audited.
4. Multi-tenant + resource-attributes — hybrid RBAC+ABAC; roles per tenant + attribute conditions.
5. Admin + break-glass — elevated-access pattern with time-boxed grants + full audit trail.
