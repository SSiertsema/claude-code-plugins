# Authentication Strategy Design — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | authentication-strategy-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs authentication strategy per user population (customer / employee / partner / service-to-service). Selects among password, MFA variants (TOTP / push / SMS / hardware key), SSO (OIDC / SAML / OAuth2), passwordless (magic link / WebAuthn / passkey), mTLS, API keys, JWT bearer, session cookies. Per population declares mechanism + MFA requirement (always / risk-based / never) + session duration + idle timeout + step-up-auth triggers + account-recovery + revocation. Covers lifecycle (registration → auth → recovery → rotation → revocation). Maps threats to mitigations (credential stuffing → rate limit + MFA + breach monitoring; phishing → passkey; session hijack → secure cookies + short tokens; token replay → audience/issuer validation; account enumeration → generic errors; password spray → lockout + anomaly). Resists custom crypto. Mermaid auth-flow diagram with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Product auth design for new system / population
- Modernizing legacy auth (password-only → MFA / passkey)
- Multi-population auth (customer + employee + services)
- Security audit follow-up

## When not to use
- Authorization modeling → `authorization-modeling`
- IdP vendor pick only → `technology-evaluation-matrix`
- Secrets at runtime → `secrets-management-design`

## Required input
- **Product**
- **User populations**

## Processing
1. Per-population mechanism choice with rationale
2. Lifecycle spec
3. Threat mitigations
4. IdP / tooling
5. Rollout plan

## Output contract
Per-population mechanism + lifecycle + threat mitigations + IdP choice + rollout + diagram.

## Failure behavior
- No populations → interview
- Custom crypto → decline
- mmdc failure → see mixin

## Examples
1. B2C + workforce — OIDC + passkey for customers, SAML + MFA for employees, mTLS + JWT for services.
2. Regulated healthcare — hardware-key MFA + short sessions + step-up for sensitive actions.
3. Legacy password-only — migration plan to MFA + passkey with deprecation roadmap.
4. API-first product — API keys for low-stakes, OAuth2 for partner integrations, mTLS for internal services.
5. Passkey-first consumer — primary path passkey + email fallback; SMS as last resort.
