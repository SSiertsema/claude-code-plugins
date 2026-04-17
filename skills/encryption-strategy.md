# Encryption Strategy — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | encryption-strategy |
| **Version** | 1.0.0 |
| **Purpose** | Designs encryption strategy across all data states (at-rest / in-transit / in-use / end-to-end). Per data category + location specifies algorithm (AES-256-GCM bulk / ECDSA or Ed25519 asymmetric / ECDHE key exchange / Argon2id password / HMAC-SHA-256 MAC / SHA-256 hash / ML-KEM + ML-DSA for post-quantum readiness), key length, key management approach, and rotation cadence. Defines key hierarchy: HSM-backed root master key → KMS-managed KEKs (per tenant) → envelope-encrypted DEKs (per record / frequently rotated) → data. Covers key lifecycle (generation → distribution → storage → rotation → revocation → cryptographic-erasure destruction). TLS config (1.3 min, AEAD ciphers only, PFS via ECDHE, short-lived certs via ACME, HSTS, mTLS internal). Crypto agility via algorithm abstraction + versioned ciphertext envelopes + documented migration paths. Regulatory alignment (FIPS 140-3 / PCI-DSS / GDPR Art. 32 / HIPAA). Resists custom crypto. Mermaid key hierarchy diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- New system with sensitive data
- Compliance-driven encryption requirements (PCI / HIPAA / GDPR)
- Retrofit encryption into legacy system
- Post-quantum readiness planning

## When not to use
- Data classification → `security-requirements-classification`
- Secrets at runtime → `secrets-management-design`
- Framework audit → `control-framework-mapping`

## Required input
- **System** + **data categories** + **regulatory context**

## Processing
1. Data-state design per category
2. Algorithm selection
3. Key hierarchy (HSM / KMS / DEKs)
4. Lifecycle spec
5. TLS config
6. Crypto agility
7. Regulatory alignment

## Output contract
Per-category encryption + algorithms + key hierarchy + lifecycle + TLS config + agility plan + regulatory alignment + diagram.

## Failure behavior
- Custom crypto → decline
- Weak algorithms → replace
- No rotation → require schedule
- mmdc failure → see mixin

## Examples
1. PCI-compliant payments — tokenization + envelope + HSM + FIPS-approved.
2. E2EE messaging — client-side encryption, server never plaintext.
3. Healthcare EHR — field-level encryption for PHI + audit on every key use.
4. B2B SaaS multi-tenant — per-tenant CMK + tenant-isolation at crypto layer.
5. Legacy retrofit — phased rollout with algorithm versioning in ciphertext headers.
