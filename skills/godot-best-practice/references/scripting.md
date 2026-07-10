# GDScript And Godot C#

Use this reference when editing scripts, signals, lifecycle code, node
references, typed APIs, or .NET projects. Follow the project's language and
style before introducing a new default.

## Contents

- GDScript
- Node references and signals
- Resources and runtime state
- Godot C#
- Godot 4.7 migration checks
- Official reading map

## GDScript

- Use the syntax and APIs of the detected project version. Reject Godot 3-era
  forms such as `yield(...)` or old export syntax in a Godot 4 project.
- Preserve the repository's indentation and typing policy. Prefer explicit
  types for exported/public boundaries, signals, return values, and locals where
  inference is unclear; do not create noisy annotations that fight local style.
- Use `@export` for designer-provided values or dependencies, `@onready` for
  stable scene-owned children, and `await` for signal/coroutine suspension.
- Keep `_ready`, `_process`, `_physics_process`, and input callbacks focused.
  Move reusable decisions into named methods and keep physics mutations in the
  physics step unless the design requires otherwise.
- Verify typed arrays/dictionaries, annotations, warnings, and method signatures
  against the project's minor version. A valid current example may not parse in
  an older Godot 4 project.

Do not run every script as a command-line program. Godot's normal `--script`
execution requires a `SceneTree` or `MainLoop` script. `--check-only` returns
after parsing and can validate an attached Node/Resource script; use the bundled
checker or an equivalent targeted command.

## Node References And Signals

Choose the narrowest stable dependency:

- Use an exported Node/Resource reference when a scene author should wire it.
- Use `$Child` or `@onready` for a stable child owned by the same scene.
- Use `%UniqueName` only inside the scene ownership boundary that guarantees the
  unique name.
- Pass required dependencies during composition when a script should not search
  the tree.
- Use signals across ownership boundaries when the sender should not know its
  listeners. Connect them at the scene or coordinator that owns both sides.
- Use groups for many objects sharing a role such as `damageable` or `saveable`,
  not to hide one required singleton-like dependency.

Avoid absolute `/root/...` paths and long cross-scene `get_node()` chains. When
renaming a node or signal, search scripts, scenes, animation tracks, exported
NodePaths, and tests for every serialized consumer.

## Resources And Runtime State

Treat resources as shared data containers. Loading the same path returns the
same in-memory resource. Do not store mutable per-instance state in a shared
resource unless sharing is intentional; duplicate it or use scene-local state
according to the project's design.

Use `preload()` only with a constant path and when compile-time loading fits the
dependency. Use `load()` or `ResourceLoader` for runtime paths and imported
resources. Do not read an imported asset through `FileAccess`; exported projects
may contain only the imported resource representation.

## Godot C#

- Confirm the project uses the .NET-enabled Godot editor and has the required
  .NET SDK. The standard editor does not provide C# support.
- Preserve `.csproj` and `.sln` files. Ignore generated `.godot/mono` state.
- Declare Godot script classes `partial`, keep the attached class name aligned
  with its file name, use Godot's PascalCase API, and use `[Export]` for
  inspector-exposed members.
- Use generated signal events and Godot collection/Variant conversions according
  to the official C# docs; do not transliterate GDScript syntax mechanically.
- Build through the project's established .NET workflow or Godot's
  `--build-solutions` editor flag. A GDScript parse check does not validate C#.
- Verify current platform support before promising an export. In the Godot 4.7
  docs, C# web export is unavailable and Android/iOS support is experimental.
  Treat those statements as versioned, not permanent.

Do not install an SDK, .NET editor, NuGet package, or testing framework without
the user's authority.

## Godot 4.7 Migration Checks

When moving from 4.6 to 4.7, inspect at least these affected script surfaces:

- overrides of methods with typed returns now inherit the return type and need
  an explicit return path;
- packed-array element assignment no longer calls the setter for the whole
  property;
- mouse and keyboard input should use `InputEvent.DEVICE_ID_MOUSE` and
  `InputEvent.DEVICE_ID_KEYBOARD` instead of assuming device ID `0`;
- several APIs changed source or binary compatibility, especially C# enum/type
  moves and editor/import APIs.

Read the complete versioned migration guide and exact class pages for the code
being changed. Do not turn this shortlist into a blanket rewrite.

## Official Reading Map

- `tutorials/scripting/gdscript/gdscript_basics.rst`
- `tutorials/scripting/gdscript/static_typing.rst`
- `tutorials/scripting/gdscript/gdscript_styleguide.rst`
- `tutorials/scripting/gdscript/gdscript_exports.rst`
- `tutorials/scripting/nodes_and_scene_instances.rst`
- `getting_started/step_by_step/signals.rst`
- `tutorials/scripting/resources.rst`
- `tutorials/scripting/c_sharp/index.rst`
- `tutorials/scripting/c_sharp/c_sharp_basics.rst`
- `tutorials/scripting/c_sharp/c_sharp_differences.rst`
- `tutorials/scripting/c_sharp/c_sharp_exports.rst`
- `tutorials/scripting/c_sharp/c_sharp_signals.rst`
