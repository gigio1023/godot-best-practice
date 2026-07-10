# Source Provenance

This document records the official Godot material used for the 2026-07-10
rewrite. It is maintenance evidence, not a runtime dependency and not a promise
that these refs remain the latest release.

## Frozen official checkouts

| Repository | Ref | Commit | Local authoring checkout |
| --- | --- | --- | --- |
| `godotengine/godot` | `4.7-stable` | `5b4e0cb0fd279832bbdd69fed5354d4e5ad26f88` | `~/git/godot-engine` |
| `godotengine/godot-docs` | `4.7` | `0585d03bea24497cf91f0969c81a187c892371c4` | `~/git/godot-docs` |

Both were content-complete shallow checkouts, clean, and equal to their remote
refs during the rewrite. `version.py` identifies the engine as 4.7.0 stable;
the matching release was published on 2026-06-18.

## Engine implementation inspected

| Concern | Files |
| --- | --- |
| Version identity | `version.py`, `CHANGELOG.md` |
| Project settings and feature versions | `core/config/project_settings.cpp`, `editor/project_manager/project_list.cpp` |
| CLI parsing and exit behavior | `main/main.cpp` |
| TSCN/TRES loading and saving | `scene/resources/resource_format_text.cpp`, `scene/resources/packed_scene.cpp` |
| Node scene ownership and unique IDs | `scene/main/node.cpp` |
| GDScript implementation | `modules/gdscript/` |
| Godot .NET implementation | `modules/mono/` |
| Import and export | `editor/import/`, `editor/export/` |

Implementation checks established that:

- the project manager derives a displayed minor version from a version-like
  entry in `application/config/features`;
- `config_version` guards the project-settings format, not the Godot 4 minor;
- `--check-only` loads a script and returns its validity before trying to
  instantiate it;
- text resources reject forward references to unordered subresources and fall
  back from invalid external UIDs to paths with a warning.

## Official documentation inspected

- `about/release_policy.rst`
- `tutorials/migrating/upgrading_to_godot_4.7.rst`
- `tutorials/editor/command_line_tutorial.rst`
- `engine_details/file_formats/tscn.rst`
- `tutorials/scripting/gdscript/`
- `tutorials/scripting/c_sharp/`
- `tutorials/scripting/resources.rst`
- `tutorials/best_practices/scene_organization.rst`
- `tutorials/best_practices/scenes_versus_scripts.rst`
- `tutorials/best_practices/autoloads_versus_regular_nodes.rst`
- `tutorials/assets_pipeline/import_process.rst`
- `tutorials/rendering/renderers.rst`
- `tutorials/physics/using_jolt_physics.rst`
- `tutorials/export/exporting_projects.rst`

## Refresh procedure

1. Check the official GitHub latest stable release and the Godot download
   archive. Do not equate an RC/dev build with stable.
2. Create or update a separate clean engine checkout at the exact stable tag and
   a docs checkout at the matching version branch.
3. Record the tag/branch, commit IDs, release date, and clean status.
4. Re-run the evaluation matrix with the existing prompts before changing the
   skill. Add only facts or rules that fix a reproduced version-era failure.
5. Update the dated baseline in `references/version-and-sources.md`, this file,
   README links, and evaluation environment together.

Official links:

- [Godot 4.7 release](https://godotengine.org/releases/4.7/)
- [Godot download archive](https://godotengine.org/download/archive/)
- [Godot 4.7 GitHub release](https://github.com/godotengine/godot/releases/tag/4.7-stable)
- [Godot release policy](https://docs.godotengine.org/en/4.7/about/release_policy.html)
- [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html)
