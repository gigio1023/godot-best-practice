# Scenes and Resources

Use this reference before changing `.tscn`, `.tres`, imported assets, or
generated scene output. Preserve Godot's serialization contract and the
project's actual source of truth.

## Contents

- Choose the source of truth
- Preserve text resource structure
- Distinguish IDs, paths, parents, and owners
- Decide whether to edit directly
- Respect generated and imported ownership
- Control resource sharing and mutation
- Validate the result
- Official Godot 4.7 sources

## Choose the source of truth

Classify the target before editing it:

| Target | Treat as source | Change through |
| --- | --- | --- |
| Hand-authored `.tscn` or `.tres` | The text resource itself | A small direct edit or a Godot save |
| Generated scene or resource | Generator plus its input data | Change inputs or generator, then regenerate |
| Imported image, audio, model, or scene | Source asset plus import configuration | Change source, import settings, importer, or post-import logic |
| `.godot/imported/` content | Derived cache | Regenerate; never repair it by hand |
| Binary `.scn` or `.res` | Godot-owned serialization | Load and save through Godot |

Inspect nearby scripts, build tasks, documentation, file headers, and version
history when ownership is unclear. Stop before overwriting a generated or
imported artifact whose authoritative input cannot be identified.

## Preserve text resource structure

### TSCN order

Keep the five principal `.tscn` sections in this order:

1. File descriptor: `[gd_scene ...]`.
2. External resources: `[ext_resource ...]`.
3. Internal resources: `[sub_resource ...]`.
4. Scene nodes: `[node ...]`.
5. Persistent signal connections: `[connection ...]`.

Keep `[editable path="..."]` records, when present for editable instances,
after the connection section. Keep parents before their descendants.

### TRES order

Keep a `.tres` file in this order:

1. File descriptor: `[gd_resource type="..." ...]`.
2. External resources.
3. Internal resources.
4. Main resource: `[resource]` followed by its stored properties.

Define every subresource before a property refers to it. A forward
`SubResource("id")` reference is a parse error.

### Format and headers

Recognize the normal Godot 4 string-ID form:

```text
[gd_scene format=3 uid="uid://cecaux1sm7mo0"]
[gd_resource type="Resource" format=3 uid="uid://dww8o7hsqrhx5"]
```

Treat `format=3` as the usual Godot 4-compatible text format. In Godot 4.7,
the saver can emit `format=4` when a resource needs `PackedVector4Array` or a
base64-encoded `PackedByteArray` larger than 64 bytes. Preserve a valid
`format=4` header; never downgrade or normalize it by hand.

Ignore a legacy `load_steps=<int>` field when reading a scene or resource.
Godot 4.6 deprecated it and current saves omit it. Do not add or recalculate it.

Expect Godot to discard comments, insignificant whitespace, and properties
equal to their defaults when it saves the file. Do not encode durable intent in
comments or formatting that a save will erase.

Do not place GDScript declarations, calls, or expressions in a text resource.
Use serialized Variant values and the section forms already present in the
file.

## Distinguish IDs, paths, parents, and owners

### Resource identity

Keep these namespaces separate:

- Header and external-resource `uid="uid://..."` values identify files across
  path moves. They are string UIDs managed by Godot.
- An external resource's `id="..."` is local to the current text file. Refer
  to it with `ExtResource("...")`.
- A subresource's `id="..."` is also local to the current text file. Refer to
  it with `SubResource("...")`.
- External-resource and subresource IDs use separate namespaces, so the same
  string may legally occur in both.
- A node's integer `unique_id` is neither a resource UID nor a resource ID.
  Godot uses it to retain node identity across moves and renames.

Expect node `unique_id` only in scenes saved by Godot 4.6 or later. Preserve an
existing value. Do not fabricate missing values in an older scene merely for
uniformity; let a Godot save assign them when needed.

Preserve each external resource's `type`, `uid`, `path`, and local `id` as one
coherent record. Godot normally saves `res://` paths; paths relative to the
`.tscn` are also valid. If an ID changes, update every matching reference in
the same namespace. If a file moves, prefer a Godot-managed move so UID and
path metadata remain coherent.

### Node relationships

Do not confuse these fields:

| Field | Meaning |
| --- | --- |
| First `[node]` | The single scene root; omit `parent` |
| `parent="."` | A direct child of the scene root |
| `parent="A/B"` | A descendant whose parent path starts below the scene root; omit the root name |
| `owner="..."` | The ancestor whose packed scene saves the node; not the tree parent |
| `NodePath("...")` | A property-level reference resolved relative to the node that stores it |

