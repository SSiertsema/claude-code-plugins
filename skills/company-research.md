# Company Research

| Field | Value |
|---|---|
| `name` | `company-research` |
| `purpose` | Autonomously research a named company from public web sources and produce a single self-contained HTML brief tailored for sales/outreach preparation. Identifies decision-makers, recent activity, and grounded conversation hooks. |
| `primary_category` | `extraction` |
| `secondary_category` | — |
| `output_mode` | `human_readable` |
| `output_format` | `html` *(override of §10 controlled vocab — see [Foundation overrides](#foundation-overrides))* |
| `mixins` | `[autonomous-research]` |
| `version` | `1.0.0` |

---

## Purpose

Pull together a single, citation-grounded HTML brief about a company so a sales/outreach professional can walk into a first conversation informed. Surfaces the people who matter (decision-makers, recent hires, public faces), the events that matter (last 12 months of activity), and the conversation hooks that turn that data into an opening line. Every fact is traceable to a public-source URL.

---

## When to use

- Preparing for a discovery call, demo, or cold outreach to a specific company
- Building an account plan that needs decision-maker mapping
- Auditing a target account's public profile before an outbound campaign
- Refreshing existing account intel with recent activity (new hires, launches, talks)

## When not to use

- Need email addresses, phone numbers, or other private contact data → out of scope (skill refuses)
- Need competitive positioning analysis → use `competitive-analysis`
- Need market sizing → use `market-sizing`
- Need candidate sourcing for recruiting → wrong bias (this skill optimizes for sales-relevant signals)
- Company has only login-gated presence (LinkedIn-only) → skill produces minimal brief, flags low coverage

---

## Required input

| Field | Type | Description |
|---|---|---|
| `company_name` | string | Name of the company to research |

## Optional input

| Field | Type | Description |
|---|---|---|
| `company_website` | URL | Skips disambiguation step |
| `industry_hint` | string | Narrows disambiguation when name is ambiguous |
| `target_role_focus` | string | Function to emphasize (e.g., `"engineering leadership"`, `"RevOps"`) |
| `region` | string | Country or region for disambiguation and source weighting |
| `output_path` | path | Override for the default output location |

## Input schema

```yaml
company_name: string         # required
company_website: string?     # URL
industry_hint: string?
target_role_focus: string?
region: string?
output_path: string?         # default: /documentation/{slug}/company-research/{slug}.html
```

---

## Processing rules

### Phase 1 — Setup

1. If no `company_name` provided, enter interview mode (foundation §7). Only ask for the company name. Everything else is optional.
2. WebSearch the company name. If multiple plausible entities, present top 3–5 candidates with one-line distinguishers and ask the user to pick. Do not guess.
3. Present scope summary (name, website, industry, role focus, region, output path) and ask for confirmation.

### Phase 2 — Research pipeline

Execute 11 steps in order. Capture per evidence: source URL, verbatim short quote, date of source. See SKILL.md for full query templates per step.

| Step | Source | Captures |
|---|---|---|
| 1 | Company website (about, team, leadership, careers, press) | Named people + roles |
| 2 | Company blog / engineering blog | Authors + post topics for timeline |
| 3 | News & press releases (last 12 months) | Quoted spokespeople + business events |
| 4 | Conference talks & podcast appearances | Speakers with role attribution |
| 5 | GitHub (org page + profile self-identification) | Engineers publicly affiliated |
| 6 | Google Scholar / arXiv | Paper authors + papers for timeline |
| 7 | Google Patents | Inventors + patents for timeline |
| 8 | SEC filings (US public co only) | Executive officers + directors |
| 9 | Crunchbase public pages | Founders + listed key people |
| 10 | Trade press & industry awards | Honorees with role attribution |
| 11 | Recent activity sweep (last 12 months) | Funding, M&A, launches, exec moves |

Per step: if WebSearch is empty, broaden once. If still empty, record the gap and proceed. Per WebFetch: if page is JS-heavy or empty, note the skip and try an alternative.

### Phase 3 — Synthesis

- **Deduplicate** people across sources by name + role similarity. Keep all source citations on the surviving card.
- **Group by function**: Leadership / GTM / Engineering / Product / Other.
- **Confidence assignment** per person:
  - `high`: company's own website OR ≥2 independent reputable sources
  - `medium`: one reputable third-party source with role attribution
  - `low`: weaker signal (GitHub profile alone, single secondary mention)
- **Recency tag** per person: date of source the displayed role came from.
- **Role conflicts**: keep both, flag in the card, prefer most recent for the displayed title.
- **Outreach hooks**: 5–10 specific, dated, person/team-tied conversation starters.

If `target_role_focus` was provided, surface that function group first and elaborate it.

### Phase 4 — Render HTML

Produce a single self-contained HTML file (embedded CSS, no external assets). Sections in order:

1. `<header>` — company name, generation date
2. `#snapshot` — `<dl>` of HQ, industry, founded, size estimate, funding stage, description (each `<dd>` cited)
3. `#timeline` — `<ol>` chronological (newest first) with date + event + citation
4. `#roster` — function-grouped `<section>` blocks, each with a `<div class="card-grid">` of `<article class="person-card">` elements
5. `#hooks` — `<ol>` of outreach hooks, each cited
6. `#sources` — `<ol>` with `id="src-N"` per entry: linked title, publication, access date
7. `#assumptions` — `<ul>` of gaps, conflicts, low-confidence areas
8. `<footer>` — policy statement

Style: system font stack, max width ~880px, card grid with `repeat(auto-fill, minmax(280px, 1fr))`, confidence badges (green/amber/grey), print-friendly `@media print` block.

Citations: every claim ends with `<sup><a href="#src-N">[N]</a></sup>`. Source numbers are stable per URL.

### Phase 5 — Hand-off

Print: absolute output path, one-line coverage summary, top 3 outreach hooks as preview. Flag if coverage is thin (≤3 people or ≤5 sources).

---

## Output contract

A single self-contained HTML file at the agreed output path. Filename pattern: `{company-slug}.html`. Default directory: `/documentation/{company-slug}/company-research/`.

### Required HTML sections (in order)
- `header` with `h1` (company name) and generation date
- `section#snapshot` — `dl` with cited `dd` for HQ, Industry, Founded, Size estimate, Funding stage, Description
- `section#timeline` — `ol.timeline` with `date` + `event` per `li`, cited
- `section#roster` — function-grouped subsections with `div.card-grid` of `article.person-card`
- `section#hooks` — `ol` of cited outreach hooks
- `section#sources` — `ol` with `li id="src-N"`, each with linked title + publication + access date
- `section#assumptions` — `ul` of gaps and conflicts
- `footer` with policy statement

### Required fields per person card
- Name
- Role (most recent if conflict)
- Evidence quote (verbatim, short)
- Confidence badge (`high` / `medium` / `low`)
- Recency tag (date of source)
- Source link (`<sup><a href="#src-N">[N]</a></sup>`)

### Schema rules (extraction extension)
- Every field traceable to a source URL
- Missing fields marked or omitted, never guessed
- Per-source completeness reported in the brief preamble printed at hand-off
- No values invented beyond what the source states

### Sources section contract (autonomous-research mixin)
- Numbered `<ol>` with stable IDs `src-1`, `src-2`, …
- Each entry: linked title, publication, access date
- One entry per unique URL consulted

### Assumptions & limitations section contract (autonomous-research mixin)
- Explicit list of gaps encountered (steps that returned nothing, JS-heavy pages skipped, conflicts left unresolved, low-coverage areas)

---

## Foundation overrides

| Override | Reason |
|---|---|
| Output format = `html` (not in §10 controlled vocab `markdown\|json\|plain_text\|table`) | User requested HTML deliverable for visual presentation and browser viewing. Embedded CSS makes it portable and printable. Does not violate safety rules. |

---

## Failure behavior

| Situation | Behavior |
|---|---|
| `company_name` missing | Enter interview mode, ask only for the company name |
| Multiple plausible companies match the name | Present candidates, ask user to pick, do not guess |
| No public web presence found | Produce minimal HTML brief, flag low coverage in Assumptions, list searches attempted |
| WebFetch returns JS-heavy or empty page | Note the skip in Assumptions, try an alternative source |
| Conflicting roles across sources for one person | Keep both in the card, flag the conflict, prefer most recent for the displayed title |
| User requests email, phone, or other private data | Refuse, state public-sources-only policy, do not produce that data |
| User asks to scrape login-gated platforms | Refuse, state policy |
| WebSearch returns nothing for a pipeline step | Broaden the query once; if still empty, record the gap and proceed |
| Output path already exists | Confirm overwrite with the user before writing |
| Browser rendering of generated HTML fails (malformed) | Validate structure before hand-off; fix and re-render |

---

## Quality checks

- [ ] Every claim in the HTML cites a source via `<sup>[N]</sup>` linking to `#src-N`
- [ ] No private contact data (email, phone) anywhere in the output
- [ ] Every person card has all required fields (name, role, evidence quote, confidence, recency, source link)
- [ ] People are deduplicated across sources; role conflicts flagged
- [ ] Roster is grouped by function (Leadership / GTM / Engineering / Product / Other)
- [ ] Outreach hooks are specific, dated, and tied to a cited piece of activity
- [ ] Sources section lists every URL consulted with access date
- [ ] Assumptions & limitations section names every gap or low-confidence area
- [ ] HTML is self-contained (no external CSS, JS, or font URLs)
- [ ] HTML opens and renders correctly in a modern browser offline
- [ ] Output path follows the default convention or a user-confirmed override
- [ ] Coverage summary printed at hand-off (people count, function count, source count, timeline event count)

---

## Examples

### Normal cases

**N1 — Mid-size SaaS company, sales targeting RevOps**
- Input: `company_name: "Drift"`, `target_role_focus: "RevOps"`
- Behavior: Disambiguates Drift the conversational marketing company (acquired by Salesloft) from other Drifts. Crawls website, finds leadership and RevOps page. Pulls news of acquisition + recent product launches. GitHub yields engineering names. Outputs HTML with RevOps function group surfaced first.

**N2 — Public US company, no role focus**
- Input: `company_name: "Snowflake"`
- Behavior: Adds SEC step (10-K, DEF 14A) for executive officers + directors. Pulls earnings call quotes for spokespeople. Conference talks (Snowflake Summit) yield many engineers. Roster spans all five function groups.

**N3 — Early-stage startup with thin web footprint**
- Input: `company_name: "Tessl"`, `industry_hint: "AI dev tools"`
- Behavior: Limited web presence. Crawls website, pulls founder from Crunchbase, captures 2–3 blog post authors, finds a recent funding press release. Flags low coverage in Assumptions. Outreach hooks tied to founder's recent talks.

**N4 — European company with regional focus**
- Input: `company_name: "Adyen"`, `region: "Netherlands"`
- Behavior: Disambiguates against any other Adyen. Pulls Dutch trade press (Het Financieele Dagblad mentions). SEC step skipped (Euronext Amsterdam, not US). Captures executives from annual report instead.

**N5 — Company with strong engineering brand**
- Input: `company_name: "Stripe"`, `target_role_focus: "engineering leadership"`
- Behavior: Engineering blog yields many named authors. GitHub org page reveals engineers. Papers + patents add named technical contributors. Engineering function group is densely populated; other groups are present but compact.

### Edge cases

**E1 — Recent rebrand**
- Input: `company_name: "Meta"`
- Behavior: Disambiguates "Meta" vs. "Meta Platforms" vs. earlier "Facebook" references. Confirms canonical entity. Notes the rebrand date in the timeline. Sources span both old and new names.

**E2 — Subsidiary of a larger group**
- Input: `company_name: "Instagram"`
- Behavior: Notes parent (Meta Platforms). Asks user whether to focus on the subsidiary or include parent-level executives. Surfaces the subsidiary's own product leadership prominently.

**E3 — Stealth-mode company with minimal public surface**
- Input: `company_name: "[stealth startup name]"`
- Behavior: Returns minimal brief. Snapshot has few cited fields. Roster may have only 1–2 people. Assumptions section explicitly lists the absence of a public website, blog, GitHub presence, or news mentions. Hand-off flags low coverage.

### Failure cases

**F1 — Request for private contact data**
- Input: `company_name: "Acme Corp"`, follow-up: "include email addresses for everyone"
- Behavior: Refuses inline. States: "This skill produces public-source data only. Email addresses are not within scope." Continues with the brief without emails.

**F2 — Ambiguous name, user does not pick**
- Input: `company_name: "Apple"`, user declines to disambiguate Apple Inc. vs. Apple Bank vs. Apple Hospitality REIT
- Behavior: Does not proceed. States: "Cannot proceed without disambiguation — three plausible entities match. Please pick one to continue."
