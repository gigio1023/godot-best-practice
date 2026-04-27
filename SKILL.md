---
name: godot-best-practice
description: >
  Use this skill for any Godot 4.x project work: GDScript, C#, scenes, resources, nodes, signals, 2D, 3D, UI, physics, animation, navigation, shaders, import/export, plugins, testing, version upgrades, and agent-authored workflows. Trigger for "Godot", "GDScript", "tscn", "tres", "Godot best practice", "Godot 문법", "Godot 활용법", "Godot 패턴", "Godot 씬", "Godot 2D/3D/UI/physics/export", and Korean requests about Godot implementation or architecture. Prefer this skill before editing Godot files or giving Godot guidance.
version: 2.0.0
tags:
  - godot
  - gdscript
  - game-dev
  - best-practices
  - agent-workflow
---

# Godot Best Practice

## Quick Start

Use this skill whenever the user asks for Godot implementation, debugging, architecture, version upgrade, import/export, or documentation help.

Default agent workflow:

1. Read `project.godot` first, then nearby `.gd`, `.tscn`, `.tres`, import, and addon files.
2. Identify the Godot version and language stack before giving version-sensitive advice.
3. Prefer Godot-native architecture: scenes as composition, scripts as behavior, resources as data, signals/groups for loose coupling, and project settings/input maps for shared configuration.
4. For details beyond this skill, read the official docs snapshot in `~/git/godot-docs` when present, or fetch from official Godot docs/GitHub using `references/local/official-docs-index.md`.
5. After edits, run the narrowest meaningful Godot checks: import, syntax, scene load, targeted smoke tests, and visual evidence when layout matters.

## Reference Files

| File | Read when | Contents |
|---|---|---|
| `references/local/official-docs-index.md` | Need exact or current Godot docs | Local docs path, GitHub/docs URL patterns, topic-to-file index, refresh rules |
| `references/local/godot-version-and-cli.md` | Starting work, checking version, running Godot CLI checks | Version baseline, CLI commands, import/export/test commands |
| `references/local/gdscript-and-csharp.md` | Writing scripts or explaining language syntax | GDScript defaults, static typing, exports, signals, C# cautions |
| `references/local/godot-architecture-patterns.md` | Designing project structure or gameplay systems | Nodes/scenes/resources/autoloads/signals/groups/data patterns |
| `references/local/scene-resource-workflow.md` | Editing `.tscn`, `.tres`, generated scenes, or imports | Scene-as-code, safe edit boundaries, resource serialization rules |
| `references/local/domain-guides.md` | Working in 2D, 3D, UI, physics, navigation, rendering, shaders, export | Practical per-domain defaults and official doc pointers |
| `references/local/completion-evidence.md` | Before claiming Godot work is complete | Import, syntax, scene-load, smoke, visual, export, and upgrade evidence |
| `references/local/mcp-integration.md` | User asks about editor automation or Godot MCP | MCP role, file-first source of truth, security checks |
| `references/local/3d-generation-patterns.md` | Building generated 3D layouts | Semantic layout data, anchors, routes, inspection cameras |
| `references/research/source-notes.md` | Comparing this skill to public Godot skills | Source notes and attribution |

## Detailed Workflow

### 1. Orient

- Locate the Godot project root by finding `project.godot`.
- Check existing conventions before adding new ones: folder layout, script style, typed/untyped GDScript, autoloads, addons, tests, and export presets.
- Read official docs for any API, setting, file format, or version behavior you are not certain about.
- If local docs exist at `~/git/godot-docs`, prefer them for fast broad search; if freshness matters, verify with official web docs or the `godotengine/godot-docs` repo.

### 2. Design With Godot Concepts

- Use scenes for reusable composition and boundaries.
- Use scripts for behavior; avoid putting complex logic into serialized scene/resource files.
- Use custom `Resource` types for reusable game data.
- Use signals for event flow across ownership boundaries.
- Use groups for broad discovery and role tags.
- Use autoloads only for truly global services or persistent session state.
- Keep generated content reproducible from source data or generator scripts.

### 3. Edit Conservatively

- Prefer editing `.gd`, JSON/data files, and small `.tres` resources directly.
- Treat large `.tscn` files, imported resources, `.godot/`, and binary assets as higher-risk.
- For non-trivial scene generation, write a generator script and check the generated result.
- Preserve node names, exported properties, input actions, and resource paths unless the user asked for a breaking change.

### 4. Verify

Minimum useful checks depend on the change:

- GDScript: `godot --headless --script res://path/to/script.gd --check-only` or the bundled syntax script.
- Scenes/resources: `godot --headless --import`, then load or instantiate the changed scene.
- Gameplay behavior: targeted smoke script, unit/integration test if the project has a test framework, or a short run.
- Visual/layout changes: screenshot, recorded run, or explicit viewport evidence.
- Export changes: dry-run or actual export with the relevant preset when feasible.

## Gotchas

- Do not answer from memory when the user asks for latest Godot behavior. Verify against official docs or the local `godot-docs` snapshot plus web.
- Do not assume Godot 3.x guidance applies to Godot 4.x. APIs, physics, and node behavior often changed.
- Do not use GDScript syntax inside `.tscn` or `.tres`; those files use serialized resource syntax.
- Do not hand-place complex worlds from raw coordinates alone. Use named anchors, source data, and inspection cameras.
- Do not install addons, MCP servers, exporters, or test frameworks without user approval unless the project already vendors them.
- Do not default every project to autoload singletons. Prefer regular scene dependencies unless global lifetime is required.
- Do not claim a scene, UI, collision setup, or export works from text inspection alone when a runtime or visual check is possible.
- Do not overwrite user-authored scene edits with regenerated output unless the source data/generator owns that scene.

## Output Standard

When finishing Godot work, report:

- Godot version used or whether it was unavailable
- files changed
- official docs consulted when relevant
- commands/checks run
- visual/export evidence collected, if any
- blocked checks and why
