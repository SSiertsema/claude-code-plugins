# Data Dictionary Definition — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | data-dictionary-definition |
| **Version** | 1.0.0 |
| **Purpose** | Produces a structured data dictionary — catalog of data entities and their attributes — used as shared contract between product, engineering, data, analytics, and compliance. Distinct from `taxonomy-design` (content classification) and physical database schema (implementation). Per entity: ID, business name, description, source of truth (table / API / file), owner, sensitivity tier (public / internal / confidential / restricted / special-category), estimated volume, retention policy, status. Per attribute: ID, entity ID, name (snake_case / camelCase per convention), display name, description, type (from controlled vocabulary: string / integer / decimal / boolean / date / timestamp / enum / reference / json / array / binary), format (ISO 8601 / UUID / email / E.164), nullable, default value, constraints (length / range / regex / enum values / unique), source (user input / system-generated / imported / computed), mandatory PII classification (none / identifier / quasi-identifier / sensitive / health / financial / biometric / children's / special-category-Art9), masking rule, retention, example value (illustrative), validation rules, status. Typed relationships between entities with cardinality + FK location + cascade rules. Required governance (owner per entity / change process / deprecation policy / versioning / review cadence / consumer notification). Mermaid ERD + PII classification pie with PNG export. Markdown + CSV export. |
| **Primary category** | `generation` |
| **Secondary category** | `extraction` |
| **Output mode** | `hybrid` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New product: define domain data model before building
- System migration: catalog existing data before moving
- Data-governance program: establish shared vocabulary
- Compliance / privacy audit: map what PII is where
- Cross-team alignment: product / engineering / data / compliance on same terms
- Input to `data-flow-diagramming` (privacy) and Phase 5 data-architecture skills

## When not to use

- Content classification → `taxonomy-design`
- Site page structure → `site-mapping`
- Physical DB schema with indexes + partitions → Phase 5 data-modeling
- API contract → API design skills (Phase 5)
- Analytics events → `metric-definition`

---

## Required input

| Field | Description |
|---|---|
| **Domain / system scope** | What data is in scope |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Entities** | Known list or source | Elicit |
| **Attributes** | Per entity | Elicit |
| **Source of truth** | DB schema / API / file | Asked |
| **Regulatory context** | GDPR / CCPA / HIPAA / PCI / none | General PII |
| **Naming convention** | snake_case / camelCase | snake_case default |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save the report | `/documentation/[case]/data-dictionary-definition/` |

## Input schema

```
input:
  required:
    domain:
      type: string | document_reference
  optional:
    entities: list[object]
    attributes: list[object]
    source_of_truth: string
    regulatory_context: list[string]
    naming_convention:
      type: string
      enum: [snake_case, camelCase, PascalCase]
      default: snake_case
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path:
      type: string
```

---

## Processing rules

### Phase 1 — Setup
Collect domain + source of truth + regulatory context.

### Phase 2 — Entity inventory
Per entity: name / source / owner / sensitivity / volume / retention / status.

### Phase 3 — Attribute specification
Per attribute: type / format / nullable / constraints / source / PII class / example / validation / status.

### Phase 4 — Relationships
Cardinality + FK + cascade + nullable.

### Phase 5 — PII classification
Mandatory on every attribute.

### Phase 6 — Governance
Owner / change process / deprecation / versioning / review / notification.

### Phase 7 — Validation & quality rules
Cross-attribute constraints + referential integrity.

### Phase 8 — Diagrams
ERD + PII classification summary.

### Phase 9 — Diagram rendering
Per `diagram-rendering` mixin.

### Phase 10 — Report assembly and approval
Full report with CSV export; present for approval; save only after confirmation.

---

## Output contract

```markdown
# Data Dictionary: [Domain]

**Date**: [date]
**Domain**: [name]
**Version**: [vN.M.K]
**Entity count**: [N]
**Attribute count**: [N]

## Scope
[Domain, source of truth, regulatory]

## Entities
[Full table]

## Attributes
[Grouped by entity]

## Relationships
[Typed with cardinality + FK + cascade]

## PII Classification Summary
[Counts + diagram]

## Validation & Quality Rules
[Cross-attribute constraints + referential integrity]

## Governance
[Owner per entity + process + deprecation + versioning + review]

## ERD
[Mermaid erDiagram]

## Versioning & CHANGELOG
[Current + notable changes]

## Assumptions & Limitations
[Gaps, source of truth caveats]
```

### Diagrams

- **ERD** — Mermaid `erDiagram`
- **PII classification summary** — Mermaid `pie`

---

## Generation and extraction policy

- Type + PII class mandatory per attribute
- Relationships typed
- Governance declared
- No fabricated attributes
- No `[unclassified]` PII

---

## Self-check

```
[] Domain declared
[] Entities with governance fields
[] Attributes with all fields (incl. PII class)
[] Relationships typed
[] PII classification on every attribute
[] Validation rules captured
[] Governance complete
[] Versioned + CHANGELOG
[] ERD valid
[] No fabricated attributes
[] No unclassified PII
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No domain | Interview mode (§7) |
| Missing PII class | Require before proceeding |
| Unknown source of truth | Flag governance gap |
| Incomplete enum domain | Elicit or flag |
| Deep JSON nesting | Recommend sub-entity or separate schema |
| mmdc failure | See `diagram-rendering` mixin |
| Schema implementation request | Out-of-scope |

---

## Quality checks

- [ ] Type per attribute
- [ ] PII class per attribute
- [ ] Relationships typed
- [ ] Governance
- [ ] Validation rules
- [ ] ERD
- [ ] Versioned
- [ ] No fabricated attributes

---

## Examples

### Normal cases

**1. E-commerce core**
- Input: Customer + Product + Order + OrderLine + Payment entities
- Expected: ~25 attributes; Customer.email = identifier + masking last-letters-only; Payment.card_token = financial (tokenized); ERD showing 1-to-many relationships; governance owned by Platform team.

**2. SaaS user management**
- Input: User + Organization + Role + Permission entities
- Expected: User.email = identifier + GDPR; multi-tenant relationships; role-based cascade rules (delete role ≠ delete user).

**3. Healthcare**
- Input: Patient + Diagnosis + Appointment entities, HIPAA context
- Expected: All patient attributes = health (Art. 9); strict retention; audit-trail attributes on every entity; relationships audited.

**4. Data-flow-diagramming follow-up**
- Input: Post-DFD data-dictionary for entities identified in flows
- Expected: Every entity in DFD maps to dictionary entry; PII classifications consistent; retention aligned with DFD retention rules.

**5. Legacy system catalog**
- Input: Existing 40-table DB to document
- Expected: Catalog as-is; flag inconsistencies (e.g., naming conventions mixed, some attributes without clear source); recommend clean-up / standardization roadmap.

### Edge cases

**6. Same attribute in multiple entities**
- Input: `email` present on Customer, Admin, Vendor
- Expected: Three distinct attributes (E-001.email, E-002.email, E-003.email); consistent type + format + PII class; flag if divergent.

**7. Polymorphic reference**
- Input: "Comment" can reference Post OR Photo OR Video
- Expected: Reference attribute + discriminator column; relationship cardinality per possible target; note polymorphism explicitly.

**8. Computed attribute**
- Input: `full_name` computed from first + last
- Expected: Source = computed; formula documented; no direct persistence; note derivation.

### Failure cases

**9. No domain**
- Input: "Make a data dictionary"
- Expected: Interview — "Which domain / system scope?"

**10. Out of scope**
- Input: "Dictionary + database schema + migrations"
- Expected: "Dictionary only. Schema + migrations are engineering work. Dictionary feeds the schema design."
