# Validation

Choose checks that establish the requested result. Script parsing, asset import, scene behavior, appearance, and exported builds prove different things. Record the exact Godot version, command, exit status, relevant diagnostics, and artifact for each check.

## Execution boundary

A review stays read-only unless the request authorizes execution. Inspect files and report findings without importing, generating project caches, or running project code. Binary-only `--version` and `--help` checks are suitable outside the project. For implementation work, run proportionate local checks within the existing authorization.

Opening, importing, parsing, building, and exporting a project can load tool scripts, editor or import plugins, native extensions, or build hooks. Inspect these surfaces before executing an unfamiliar project and use an appropriate isolation boundary. Recovery mode disables several editor facilities; it is not a security sandbox. Import and editor commands normally create `.godot/` caches and may update import metadata.

## Binary and prerequisites

```sh
godot --version
godot --help
```

Use the project's intended engine version. The maintained reference is Godot 4.7.2; a different project version needs its matching binary and documentation. Capture the full version string instead of treating the reference version as proof of the installed engine.

Confirm each option in the selected binary's help output. Godot can silently ignore unsupported arguments, so exit status alone does not establish that a requested check ran. `--script` and `--check-only` need an editor or a build with path overrides enabled. Import, solution build, and export commands require an editor. C# additionally needs the .NET editor and the project's compatible SDK.

A fresh checkout may need an import before script parsing: imported assets and the global script-class cache can be missing. After changes to class names, assets, import settings, or referenced resources, import first. Diagnose a missing dependency or stale cache before treating its downstream parse errors as independent source defects.

## Asset import

```sh
godot --headless --path /absolute/path/to/project --import
```

`--import` starts the editor, waits for imports, and quits. Require a clean exit and inspect all diagnostics. Import completion does not establish scene behavior or appearance. For Blender assets, check the conversion/import prerequisites and artifacts in [Blender pipeline](blender-pipeline.md) when that workflow is in use.

## GDScript parsing

Check a changed script in its project context:

```sh
godot --headless --path /absolute/path/to/project \
  --script res://path/to/changed_script.gd --check-only
```

`--check-only` loads and parses the named script without instantiating its main loop. It still loads project context and dependencies. It does not prove scene wiring, runtime behavior, or the safety of an unfamiliar project.

For all regular `.gd` files under a trusted project, invoke the bundled helper using its installed location:

```sh
GODOT_BIN=/absolute/path/to/godot \
  bash /absolute/path/to/godot-best-practice/scripts/check_gdscript.sh \
  /absolute/path/to/project
```

The helper requires Bash, `find`, `mktemp`, and `grep`. `GODOT_PATH` remains a legacy fallback when `GODOT_BIN` is unset or empty. Paths with spaces are supported. It excludes directories named `.git` and `.godot`, does not follow symlinks, and includes regular scripts under addons and `.gdignore` directories. This is filesystem coverage, not a replica of the editor's import selection.

The helper checks CLI option availability, rejects incomplete file discovery, and treats nonzero parser exits or engine error diagnostics as failures. Godot can print script errors with exit status zero. Before scanning, the helper parses an intentionally malformed temporary script outside the project and requires its expected error and exact path in the diagnostics. This rejects effective diagnostic suppression, including `application/run/disable_stderr` set through `override.cfg`, without rewriting project configuration. The temporary probe is removed on exit. Warnings remain visible but do not fail the helper. It does not import automatically, enforce an engine version, impose a wall-clock timeout, or check C#, scenes, shaders, and exports. Use a bounded external runner when project startup or native code might hang.

| Exit | Meaning |
| --- | --- |
| `0` with `Checked: N`, `Failed: 0` | All discovered scripts passed the parser check |
| `0` with `SKIP` | No regular `.gd` files; no engine check ran |
| `1` | At least one script or engine diagnostic failed |
| `2` | Invalid input, incomplete discovery, unavailable CLI option, or unavailable parser diagnostics |
| `127` | Configured engine missing or not executable |
| Any version/help failure | Original nonzero exit preserved; diagnostics identify the preflight stage |

An empty GDScript scan is valid for a C# project but supplies no C# build evidence. A passing scan also supplies no runtime or visual evidence.

## C# build

```sh
godot --headless --path /absolute/path/to/project --build-solutions --quit
```

Use the .NET editor, confirm that the existing solution actually built, and inspect build diagnostics. `--build-solutions` implies editor mode; `--quit` bounds editor lifetime after the build callback. Also run the repository's existing build command when it encodes additional requirements. A standard editor with no C# build callback supplies no C# evidence.

## Runtime and existing tests

```sh
godot --headless --path /absolute/path/to/project \
  --scene res://scenes/target.tscn --quit-after 2
```

`--quit-after` counts engine iterations, not seconds. This command provides a short startup smoke check; it does not establish gameplay that was never exercised. Prefer a focused scene or script with observable assertions and deterministic exit for behavioral claims. Inspect stderr even when the process returns zero.

Run the relevant tests already configured by the project. Discover the command from repository documentation, addons, or CI. Do not install a framework solely to obtain a passing check. Where no framework exists, use a focused smoke scenario for the changed behavior.

## Visual evidence

```sh
godot --path /absolute/path/to/project --scene res://scenes/target.tscn
```

Exercise the changed state at the required viewport and renderer. Record the scene, viewport, interaction, and screenshot or recording. UI layout, camera framing, animation timing, materials, lighting, and renderer-specific behavior need visual evidence. A headless run does not establish their appearance. If the display, GPU, input, or capture route is unavailable, state which visual claim remains blocked.

## Export evidence

Use an exact preset from `export_presets.cfg`, matching export templates, and the platform SDK or signing dependencies it requires. Create the output directory first:

```sh
godot --headless --path /absolute/path/to/project \
  --export-release "Preset Name" build/game.exe
```

Relative output paths resolve from the directory containing `project.godot`, not the shell directory. Debug and pack exports imply an import pass. Require a clean exit and the expected artifact, then inspect or launch it when the claim includes packaging or runtime behavior. Keep `.godot/export_credentials.cfg` and signing secrets out of shared logs.

## Result reporting

Report each relevant check as passed, failed, blocked, not run, or inconclusive. Name the observed result and its limit. For a blocked claim, give the missing prerequisite and smallest next action; do not retry an unchanged command when the prerequisite is still absent. Finish with changed files, exact engine version, checks actually run, and remaining runtime, visual, or export gaps.

## Official sources

- [Godot 4.7 command-line reference](https://docs.godotengine.org/en/4.7/tutorials/editor/command_line_tutorial.html): option availability and command semantics.
- [Godot 4.7.2 CLI implementation](https://github.com/godotengine/godot/blob/4.7.2-stable/main/main.cpp): check-only startup and build callback behavior.
- [Running code in the editor](https://docs.godotengine.org/en/4.7/tutorials/plugins/running_code_in_the_editor.html): tool-script execution.
- [Exporting projects](https://docs.godotengine.org/en/4.7/tutorials/export/exporting_projects.html): export prerequisites.
