---
name: figma-webar-converter
description: Convert the local ROOT ROTATION Figma prototype wire/layer project into WebAR website outputs using the Figma AR Project Wire Pipeline. Use when the user asks to convert Figma frames, Figma prototype wires, MyWebAR-like layers/actions, or a Figma project into a local AR/WebXR website, especially with requirements to start from Frame 1, load the full project, and avoid auto rotation.
---

# Figma WebAR Converter

Use the local program:

```bash
cd "/Users/delements/Desktop/AI tool system/Figma AR Project 3D Demo"
python3 figma_wire_layer_pipeline.py build
python3 figma_wire_layer_pipeline.py serve --port 4182
```

Open the generated local site:

```text
http://127.0.0.1:4182/figma-webar-index.html
```

Core outputs:

- `output/figma-webxr-ar.html`: WebXR camera AR website.
- `output/figma-ar-experience.html`: desktop Three.js AR inspection preview.
- `output/figma-final-prototype.html`: 2D clickable prototype.
- `output/figma-wire-layers.md`: Markdown audit with embedded JSON.
- `output/figma-wire-layer-export.json`: normalized source of truth.

Rules for this project:

- Start from Frame 1 when possible: prefer node `1908:485`, then a frame named `FRAME 1`, then the first real screenshot frame.
- Load the full project graph, not only one frame.
- Do not add auto rotation to AR scenes.
- Do not add auto navigation unless the user explicitly asks for timed playback.
- Keep generated assets local under the project `output/` folder.
- If live Figma extraction is required, use `FIGMA_ACCESS_TOKEN` with the program's `fetch` command.

Installed AR research/runtime references live here:

```text
/Users/delements/Desktop/AI tool system/ar-tools
```

Prefer WebXR/Three.js for the primary output. Use AR.js or MindAR only when the user specifically asks for marker/image-tracking workflows.
