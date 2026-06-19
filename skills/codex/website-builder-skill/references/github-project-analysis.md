# GitHub Project Analysis

Research date: 2026-05-23

Selection criteria:

- high stars or official/well-known publisher
- active repository, not archived
- useful for local program execution or durable website-building rules
- compatible with Webflow/custom-code workflow

## Keep: Core Local Program Integrations

| Project | Stars checked | Publisher | Keep because | Local role |
| --- | ---: | --- | --- | --- |
| `microsoft/playwright` | ~89k | Microsoft | Reliable browser automation across Chromium/WebKit/Firefox | responsive, visual, click/tap, screenshot tests |
| `GoogleChrome/lighthouse` | ~30k | Google Chrome | Standard web audit engine | performance, SEO, accessibility, best practices |
| `dequelabs/axe-core` | ~7.2k | Deque | Strong accessibility engine | accessibility checks beyond simple DOM rules |
| `GoogleChrome/web-vitals` | ~8.5k | Google Chrome | Core Web Vitals library | runtime metrics and page experience |
| `lovell/sharp` | ~32k | libvips/Sharp ecosystem | Fast image processing | resize, convert WebP/AVIF, asset pipeline |
| `sitespeedio/sitespeed.io` | ~5k | sitespeed.io | Deep performance monitoring | advanced performance audit, optional |
| `harlan-zw/unlighthouse` | ~4.6k | Unlighthouse | Lighthouse at site/crawl scale | whole-site Lighthouse |
| `SchemaStore/schemastore` | ~3.8k | SchemaStore | Large collection of JSON schemas | validate configs and generated JSON |
| `google/schema-dts` | ~1.2k | Google | TypeScript types for Schema.org | JSON-LD/schema validation and generation |

## Keep As UI/UX Knowledge Sources

| Project | Stars checked | Publisher | Use as |
| --- | ---: | --- | --- |
| `twbs/bootstrap` | ~174k | Bootstrap | mobile-first responsive patterns |
| `tailwindlabs/tailwindcss` | ~95k | Tailwind Labs | breakpoint and utility rule reference |
| `shadcn-ui/ui` | ~115k | shadcn ecosystem | accessible component composition patterns |
| `mui/material-ui` | ~98k | MUI | Material Design UX/reference |
| `ant-design/ant-design` | ~98k | Ant Design | enterprise UI/reference |
| `radix-ui/primitives` | ~19k | WorkOS/Radix | accessible primitive behavior |
| `storybookjs/storybook` | ~90k | Storybook | component states and visual QA ideas |
| `motiondivision/motion` | ~32k | Motion | animation and reduced-motion references |
| `lucide-icons/lucide` | ~23k | Lucide | icon consistency reference |

Do not import these UI systems into an existing Webflow site unless the site already depends on them. Use them to build rules and checks.

## Keep: Webflow/Spline Specific

| Project | Stars checked | Publisher | Keep because |
| --- | ---: | --- | --- |
| `webflow/js-webflow-api` | ~343 | Webflow | Official JS/TS SDK for Webflow Data API |
| `webflow/mcp-server` | ~130 | Webflow | Official Webflow MCP server |
| `webflow/webflow-skills` | ~73 | Webflow | Official Webflow Agent Skills |
| `finsweet/attributes` | ~63 | Finsweet | Strong Webflow-native attribute behaviors |
| `splinetool/react-spline` | ~1.4k | Spline | Official Spline React wrapper/reference |

Stars are lower for Webflow-specific repos, but publisher relevance is more important here.

## Optional

| Project | Stars checked | Reason |
| --- | ---: | --- |
| `QwikDev/partytown` | ~13.7k | Useful when third-party scripts hurt performance; can be complex in Webflow |
| `AnswerDotAI/llms-txt` | ~2.4k | Useful for LLM-facing docs, but not a Google Search requirement |
| `garmeeh/next-seo` | ~8.5k | Good SEO reference for Next.js projects, less direct for Webflow |
| `iamvishnusankar/next-sitemap` | ~3.7k | Good sitemap reference for Next.js, less direct for Webflow |
| `unjs/unhead` | ~1.3k | Strong head/meta reference if building a framework app |

## Reject Or Defer

- Generic UI framework installation into Webflow: risks CSS collision and bloat.
- Unofficial Spline MCP repos: interesting, but not enough trust for production without review.
- Old/archived Nuxt SEO repos: not useful for this Webflow local program.
- Any "AI SEO magic" package claiming special Google AI ranking markup: conflicts with Google guidance.

## Optimized Stack

Recommended local stack:

```text
Playwright + Lighthouse + axe-core + web-vitals
Sharp for assets
SchemaStore + schema-dts for JSON/schema validation
Webflow JS SDK + Webflow MCP for Webflow operations
Finsweet Attributes and Spline docs as Webflow-specific rule sources
```

## Asset Pipeline Research Addendum

| Project | Stars checked | Publisher | Fit |
| --- | ---: | --- | --- |
| `lovell/sharp` | ~32k | Sharp/libvips ecosystem | Best future image resize/convert integration |
| `FFmpeg/FFmpeg` | ~60k | FFmpeg | Best future video compression/transcode backend |
| `ffmpegwasm/ffmpeg.wasm` | ~17.5k | ffmpeg.wasm | Useful for browser-based video workflows, less ideal for Node CLI on Mac |
| `imagemin/imagemin` | ~5.7k | imagemin | Useful image minification reference, less direct than Sharp |
| `nodeca/pica` | ~4.1k | nodeca | High quality browser resizing, not needed for Node CLI |
| `sindresorhus/slugify` | ~2.7k | Sindre Sorhus | Good reference for slug rules |
| `sindresorhus/filenamify` | ~516 | Sindre Sorhus | Good reference for safe filename rules |
| `parshap/node-sanitize-filename` | ~368 | parshap | Small safe filename reference |

Current package keeps asset preparation dependency-free using Node `crypto`, filesystem APIs, and internal slug/sanitize logic. Add Sharp/FFmpeg later only when real optimization/transcoding is needed.
