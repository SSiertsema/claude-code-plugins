# Survey Design — Skill Specification

## Metadata

| Field | Value |
|---|---|
| **Name** | survey-design |
| **Version** | 1.0.0 |
| **Purpose** | Designs complete survey questionnaires with sampling plans, bias review, analysis plans, and pre-test protocols. Exports to Qualtrics (QSF), XLSForm, SurveyJS, or CSV formats. Also analyzes provided survey results using statistical methods and framework scoring (NPS, CSAT, CES, SUS). Two modes: design (create instrument) and analyze (interpret results). Generates Mermaid diagrams with optional PNG export. |
| **Primary category** | `generation` |
| **Secondary category** | `assessment` |
| **Output mode** | `human_readable` |
| **Creativity level** | `medium` |
| **Tone** | `neutral` |
| **Audience** | `stakeholder` |
| **Output format** | `markdown` |
| **Mixins** | `[diagram-rendering]` |

---

## When to use

- User needs a survey questionnaire for market research, customer feedback, or product validation
- User wants a complete survey package (questions, sampling plan, analysis plan)
- User needs to apply a specific framework (NPS, CSAT, CES, SUS, Kano, MaxDiff, Van Westendorp)
- User wants export to a specific survey tool (Qualtrics, XLSForm, SurveyJS, CSV)
- User has survey results and needs analysis with statistical rigor
- User wants bias review of existing survey questions

## When not to use

- Autonomous market research (data gathering) — use `competitive-analysis`, `market-sizing`, or `trend-analysis`
- Customer segmentation from market data — use `customer-segmentation`
- Industry benchmarking — use `industry-benchmarking`
- Persona creation — use `persona-management`
- Survey deployment/distribution (this skill designs, not deploys)
- Statistical analysis of non-survey data

---

## Required input

### Design mode
| Field | Description |
|---|---|
| **Research objective** | What the survey should investigate |

### Analyze mode
| Field | Description |
|---|---|
| **Survey results** | Response data (pasted, file path, or CSV) |

## Optional input

| Field | Description | Default |
|---|---|---|
| **Target audience** | Who the survey targets | Inferred from objective |
| **Survey type** | CSAT, NPS, product feedback, market research, usability, employee engagement | Inferred from objective |
| **Export format** | Qualtrics QSF, XLSForm, SurveyJS, CSV, none | Asked during setup |
| **Distribution channel** | Email, in-app, SMS, QR | Email |
| **Confidence level** | Statistical confidence | 95% |
| **Margin of error** | Acceptable error | 5% |
| **Existing questions** | Questions to include | None |
| **Diagram render mode** | `code` or `image` | `code` |
| **Output path** | Where to save files | `/documentation/[case]/survey-design/` |

## Input schema

```
input:
  design_mode:
    required:
      research_objective:
        type: string
        description: "What the survey should investigate"
    optional:
      target_audience: string
      survey_type:
        type: string
        enum: [csat, nps, product_feedback, market_research, usability, employee_engagement, custom]
      export_format:
        type: string
        enum: [qualtrics_qsf, xlsform, surveyjs, csv, none]
        default: asked_during_setup
      distribution_channel:
        type: string
        enum: [email, in_app, sms, qr, social]
        default: email
      confidence_level:
        type: number
        default: 0.95
      margin_of_error:
        type: number
        default: 0.05
      existing_questions:
        type: list[string]
  analyze_mode:
    required:
      survey_results:
        type: string | file_path
        description: "Response data"
    optional:
      original_research_questions: list[string]
      framework: string
  common:
    render_mode:  # See diagram-rendering mixin
      type: string
      enum: [code, image]
      default: code
    output_path:
      type: string
```

---

## Generation policy

| Aspect | Declaration |
|---|---|
| **What may be invented** | Survey questions, response options, section structure, skip logic, scenario examples in pre-test guide |
| **What must be grounded** | Research objectives (from user), framework definitions (NPS/CSAT/CES/SUS/Kano), statistical formulas, sample size calculations |
| **What assumptions are allowed** | Response rate estimates, completion time estimates, distribution channel effectiveness |
| **What must never be fabricated** | Survey results, response data, statistical findings, p-values, benchmark scores |

