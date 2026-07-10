# Validation

Use the narrowest evidence that proves the requested Godot result, then add
higher evidence only where the claim requires it. Treat every project-facing
Godot invocation as potentially stateful and executable.

## Contents

- Set authority and trust boundaries
- Identify the exact binary
- Climb the evidence ladder
- Import assets
- Parse scripts
- Build C# solutions
- Run scenes and tests
- Collect visual evidence
- Verify exports
- Report results and blocked checks
- Official Godot 4.7 sources

## Set authority and trust boundaries

Classify the request before running checks:

- For a review, inspect and report findings without editing files, importing
  assets, generating caches, or running project code. Binary-only version and
  help checks are acceptable when they do not target the project.
- For a diagnosis, gather read-only evidence first. Do not implement a fix
  unless the request also authorizes changes.
- For an implementation, make in-scope local changes and run proportionate,
  non-destructive validation against a trusted project.

Treat an unfamiliar project as untrusted code. Opening the editor, importing,
loading a project script, building, running a scene, testing, and exporting may
activate tool scripts, editor or import plugins, native extensions, build
hooks, or ordinary game code. Inspect `addons/`, `@tool` scripts, extension
configuration, import plugins, and project build files before execution.

Do not run project-facing commands for an untrusted project without explicit
authorization and an appropriate isolation boundary. Recovery mode disables
several crash-prone facilities, including tool scripts, editor plugins, and
GDExtension addons, but it is a recovery aid, not a security sandbox.

Expect import and editor commands to create or update `.godot/` caches. Treat
that normal cache mutation as validation state, not as a source edit. Keep it
out of a review-only workflow.

## Identify the exact binary

Start outside the project directory and identify the candidate executable:

```sh
godot --version
godot --help
```

Use `--version` to capture the exact version string. Use `--help` to confirm
that the current build exposes every option you plan to use. Both options exit
early in Godot 4.7 before project startup.

Never infer option support from a zero exit status alone. Godot silently ignores
unknown command-line arguments and does not warn when an option is unavailable
for the current build type. Confirm the option in this binary's help output and
require the expected log, state change, or artifact from every command.

Remember the availability classes:

- `--help` and `--version` are available in editor and export-template builds.
- `--script` and `--check-only` require an editor build or an export template
  compiled with path overrides enabled.
- `--import`, `--build-solutions`, and export commands require an editor build.

Stop version-sensitive validation when the executable does not match the
project's intended Godot line. Report the mismatch instead of silently testing
with a different version.

## Climb the evidence ladder

Use this order and stop when the requested claim is proven:

1. Inspect the diff, `project.godot`, referenced paths, and serialized structure.
2. Parse each changed script.
3. Import changed assets and text resources.
4. Build the existing C# solution when applicable.
5. Load or run the affected scene with a bounded smoke case.
6. Run relevant existing automated tests.
7. Observe visual behavior at the required viewport and renderer.
8. Export with the actual preset and inspect or launch the artifact.

Do not substitute a lower rung for a higher claim. Parsing does not prove
runtime behavior, a headless run does not prove appearance, and a scene run
does not prove export configuration.

For every executed check, retain the exact command, working project path,
version, exit status, relevant output, and produced artifact. Read stderr even
when the exit status is zero.

## Import assets

Run an editor import from an explicit project directory:

```sh
godot --headless --path /absolute/path/to/project --import
```

In Godot 4.7, `--import` starts the editor, waits for resources to import, then
quits; it implies `--editor` and `--quit`. Use it after changes to imported
assets, `.tscn`, `.tres`, scripts referenced by resources, import settings, or
project-wide type registration.

Require a clean exit and inspect import or parse diagnostics. Remember that a
successful import proves only that the editor completed its import pass. It
does not prove a scene can run or looks correct.

## Parse scripts

Parse a changed GDScript without instantiating its main loop:

```sh
godot --headless --path /absolute/path/to/project \
  --script res://path/to/changed_script.gd --check-only
```

Use `--check-only` only with `--script`. It loads the named script resource,
parses it for errors, and quits. Supply a resource path relative to the project
or an absolute filesystem path. Repeat for each independently changed entry
script whose validity matters.

Treat this as targeted parse evidence, not a project-wide type, scene, or
runtime check. It can still load project context and script dependencies, so do
not treat it as safe execution for an untrusted project.

