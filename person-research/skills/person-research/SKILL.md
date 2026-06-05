---
name: person-research
description: Autonomous digital footprint audit for a named person. Surfaces every publicly findable item across self-published channels, third-party publications, and leaked-but-public sources. Output is a single self-contained HTML brief with origin badges and a prioritized takedown action list so the subject can request removal. Public sources only.
argument-hint: "[full name] [optional disambiguator]"
---

# Person Research — Digital Footprint Audit

You perform autonomous web research on a named person and produce a self-contained HTML dossier intended to help that person see and act on their public digital footprint. You research the data yourself — do not ask the user for facts they would need to look up. Only ask for decisions and confirmations.

**Purpose framing — keep this in mind throughout:**
This is a **digital footprint audit / right-to-erasure self-service** tool. Output is intended to be shared with the subject so they can request removal of items they don't want public. Every item must carry its origin (who put it there) and its removal path (how to get it taken down).

**Hard rules:**
- **Public sources only.** No login-gated platforms (LinkedIn behind sign-in, paywalled databases). Use the publicly indexed/visible portions only.
- **Origin label is mandatory** for every item: `self-published`, `third-party`, or `leaked-but-public`.
- **Leaks: meta only.** For breach data: report the breach name, source, date, and the fact that the subject's email/handle appears in it. Do NOT quote passwords, private message contents, or other sensitive payload from leaks.
- **Removal route is mandatory** for every item where one is known. If the route is non-obvious, say so explicitly.
- **No fabrication.** If a source can't be opened, mark it skipped. Do not infer items that aren't actually cited.
- **Disambiguation first.** Never produce a dossier mixed from multiple people with the same name.

---

## Phase 1 — Setup

### 1. Collect input

Required:
- `full_name` (first + last)

Optional disambiguators (any combination):
- `current_employer`
- `city` / `region`
- `profession` / `role`
- `profile_url` (e.g. a known LinkedIn, X, or personal site)
- `birth_year` (only if user volunteers — never solicited beyond this)
- `email` (only if user volunteers — used for breach lookups)

If no `full_name` is provided, enter interview mode (foundation §7) and ask only for the name.

### 2. Disambiguate — candidate sweep

WebSearch the full name. Cluster results into distinct candidate people. For each plausible candidate produce a one-line disambiguator card:

```
[N] [Name]
    Distinguishers: [employer / city / role / age / notable affiliation]
    Top hits: [3 source URLs]
```

Present **all plausible candidates** (not just top 5). For very common names with many low-signal hits, group the long tail under "Other candidates with low signal — N people" and list only those with disambiguable profiles in detail.

Ask the user to pick by number, or to provide additional disambiguators. **Do not proceed until one candidate is confirmed.** Mixing two people in one dossier is a critical failure.

### 3. Confirm scope and output path

Present:

```
**Subject**: [name]
**Disambiguators**: [list]
**Output**: /documentation/[name-slug]/person-research/[name-slug].html
**Scope**: full digital footprint audit (self-published + third-party + leaked-but-public)
```

Ask for path override if needed. Create the directory if it doesn't exist.

---

## Phase 2 — Research pipeline

Track for every finding: source URL, exact title/handle, date if available, verbatim short quote or excerpt, and origin category.

### Self-published sources

**S1 — Personal website / blog / portfolio.** WebSearch `"[name]" site:[domain candidates]`, also `"[name]" personal blog OR portfolio OR website`. WebFetch any direct hits.

**S2 — Major social platforms (public profiles).** Search for the person's presence on:
- X / Twitter, Mastodon, Bluesky, Threads
- LinkedIn (public-visible parts only)
- Facebook, Instagram, TikTok (public posts/profiles only)
- YouTube channel, Twitch
- Reddit (own user profile)

Queries: `"[name]" site:twitter.com`, `"[name]" site:bsky.app`, etc. Capture handle, follower scale if visible, bio, sample of pinned/recent public posts.

**S3 — Code & technical platforms.** GitHub, GitLab, Codeberg, npm/PyPI/Crates author profiles, Stack Overflow user profile, Hacker News user, dev.to.

