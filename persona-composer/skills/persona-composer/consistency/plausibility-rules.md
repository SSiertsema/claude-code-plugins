# Plausibility rules

Loose rules used door de composer in Fase 7 (plausibility-check). Twee categorieën: **hard fails** die re-roll triggeren, en **soft warns** die gelogd worden in de `### Notes` van de persona maar compositie niet blokkeren.

## Hard fails (re-roll bundles)

Als een gecomposeerde persona één van deze situaties heeft, gooi de bundel-keuze weg en probeer opnieuw (max 3 pogingen per slot, daarna markeren als "impossible-under-constraints").

### Leeftijd vs beroep
- Leeftijd > 70 + beroep dat ≥40u fysieke arbeid vereist (bouwvakker, monteur, verpleegkundige in de uitvoering, boer op het land, transporteur)
- Leeftijd > 40 + beroep "professioneel atleet" (tenzij expliciet "gepensioneerd atleet" of "coach")
- Leeftijd > 35 + beroep "conservatoriumstudent" of "student-universiteit-bachelor"
- Leeftijd < 22 + beroep "chirurg", "hoogleraar", "rechter", "directeur-grote-organisatie", "huisarts met eigen praktijk"
- Leeftijd < 25 + beroep "partner bij advocatenkantoor" of "arts-specialist"

### Woonsituatie
- Eigen koopwoning in Amsterdam-centrum / grachtengordel + SES laag
- Eigen boerderij + regio G4-centrum
- Rijwoning jaren '70-wijk + bundle `fpc-003` (welgesteld-asset-rich) — meestal anders
- Sociale huurwoning + bundle `fpc-003`

### Gezondheid vs werk
- Bundle `hwa-002` (chronisch-ziek-WIA-parttime) + beroep met fysieke zwaarte ≥40u
- Bundle `hwa-002` + bundle `cgb-002` (jonge-kinderen-intensief) als energie-budget puur onmogelijk (check per geval)

### Identiteit-politiek-regio
- Bundle `ipc-001` (progressief-stedelijk-hoogopgeleid) + bundle `rr-003` (biblebelt-rooted) — cultuur-clash
- Bundle `frw-003` (islamitisch-praktiserend-Marokkaans) + bundle `mgc-001` (NL-native-geen-migratie) — migratie-achtergrond nodig
- Bundle `frw-002` (PKN-provincie-nuchter) + bundle `ipc-001` (progressief-stedelijk) — wrijving

### Opleiding vs beroep
- Bundle `ecm-002` (VMBO-MBO-praktisch) + beroep met WO-vereiste (arts, rechter, hoogleraar, advocaat)
- Bundle `ecm-003` (VWO-WO-academisch) + beroep VMBO-niveau als primair (bouwvakker, monteur)

## Soft warns (log in Notes van persona)

Deze combinaties zijn zeldzaam maar mogelijk — niet blokkeren, wel flag.

- SGP-kiezer + G4-centrum wonen ("zeldzaam maar voorstelbaar")
- Leeftijd < 22 + eigen koopwoning ("zeer zeldzaam zonder familievermogen")
- Migratie-2e-gen + opgegroeid in Friese krimpregio ("zeldzaam demografisch")
- Vegan + jaarlijks vliegen ver ("cognitieve dissonantie — echte personas hebben deze vaak")
- Pro-immigratie + PVV-stem ("onwaarschijnlijk maar denkbaar bij zeer specifieke migratie-ervaring")
- Bundle `rr-002` (dorp-born-and-raised) + bundle `ecm-003` (VWO-WO-academisch) ("uitzondering, mogelijk — eerste-generatie-studie is narratief")

## Hoe toe te passen

In Fase 7 van de composition algorithm:

1. Voor elke hard-fail-regel: check of de gecomposeerde persona deze bevat. Als ja → markeer slot als `HARD_FAIL`, noteer regel-ID.
2. Als `HARD_FAIL`: kies opnieuw bundel-combinatie (stap 2 van algoritme) met constraint dat de triggerende combinatie wordt vermeden.
3. Max 3 re-rolls per slot. Na 3 re-rolls: markeer slot als `impossible-under-constraints`, log uitvoerig in manifest, compose best-effort.
4. Voor elke soft-warn-regel: check, voeg bij trigger een regel toe aan `### Notes` in de persona: "Opmerking: [regel-beschrijving]. Deze combinatie is zeldzaam maar niet uitgesloten."

## Niet-goals

- Geen volledige constraint-satisfaction engine.
- Geen NLP-plausibiliteits-model.
- Geen statistische kansberekening op basis van CBS.
- De regels zijn bewust handgemaakt en beperkt — voldoende om 90%+ plausibele output te garanderen.
