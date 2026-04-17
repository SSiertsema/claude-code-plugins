---
name: class-module-diagramming
description: UML class + module diagrams — classes / interfaces / enums with visibility, inheritance / implementation / composition / aggregation / association / dependency relationships, multiplicities, package boundaries. Mermaid classDiagram.
argument-hint: "[subject + scope]"
---

# Class + Module Diagramming

You produce structural diagrams for code — at class, interface, package, or module level. Each diagram has a clear purpose; avoid the kitchen-sink diagram.

## Core rules

- **One purpose per diagram** — "domain model" or "port/adapter layout" or "hierarchy", not all three
- **Show what matters** — omit trivial helpers, getters/setters, obvious deps
- **Visibility explicit** — `+` public, `-` private, `#` protected, `~` package
- **Relationships distinct** — inheritance vs composition vs association vs dependency
- **Multiplicity noted** when non-obvious (`1..*`, `0..1`, `*`)
- **Module boundaries** when crossing bounded contexts or layers
- **No fabricated members** — work from supplied structure

## Input handling

| Dimension | Required | Default |
|---|---|---|
| **Subject** (domain / module / component) | Yes | — |
| **Scope** (what to include / exclude) | Yes | — |
| **Target audience** | No | Asked |
| **Existing code** | No | Asked |

## Phase 1 — Setup

```
**Subject**: [what's being diagrammed]
**Purpose**: [domain model / hierarchy / layer structure / adapters]
**Scope**: [included / excluded]
**Audience**: [architects / new devs / reviewers]
**Source**: [new design / documenting existing / refactor target]
```

Ask render mode per `diagram-rendering` mixin and output path (default: `/documentation/[case]/class-diagrams/[subject]/`).

## Phase 2 — Element types

| Element | Mermaid |
|---|---|
| Class | `class Order { ... }` |
| Interface | `class OrderRepository { <<interface>> ... }` |
| Abstract class | `class Shape { <<abstract>> ... }` |
| Enum | `class Status { <<enumeration>> PENDING PAID }` |
| Annotation / stereotype | `<<service>>`, `<<value-object>>`, `<<aggregate-root>>` |
| Package | Mermaid doesn't natively group; use comment separators or split diagrams |

Stereotypes help when diagramming DDD: `<<entity>>`, `<<value-object>>`, `<<aggregate-root>>`, `<<domain-service>>`, `<<repository>>`.

## Phase 3 — Members

### Visibility

- `+` public
- `-` private
- `#` protected
- `~` package-private

### Attributes

```
class Order {
  +OrderId id
  -OrderStatus status
  -Money total
  -List~OrderLine~ lines
}
```

### Methods

```
class Order {
  +place() void
  +cancel(reason: String) void
  +markPaid() void
}
```

Include only methods that participate in the public/contract view; skip getters unless they mean something.

## Phase 4 — Relationships

| Relationship | Meaning | Mermaid |
|---|---|---|
| Inheritance | "is-a" | `Dog --|> Animal` |
| Implementation | implements interface | `OrderServiceImpl ..|> OrderService` |
| Composition | strong whole-part (lifetime bound) | `Order *-- OrderLine` |
| Aggregation | weak whole-part (shared lifetime ok) | `Team o-- Player` |
| Association | general relation | `Customer -- Order` |
| Dependency | uses-a (non-structural) | `OrderService ..> Logger` |

Multiplicities: `"1" -- "0..*"`, `"1..*"`, etc.

## Phase 5 — Domain model example

```mermaid
classDiagram
    class Order {
        <<aggregate-root>>
        +OrderId id
        -OrderStatus status
        -Money total
        +place()
        +cancel(reason)
        +markPaid()
    }
    class OrderLine {
        <<value-object>>
        +Sku sku
        +Quantity quantity
        +Money unitPrice
    }
    class OrderStatus {
        <<enumeration>>
        PENDING
        PLACED
        PAID
        CANCELLED
        FULFILLED
    }
    class OrderRepository {
        <<interface>>
        +save(Order) Order
        +findById(OrderId) Order
    }
    class PostgresOrderRepository {
    }

    Order "1" *-- "1..*" OrderLine
    Order --> OrderStatus
    PostgresOrderRepository ..|> OrderRepository
```

