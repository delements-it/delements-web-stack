# Webflow And Spline Guardrails

## Webflow API/MCP

- Use Webflow Data API or SDK for CMS, page metadata, scripts, and publish operations.
- Use Webflow MCP or Designer tools for native canvas edits.
- Always prefer dry-run and staging before production.
- Record previous custom-code state before mutation.
- Keep class naming consistent with existing Webflow project.
- Use publish only after approval.

## CMS

- Validate required fields before import.
- Keep slug uniqueness.
- Treat draft/published state explicitly.
- Validate references/options before create/update.
- Store import source and timestamp.

## Finsweet Attributes

- Prefer Finsweet Attributes for Webflow-native filtering, CMS list behavior, and common interaction patterns.
- Do not duplicate Finsweet behavior with custom scripts unless needed.
- Audit attribute names and version compatibility.

## Spline

Detect:

- `<spline-viewer>`
- Spline iframe URLs
- `@splinetool/runtime`
- `@splinetool/react-spline`
- large canvas elements

Guardrails:

- lazy-load below-the-fold scenes
- set stable aspect ratio
- provide static fallback/poster
- mobile max height should not cover all content
- check nav/CTA clickability over canvas
- check reduced-motion/static alternative
- avoid multiple heavy scenes on one mobile viewport