**S4 — Long-form publishing.** Medium, Substack, dev.to, personal newsletters, Ghost-hosted blogs.

**S5 — Audio / video / podcasting.** Their own YouTube channel posts, Spotify-for-creators / podcast host pages, SoundCloud, Vimeo.

**S6 — Author / creator profiles.** Goodreads author, Behance, Dribbble, ArtStation, Bandcamp, Patreon, Ko-fi.

**S7 — Speaker pages.** Conference speaker bios on event sites (where they listed themselves), Lanyrd-archive equivalents.

### Third-party published

**T1 — News, interviews, profile pieces.** WebSearch `"[name]" interview OR profile OR quote` and `"[name]" announced OR appointed OR named` from recent years.

**T2 — Co-authored papers.** Google Scholar, arXiv, ResearchGate, ORCID lookup. Note: ResearchGate is self-published when the person uploaded; third-party when only cited.

**T3 — Patents.** Google Patents — inventor listings.

**T4 — Public corporate filings.** For NL: KvK officer listings (UBO data is restricted). For US public co's: SEC filings naming them. Companies House (UK).

**T5 — Court / legal records.** rechtspraak.nl (NL), CourtListener (US), local equivalents. **Only the existence and public-record metadata of cases — do not retell case substance beyond what the published summary states.**

**T6 — Wikipedia & encyclopedic.** Wikipedia article in any language, Wikidata entry.

**T7 — Forum mentions / discussions ABOUT the person.** Reddit threads, Hacker News threads, Stack Exchange answers naming them, X/Twitter mentions discussing them (where searchable without login).

**T8 — Awards, honoree lists, alumni rosters.** Trade press, university alumni features, industry "30 under 30" / "top X" lists.

**T9 — Image search.** Google Images / TinEye reverse-search on their name — note pages where their photo appears (useful for the subject to know).

**T10 — Wayback Machine.** Archived versions of removed pages (their own old site, old social profile snapshots) — flag separately because removal from archive.org requires a specific process.

### Leaked-but-public

**L1 — Breach databases (meta only).** HaveIBeenPwned-style lookups using known emails: report breach name + date + the categories of leaked data per breach. **Do not quote any actual payload (no passwords, no private messages).**

**L2 — Pastebin / Ghostbin / similar.** Search for the name and known handles. Report only the existence of the paste, the URL, and a one-line description. Do not transcribe the contents if they contain credentials, private messages, or personal data dumps.

**L3 — Doxbins / harassment-archive sites.** If found, list with extreme care: source URL, date, and a generic description. **Never transcribe the contents.** These items should appear at the top of the takedown list with the urgency-flag.

**L4 — Old database dumps that surfaced publicly** (e.g., voter rolls scraped to GitHub, customer-list exposures). Existence + URL + one-line description only.

---

## Phase 3 — Synthesize

### Per-item required fields
- **Title / what it is**
- **Source URL**
- **Origin**: `self-published` | `third-party` | `leaked-but-public`
- **Platform** (specific: github.com, x.com, weekblad-debrug.nl, etc.)
- **Date** (publication or last-seen)
- **Brief description** (1–2 lines, neutral)
- **Removal route**: concrete steps to request takedown (see Removal Routes below)
- **Removal difficulty**: `easy` | `medium` | `hard` | `very-hard`

### Removal route catalog (use these defaults, refine where you know the specifics)

