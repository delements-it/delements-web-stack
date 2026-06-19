---
name: figma-mcp-ui-translator
description: Use when building UI through a local Figma MCP server and you need to translate human design language into concrete MCP-ready actions, scene structure, node plans, and realistic Figma execution steps. Trigger for requests about converting briefs into Figma MCP commands, building layouts on the open Figma canvas, or improving fidelity within a limited local Figma MCP toolset.
---

# Figma MCP UI Translator

Use this skill when the user wants Codex to build or refine UI directly on an open Figma canvas through a local MCP server, especially when the source input is a human-facing design brief rather than low-level node instructions.

This skill assumes the local Figma MCP bridge is already running and the Figma plugin is connected.

## Goal

Convert:

- human brief
- visual direction
- product requirements
- copied UI references

into:

- scene breakdown
- frame hierarchy
- token decisions
- MCP-safe creation order
- follow-up polish passes

## Default assumptions

- Local MCP server is available at `http://127.0.0.1:38450/mcp`
- The connected toolset is limited and may only support:
  - `create-frame`
  - `create-rectangle`
  - `create-text`
  - `get-selection`
  - `get-node-info`
  - `move-node`
  - `resize-node`
  - `set-fill-color`
  - `set-stroke-color`
  - `set-corner-radius`
  - `set-layout`
  - `delete-node`
- The plugin may behave more reliably when containers are created as `frame` nodes instead of `rectangle` nodes.
- High-fidelity results come from disciplined composition, not from a single giant prompt.

## Working mode

Always work in 5 passes:

1. Decode the brief
2. Reduce it into tokens and structure
3. Build macro layout first
4. Add content and controls
5. Polish spacing, radius, contrast, and alignment

Do not jump straight from prose to dozens of arbitrary node calls.

## Translation model

Map the user's language into these buckets before making MCP actions:

### 1. Product intent

Identify:

- page type
- primary goal
- density level
- emotional tone

Examples:

- "Spotify-like immersive dashboard" -> dark app shell, dense content grid, strong content-first hierarchy
- "premium finance landing page" -> structured hero, trust blocks, calm spacing, controlled emphasis

### 2. Design tokens

Extract:

- background colors
- surface colors
- text hierarchy colors
- accent color
- corner radius scale
- spacing rhythm
- type scale

If the brief is vague, infer a compact token set first and keep it consistent.

### 3. Scene structure

Rewrite the brief into a hierarchy:

- root frame
- major regions
- region children
- interactive controls
- repeating cards

Example:

- root app frame
- sidebar
- main content surface
- hero banner
- content rail
- bottom player bar

### 4. MCP action plan

Before creating nodes, convert the scene into a safe execution order:

1. root frame
2. large containers
3. sub-containers
4. text blocks
5. controls
6. polish

Never start with tiny details.

## Fidelity rules

To make the result feel real despite a limited toolset:

- Prefer `frame` for all containers that may receive children
- Use a small number of consistent radii
- Use consistent x/y grids rather than ad hoc placement
- Build visual hierarchy with scale, weight, and contrast
- Keep copy concise unless the user explicitly wants content-rich screens
- Use accent color sparingly and functionally
- Fake image areas with colored blocks when image tools or assets are unavailable
- Build the “shape” of realism first: shell, spacing, alignment, contrast, density

## What not to do

- Do not try to imitate every visual effect from a reference if the MCP toolset lacks gradients, blur, image fills, or effects
- Do not create hundreds of unstructured nodes in one pass
- Do not mix incompatible radius systems
- Do not overuse bright accent colors
- Do not treat rectangles as reliable parent containers unless you've confirmed they accept children cleanly

## MCP-oriented execution heuristics

### Container rule

Use `create-frame` for:

- app shell
- panels
- cards
- hero blocks
- button shells
- input shells

Use `create-rectangle` only for simple decorative or inner blocks when needed.

### Text rule

Create text only after its container exists.

For each text node define:

- position
- content
- font size
- font weight
- font color

Avoid placing text before the macro layout is stable.

### Layout rule

When a region is visually repetitive:

- first place 1 correct exemplar
- then repeat with consistent offsets

Do not improvise spacing card by card.

### Polish rule

After the first complete build, run a second pass for:

- alignment cleanup
- corner-radius normalization
- color normalization
- spacing consistency
- text hierarchy cleanup

## Response format to use internally

When preparing work from a human brief, think in this exact sequence:

1. `Design intent`
2. `Token set`
3. `Frame map`
4. `Build order`
5. `MCP actions`
6. `Polish pass`

Keep this compact. Do not dump long theory back to the user unless asked.

## Prompt compression pattern

Convert vague requests into this compact internal form:

`Build a [page type] with [tone]. Use [background], [surface], [accent], [radius style], [spacing density]. Regions: [list]. Primary CTA: [cta]. Content pattern: [cards/list/hero/sidebar/etc].`

Example:

`Build a music dashboard with immersive dark tone. Use #121212 background, #181818 surfaces, #1ED760 accent, full-pill buttons, dense 8px rhythm. Regions: sidebar, top search/filter bar, hero panel, 4-card content rail, bottom player bar.`

## Local MCP testing flow

Before a large build:

1. Confirm session is alive
2. Run `tools/list`
3. Create a throwaway frame
4. Confirm color updates work
5. Confirm nested frame creation works
6. Only then build the real screen

If nested children fail inside a node type, switch to `frame` containers.

## Recommended user-facing operating pattern

When the user asks to build a screen:

1. Summarize the intended UI in one short paragraph
2. State the structure you will build
3. Build the first complete version directly in Figma
4. Ask whether to:
   - increase fidelity
   - adjust content
   - convert to reusable system blocks

## When to stop and ask

Ask the user only if one of these is true:

- the page type is unclear
- the target platform is unclear
- the user wants a specific existing brand copied closely
- the user expects images/assets that are not available
- the user wants editable production-grade components beyond the current toolset

Otherwise, make reasonable design assumptions and build.

## Reference files

- For brief-to-node mapping patterns, read `references/brief-to-mcp.md`
- For current local-tool translation rules, read `references/local-tool-mapping.md`