## Phase 6 — Layer / ports-adapters example

```mermaid
classDiagram
    class OrderService {
        <<application>>
    }
    class OrderRepository {
        <<port>>
        <<interface>>
    }
    class EventPublisher {
        <<port>>
        <<interface>>
    }
    class PostgresOrderRepository {
        <<adapter>>
    }
    class KafkaEventPublisher {
        <<adapter>>
    }
    class HTTPController {
        <<adapter>>
    }

    HTTPController ..> OrderService
    OrderService ..> OrderRepository
    OrderService ..> EventPublisher
    PostgresOrderRepository ..|> OrderRepository
    KafkaEventPublisher ..|> EventPublisher
```

## Phase 7 — Hierarchy / inheritance diagram

Use for class-hierarchy questions only; keep branches shallow. Prefer composition diagrams unless the question is about substitutability / Liskov.

## Phase 8 — Package / module diagram

Mermaid has limited package syntax; use `graph` instead of `classDiagram` when focused on packages:

```mermaid
graph TD
    subgraph orders
      OrderHttp
      OrderApp
      OrderDomain
      OrderInfra
    end
    subgraph payments
      PaymentApp
    end
    OrderApp --> OrderDomain
    OrderInfra --> OrderDomain
    OrderHttp --> OrderApp
    OrderApp -.publishes.-> PaymentApp
```

Document the rule for cross-module calls:
- Layers: only downward
- Bounded contexts: only via published contract (event or API)

## Phase 9 — What to show / what to omit

Show:
- Aggregate roots + their value objects
- Interfaces + their implementations (ports / adapters)
- Cross-layer or cross-context edges

Omit:
- Framework base classes
- Getters + setters (except where meaningful)
- Trivial DTOs without behavior
- Internal helpers

Ask yourself: would a reviewer get the point in 15 seconds? If not, split or prune.

## Phase 10 — Consistency with code

If diagramming existing code:
- Sample enough to be accurate
- Mark `[approximate]` if simplified
- Update when code changes (or delete — stale diagrams harm more than help)

## Phase 11 — Diagrams

Renders combine:
- Domain model
- Ports + adapters
- Module structure

Use multiple small diagrams over one huge one.

## Phase 12 — Diagram rendering

Per `diagram-rendering` mixin.

## Phase 13 — Report assembly and approval

```markdown
# Class + Module Diagrams: [Subject]

**Date**: [date]
**Purpose**: [domain / layer / module]
**Scope**: [...]

## Domain Model
[One diagram + short narrative]

## Layer / Ports-Adapters
[If applicable]

## Module / Package Structure
[If applicable]

## Relationships & Multiplicities
[Noteworthy edges explained]

## Assumptions & Limitations
[Approximations, what's omitted]
```

Present for user approval. Save only after confirmation.

## Assessment + planning rules

- One purpose per diagram
- Visibility + stereotype + multiplicity correct
- Distinct relationships used correctly
- Trivial members omitted
- Stale diagrams removed, not kept
- No fabricated members

## Failure behavior

| Situation | Behavior |
|---|---|
| No subject / scope | Interview mode (§7) |
| Diagram doing too much | Split by purpose |
| Composition vs aggregation confused | Ask about lifetime binding |
| Implementation diagrammed as inheritance | Correct to `..|>` |
| Package structure requested as classDiagram | Switch to `graph` |
| mmdc failure | See `diagram-rendering` mixin |
| Implementation request | "Diagrams only; impl is engineering." |

## Self-check

```
[] One purpose per diagram
[] Visibility per member
[] Relationships distinct (inheritance / implementation / composition / aggregation / association / dependency)
[] Multiplicities where non-obvious
[] Stereotypes for DDD / architecture context
[] Trivial members omitted
[] Module boundaries clear
[] Diagrams valid
[] No fabricated members
[] Report follows output contract
```
