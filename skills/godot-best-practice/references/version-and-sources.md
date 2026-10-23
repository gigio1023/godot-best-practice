# Version and Official Sources

## Project version

Use the project's pinned version even when a newer stable release exists. Read the version-like feature in `application/config/features`, CI and editor pins, `.csproj`/`.sln`, addon and GDExtension constraints, and the intended editor's `--version`. Godot's project manager uses the first version-like feature to display the project version; it does not establish a patch or custom build. `config_version=5` identifies the Godot 4 settings format.

Resolve disagreements before importing. Opening a project with a guessed newer editor can rewrite imports, metadata, and serialized files. Confirm unfamiliar flags with that binary's `--help`, since unknown arguments can be ignored.

## Evidence selection

Use the target's repository conventions and matching official docs first, the matching engine tag for implementation details, and release notes plus migration guides for upgrades. Prefer versioned URLs such as `/en/4.7/`. Resolve `stable` before recording it as evidence; `latest` and `master` describe development material.

Search for the relevant guide, class, and implementation rather than loading whole trees. An existing official checkout can speed this up: inspect its status and exact commit before using it. Honor configured `GODOT_SOURCE` and `GODOT_DOCS` paths. Do not fetch, switch, or clean a user's checkout merely to read sources; use a pinned web source when its ref does not match.

## Verified baseline

Checked on **2026-10-23** against the [official download](https://godotengine.org/download/macos/), [archive](https://godotengine.org/download/archive/), and [GitHub latest-release API](https://api.github.com/repos/godotengine/godot/releases/latest):

| Source | Verified value |
| --- | --- |
| Latest stable | [Godot 4.7.2](https://github.com/godotengine/godot/releases/tag/4.7.2-stable), released 2026-08-18 |
| Engine tag | `4.7.2-stable` at `ed1daf0bf001b61586d9930840f2f1394092c079` |
| Matching docs | [`4.7`](https://github.com/godotengine/godot-docs/tree/9adca4c1c72917bfe1b7be3108abed5ce26696a6) at `9adca4c1c72917bfe1b7be3108abed5ce26696a6` |
| Latest prerelease | [4.8-beta1](https://github.com/godotengine/godot-builds/releases/tag/4.8-beta1), published 2026-10-15 |

This snapshot does not establish what is latest on a later date. Recheck official releases when the task asks for current versions. The repository's `docs/source-provenance.md` records maintenance evidence and historical baselines; it is not needed at runtime.

### Relevant migration changes

Read the full guide for the project's source and target versions. These changes commonly affect existing assumptions:

- Godot 4.6 stopped writing deprecated TSCN `load_steps` and introduced node `unique_id` serialization. Editor saves can produce expected scene diffs.
- New 3D projects use Jolt; existing projects retain their selected physics engine.
- Godot 4.7 packed-array element assignment no longer invokes the whole property's setter.
- Overrides of methods with typed returns inherit the return type and need explicit return paths.
- Mouse and keyboard have dedicated device-ID constants; do not assume `0`.
- Newly created 4.7 projects default to `canvas_items` stretch mode and `expand` aspect. Existing project settings are not silently rewritten.

Sources: [4.6 migration](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.6.html), [4.7 migration](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html).

## Upgrade procedure

1. Confirm upgrade scope and preserve a recoverable checkout, including existing work.
2. Record source and target versions, language, addons, GDExtensions, render/physics settings, and export targets.
3. Read every intervening migration guide. Separate API changes, behavior changes, and new-project defaults.
4. Update required engine, SDK, and addon constraints. Import with the target editor and review the resulting diffs.
5. Exercise affected scripts/builds, scenes, gameplay, visuals, physics, input, and export targets. Report targets that were not exercised.

Godot 3-to-4 conversion is a separate migration path. Its converter does not establish gameplay, rendering, physics, shader, or addon equivalence.

## Source map

Paths are relative to the matching official docs or engine checkout.

| Question | Documentation | Engine implementation |
| --- | --- | --- |
| Release policy | `about/release_policy.rst` | `version.py`, `CHANGELOG.md` |
| Project version | `tutorials/editor/project_settings.rst` | `core/config/project_settings.cpp`, `editor/project_manager/project_list.cpp` |
| CLI | `tutorials/editor/command_line_tutorial.rst` | `main/main.cpp` |
| TSCN/TRES | `engine_details/file_formats/tscn.rst` | `scene/resources/resource_format_text.cpp`, `scene/resources/packed_scene.cpp` |
| GDScript | `tutorials/scripting/gdscript/` | `modules/gdscript/` |
| C#/.NET | `tutorials/scripting/c_sharp/` | `modules/mono/` |
| Imports | `tutorials/assets_pipeline/import_process.rst` | `editor/import/` |
| Export | `tutorials/export/exporting_projects.rst` | `editor/export/` |
