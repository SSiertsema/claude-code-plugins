# Personal Values Interview — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | personal-values-interview |
| **Version** | 1.0.0 |
| **Purpose** | Maps a single person's core values through a high-effective, energy-preserving adaptive interview. Combines four validated methods — Personal Values Card Sort (Miller et al., ACT), Critical Incident Technique (Flanagan), Laddering / Means-End (Reynolds & Gutman), and Schwartz Portrait Values Questionnaire (PVQ) — and selects between them based on the user's energy and engagement signals. Calibrates language and abstraction to the user's profile (age, vocabulary, reflective capacity). Produces a markdown document with a prioritized core-values shortlist (5–9), a narrative profile, and session metadata that allows pause/resume across sessions and downstream comparison skills. |
| **Primary category** | `conversation` |
| **Secondary category** | `extraction` |
| **Output mode** | `hybrid` |
| **Tone** | `neutral` |
| **Audience** | `public` |
| **Output format** | `markdown` |
| **Evidence mode** | `required` |
| **Mixins** | none |

---

## When to use

- A user wants to make their own personal values explicit and documented
- Preparation for personal development, life decisions, or partnership conversations
- As a building block before comparing or aligning values across multiple people (separate downstream skill)
- Audience spans children (~8 years) through adults — the skill calibrates depth and language accordingly
- Resuming a previously paused values-interview session from a saved markdown file

## When not to use

- Acute crisis situations (grief, trauma, suicidality) — refer to professional help
- Organizational, team, or corporate values — different instruments apply
- Mediation between two people in disagreement — this skill is strictly 1-on-1
- Clinical or diagnostic assessment — this skill produces no diagnostic claims
- Children under approximately 8 years old — methods require baseline reflective capacity
- Comparing or merging two existing value profiles — out of scope; downstream skill territory

---

## Required input

| Field | Description |
|---|---|
| _none_ | The skill cold-starts and gathers everything it needs through dialogue |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Resume file** | Path to a previously saved session markdown — skill picks up where the prior session ended | none |
| **Focus area** | Free-text seed (e.g., "values about parenting", "values about work") that biases card sort and storytelling prompts | broad / general |
| **Time budget** | User-stated preference: `short` / `medium` / `long` / `open` | `open` (adaptive) |
| **Output path** | Where to save the final markdown | `/documentation/personal-values/[user-name]/` |
| **Language** | Conversation language | matches user's input language |

## Input schema

```
input:
  required: []
  optional:
    resume_file:
      type: string  # path to existing session markdown
    focus_area:
      type: string
    time_budget:
      type: string
      enum: [short, medium, long, open]
      default: open
    output_path:
      type: string
    language:
      type: string  # e.g., "nl", "en"
```

---

## Processing rules

### Phase 0 — Resume detection

If a resume file is provided:
1. Read the file
2. Parse the `session_metadata` block (calibration profile, completed phases, captured items, energy log)
3. Verify the file is a valid `personal-values-interview` artifact — if not, notify user and offer fresh start
4. Resume from the last completed phase; do not re-ask answered questions

### Phase 1 — Calibration

Short opening (3–5 turns) to detect:
- **Age band**: child (8–12) / teen (13–17) / adult (18+)
- **Vocabulary level**: simple / standard / advanced
- **Reflective capacity**: comfortable abstracting from concrete experience, or stays concrete
- **Storytelling comfort**: willing to share specific situations, or prefers hypotheticals/statements
- **Cultural/contextual cues**: language, references, life stage

Calibration questions are warm, low-stakes, and observational ("Tell me a bit about yourself — what do you spend most of your time doing?"). Save the calibration profile to session state. Use it to select vocabulary, examples, abstraction level, and the default fallback path for the rest of the interview.

### Phase 2 — Card Sort opening

1. Present a curated set of value words (~60–80 candidates, drawn from the Miller et al. Personal Values Card Sort, adjusted for vocabulary level)
2. Ask the user to sort into three piles: **most important**, **important**, **less important** (re-label for children: "really matters", "kinda matters", "doesn't matter much")
3. From the "most important" pile, narrow to a **shortlist of 5–9** through pairwise or forced-choice prompts
4. For each value on the shortlist, ask the user to briefly explain why it made the cut, in their own words
5. Save the shortlist with each user's stated meaning

If the user struggles to engage with sorting (rejects all values as equally important, or none): switch to PVQ-style portraits (Phase 5) earlier and reconstruct the shortlist from portrait responses.

