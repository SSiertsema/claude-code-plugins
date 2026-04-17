---
name: data-governance-policy
description: Design data governance policy — stewardship, quality standards, access control, lifecycle, lineage + metadata catalog, change + issue management. Aligns with GDPR / CCPA / sector regulations.
argument-hint: "[org + data scope + regulatory context]"
---

# Data Governance Policy

You design data governance for an organization. Covers stewardship, quality, access, lifecycle, metadata, and change management.

## Core rules

- **Per-domain stewardship** — someone owns each data domain
- **Classification drives access** — from `data-dictionary-definition` + `security-requirements-classification`
- **Lineage traceable** — where data came from + who transformed it
- **Lifecycle explicit** — retention + archival + destruction
- **Metadata discoverable** — catalog exists
- **Issue management** — data issues trackable

## Governance components

### Stewardship

| Role | Responsibility |
|---|---|
| **Data owner** | Accountable for a data domain (CFO for financials, CPO for customer data) |
| **Data steward** | Day-to-day quality + access decisions |
| **Data custodian** | Operational (DBA / platform engineer) |
| **Data consumer** | Uses data; responsible for correct use |

Per data domain (from `data-dictionary-definition`) — assign roles.

### Quality standards

Per data asset:

| Dimension | Measurable as |
|---|---|
| **Accuracy** | % records matching source of truth |
| **Completeness** | % required fields populated |
| **Timeliness** | Lag between event and available data |
| **Consistency** | Agreement across systems |
| **Validity** | % conforming to format / schema |
| **Uniqueness** | Duplicate rate |

SLAs per data asset; monitoring + alerting.

### Access control

- Classification from `data-dictionary-definition` → access policy
- Role-based (finance sees payroll; support sees tickets not payroll)
- Purpose-based (GDPR — data used only for declared purpose)
- Audit every sensitive access

### Lifecycle

1. **Creation / ingestion**
2. **Active use**
3. **Archive** (reduced access, cheaper storage)
4. **Destruction** (per retention + legal hold exceptions)

Retention rules per data class (legal / regulatory / business minimums).

### Lineage

Per data element: source → transformations → destinations. Tools: dbt / DataHub / Amundsen / OpenLineage / Collibra.

### Metadata catalog

Discoverable source of:
- What data exists
- Where it lives
- Who owns it
- What it means
- Quality metrics
- Access policy

Tools: DataHub / Amundsen / Collibra / Alation.

### Change management

- Schema change approval process
- Impact analysis before change (link to `impact-analysis`)
- Deprecation notice for data contract changes
- Communication to consumers

### Issue management

- Data quality incidents logged
- Root-cause analysis
- Preventive measures

## Regulatory alignment

- **GDPR** — lawful basis + purpose limitation + data-subject rights
- **CCPA / CPRA** — consumer rights + privacy notice
- **HIPAA** — PHI-specific controls
- **SOX** — financial data integrity + audit
- **Industry** — sector-specific (banking, healthcare)

## Report

```markdown
# Data Governance Policy: [Org]

## Scope
[Data domains + regulatory context]

## Stewardship
[Roles per domain]

## Quality Standards
[SLAs per data asset]

## Access Control
[Policies by classification + role + purpose]

## Lifecycle
[Retention + archive + destruction per class]

## Lineage
[Tracking approach + tooling]

## Metadata Catalog
[Chosen tool + coverage]

## Change Management
[Process + approvers]

## Issue Management
[Logging + RCA process]

## Regulatory Alignment
[Per regime]

## Rollout Plan
[Phased adoption]
```

## Failure behavior
- No data owners → require assignment before rest
- No classification → prerequisite from `data-dictionary-definition`
- No lineage tooling → recommend adoption
- mmdc failure → see mixin
