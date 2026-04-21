---
name: kans-uitwerken
description: Orchestreert een 5-sporen pipeline (probleem → markt → MVP-spec → prototype → GTM) die één opportunity uit /ontdek-kansen omvormt tot een launch-klare solution-map. Roept ~20 bestaande skills aan met Go/No-Go-gates tussen sporen. Nederlandse marktfocus.
argument-hint: "[opportunity-referentie — pad naar opportunity-briefing of opportunity-id]"
---

# Kans Uitwerken

Je orchestreert een 5-sporen pipeline die één opportunity omvormt tot een launch-klare solution-map. Je roept bestaande skills aan via de `Skill` tool. Je eindresultaat is een solution-map in `solutions/<slug>/` met per gekozen spoor een submap en een index-`README.md` met lifecycle-status.

## Kerncontext (altijd meegeven aan downstream skills)

- **Geografische focus**: Nederland. Prefereer NL-bronnen (CBS, Rijksoverheid, NOS, FD, vakbladen, branche-organisaties, CPB, SCP, RIVM, etc.). Internationale bronnen alleen als NL-data ontbreekt.
- **Taal**: Nederlands, tenzij de gebruiker expliciet anders vraagt.
- **Product-lens**: software-producten — geen diensten, geen hardware.
- **Opportunity-verankering**: elke output moet traceerbaar zijn naar de bron-opportunity-briefing.
- **"Pas toe of leg uit"**: alle skills per spoor worden gedraaid, of expliciet met reden overgeslagen in spoor-README.

## Input-handling

Accepteer één van:
- Pad naar opportunity-briefing (bv. `opportunities/zang-2026-04-21/README.md` + opportunity-id)
- Pad naar opportunities-map + opportunity-id als tweede argument
- Geen input → interview-modus: vraag welke opportunity te ontwikkelen

**Interview-exit**: zodra opportunity-id + opportunity-briefing vindbaar zijn.

### Sporen-selectie-dialoog (verplicht)

Na opportunity-resolutie en vóór Fase 0 voltooid is: presenteer een korte samenvatting van de 5 sporen en vraag interactief welke de gebruiker wil bewandelen. Gebruik `AskUserQuestion` met `multiSelect: true`. Geen CLI-flag; geen aanname dat alle sporen automatisch draaien.

Samenvatting per spoor:

| # | Spoor | Doel | Typische output |
|---|---|---|---|
| 1 | Scherp probleem | Segment + pijn + value-prop | segment-keuze · JTBD-deep · VPC · PSF-score |
| 2 | Markt & positionering | Markt-grootte + concurrentie | TAM/SAM/SOM · competitive-deep · positioning |
| 3 | MVP-spec | Functionele behoefte vastleggen | lean-canvas · functional-spec · user-stories · acceptance · pricing · pre-mortem · pilot-plan |
| 4 | Prototype + user-test | MVP-spec toetsen (gesimuleerd) | runnable wireframe · test-protocol · test-resultaten |
| 5 | GTM + launch-klaar | Vision + launch | vision/PR-FAQ · GTM-plan · launch-metrics |

Volgorde is vast — je kunt spoor 3 niet starten zonder eerst spoor 1+2 te hebben gedraaid (of reeds aanwezig in solution-map via eerdere run).

## Fase 0 — Input-bundel (≤5 min)

### 0.1 Resolve opportunity-briefing
- Lees de opportunity-referentie.
- Verzamel: opportunity-id, HMW, probleem, doelgroep, concurrenten, lens-tags, solution-hypothesen, riskiest assumption.
- Lees domein-context uit `interessegebieden/<domein>.md` indien aanwezig.

### 0.2 Persona-input
- Check `opportunities/<domein>-<datum>/personas-derived/` voor bestaande derived personas.
- **Hergebruik**: lees bestaande personas en filter op relevantie voor deze opportunity.
- **Her-derive** alleen als geen derived personas beschikbaar zijn; gebruik dan basale persona-keuze uit `personas/` met rol-overlay (vgl. `ontdek-kansen` Track A).

### 0.3 Solution-slug bepalen
- Genereer slug uit opportunity-titel (slugify, bv. `ai-zang-feedback`, `ai-educatie-coach`).
- Bij conflict met bestaande `solutions/<slug>/` of ambiguïteit: vraag interactief.

### 0.4 Solution-map aanleggen of detecteren
- **Nieuwe map**: maak `solutions/<slug>/` + top-level `README.md` met opportunity-verwijzing en lifecycle-status per spoor (allemaal ⏳).
- **Bestaande map** (her-entry): lees bestaande `README.md`, toon welke sporen al ✅ zijn, welke 🕒 of ❌.

