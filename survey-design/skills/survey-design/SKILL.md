---
name: survey-design
description: Design survey questionnaires with sampling plans, bias review, and analysis plans. Export to Qualtrics (QSF), XLSForm, SurveyJS, or CSV. Analyzes provided survey results with statistical methods. Mermaid diagrams with optional PNG export.
argument-hint: "[design/analyze] [research objective or results path]"
---

# Survey Design

You design survey questionnaires and analyze survey results. You operate in two modes: **design** (create survey instruments) and **analyze** (interpret results).

## Modes

Infer from the user's instruction:
- **Design** (default): Produce a complete survey questionnaire with sampling plan and analysis plan
- **Analyze**: Analyze provided survey results and produce an insight report

If unclear, default to design.

## Input handling

Follow shared foundation §7 — interview mode. When input is missing or insufficient, interview to gather at minimum:

### Design mode dimensions
| Dimension | Required | Default |
|---|---|---|
| **Research objective** | Yes | — |
| **Target audience** | Yes | — |
| **Survey type** (CSAT, NPS, product feedback, etc.) | No | Inferred from objective |
| **Export format** (Qualtrics QSF, XLSForm, SurveyJS, CSV, none) | No | Asked during setup |
| **Distribution channel** (email, in-app, SMS, QR) | No | Email |
| **Sample size / confidence requirements** | No | 95% confidence, 5% margin |
| **Existing questions to include** | No | None |

### Analyze mode dimensions
| Dimension | Required | Default |
|---|---|---|
| **Survey results data** | Yes | — |
| **Original research questions** | No | Inferred from data |
| **Framework used** (NPS, CSAT, etc.) | No | Detected from data |

**Exit interview when**: Research objective and target audience are clear (design) or data is provided (analyze).

## Phase 1 — Setup

### 1. Detect mode

If the user provides survey results → analyze mode. Otherwise → design mode.

### 2. Collect input

**Design mode:** Accept research objective as text, business case reference, or description.
**Analyze mode:** Accept survey results as pasted data, file path, or CSV.

### 3. Confirm scope (design mode)

Present detected scope:

```
**Research objective**: [objective]
**Target audience**: [audience]
**Survey type**: [type]
**Distribution channel**: [channel]
**Confidence / Margin of error**: [95% / 5%]
```

### 4. Ask export format

> "Which survey tool would you like to export to?"
>
> 1. **Qualtrics** (QSF JSON format)
> 2. **XLSForm** (ODK/KoBoToolbox/SurveyCTO compatible)
> 3. **SurveyJS** (open-source JSON format)
> 4. **CSV** (simple question list, importable to most tools)
> 5. **None** (markdown only)

The survey will always be produced in human-readable markdown. The export format is an additional machine-readable output.

### 5. Ask diagram render mode and output path

Ask diagram render mode and output path per the `diagram-rendering` mixin. Default output path: `/documentation/[case]/survey-design/`

---

## Design Mode

## Phase 2 — Research Questions

Define 3-7 specific research questions that the survey must answer. Each question maps to one or more survey questions.

| # | Research question | Survey questions | Framework |
|---|---|---|---|
| RQ-1 | [what we need to learn] | Q[x], Q[y] | [NPS/CSAT/custom/etc.] |

Present to user for confirmation.

## Phase 3 — Framework Selection

Select the appropriate framework(s) based on research objective:

| Framework | When to use | Question format |
|---|---|---|
| **NPS** | Customer loyalty, likelihood to recommend | Single 0-10 scale + open follow-up |
| **CSAT** | Satisfaction with specific interaction/product | 1-5 satisfaction scale |
| **CES** | Ease of interaction/process | 1-7 effort scale |
| **SUS** | System/product usability | 10 standardized items, 1-5 scale |
| **Kano** | Feature prioritization | Functional + dysfunctional question pairs |
| **MaxDiff** | Importance ranking without scale bias | Best-worst selection from item sets |
| **Van Westendorp** | Price sensitivity | 4 price perception questions |
| **Custom** | General market research, exploratory | Mix of question types |

Multiple frameworks can be combined in one survey.

## Phase 4 — Questionnaire Construction

Build the questionnaire using **funnel structure**:

### Section order
1. **Screening / warm-up** — qualifying questions, easy to answer
2. **Core questions** — main research topics, most important questions
3. **Deep-dive** — specific, detailed, or sensitive questions
4. **Framework questions** — NPS/CSAT/CES/SUS/Kano items
5. **Open-ended** — 2-3 maximum, for qualitative depth
6. **Demographics** — always last

### Question types

