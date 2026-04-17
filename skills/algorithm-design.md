# Algorithm Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | algorithm-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs an algorithm before production implementation. Frames problem (precise statement + inputs/outputs with types and ranges + constraints including size bounds, latency budget, memory cap, stability requirement + correctness criteria + assumptions). Compares at least two candidate approaches on time + space complexity, in-place vs extra memory, stability (for sorts), parallelizability, trade-offs. Selects one with justification. States invariants (loop invariants, data-structure invariants, global invariants) as scaffolding for correctness. Produces language-neutral pseudocode annotated with pre/post-conditions and loop invariants. Argues correctness via loop-invariant proof (initialization / maintenance / termination), structural induction, invariant preservation, or reduction to a solved problem. Lists edge cases from category catalog (empty, single, already-sorted, reverse, all-equal, large, overflow-prone, unicode/nulls, negative/zero). Complexity analysis: worst / average / best, amortized where relevant, hidden constants if they matter at scale. Failure + numerical concerns (overflow, floating-point, cancellation, determinism, concurrency safety). Test strategy with property-based tests + boundary + performance + fuzz + regression. Parallelization + out-of-core + streaming variants considered. Mermaid control-flow + recursion-tree with PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Tone** | `technical` |
| **Audience** | `technical` |
| **Output format** | `markdown` |
| **Creativity level** | `low` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- Non-trivial algorithmic problem pre-build
- Reviewing a proposed approach for correctness + cost
- Migrating from a naive to a scalable approach
- Formalizing a historically-hacky internal algorithm

## When not to use

- API / contract design → `api-design` / `api-contract-specification`
- Whole component design → `component-design-documentation`
- Error-handling strategy → `system-error-handling-strategy`
- Data schema → `conceptual-data-modeling`

---

## Required input

| Field | Description |
|---|---|
| **Problem statement** | Precise description |
| **Inputs + outputs** | Types and ranges |
| **Constraints** | Size, time, memory |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Correctness criteria** | How correctness is judged | Asked |
| **Target language / runtime** | For pseudocode flavor | Language-neutral |
| **Diagram render mode** | `code` / `image` | `code` |
| **Output path** | Save location | `/documentation/[case]/algorithm-design/[problem]/` |

## Input schema

```
input:
  required:
    problem: string
    inputs: array[object]
    outputs: array[object]
    constraints: object
  optional:
    correctness_criteria: string
    target_language: string
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
      dependency_if_image: "@mermaid-js/mermaid-cli (mmdc)"
    output_path: string
```

---

## Processing rules

### Phase 1 — Problem framing
Statement, inputs, outputs, constraints, correctness, assumptions.

### Phase 2 — Candidate approaches
≥ 2 candidates with complexity + trade-offs.

### Phase 3 — Chosen approach
Justify selection against constraints.

### Phase 4 — Invariants
Loop / data-structure / global.

### Phase 5 — Pseudocode
Annotated with pre/post-conditions + invariants.

### Phase 6 — Correctness argument
Loop invariant / induction / preservation / reduction.

### Phase 7 — Edge cases
From category catalog.

### Phase 8 — Complexity analysis
Worst / average / best + amortized + hidden constants.

### Phase 9 — Failure + numerical concerns
Overflow / floating-point / determinism / concurrency.

### Phase 10 — Test strategy
Property-based + boundary + performance + fuzz + regression.

### Phase 11 — Parallelization + scale
Divide points, out-of-core, streaming, distributed.

### Phase 12 — Alternatives + rejections
Short rationale per rejection.

### Phase 13 — Diagrams
Control flow + recursion tree.

### Phase 14 — Diagram rendering
Per mixin.

### Phase 15 — Report assembly and approval
Approval before save.

---

## Output contract

```markdown
# Algorithm Design: [Problem]

**Date**: [date]

## Problem
## Inputs + Outputs + Constraints
## Candidate Approaches
## Comparison
## Chosen Approach
## Invariants
## Pseudocode
## Correctness Argument
## Edge Cases
## Complexity Analysis
## Failure + Numerical Concerns
## Test Strategy
## Parallelization + Scale
## Alternatives + Rejections
## Diagrams
## Hand-offs
## Assumptions & Limitations
```

### Diagrams
- **Control flow** — Mermaid `flowchart TD`
- **Recursion tree** — Mermaid `graph TD`

---

## Assessment and planning policy

- Problem + constraints explicit
- Multiple candidates compared
- Invariants stated
- Correctness argued
- Edge cases listed
- Complexity honest
- Test strategy included
- No fabricated constraints

---

## Self-check

```
[] Problem + constraints stated
[] ≥2 candidates
[] Complexity per candidate
[] Invariants for chosen approach
[] Correctness argued
[] Edge cases covered
[] Numerical + concurrency concerns
[] Test strategy proposed
[] Pseudocode precise
[] Alternatives rejected with rationale
[] Diagrams valid
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No constraints | Interview mode (§7) |
| One candidate | Ask for alternative |
| Complexity glossed | Require worst / avg / space |
| Edge cases missing | Generate from catalog |
| Known library exists | Recommend; explain why |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | Out of scope |

---

## Quality checks

- [ ] Problem precisely stated
- [ ] Multiple candidates with honest comparison
- [ ] Invariants spelled out
- [ ] Correctness reasoning not hand-waved
- [ ] Edge cases comprehensive
- [ ] Complexity worst/avg/space
- [ ] Numerical + concurrency + determinism addressed
- [ ] Property-based + boundary tests proposed

---

## Examples

### Normal cases

**1. Top-K elements in a stream**
- Input: Unbounded stream; k small
- Expected: Compare heap-of-k vs count-min + quickselect; heap-of-k chosen; O(n log k); invariants; streaming variant

**2. Deduplicate events with near-duplicate tolerance**
- Input: Event payloads + similarity threshold
- Expected: Compare hash + MinHash+LSH; MinHash+LSH chosen; false-positive / false-negative rates; test with corpus

**3. Rate-limiter algorithm (internal)**
- Input: Per-user limits
- Expected: Token bucket vs sliding-window; GCRA chosen; invariants on refill; edge cases: clock skew, burst

**4. Graph shortest path with constraints**
- Input: Weighted DAG with time windows
- Expected: Dijkstra vs BFS vs topo-order DP; topo DP chosen; complexity + memory

**5. Large-file diff**
- Input: Two files possibly larger than memory
- Expected: Myers diff baseline; streaming chunked variant; out-of-core considerations

### Edge cases

**6. Library already solves it**
- Input: "Design sorting algorithm for 10-element arrays"
- Expected: "Use language sort; here's why"; document edge cases + invariants if custom needed

**7. Numerical instability risk**
- Input: Summing floats in any order
- Expected: Flag cancellation; recommend Kahan / pairwise summation

**8. Parallel safety**
- Input: Shared counter increments
- Expected: CAS / atomic; ABA problem; memory ordering

### Failure cases

**9. No constraints**
- Input: "Design an algorithm"
- Expected: Interview — problem, inputs, sizes

**10. Implementation request**
- Input: "Design + code"
- Expected: "Design only."
