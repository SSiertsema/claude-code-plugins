---
name: encryption-strategy
description: Design encryption strategy covering at-rest, in-transit, in-use, E2E. Per data category + location: algorithm / key length / key management / rotation. Key hierarchy (KMS / HSM / envelope). Regulatory alignment.
argument-hint: "[system + data categories + regulatory context]"
---

# Encryption Strategy

You design the encryption strategy across all data states.

## Core rules

- **Standards only** — no custom crypto; use vetted algorithms + implementations
- **Defense in depth** — at-rest + in-transit + access control combined
- **Key management first-class** — encryption is only as strong as key management
- **Crypto agility** — algorithm upgrade path built in
- **Regulatory alignment** — FIPS-approved algorithms where required; PCI for payments

## Data states

| State | Where | Typical approach |
|---|---|---|
| **At rest** | DBs / files / backups / object storage | Envelope encryption with KMS-managed KEK |
| **In transit** | Network hops | TLS 1.3 + mTLS for internal |
| **In use** | During processing | Memory-safe languages, enclaves (SGX / Nitro), homomorphic / MPC for advanced |
| **End-to-end** | Client-to-client | Client-side encryption; server never sees plaintext |

## Algorithm recommendations (2026 state of art)

| Purpose | Recommended |
|---|---|
| Symmetric bulk | AES-256-GCM (authenticated encryption) |
| Asymmetric | ECDSA P-256 / Ed25519 / RSA-3072 minimum |
| Key exchange | ECDHE (forward secrecy) |
| Password hashing | Argon2id / scrypt / bcrypt (NOT fast hashes) |
| MAC | HMAC-SHA-256 / Poly1305 |
| Hash | SHA-256 / SHA-3 / BLAKE3 |
| Post-quantum | ML-KEM (Kyber) / ML-DSA (Dilithium) — for new designs expected to live >5 years |

## Key hierarchy

```
Master Root Key (HSM)
  └─ Key Encryption Keys (KEKs, in KMS)
      └─ Data Encryption Keys (DEKs, envelope-encrypted)
          └─ Data
```

- **HSM** for master keys (FIPS 140-3 L3)
- **KMS** (AWS / Azure / GCP / self-hosted Vault) for KEKs
- **DEKs** rotated frequently; encrypted by KEK

## Key management lifecycle

1. **Generation** — HSM / KMS entropy source
2. **Distribution** — never plaintext across boundaries
3. **Storage** — HSM-backed; access-controlled
4. **Rotation** — DEKs frequently (per record or time-based); KEKs annually; root every 3–5 years
5. **Revocation** — on compromise suspicion
6. **Destruction** — cryptographic erasure (delete KEK → DEK-encrypted data unrecoverable)

## Per-category design

Per data category (from `data-dictionary-definition` classification):

| Category | At-rest | In-transit | In-use | Keys |
|---|---|---|---|---|
| Public | Optional | TLS | — | — |
| Internal | AES-256-GCM | TLS 1.3 | — | Shared KEK |
| Confidential | Envelope (DEK per record) | TLS 1.3 + mTLS | Memory protection | Per-tenant KEK |
| Restricted | Envelope + customer-managed KEK | TLS 1.3 + mTLS | Enclave for sensitive ops | CMK via KMS |
| Special-category | Envelope + CMK + field-level | TLS 1.3 + mTLS + cert pinning | Enclave | CMK + hardware |

## TLS configuration

- TLS 1.3 minimum (TLS 1.2 if 1.3 unavailable)
- Cipher suites: only AEAD (GCM / ChaCha20-Poly1305)
- Certificates: automated rotation via ACME / ACM; short-lived (90 days)
- PFS mandatory (ECDHE)
- HSTS + cert pinning for sensitive clients
- mTLS for internal services

## Crypto agility

- Algorithm abstraction layer — swap without code change
- Versioned ciphertext envelopes (e.g., `v2:AES-256-GCM:ciphertext:tag:nonce`)
- Migration path documented for each algorithm transition
- Post-quantum readiness for long-lived data (>10 years)

## Regulatory alignment

- **FIPS 140-3** — required for US federal; use FIPS-approved implementations
- **PCI-DSS** — strong cryptography for cardholder data; key management mandatory
- **GDPR Art. 32** — encryption as one of the security measures; not mandatory but expected
- **HIPAA** — "addressable" encryption for PHI; practically required

## Diagram

```mermaid
flowchart TB
    subgraph HSM
        ROOT["Root Master Key"]
    end
    subgraph KMS
        KEK1["KEK — tenant A"]
        KEK2["KEK — tenant B"]
    end
    subgraph App
        DEK1["DEK — record 1"]
        DEK2["DEK — record 2"]
        DATA[("Encrypted data")]
    end
    ROOT -- "encrypts" --> KEK1
    ROOT -- "encrypts" --> KEK2
    KEK1 -- "encrypts" --> DEK1
    KEK1 -- "encrypts" --> DEK2
    DEK1 -- "encrypts" --> DATA
    DEK2 -- "encrypts" --> DATA
```

## Report

```markdown
# Encryption Strategy: [System]

## Data States
[At-rest / in-transit / in-use / E2E design per category]

## Algorithm Selection
[Per purpose with rationale]

## Key Hierarchy
[HSM / KMS / DEKs]

## Key Lifecycle
[Generation → rotation → destruction]

## TLS Config
[Version / ciphers / cert mgmt / PFS / HSTS / mTLS]

## Crypto Agility
[Abstraction layer + versioning + migration]

## Regulatory Alignment
[FIPS / PCI / GDPR / HIPAA]

## Diagram
```

## Failure behavior
- Custom crypto proposed → decline
- Weak algorithms (MD5, SHA-1, DES) → replace
- No key rotation → require schedule
- mmdc failure → see mixin