| Platform / origin | Default removal route | Difficulty |
|---|---|---|
| Own social account (X/IG/FB/etc.) | Delete post / delete account in app settings | easy |
| Own GitHub repo | Repo settings → Delete; for forks, ask forkers via issue | easy (own), hard (forks) |
| Own blog/Medium/Substack | Delete post in dashboard | easy |
| LinkedIn (own) | Edit / delete in profile | easy |
| Third-party news article | Email editor; cite GDPR Art. 17 in EU; cite "outdated/inaccurate" otherwise | medium → hard |
| Third-party blog mention | Email site owner; check site privacy policy for takedown form | medium |
| Conference speaker page | Email event organizer | medium |
| Wikipedia article about you | Talk page request; cite WP:BLP for harmful info | medium → hard |
| Google Search result (cached) | Google "Remove outdated content" tool + "Personal information removal" form | medium |
| Image in Google Images | Google removal tool; underlying source must also be addressed | medium → hard |
| Wayback Machine snapshot | Email info@archive.org; cite specific URL | hard |
| KvK officer listing | Cannot remove while still an officer; resign or correct via KvK form | very-hard while active |
| Court record (rechtspraak.nl etc.) | Generally not removable; can request anonymization in EU under specific grounds | very-hard |
| Patent inventor listing | Cannot remove (matter of public record) | not-removable |
| Scientific paper / Scholar | Contact publisher; preprint servers (arXiv) allow withdrawal not deletion | hard |
| Pastebin / Ghostbin | Use site's abuse/removal form; cite contains-personal-data | medium |
| Doxbin / harassment archive | Site-specific abuse form; often unresponsive — escalate to hosting provider / local police if threats | very-hard |
| HaveIBeenPwned breach record | Cannot remove from HIBP (it indexes already-public breaches); contact the breached service for their own records | very-hard for HIBP, varies for source |
| Wayback / archive.today | archive.today does not honor removal requests by design | very-hard |

If the platform isn't in the catalog, write: "No standard removal route — try the site's contact/privacy form; cite GDPR Art. 17 if EU-based."

### Sorting & grouping in the brief

- **Items within each origin section**: sort by removal difficulty (easy first), then by recency.
- **Takedown action list**: sort by urgency (leaked > sensitive third-party > old self-published the subject likely forgot > everything else), then by ease (quick wins first).

---

## Phase 4 — Render HTML

Single self-contained HTML file at the agreed output path. Embedded CSS only.

### Structure

```html
<!DOCTYPE html>
<html lang="nl"> <!-- match the subject's primary language where known, else en -->
<head>
  <meta charset="utf-8">
  <title>Digital footprint audit — [Name]</title>
  <style>/* embedded */</style>
</head>
<body>
  <header>
    <h1>[Name]</h1>
    <p class="subtitle">Digital footprint audit — generated [YYYY-MM-DD]</p>
  </header>

  <div class="intent-banner">
    <strong>Purpose:</strong> This document lists every publicly findable item about [Name].
    It is intended to be shared with [Name] so they can decide what to leave, what to remove,
    and where to act. Every item shows its origin and a removal route where one is known.
  </div>

  <section id="identity">
    <h2>Public identity snapshot</h2>
    <dl>
      <dt>Confirmed identity</dt><dd>[disambiguators used] <sup>[N]</sup></dd>
      <dt>Public role(s)</dt><dd>... <sup>[N]</sup></dd>
      <dt>Region</dt><dd>... <sup>[N]</sup></dd>
      <dt>Active handles</dt><dd>[platform: @handle, ...] <sup>[N]</sup></dd>
    </dl>
  </section>

  <section id="self-published">
    <h2>Self-published <span class="origin-badge self">self-published</span></h2>
    <p class="section-note">Content the subject controls directly. Easiest to act on.</p>
    <div class="card-grid">
      <article class="footprint-card">
        <h4>[Title]</h4>
        <p class="meta">
          <span class="platform">[platform]</span>
          <span class="date">[date]</span>
          <span class="difficulty diff-easy">easy</span>
        </p>
        <p class="desc">[brief description]</p>
        <p class="url"><a href="[URL]">[shortened URL]</a> <sup><a href="#src-N">[N]</a></sup></p>
        <p class="removal"><strong>Remove:</strong> [route]</p>
      </article>
      <!-- more cards -->
    </div>
  </section>

  <section id="third-party">
    <h2>Third-party published <span class="origin-badge third">third-party</span></h2>
    <p class="section-note">Content others published about the subject. Removal usually requires contacting the publisher.</p>
    <div class="card-grid">
      <!-- cards same structure, with difficulty mostly medium/hard -->
    </div>
  </section>

  <section id="leaked">
    <h2>Leaked-but-public <span class="origin-badge leaked">leaked-but-public</span></h2>
    <p class="section-note warn">
      Items found in breach databases or paste sites. Only metadata is shown — no passwords or message contents.
      These items are usually difficult to remove from the source but actionable elsewhere (rotate credentials, notify the originally-breached service).
    </p>
    <div class="card-grid">
      <!-- cards; if none found, render a "No leaked-but-public items found" note -->
    </div>
  </section>

  <section id="takedown">
    <h2>Takedown action list</h2>
    <p class="section-note">Sorted by urgency, then by ease. Tackle the quick wins first; escalate the hard ones.</p>
    <ol class="action-list">
      <li>
        <strong>[Item title]</strong> — <span class="difficulty diff-easy">easy</span>
        <br><span class="action">[concrete next step]</span>
        <br><a href="[URL]">[source]</a> <sup><a href="#src-N">[N]</a></sup>
      </li>
      <!-- more -->
    </ol>
  </section>

  <section id="sources">
    <h2>Sources</h2>
    <ol>
      <li id="src-1">[linked title] — [publication], accessed [date]</li>
    </ol>
  </section>

  <section id="assumptions">
    <h2>Assumptions &amp; limitations</h2>
    <ul>
      <li>[Gap / what was not searched / why]</li>
    </ul>
  </section>

  <footer>
    <p>Public sources only. Leaks are reported as metadata only — no payload contents included.
       Generated by the <code>person-research</code> skill.</p>
  </footer>
</body>
</html>
```

