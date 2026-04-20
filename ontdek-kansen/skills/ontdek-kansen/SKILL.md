---
name: ontdek-kansen
description: Orchestreert een pipeline van skills (trend-analysis, competitive-analysis, jtbd-analysis, hmw-framing, opportunity-scoring) om per interessegebied een gerangschikte lijst van softwareproduct-kansen op te leveren. Focus op de Nederlandse markt en twee strategische lenzen (goedkopere her-implementatie + niet-beeldscherm-interfaces).
argument-hint: "[interessegebied — bv. zorg, educatie, voetbal, fitness, zang, overheid, veiligheid]"
---

# Ontdek Kansen

Je orchestreert een multi-skill pipeline die per interessegebied software-product-kansen op de Nederlandse markt ontdekt en rangschikt. Je roept bestaande skills aan via de `Skill` tool. Je eindresultaat is een Markdown-rapport met een gerangschikte opportunity-lijst.

## Kerncontext (altijd meegeven aan downstream skills)

- **Geografische focus**: Nederland. Prefereer NL-bronnen (CBS, Rijksoverheid, NOS, FD, vakbladen, branche-organisaties, gemeentelijke rapporten, CPB, SCP, RIVM, etc.). Internationale bronnen alleen als NL-data ontbreekt.
- **Taal**: Nederlands, tenzij de gebruiker expliciet anders vraagt.
- **Product-lens**: software-producten — geen diensten, geen hardware.
- **Twee strategische lenzen** (bonus-score, geen harde filter):
  - **L1 — Goedkopere her-implementatie**: bestaande software in het domein die 'te duur' is en waarvoor een goedkoper alternatief kansrijk is. AI en moderne software-stacks maken veel herbouw goedkoper en robuuster dan 5-10 jaar geleden.
  - **L2 — Niet-beeldscherm-interfaces**: kansen waar software beter zou landen via audio, dialoog, smartglasses, smart headphones, smartwatches of andere ambient/voice-first interfaces, maar bestaande oplossingen nog primair op een beeldscherm leunen.
- **Tijdsbudget**: maximaal 60 minuten totaal.

## Input-handling

Accepteer één van:
- Een domeinnaam als argument (bv. `zorg`, `educatie`, `voetbal`, `fitness`, `zang`, `overheid`, `veiligheid`)
- Een pad naar een domein-md (bv. `interessegebieden/zorg_en_welzijn.md`)
- Geen input → interview-modus: vraag welk interessegebied

**Interview-exit**: zodra het domein bekend is en het bijbehorende md-bestand vindbaar is.

## Fase 0 — Input-bundel (≤5 min)

### 0.1 Resolve domein-bestand
Zoek in `interessegebieden/`. Mapping:

| Argument | Bestand |
|---|---|
| `zorg` | `interessegebieden/zorg_en_welzijn.md` |
| `educatie` | `interessegebieden/educatie.md` |
| `voetbal` | `interessegebieden/voetbal.md` |
| `fitness` | `interessegebieden/fitness.md` |
| `zang` | `interessegebieden/zang.md` |
| `overheid` | `interessegebieden/overheid.md` |
| `veiligheid` | `interessegebieden/veiligheid.md` |

Als het bestand niet bestaat: stop en vraag de gebruiker om het te maken (of geef een pad op).

### 0.2 Persona-samenstelling

Stel een set van 8-15 domein-specifieke personas samen. Er zijn twee tracks, in volgorde van voorkeur:

---

#### Track A — Derive: bestaande personas adopteren en domein-rol overlayen (voorkeur)

Dit garandeert domein-relevantie en benut de rijke narratief-structuur (demografie, familie, gezondheid, persoonlijkheid) van de bestaande personas.

1. **Kies 8-12 base-personas** uit `personas/` op basis van expliciete diversiteit:
   - Leeftijd: minstens 3 bandjes (bv. 15-25, 26-45, 46-65, 65+)
   - Regio: mix van G4 / middelgrote stad / klein dorp
   - Sociaaleconomische status: laag / midden / hoog
   - Gender en migratie-achtergrond in representatieve mix
   - Bij afwezigheid van metadata: selecteer op bestandsnaam/plaatsnaam en steekproeven op de eerste ~10 regels van elke file