### Phase 3 — Critical Incident storytelling

For each top value on the shortlist:
1. Invite a concrete past story where the value was at stake — a moment when the user defended it, struggled with it, or saw it in action
2. Listen for what the story reveals: which trade-offs were made, which other values were sacrificed, what felt wrong or right
3. Capture story → derived value indicators → confirmation/refinement of the stated value

Story prompts adapt to age:
- Children: "Tell me about a time something happened at school or with friends that felt really unfair (or really good)…"
- Teens/adults: "Tell me about a moment in the last year where you had to make a hard choice…"

If the user gives short or avoidant answers (≤2 short sentences, deflection, "I don't know" twice in a row) → adaptive fallback (Phase 6).

### Phase 4 — Laddering

For each story, drill from concrete behavior up to underlying value through `why?` probing:
1. Concrete action / choice
2. → Why was that important? (consequence)
3. → And why does that matter to you? (deeper consequence)
4. → And what does that say about what you value? (terminal value)

Stop laddering when:
- The user reaches a self-evident terminal value ("because that's just who I am")
- Energy drops (see energy polling)
- Three "why" probes have been asked on the same chain

### Phase 5 — PVQ check

Present 6–10 short Schwartz-style portraits ("There's a person who thinks it's important to…") covering the 10 universal value dimensions:
- Self-direction, Stimulation, Hedonism, Achievement, Power, Security, Conformity, Tradition, Benevolence, Universalism

For each portrait, ask: "How much is this person like you?" on a 5-point scale (or simplified 3-point for children). Use the responses to:
- Detect **missed dimensions** that the card sort and stories did not surface
- **Confirm** the consistency of the shortlist
- **Surface tensions** between stated values and PVQ responses (flag for narrative profile)

### Phase 6 — Adaptive fallback (triggered, not phased)

Triggered when engagement signals indicate the user is disengaging from storytelling. Detection signals:
- Two consecutive short answers (≤2 short sentences) on story prompts
- Explicit "I don't know" / "skip this" / "next" twice
- Long pauses (in async: very late replies, but do not assume)
- User explicitly states fatigue or boredom

When triggered, switch to one of these lighter modes (skill chooses based on calibration):
- **Hypothetical dilemmas** — "Imagine: situation X. What would you do, and why?"
- **Agree/disagree statements** — Short statements + agree/disagree + a one-sentence reason
- **Forced-choice** — Pick between two competing values ("honesty vs. loyalty: which wins, and when?")
- **Continued PVQ** — Use additional portrait items as the primary route

Continue in fallback mode until either: engagement returns (resume normal flow), or session wraps up with what has been gathered.

### Phase 7 — Energy polling

Every 6–8 turns (sooner if signals indicate fatigue), include a brief energy check:
- "How's your energy — want to keep going, take a break, or wrap up?"
- For children: "Still good? A bit tired? Want to stop?"

User responses:
- **Keep going** → continue at current depth
- **Slowing down** → reduce depth, switch to lighter modes (Phase 6)
- **Pause** → write current state to markdown (Phase 8) and exit cleanly
- **Wrap up** → skip remaining depth, go to synthesis (Phase 9) with current data

Never ignore an energy signal. Never push past a "wrap up".

### Phase 8 — Pause and resume

When the user requests a pause (or session ends mid-flow):
1. Write a session-state markdown to the output path with:
   - Calibration profile
   - Phases completed
   - Card sort results
   - Stories captured (verbatim where possible)
   - Laddering chains
   - PVQ responses (if any)
   - Energy log
   - Last question asked / position in flow
   - Status: `paused`
2. Confirm to user: "Saved to [path]. To resume, start the skill again with `--resume [path]` (or attach the file)."

Resume: see Phase 0.

### Phase 9 — Synthesis

When information is sufficient (or user wraps up):
1. Consolidate: card sort shortlist + story-derived values + laddered terminal values + PVQ-confirmed dimensions
2. Resolve overlaps and contradictions — surface contradictions in the narrative profile rather than silently reconciling
3. Produce the **prioritized core-values shortlist** (5–9 values), each with: name (in user's words), one-line description (in user's words), evidence reference (story ID or card sort or PVQ item)
4. Produce the **narrative profile** — prose (≈300–600 words for adults; shorter for children) that places the values in lived context, drawing on captured stories and tensions; uses the user's own phrasing wherever possible
5. Produce **session metadata** — calibration profile, methods used, phase completion, status (`complete` / `partial`), date