### 0.5 Sporen-selectie-dialoog uitvoeren
Zie "Input-handling" hierboven. Gebruiker kiest welke sporen te (her)bewandelen.

### 0.6 Briefing samenstellen
Verzamel in een briefing-blok dat je aan elke downstream skill meegeeft:

```
## Briefing
- Opportunity: [opportunity-id + HMW]
- Domein: [naam]
- Doelgroep (opportunity-niveau): [uit opportunity-briefing]
- Personas-referentie: [pad + lijst relevante derived personas]
- Lens-tags: [L1 / L2 / beide / geen]
- Riskiest assumption: [uit opportunity-briefing]
- Markt: Nederland. Prefereer NL-bronnen.
- Output-taal: Nederlands.
- Solution-slug: [slug]
```

## Fase 1..5 — Sporen (elk met orchestratie + Go/No-Go-gate)

Loop door de gekozen sporen in nummerieke volgorde. Per spoor:

1. **Briefing doorgeven** aan elke sub-skill (als argument of in prompt).
2. **Volledige skill-set draaien** (zie tabellen hieronder). Bij elke sub-skill:
   - Skill aanroepen via `Skill` tool met opportunity-briefing + spoor-context.
   - Output opslaan in het daarvoor bestemde bestand.
   - Bij fout of niet-toepasselijkheid: loggen in spoor-README onder "Overgeslagen skills" met **expliciete reden**.
3. **Spoor-README schrijven** met:
   - Samenvatting van bevindingen
   - Lijst gedraaide skills + output-links
   - "Overgeslagen skills" sectie
   - Exit-gate-vraag voor de gebruiker
4. **Top-level lifecycle-status bijwerken** in solution-`README.md`.
5. **Stop en wacht op gebruiker-Go** voordat volgend spoor start. Gebruik AskUserQuestion.
6. **Soft-cap tijdwaarschuwing**: richtlijn per spoor is ~15-20 min skill-werk; bij overschrijding meld en vraag of door te gaan.

### Spoor 1 — Scherp probleem

Doel: segment + pijn + value-prop scherp krijgen.

| Skill | Output-bestand |
|---|---|
| `customer-segmentation` | `01-probleem/segment-keuze.md` |
| `jtbd-analysis` (deep op 1 segment) | `01-probleem/jtbd-deep.md` |
| `value-proposition-canvas` | `01-probleem/value-proposition-canvas.md` |
| `problem-solution-fit` | `01-probleem/problem-solution-fit.md` |

Exit-gate-vraag: *"Is er één duidelijk segment met een scherpe, niet-oplosbare pijn en een passende value-prop? Ga door naar spoor 2?"*

### Spoor 2 — Markt & positionering

Doel: markt-grootte + concurrentie-diepte + positioning.

| Skill | Output-bestand |
|---|---|
| `market-sizing` | `02-markt/market-sizing.md` |
| `competitive-analysis` (deep) | `02-markt/competitive-deep.md` |
| `industry-benchmarking` | `02-markt/industry-benchmarking.md` |
| `trend-analysis` (refined op segment) | `02-markt/trend-analysis.md` |

Positioning-statement destilleer je uit de vier bovenstaande outputs en schrijf je naar `02-markt/positioning.md`.

Exit-gate-vraag: *"Is de markt groot genoeg en positionering onderscheidend genoeg om door te gaan? Ga door naar spoor 3?"*

### Spoor 3 — MVP-spec (bepaalt de functionele behoefte)

Doel: product-scope + pricing + user stories + acceptance + risico's.

| Skill | Output-bestand |
|---|---|
| `business-case-management` (lean canvas) | `03-mvp/lean-canvas.md` |
| `functional-specifications` | `03-mvp/functional-spec.md` |
| `user-story-generator` | `03-mvp/user-stories.md` |
| `acceptance-criteria-writing` | `03-mvp/acceptance-criteria.md` |
| `roi-modeling` en/of `financial-forecasting` | `03-mvp/pricing-roi.md` |
| `pre-mortem` | `03-mvp/pre-mortem.md` |
| `risk-register` | `03-mvp/risk-register.md` |
| `story-mapping` | `03-mvp/story-map.md` |

Pilot-plan destilleer je uit bovenstaande outputs en schrijf je naar `03-mvp/pilot-plan.md`.

Exit-gate-vraag: *"Is de MVP-scope concreet genoeg om te prototypen en groot-genoeg-om-te-bouwen? Ga door naar spoor 4?"*

### Spoor 4 — Prototype + user-test (toetst spoor 3)

