# README figure

`blender-godot-workflow.svg` is editable semantic SVG for the
[`technical-figure`](https://github.com/gigio1023/gigio-figures) renderer.
`blender-godot-workflow.spec.json` records the required nodes, edges, and claim.
The README selects the light or dark PNG through a `<picture>` element.

## Figure plan

- One figure explains the import alternatives and the game-owned scene boundary.
- Flow runs top to bottom. The upper branches select one route; the lower
  branches supply the scene to relevant verification steps.
- Blue means game-owned composition. Neutral lines carry artifact flow.
- Version details and import options stay in the linked pipeline reference.

## Rendering

From an installed `technical-figure` skill directory, use the absolute path to
the repository's source and spec:

```bash
bash scripts/setup.sh --check
node scripts/render.mjs /path/to/blender-godot-workflow.svg \
  --spec /path/to/blender-godot-workflow.spec.json --no-portable
```

The delivery width is 704 CSS pixels. The source is 720 × 640 units, and both
PNGs include their theme background. The lint report covers both themes. Open
both PNGs after each change and compare every node and edge with the spec.
