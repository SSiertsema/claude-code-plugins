# Wirekit Fonts

## Current state (v0.1.0)

Wirekit's `css/wireframe.css` currently imports fonts via **Google Fonts CDN**:

```css
@import url('https://fonts.googleapis.com/css2?family=Caveat:wght@400;700&family=Patrick+Hand&display=swap');
```

This is a pragmatic choice for v0.1 to keep the library small and the aesthetic immediate.

## Vendoring plan (v1.0 target)

For production / offline / privacy-conscious use, the fonts should be vendored (downloaded and served locally).

### Fonts used

| Font | Designer | License | Role |
|---|---|---|---|
| [Caveat](https://fonts.google.com/specimen/Caveat) | Pablo Impallari | OFL (SIL Open Font License) | Primary — headlines, body, CTAs |
| [Patrick Hand](https://fonts.google.com/specimen/Patrick+Hand) | Patrick Wagesreiter | OFL (SIL Open Font License) | Secondary — form inputs, labels, smaller UI |

Both are OFL — free to vendor and redistribute.

### Vendoring steps (before v1.0 release)

1. Download woff2 files from Google Fonts (or fontsource.org):
   - `caveat/Caveat-Regular.woff2`
   - `caveat/Caveat-Bold.woff2`
   - `patrick-hand/PatrickHand-Regular.woff2`
2. Place in this directory:
   ```
   wirekit/fonts/
     caveat/
       Caveat-Regular.woff2
       Caveat-Bold.woff2
       LICENSE.txt   (OFL)
     patrick-hand/
       PatrickHand-Regular.woff2
       LICENSE.txt   (OFL)
   ```
3. Replace the `@import` at the top of `css/wireframe.css` with `@font-face` declarations:
   ```css
   @font-face {
     font-family: 'Caveat';
     src: url('../fonts/caveat/Caveat-Regular.woff2') format('woff2');
     font-weight: 400;
     font-display: swap;
   }
   @font-face {
     font-family: 'Caveat';
     src: url('../fonts/caveat/Caveat-Bold.woff2') format('woff2');
     font-weight: 700;
     font-display: swap;
   }
   @font-face {
     font-family: 'Patrick Hand';
     src: url('../fonts/patrick-hand/PatrickHand-Regular.woff2') format('woff2');
     font-weight: 400;
     font-display: swap;
   }
   ```

### Total size estimate

~30–40 KB across all three font files (woff2). Negligible.

## Why these fonts

- **Caveat** — flowing, hand-written feel; readable at large sizes; warm. Avoids Comic-Sans baggage while keeping the "sketch" signal.
- **Patrick Hand** — cleaner monoline handwriting; better legibility at small sizes (form labels, annotations, secondary text).

Together they cover the "Balsamiq-sketch" aesthetic: intentional, draft-looking, human.

## Fallback chain

If webfonts fail to load:

```css
--wk-font-primary: 'Caveat', 'Patrick Hand', cursive;
--wk-font-secondary: 'Patrick Hand', 'Caveat', cursive;
```

`cursive` is a generic family supported by all browsers; typically resolves to Comic Sans (macOS/Windows) or a system handwriting font. Not ideal but preserves the intent of "this is not final".
