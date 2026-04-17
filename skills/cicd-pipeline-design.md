# CI/CD Pipeline Design — Skill Specification

## Metadata
| Field | Value |
|---|---|
| **Name** | cicd-pipeline-design |
| **Version** | 1.0.0 |
| **Purpose** | Design CI/CD pipeline: source → build → test → security-scan → artifact → deploy → verify → notify. Tool selection (GitHub Actions / GitLab CI / Jenkins / CircleCI / Buildkite / Azure Pipelines / Tekton / Argo / Dagger). Pipeline stages with quality gates per layer (unit + integration + E2E + SAST + SCA + container scan + license + secret scan) and tooling (Semgrep / CodeQL / Snyk / Trivy / Gitleaks / FOSSA). Artifact management (semver + immutable + signed via Sigstore/Cosign + SLSA provenance). Deployment strategies: rolling / blue-green / canary / progressive with metrics gating / feature flags / shadow launches — selected per risk profile. Environment flow dev → staging → prod with appropriate approvals. OIDC federation for secrets (no long-lived keys). Caching + parallelization + selective CI for speed. Pipeline observability (duration trends, flaky test tracking, success rate). |
| **Primary category** | `generation` |
| **Secondary category** | `planning` |
| **Mixins** | `[diagram-rendering]` |

## When to use
- New project pipeline design
- Existing pipeline audit / modernization
- Adding security / quality gates
- Migrating tooling (Jenkins → GitHub Actions, etc.)

## When not to use
- IaC pipeline specific → `iac-planning` (has its own pipeline)
- Secrets → `secrets-management-design`
- Deployment platform choice → cloud-architecture-design / infra skills

## Required input
- **Repo** + **target environments** + **deployment strategy preference**

## Output contract
Tool + stages + quality gates + artifact mgmt + deployment strategy + env flow + secrets + observability + rollback + diagram.

## Failure behavior
- No test gates → require
- Secrets in env → migrate to OIDC
- No rollback → require

## Examples
1. Web app — GH Actions + Semgrep + Trivy + canary deploy on EKS.
2. Mobile app — Fastlane + CircleCI + code signing + staged rollout via app stores.
3. Serverless — SAM / CDK + feature flags + blue-green via Lambda aliases.
4. Regulated — extra audit + manual approval + SLSA provenance + signed artifacts.
5. Monorepo — selective CI per package + shared base pipeline.