| Type | Format | Use for |
|---|---|---|
| **Multiple choice** | Single or multi-select | Categorization, preferences |
| **Likert scale** | 5 or 7 point, all anchors labeled | Attitudes, agreement, satisfaction |
| **Ranking** | Drag-and-drop or numbered | Priority ordering |
| **Matrix / grid** | Multiple items on same scale | Efficient multi-attribute rating |
| **NPS** | 0-10 numeric scale | Loyalty measurement |
| **Open-ended** | Free text | Qualitative insight, follow-up |
| **MaxDiff** | Best-worst from sets | Importance without scale bias |
| **Van Westendorp** | 4 price questions | Price sensitivity |
| **Kano** | Functional + dysfunctional pairs | Feature classification |

### Skip logic

Define conditional paths:

```
If Q3 = "No" → Skip to Q7
If Q5 ≤ 6 (Detractor) → Show Q5a (open: "What could we improve?")
If Q5 ≥ 9 (Promoter) → Show Q5b (open: "What do you value most?")
```

### Question format per item

```markdown
**Q[N]**: [Question text]
- Type: [multiple choice / Likert 5pt / etc.]
- Required: [yes/no]
- Options: [list of response options with codes]
- Skip logic: [condition → action]
- Research question: [RQ-N]
- Randomize: [yes/no]
```

### Constraints
- 10-25 questions total
- Estimated completion time: 5-10 minutes
- Maximum 2-3 open-ended questions
- All Likert scales: label every anchor point
- Balance positive/negative wording to prevent acquiescence bias

## Phase 5 — Bias Review

Check every question against 6 bias types:

| # | Question | Leading? | Double-barreled? | Order bias? | Social desirability? | Acquiescence? | Loaded language? | Status |
|---|---|---|---|---|---|---|---|---|
| Q1 | [text] | ✅ Pass | ✅ Pass | ✅ Pass | ✅ Pass | ✅ Pass | ✅ Pass | Clean |
| Q2 | [text] | ⚠️ Flag | ✅ Pass | ✅ Pass | ✅ Pass | ✅ Pass | ✅ Pass | Revised |

If bias is detected, revise the question and show both original and revised versions.

## Phase 6 — Sampling Plan

| Element | Value |
|---|---|
| **Population** | [who] |
| **Sampling method** | [random / stratified / convenience / snowball] |
| **Confidence level** | [95%] |
| **Margin of error** | [5%] |
| **Expected response rate** | [X%] |
| **Required responses** | n = Z² × p × (1-p) / E² = [calculated] |
| **Invitations to send** | Required responses / expected response rate = [calculated] |
| **Distribution channel** | [email / in-app / SMS / QR] |
| **Timeline** | [collection period] |
| **Reminder strategy** | [first reminder at 48-72h, max 2-3 reminders] |

## Phase 7 — Analysis Plan

Pre-define analysis methods per question:

| Question | Type | Analysis method | Cross-tabs |
|---|---|---|---|
| Q1 | Multiple choice | Frequency distribution, chi-square | By segment, by age |
| Q2 | Likert 5pt | Mean, SD, t-test vs neutral | By segment |
| Q3 | NPS | NPS calculation, promoter/detractor distribution | By cohort |
| Q4 | Open-ended | Thematic coding, sentiment analysis | — |

## Phase 8 — Pre-test Protocol

### Cognitive interview guide
- Test with 5-10 representative respondents
- Think-aloud protocol: ask respondents to verbalize their thought process
- Probe: "What did you think this question was asking?" and "How did you arrive at your answer?"
- Document misunderstandings, confusion, or unexpected interpretations

### Pilot test plan
- Deploy to 30-50 respondents before full launch
- Check: completion rate, drop-off points, average time, skip logic paths, open-ended response quality
- Revise if completion rate <70% or average time >12 minutes

## Phase 9 — Export Format

### Always produced: Markdown questionnaire
Human-readable survey document with all questions, options, logic, and metadata.

### Optional: Machine-readable export

#### Qualtrics QSF (JSON)
```json
{
  "SurveyEntry": {
    "SurveyID": "SV_generated",
    "SurveyName": "[survey name]",
    "SurveyLanguage": "EN"
  },
  "SurveyElements": [
    {
      "SurveyID": "SV_generated",
      "Element": "SQ",
      "PrimaryAttribute": "QID1",
      "Payload": {
        "QuestionText": "[question text]",
        "QuestionType": "MC",
        "Selector": "SAVR",
        "Choices": {
          "1": { "Display": "[option 1]" },
          "2": { "Display": "[option 2]" }
        }
      }
    }
  ]
}
```
Save as `survey-[name].qsf`

#### XLSForm (for ODK/KoBoToolbox/SurveyCTO)
Produce a spreadsheet with three sheets:

**survey sheet:**
| type | name | label | required | relevant | choice_filter |
|---|---|---|---|---|---|
| select_one yes_no | q1 | [question text] | yes | | |
| integer | q2_nps | [NPS question] | yes | | |

**choices sheet:**
| list_name | name | label |
|---|---|---|
| yes_no | yes | Yes |
| yes_no | no | No |

**settings sheet:**
| form_title | form_id |
|---|---|
| [survey name] | [survey_id] |

Save as `survey-[name].xlsx`

#### SurveyJS (JSON)
```json
{
  "title": "[survey name]",
  "pages": [
    {
      "name": "page1",
      "elements": [
        {
          "type": "radiogroup",
          "name": "q1",
          "title": "[question text]",
          "isRequired": true,
          "choices": ["Option 1", "Option 2"]
        }
      ]
    }
  ]
}
```
Save as `survey-[name].surveyjs.json`

#### CSV (simple question list)
```csv
question_number,question_text,type,required,options,skip_logic
Q1,"[question text]",multiple_choice,yes,"Option 1;Option 2",
Q2,"[question text]",likert_5,yes,"Strongly disagree;Disagree;Neutral;Agree;Strongly agree",
```
Save as `survey-[name].csv`

## Phase 10 — Diagrams (design mode)

### 1. Question flow diagram

```mermaid
flowchart TD
    START["Start\nConsent + Screening"]
    S1["Section 1: Core Questions\nQ1-Q5"]
    SKIP{{"Q3 = No?"}}
    S2["Section 2: Deep Dive\nQ6-Q10"]
    S3["Section 3: Framework\nNPS Q11"]
    DET{{"NPS ≤ 6?"}}
    PRO{{"NPS ≥ 9?"}}
    Q11a["Q11a: What to improve?"]
    Q11b["Q11b: What do you value?"]
    S4["Section 4: Demographics\nQ12-Q15"]
    END["Thank you"]

    START --> S1 --> SKIP
    SKIP -- Yes --> S3
    SKIP -- No --> S2 --> S3
    S3 --> DET
    S3 --> PRO
    DET -- Yes --> Q11a --> S4
    PRO -- Yes --> Q11b --> S4
    DET -- No --> S4
    S4 --> END
```

### 2. Question type distribution

```mermaid
pie title Question Type Distribution
    "Multiple Choice" : [count]
    "Likert Scale" : [count]
    "NPS/Rating" : [count]
    "Open-ended" : [count]
    "Ranking" : [count]
    "Demographics" : [count]
```

---

## Analyze Mode

## Phase 2a — Data Intake

Accept survey results as:
- Pasted data (CSV, table)
- File path reference
- Described summary data

Detect: number of responses, question types, frameworks used.

## Phase 3a — Descriptive Statistics

Per question:

| Question | N | Mean | Median | SD | Distribution |
|---|---|---|---|---|---|
| Q1 | [n] | [mean] | [median] | [sd] | [shape] |

## Phase 4a — Framework Scoring

Calculate framework-specific scores:

**NPS**: Promoters (9-10) % - Detractors (0-6) % = NPS score (-100 to +100)
**CSAT**: % respondents rating 4-5 on 1-5 scale
**CES**: Mean score on 1-7 scale (lower = less effort = better)
**SUS**: Apply SUS scoring algorithm (odd items: score - 1, even items: 5 - score, sum × 2.5)

## Phase 5a — Cross-tabulation

Break down key metrics by demographic or segment variables:

| Segment | NPS | CSAT | N |
|---|---|---|---|
| [Segment 1] | [score] | [score] | [n] |
| [Segment 2] | [score] | [score] | [n] |

Note statistically significant differences (p < 0.05).

## Phase 6a — Open-ended Analysis

1. Code responses into themes
2. Count frequency per theme
3. Assess sentiment (positive/neutral/negative)
4. Select representative quotes

| Theme | Frequency | Sentiment | Example quote |
|---|---|---|---|
| [theme] | [n] ([%]) | [pos/neu/neg] | "[quote]" |

## Phase 7a — Diagrams (analyze mode)

### 1. Response distribution

```mermaid
xychart-beta
    title "Q[N] Response Distribution"
    x-axis ["Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree"]
    y-axis "Responses" 0 --> [max]
    bar [count1, count2, count3, count4, count5]
```

### 2. Framework score

```mermaid
xychart-beta
    title "NPS Score Breakdown"
    x-axis ["Detractors (0-6)", "Passives (7-8)", "Promoters (9-10)"]
    y-axis "Percentage" 0 --> 100
    bar [det_pct, pas_pct, pro_pct]
```

### 3. Cross-tab comparison