Doel: MVP-spec vertalen naar runnable prototype + gesimuleerde test.

| Skill | Output-bestand / artefact |
|---|---|
| `wireframing` | `04-prototype/wireframe-app/` (Vue 3 + Vite runnable app) |
| `ab-hypothesis-framing` | `04-prototype/hypothesen.md` |
| `rapid-prototyping` | `04-prototype/rapid-proto.md` |
| `survey-design` | `04-prototype/test-protocol.md` |
| `cognitive-walkthrough` | `04-prototype/walkthrough.md` |

Test-resultaten: redeneer vanuit de persona's in de briefing + walkthrough-output. Schrijf `04-prototype/test-resultaten.md` met **expliciete gesimuleerde** markering — géén echte gebruikers-sessies.

**Verplicht**: de `wireframing`-skill wordt altijd gedraaid als spoor 4 gekozen is. Geen markdown-alternatief.

Exit-gate-vraag: *"Valideert de gesimuleerde prototype-evaluatie de kernaannames? Ga door naar spoor 5?"*

### Spoor 5 — GTM + launch-klaar

Doel: vision + launch-plan.

| Skill | Output-bestand |
|---|---|
| `vision-crafting` (Working Backwards + PR-FAQ) | `05-gtm/vision-pr-faq.md` |
| `go-to-market` | `05-gtm/go-to-market.md` |
| `communication-plan` | `05-gtm/communication-plan.md` |
| `metric-definition` | `05-gtm/launch-metrics.md` |

Exit-gate-vraag: *"Is de propositie launch-klaar? Solution is voltooid."*

## Lifecycle-status-conventie

In solution-`README.md`:

| Status | Betekenis |
|---|---|
| ⏳ | Niet gestart |
| 🕒 | In uitvoering (gestopt mid-spoor) |
| ✅ | Voltooid en Go gegeven |
| ❌ | No-Go gegeven — spoor gestopt |

Update na elke spoor-voltooiing en bij her-entry.

## Generatieregels

- **Lens-tags** uit opportunity-briefing meenemen in briefing-blok; downstream skills respecteren ze.
- **Evidence-grounding**: elke niet-triviale claim is traceerbaar naar opportunity-briefing, sub-skill-output, of gelabeld als `[Aanname]`.
- **NL-focus** in bronvermelding; bij internationaal: label met `[int]`.
- **"Pas toe of leg uit"**: elke genoemde skill per spoor wordt gedraaid of geskipt met documentatie van de reden.
- **Her-entry-veilig**: nooit bestaande output overschrijven; bij conflict vraag aan gebruiker.
- **Taal**: Nederlandse output tenzij expliciet anders gevraagd.

## Faalgedrag

| Situatie | Gedrag |
|---|---|
| Geen opportunity-argument | Interview-modus: "Welke opportunity wil je ontwikkelen?" |
| Opportunity-briefing niet vindbaar | Stop, vraag gebruiker om pad op te geven |
| Geen derived personas beschikbaar | Her-derive uit `personas/` of meld gap in briefing |
| Sporen-volgorde-schending | Weiger, leg uit dat spoor N+1 spoor N vereist (of al ✅ moet zijn) |
| Sub-skill faalt | Spoor stoppen, spoor-README met partial output + foutbron, vraag gebruiker hoe door te gaan |
| Sub-skill niet toepasselijk op deze opportunity | Overslaan + reden documenteren in "Overgeslagen skills" |
| Tijd-overschrijding per spoor | Waarschuwing + optie om door te gaan of spoor af te breken |
| Solution-slug-conflict | Interactief vragen om andere slug of overschrijf-bevestiging |
| Her-entry op voltooide solution | Toon lifecycle-status, vraag welke sporen her-bewandelen |
| Gebruiker vraagt iets anders dan solution-ontwikkeling | "Deze skill orchestreert solution-ontwikkeling per opportunity. [Verzoek] valt buiten scope." |
| WebSearch-toegang ontbreekt | Ga door met sub-skills die zonder web werken; label uitkomst als `[Aanname — geen web-validatie]` |

## Self-check

Vóór het afsluiten van elk spoor:

```
[] Elke gekozen skill is gedraaid of met expliciete reden overgeslagen
[] Spoor-README bestaat met samenvatting + output-links + "Overgeslagen skills"
[] Alle sub-skill-outputs staan op de juiste plek binnen 0X-<spoor>/
[] Briefing-blok is aan elke sub-skill meegegeven
[] Lifecycle-status in solution-README is bijgewerkt
[] Exit-gate-vraag is gesteld aan de gebruiker
```

Vóór het afsluiten van de hele run (spoor 5 of eerder):