---

## Processing rules

### Design mode

1. Parse input, detect mode, identify research objective
2. If insufficient, enter interview mode (§7)
3. Confirm scope with user
4. Ask export format (Qualtrics QSF / XLSForm / SurveyJS / CSV / none)
5. Ask diagram render mode (per diagram-rendering mixin) and output path
6. Define 3-7 research questions mapped to survey questions
7. Select framework(s) (NPS/CSAT/CES/SUS/Kano/MaxDiff/Van Westendorp/custom)
8. Construct questionnaire: funnel structure, 10-25 questions, skip logic
9. Bias review: check every question against 6 types
10. Sampling plan: population, method, size calculation (n = Z²×p×(1-p)/E²)
11. Analysis plan: statistical method per question, planned cross-tabs
12. Pre-test protocol: cognitive interview guide, pilot test plan
13. Generate export file in selected format
14. Generate 2 diagrams (question flow, question type distribution)
15. Assemble report, present for approval

### Analyze mode

1. Accept results data
2. Descriptive statistics per question
3. Framework scoring (NPS/CSAT/CES/SUS)
4. Cross-tabulation with significance testing
5. Open-ended thematic analysis
6. Key findings and recommendations
7. Generate 3 diagrams (distribution, framework score, cross-tab)
8. Assemble report, present for approval

---

## Output contract

### Design mode

```markdown
# Survey Design: [Research Objective]

**Date**: [date]
**Target audience**: [audience]
**Survey type**: [type]
**Estimated completion time**: [X minutes]
**Questions**: [count]
**Export format**: [format]

## Research Questions
[Mapping table]

## Questionnaire
[Full questionnaire]

## Question Flow
[Flow diagram]

## Question Type Distribution
[Distribution diagram]

## Bias Review
[Checklist table]

## Sampling Plan
[Calculation and distribution plan]

## Analysis Plan
[Per-question methods]

## Pre-test Protocol
[Interview guide + pilot plan]

## Informed Consent Template
[Consent text]
```

Plus export file in selected format.

### Analyze mode

```markdown
# Survey Analysis: [Survey Name]

**Date**: [date]
**Responses**: [N]

## Executive Summary
## Descriptive Statistics
## Framework Scores + diagram
## Cross-tabulation + diagram
## Open-ended Themes
## Response Distribution + diagram
## Key Findings & Recommendations
## Limitations
```

### Export formats

| Format | File | Description |
|---|---|---|
| Qualtrics QSF | `survey-[name].qsf` | JSON importable to Qualtrics |
| XLSForm | `survey-[name].xlsx` | 3-sheet XLSX for ODK/KoBoToolbox |
| SurveyJS | `survey-[name].surveyjs.json` | JSON for SurveyJS library |
| CSV | `survey-[name].csv` | Simple question list |

### Diagrams

**Design mode (2):**
1. Question flow (flowchart) — survey logic with skip paths
2. Question type distribution (pie)

**Analyze mode (3):**
1. Response distribution (xychart)
2. Framework score breakdown (xychart)
3. Cross-tab comparison (xychart)

Rendering per diagram-rendering mixin.

---

## Self-check

### Design mode
```
[] Research questions defined and mapped
[] 10-25 questions, 5-10 min completion
[] Funnel structure (broad → specific → sensitive → demographics)
[] Every question serves a research question
[] All scales have every anchor labeled
[] Bias review for every question (6 types)
[] Skip logic defined and consistent
[] Sampling plan with formula and calculation
[] Analysis plan per question
[] Pre-test protocol included
[] Informed consent included
[] Export file produced (if requested)
[] Diagrams render valid Mermaid syntax (per diagram-rendering mixin)
```