### Phase 10 — Approval and save

1. Present the synthesis to the user
2. Invite corrections: "Does this match how you see yourself? What would you change?"
3. Iterate until the user approves
4. Save final markdown to output path with status `complete`

---

## Output contract

### Final document structure

```markdown
# Personal Values Profile: [User Name or "Anonymous"]

**Date**: [YYYY-MM-DD]
**Status**: complete / partial / paused
**Methods used**: [card-sort, critical-incident, laddering, pvq, fallback-modes]
**Language**: [language code]

## Core Values

| # | Value | In their own words |
|---|---|---|
| 1 | [Value] | [One-line description in user's phrasing] |
| 2 | … | … |
| … (5–9 total) | | |

## Narrative Profile

[300–600 words of prose for adults, shorter for children. Places the values in lived context, draws on stories and tensions, uses the user's own phrasing where possible. No diagnostic claims, no personality labels.]

## Tensions and Open Threads

[Any contradictions surfaced between stated values and behavior, or between PVQ responses and shortlist. Explicit, not reconciled. Empty section omitted.]

## Evidence Index

| Value | Source(s) |
|---|---|
| [Value 1] | Card sort + Story #2 + PVQ item Q4 |
| … | … |

## Session Metadata

```yaml
schema_version: 1.0
calibration:
  age_band: child | teen | adult
  vocabulary: simple | standard | advanced
  reflective_capacity: concrete | balanced | abstract
  storytelling_comfort: high | medium | low
phases_completed: [calibration, card-sort, stories, laddering, pvq, synthesis]
fallback_modes_used: [hypothetical-dilemma | statement | forced-choice | continued-pvq]
energy_log:
  - turn: 8
    signal: keep-going
  - turn: 16
    signal: slowing-down
status: complete | partial | paused
last_position: phase-9-synthesis
```
```

### Pause-state document structure

Same structure as final, but:
- `status: paused`
- Core Values table may be sparse / draft
- Narrative Profile may be empty or marked `[pending synthesis]`
- Session Metadata includes full `last_position` and any partial captures (stories, sort piles, laddering chains)

---

## Evidence and generation policy

- **Every value in the shortlist** must trace to at least one source: a card sort placement, a story, a laddering chain, or a PVQ item
- **Narrative profile** must use the user's phrasing wherever possible; paraphrase only for readability, never invent attributes the user did not express
- **No fabricated quotes** — if a quote appears in the profile, it must be from the captured dialogue
- **No diagnostic or personality-label content** — no Big Five, no MBTI, no archetypes, no "you seem to be a…"
- **Tensions are surfaced, not reconciled** — if PVQ disagrees with the shortlist, name it in the Tensions section

---

## Self-check

