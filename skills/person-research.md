# Person Research — Digital Footprint Audit

| Field | Value |
|---|---|
| `name` | `person-research` |
| `purpose` | Autonomously surface every publicly findable item about a named person across self-published channels, third-party publications, and leaked-but-public sources; produce a single self-contained HTML brief with origin badges and a prioritized takedown action list so the subject can request removal. |
| `primary_category` | `extraction` |
| `secondary_category` | — |
| `output_mode` | `human_readable` |
| `output_format` | `html` *(override of §10 controlled vocab — see [Foundation overrides](#foundation-overrides))* |
| `mixins` | `[autonomous-research]` |
| `version` | `1.0.0` |

---

## Purpose

Help the subject of the dossier see and act on their own digital footprint. The output is intended to be shared with that person so they can decide what to keep, what to remove, and where to act. Every item carries:

1. Where it came from (`self-published`, `third-party`, or `leaked-but-public`)
2. The exact source URL
3. A removal route and an estimated removal difficulty

The skill operates on the explicit framing: **all included content is publicly findable; the value is in surfacing and routing it for action, not in concealing it.**

---

## When to use

- A person wants a complete view of what's publicly findable about them (right-to-erasure preparation, reputation audit, pre-job-search cleanup)
- A privacy professional is preparing a takedown campaign on behalf of a client
- An employer is preparing an offboarding handover for a departing public-facing employee
- A subject of past harassment wants to map and address residual online traces

## When not to use

- Sales / outreach prospect prep — use `company-research` and its person cards instead (no takedown list, no leaks section)
- Recruiting / sourcing — purpose mismatch (this skill surfaces content the subject likely wants removed, not signals you'd evaluate them on)
- Investigating a third party against their interests (stalking, doxxing, harassment) — refuse
- Researching a minor without explicit guardian consent — refuse
- Confirming identity for security/KYC purposes — wrong tool, no authoritative ID layer

---

## Required input

| Field | Type | Description |
|---|---|---|
| `full_name` | string | First + last name of the subject |

## Optional input

| Field | Type | Description |
|---|---|---|
| `current_employer` | string | Disambiguator |
| `city` / `region` | string | Disambiguator |
| `profession` / `role` | string | Disambiguator |
| `profile_url` | URL | Known profile (LinkedIn, personal site, X handle) — strong disambiguator |
| `birth_year` | number | Disambiguator — only solicited if user volunteers |
| `email` | string | Used for breach lookups — only solicited if user volunteers |
| `output_path` | path | Override default location |

## Input schema

```yaml
full_name: string                # required
current_employer: string?
city: string?
region: string?
profession: string?
profile_url: string?             # URL
birth_year: number?
email: string?
output_path: string?             # default: /documentation/{slug}/person-research/{slug}.html
```

---

## Processing rules

### Phase 1 — Setup

1. If `full_name` missing → interview mode; ask only for name.
2. Candidate sweep: WebSearch the name, cluster results into distinct candidates, present **all plausible candidates** with one-line disambiguators. Long tail of low-signal hits grouped under "Other candidates — N people, low signal."
3. Do not proceed until exactly one candidate is confirmed by the user. Mixing two people is a critical failure.
4. Confirm scope + output path.

### Phase 2 — Research pipeline

22 source classes across three origin categories:

**Self-published (S1–S7)**: personal site/blog; social profiles (X, Mastodon, Bluesky, Threads, LinkedIn, Facebook, Instagram, TikTok, YouTube, Twitch, Reddit user); code platforms (GitHub, GitLab, npm/PyPI/Crates, Stack Overflow, Hacker News user, dev.to); long-form (Medium, Substack, newsletters); audio/video (own channels, podcast host); creator profiles (Goodreads, Behance, Dribbble, ArtStation, Bandcamp, Patreon); speaker pages.

**Third-party (T1–T10)**: news/interviews; co-authored papers (Scholar, arXiv, ResearchGate, ORCID); patents; corporate filings (KvK, SEC, Companies House); court records (rechtspraak.nl, CourtListener); Wikipedia/Wikidata; forum mentions ABOUT the person; awards/honoree lists; image search (Google Images, TinEye); Wayback Machine.

**Leaked-but-public (L1–L4)**: breach databases (meta only — no payload); pastebins/ghostbins (existence only); doxbins/harassment archives (existence only, urgency-flagged); old database dumps that surfaced publicly.

Per item capture: title, source URL, platform, date, brief description (1–2 lines, neutral), origin category. Then derive: removal route + difficulty.

### Phase 3 — Synthesis

**Required fields per item**: title, source URL, origin badge, platform, date, description, removal route, removal difficulty (`easy` / `medium` / `hard` / `very-hard` / `not-removable`).

**Removal route catalog** (see SKILL.md for full table):
- Own social → app settings, easy
- Third-party news → editor email + GDPR Art. 17, medium-hard
- Wikipedia → talk page, medium-hard
- Google Search cached → Google removal tools, medium
- Wayback Machine → email archive.org, hard
- Court records → generally not removable, anonymization request possible in EU
- KvK officer listing → cannot remove while serving
- Patents → not removable (public record)
- HIBP breach → not removable from HIBP; address source breached service
- Doxbins → site abuse form, often unresponsive — escalate to hosting/police if threats

**Sorting**:
- Within each origin section: by removal difficulty (easy first), then recency
- Takedown action list: by urgency (leaked > sensitive third-party > old forgotten content > rest), then by ease (quick wins first)

### Phase 4 — Render HTML

Single self-contained HTML file at the agreed path. Embedded CSS, no external assets.

Sections in order:
1. `<header>` — name + generation date
2. **Intent banner** — yellow border-left, explains the document is meant to be shared with the subject for action
3. `#identity` — public identity snapshot (confirmed disambiguators, active handles, public role)
4. `#self-published` — card grid, origin badge `self`
5. `#third-party` — card grid, origin badge `third`
6. `#leaked` — card grid with subtle warning background, origin badge `leaked`; if empty, render "No leaked-but-public items found"
7. `#takedown` — ordered action list, sorted by urgency + ease
8. `#sources` — numbered `<ol>` with stable `id="src-N"` per entry
9. `#assumptions` — gaps and limitations
10. `<footer>` — policy statement

**Visual conventions**:
- Origin badges: blue (self), purple (third), red/orange (leaked)
- Difficulty badges: green (easy), amber (medium), orange (hard), red (very-hard), grey (not-removable)
- Card grid: `repeat(auto-fill, minmax(300px, 1fr))`, max width ~960px
- Print styles via `@media print`

### Phase 5 — Hand-off

Print: absolute path, coverage summary (X self / Y third / Z leaked / N sources), top-3 takedown preview, suggestion to share HTML with subject. Prominent flag if any leaked-but-public items found.

---

## Output contract

A single self-contained HTML file at the agreed output path. Filename: `{name-slug}.html`. Default directory: `/documentation/{name-slug}/person-research/`.

### Required HTML sections (in order)
1. `header` with `h1` (name) + generation date
2. `div.intent-banner` — purpose statement
3. `section#identity` — `dl` of confirmed disambiguators + public role + active handles (each cited)
4. `section#self-published` — card grid with origin badge
5. `section#third-party` — card grid with origin badge
6. `section#leaked` — card grid with warning treatment and origin badge
7. `section#takedown` — ordered action list sorted by urgency then ease
8. `section#sources` — `ol` with `li id="src-N"` per entry; linked title, publication, access date
9. `section#assumptions` — `ul` of gaps and limitations
10. `footer` — policy statement

### Required per-item fields (every card)
- Title
- Source URL (linked + cited)
- Origin badge (`self-published` / `third-party` / `leaked-but-public`)
- Platform (specific domain or service)
- Date (publication or last-seen)
- Brief description (1–2 lines, neutral, no payload from leaks)
- Removal route (concrete steps; "no standard route" if unknown)
- Removal difficulty (`easy` / `medium` / `hard` / `very-hard` / `not-removable`)

### Required per-takedown-action fields
- Item title (links back to card)
- Difficulty badge
- Concrete next step (1 sentence)
- Source URL + citation

### Schema rules (extraction extension)
- Every field traceable to a source URL
- Missing/unknown fields marked, never guessed
- Coverage reported at hand-off (counts per origin + total sources)
- No payload contents from leaks anywhere in output

### Sources section contract (autonomous-research mixin)
- Numbered `<ol>` with stable `id="src-N"`
- Linked title + publication + access date per entry

### Assumptions & limitations section contract (autonomous-research mixin)
- Explicit list of gaps (platforms not reachable, blocked archives, candidates ruled out, breach-DB access status, sources skipped due to JS-heavy pages)

---

## Foundation overrides

| Override | Reason |
|---|---|
| Output format = `html` (not in §10 controlled vocab) | User requested HTML deliverable for visual presentation and direct shareability with the subject. Embedded CSS makes it portable and printable. |
| Leak content rendering | Foundation §8 requires not extending scope; this skill explicitly includes leaked-but-public items as a category, but constrains them to metadata only (no payload contents). The constraint is the safety boundary, not the inclusion. |

---

## Failure behavior

| Situation | Behavior |
|---|---|
| `full_name` missing | Interview mode, ask only for the name |
| Common name, multiple plausible candidates | List all plausible candidates with disambiguators, ask user to pick — do not proceed with mixing |
| User cannot disambiguate | Produce a candidate list only, no dossier — do not guess |
| No public footprint found | Produce minimal HTML stating: "No significant public footprint found across [platforms searched]" — list platforms searched in Assumptions |
| Breach database not accessible | Note in Assumptions, do not fabricate breach entries |
| Leak source contains payload contents | Reference existence + meta only; do not transcribe |
| User requests payload contents from leaks | Refuse, state policy |
| User requests dossier on a minor (under 18) | Refuse unless explicit guardian consent stated in input — refuse otherwise |
| User requests dossier "against" a target (stalking signals) | Refuse — the skill is for subjects to audit their own (or commissioned) footprint, not for adversarial research |
| Court record substantive details exposed | Reference existence + public summary only — do not retell case substance |
| Wayback or archive.today snapshot of removed content | Include but flag as archive — note that archive.today does not honor removal requests |
| Source URL no longer accessible | Note skipped; if cached version exists, link to that |

---

## Quality checks

- [ ] Every item carries an origin badge (`self-published` / `third-party` / `leaked-but-public`)
- [ ] Every item carries a removal route or explicit "no standard route" note
- [ ] Every item carries a removal-difficulty badge
- [ ] No leak payload contents (passwords, private messages, sensitive data dumps) appear anywhere
- [ ] Identity confirmed before research started — no mixing of namesakes
- [ ] Subject is not a minor (or guardian consent recorded in input)
- [ ] Takedown action list is sorted by urgency, then by ease
- [ ] Quick-win takedowns surface near the top of the list
- [ ] Sources section lists every URL consulted with access date
- [ ] Assumptions & limitations names every gap and skipped source
- [ ] HTML is self-contained, valid, opens correctly in a browser offline
- [ ] Output path follows `/documentation/[name-slug]/person-research/[name-slug].html` (or user-confirmed override)
- [ ] Intent banner is present and visible above the fold

---

## Examples

### Normal cases

**N1 — Mid-career tech professional, broad footprint**
- Input: `full_name: "Sven Siertsema"`, `current_employer: "Anthropic"` (hypothetical), `profile_url: "https://github.com/SSiertsema"`
- Behavior: Candidate sweep returns one strong match. Sweeps GitHub (own), X / LinkedIn / Mastodon (public), Medium (if any), conference speaker pages, Scholar (if any), KvK (NL officer listings), HaveIBeenPwned for any captured email. Brief is dense in self-published + third-party; leaked section lists ≥1 historical breach. Takedown list is mostly medium (third-party mentions) with a few easy wins (own old blog posts).

**N2 — Public figure with Wikipedia presence**
- Input: `full_name: "Mark Rutte"`
- Behavior: Skill flags this is a public figure with extensive coverage; produces dossier acknowledging that most third-party content is press-of-record and not realistically removable. Takedown list focuses on stale or inaccurate items, not the corpus.

**N3 — Private individual with thin footprint**
- Input: `full_name: "[private name]"`, `city: "Utrecht"`
- Behavior: Surface limited self-published items + maybe 1 third-party (school alumni page, hobby club listing). Leaked section may be empty. Brief is short, takedown list is short — likely quick wins only.

**N4 — Researcher / academic**
- Input: `full_name: "[researcher name]"`, `current_employer: "TU Delft"`
- Behavior: Heavy in Scholar / arXiv / ResearchGate / ORCID / patents. Self-published mostly long-form + speaker pages. Third-party rich with citation chains. Takedown list flags that papers are practically unremovable (`not-removable`).

**N5 — Former public officeholder**
- Input: `full_name: "[name]"`, `profession: "former mayor"`, `city: "Eindhoven"`
- Behavior: KvK / municipal-records prominent in third-party. Court records check (rechtspraak.nl). Historical news coverage. Takedown list realistic: stale items addressable, public-record items not.

### Edge cases

**E1 — Highly common name**
- Input: `full_name: "Jan Jansen"`, no disambiguators
- Behavior: Returns 20+ plausible candidates with disambiguators (city + role + employer). Refuses to proceed until user picks one or supplies more disambiguators.

**E2 — Subject explicitly requested a Right-to-be-Forgotten earlier**
- Behavior: Skill detects Google "Some results removed under EU data protection law" notice in search results; flags this in Assumptions and reports the implication: Google has already de-indexed some content, but the source pages still exist and are reachable via other indexes.

**E3 — Subject has the same name as a famous person**
- Input: `full_name: "Stefan King"` (or any conflict)
- Behavior: Disambiguation step is critical — the famous person dominates search results. Skill explicitly surfaces "famous person with this name" as Candidate 1 and asks: is this you? If not, requires further disambiguators to filter.

### Failure cases

**F1 — Request for payload contents from a leak**
- Input: `full_name: "[name]"`, follow-up: "show me the leaked passwords"
- Behavior: Refuses inline. States: "Leak payload contents are out of scope. The brief reports the existence + metadata of the breach. To rotate credentials, the subject should use the breached service's password-reset flow."

**F2 — Request for dossier on a minor without consent**
- Input: `full_name: "[child name]"`, `birth_year: 2015`
- Behavior: Refuses. States: "Person-research dossiers on minors require explicit guardian consent stated in the request. Please re-issue with consent declared, or provide a different subject."

