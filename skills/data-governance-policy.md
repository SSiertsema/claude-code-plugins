# Data Governance Policy — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | data-governance-policy |
| **Version** | 1.0.0 |
| **Purpose** | Designs data governance for an organization covering stewardship (data owner accountable per domain + data steward day-to-day quality/access + data custodian operational + data consumer appropriate use), quality standards with SLAs per data asset across 6 dimensions (accuracy / completeness / timeliness / consistency / validity / uniqueness), access control driven by data classification from `data-dictionary-definition` + `security-requirements-classification` (role-based + purpose-based + audited sensitive access), lifecycle (creation → active → archive → destruction with retention per legal/regulatory/business minimums), lineage tracking (tools: dbt / DataHub / Amundsen / OpenLineage / Collibra), metadata catalog (what exists + where + owner + meaning + quality + access), change management (schema approval + impact analysis + deprecation notices), and issue management (data quality incidents + RCA + prevention). Regulatory alignment for GDPR / CCPA-CPRA / HIPAA / SOX / sector-specific. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Establishing data governance program
- Compliance-driven policy development
- Post-incident tightening
- M&A data-integration governance

## When not to use
- Schema / data dictionary → `data-dictionary-definition`
- Security classification → `security-requirements-classification`
- Privacy-flow mapping → `data-flow-diagramming`

## Required input
- **Organization + data scope + regulatory context**

## Output contract
Stewardship roles + quality SLAs + access policies + lifecycle + lineage + catalog + change mgmt + issue mgmt + regulatory alignment + rollout plan.

## Failure behavior
- No owners → require
- No classification → prerequisite
- No lineage tooling → recommend adoption

## Examples
1. Fintech GDPR + PCI — data owners per domain; audit every access; purpose-based controls.
2. Healthcare HIPAA — PHI steward; strict access; BAAs with processors; incident-response integrated.
3. E-commerce — customer-data owner; GDPR rights flows; catalog via DataHub.
4. Enterprise migration — per-source-system stewardship; data-contract approach between domains.
5. Analytics data-warehouse — separate governance for warehouse vs OLTP; data-quality SLAs per model.
