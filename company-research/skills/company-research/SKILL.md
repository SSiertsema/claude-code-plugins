---
name: company-research
description: Autonomous web research that produces a sales/outreach-ready HTML company brief. Identifies people via website, news, blogs, talks, GitHub, papers, patents, SEC filings, and Crunchbase. Public sources only, every claim cited.
argument-hint: "[company name]"
---

# Company Research

You perform autonomous web research on a named company and produce a sales/outreach-ready HTML brief. You research the data yourself — do not ask the user for facts they would need to look up. Only ask the user for decisions and confirmations.

**Hard rules — do not violate:**
- Public sources only. No login-gated platforms (LinkedIn pages requiring sign-in, paywalled databases, etc.).
- No email guessing. No phone numbers. No private contact data of any kind.
- No inference of facts not stated in a cited source.
- Every non-trivial claim must cite a source via numbered superscript linking to the Sources section.
- If the user asks to add private contact data or scrape gated platforms, refuse and state this policy.

---

## Phase 1 — Setup

### 1. Collect input

Accept:
- A company name (required)
- Optional: company website URL, industry hint, target role focus, region/country
- No input or vague input → enter interview mode (foundation §7)

In interview mode, gather only the **company name**. Everything else is optional.

### 2. Disambiguate

WebSearch the company name. If multiple plausible entities exist (same name across industries, regions, or unrelated organizations), present the top candidates with one-line distinguishers and ask the user to pick. Do not guess.

If only one plausible entity exists, present a one-line confirmation:

```
Researching: [Company Name] — [one-line description from search result] ([domain])
```

Wait for confirmation or correction before proceeding.

### 3. Confirm scope and output path

Present detected scope:

```
**Company**: [name]
**Website**: [URL]
**Industry**: [if known]
**Target role focus**: [if provided, else "all functions"]
**Region**: [if provided, else "global"]
**Output**: /documentation/[company-slug]/company-research/[company-slug].html
```

Ask for confirmation or path override. Create the directory if it does not exist.

---

## Phase 2 — Research pipeline

Execute these 11 steps. Track every URL consulted with access date. For each piece of evidence, capture: source URL, evidence quote (verbatim, short), date of source.

**Step 1 — Canonical website crawl.** WebFetch the homepage, then `/about`, `/team`, `/leadership`, `/people`, `/careers`, `/press`, `/contact`, `/company`, `/our-story`. Extract named people with roles. Note publication dates if visible.

**Step 2 — Company blog / engineering blog.** Locate via homepage links or WebSearch `site:[domain] blog`. WebFetch recent post index. Capture author names + bios where listed. Note post topics and dates for the activity timeline.

**Step 3 — News & press releases.** WebSearch `"[company name]" announcement|raises|launches|appoints|hires` and `"[company name]" CEO|CTO|founder|VP interview` from the last 12 months. WebFetch top results. Capture quoted spokespeople with role attribution and recent product/business events.

**Step 4 — Conference talks & podcasts.** WebSearch `"[company name]" speaker|keynote|talk` and `"[company name]" podcast guest`. WebFetch event pages, YouTube descriptions where accessible. Capture speakers with role attribution.

**Step 5 — GitHub.** WebSearch `site:github.com "[company name]"` and `"@[domain]" site:github.com`. Look for a company org page (`github.com/[company]`) — WebFetch the People tab if public. Capture engineers who publicly list the company in their profile.

**Step 6 — Google Scholar / arXiv.** WebSearch `"[company name]" site:scholar.google.com` and `"[company name]" site:arxiv.org`. Capture paper authors with company affiliation. Note paper titles and dates for the activity timeline.

**Step 7 — Patents.** WebSearch `"[company name]" site:patents.google.com` with the company as assignee. Capture inventors. Note recent patents for the activity timeline.

**Step 8 — SEC filings (US public companies only).** WebSearch `"[company name]" site:sec.gov 10-K` or `DEF 14A`. WebFetch the most recent filing. Extract named executive officers and directors. Skip if the company is private.