### Analyze mode
```
[] Descriptive statistics for every question
[] Framework scores calculated correctly
[] Cross-tabs with significance testing
[] Open-ended coded into themes
[] Findings ranked by significance
[] Recommendations tied to findings
[] Limitations stated
[] Diagrams render valid Mermaid syntax (per diagram-rendering mixin)
```

---

## Failure behavior

| Situation | Behavior |
|---|---|
| No research objective | Enter interview mode (§7) |
| Objective too vague | Enter interview mode (§7) |
| Wrong mode detected | Confirm mode with user |
| Analyze mode with no data | Ask user to provide results |
| Insufficient data for tests | Report limitation, use available methods |
| Export format unknown | Present 5 options, ask user |
| Framework not applicable | Suggest appropriate framework, confirm |
| Diagram rendering fails | Per diagram-rendering mixin |
| Out-of-scope request | "This skill designs surveys and analyzes results. [Request] is outside scope." |

---

## Quality checks

- [ ] 10-25 questions, 5-10 minute completion (design)
- [ ] Every question serves a defined research question
- [ ] Funnel structure maintained
- [ ] Bias review for every question (6 types checked)
- [ ] Balanced scales with all anchor points labeled
- [ ] Sample size calculated with explicit formula
- [ ] Analysis plan specifies method per question
- [ ] Export file matches selected format specification
- [ ] Framework scores calculated with correct formula (analyze)
- [ ] Statistical significance reported where applicable (analyze)
- [ ] No fabricated results, data, or p-values
- [ ] All diagrams render valid Mermaid syntax (per diagram-rendering mixin)

---

## Examples

### Normal cases

**1. Customer satisfaction survey**
- Input: "Design a CSAT survey for our mobile banking app after a recent redesign"
- Expected: CSAT framework + usability questions, app-specific touchpoints, skip logic for dissatisfied users, NPS as secondary metric, export to Qualtrics.

**2. Market research survey**
- Input: "We need to understand willingness to pay for our new premium tier"
- Expected: Van Westendorp price sensitivity + MaxDiff for feature importance, targeting existing free-tier users, funnel from usage patterns to pricing.

**3. Employee engagement**
- Input: "Annual employee engagement survey for a 500-person tech company"
- Expected: Likert scales for engagement dimensions (growth, leadership, culture, workload), eNPS, open-ended for improvement suggestions, stratified sampling by department.

**4. Analyze NPS results**
- Input: "Here are our NPS survey results [data]. Analyze and tell us what to focus on."
- Expected: NPS calculation, promoter/passive/detractor breakdown, cross-tab by segment, open-ended theme analysis, prioritized recommendations.

**5. Product feedback with Kano**
- Input: "Design a Kano survey to prioritize features for our project management tool"
- Expected: Kano functional/dysfunctional question pairs for each feature, classification into must-be/one-dimensional/attractive/indifferent, export to SurveyJS.

### Edge cases

**6. Very short survey**
- Input: "We need a 3-question pulse check for customer satisfaction"
- Expected: Minimal survey (below 10-question guideline). Acknowledges constraint, designs 3 high-impact questions (CSAT + open follow-up + NPS), simplified sampling plan.

**7. Sensitive topic**
- Input: "Design a survey about workplace harassment experiences"
- Expected: Enhanced ethical considerations — informed consent with trigger warning, anonymity guaranteed (not just confidentiality), indirect questioning techniques, resources provided at end, IRB recommendation flagged.

**8. Multi-language survey**
- Input: "We need a customer survey for our European market — EN, DE, FR, NL"
- Expected: Designs in primary language, flags translation requirements, notes cultural adaptation needs per market, recommends back-translation validation.

### Failure cases

**9. No objective**
- Input: "Design a survey"
- Expected: Enters interview mode (§7) — "What should the survey investigate? What decisions will the results inform?"

**10. Out of scope**
- Input: "Deploy this survey to our customer list and collect responses"
- Expected: "This skill designs survey instruments and analyzes results. Deployment and response collection is outside scope. The exported [format] file can be imported into [tool] for distribution."
