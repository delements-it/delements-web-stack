# UI, UX, Responsive, Mobile Rules

## Required Checks

- viewport meta exists and uses `width=device-width`
- no horizontal overflow at 360, 390, 768, 1024, and 1440 widths
- key CTA is visible above fold or after clear scroll cue
- tap targets are at least 44px where practical
- mobile nav opens/closes predictably
- sticky header does not hide anchors/content
- dropdowns/modals do not trap scroll incorrectly
- keyboard focus is visible
- text does not overflow cards/buttons
- media has stable aspect ratio and no layout shift
- animations have `prefers-reduced-motion` fallback
- forms have labels, errors, and mobile-friendly inputs

## Webflow-Specific Checks

- `.w-nav` mobile menu: overlay scroll, close on link, Escape behavior
- `.w-tabs`: non-empty labels, active state, keyboard/touch behavior
- `.w-slider`: stable slide height, accessible arrows/dots, swipe behavior
- `.w-dropdown`: touch open/close behavior and scroll containment
- `data-w-id`: interaction audit and reduced-motion fallback

## Local Decision

Local program can flag and generate guardrails. It should not rewrite complex Webflow Designer structure without MCP or human approval.
