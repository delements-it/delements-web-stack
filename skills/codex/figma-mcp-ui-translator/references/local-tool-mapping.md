# Local Tool Mapping

This reference is for the current local Figma MCP server profile that exposes a limited but useful toolset.

## Available design primitives

- `create-frame`: use for all real containers
- `create-rectangle`: use sparingly for simple blocks
- `create-text`: all copy and labels
- `set-fill-color`: primary styling tool
- `set-stroke-color`: useful for outlines and subtle borders
- `set-corner-radius`: critical for identity and realism
- `move-node`: cleanup and nudging
- `resize-node`: refinement and consistency
- `set-layout`: use only after validating that the server handles the desired layout mode reliably
- `delete-node`: clean failed experiments fast

## Missing or likely missing

Assume these may be unavailable unless verified in `tools/list`:

- gradients
- blur
- shadow/effects
- image fills from URLs
- advanced typography controls
- component authoring
- variable systems
- constraints beyond basic geometry

## Realism strategy under limited tools

When advanced visual effects are unavailable:

- use layered dark surfaces instead of shadow-heavy depth
- use contrast and radius to imply sophistication
- use large blocks of clean spacing to sell intent
- use one bright accent color only where interaction matters
- use repeated cards and aligned controls to create product realism

## Recommended execution pattern

1. Create root frame
2. Create major frames
3. Color major frames
4. Add text hierarchy
5. Add repeated card structures
6. Add CTA/control shells
7. Run cleanup with move/resize/color/radius passes

## MCP phrase conversion

Translate:

- `hero section` -> `large top frame with headline, body copy, and CTA child frames`
- `card rail` -> `repeated child frames with consistent dimensions and offsets`
- `pill button` -> `frame with high corner radius and centered text`
- `search bar` -> `wide frame with high corner radius and muted placeholder text`
- `sidebar` -> `left column frame with stacked child frames and labels`

