---
name: kans-vitepress-documentation
description: Scaffoldt of her-aligneert een VitePress sub-site voor een solution binnen de kans-uitwerken-hub. Mode met wireframe-embed of zonder. Idempotent — theme/config-bestanden worden her-aligneert naar het huidige patroon; solution-content (01-probleem/, ... 05-gtm/) wordt nooit aangeraakt. Wired ook automatisch het hub-niveau (srcExclude, nav-dropdown, SUB_SITES-set, landing features).
argument-hint: "<slug> [--title '…'] [--tagline '…'] [--mode with-wireframe|without-wireframe] [--color hex] [--opportunity path]"
---

# Kans VitePress Documentation

Je scaffoldt of her-aligneert een VitePress sub-site voor een solution volgens het standaard-patroon van de kans-uitwerken-hub. Je output zijn bestanden op disk (sub-site + hub-wiring), geen prose.

## Positioning

Deze skill is de verplichte laatste stap van `kans-uitwerken`, ongeacht bij welk spoor de pipeline eindigt. Kan ook standalone worden aangeroepen om:
- een nieuwe sub-site op te zetten voor een bestaande `solutions/<slug>/`-map
- een bestaande sub-site te her-aligneren met het huidige patroon (idempotent)

Niet van toepassing op:
- solutions die binnen de hub worden gerenderd (geen eigen `.vitepress/`). Dat pad scaffoldt deze skill niet.
- solution-content zelf (01-probleem/, 02-markt/, 03-mvp/, 04-prototype/, 05-gtm/). Die blijft onaangeraakt.

## Kerncontext

- **Hub-project**: wordt vooraf gedetecteerd via een zoektocht naar `/.vitepress/config.mts` met `srcExclude` dat `solutions/`-paden bevat.
- **Workspaces**: de hub's `package.json` MOET `solutions/*` én (indien mode = with-wireframe) `solutions/*/04-prototype/wireframe-app` als workspaces hebben. Deze skill controleert dat maar past het niet aan (hub-eigenaar-verantwoordelijkheid).
- **Taal**: Nederlandse output + copy.
- **Fail-fast**: bij ontbrekende hub-structuur stop met `Cannot proceed`.

## Input-handling

Accepteer één van:

1. **Volledige argumenten**: `<slug> --title "…" --tagline "…" --mode with-wireframe`
2. **Alleen slug**: `<slug>` — zoek in `solutions/<slug>/README.md` + `index.md` naar bestaande `TITLE` en `TAGLINE`; vraag ontbrekende waarden via interview
3. **Geen argument**: interview-modus — vraag slug, titel, tagline, mode, opportunity-ref

**Mode-detectie** (als niet opgegeven):
- Bestaat `solutions/<slug>/04-prototype/wireframe-app/package.json`? → `with-wireframe`
- Anders → `without-wireframe`

**Brand-color** (optioneel):
- Verplicht NIET aanwezig → fallback naar neutrale palette (grijs-blauw, zie Kleur-defaults)
- Accepteert één hex (bv. `#4a6fa5`) → genereer 5-stops palette (50/100/500/600/700) door HSL-shifting
- Accepteert benoemde kleur: `blue`, `green`, `purple`, `amber`, `teal`, `rose`, `slate` → gebruik vooringestelde palette

### Kleur-defaults

| Naam | 50 | 100 | 500 | 600 | 700 | Comment |
|---|---|---|---|---|---|---|
| neutral (default) | `#edf2f9` | `#d6e0ee` | `#4a6fa5` | `#3a5e94` | `#2c4b7a` | grijs-blauw |
| blue | `#eff6ff` | `#dbeafe` | `#3b82f6` | `#2563eb` | `#1d4ed8` | helder blauw |
| green | `#ecfdf5` | `#d1fae5` | `#10b981` | `#059669` | `#047857` | teal-groen |
| purple | `#faf5ff` | `#f3e8ff` | `#a855f7` | `#9333ea` | `#7e22ce` | violet |
| amber | `#fffbeb` | `#fef3c7` | `#f59e0b` | `#d97706` | `#b45309` | warm amber |
| teal | `#f0fdfa` | `#ccfbf1` | `#14b8a6` | `#0d9488` | `#0f766e` | koel teal |
| rose | `#fff1f2` | `#ffe4e6` | `#f43f5e` | `#e11d48` | `#be123c` | zacht rood |
| slate | `#f8fafc` | `#f1f5f9` | `#64748b` | `#475569` | `#334155` | leisteen |

