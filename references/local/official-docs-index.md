# Official Godot Docs Index

Use this file when exact Godot behavior matters, when the user asks for current guidance, or when the skill's local notes are not detailed enough.

## Contents

- Source Priority
- Freshness Workflow
- URL Mapping
- Search Commands
- Topic Map
- How Much To Read

## Source Priority

1. Local official docs clone, when present:
   - `~/git/godot-docs`
   - `/Users/user/git/godot-docs`
2. Official hosted docs:
   - Stable docs: `https://docs.godotengine.org/en/stable/`
   - Versioned docs: `https://docs.godotengine.org/en/4.6/`
   - Latest development docs: `https://docs.godotengine.org/en/latest/`
3. Official docs repo:
   - GitHub: `https://github.com/godotengine/godot-docs`
   - Raw stable file: `https://raw.githubusercontent.com/godotengine/godot-docs/stable/` plus the `.rst` path
   - Raw master file: `https://raw.githubusercontent.com/godotengine/godot-docs/master/` plus the `.rst` path

Prefer stable docs for production guidance. Use latest/master only when the user explicitly asks about unreleased behavior or when stable docs do not include a needed page.

## Freshness Workflow

For local docs:

```bash
DOCS="${GODOT_DOCS:-$HOME/git/godot-docs}"
git -C "$DOCS" status --short --branch
git -C "$DOCS" log -1 --format='%H %cd %s' --date=short
git -C "$DOCS" fetch origin
```

If the local clone is missing, stale, or on the wrong branch, use official web docs or raw GitHub URLs instead of guessing.

As of 2026-04-27, the verified local docs clone was `/Users/user/git/godot-docs` on `master` at commit `3a4f7e27f6ab0eb2701f8a720847de1c55b234f8`, and the official stable docs were the Godot 4.6 branch.

## URL Mapping

Local file:

```text
tutorials/scripting/gdscript/gdscript_basics.rst
```

Hosted stable URL:

```text
https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html
```

Hosted versioned URL:

```text
https://docs.godotengine.org/en/4.6/tutorials/scripting/gdscript/gdscript_basics.html
```

Raw stable URL:

```text
https://raw.githubusercontent.com/godotengine/godot-docs/stable/tutorials/scripting/gdscript/gdscript_basics.rst
```

If a hosted URL fails, search the local docs clone or GitHub repo because files can move or be renamed.

## Search Commands

Use `rg` against local docs for broad discovery:

```bash
rg -n "CharacterBody2D|move_and_slide|NavigationAgent3D" ~/git/godot-docs
rg --files ~/git/godot-docs | rg "gdscript|signals|resources|export"
```

Use class reference files for exact APIs:

```text
classes/class_characterbody2d.rst
classes/class_characterbody3d.rst
classes/class_node.rst
classes/class_resource.rst
classes/class_packedscene.rst
classes/class_resourceuid.rst
```

## Topic Map

### Getting Started

- `getting_started/introduction/index.rst`
- `getting_started/step_by_step/index.rst`
- `getting_started/first_2d_game/index.rst`
- `getting_started/first_3d_game/index.rst`

### GDScript And Scripting

- `tutorials/scripting/index.rst`
- `tutorials/scripting/gdscript/gdscript_basics.rst`
- `tutorials/scripting/gdscript/gdscript_advanced.rst`
- `tutorials/scripting/gdscript/static_typing.rst`
- `tutorials/scripting/gdscript/gdscript_exports.rst`
- `tutorials/scripting/gdscript/gdscript_styleguide.rst`
- `tutorials/scripting/gdscript/warning_system.rst`
- `getting_started/step_by_step/signals.rst`
- `tutorials/scripting/nodes_and_scene_instances.rst`
- `tutorials/scripting/resources.rst`
- `tutorials/scripting/groups.rst`
- `tutorials/scripting/singletons_autoload.rst`
- `tutorials/scripting/scene_tree.rst`

### C# And GDExtension

- `tutorials/scripting/c_sharp/index.rst`
- `tutorials/scripting/c_sharp/c_sharp_basics.rst`
- `tutorials/scripting/c_sharp/c_sharp_exports.rst`
- `tutorials/scripting/c_sharp/c_sharp_signals.rst`
- `tutorials/scripting/c_sharp/c_sharp_style_guide.rst`
- `tutorials/scripting/cpp/gdextension_cpp_example.rst`

### Best Practices

- `tutorials/best_practices/project_organization.rst`
- `tutorials/best_practices/scene_organization.rst`
- `tutorials/best_practices/scenes_versus_scripts.rst`
- `tutorials/best_practices/autoloads_versus_regular_nodes.rst`
- `tutorials/best_practices/data_preferences.rst`
- `tutorials/best_practices/logic_preferences.rst`
- `tutorials/best_practices/godot_interfaces.rst`
- `tutorials/best_practices/node_alternatives.rst`

### 2D, UI, And Input

- `tutorials/2d/introduction_to_2d.rst`
- `tutorials/2d/2d_movement.rst`
- `tutorials/2d/using_tilemaps.rst`
- `tutorials/2d/using_tilesets.rst`
- `tutorials/inputs/inputevent.rst` may move; search `tutorials/inputs`.
- `tutorials/ui/control_node_gallery.rst`
- `tutorials/ui/gui_containers.rst`
- `tutorials/ui/size_and_anchors.rst`
- `tutorials/ui/gui_navigation.rst`
- `tutorials/ui/gui_skinning.rst`

### 3D, Physics, And Navigation

- `tutorials/3d/introduction_to_3d.rst`
- `tutorials/3d/using_transforms.rst`
- `tutorials/3d/standard_material_3d.rst`
- `tutorials/physics/physics_introduction.rst`
- `tutorials/physics/using_character_body_2d.rst`
- `tutorials/physics/collision_shapes_2d.rst`
- `tutorials/physics/collision_shapes_3d.rst`
- `tutorials/physics/using_jolt_physics.rst`
- `tutorials/navigation/navigation_introduction_2d.rst`
- `tutorials/navigation/navigation_introduction_3d.rst`
- `tutorials/navigation/navigation_using_navigationagents.rst`
- `tutorials/navigation/navigation_using_navigationregions.rst`

### Rendering, Shaders, Assets, Export

- `tutorials/rendering/renderers.rst`
- `tutorials/rendering/viewports.rst`
- `tutorials/shaders/introduction_to_shaders.rst`
- `tutorials/shaders/shader_reference/shading_language.rst`
- `tutorials/assets_pipeline/import_process.rst`
- `tutorials/assets_pipeline/importing_images.rst`
- `tutorials/assets_pipeline/importing_audio_samples.rst`
- `tutorials/assets_pipeline/importing_3d_scenes/index.rst`
- `tutorials/export/exporting_projects.rst`
- `tutorials/export/exporting_for_web.rst`
- `tutorials/export/exporting_for_android.rst`
- `tutorials/export/exporting_for_ios.rst`

### Engine Details And File Formats

- `engine_details/file_formats/tscn.rst`
- `.tres` resource format docs can move; search `engine_details/file_formats/` and the docs tree for "tres" when needed.
- `engine_details/class_reference/index.rst`
- `tutorials/editor/command_line_tutorial.rst`

## How Much To Read

Do not load an entire docs tree into context. Read:

- the skill's local reference first for default practice
- one or two official pages for exact syntax or API details
- the class reference page for exact method/property names
- neighboring index pages only when the file moved or the topic is ambiguous
