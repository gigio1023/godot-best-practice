---
name: godot-best-practice
description: >
  Implement, debug, review, or upgrade Godot projects: GDScript, Godot C#, scenes, resources, signals, UI, physics, shaders, asset imports, Blender-to-Godot pipelines, and exports. Use for project.godot, .gd, .tscn, .tres, ExtResource, SubResource, NodePath, and res:// work even when Godot is not named. NOT for engine-neutral game design, unrelated C#/GLSL, standalone Blender asset creation, or Godot engine development.
---

# Godot Best Practice

Make the requested change against the project's actual Godot version. For a new project, use the verified current stable release unless the user chooses another target. Preserve scene ownership and asset sources, then verify the behavior or artifact the user needs.

## Workflow

1. Locate the target `project.godot` or establish the new project root requested by the user. Inspect affected scripts, scenes, resources, imports, or export presets and repository conventions.
2. Establish the engine version, language, renderer, and relevant addons or GDExtensions. Reuse reliable session evidence; recheck when the project, binary, or configuration changes.
3. Read the reference for the affected surface. Use matching official docs for exact APIs and migration behavior; check engine source when documentation leaves a consequential ambiguity.
4. Choose the source of truth and control surface. Edit code in files; use Godot for complex scene serialization and editor-owned changes when available.
5. Make the coherent change and run the checks that establish its result. Code parsing, scene loading, gameplay, appearance, and exported builds require different evidence.
6. Report the outcome, engine version, meaningful checks, and any remaining limitation. Stop when the requested result has sufficient evidence.

## Scope and execution

Follow the user's existing authorization. Answers and reviews do not imply edits. A request to reproduce or diagnose a runtime failure includes the relevant non-destructive execution; a change or build includes local edits and proportionate validation. Do not repeatedly ask for these actions or turn missing optional tooling into a blocker.

An engine migration, dependency installation, integration setup, destructive cleanup, or publication needs that scope in the request. Opening or importing with a newer editor can rewrite project files, so do not silently upgrade an existing project to the current stable release.

Godot invocations and editor reloads can execute project code. Before running an unfamiliar or untrusted project, inspect relevant `@tool` scripts, editor plugins, autoloads, GDExtensions, and build hooks. Recovery mode changes what loads and cannot establish normal startup.

## Project and ownership rules

- Identify the version from `application/config/features`, repository pins, and the intended binary's `--version`. `config_version=5` identifies the Godot 4 settings format, not its minor release.
- Detect `.csproj`/`.sln` and the `C#` feature before applying GDScript guidance. Check renderer, physics, input, and export settings when they affect the change.
- Preserve public node names, resource paths, exported properties, signals, groups, input actions, and serialization IDs, or migrate their consumers together.
- Use scenes for editable composition, scripts for behavior, and resources for reusable data. Resources are normally shared; choose private per-instance state deliberately.
- Connect signals where both endpoints are owned. Use groups for many objects sharing a role and autoloads for cross-scene lifetime.
- Use `res://` for project resources and `user://` for writable persistent data.
- Change authored assets and import configuration. `.godot/` is generated cache; adjacent `.import` files and applicable `.uid` sidecars belong with their sources.
- Change a generator or its inputs before regenerating its output. Keep hand-authored extensions outside imported or generated content that will be replaced.

## Tools and evidence

Use files and the Godot CLI for code, bulk edits, imports, CI, and export. A connected editor is useful for scene/inspector changes, interaction, diagnostics, and screenshots. [Live editor control](references/live-editor-control.md) describes the optional Godot AI adapter; match its project and readiness before writes. Use the available route without installing or configuring another integration implicitly.

Read [validation](references/validation.md) before choosing engine commands. Confirm unfamiliar flags with the selected binary's `--help`: Godot can ignore unknown flags. Engine `--test` runs engine C++ tests, not the project's tests.

If a prerequisite is missing, finish useful work and available checks, then name the specific unverified claim. Static inspection cannot prove runtime behavior, a successful launch cannot prove visual correctness, and editor success cannot prove an export works.

## References

| Task | Reference |
| --- | --- |
| Version detection, exact APIs, upgrades | [Version and sources](references/version-and-sources.md) |
| `.tscn`, `.tres`, UIDs, NodePaths, imports, resource sharing | [Scenes and resources](references/scenes-and-resources.md) |
| GDScript, C#, lifecycle, dependencies, signals | [Scripting](references/scripting.md) |
| Scene boundaries, ownership, data, global state | [Architecture](references/architecture.md) |
| 2D/3D, UI, physics, navigation, rendering, export | [Domains and export](references/domains-and-export.md) |
| Blender assets, glTF, reimport, materials, rigging, animation | [Blender pipeline](references/blender-pipeline.md) |
| Parse/build, load, runtime, visual, export checks | [Validation](references/validation.md) |
| Connected editor sessions and optional Godot AI tools | [Live editor control](references/live-editor-control.md) |

The bundled `scripts/check_gdscript.sh` checks GDScript with a configured Godot binary. Resolve it from this skill's installed directory, not the target project's working directory.
