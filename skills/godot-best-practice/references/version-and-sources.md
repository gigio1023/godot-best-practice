# Version And Official Sources

Use this reference to identify the project's Godot version, resolve exact
behavior, or plan an engine upgrade. Treat the dated baseline as provenance,
not as permanent proof of what is latest.

## Contents

- Determine the project version
- Select official evidence
- Use local official checkouts
- Current verified baseline
- Upgrade safely
- Source map

## Determine The Project Version

Build version evidence from several signals:

1. Read `application/config/features` in `project.godot`. Godot's project
   manager treats its first version-like feature, such as `4.7`, as the project
   version.
2. Read version pins in CI, launch scripts, editor setup, containers, or project
   documentation. A repository may intentionally use a patch or custom build.
3. Inspect `.csproj`, `.sln`, `C#` feature tags, GDExtensions, addons, and export
   targets for compatibility constraints.
4. Run the intended editor binary with `--version` when execution is authorized.
   Run `--help` before depending on a flag for a custom build; Godot silently
   ignores unknown command-line arguments.

Do not use `config_version` as a minor-version detector. `config_version=5`
means the Godot 4 project-settings format. The engine rejects a newer,
unsupported configuration format, but the value does not distinguish 4.0 from
4.7.

If these sources disagree, report the conflict. Do not open or import the project
with a guessed newer editor merely to discover its version; that can update
metadata, imports, or serialized files.

## Select Official Evidence

Use this order for exact or version-sensitive decisions:

1. The target project's pinned version and repository conventions.
2. The matching version of the official Godot documentation and class
   reference.
3. The matching official engine tag/branch when documentation is ambiguous or
   the behavior is implemented below the public API.
4. Official release notes and each migration guide between source and target
   versions for upgrades.

Use hosted `stable` pages only after verifying which version `stable` currently
points to. Prefer a versioned URL such as `/en/4.7/` when recording evidence.
Use `latest`/`master` only for unreleased behavior and label it development
material.

Do not load an entire documentation or source tree. Search broadly, then read
the relevant guide, exact class page, and implementation site when needed.

## Use Local Official Checkouts

Local official checkouts are optional acceleration, not a runtime prerequisite.
Honor configured locations such as `GODOT_SOURCE` and `GODOT_DOCS`; otherwise
search plausible workspace or `~/git` paths before using the web.

Before relying on a checkout, inspect rather than mutate it:

```bash
git -C "$GODOT_SOURCE" status --short --branch
git -C "$GODOT_SOURCE" rev-parse HEAD
git -C "$GODOT_SOURCE" describe --tags --exact-match HEAD

git -C "$GODOT_DOCS" status --short --branch
git -C "$GODOT_DOCS" rev-parse HEAD
```

Do not fetch, switch branches, discard changes, or rewrite a user's checkout
unless the request includes maintaining that checkout. If its ref is wrong or
stale, use versioned official web sources or a separate authorized clone.

Useful searches:

```bash
rg -n "ClassName|method_name|project setting" "$GODOT_DOCS/classes" "$GODOT_DOCS/tutorials"
rg -n "ClassName|method_name" "$GODOT_SOURCE/scene" "$GODOT_SOURCE/core" "$GODOT_SOURCE/modules"
```

## Current Verified Baseline

Verified on 2026-09-23:

- Latest stable release: Godot 4.7.2, released 2026-08-18. The earlier 4.7 releases were 4.7.1 on 2026-07-14 and 4.7 on 2026-06-18.
- Engine tag: `4.7.2-stable` at `ed1daf0bf001b61586d9930840f2f1394092c079`.
- Matching docs branch: `4.7` at `9adca4c1c72917bfe1b7be3108abed5ce26696a6`.
- `4.8-dev6`, published 2026-09-15, is a development build, not a newer stable release.

Recheck official releases before answering any later "latest" or "current" request. The skill itself was authored on 2026-07-10 against `4.7-stable` at `5b4e0cb0fd279832bbdd69fed5354d4e5ad26f88`; see `docs/source-provenance.md` in the repository checkout for that authoring evidence. The maintainer document is not required at runtime.

High-impact 4.6/4.7 details include:

- Godot 4.6 stopped writing deprecated TSCN `load_steps` and began writing node
  `unique_id` values, so editor saves can produce legitimate large scene diffs.
- New 3D projects use Jolt, but existing projects retain their configured
  physics engine. Inspect project settings before applying Jolt assumptions.
- In 4.7, packed-array element assignment no longer invokes the setter for the
  entire property.
- A method overriding a typed-return method inherits that return type and needs
  an explicit return path.
- Mouse and keyboard device IDs are dedicated constants; do not assume `0`.
- Newly created projects default to `canvas_items` stretch mode with `expand`
  aspect. This does not silently rewrite the defaults of existing projects.

These are migration prompts, not a substitute for reading the full guide for
the affected systems.

## Upgrade Safely

1. Confirm explicit upgrade scope and a clean, recoverable version-control state.
2. Record the exact source version, target stable version, languages, addons,
   GDExtensions, render/physics settings, and export targets.
3. Read every official migration guide between the two versions. Separate API
   breaks, behavior changes, and changed defaults.
4. Update engine/SDK/addon constraints deliberately. Do not bundle unrelated
   architecture rewrites into the migration.
5. Import with the target editor, review generated diffs, and distinguish
   expected serializer churn from unintended changes.
6. Run representative script/build, scene, runtime, visual, physics, input, and
   export checks for surfaces named by the migration guides.
7. Report any target or platform that was not exercised.

Treat Godot 3-to-4 conversion as a separate high-risk path. The converter cannot
prove gameplay, rendering, physics, shader, or addon equivalence.

## Source Map

| Question | Official docs path | Engine source path |
| --- | --- | --- |
| Release and compatibility policy | `about/release_policy.rst` | `version.py`, `CHANGELOG.md` |
| Project version/features | `tutorials/editor/project_settings.rst` | `core/config/project_settings.cpp`, `editor/project_manager/project_list.cpp` |
| CLI flags and behavior | `tutorials/editor/command_line_tutorial.rst` | `main/main.cpp` |
| TSCN/TRES parsing | `engine_details/file_formats/tscn.rst` | `scene/resources/resource_format_text.cpp`, `packed_scene.cpp` |
| GDScript | `tutorials/scripting/gdscript/` | `modules/gdscript/` |
| C#/.NET | `tutorials/scripting/c_sharp/` | `modules/mono/` |
| Imports | `tutorials/assets_pipeline/import_process.rst` | `editor/import/` |
| Export | `tutorials/export/exporting_projects.rst` | `editor/export/` |

Official web entry points:

- `https://godotengine.org/releases/4.7/`
- `https://godotengine.org/download/archive/`
- `https://github.com/godotengine/godot/releases/tag/4.7-stable`
- `https://docs.godotengine.org/en/4.7/`
- `https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html`
