# Domain Guides

Use this reference for practical defaults by Godot domain. For exact APIs and current behavior, jump from here to `official-docs-index.md`.

## Contents

- 2D
- 3D
- UI
- Physics
- Navigation
- Rendering And Shaders
- Assets And Import
- Export

## 2D

Defaults:

- Use `Node2D` as the root for 2D world objects.
- Use `CharacterBody2D` for player/NPC movement that collides.
- Use `Area2D` for triggers, pickups, hitboxes, and detection zones.
- Use `TileMapLayer`/tile workflows according to the project's Godot version and existing setup.
- Keep coordinate, collision, and visual scale consistent.

Check:

- collision shapes match sprites
- movement uses `_physics_process`
- camera limits and zoom are intentional
- tile collisions are imported or authored correctly

Official docs to check:

- `tutorials/2d/introduction_to_2d.rst`
- `tutorials/2d/2d_movement.rst`
- `tutorials/2d/using_tilemaps.rst`
- `tutorials/physics/using_character_body_2d.rst`

## 3D

Defaults:

- Use `Node3D` roots for spatial scenes.
- Use `CharacterBody3D` for controlled characters.
- Use simple collision shapes early.
- Use glTF for imported models.
- Prefer semantic anchors and generator scripts for large generated layouts.

Check:

- spawn points do not intersect collision
- main landmarks are visible and reachable
- lights/environment work with the selected renderer
- imported asset scale and orientation are correct

Official docs:

- `tutorials/3d/introduction_to_3d.rst`
- `tutorials/3d/using_transforms.rst`
- `tutorials/assets_pipeline/importing_3d_scenes/index.rst`
- `tutorials/physics/collision_shapes_3d.rst`

## UI

Defaults:

- Use `Control` nodes for UI.
- Use containers for layout instead of manual positions when possible.
- Use anchors and size flags deliberately.
- Keep UI state separate from gameplay simulation where practical.
- Prefer theme resources for repeated styling.

Check:

- no overlap at target resolutions
- text fits localized or long strings where relevant
- focus/navigation works for keyboard/controller if required
- UI does not depend on editor-only sizes

Official docs:

- `tutorials/ui/control_node_gallery.rst`
- `tutorials/ui/gui_containers.rst`
- `tutorials/ui/size_and_anchors.rst`
- `tutorials/ui/gui_navigation.rst`
- `tutorials/ui/gui_skinning.rst`

## Physics

Defaults:

- Use physics bodies for collision semantics, not only visual transforms.
- Keep collision layers/masks named and documented for non-trivial projects.
- Use simple shapes unless complex collision is required.
- Keep physics movement in `_physics_process`.

Check:

- layers/masks allow intended interactions
- shape scale is not accidentally distorted by parent transforms
- raycasts/areas update at the expected time
- large world coordinates or interpolation are considered only when needed

Official docs:

- `tutorials/physics/physics_introduction.rst`
- `tutorials/physics/collision_shapes_2d.rst`
- `tutorials/physics/collision_shapes_3d.rst`
- `tutorials/physics/ray-casting.rst`
- `tutorials/physics/using_jolt_physics.rst`

## Navigation

Defaults:

- Use navigation regions/maps for walkable space.
- Use `NavigationAgent2D`/`NavigationAgent3D` for actors.
- Keep debug visualization available for pathing work.
- Treat dynamic obstacles and layer access as explicit design choices.

Check:

- agents can reach representative targets
- paths do not clip through walls or blocked areas
- actor radius/height matches collision and navmesh settings

Official docs:

- `tutorials/navigation/navigation_introduction_2d.rst`
- `tutorials/navigation/navigation_introduction_3d.rst`
- `tutorials/navigation/navigation_using_navigationagents.rst`
- `tutorials/navigation/navigation_using_navigationregions.rst`

## Rendering And Shaders

Defaults:

- Choose renderer based on target platform.
- Keep material/shader complexity aligned with performance target.
- Use viewports intentionally; they can be powerful but add complexity.
- Prefer standard materials until custom shader behavior is needed.

Check:

- renderer-specific features are supported on target
- shader syntax compiles
- lighting and post-processing are visible in runtime, not only editor preview

Official docs:

- `tutorials/rendering/renderers.rst`
- `tutorials/rendering/viewports.rst`
- `tutorials/3d/standard_material_3d.rst`
- `tutorials/shaders/introduction_to_shaders.rst`
- `tutorials/shaders/shader_reference/shading_language.rst`

## Assets And Import

Defaults:

- Use glTF 2.0 for 3D assets.
- Use PNG/WebP for images.
- Use WAV/OGG for audio.
- Keep source assets outside `.godot/imported/`.
- Do not hand-edit generated import artifacts.

Check:

- import completed headlessly
- resource paths resolve
- scale/orientation/materials are correct for imported 3D assets
- audio loops/compression settings match use

Official docs:

- `tutorials/assets_pipeline/import_process.rst`
- `tutorials/assets_pipeline/importing_images.rst`
- `tutorials/assets_pipeline/importing_audio_samples.rst`
- `tutorials/assets_pipeline/importing_3d_scenes/index.rst`

## Export

Defaults:

- Check `export_presets.cfg` before editing export behavior.
- Keep platform-specific constraints explicit.
- Verify templates are installed before blaming project code.
- Treat web export, mobile permissions, signing, and C# support as version-sensitive.

Check:

- selected preset exists
- export templates are installed
- exported artifact launches or reaches a smoke screen when feasible

Official docs:

- `tutorials/export/exporting_projects.rst`
- `tutorials/export/exporting_for_web.rst`
- `tutorials/export/exporting_for_android.rst`
- `tutorials/export/exporting_for_ios.rst`
- `tutorials/export/exporting_for_macos.rst`
- `tutorials/export/exporting_for_windows.rst`
