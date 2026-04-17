# Dependency Injection Planning — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | dependency-injection-planning |
| **Version** | 1.0.0 |
| **Purpose** | Plans how a service wires its dependencies for testability + clear lifetimes + unambiguous composition. Establishes constructor injection as default with escape-hatches for setter (optional / framework-required), method-parameter (per-call context like user/tenant), and ambient (cross-cutting logger/tracer, used sparingly). Avoids service locator, hidden statics, and global mutable singletons. Places one composition root per process (at `main` / `Program.cs` / `app.module.ts` / `bootstrap()`): reads config, creates adapters, wires services, starts lifecycle; nothing below imports the DI container. Assigns lifetimes per dependency (singleton / scoped-per-request / transient / per-tenant via factory+cache / per-conversation) with rules (singleton deps must be thread-safe, singleton holding scoped is a leak, DB pool singleton + transaction scoped, HTTP client singleton with keepalive). Selects framework vs pure per language (Go/Rust manual; Java/Kotlin Spring or Dagger; TypeScript NestJS or manual; Python FastAPI Depends or manual; .NET built-in). Uses ports + adapters for test-double substitution and deterministic ports for side-effects (Clock, RandomSource, IdGenerator, HttpClient). Lifecycle hooks for start / ready / shutdown. Circular-dependency prevention via seam extraction / inversion / merge — never setter-null dances. Testing strategy: unit builds graphs manually, integration uses testcontainers, composition-root tests validate wiring. Mermaid dependency-graph + lifetime-layering with PNG export. Hand-offs to `component-design-documentation`, `configuration-management-design`, `system-error-handling-strategy`. |
| **Primary category** | `planning` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- New service wiring
- Refactor from service locator / static access
- Multi-tenant / per-request scoping design
- Test-ability improvement

## When not to use

- Framework selection (broader) → `technology-evaluation-matrix`
- Error strategy → `system-error-handling-strategy`
- Config → `configuration-management-design`

---

## Required input

| Field | Description |
|---|---|
| **Service / module** | Name |
| **Language + framework** | Target stack |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Existing approach** | Manual / Spring / locator / mixed | Asked |
| **Architecture** | Ports-adapters / layered | Asked |
| **Scoping needs** | Per-request / per-tenant | Asked |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/dependency-injection-planning/[service]/` |

## Input schema

```
input:
  required:
    service: string
    language: string
    framework: string
  optional:
    existing_approach: string
    architecture: string
    scoping_needs: array[string]
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Setup
Service, language, framework, existing, architecture, scoping.

### Phase 2 — Injection styles
Constructor default; setter / param / ambient with guidance.

### Phase 3 — Composition root
Single location + rules.

### Phase 4 — Lifetimes + scopes
Singleton / scoped / transient / per-tenant.

### Phase 5 — Framework vs pure
Choice + rationale.

### Phase 6 — Ports + adapters + test doubles
Deterministic ports for Clock / RNG / IdGen.

### Phase 7 — Lifecycle
Start / ready / shutdown hooks.

### Phase 8 — Circular dependencies
Prevention + fix strategies.

### Phase 9 — Testing strategy
Unit / integration / composition-root tests.

### Phase 10 — Anti-patterns
Listed + avoided.

### Phase 11 — Diagrams
Graph + lifetime layering.

### Phase 12 — Diagram rendering
Per mixin.

### Phase 13 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Dependency Injection Plan: [Service]

**Date**: [date]
**Service**: [...]
**Language / framework**: [...]

## Scope
## Injection Styles
## Composition Root
## Lifetimes + Scopes
## Framework vs Pure
## Ports + Adapters + Test Doubles
## Lifecycle
## Circular Dependencies
## Testing Strategy
## Anti-Patterns Avoided
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Dependency graph** — Mermaid `graph TD`
- **Lifetime layering** — Mermaid `graph LR`

---

## Assessment and planning policy

- Constructor default
- One composition root
- Lifetimes documented
- Ports + adapters
- Deterministic ports
- No service locator
- Framework-free domain
- No fabricated deps

---

## Self-check

```
[] Injection style per category
[] Composition root located
[] Lifetimes per dependency
[] Framework vs pure justified
[] Deterministic ports
[] Lifecycle hooks
[] Circular-dep prevention
[] Testing approach
[] Anti-patterns avoided
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No language / architecture | Interview mode (§7) |
| Service locator present | Flag + migration plan |
| 10+ constructor deps | Split service |
| Domain framework-bound | Port-adapter separation |
| Circular deps | Seam fix, not setter dance |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Constructor is default
- [ ] Domain is framework-free
- [ ] Lifetimes thread-safe
- [ ] Clock/RNG/IdGen as ports
- [ ] Lifecycle hooks cover start + shutdown
- [ ] Tests build graphs without container

---

## Examples

### Normal cases

**1. Go service**
- Input: Go + Gin + Postgres + Kafka
- Expected: Manual DI at `main`; Clock port; per-request context only for request values; connection pool singleton; transaction scoped

**2. NestJS backend**
- Input: TypeScript + NestJS
- Expected: Module-based DI; providers singleton by default; `REQUEST` scope for per-request; composition at `AppModule`

**3. Spring Boot Java service**
- Input: Spring + JPA
- Expected: Constructor injection (no field); `@Service` singleton; `@RequestScope` for per-request; `@PostConstruct`/`@PreDestroy`

**4. Python FastAPI**
- Input: FastAPI + SQLAlchemy
- Expected: `Depends()` for per-request session; repository classes constructor-injected; manual Clock provider

**5. .NET web API**
- Input: .NET 8 + EF Core
- Expected: `IServiceCollection` in `Program.cs`; scoped `DbContext`; singleton `IOptions<Config>`; deterministic ports for Clock

### Edge cases

**6. Existing service locator**
- Input: Legacy locator usage
- Expected: Flag as anti-pattern; migration plan module by module

**7. Per-tenant scoping**
- Input: Multi-tenant SaaS with tenant-specific config
- Expected: Factory pattern keyed on tenant; cache with eviction; audit on creation

**8. Circular dep detected**
- Input: `A → B → A`
- Expected: Propose seam (extract shared port) or inversion; never setter injection with null dance

### Failure cases

**9. No language**
- Input: "Plan DI"
- Expected: Interview — language + architecture + existing approach

**10. Implementation request**
- Input: "Plan + code the wiring"
- Expected: "Design only."