2. **Definieer een catalogus van domein-rollen** vóór adoptie. Bepaal de rollen vanuit de subdomeinen in het `interessegebieden/<gebied>.md`. Voorbeeld voor **zang**:
   - Zangleraar / stemcoach bij muziekschool
   - Amateur-koorlid (pas beginnend)
   - Zangstudent conservatorium
   - Semi-professionele vocalist (coverband, musical-ensemble)
   - Hobby-zanger thuis (douche, karaoke, TikTok)
   - Koordirigent vrijwillig
   - Logopedist met focus stem
   - Ouder van kind met zang-ambitie
   - Volwassene in stemrevalidatie (na operatie/ziekte)

3. **Wijs per base-persona een rol toe** en pas minimaal aan:
   - **Wat je verandert**: beroep / hobby-focus, domein-specifieke doelen, pains, gains, dagelijkse routines rond het domein
   - **Wat je behoudt**: demografie, familiecontext, financiële situatie, persoonlijkheid, mentale gezondheid, taalvoorkeur, digitale vaardigheid
   - **Conflicten**: als de base-persona onverenigbaar is met de rol (bv. persona is blind → niet passend voor "scherm-heavy"-rol), kies een andere base-persona

4. **Schrijf de afgeleide personas tijdelijk** naar `opportunities/<domein>-<datum>/personas-derived/` zodat downstream skills (Fase 1.3 JTBD) ernaar kunnen verwijzen.

5. **Naamgeving** bij derived personas: `<base-id>_as_<rol>.md` (bv. `001_anouk_de_vries_as_hobby_zanger.md`) — traceerbaar naar origineel.

---

#### Track B — Filter: bestaande domein-getagde personas gebruiken

Alleen bruikbaar als personas al domein-metadata hebben. Methoden in voorkeursvolgorde:

1. **YAML-frontmatter met `domains: [...]`** — lees alleen frontmatter, filter direct.
2. **Index-bestand** `personas/domain-index.md` met mapping `domein → [persona-bestanden]`.
3. **Bestandsnaam-patroon** `<id>_<naam>_<plaats>_<domein>.md`.
4. **Heuristische scan** (fallback, duur): eerste 30 regels per file scannen en filteren.

---

#### Stopcriterium
- Minstens 6 personas (6 = minimum voor zinvolle JTBD-variatie)
- Maximaal 15 personas (>15 voegt vooral token-last toe)

#### Bij falen
Als beide tracks <6 personas opleveren: noteer in rapport onder "Aannames & beperkingen" en ga verder zonder persona-input. Fase 1.3 werkt dan alleen op domeincontext.

### 0.3 Samenstel briefing
Verzamel in een briefing-blok dat je aan elke downstream skill meegeeft:

```
## Briefing
- Domein: [naam]
- Domeincontext: [inhoud van interessegebieden/<bestand>.md]
- Personas-methode: [Track A — derived / Track B — filtered / Geen]
- Personas: [lijst namen + rol + 1-regel samenvatting per persona; bij Track A ook base-id noemen]
- Lenzen:
  - L1: goedkopere her-implementatie van te dure bestaande software
  - L2: niet-beeldscherm-interfaces (audio, dialoog, smartglasses, headphones, watch)
- Markt: Nederland. Prefereer NL-bronnen.
- Output-taal: Nederlands.
```

## Fase 1 — Signaalverzameling (≤25 min, parallel waar mogelijk)

Roep de volgende drie skills sequentieel aan (parallel niet gegarandeerd binnen één sessie; sequentieel is veiliger). Geef elke skill de briefing uit Fase 0 plus een specifieke focus-instructie.

### 1.1 Trend-analyse
Roep `trend-analysis` aan met:
- Scope: "[domein] in Nederland"
- Focus: PESTEL-scan + opkomende trends die software-kansen opleveren; classificeer als megatrend / trend / fad
- Let specifiek op: technologische trends die L1 (prijsverlaging) of L2 (nieuwe interfaces) mogelijk maken

**Output opslaan**: `opportunities/<domein>-<datum>/01-trend-analysis.md`

### 1.2 Concurrentie-analyse
Roep `competitive-analysis` aan met:
- Scope: "softwareaanbod voor [domein] in Nederland"
- Focus: wie zijn de spelers, wat zijn de prijspunten, welke interfaces gebruiken ze (beeldscherm / mobiel / voice / wearable)
- Let specifiek op: aanbod dat als 'te duur' wordt ervaren (L1) en aanbod dat alleen op beeldscherm draait terwijl ambient use-cases bestaan (L2)

**Output opslaan**: `opportunities/<domein>-<datum>/02-competitive-analysis.md`

### 1.3 Jobs-to-be-Done analyse
Roep `jtbd-analysis` aan met:
- Scope: "[domein] vanuit perspectief van de geselecteerde personas"
- Persona-input: de persona-briefing uit Fase 0
- Focus: onvervulde of onderbediende jobs; gebruik "when [situation] I want to [outcome] so I can [benefit]"

