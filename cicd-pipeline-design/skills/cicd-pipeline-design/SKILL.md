---
name: cicd-pipeline-design
description: Design CI/CD pipeline from source to prod. Tool selection, stages, quality gates, artifact management, deployment strategy (blue-green / canary / rolling / progressive), observability, secrets via OIDC.
argument-hint: "[repo + target environments + deployment strategy]"
---

# CI/CD Pipeline Design

You design a CI/CD pipeline: stages, quality gates, deployment strategy.

## Tool selection

| Tool | Best for |
|---|---|
| **GitHub Actions** | Repo on GitHub; rich ecosystem |
| **GitLab CI** | Repo on GitLab; integrated |
| **Jenkins** | Legacy / on-prem / highly customizable |
| **CircleCI** | Cloud-native, fast |
| **Buildkite** | Self-hosted agents with cloud UI |
| **Azure Pipelines** | Azure-ecosystem |
| **Tekton** | K8s-native pipelines |
| **Argo Workflows / Argo CD** | K8s-native; GitOps |
| **Dagger** | Portable pipelines in code |

## Pipeline stages

```
Source → Build → Test → Security → Artifact → Deploy → Verify → Notify
```

### Source

- Trigger on push / PR / merge / tag
- Branch protection rules
- Commit signing (optional but recommended)

### Build

- Deterministic / reproducible
- Cache dependencies (`node_modules`, container layers, language caches)
- Build artifact versioned (semver + commit SHA)

### Test

| Layer | When | Gate |
|---|---|---|
| Unit | Every PR | Must pass |
| Integration | Every PR (slower) | Must pass |
| E2E critical path | Pre-merge or post-deploy to staging | Must pass |
| Performance | Nightly / pre-release | Regression detection |
| Security (SAST) | Every PR | Fail on critical/high |
| SCA (dependencies) | Every PR | Fail on critical vuln |
| Container scan | On image build | Fail on critical |
| License check | On dependency change | Fail on non-allow-listed |

### Security scans

- **SAST**: Semgrep / SonarQube / CodeQL / Snyk Code
- **SCA**: Dependabot / Snyk / Renovate
- **Container scan**: Trivy / Grype / Snyk Container
- **Secret scan**: Gitleaks / TruffleHog / built-in
- **License**: license-checker / FOSSA / Snyk License

### Artifact

- Semver-tagged
- Immutable
- Signed (Sigstore / Cosign)
- Provenance (SLSA attestations)

### Deploy strategies

| Strategy | How | Risk profile |
|---|---|---|
| **Rolling** | Replace instances gradually | Simple; downtime-free for stateless |
| **Blue-green** | Deploy to parallel env, switch | Fast rollback; 2× capacity momentarily |
| **Canary** | Route small % to new, watch, scale | Risk-controlled; needs traffic-split capability |
| **Progressive delivery** | Canary + automated metrics gating | Highest safety; requires observability depth |
| **Feature flags** | Deploy dark, enable per cohort | Decouples deploy from release |
| **Shadow / dark launch** | Run new alongside, compare | Validate before full cutover |

### Verify

- Smoke tests post-deploy
- Health checks
- Metrics from observability
- Error-rate + latency delta vs baseline
- Auto-rollback on regression

### Notify

- Slack / Teams / email on success + failure
- PagerDuty on prod failure

## Environment flow

```
Dev (auto) → Staging (auto on merge) → Production (manual approval or auto with all gates green)
```

## Secrets

- OIDC federation (GitHub Actions → AWS IAM via OIDC; GitLab → GCP Workload Identity)
- No long-lived keys in pipeline secrets
- Runtime secrets via vault at deploy (not baked into artifacts)

## Cache + speed

- Dependency caches
- Parallel test runs
- Selective CI (only run tests for changed components)
- Incremental builds

## Observability of pipeline itself

- Pipeline duration trend
- Flaky test tracking
- Build-success rate per branch
- Bottleneck stage identification

## Report

```markdown
# CI/CD Pipeline: [Product]

## Tool Selection
[Chosen + rationale]

## Pipeline Stages
[Each stage with gates]

## Quality Gates
[Unit / integration / E2E / SAST / SCA / container / license]

## Artifact Management
[Versioning + signing + provenance]

## Deployment Strategy
[Rolling / blue-green / canary / progressive / feature-flags]

## Environment Flow
[Dev → staging → prod with approvals]

## Secrets
[OIDC federation + no long-lived keys]

## Observability
[Pipeline + deployment]

## Rollback Procedure
[Automated + manual triggers]

## Diagram
```

## Failure behavior
- No test gates → require
- Secrets in pipeline env → migrate to OIDC
- No rollback → require
- mmdc failure → see mixin
