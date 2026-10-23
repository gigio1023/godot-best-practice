# Scenes and Resources

## Source ownership

| Target | Source of truth | Edit route |
| --- | --- | --- |
| Authored `.tscn`/`.tres` | Text resource | Small direct edit or Godot save |
| Generated scene/resource | Generator and inputs | Change source, then regenerate |
| Imported asset/scene | Source asset and import settings | Source, importer, post-import logic, or authored wrapper |
| `.godot/imported/` | Derived cache | Reimport |
| Binary `.scn`/`.res` | Godot serialization | Load/save through Godot |

Inspect nearby scripts, build tasks, headers, and history when ownership is unclear. Identify authoritative input before overwriting generated output. For Blender, glTF, materials, rigs, and animation, use the [Blender pipeline](blender-pipeline.md).

Direct text editing fits a small change with understood IDs, paths, owners, and references. Use Godot APIs or a deterministic generator for many nodes, reparenting, inherited overrides, nested ownership, editable instances, persistent connections, animation tracks, or dense mesh/packed-array data. Review unrelated serializer churn separately.

## Text resource structure

TSCN sections appear in this order: `[gd_scene]`, `[ext_resource]`, `[sub_resource]`, `[node]`, `[connection]`, then any `[editable]` records. Keep parents before descendants. TRES uses `[gd_resource]`, external resources, subresources, then `[resource]` and its properties.

Define each subresource before a property references it. A forward `SubResource("id")` reference is a parse error. Use serialized Variant values, not GDScript expressions or calls.

Normal Godot 4 headers use string IDs and `format=3`:

```text
[gd_scene format=3 uid="uid://cecaux1sm7mo0"]
[gd_resource type="Resource" format=3 uid="uid://dww8o7hsqrhx5"]
```

Godot 4.7 can emit `format=4` for `PackedVector4Array` or base64-encoded `PackedByteArray` values over 64 bytes. Preserve valid headers rather than downgrading them. Legacy `load_steps` is ignored and omitted by saves from Godot 4.6 onward; do not recalculate it.

A Godot save can discard comments, insignificant whitespace, and properties equal to defaults. Keep durable authoring intent outside formatting that serialization removes.

## IDs and paths

| Value | Identity |
| --- | --- |
| Header/external `uid="uid://..."` | File identity across moves |
| External `id="..."` | File-local `ExtResource("...")` reference |
| Subresource `id="..."` | File-local `SubResource("...")` reference |
| Node integer `unique_id` | Node identity across moves and renames |

External and subresource IDs have separate namespaces and may share a string. Preserve existing node `unique_id` values from Godot 4.6+; let the editor assign missing values when needed.

Keep an external resource's `type`, `uid`, `path`, and local `id` coherent. `res://` paths are normal; paths relative to the text resource are also valid. Update every reference in the same namespace if an ID changes. Prefer editor-managed moves and keep source `.uid` sidecars where the resource type uses them. A stale UID falling back to its path with a warning is a problem to resolve, not a clean validation result.

## Parents, owners, and NodePaths

| Field | Meaning |
| --- | --- |
| First `[node]` | Single root, without `parent` |
| `parent="."` | Child of the scene root |
| `parent="A/B"` | Parent below the root, without the root's name |
| `owner="..."` | Ancestor whose packed scene saves the node |
| `NodePath("...")` | Node/property path interpreted by the consuming API |

Tree parent and scene owner are different. Preserve non-root owners for nested/instanced content. An ordinary text-scene child with omitted `owner` defaults to the scene root. In code, add the child, then assign an ancestor as owner if it must be included in that ancestor's `PackedScene`; a visible but unowned child can disappear on save.

For node lookup, `.` means the current node, an empty path means no node, and `..` means its parent. Resolve ordinary node-reference properties from their storing node, but follow the consuming API for other uses: animation tracks resolve against the animation root. Preserve subnames such as `NodePath("Mesh:scale.x")`.

## Imported and generated assets

Commit source assets and adjacent `<asset>.import` metadata. Keep `.godot/` out of source control by default and regenerate its cache. Native `.tscn`, `.scn`, `.tres`, and `.res` files do not expose Import dock options.

Change the source asset, import configuration, importer, post-import script, or authored wrapper. Keep hand-authored extensions outside regenerated output. An explicitly requested one-off output patch should identify that reimport or regeneration can overwrite it.

Load imported resources through `ResourceLoader`. Direct file access to their source representation may work in the editor and fail in an exported project.

## Resource sharing

Normal cached loads of a retained path return the same resource. Scene instances also share assets such as meshes and images. Before mutating, choose whether the value should be shared:

- Keep immutable definitions shared; use nodes for transient instance behavior/state.
- Duplicate a resource when one consumer needs a private value.
- Set `resource_local_to_scene = true` before instantiation when every scene instance needs a private copy. Changing the flag does not alter instances already created.

In Godot 4.7, `duplicate(false)` shares nested arrays, dictionaries, and resources. `duplicate(true)` recursively copies containers and local resources; external resources remain shared unless property usage flags override the behavior. `duplicate_deep(...)` exposes subresource modes; copying every external resource can duplicate large assets. Custom resources with required `_init` arguments cannot use these duplication methods successfully.

Emit `changed` for custom-resource mutations when dependents need notification. Save runtime changes into source resources only when persistence is intended.

## Verification and sources

Use [validation](validation.md): inspect structure, import changed assets, and load or instantiate changed scenes/resources. Exercise changed behavior and capture changed appearance.

Official Godot 4.7 sources: [TSCN format](https://docs.godotengine.org/en/4.7/engine_details/file_formats/tscn.html), [imports](https://docs.godotengine.org/en/4.7/tutorials/assets_pipeline/import_process.html), [resources](https://docs.godotengine.org/en/4.7/tutorials/scripting/resources.html), [Node](https://docs.godotengine.org/en/4.7/classes/class_node.html), [NodePath](https://docs.godotengine.org/en/4.7/classes/class_nodepath.html), [Resource](https://docs.godotengine.org/en/4.7/classes/class_resource.html), and [4.7.2 text loader/saver](https://github.com/godotengine/godot/blob/ed1daf0bf001b61586d9930840f2f1394092c079/scene/resources/resource_format_text.cpp).
