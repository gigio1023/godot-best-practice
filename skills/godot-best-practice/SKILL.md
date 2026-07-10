---
name: godot-best-practice
description: >
  Use when implementing, debugging, reviewing, or upgrading a Godot project, including project.godot, GDScript, Godot C#, .gd, .tscn, .tres, scenes, resources, signals, nodes, UI, physics, shaders, imports, exports, addons, or engine-version changes. Also trigger on Godot resource terms such as ExtResource, SubResource, NodePath, and res:// even when "Godot" is omitted. NOT for engine-neutral game design, unrelated C#/GLSL work, asset creation alone, or contributing to the Godot engine source itself.
---

# Godot Best Practice

Deliver a Godot-native result grounded in the project's actual engine version,
serialized-resource semantics, and the strongest evidence the requested claim
needs.

## Quick Path

1. Classify the request as answer/review/diagnosis or change/build.
2. Locate `project.godot`; inspect the project version, language stack, renderer,
   addons, export setup, nearby scenes/resources/scripts, and repository rules.
3. Read only the references needed for the affected surface. Verify exact or
   current behavior against version-matched official documentation or engine
   source instead of relying on memory.
4. Choose Godot-native ownership and data boundaries, then make the smallest
   coherent change that preserves existing conventions.
5. Validate at the layer that can actually prove the claim: parse, import,
   build, scene load, runtime behavior, visual output, or export.
6. Report the result, project/engine version evidence, files changed, checks
   actually run, and any evidence that remains blocked.

## Authority And Runtime Safety

- Keep answer, review, and diagnosis requests read-only. Do not edit, import,
  open the project in a different engine version, or run project code unless
  the request authorizes that action.
- Treat change and build requests as authority for in-scope local edits and
  existing non-destructive checks. They do not authorize installing an engine,
  addon, MCP server, export template, SDK, or test framework.
- Treat changing the project's Godot version as a migration. Require that scope
  explicitly; inspect version control state and the applicable migration guides
  before opening or importing with the target editor.
- Treat any Godot invocation as potential project-code execution. Inspect
  `@tool` scripts, editor plugins, autoloads, and GDExtensions before running an
  untrusted project. Use recovery mode only when it fits the diagnostic goal;
  it changes what the editor loads and is not proof of a normal startup.
- Do not regenerate or overwrite hand-authored scenes unless a documented source
  file or generator owns them and the request includes regeneration.

## Establish The Project Contract

- Find the project root from `project.godot`, not from the current shell
  directory alone. If several projects exist, select from task context or ask
  before editing the wrong one.
- Infer the project version from the version-like entry in
  `application/config/features`, version pins and CI, repository documentation,
  and a matching editor's `--version` output. `config_version=5` identifies the
  Godot 4 configuration format; it does not identify a Godot 4 minor release.
- Check `.csproj`/`.sln` and the `C#` feature before applying GDScript defaults to
  a .NET project. Check `addons/`, `.gdextension`, `export_presets.cfg`, input
  actions, renderer, and physics settings when they affect the task.
- Preserve public node names, scene paths, resource paths, exported properties,
  signals, groups, input actions, and serialization IDs unless the requested
  change intentionally migrates every consumer.
- Use `res://` for project resources and `user://` for persistent writable data.
  Do not treat imported resources as ordinary runtime files.

## Choose The Right Godot Surface

- Put editable composition and ownership in scenes.
- Put behavior, orchestration, and tools in scripts.
- Put reusable configuration and asset-like data in resources. Remember that a
  loaded resource is shared unless explicitly duplicated or localized.
- Connect signals at the scene that owns both sides. Use groups for broad role
  discovery, not as a hidden replacement for one required dependency.
- Use autoloads only for genuinely broad lifetime or cross-scene state. Prefer a
  regular scene-owned node or resource when its lifetime is local.
- Prefer direct `.tscn`/`.tres` edits only when the change is small, surrounding
  structure is understood, and IDs, paths, ownership, and ordering remain
  coherent. Use Godot APIs or a generator for structural or repetitive changes.
- Change source assets and committed import metadata, not `.godot/` cache or
  derived imported artifacts.

## Prove The Requested Claim

Match evidence to the surface instead of running a ritual command list:

- Script/API claim: version-matched API lookup plus targeted parse or build.
- Scene/resource claim: import and load/instantiate the affected scene or
  resource; inspect required nodes, paths, owners, and dependencies.
- Behavior claim: targeted project test or bounded scene/runtime smoke check.
- UI, animation, camera, lighting, or layout claim: runtime capture at relevant
  sizes or viewpoints in addition to non-visual checks.
- Export claim: inspect the preset, platform requirements, templates, and an
  export attempt; launch the artifact when the claim includes runtime success.
- Upgrade claim: migration guide, import with the target version, representative
  runtime/visual checks, and export checks for affected targets.

Do not call the engine's `--test` flag a project test: it runs engine C++ tests
only in builds compiled with test support. Use a GDScript or C# test framework
only when the project already declares it or the user authorizes adding it.

If a matching Godot binary or another prerequisite is unavailable, perform the
useful static checks that remain and state exactly which engine evidence did not
run. Never install a replacement or report a pass by inference.

## References

| Read | When |
| --- | --- |
| `references/version-and-sources.md` | Determining the project/current version, resolving an exact API, or planning an upgrade |
| `references/scenes-and-resources.md` | Editing or reviewing `.tscn`, `.tres`, UIDs, NodePaths, imports, or generated content |
| `references/scripting.md` | Writing or reviewing GDScript, Godot C#, signals, lifecycle code, or node references |
| `references/architecture.md` | Choosing scene, node, resource, signal, group, autoload, and ownership boundaries |
| `references/domains-and-export.md` | Working in 2D, 3D, UI, physics, navigation, rendering, shaders, assets, or export |
| `references/validation.md` | Selecting commands, runtime/visual evidence, failure handling, and completion criteria |

The bundled `scripts/check_gdscript.sh` parses project GDScript files with a
configured Godot binary. Resolve the active skill directory first and execute
the script; do not assume the skill lives inside the target project.

## Gotchas

- `config_version=5` identifies the Godot 4 settings format, not the minor
  release.
- Godot can ignore an unknown CLI flag without failing; confirm flags with the
  selected binary's `--help` and require the expected artifact or log.
- `.godot/` is generated cache, while an asset's adjacent `.import` file is
  source-controlled import metadata in normal Godot workflows.
- Engine import, script parsing, scene runs, and builds can execute project code
  or update cache state; they are not read-only review operations.
- Godot's `--test` is for engine C++ tests in a test-enabled build, not the
  project's gameplay tests.

## Stop And Report

Stop when the narrowest evidence that proves the requested outcome passes and no
material error remains. Retry only when the failure is transient or a corrected
input makes the same check meaningful.

Lead the final response with the outcome. Include the project and engine version
used or inferred, changed files, official sources consulted for version-sensitive
decisions, checks and evidence actually collected, and blocked or residual risk.
