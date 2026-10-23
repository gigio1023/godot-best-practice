# Blender Asset Pipeline

Keep Blender authoring, Godot import, and gameplay composition independently editable. Choose the transfer format before changing assets, then verify the same asset through export, import, reimport, and the target renderer. This reference uses the Godot 4.7 and Blender 5.2 manuals, checked on 2026-10-23. Resolve current releases and project pins through [version and sources](version-and-sources.md); documentation coverage is not measured compatibility.

## Transfer Format

| Route | Use when | Required on import machines |
| --- | --- | --- |
| Explicit `.glb` | Portable team handoff or a reproducible build input | Godot and the committed GLB |
| Explicit `.gltf` plus dependencies | Separate textures or reviewable scene JSON matters | Godot, JSON, buffers, and referenced textures |
| Direct `.blend` | Fast save-and-reimport iteration with a shared Blender setup | Godot and the pinned Blender executable |

Godot recommends glTF 2.0. Direct `.blend` import launches Blender's glTF exporter, then follows Godot's glTF import pipeline. Configure `Filesystem > Import > Blender > Blender Path` in **Editor Settings** if detection fails. To retain `.blend` files under the project without importing them, disable `Filesystem > Import > Blender > Enabled` in advanced **Project Settings**. Android and Web editors cannot perform this conversion. The exported game uses imported resources and does not need Blender. [Godot formats](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html)

For explicit exports, keep editable sources in an authoring directory outside the Godot project, or use an intentional import exclusion. Record the export preset and selected collection or objects. A GLB can package textures, while separate glTF files require every referenced dependency. Preserve the existing team's route unless changing its build contract is in scope.

## Asset Ownership

| Owner | Contents | Edit here for |
| --- | --- | --- |
| Blender source | Meshes, UVs, rig, actions, exportable material inputs | Geometry and authored motion |
| Godot import configuration | Adjacent `.import`, external resource mappings, import scripts | Repeatable conversion |
| Generated imported scene | Imported `PackedScene` and subresources in `.godot/` | Inspection only |
| Game-owned wrapper `.tscn` | Imported visual instance, gameplay body, scripts, sensors, attachments | Gameplay behavior and composition |

Default to a wrapper such as `CharacterBody3D` with a visual instance and a sibling `CollisionShape3D`. Keep animation state control and gameplay dependencies in the wrapper. Use an inherited scene when deliberate overrides of the imported hierarchy are needed; inherited base nodes cannot be removed. Renaming source nodes, bones, materials, or clips can invalidate paths and mappings even when the wrapper file survives. [Import configuration](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html)

## Scale, Orientation, And Transforms

- Use known physical dimensions and check them after import. glTF linear distances are meters; a scene-unit label alone is insufficient evidence of exported size. [glTF units](https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#coordinate-system-and-units)
- Let the exporter convert Blender's Z-up coordinates to glTF's Y-up convention. Godot cameras face `-Z`, but oriented model fronts face `+Z`, corresponding to Blender `-Y`. Use `use_model_front` with `look_at` where that model convention applies. Do not add an unexplained corrective rotation to every asset. [Godot model conventions](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/model_export_considerations.html)
- Set pivots for placement, rotation, and attachments. Apply rotation or scale deliberately before rigging when appropriate. Applying transforms changes the basis used by parenting, modifiers, and constraints; applying armature transforms does not update pose locations, animation curves, or constraints. Do not batch-apply all transforms to an animated rig or apply location when its pivot must stay local. [Blender Apply](https://docs.blender.org/manual/en/5.2/scene_layout/object/editing/apply.html)
- For static meshes, make triangulation and modifier evaluation intentional. For skinned meshes and shape keys, preserve the rest pose, deformation, and topology contract before changing export modifiers. Inspect mirrored normals, tangents, and nonuniform scale in Godot. [Model export considerations](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/model_export_considerations.html)

## Materials And Animation

Use a simple Principled BSDF material with supported texture inputs as the transfer baseline. Bake procedural appearance that must transfer, or recreate it as a Godot material. Mark roughness, metallic, and normal textures as Non-Color in Blender; check UVs, tangents, alpha, culling, and texture compression in the target renderer. A Blender render is not a Godot appearance check. [Blender glTF materials](https://docs.blender.org/manual/en/5.2/addons/import_export/scene_gltf2.html#materials)

Choose animation export mode explicitly. In Actions mode, keep required actions active or stashed; Blender 4.4 introduced slotted actions and changed default merging to the action rather than track name. NLA Tracks mode uses track organization. Bake or sample constraints and drivers into supported transform, bone, or shape-key channels. Check clip inventory, time origin, duration, rest pose, loop seam, and root-motion ownership. Frame 1 need not export at time zero; verify the range and timestamp-shifting setting before diagnosing a duration mismatch. Do not assume a rig's constraints become runtime Godot logic. [Blender glTF animations](https://docs.blender.org/manual/en/5.2/addons/import_export/scene_gltf2.html#animations)

For blend shapes, enable `Data > Armature > Export Deformation Bones Only` as required by Godot's documentation, then check shading and deformation together. Preview every required clip in Godot before wiring gameplay transitions. [Godot Blender export guidance](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html#exporting-gltf-2-0-files-from-blender-recommended)

## Import Customization And Reimport

- Use Advanced Import Settings for per-object physics and material mappings. Prefer primitive or convex collision for moving objects; reserve trimesh collision for static geometry. Keep the visual mesh separate from collision when their detail differs. [Advanced import settings](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/advanced_import_settings.html)
- Use suffixes only as an intentional authoring convention. For example, `-colonly` removes the visible mesh and creates static collision; `-noimp` removes the node. Check the suffix's precise semantics before applying it to a rig or moving body. [Import suffixes](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/node_type_customization.html)
- Extract materials or assign external Godot materials when the engine owns their appearance. Reimport preserves extracted-material edits, but renaming the source material breaks its mapping. Inspect the instantiated scene: the advanced import preview still displays the source material. [External materials](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/advanced_import_settings.html#extracting-materials-to-separate-files)
- Use `EditorScenePostImport._post_import(scene)` for repeatable import-wide changes and return the resulting scene. Keep scripts deterministic, version-controlled, and free of machine-specific paths. [Import scripts](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html#using-import-scripts-for-automation)
- Inspect generated mesh LODs at gameplay distances. Mesh LOD reduces geometry detail; visibility ranges serve a different role when replacing whole objects or groups. Neither establishes a performance improvement without target measurements. [Mesh LOD](https://docs.godotengine.org/en/4.7/tutorials/3d/mesh_lod.html)

## Reproducible Verification

1. Record exact Godot, Blender, exporter or addon versions and export settings. Direct `.blend` builds need Blender discovery configured on CI; explicit-GLB builds need Blender only where GLBs are produced.
2. Commit source inputs, exported assets required by the chosen route, adjacent `.import` metadata, wrapper scenes, external materials, and import scripts. Keep `.godot/` generated. For binary assets, follow repository LFS policy and verify the build receives objects rather than pointer files.
3. Import from a fresh temporary checkout using the matching editor. Use the commands and log checks in [validation](validation.md); a warm local cache does not prove a fresh build can convert the source.
4. Check dimensions, forward direction, pivots, material appearance, clip names, skinning, collision, and dependencies. Change one source detail, re-export or reimport, and confirm wrapper behavior and intended overrides survive.
5. Build the named export preset and launch on the target class when delivery includes a working game. Report export/import success separately from visual, rig, platform, and performance evidence. A cube smoke does not certify production assets.
