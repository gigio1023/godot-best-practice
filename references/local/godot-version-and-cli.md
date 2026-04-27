# Godot Version And CLI

Use this reference when starting Godot work, checking current version assumptions, or validating a project from the command line.

## Version Baseline

Last verified on 2026-04-27: Godot 4.6.2 was the current stable release checked while writing this skill, and the official stable docs branch pointed at Godot 4.6.

Primary official sources:

- https://godotengine.org/article/maintenance-release-godot-4-6-2/
- https://docs.godotengine.org/en/stable/
- https://github.com/godotengine/godot-docs

Do not treat this file as proof of the current latest release. When the user asks for "latest", "current", or version-sensitive behavior, verify again before answering.

## Detect Project Version

Look for:

- `project.godot`
- `.godot/` metadata, if present
- `export_presets.cfg`
- C# project files such as `.csproj` and `*.sln`
- addon metadata under `addons/`

Useful commands:

```bash
godot --version
godot --headless --version
rg -n "config/features|config_version|application/config/name" project.godot
```

If `godot` is not on `PATH`, try common environment variables or ask for the binary path:

```bash
${GODOT_PATH:-godot} --version
```

## CLI Check Commands

Run from the Godot project root unless paths are absolute.

Import assets:

```bash
godot --headless --import
```

Check one script:

```bash
godot --headless --script res://path/to/script.gd --check-only
```

Run a script:

```bash
godot --headless --path . --script res://tools/smoke_test.gd
```

Export with a preset:

```bash
godot --headless --export-release "Preset Name" build/game.zip
```

Use `--quit-after` for short runtime smoke checks when supported by the local Godot version.

## Renderer Defaults

Choose renderer by target, not habit:

- Desktop 3D: Forward+
- Mobile and XR-oriented targets: Mobile
- Web, older hardware, or broad compatibility: Compatibility

Renderer changes can affect lighting, shaders, materials, performance, and post-processing. Confirm target platforms before changing renderer settings.

## Physics Defaults

Godot 4.6 uses Jolt Physics by default for new 3D projects. Existing projects may still depend on older behavior or project settings. Check before changing physics settings.

## Language Defaults

Default to GDScript for new agent-written code unless:

- the project already uses C#
- the user explicitly requests C#
- the feature needs a native extension or existing C#/.NET integration

C# requires the .NET build of Godot. Web export support and platform behavior can differ from GDScript projects; verify against current official docs before promising support.
