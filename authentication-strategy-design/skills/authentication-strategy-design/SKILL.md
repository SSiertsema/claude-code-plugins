---
name: authentication-strategy-design
description: Design authentication strategy. Selects mechanism (password / MFA / SSO / passwordless / mTLS / API keys / JWT / session) per user population. Covers lifecycle (registration / auth / recovery / rotation / revocation).
argument-hint: "[product + user populations]"
---

# Authentication Strategy Design

You design authentication strategy per user population (customer, employee, partner, service-to-service). Output: per-population mechanism choice with rationale + lifecycle spec + threat mitigations.

## Core rules

- **Per-population design** — customers ≠ employees ≠ services
- **Threat-model driven** — link to `threat-modeling` / `attack-surface-analysis`
- **Lifecycle covered**: registration / auth / recovery / rotation / revocation
- **Standard mechanisms preferred** — resist custom
- **MFA default for anything sensitive**
- **Passkey-ready** where feasible

## Mechanisms

| Mechanism | Best for | Notes |
|---|---|---|
| **Password** | Legacy / simplest | Weakest alone; pair with MFA |
| **MFA (TOTP / push / SMS)** | Any sensitive access | SMS weakest; TOTP/push stronger; hardware key strongest |
| **SSO — OIDC** | Workforce (consumer / B2B) | Modern, standard, broad support |
| **SSO — SAML** | Enterprise workforce | Mature, SAML-required by some IdPs |
| **SSO — OAuth2** | Third-party authorization | Authorization framework, often wrapped in OIDC for authentication |
| **Passwordless — magic link** | Consumer with email | Eliminates password storage risk |
| **Passwordless — passkey / WebAuthn** | Modern consumer + enterprise | Phishing-resistant, public-key based |
| **mTLS** | Service-to-service | Strongest server-auth; cert lifecycle overhead |
| **API keys** | Machine-to-machine, low stakes | Rotation critical |
| **JWT bearer** | Stateless session after auth | Short-lived + refresh tokens; signature-verify required |
| **Session cookie** | Server-rendered apps | Secure + HttpOnly + SameSite |

## Per-population decisions

Per population declare:
- **Mechanism(s)** (primary + fallback)
- **MFA requirement** (always / risk-based / never)
- **Session duration** (short-lived access + refresh)
- **Idle timeout**
- **Re-auth triggers** (sensitive action / privilege elevation)
- **Account-recovery mechanism**
- **Revocation mechanism**

## Lifecycle spec

Per population:
1. **Registration** — self-serve / invite / provisioning
2. **Initial authentication** — first login flow
3. **Subsequent authentication** — SSO / password + MFA / passkey
4. **Step-up auth** — for sensitive actions
5. **Recovery** — forgot password / lost device / account lockout
6. **Rotation** — password change, key rotation, cert renewal
7. **Revocation** — session invalidation, token revocation, account deletion

## Threat mitigations

Map threats to mechanisms:
- **Credential stuffing** → rate limiting + MFA + breach monitoring
- **Phishing** → passkey / WebAuthn (phishing-resistant)
- **Session hijack** → secure cookies, short-lived tokens, re-auth on sensitive
- **Token replay** → short lifetimes + audience/issuer validation
- **Account enumeration** → generic error messages, timing-attack mitigation
- **Password spray** → rate limit + lockout + anomaly detection

## Diagram

```mermaid
flowchart LR
    subgraph Customers
        CUST["Customers"]
    end
    subgraph Employees
        EMP["Employees"]
    end
    subgraph Services
        SVC["Services"]
    end
    CUST -- "OIDC or passkey + MFA" --> IDP["IdP (Auth0 / Cognito)"]
    EMP -- "SAML + MFA" --> IDP
    SVC -- "mTLS + JWT" --> API["API"]
    IDP --> API
```

## Report

```markdown
# Authentication Strategy: [Product]

## Per-population decisions
[Table per population with mechanism / MFA / session / recovery]

## Lifecycle per population
[Registration → auth → recovery → rotation → revocation]

## Threat mitigations
[Threats × controls]

## IdP / tooling
[Chosen providers]

## Diagram

## Rollout plan
[Phased adoption]
```

## Failure behavior
- No populations → interview
- Custom crypto proposed → decline; use standards
- mmdc failure → see mixin
