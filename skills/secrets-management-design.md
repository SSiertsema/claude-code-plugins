# Secrets Management Design — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | secrets-management-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs secrets management for an organization or system: vault selection (HashiCorp Vault self-hosted feature-rich / AWS Secrets Manager / GCP Secret Manager / Azure Key Vault / Doppler developer-UX / 1Password Secrets Automation / Infisical OSS), lifecycle per secret type (DB credentials → dynamic via Vault DB engine; cloud credentials → OIDC federation with no stored secrets; API keys → vendor rotation + vault auto-update; certificates → ACME automation; JWT signing keys → scheduled rotation with gradual rollover; encryption keys → KMS-managed per `encryption-strategy`; service account tokens → workload identity via SPIFFE / cloud-native). Covers generation (inside vault only) → distribution (fetch at runtime, never copy) → access control (per-service / per-env / per-user) → automated rotation → revocation on compromise + offboarding → audit every access. Injection pattern ranked: sidecar or API-fetch preferred > files > env variables least-preferred (leaky via `env` / crashes / logs). Environment separation strictly enforced (dev never has prod). CI/CD via OIDC federation eliminating long-lived keys + secret-scanning + auto-rotation on leak. Break-glass procedure with senior approval + time-box + extra audit. Surfaces common anti-patterns for migration. Mermaid vault + injection diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Greenfield secrets architecture
- Migration from `.env`-committed / shared-creds legacy
- Multi-cloud / hybrid with centralized vault need
- CI/CD modernization to OIDC federation

## When not to use
- Encryption keys at rest → `encryption-strategy` (KMS-managed)
- AuthN / AuthZ strategy → `authentication-strategy-design` / `authorization-modeling`
- Compliance audit → `control-framework-mapping`

## Required input
- **Environment** (cloud + orchestration)
- **Scale** (team size, service count)
- **Existing tooling**

## Processing
1. Vault selection
2. Lifecycle per secret type
3. Injection patterns
4. Environment separation
5. CI/CD integration
6. Audit
7. Break-glass procedure
8. Migration from anti-patterns

## Output contract
Vault + per-type lifecycle + injection + env separation + CI/CD + audit + break-glass + migration + diagram.

## Failure behavior
- Plaintext in repo → immediate remediation
- No rotation → require schedule
- Long-lived cloud keys → OIDC federation
- mmdc failure → see mixin

## Examples
1. AWS-heavy SaaS — AWS Secrets Manager + IAM roles + OIDC federation from GitHub Actions.
2. Multi-cloud enterprise — HashiCorp Vault centralized; dynamic DB creds; PKI for mTLS.
3. Small team — Doppler for developer UX + 1Password for vendor credentials.
4. Regulated fintech — Vault with HSM backend + strict audit + break-glass process.
5. Legacy migration — remove 200 committed secrets from git history; rotate everything; install vault + sidecar.