## Fase 0 — Hub-detectie

1. Start vanuit CWD; zoek `/.vitepress/config.mts` of parent-dirs tot root.
2. Valideer:
   - `/.vitepress/config.mts` bestaat en bevat `srcExclude` (Array)
   - `/.vitepress/theme/index.ts` bestaat en bevat `const SUB_SITES = new Set([...])`
   - `/package.json` bestaat met `"workspaces": ["solutions/*", "solutions/*/04-prototype/wireframe-app"]` (of superset)
   - `/index.md` bestaat met `features:` frontmatter-sectie
3. Bij ontbrekende structuur: stop met:
   ```
   ## Cannot proceed

   **Reason**: hub-project niet gevonden of niet correct geconfigureerd.
   **Missing**: [specifiek bestand + regel]
   **Action**: run deze skill vanuit een kans-uitwerken-hub, of stel de ontbrekende structuur eerst op.
   ```

## Fase 1 — Slug-validatie

1. Vereist patroon: `^[a-z][a-z0-9-]{2,40}$` (lowercase, cijfers, koppelteken; geen underscores/spaties)
2. Controleer `solutions/<slug>/` bestaat; zo niet, stop:
   ```
   ## Cannot proceed

   **Reason**: `solutions/<slug>/` bestaat niet.
   **Action**: maak eerst de solution-map via kans-uitwerken.
   ```
3. Bij her-alignement (sub-site bestond al): lees bestaande titel/tagline uit `solutions/<slug>/index.md` of `README.md` voor verdere invulling.

## Fase 2 — Mode-bepaling

1. **Expliciet opgegeven** (`--mode …`): gebruik die.
2. **Afgeleid** via `04-prototype/wireframe-app/package.json`:
   - Aanwezig → `with-wireframe`
   - Afwezig → `without-wireframe`
3. Log de keuze expliciet in de output.

## Fase 3 — Sub-site scaffold / re-align

Bepaal per bestand: `create` (nieuw) of `update` (bestaand, diff-check).

### Te schrijven bestanden

Relatief aan `solutions/<slug>/`:

| Pad | Template | Always-overwrite |
|---|---|---|
| `.vitepress/config.mts` | `config.mts.template` | Ja (her-aligneert) |
| `.vitepress/theme/index.ts` | `theme-index.ts.template` | Ja |
| `.vitepress/theme/custom.css` | `theme-custom.css.template` | Ja |
| `.vitepress/theme/MainHeader.vue` | `MainHeader.vue` (literal copy) | Ja |
| `.vitepress/theme/AppearanceToggle.vue` | `AppearanceToggle.vue` (literal copy) | Ja |
| `package.json` | `package.json.{mode}.template` | Ja |
| `index.md` | `index.md.template` | **Nee** — alleen aanmaken als niet bestaat; anders skippen (behoudt eigenaar-aanpassingen) |
| `04-prototype/wireframe.md` | `wireframe.md.template` — alleen bij `with-wireframe` | Ja |

### Template-substitutie

Variabelen die in templates worden vervangen:

| Placeholder | Bron | Voorbeeld |
|---|---|---|
| `{{SLUG}}` | argument | `zangles-platform` |
| `{{TITLE}}` | argument of titelizerd-slug | `Zangles-Platform` |
| `{{TAGLINE}}` | argument of default | `Geïntegreerd online-zangles-platform voor docent + student` |
| `{{HERO_TEXT}}` | argument of default | `Alle zangles-tools in één` |
| `{{DESCRIPTION}}` | uit tagline | (gelijk aan tagline) |
| `{{DOMAIN}}` | argument of `[niet gespecificeerd]` | `Zang` |
| `{{MARKET}}` | argument of `[niet gespecificeerd]` | `Nederland` |
| `{{FOOTER_MESSAGE}}` | auto-genereerd | `<title> — solution-exploratie (<slug>)` |
| `{{OPPORTUNITY_LINK}}` | `--opportunity` of `#` | `../../opportunities/zangles-platform-2026-04-22/` |
| `{{BRAND_50}}` ... `{{BRAND_700}}` | uit kleur-keuze | zie tabel |
| `{{COLOR_NAME_COMMENT}}` | naam of hex | `blue (helder blauw)` |
| `{{WIREFRAME_SRC_EXCLUDE}}` | bij `with-wireframe`: `,\n      '04-prototype/wireframe-app/**'`; anders: lege string | — |
| `{{WIREFRAME_SIDEBAR_ITEM}}` | bij `with-wireframe`: `,\n            { text: '🎨 Wireframe (live)', link: '/04-prototype/wireframe' }`; anders: lege string | — |
| `{{HERO_WIREFRAME_ACTION}}` | bij `with-wireframe`: extra action-block; anders: lege string | — |
| `{{PROTOTYPE_DETAILS}}` | bij `with-wireframe`: verwijst naar live wireframe; anders: spec-only-tekst | — |

