# IaC Planning — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | iac-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plan Infrastructure as Code approach. Tool selection (Terraform / OpenTofu / Pulumi / CloudFormation / AWS CDK / Bicep / GCP DM / Crossplane) based on cloud + team preference. Module structure in layers (base: networking/IAM → platform: K8s/RDS templates → application). Versioned + documented + reusable. Remote state with locking (S3+DynamoDB / GCS / Terraform Cloud / Spacelift / Atlantis) + encryption + access control + per-environment separation. Environment-separation strategies: workspaces (risky), directories (clearer), separate accounts (strongest, landing-zone aligned), separate repos (max isolation). CI/CD integration: PR-triggered plan + merge-triggered apply + approval gate for prod + OIDC federation no long-lived keys + staged rollout dev→staging→prod. Policy-as-code (OPA/Rego, Sentinel, Checkov, tfsec, terrascan, AWS Config / Azure Policy / GCP Org Policy) with typical rules (encryption required, public-access blocked, required tags, region allow-list, instance-type allow-list for cost). Drift detection periodic with alerts. Secrets reference via KMS/Secrets Manager, never in state/code. Anti-pattern catalog. |
| **Primary category** | `planning` |
| **Secondary category** | `generation` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- Greenfield IaC adoption
- Migrating from manual/console-managed infra
- IaC governance / policy maturity
- Team scaling IaC practice

## When not to use
- CI/CD generic → `cicd-pipeline-design`
- Secrets → `secrets-management-design`
- Cloud architecture → `cloud-architecture-design`

## Required input
- **Cloud + team + existing tooling**

## Output contract
Tool + module structure + state + env separation + CI/CD + policy + drift detection + secrets + migration.

## Failure behavior
- No CI/CD → require before prod
- State in repo → block + remediate
- Auto-apply prod → require review

## Examples
1. Multi-cloud — Terraform + S3 backend + separate accounts per env + OPA policies.
2. AWS-native — CDK in TypeScript + CodePipeline + AWS Config rules.
3. Azure — Bicep + Azure DevOps + Azure Policy.
4. K8s-native multi-cloud — Crossplane + ArgoCD.
5. Legacy to IaC migration — phased; state import; quick wins first.