**Output opslaan**: `opportunities/<domein>-<datum>/03-jtbd-analysis.md`

## Fase 2 — Gap-synthese (≤15 min)

### 2.1 Consolideer bevindingen
Verzamel uit fase 1 alle losse gaps/kansen/onvervulde jobs. Deduplificeer en groepeer.

### 2.2 Lens-tagging
Tag elke gap met L1, L2, beide of geen:
- **L1**: is er bestaande software die dit adresseert maar als te duur wordt ervaren? → tag `L1`
- **L2**: zou deze gap beter bediend worden via audio / dialoog / smartglasses / headphones / watch? → tag `L2`
- Een gap mag beide tags hebben.

### 2.3 HMW-framing
Roep `hmw-framing` aan met:
- Input: de geconsolideerde, lens-getagde gap-lijst
- Focus: één of meer "How might we..."-statements per gap die een kandidaat-opportunity formuleren
- Instructie: behoud de lens-tags bij elke HMW-statement

**Output opslaan**: `opportunities/<domein>-<datum>/04-gap-synthese-hmw.md`

## Fase 3 — Opportunity-scoring (≤15 min)

Roep `opportunity-scoring` aan met:
- Input: de HMW-statements uit Fase 2.3 als kandidaat-opportunities
- **Multi-Criteria scoring** (Phase 8 in opportunity-scoring) met deze gewichten:

### Scoringsformule

Elk criterium krijgt een score 0-100. De eindscore is:

```
totaal = 0.40·Waarde + 0.30·Complexiteit_ratio + 0.20·Lage_afhankelijkheden + lens_bonus
```

Maximum theoretische score: 100 (weighted) + 10 (bonus) = **110**.

### Criteria en gewichten

| Criterium | Gewicht | Score 0-100 betekent |
|---|---|---|
| Waarde | 40% | 0 = geen meetbare waarde, 100 = grote impact × grote NL-marktomvang |
| Complexiteit-vs-waarde-ratio | 30% | 0 = bouw-inspanning veel groter dan waarde; 100 = lage complexiteit, hoge waarde |
| Lage afhankelijkheden | 20% | 0 = volledig afhankelijk van externe partijen/regelgeving/data; 100 = zelfstandig bouwbaar |

### Lens-bonus (absolute punten bovenop totaal)

| Lens-tag | Bonus |
|---|---|
| Geen lens | +0 |
| Alleen L1 (her-implementatie) | +4 |
| Alleen L2 (niet-beeldscherm) | +6 |
| Beide lenzen | +10 |

Deze punten worden **letterlijk opgeteld** bij de weighted score — niet genormaliseerd. Een kans zonder lens-hit kan dus maximaal 100 scoren; een dubbele-lens-kans maximaal 110.

### Aanvullende instructies aan opportunity-scoring

- Gebruik Ulwick Opportunity Score (Phase 6) waar JTBD-data rijk genoeg is, anders uitsluitend Multi-Criteria.
- Rapporteer per opportunity: de drie deelscores, de lens-tags, de bonus, en de totaal-score in één tabel.
- Produceer het volledige rapport inclusief ranglijst, landscape-quadrant en solution-tree voor de top 5.

**Output opslaan**: `opportunities/<domein>-<datum>/05-opportunity-scoring.md`

## Fase 4 — Eindrapport

Assembleer een samenvattend rapport:

```markdown
# Kansen in [domein] — Nederland — [datum]

## Samenvatting
- Aantal kansen geïdentificeerd: [N]
- Top-3 kansen: [lijst]
- L1-kansen (her-implementatie): [N]
- L2-kansen (niet-beeldscherm-interfaces): [N]
- Dubbele-lens-kansen: [N]

## Top-10 opportunity-ranglijst
[tabel: rank, HMW, lens-tags, waarde, complexiteit-ratio, afhankelijkheden, totaal-score]

## Per top-5 uitgewerkt
[per opportunity: HMW, probleem, doelgroep (personas), concurrenten, lens-rationale, solution-hypothesen, belangrijkste aanname om te testen]

## Detailrapporten
- [link naar 01-trend-analysis.md]
- [link naar 02-competitive-analysis.md]
- [link naar 03-jtbd-analysis.md]
- [link naar 04-gap-synthese-hmw.md]
- [link naar 05-opportunity-scoring.md]

## Aannames & beperkingen
[expliciete lijst: welke data was dun, waar is geëxtrapoleerd, welke personas ontbraken]

## Vervolgstappen
[top-3 kansen → voorgesteld eerste experiment per kans]
```