### Idempotentie-protocol

Voor elk bestand dat "Always-overwrite: Ja":

1. **Bestaat het**? Lees huidige inhoud.
2. **Genereer target**-inhoud via template + substitutie.
3. **Diff**: als huidige inhoud ≠ target → toon `[update]` + korte samenvatting van het verschil (aantal regels gewijzigd), dan schrijf.
4. Als gelijk → log `[unchanged]`.
5. **Bestaat niet** → log `[create]` en schrijf.

Voor `index.md`: alleen schrijven als het bestand niet bestaat (`[create]` of `[skip — exists]`).

## Fase 4 — Hub-wiring

Pas 4 bestanden aan in het hub-root:

### 4.1 `/.vitepress/config.mts` — srcExclude

Zoek de `srcExclude: [...]`-array. Check of `'solutions/<slug>/**'` al aanwezig is.
- Aanwezig → log `[unchanged]`
- Afwezig → voeg alfabetisch gesorteerd toe binnen het `solutions/*`-blok en log `[added]`

### 4.2 `/.vitepress/config.mts` — nav 'Uitgewerkt'-dropdown

Zoek `{ text: 'Uitgewerkt', items: [ … ] }` (of vergelijkbaar; afhankelijk van hub-versie). Check of een entry met `link: '/solutions/<slug>/'` bestaat.
- Aanwezig → log `[unchanged]`
- Afwezig → voeg toe onderin de items-lijst (met `rel: 'external'`), log `[added]`

Als geen 'Uitgewerkt'-dropdown bestaat: voeg er één toe.

### 4.3 `/.vitepress/theme/index.ts` — SUB_SITES set

Zoek `const SUB_SITES = new Set([...])`. Check of `'<slug>'` erin staat.
- Aanwezig → log `[unchanged]`
- Afwezig → voeg toe (alfabetisch gesorteerd), log `[added]`

Als de set-declaratie ontbreekt: stop met `Cannot proceed` — hub is niet compatibel.

### 4.4 `/index.md` — hero features + Live exploraties

Parse frontmatter `features:`. Check of een feature met `link: /solutions/<slug>/` bestaat.
- Aanwezig → log `[unchanged]`
- Afwezig → voeg feature-kaart toe onderin de features-array, met `icon: {{ICON}}`, `title: <title>`, `details: <tagline>`, `linkText: Open sub-site`, `rel: external`. Log `[added]`.

Als er een body-sectie `## Live exploraties` met bullet-list bestaat: voeg bullet toe aan de lijst. Anders: skip dit deel.

Default icons per mode:
- with-wireframe → 🎨
- without-wireframe → 📋

## Fase 5 — Build-validatie

1. Run `npm install` op de hub-root (werkspace-refresh).
2. Run `npm run build` op hub-root.
3. Check of `dist/solutions/<slug>/index.html` bestaat. Bij `with-wireframe` ook `dist/solutions/<slug>/wireframe/index.html`.
4. Bij fout: log de error-output en stop met `Cannot proceed — build faalde`.

Mag worden overgeslagen bij explicit `--skip-build`.

## Fase 6 — Eindrapport

Output-contract:

```markdown
## Kans VitePress Documentation — <slug>

**Mode**: with-wireframe | without-wireframe
**Kleur**: <naam of hex>
**Titel**: <title>

### Sub-site-scaffold
- [create | update | unchanged] `.vitepress/config.mts`
- [create | update | unchanged] `.vitepress/theme/index.ts`
- ... (elk bestand)

### Hub-wiring
- [added | unchanged] srcExclude
- [added | unchanged] nav-dropdown
- [added | unchanged] SUB_SITES-set
- [added | unchanged] landing features

### Build-validatie
- `dist/solutions/<slug>/index.html` ✓
- `dist/solutions/<slug>/wireframe/index.html` ✓ (indien with-wireframe)

### Volgende stap
- Commit + push om Netlify-deploy te triggeren
- URL live: `https://<hub-netlify>/solutions/<slug>/`
```

## Failure-gedrag

| Situatie | Gedrag |
|---|---|
| Geen slug | Interview: "Voor welke solution wil je een sub-site (slug)?" |
| Slug niet geldig | Toon patroon, vraag opnieuw |
| `solutions/<slug>/` bestaat niet | `Cannot proceed` — solution-map moet eerst via kans-uitwerken aangemaakt |
| Hub-structuur niet compatibel | `Cannot proceed` — wijs aan welk bestand/regel ontbreekt |
| Build faalt | Log error, toon mogelijke oorzaken (ontbrekende `srcExclude`, `SUB_SITES`-entry etc.) |
| Gebruiker annuleert | Gemaakte wijzigingen blijven staan; geen rollback |

## Self-check

```
[] Slug voldoet aan patroon
[] Hub-structuur gedetecteerd en valide
[] Mode expliciet gelogd
[] Alle 8 (without-wireframe) of 9 (with-wireframe) templates geschreven of gepland
[] Hub-wiring in 4 plekken gecheckt en zo nodig bijgewerkt
[] Build-validatie gedraaid (tenzij --skip-build)
[] Rapport toont per-bestand-status
```

## Voorbeelden

### Voorbeeld 1 — Nieuwe sub-site, met wireframe

**Input**: `/kans-vitepress-documentation ai-stemcoach --title "AI Stemcoach" --tagline "Realtime zangtechniek-feedback op je stem" --mode with-wireframe --color purple`

**Verwacht**: 9 bestanden geschreven in `solutions/ai-stemcoach/`; hub bijgewerkt op 4 plekken; `npm run build` slaagt; `dist/solutions/ai-stemcoach/{index.html,wireframe/index.html}` beide bestaan.

### Voorbeeld 2 — Her-alignement bestaande sub-site

**Input**: `/kans-vitepress-documentation zangles-platform`

**Verwacht**: mode auto-gedetecteerd als `with-wireframe` (wireframe-app aanwezig); titel/tagline uit bestaande `index.md`; 8 bestanden her-aligneert (diff-check per bestand); hub-wiring `[unchanged]` (al gewired); build slaagt.

### Voorbeeld 3 — Standalone zonder wireframe

**Input**: `/kans-vitepress-documentation beleidsanalyse-assistent --mode without-wireframe --color slate`

**Verwacht**: 8 bestanden (geen wireframe.md); `package.json` zonder wireframe:build; config.mts met lege `srcExclude` toevoeging en spoor-4-sidebar zonder wireframe-item.

### Voorbeeld 4 — Hub niet gevonden

**Input**: `/kans-vitepress-documentation foo` uitgevoerd buiten hub-project

**Verwacht**: `Cannot proceed` met duidelijke aanwijzing om vanuit de hub te draaien.

### Voorbeeld 5 — Ongeldige slug

**Input**: `/kans-vitepress-documentation "Foo Bar"`

**Verwacht**: Interview-fallback: "Slug moet lowercase met koppeltekens zijn, bv. `foo-bar`. Wil je `foo-bar` gebruiken?"

## Generatieregels (per foundation §2 — generation)

- **Wat mag worden uitgevonden**: niets. Alle inhoud komt uit templates + argumenten of auto-detectie uit bestaande bestanden.
- **Wat moet gegrond zijn**: slug uit argument of bestaande map-naam; titel/tagline uit argument of bestaande `index.md`; opportunity-link uit argument.
- **Creativiteitsniveau**: `none` — deterministische scaffold.
- **Wat nooit gefabriceerd mag worden**: opportunity-IDs, HMW-statements, persona-lijsten. Als die ontbreken in templates, leeg laten.
