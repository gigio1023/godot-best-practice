# Source Provenance

The 2026-10-23 refresh targets **Godot 4.7.2 stable**. The official download, archive, and GitHub latest-release API agree. Godot 4.8-beta1 is a prerelease, not the stable baseline.

## Current source snapshot

| Source | Ref | Commit or date |
| --- | --- | --- |
| [Godot engine](https://github.com/godotengine/godot/tree/ed1daf0bf001b61586d9930840f2f1394092c079) | `4.7.2-stable` | `ed1daf0bf001b61586d9930840f2f1394092c079` |
| [Godot docs](https://github.com/godotengine/godot-docs/tree/9adca4c1c72917bfe1b7be3108abed5ce26696a6) | `4.7` | `9adca4c1c72917bfe1b7be3108abed5ce26696a6` |
| [Stable release](https://github.com/godotengine/godot/releases/tag/4.7.2-stable) | Godot 4.7.2 | Published 2026-08-18 |
| [Blender release index](https://download.blender.org/release/Blender5.2/) | Blender 5.2.3 LTS | Released 2026-10-22 |
| [Development release](https://github.com/godotengine/godot-builds/releases/tag/4.8-beta1) | Godot 4.8-beta1 | Published 2026-10-15 |
| [Godot AI](https://github.com/hi-godot/godot-ai/tree/b82b5c519b1b17228f70d8effce1626f391bd1dd) | `v4.3.0` | `b82b5c519b1b17228f70d8effce1626f391bd1dd` |

Release checks: [official download](https://godotengine.org/download/macos/), [archive](https://godotengine.org/download/archive/), [Godot latest-release API](https://api.github.com/repos/godotengine/godot/releases/latest), [Godot AI latest-release API](https://api.github.com/repos/hi-godot/godot-ai/releases/latest). These establish the snapshot date, not future freshness.

## Material rechecked

The refresh read the following files at the pinned revisions. It did not re-audit the full engine or documentation tree.

| Concern | Inspected source | Guidance |
| --- | --- | --- |
| Serialization | Engine `resource_format_text.cpp` and `.h` | Ordered subresources, format 3/4, IDs, parents/owners |
| Shared resources | Engine `doc/classes/Resource.xml` | Cache lifetime, scene-local copies, duplication depth, custom-resource limits |
| Node references | Engine `doc/classes/Node.xml`, `NodePath.xml`, `AnimationMixer.xml` | Ownership and API-specific path resolution |
| Migration | Docs `upgrading_to_godot_4.6.rst`, `upgrading_to_godot_4.7.rst` | Serializer changes, typed returns, packed arrays, input IDs, new-project defaults |
| Physics | Docs `using_jolt_physics.rst` | New-project default and existing-project setting |
| Imports | Docs `import_process.rst` | Source/sidecar ownership and generated cache |
| C# platforms | Docs `tutorials/scripting/c_sharp/index.rst` | .NET editor, experimental mobile support, no web export in 4.7 |
| Optional editor adapter | Godot AI `README.md`, `docs/TOOLS.md` | Compatibility, attach route, sessions, autosave, game status, logs, C# text-only edits, routed screenshots |

[Blender pipeline](../skills/godot-best-practice/references/blender-pipeline.md) records its Blender and glTF sources and version assumptions. Blender 5.2.3 LTS is the current documentation baseline, not a claim that every pipeline was exercised with that patch. [Validation](../skills/godot-best-practice/references/validation.md) defines what engine, visual, and export checks can establish. Historical evaluation results retain their original dates and environments; source review and prose simplification do not establish an improvement in agent behavior.

## Earlier authoring evidence

The 2026-07-10 rewrite used clean, content-complete shallow checkouts of `godotengine/godot` at `4.7-stable`, commit `5b4e0cb0fd279832bbdd69fed5354d4e5ad26f88`, and `godotengine/godot-docs` branch `4.7`, commit `0585d03bea24497cf91f0969c81a187c892371c4`.

That work inspected `version.py`, project settings and project-manager version detection, `main/main.cpp`, text-resource/packed-scene serialization, node ownership, GDScript/.NET, import, and export implementation. It established that `config_version` is a settings-format version, `--check-only` validates scripts before entry-point instantiation, and invalid external UIDs can fall back to paths with a warning. Its documentation reading covered the release policy, CLI, scripting, scene organization, resources, import, renderers, physics, and export.

These are historical authoring records, not claims that every file was re-read in this refresh or that a current runtime check passed.

## Refresh procedure

1. Check official download/archive and GitHub stable releases. Separate stable, RC, beta, and dev builds.
2. Resolve exact engine and docs revisions, then inspect sources relevant to changed claims. Use pinned web files or a separate checkout without mutating the user's source checkout.
3. Update the affected guidance, dated baseline, provenance, and public version links together.
4. Validate package links and changed scripts through their actual entry points. Exercise affected engine behavior where the claim requires it.
5. Run model evaluations only when requested; report their prompts, model/runtime versions, outputs, and limits separately from static and engine checks.