**Step 9 — Crunchbase public pages.** WebSearch `"[company name]" site:crunchbase.com`. WebFetch the public page (do not attempt to access gated content). Capture founders and listed key people.

**Step 10 — Trade press & industry awards.** WebSearch `"[company name]" award|honoree|"40 under 40"|"top [industry] leaders"`. Capture honorees with role attribution.

**Step 11 — Recent activity sweep.** WebSearch `"[company name]"` filtered to the last 12 months. Capture funding rounds, acquisitions, product launches, partnerships, executive moves, layoffs. Each event becomes a timeline entry.

**Per step**: if WebSearch returns nothing useful, broaden the query (drop quotes, try synonyms) once. If still empty, record the gap and move on.

**Per WebFetch**: if a page is JS-heavy or empty, note the skip in Assumptions & Limitations. Do not retry endlessly.

---

## Phase 3 — Synthesize

### Deduplicate people
- Match across sources by name + role similarity
- On role conflicts: keep both, flag the conflict in the person card, prefer the most recent source for the displayed title
- One card per person, with all sources listed

### Group by function
- **Leadership**: C-suite, founders, board, VP+ roles
- **GTM**: Sales, marketing, RevOps, customer success, BD, partnerships
- **Engineering**: SWE, infra, platform, security, data, ML
- **Product**: PM, design, research, UX
- **Other**: Everyone else (finance, legal, HR, ops)

If a `target_role_focus` was provided, surface the matching function group first and elaborate it; keep the others compact.

### Confidence assignment per person
- **High**: Named on the company's own website OR ≥2 independent reputable sources corroborate the role
- **Medium**: Named on one reputable third-party source (news, conference page, Crunchbase) with role attribution
- **Low**: Named with weaker signal (GitHub profile alone, single secondary mention)

### Recency tag per person
- Use the date of the source the role came from (e.g., `2025-Q4`, `2024-10`, `2023`)
- If a role conflict exists, note it: `2025-Q1 (VP Eng) / 2024-Q2 (Director Eng)`

### Outreach hooks
Generate 5–10 conversation starters, each grounded in a specific cited piece of activity (recent talk, blog post, hiring pattern, product launch, paper). Each hook names the topic, the person or team it ties to, and the source. Hooks must be:
- Specific (not "they care about scalability")
- Tied to dated activity within the last 12 months when possible
- Useful as an opening sentence in an outreach email

---

## Phase 4 — Render HTML

Produce a **single self-contained HTML file** at the agreed output path. No external CSS, JS, or fonts. Embedded `<style>` only. Must open and render correctly in any modern browser offline.

### Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Company Research — [Company Name]</title>
  <style>/* embedded, see Style below */</style>
</head>
<body>
  <header>
    <h1>[Company Name]</h1>
    <p class="subtitle">Sales/outreach research brief — generated [YYYY-MM-DD]</p>
  </header>

  <section id="snapshot">
    <h2>Company snapshot</h2>
    <dl>
      <dt>HQ</dt><dd>[city, country] <sup><a href="#src-N">[N]</a></sup></dd>
      <dt>Industry</dt><dd>... <sup>[N]</sup></dd>
      <dt>Founded</dt><dd>... <sup>[N]</sup></dd>
      <dt>Size estimate</dt><dd>... <sup>[N]</sup></dd>
      <dt>Funding stage</dt><dd>... <sup>[N]</sup></dd>
      <dt>Description</dt><dd>... <sup>[N]</sup></dd>
    </dl>
  </section>

  <section id="timeline">
    <h2>Recent activity (last 12 months)</h2>
    <ol class="timeline">
      <li>
        <span class="date">YYYY-MM-DD</span>
        <span class="event">[event description]</span>
        <sup><a href="#src-N">[N]</a></sup>
      </li>
      <!-- chronological, newest first -->
    </ol>
  </section>

  <section id="roster">
    <h2>People</h2>

    <section class="function-group">
      <h3>Leadership</h3>
      <div class="card-grid">
        <article class="person-card">
          <h4>[Name]</h4>
          <p class="role">[Role]</p>
          <blockquote>"[evidence quote]"</blockquote>
          <p class="meta">
            <span class="conf conf-high">high</span>
            <span class="recency">2025-Q4</span>
            <a href="#src-N">[N]</a>
          </p>
        </article>
        <!-- more cards -->
      </div>
    </section>

    <!-- repeat for GTM, Engineering, Product, Other -->
  </section>

  <section id="hooks">
    <h2>Outreach hooks</h2>
    <ol>
      <li>[Hook tied to specific activity] — [person/team] <sup><a href="#src-N">[N]</a></sup></li>
    </ol>
  </section>

  <section id="sources">
    <h2>Sources</h2>
    <ol>
      <li id="src-1"><a href="[URL]">[Title]</a> — [publication], accessed YYYY-MM-DD</li>
      <!-- one per consulted URL -->
    </ol>
  </section>

  <section id="assumptions">
    <h2>Assumptions &amp; limitations</h2>
    <ul>
      <li>[Gap or assumption]</li>
    </ul>
  </section>

  <footer>
    <p>Public sources only. No private contact data. Generated by company-research skill.</p>
  </footer>
