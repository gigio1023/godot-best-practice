# Godot Skill Case Studies

## Sources

- MCP.Directory Godot skill: https://mcp.directory/skills/godot
- bfollington source repo: https://github.com/bfollington/terma
- Fern Forest Games Godot skill: https://github.com/fernforestgames/agent-skill-godot
- Godot 4.6 documentation: https://docs.godotengine.org/en/4.6/

## Findings

The public Godot skill examples agree on one important point: agents need Godot-specific file-format and CLI guidance before editing `.gd`, `.tscn`, and `.tres`.

The MCP.Directory skill is broad and reference-heavy. It emphasizes file format pitfalls, architecture patterns, templates, and validators.

The Fern Forest skill is lean and stricter. It makes Godot work mandatory for all `.gd`, `.tscn`, and `.tres` edits, and it runs `godot --headless --import` plus syntax checks.

## What This Repo Copies Conceptually

- strong trigger wording
- explicit `.tscn`/`.tres` gotchas
- Godot CLI check scripts
- progressive disclosure through reference files
- no automatic installation of test frameworks

## What This Repo Changes

- no mandatory dependency on Godot MCP servers
- focus on Godot 4.x and reusable project-neutral guidance
- scene-as-code and semantic layout as optional workflows
- completion evidence includes screenshots and runtime evidence
- Godot MCP is optional helper tooling, not the authoring source of truth

## License Constraint

Do not vendor the MCP.Directory/bfollington skill content unless its license obligations are reviewed. This repo should keep original local guidance and cite research sources instead.