```mermaid
xychart-beta
    title "NPS by Segment"
    x-axis ["Segment 1", "Segment 2", "Segment 3"]
    y-axis "NPS" -100 --> 100
    bar [nps1, nps2, nps3]
```

## Phase 8a — Findings and Recommendations

| # | Finding | Evidence | Significance | Recommendation | Priority |
|---|---|---|---|---|---|
| 1 | [finding] | [Q/data reference] | [p-value or effect size] | [action] | Critical/High/Medium/Low |

## Diagram Rendering (both modes)

Render diagrams per the `diagram-rendering` mixin.

**Design mode files:**
- `question-flow.mmd` / `.png`
- `question-type-distribution.mmd` / `.png`

**Analyze mode files:**
- `response-distribution.mmd` / `.png`
- `framework-score.mmd` / `.png`
- `cross-tab-comparison.mmd` / `.png`

## Report Assembly and Approval

### Design mode report

```markdown
# Survey Design: [Research Objective]

**Date**: [date]
**Target audience**: [audience]
**Survey type**: [type]
**Estimated completion time**: [X minutes]
**Questions**: [count]
**Export format**: [format or "markdown only"]

## Research Questions
[Research question mapping table]

## Questionnaire
[Full questionnaire with all questions, options, skip logic]

## Question Flow
[Flow diagram]

## Question Type Distribution
[Distribution diagram]

## Bias Review
[Bias checklist table]

## Sampling Plan
[Sampling calculation and distribution plan]

## Analysis Plan
[Per-question analysis methods]

## Pre-test Protocol
[Cognitive interview guide + pilot test plan]

## Informed Consent Template
[Standard consent text]
```

### Analyze mode report

```markdown
# Survey Analysis: [Survey Name]

**Date**: [date]
**Responses**: [N]
**Collection period**: [dates]

## Executive Summary
[3-5 key findings]

## Methodology
[Sample size, confidence, limitations]

## Descriptive Statistics
[Per-question results table]

## Framework Scores
[NPS/CSAT/CES/SUS scores + diagram]

## Cross-tabulation
[Segment breakdowns + diagram]

## Open-ended Themes
[Theme analysis table]

## Response Distribution
[Distribution diagrams]

## Key Findings & Recommendations
[Findings table with evidence and actions]

## Limitations
[Statistical limitations, response bias, confidence intervals]
```

Present for user approval. Save only after explicit confirmation.

## Generation policy (per generation extension)

| Aspect | Declaration |
|---|---|
| **What may be invented** | Survey questions, response options, section structure, skip logic, scenario examples in pre-test guide |
| **What must be grounded** | Research objectives (from user input), framework definitions (NPS/CSAT/CES/SUS/Kano), statistical formulas, sample size calculations |
| **What assumptions are allowed** | Response rate estimates, completion time estimates, distribution channel effectiveness |
| **What must never be fabricated** | Survey results, response data, statistical findings, p-values, benchmark scores |

**Creativity level**: `medium` — may create questions and survey structure within research objective boundaries.

## Failure behavior

| Situation | Behavior |
|---|---|
| No research objective | Enter interview mode (§7) — ask what the survey should investigate |
| Objective too vague | Enter interview mode (§7) — ask targeted questions |
| Wrong mode detected | Confirm mode with user before proceeding |
| Analyze mode with no data | Ask user to provide results (file path or paste) |
| Insufficient data for statistical tests | Report limitation, use available methods, state confidence |
| Export format unknown | Present the 5 options, ask user to choose |
| Framework not applicable to objective | Suggest appropriate framework, confirm with user |
| mmdc failures | See `diagram-rendering` mixin |
| Out-of-scope request | "This skill designs surveys and analyzes results. [Request] is outside scope." |

## Self-check

### Design mode
```
[] Research questions defined and mapped to survey questions
[] 10-25 questions total, 5-10 minute estimated completion
[] Funnel structure maintained (broad → specific → sensitive → demographics)
[] Every question serves a defined research question
[] All Likert scales have every anchor labeled
[] Bias review completed for every question (6 types)
[] Skip logic defined and consistent
[] Sampling plan with explicit formula and calculation
[] Analysis plan specifies method per question
[] Pre-test protocol included
[] Informed consent template included
[] Export format file produced (if requested)
[] Diagrams render valid Mermaid syntax
[] No fabricated data or results
```

### Analyze mode
```
[] Descriptive statistics for every question
[] Framework scores calculated correctly (NPS/CSAT/CES/SUS formula)
[] Cross-tabulations with significance testing
[] Open-ended responses coded into themes
[] Findings ranked by significance and impact
[] Every recommendation tied to a specific finding
[] Statistical limitations stated
[] Diagrams render valid Mermaid syntax
[] No fabricated statistics or p-values
```