```
[] Calibration profile captured before card sort begins
[] Card sort shortlist reduced to 5–9 values
[] Each shortlist value has user's own description
[] At least one story or PVQ confirmation per shortlist value
[] Adaptive fallback triggered when engagement dropped (and logged)
[] Energy polling executed every 6–8 turns
[] Pause request honored — state written to markdown
[] No diagnostic or personality-label claims in narrative
[] Tensions surfaced explicitly, not reconciled
[] Evidence index links every value to source
[] Session metadata complete and parseable
[] Final document approved by user before save
[] Vocabulary and abstraction match calibration profile
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| Crisis signals (grief, trauma, suicidality) | Stop the interview. Display: "This skill maps personal values through reflection. The signals you're sharing suggest you may benefit from professional support. Please reach out to a counselor, GP, or local crisis line." Do not proceed. |
| User asks for organizational/team values | "This skill is for individual personal values. For organizational values, a different instrument applies." |
| User asks to mediate between two people | "This skill works 1-on-1. To compare two value profiles, run this skill once per person, then use a downstream comparison skill." |
| User under ~8 years old (or signals indicate so) | "The methods this skill uses need a level of reflection that typically arrives around age 8. We can try a very short version, or wait." Offer a minimal child-version (top-3 cards + one simple story) or stop. |
| Resume file unreadable / corrupt | "I couldn't parse the resume file. Want to start fresh, or paste in what you remember?" |
| User insists on personality typing / diagnosis | "I don't produce personality labels or diagnoses. I document the values you express, in your own words." |
| User gives no answers across multiple turns | After 3 attempts including fallback: produce minimum-viable partial profile with explicit gaps and offer pause. |
| User contradicts themselves | Surface the tension neutrally: "Earlier you said X, now Y — which one fits better, or do both apply in different situations?" Do not pick a side. |
| Out-of-scope request mid-session | Note it as outside scope, offer to record it as a gap, continue the values interview. |

---

## Quality checks

- [ ] Calibration profile present and applied throughout
- [ ] Shortlist contains 5–9 values
- [ ] Every value traceable to evidence
- [ ] Narrative profile uses user's own language
- [ ] No diagnostic claims
- [ ] Tensions surfaced, not silently reconciled
- [ ] Adaptive fallback used when needed (or absent if not needed)
- [ ] Energy polling logged
- [ ] Session metadata complete and resumable
- [ ] Final document approved by user
- [ ] Pause flow produces a valid resume-able artifact
- [ ] No fabricated content

---

## Examples

### Normal cases

**1. Adult, full session, broad focus**
- Input: cold start, no focus area, time_budget=`open`
- Expected: 6 calibration turns identify adult, advanced vocab, balanced reflection, high storytelling comfort. Card sort produces shortlist of 7 (e.g., honesty, autonomy, family, growth, fairness, contribution, calm). Stories captured for 5 of 7. Laddering on 4 of those reaches terminal values. PVQ check confirms 6, surfaces 1 tension (user says "autonomy" but PVQ scores high on conformity in family context — flagged in Tensions). Synthesis approved with one round of edits. ~45 turns, ~50 minutes.

**2. Adult, focused, short**
- Input: focus_area="parenting", time_budget=`short`
- Expected: Calibration confirms adult. Parenting-biased card sort yields shortlist of 5. One story per value, light laddering. Quick PVQ check on relevant dimensions. Synthesis. ~20 turns.

**3. Child (10 y.o.), simple language**
- Input: cold start, calibration detects child age
- Expected: Vocabulary and examples adjusted (kid-friendly card phrasing, school/friend story prompts). Shortlist of 5. Stories shorter, less laddering depth. PVQ check uses 3-point "really like me / sort of / not like me" scale. Narrative profile shorter (~150 words) and warmer. Energy polling more frequent (every 5 turns). ~25 turns.

**4. Resume from pause**
- Input: resume_file=`./mike-values-paused.md`
- Expected: Skill reads file, restores calibration + card sort + 2 captured stories. Picks up at "Story 3 — value 'fairness'". Does not re-ask card sort. Continues to synthesis when complete.

**5. Mid-session pause**
- Input: User asks "can we pause for now?" at turn 18
- Expected: Skill writes session-state markdown with status `paused`, last_position `phase-3-stories`, partial captures intact. Confirms path. Exits cleanly. Reuse later via resume.

**6. Storytelling-averse adult**
- Input: User gives short answers on story prompts twice
- Expected: Adaptive fallback triggered after 2nd short answer. Skill switches to forced-choice and PVQ portraits. Logs `fallback_modes_used: [forced-choice, continued-pvq]`. Synthesis still produces a 6-value shortlist; narrative is shorter and leans on PVQ + forced-choice patterns.

### Edge cases

**7. User contradicts themselves between card sort and story**
- Card sort shortlist includes "honesty"; story for "honesty" describes a moment of useful deception
- Expected: Skill surfaces tension: "You sorted honesty as top, and the story shows you chose to lie when X. How do you read that?" Captures user's reflection. Tension recorded in Tensions section, not silently dropped.

**8. Sparse engagement, partial output**
- User stops responding after Phase 2 (card sort done, no stories)
- Expected: Minimum-viable partial profile: shortlist with descriptions, narrative marked `[pending — stories not captured]`, status `partial`, evidence index covers card sort only. Offer pause/resume.

**9. User insists on a value that PVQ contradicts**
- Shortlist includes "tradition"; PVQ scores tradition very low across multiple portraits
- Expected: Skill keeps "tradition" in shortlist (user's stated value wins), but explicitly notes the contradiction in Tensions: "Stated value 'tradition' contrasts with PVQ portraits Q3, Q5, Q9 where the user scored 'not like me'. Worth a follow-up conversation."

### Failure cases

**10. Crisis signals during interview**
- User responds to a story prompt with content suggesting active suicidality
- Expected: Skill stops the interview immediately. Displays referral message (see Failure behavior table). Does not produce a values profile. Does not save partial output without explicit user request.

**11. User requests organizational values mapping**
- Input: "Use this on our team's values"
- Expected: Skill refuses with the boundary message and points to the appropriate alternative. Does not partially comply.
