# GDScript and Godot C#

## GDScript

Use the detected engine version and repository style. Godot 4 uses `@export`, `@onready`, and `await`; Godot 3 syntax such as `yield(...)` is not interchangeable.

- Type public/exported boundaries, signals, return values, and ambiguous values. Preserve the project's typing and indentation policy.
- Use `@export` for designer-provided values and dependencies, and `@onready` for stable scene-owned children.
- Keep lifecycle and input callbacks focused. Put collision-aware movement in `_physics_process` and presentation updates in `_process` when their timing requires it.
- Check typed containers, annotations, warnings, and method signatures against the project's minor version. A current example may not parse in an older Godot 4 project.
- After `await`, account for changed scene or object lifetime before using captured nodes. A continuation can outlive the gameplay state that started it.

Normal `--script` execution needs a `SceneTree` or `MainLoop` entry point. `--check-only` parses without instantiating that entry point and can check attached Node/Resource scripts. See [validation](validation.md) for the checker and its limits.

## Dependencies and signals

| Dependency | Prefer |
| --- | --- |
| Designer-wired node or data | Exported Node/Resource reference |
| Stable child in the same scene | `$Child` or `@onready` reference |
| Named node within its scene ownership boundary | `%UniqueName` |
| Required external collaborator | Reference passed during composition |
| Event whose sender should not know its listeners | Signal connected by their common owner |
| Changing set of objects with one role | Group |

Avoid long cross-scene `get_node()` chains and absolute `/root/...` paths when a local owner can wire the dependency. A rename must cover serialized consumers too: scene connections, animation tracks, exported NodePaths, scripts, and existing tests.

## Resources

Keep immutable definitions shared and per-instance state private. Normal cached loads of the same path return the same resource while it is retained. Choose duplication depth or scene-local resources before mutation; [scenes and resources](scenes-and-resources.md#resource-sharing) owns the details.

`preload()` needs a constant path and loads during script parsing. Use `load()` or `ResourceLoader` for runtime paths. Imported assets must load through the resource system; direct `FileAccess` to their source representation can fail after export.

## Godot C#

Use the .NET-enabled Godot editor and the project's required .NET SDK. Preserve `.csproj` and `.sln`; `.godot/mono` is generated state.

Declare Godot script classes `partial`, align an attached class with its filename, use Godot's PascalCase API and `[Export]`, and follow the C# docs for signal events, collections, and Variant conversion. GDScript syntax is not a C# template.

Build with the project's .NET workflow or the editor's `--build-solutions` flag. A GDScript parse check, successful file write, or empty editor log cannot prove C# compilation. Godot AI v4.3.0 edits C# as text and does not compile it; inspect actual build output.

The [4.7 C# platform guide](https://docs.godotengine.org/en/4.7/tutorials/scripting/c_sharp/index.html#c-platform-support) describes Android/iOS support as experimental and web export as unavailable. Recheck the target version before promising a platform.

## Godot 4.7 migration

Check typed-return overrides, packed-array property setters, and mouse/keyboard device IDs when upgrading from 4.6. Use `InputEvent.DEVICE_ID_MOUSE` and `InputEvent.DEVICE_ID_KEYBOARD` where relevant. The [4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) also lists source and binary compatibility changes, including C# and editor/import APIs; apply the changes relevant to the project.

## Official references

- [GDScript basics](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/gdscript_basics.html), [static typing](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/static_typing.html), [style](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/gdscript_styleguide.html), [exports](https://docs.godotengine.org/en/4.7/tutorials/scripting/gdscript/gdscript_exports.html).
- [Node references](https://docs.godotengine.org/en/4.7/tutorials/scripting/nodes_and_scene_instances.html), [signals](https://docs.godotengine.org/en/4.7/getting_started/step_by_step/signals.html), [resources](https://docs.godotengine.org/en/4.7/tutorials/scripting/resources.html).
- [C# basics](https://docs.godotengine.org/en/4.7/tutorials/scripting/c_sharp/c_sharp_basics.html), [API differences](https://docs.godotengine.org/en/4.7/tutorials/scripting/c_sharp/c_sharp_differences.html), [signals](https://docs.godotengine.org/en/4.7/tutorials/scripting/c_sharp/c_sharp_signals.html).