Keep exactly one root. Keep `parent` paths rooted at the scene root but written
without the root's name. Preserve a non-root `owner` when it marks ownership by
an instanced or nested scene. When `owner` is omitted for an ordinary child,
the text loader assigns the scene root as owner.

When constructing nodes through code, set the owner to the current scene root
after adding a child if the node must be packed and saved. The owner must be an
ancestor. A child without the required owner may exist at runtime or in the
viewport yet disappear from the saved `PackedScene`.

Resolve `NodePath` from the node property that contains it, not from the file or
scene root. Interpret `NodePath(".")` as the current node,
`NodePath("")` as no node, and `..` as the parent. Preserve `:property` and
component suffixes such as `NodePath("Mesh:scale.x")`.

## Decide whether to edit directly

Edit text directly only when all of these conditions hold:

- The file is hand-authored and text-based.
- The change is small and follows an existing serialized pattern.
- The affected IDs, paths, owners, and references are easy to enumerate.
- The edit does not rewrite imported, inherited, or generated content.
- A later import and load check can verify it.

Prefer a Godot save or a deterministic generator when any of these conditions
hold:

- Add, remove, or reparent many nodes.
- Change nested-scene ownership, inherited overrides, editable instances, or
  persistent connections.
- Create many resource IDs or cross-references.
- Change animation tracks, mesh arrays, large packed arrays, or other dense
  serialization.
- Touch binary `.scn` or `.res` files.
- Repetition makes a hand edit difficult to review or reproduce.

For a direct edit, preserve unrelated IDs and ordering, update all references,
and keep the diff narrow. Reopen or resave through the target Godot version
when canonical serialization matters.

## Respect generated and imported ownership

For generated output, find the generator and input data first. Move the desired
change upstream, regenerate once, and review the output diff. Keep hand-authored
extensions in separate scenes, resources, or override data when regeneration
would otherwise erase them. Patch generated output directly only for an
explicit one-off request, and report that regeneration can overwrite it.

For imported assets:

- Commit the source asset and its adjacent `<asset>.import` sidecar. The
  sidecar stores import configuration and important metadata.
- Do not commit or edit `.godot/` by default. Treat `.godot/imported/` files as
  disposable derived artifacts; deletion causes reimport.
- Change the source asset, import settings, import plugin, post-import script,
  or source-controlled override instead of changing imported cache output.
- Remember that native `.tscn`, `.scn`, `.tres`, and `.res` files do not expose
  import options in the Import dock.
- Load imported resources through `ResourceLoader`; direct file access to the
  source may work in the editor and fail after export.

## Control resource sharing and mutation

Assume resources are shared references. Loading the same path again returns
the cached instance, and scene instances normally share images, meshes, and
other resources. Mutating shared data can therefore change every consumer.

Use this decision rule before mutation:

- Keep immutable definitions shared.
- Put per-instance runtime state on nodes when it is behavior or transient
  state rather than reusable data.
- Duplicate a resource before changing it when one consumer needs a private
  value.
- Set `resource_local_to_scene = true` in the source before scene instantiation
  when each scene instance must receive its own resource copy. Changing this
  flag later does not affect copies already created.

Choose duplication depth deliberately. `duplicate(false)` shares nested arrays,
dictionaries, and resources. `duplicate(true)` recursively duplicates
containers and local subresources. Use `duplicate_deep(...)` only when its
explicit subresource mode is required; duplicating all external subresources
can copy large assets unexpectedly.

For custom resources, emit `changed` when a meaningful runtime mutation must
notify dependents. Do not save transient mutations back into shared source
resources unless persistence is the requested outcome.

## Validate the result

Apply the evidence ladder in `validation.md`. At minimum, inspect the final
structure and references, import changed assets, and load or instantiate every
changed scene or resource. Add runtime and visual evidence when behavior or
appearance changed. Report any check that could not run instead of treating
static inspection as a pass.

## Official Godot 4.7 sources

Recheck these files within `godotengine/godot-docs` when updating
version-sensitive rules:

- `engine_details/file_formats/tscn.rst`
- `tutorials/assets_pipeline/import_process.rst`
- `tutorials/scripting/resources.rst`
- `classes/class_node.rst`
- `classes/class_resource.rst`

Recheck these files within `godotengine/godot` for implementation details:

- `scene/resources/resource_format_text.h`
- `scene/resources/resource_format_text.cpp`
- `scene/resources/packed_scene.cpp`
- `doc/classes/Node.xml`
- `doc/classes/Resource.xml`