## Build C# solutions

For an existing Godot C# project, use the editor build that contains the .NET
integration:

```sh
godot --headless --path /absolute/path/to/project --build-solutions
```

`--build-solutions` implies editor mode and requires a valid project being
edited. It invokes the registered scripting build callback and fails when the
callback fails. Do not use it as a GDScript check, and do not claim C# build
coverage when the required editor build or SDK is absent.

Also run the repository's existing build command when it encodes additional
project rules. Do not invent a replacement build workflow merely to produce a
green command.

## Run scenes and tests

Run a specific scene explicitly for a non-visual smoke check:

```sh
godot --headless --path /absolute/path/to/project \
  --scene res://scenes/target.tscn --quit-after 2
```

`--scene` accepts a project scene path or UID. A scene may also be supplied as
a positional argument from the project directory. Treat `--quit-after` as a
number of engine iterations, not seconds. Prefer a scene or smoke script that
exits deterministically; do not leave an open-ended process running.

Scene execution runs project code. Assert the behavior under test through
exit status, explicit diagnostics, or deterministic state. Mere startup without
an error is insufficient for gameplay logic that never ran.

Use a test framework only when the project already includes and configures it.
Discover the project's test command from its repository, addons, and continuous
integration configuration. Run the smallest relevant existing test set first.
Do not install or scaffold a framework solely to validate a change. When none
exists, use a focused smoke scene or script and report the missing framework.

## Collect visual evidence

Run without `--headless` when the result depends on UI layout, 2D or 3D
composition, camera framing, animation timing, particles, materials, lighting,
or renderer-specific behavior:

```sh
godot --path /absolute/path/to/project --scene res://scenes/target.tscn
```

Exercise the state that changed, not only the initial frame. Record the scene,
viewport size, renderer, interaction state, and a screenshot or short recording.
Compare against explicit acceptance criteria or a known baseline.

If a display, GPU, input path, or capture route is unavailable, mark visual
validation blocked. Do not present text inspection or a headless exit as visual
evidence.

## Verify exports

Check all prerequisites before exporting:

- Use a Godot editor binary, not an export template.
- Match the preset name exactly to `export_presets.cfg`.
- Install matching export templates or configure a valid custom template.
- Install any platform SDK or signing dependency required by the preset.
- Create the target directory before running the command.
- Include the output filename where the platform requires one.

Run the relevant preset:

```sh
godot --headless --path /absolute/path/to/project \
  --export-release "Preset Name" build/game.exe
```

Resolve a relative export path from the directory containing `project.godot`,
not from the shell's current directory. The same rule applies to
`--export-debug` and `--export-pack`. In Godot 4.7, debug and pack exports imply
an import pass.

Require a clean exit and the expected artifact at the resolved path. Check its
type and size, then launch or inspect it when the requested claim includes
packaging or runtime behavior. Keep credentials from
`.godot/export_credentials.cfg` private and out of reported logs.

## Report results and blocked checks

Label each check as one of:

- **Passed:** the expected observable result occurred.
- **Failed:** the command ran and produced a relevant error or wrong result.
- **Blocked:** a prerequisite, authority boundary, trust boundary, or required
  environment was unavailable.
- **Not run:** the check was irrelevant or outside the requested scope.
- **Inconclusive:** the command ran but did not prove the claim.

For every blocked or inconclusive check, report:

1. The exact check not proven.
2. The concrete reason.
3. The strongest evidence obtained instead.
4. The impact on the completion claim.
5. The smallest next action that would unblock it.

Do not retry unchanged commands after the same missing prerequisite is clear.
Do not replace a required version, renderer, platform, preset, or visual state
without identifying the substitution and its reduced evidentiary value.

Finish with the Godot version, commands run, passed evidence, visual and export
evidence, failed checks, blocked checks, and files changed. Claim only what the
recorded evidence supports.

## Official Godot 4.7 sources

Recheck these files within `godotengine/godot-docs` when updating
version-sensitive rules:

- `tutorials/editor/command_line_tutorial.rst`
- `tutorials/editor/project_manager.rst`
- `tutorials/plugins/running_code_in_the_editor.rst`
- `tutorials/plugins/editor/import_plugins.rst`
- `tutorials/export/exporting_projects.rst`

Recheck `main/main.cpp` within `godotengine/godot` for CLI implementation
details.