### Style (embedded)

- System font stack, max width ~960px (wider than company-research because more cards), line-height 1.55
- Card grid: `repeat(auto-fill, minmax(300px, 1fr))`
- Origin badges: distinct colors — self (blue), third-party (purple), leaked (red/orange)
- Difficulty badges: easy (green), medium (amber), hard (orange), very-hard (red), not-removable (grey)
- Intent banner: yellow border-left, padding, prominent
- Leaked section: subtle warning background, but content is still rendered fully
- Print-friendly: `@media print` with single-column card grid, no color flooding

### Citation discipline
Same as company-research: numbered `<sup><a href="#src-N">[N]</a></sup>` linking to Sources entries with stable IDs.

---

## Phase 5 — Hand off

After writing the HTML:

1. Print absolute output path.
2. Print a coverage summary: `[X] self-published items, [Y] third-party, [Z] leaked-but-public. [N] sources total.`
3. Print the top 3 takedown actions inline as a preview, with the suggestion: "Share the HTML with the subject so they can work through the full list."
4. If leaked-but-public items were found, flag prominently: `⚠ N leaked-but-public items found — see HTML section for details.`

---

## Failure behavior

| Situation | Behavior |
|---|---|
| Name is too common to disambiguate even with provided disambiguators | List all plausible candidates anyway, ask user to pick or supply more |
| User does not provide enough to disambiguate | Refuse to mix data — produce a candidate list only, no dossier |
| Subject has no findable public footprint | Produce minimal HTML with a positive finding: "No significant public footprint found across [list of platforms searched]" |
| Breach lookup tools are not accessible | Note in Assumptions; do not fabricate breach data |
| Leak contains payload content (passwords, messages) | Reference the leak's existence + meta; do not transcribe the payload |
| User requests payload contents from leaks | Refuse, state policy |
| User requests data on minors (under 18) | Refuse, state policy — only produce a dossier on minors with explicit guardian consent stated in input |
| Source URL no longer accessible | Note skipped; if cached version exists in Wayback, link to that |
| Court record contains substantive details beyond a summary | Reference existence + public summary only — do not retell case substance |

---

## Self-check before hand-off

```
[] Every item has an origin badge (self / third-party / leaked)
[] Every item has a source URL
[] Every item has a removal route or explicit "no standard route" note
[] Every item has a removal difficulty rating
[] No leak payload (passwords, private messages, sensitive contents) appears anywhere
[] Identity confirmed — no mixing of people with same name
[] Subject is not a minor (or guardian consent recorded if so)
[] Takedown action list is sorted by urgency, then by ease
[] Sources section lists every URL with access date
[] Assumptions & limitations names every gap
[] HTML is self-contained, valid, opens correctly in a browser
[] Output path follows /documentation/[name-slug]/person-research/[name-slug].html
```
