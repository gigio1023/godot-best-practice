# Source Notes

Research performed on 2026-04-27.

## MCP.Directory godot skill

Source: https://mcp.directory/skills/godot

Observed focus:

- general Godot Engine project guidance
- `.gd`, `.tscn`, and `.tres` file-format awareness
- component-based and signal-driven architecture
- validation scripts for `.tres` and `.tscn`
- templates for components, attributes, interactions, items, and spell resources

Useful lessons to copy:

- make the description strongly trigger on all Godot tasks
- explicitly warn that `.tscn` and `.tres` are serialized formats, not GDScript
- ship validators and templates instead of relying only on prose
- use progressive disclosure for file formats and architecture patterns

What this repo changes:

- includes Godot-specific file, CLI, and validation guidance
- adds semantic layout guidance
- makes MCP optional instead of central
- adds validation gates for runtime, visual, and export-sensitive changes

## fernforestgames/agent-skill-godot

Source: https://github.com/fernforestgames/agent-skill-godot

Observed focus:

- compact `SKILL.md`
- mandatory trigger for GDScript and Godot resource work
- requires `godot-docs` and `godot-editor` MCP servers
- includes `scripts/check_syntax.sh`
- workflow: read source, lookup docs, write code, import, syntax check, test
- testing guidance uses GUT if already installed

Useful lessons to copy:

- always run `godot --headless --import` after adding files
- include a syntax checking script
- do not install GUT automatically
- keep GDScript style rules explicit

What this repo changes:

- does not require MCP servers
- prefers Godot 4.6 current docs over 4.5-specific wording
- expands beyond GDScript into 3D scene/layout generation
- keeps planning docs limited to reusable skill design and research notes

## Official Godot docs used

- Godot 4.6.2 release: https://godotengine.org/article/maintenance-release-godot-4-6-2/
- Renderers: https://docs.godotengine.org/en/4.6/tutorials/rendering/renderers.html
- Importing 3D scenes: https://docs.godotengine.org/en/4.6/tutorials/assets_pipeline/importing_3d_scenes/index.html
- Command line tutorial: https://docs.godotengine.org/en/latest/tutorials/editor/command_line_tutorial.html
- TSCN format: https://docs.godotengine.org/en/4.6/engine_details/file_formats/tscn.html
- PackedScene: https://docs.godotengine.org/en/4.6/classes/class_packedscene.html
- ResourceSaver: https://docs.godotengine.org/en/4.6/classes/class_resourcesaver.html
- EditorScript: https://docs.godotengine.org/en/4.6/classes/class_editorscript.html
- C#/.NET: https://docs.godotengine.org/en/4.6/tutorials/scripting/c_sharp/index.html
