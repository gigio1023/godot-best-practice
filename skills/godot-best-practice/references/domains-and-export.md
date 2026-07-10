# Domain And Export Decisions

Use this reference to route 2D, 3D, UI, physics, navigation, rendering, shader,
asset, and export work. These are starting points; preserve project choices and
verify exact APIs for its engine version.

## Contents

- Domain matrix
- Renderer choice
- Physics and navigation
- UI and input
- Assets and imports
- Export
- Official reading map

## Domain Matrix

| Surface | Prefer | Evidence that matters |
| --- | --- | --- |
| 2D | `Node2D`, `CharacterBody2D`, `Area2D`, version-appropriate tile workflow | Physics movement, collision layers/shapes, camera, tile import, runtime view |
| 3D | `Node3D`, `CharacterBody3D`, simple collision, glTF source assets | Scale/orientation, collision, camera/lighting, navigation, target renderer |
| UI | `Control`, containers, anchors/size flags, themes, focus neighbors | Target resolutions/aspects, localization-length text, keyboard/controller focus, runtime capture |
| Physics | Bodies and shapes matching interaction semantics; explicit layers/masks | Fixed-step behavior, collision/debug view, configured 3D engine, representative contacts |
| Navigation | Regions/maps for walkable data and agents for actors | Map synchronization, agent dimensions, reachable targets, debug paths, dynamic obstacles |
| Rendering/shaders | Standard materials first; custom shader for a measured need | Target renderer compilation, lighting/post effects, device/platform capture, performance budget |
| Assets/import | Source assets plus committed import metadata and optional post-import tools | Clean import, paths, scale/orientation, materials, animations, compression |
| Export | Existing named preset and target-specific requirements | Templates/SDK/signing availability, successful artifact, smoke launch on the target class |

## Renderer Choice

Godot 4.7 provides three rendering methods:

- Forward+: advanced desktop renderer for modern Vulkan, Direct3D 12, or Metal
  hardware; choose it when advanced 3D features justify the higher baseline.
- Mobile: RenderingDevice-based renderer for newer mobile, desktop, and XR
  targets with fewer features and lower cost than Forward+.
- Compatibility: OpenGL renderer for the broadest/older hardware and Web. It is
  the only Web renderer.

Treat this as a target decision, not an aesthetic preference. Switching between
Compatibility and a RenderingDevice renderer can change materials, shaders,
lighting, environment, and appearance. A driver fallback that launches is not
proof the project renders as intended.

Godot 4.7 adds HDR output and renderer-specific features. Verify OS, display,
renderer, project settings, and capture path before claiming HDR behavior.

## Physics And Navigation

New projects use Jolt for 3D physics, but existing projects can use Godot Physics
or retain older settings. Inspect `physics/3d/physics_engine` and migration notes
before changing shapes, joints, contacts, soft bodies, or world boundaries.

Keep movement in the physics step, avoid distorted collision shapes from scaled
parents, and name non-trivial layer/mask intent. Use simple primitive shapes
until complex collision is required and measured.

Navigation data and queries synchronize on engine-defined timing. Do not expect
an immediately changed map to answer a valid path in the same step without
checking the documented synchronization behavior. Match navigation agent radius,
height, layers, and avoidance settings to collision and gameplay.

## UI And Input

Let containers own child layout. Use anchors, offsets, size flags, minimum sizes,
and themes deliberately; do not patch fixed coordinates until the layout owner is
understood. Godot 4.7 `Control.offset_transform_*` can apply visual transforms
without container sorting erasing them, but verify input behavior and project
version before using it.

Test the requested resolution/aspect range and input methods. A scene that parses
does not prove text fits, focus moves correctly, or pointer hit regions match a
visual transform.

Use named Input Map actions for gameplay. For 4.7 migrations, replace device-ID
`0` assumptions with the dedicated mouse/keyboard constants where relevant.

## Assets And Imports

- Keep `.godot/` as generated cache and out of version control.
- Commit source assets and their adjacent `<asset>.import` metadata when the
  project tracks those settings.
- Access imported resources through `ResourceLoader`/`load`, not `FileAccess`;
  exported projects may not include the original source file at `res://`.
- Change import settings, post-import scripts, or intentional overrides instead
  of editing `.godot/imported/` artifacts.
- Reimport and inspect 3D scale/orientation, materials, animation clips,
  collision, image compression, audio loop/compression, and dependencies.

## Export

Before changing or claiming an export:

1. Inspect `export_presets.cfg`, target feature tags, plugins, permissions,
   signing, and output path conventions.
2. Confirm an editor binary and matching export templates exist. C# targets also
   need a compatible .NET toolchain.
3. Verify platform constraints in versioned docs. In the 4.7 docs, Godot 4 C#
   projects cannot export to Web; mobile C# support remains experimental.
4. Create the output directory before a CLI export. Relative export paths are
   resolved from the directory containing `project.godot`.
5. Run the exact preset and smoke-launch the artifact when the claim includes a
   working deliverable. Report unavailable devices, credentials, SDKs, templates,
   or signing separately from project defects.

Do not install templates, SDKs, or signing material without explicit authority.

## Official Reading Map

- `tutorials/2d/`
- `tutorials/3d/`
- `tutorials/ui/gui_containers.rst`
- `tutorials/ui/size_and_anchors.rst`
- `tutorials/ui/gui_navigation.rst`
- `tutorials/physics/physics_introduction.rst`
- `tutorials/physics/using_jolt_physics.rst`
- `tutorials/navigation/`
- `tutorials/rendering/renderers.rst`
- `tutorials/shaders/shader_reference/shading_language.rst`
- `tutorials/assets_pipeline/import_process.rst`
- `tutorials/assets_pipeline/importing_3d_scenes/`
- `tutorials/export/exporting_projects.rst`
- the target platform's page under `tutorials/export/`
