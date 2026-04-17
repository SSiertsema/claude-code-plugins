---
name: iac-planning
description: Infrastructure as Code planning. Tool selection, module design, state management, environment separation, CI/CD integration, drift detection, policy-as-code, secrets handling.
argument-hint: "[cloud + team + existing tooling]"
---

# IaC Planning

You plan Infrastructure as Code approach: tooling, structure, state, CI/CD, policy, secrets.

## Tool selection

| Tool | Best for |
|---|---|
| **Terraform (HCL)** | Multi-cloud, mature ecosystem, large community |
| **OpenTofu** | Terraform fork with open governance (post-BSL) |
| **Pulumi** | Real programming languages (TS / Python / Go / .NET) |
| **CloudFormation** | AWS-only, native, slower adoption |
| **AWS CDK** | AWS-native with TypeScript/Python abstraction over CF |
| **Bicep** | Azure ARM abstraction |
| **Google Cloud Deployment Manager** | GCP; less popular vs Terraform |
| **Crossplane** | K8s-native multi-cloud (CR-based) |

Most teams: Terraform / OpenTofu unless AWS-exclusive (CDK OK) or prefer programming (Pulumi).

## Module design

- **Layered modules**: base (networking / IAM) → platform (K8s / RDS templates) → application (per-service)
- **Versioned** (semver; Git tags or Registry)
- **Thin composition** top-level (mostly wiring modules)
- **Inputs + outputs documented**
- **Reusable across environments**

Anti-pattern: monolithic root module with everything.

## State management

- **Remote backend** (S3 + DynamoDB lock / GCS + locking / Terraform Cloud / Spacelift / Atlantis)
- **State locking** always on
- **Encryption at rest** for state
- **Access control** on state bucket
- **Per-environment state** (dev / staging / prod separate)
- **No secrets in state** (use data sources / KMS references)

## Environment separation strategies

| Strategy | Notes |
|---|---|
| **Workspaces** | Single codebase; switch workspace; simple but risky (wrong-env applies) |
| **Directories** | One root dir per env (dev/ staging/ prod/); clearer separation |
| **Separate accounts / subscriptions** | Strongest; Landing-zone pattern |
| **Separate repos** | Maximum isolation; more overhead |

Most robust: directories + separate accounts.

## CI/CD integration

- **PR trigger**: `terraform plan` on PR for review
- **Merge trigger**: `terraform apply` to target env
- **Approval gate** for prod
- **OIDC federation** to cloud (no long-lived keys)
- **Plan review mandatory** — don't auto-apply without human review for prod
- **Staged rollouts** — dev → staging → prod

## Policy as code

Prevent misconfigurations pre-apply:

| Tool | Notes |
|---|---|
| **OPA (Rego)** | General policy; used by Terraform Cloud |
| **Sentinel** | Terraform Cloud native |
| **Checkov** | Static analysis for Terraform / CloudFormation / K8s |
| **tfsec / terrascan** | Terraform-specific scanners |
| **AWS Config rules / Azure Policy / GCP Organization Policy** | Runtime enforcement |

Typical policies:
- Encryption required (S3, EBS, RDS)
- Public access blocked by default
- Required tags present
- Region allow-list
- Instance type allow-list (cost control)

## Drift detection

- Periodic `terraform plan` compared to state
- Alerts on unexpected diffs
- Tools: Terraform Cloud drift detection, Spacelift, env0

## Secrets handling

- Never in state or code
- Reference via KMS / Secrets Manager via data source
- See `secrets-management-design`

## Common anti-patterns

- State file committed to repo
- Hardcoded account IDs / secrets
- Single module doing everything
- Auto-apply to prod without review
- No policy enforcement
- Untested modules going to prod

## Report

```markdown
# IaC Plan: [Scope]

## Tool Selection
[Chosen + rationale]

## Module Structure
[Base / platform / application layers + registry]

## State Management
[Backend + locking + encryption + access]

## Environment Separation
[Strategy]

## CI/CD Integration
[PR plan + approval + OIDC + staged rollout]

## Policy as Code
[Tool + policies]

## Drift Detection
[Approach + cadence]

## Secrets Handling
[Reference pattern]

## Migration / Adoption
[From current state]
```

## Failure behavior
- No CI/CD for IaC → require before prod
- State in repo → block; remediate first
- Auto-apply to prod → require review gate