</body>
</html>
```

### Style (embedded)

Use a clean, neutral, print-friendly stylesheet:
- System font stack: `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif`
- Max body width ~880px, centered, generous line-height (1.55)
- Card grid: `display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem;`
- Person cards: subtle border, padding, role in muted color
- Confidence badges: green (high), amber (medium), grey (low) — use `background` + `padding: 2px 8px; border-radius: 3px;`
- Timeline: dates left-aligned in a fixed-width column, events flow right
- Sources: small font, hanging indent
- Print styles: `@media print { body { max-width: none; } .card-grid { break-inside: avoid; } }`

### Citation discipline
- Every claim in snapshot, timeline, person card, and hook gets a numbered superscript linking to the matching `<li id="src-N">` in Sources.
- One source can be cited multiple times — the number stays stable per URL.
- If a fact lacks a source, it does not appear in the brief.

---

## Phase 5 — Hand off

After writing the HTML file:

1. Print the absolute output path.
2. Print a one-line coverage summary: `N people across M functions, K sources, T timeline events.`
3. Print the top 3 outreach hooks inline as a preview.
4. If coverage was thin (≤3 people OR ≤5 sources), flag it: `Coverage is low — limited public footprint. See Assumptions & limitations section.`

Do not produce a markdown brief in the conversation. The HTML file is the deliverable.

---

## Failure behavior

| Situation | Behavior |
|---|---|
| Multiple companies match the name | Ask user to pick — do not guess |
| No public web presence found | Produce minimal HTML brief, flag low coverage in Assumptions, list searches attempted |
| WebFetch returns JS-heavy / empty page | Note skip in Assumptions, try alternative sources |
| Conflicting roles across sources for a person | Keep both, flag in person card, prefer most recent for displayed title |
| User requests email / phone / private data | Refuse, restate public-sources-only policy, do not produce that data |
| User asks to scrape login-gated platforms | Refuse, restate policy |
| WebSearch returns nothing for a pipeline step | Broaden query once; if still empty, record gap and proceed |
| Output path already exists | Confirm overwrite with the user before writing |

---

## Self-check before hand-off

```
[] Every claim in the HTML cites a source via <sup>[N]</sup> linking to #src-N
[] No private contact data (email, phone) in the output
[] Every person card has: name, role, evidence quote, confidence, recency, source link
[] People are deduplicated across sources; role conflicts flagged
[] Roster is grouped by function (leadership / GTM / engineering / product / other)
[] Sources section lists every URL consulted with access date
[] Assumptions & limitations section is present and names every gap
[] HTML is self-contained (no external CSS, JS, fonts)
[] HTML opens and renders correctly in a browser
[] Output path matches /documentation/[company-slug]/company-research/[company-slug].html (or user override)
```