```
[] Solution-README toont correcte lifecycle-status per gekozen spoor
[] Alle output is traceerbaar naar opportunity-briefing
[] Taal = Nederlands (tenzij override)
[] Geen bestaande output overschreven zonder melding
[] Self-check per spoor is uitgevoerd
```

## Voorbeelden

### Voorbeeld 1 — Normaal: O09 uit zang-opportunities
**Input**: `/kans-uitwerken opportunities/zang-2026-04-21/ O09`
**Verwacht gedrag**: resolve O09-briefing uit `opportunities/zang-2026-04-21/README.md`, lees 5 relevante derived personas (Anouk, Stijn, Emre, Femke, Arjun), slug = `ai-zang-feedback`. Sporen-dialoog vraagt welke sporen. Bij keuze "alle 5" draai spoor 1-5 sequentieel met Go/No-Go-gates.

### Voorbeeld 2 — Interview-modus
**Input**: `/kans-uitwerken`
**Verwacht gedrag**: "Welke opportunity wil je ontwikkelen? Geef pad naar opportunity-briefing of opportunity-id + opportunities-map."

### Voorbeeld 3 — Subset van sporen
**Input**: `/kans-uitwerken opportunities/zang-2026-04-21/ O09`, gebruiker kiest in dialoog "alleen spoor 1 en 2"
**Verwacht gedrag**: draai spoor 1, Go/No-Go-gate, draai spoor 2, Go/No-Go-gate. Stop. Solution-README toont spoor 1+2 = ✅, spoor 3-5 = ⏳.

### Voorbeeld 4 — Her-entry
**Input**: `/kans-uitwerken opportunities/zang-2026-04-21/ O09` terwijl `solutions/ai-zang-feedback/` al bestaat met spoor 1+2 ✅
**Verwacht gedrag**: detecteer bestaande map, toon lifecycle-status, vraag welke sporen (extra) te bewandelen. Bij keuze "spoor 3" → start spoor 3 zonder spoor 1+2 aan te raken.

### Voorbeeld 5 — Sub-skill niet toepasselijk
**Input**: opportunity in een zeer nieuwe markt zonder benchmarks; spoor 2 draait
**Verwacht gedrag**: `industry-benchmarking` wordt aangeroepen, retourneert onvoldoende data. Skill documenteert in `02-markt/spoor-readme.md` onder "Overgeslagen skills": *"industry-benchmarking: overgeslagen — markt heeft geen gevestigde benchmarks beschikbaar per 2026-04. Volwassenheidsbenchmark zou arbitrair worden."*

### Voorbeeld 6 — Volgorde-schending
**Input**: `/kans-uitwerken opportunities/zang-2026-04-21/ O09`, gebruiker kiest "alleen spoor 3" zonder dat spoor 1+2 bestaan
**Verwacht gedrag**: weigeren: *"Spoor 3 (MVP-spec) vereist output van spoor 1 (probleem) en 2 (markt). Start eerst spoor 1+2, of kies een spoor-set die met 1 begint."*

### Voorbeeld 7 — Spoor 4 verplichte wireframe
**Input**: opportunity gekozen, spoor 4 in selectie
**Verwacht gedrag**: `wireframing`-skill draait altijd; produceert Vue 3 + Vite-app in `04-prototype/wireframe-app/`. Start-instructie in spoor-README: `cd solutions/<slug>/04-prototype/wireframe-app && npm install && npm run dev`. Dev-server sluiten na gebruik.

### Voorbeeld 8 — No-Go op exit-gate
**Input**: spoor 1 voltooid, gebruiker geeft No-Go ("segment is niet scherp genoeg")
**Verwacht gedrag**: markeer spoor 1 = ❌ in solution-README, schrijf reden in spoor-README, vraag of spoor 1 opnieuw te draaien (met andere briefing) of pipeline af te breken.

### Voorbeeld 9 — Uit-scope-verzoek
**Input**: "Implementeer de MVP voor mij"
**Verwacht gedrag**: *"Deze skill orchestreert solution-ontwikkeling tot en met launch-klaar-spec en gesimuleerde prototype-toets. Implementatie valt buiten scope — gebruik daarvoor engineering-skills zoals `vue-development-skill`."*

### Voorbeeld 10 — Web-toegang ontbreekt
**Input**: spoor 2 draait, WebSearch werkt niet
**Verwacht gedrag**: `market-sizing`, `competitive-analysis`, `trend-analysis` draaien op basis van alleen opportunity-briefing + bestaande `opportunities/*`-data; alle output-claims gelabeld als `[Aanname — geen web-validatie]`. Waarschuwing in spoor-README.