**Opslaan naar**: `opportunities/<domein>-<datum>/README.md`

Presenteer voor gebruikersgoedkeuring. Schrijf de bestanden pas na expliciete bevestiging.

## Generatieregels

- **Lens-tagging is verplicht** op elke opportunity in de eindlijst.
- **Scoring is gegrond in evidence** — elke score moet traceerbaar zijn naar een bron of expliciet gelabeld als [Aanname].
- **NL-focus in bronvermelding**: elk brongebruik moet zichtbaar zijn in het rapport; bij gebrek aan NL-data, label internationaal gebruikte data als `[int]`.
- **Tijdsbudget**: als een fase dreigt uit te lopen, stop die fase en flag dat in het eindrapport onder "Beperkingen".
- **Geen verzonnen concurrenten**: als `competitive-analysis` geen concrete spelers vindt, meld dat expliciet — verzin er geen.
- **Taal**: alle output in het Nederlands.

## Faalgedrag

| Situatie | Gedrag |
|---|---|
| Geen domein-argument | Interview-modus: "Voor welk interessegebied wil je kansen ontdekken?" |
| Domein-md bestaat niet | Stop, vraag gebruiker om bestand aan te maken of pad op te geven |
| `personas/` is leeg of geen matches | Flag in rapport, ga door zonder persona-input in Fase 1.3 |
| Downstream-skill faalt | Flag welke fase en waarom; lever partieel rapport met duidelijke gaps |
| Fase dreigt het tijdsbudget te overschrijden | Stop die fase, noteer in rapport, ga naar volgende fase |
| WebSearch-toegang ontbreekt | Ga door met domein-md + personas als enige input; label alle scores als `[Aanname — geen web-validatie]` |
| Gebruiker vraagt iets anders dan kansen ontdekken | "Deze skill orchestreert kansen-ontdekking per interessegebied. [Verzoek] valt buiten scope." |

## Self-check

Vóór het presenteren van het eindrapport:

```
[] Domein-context is geladen uit interessegebieden/<bestand>.md
[] Minstens 6 personas samengesteld via Track A of B (of gap expliciet gemeld)
[] Bij Track A: elke derived persona is traceerbaar naar base-persona en heeft een domein-rol toegewezen
[] Fase 1: trend-, competitive- én jtbd-output bestaat
[] Fase 2: elke opportunity heeft een lens-tag (L1, L2, beide, of geen)
[] Fase 2: elke opportunity heeft minstens één HMW-statement
[] Fase 3: elke opportunity heeft een score op alle vier de criteria
[] Fase 3: lens-bonus is correct toegepast (+4 / +6 / +10)
[] Eindrapport heeft een top-10 ranglijst
[] Top-5 heeft uitgewerkte solution-hypothesen
[] Aannames en data-gaps staan expliciet in "Aannames & beperkingen"
[] Alle tussenbestanden staan in opportunities/<domein>-<datum>/
[] Totale doorlooptijd ≤ 60 minuten (of overschrijding gemeld)
[] Output-taal = Nederlands
```

## Voorbeelden

### Voorbeeld 1 — Normaal gebruik
**Input**: `/ontdek-kansen zorg`
**Verwacht gedrag**: resolve `interessegebieden/zorg_en_welzijn.md`, selecteer personas met raakvlak zorg (mantelzorgers, ouderen, zorgverleners, chronisch zieken), run fase 1-3, lever rapport met top-10 kansen in de Nederlandse zorgmarkt.

### Voorbeeld 2 — Alternatief argument
**Input**: `/ontdek-kansen interessegebieden/fitness.md`
**Verwacht gedrag**: gebruik opgegeven pad direct, skip lookup.

### Voorbeeld 3 — Ontbrekend argument
**Input**: `/ontdek-kansen`
**Verwacht gedrag**: interview-modus.

### Voorbeeld 4 — Onbekend domein
**Input**: `/ontdek-kansen landbouw`
**Verwacht gedrag**: "Geen `interessegebieden/landbouw.md` gevonden. Wil je dit bestand eerst aanmaken, of een bestaand interessegebied kiezen?"

### Voorbeeld 5 — Na uitvoering
**Input**: "OK, genereer nu een business case voor opportunity #1"
**Verwacht gedrag**: "Deze skill orchestreert kansen-ontdekking. Voor een business case, gebruik `/business-case-management` met opportunity #1 als input."
