# Brief To MCP Mapping

Use this file when converting natural-language design requests into scene plans for local Figma MCP execution.

## Human phrase -> design decision

- `premium` -> fewer colors, larger type contrast, cleaner spacing, restrained accent use
- `immersive` -> darker backgrounds, edge-to-edge surfaces, heavier contrast, dense content
- `playful` -> brighter accents, softer corners, more size contrast
- `editorial` -> stronger text hierarchy, larger headlines, more whitespace
- `dashboard` -> shell layout, utility regions, repeated data cards
- `landing page` -> hero-first, stacked sections, stronger CTA path
- `mobile app` -> narrow frame, stronger vertical rhythm, bottom navigation

## Human phrase -> geometry

- `modern SaaS` -> 12-24px radius, balanced spacing, neutral surfaces
- `Spotify-like` -> near-black surfaces, pill buttons, compact text, sparse accent green
- `Apple-like` -> larger whitespace, restrained borders, low-noise hierarchy
- `Notion-like` -> soft neutral surfaces, subtle structure, editorial text rhythm

## Human phrase -> build order

- `dashboard` -> shell -> nav -> hero -> cards -> utility strips
- `settings page` -> shell -> header -> grouped panels -> fields -> actions
- `catalog/listing` -> header -> filters -> item grid/list -> pagination/cta
- `player/media app` -> shell -> nav -> content -> persistent control bar

## Human phrase -> density

- `clean` -> medium spacing, fewer simultaneous elements
- `dense` -> smaller gaps, more cards, tighter typography
- `luxury` -> larger surfaces, fewer items, stronger whitespace
- `power-user` -> denser controls, visible utility actions

## Human phrase -> text style

- `systematic` -> uppercase labels, compact type, stronger secondary metadata
- `friendly` -> sentence case, softer hierarchy, less rigid labels
- `technical` -> stronger section labels, explicit grouping, high scannability

