# Architecture and Ownership

Choose boundaries from lifetime, composition, and data sharing. A level can connect its player and HUD because it owns both; the player need not search `/root/Main/HUD`.

## Godot primitives

| Primitive | Responsibility |
| --- | --- |
| Scene | Reusable composition, editable hierarchy, local subsystem |
| Node | Runtime lifecycle and scene-tree behavior |
| Script | Rules, orchestration, editor/runtime tools |
| Resource | Reusable typed data and asset configuration |
| Signal | Event notification without coupling the sender to listeners |
| Group | Role tags and many-object discovery |
| Autoload | State or services that must survive scene changes |
| Project setting/input action | Engine configuration and named input intent |

A script or custom type is enough when a node hierarchy adds no useful composition. A scene fits actors, panels, level chunks, effects, and coordinators that benefit from instancing and editor authoring. Keep the repository's existing layout unless restructuring is part of the task.

## Ownership decisions

Resolve who creates and frees the object, which scene composes its dependencies, whether data belongs to one instance or the session, and whether a designer must wire it. Check that renaming, reparenting, instancing, or inheritance will preserve the relationship.

- Connect signals where both endpoints are known. Handle lifecycle-sensitive subscriptions deliberately.
- Use exported references for required designer-wired dependencies and resources for shared definitions.
- Keep scene-unique names inside the scene that owns them.
- Use groups for a changing set of roles, not a hidden lookup for one required object.
- Add an autoload only when cross-scene continuity is required. Local coordinators, static helpers, shared resources, and ordinary nodes often suffice.
- Persist explicit save data rather than arbitrary live nodes.

## Processing and input

Keep simulation state independent of UI presentation. Use `_physics_process` for collision-aware movement, `_process` for frame-dependent presentation, events for discrete input, and polling for continuous state. Gameplay should use named Input Map actions; raw key codes fit remapping and tool code.

Check process modes, pause behavior, tree order, deferred calls, and signal timing where they affect correctness. Source-file order does not establish callback order.

## Generated content

Use an explicit pipeline: authored data or Resource, then generator/editor tool, then generated scene/resource. Give inputs semantic identifiers and relationships, mark generated output, and preserve a reproducible route from source to artifact. Put manual intent into source or separate authored extensions before regeneration.

Load generated output through Godot and check required nodes, owners, paths, groups, and resources. Spatial results also need visual or runtime evidence. [Scenes and resources](scenes-and-resources.md) covers serialization, imports, and shared-resource behavior.

## Official references

[Scene organization](https://docs.godotengine.org/en/4.7/tutorials/best_practices/scene_organization.html), [scenes versus scripts](https://docs.godotengine.org/en/4.7/tutorials/best_practices/scenes_versus_scripts.html), [autoloads versus regular nodes](https://docs.godotengine.org/en/4.7/tutorials/best_practices/autoloads_versus_regular_nodes.html), [node alternatives](https://docs.godotengine.org/en/4.7/tutorials/best_practices/node_alternatives.html), [project organization](https://docs.godotengine.org/en/4.7/tutorials/best_practices/project_organization.html), [SceneTree](https://docs.godotengine.org/en/4.7/tutorials/scripting/scene_tree.html), and [input events](https://docs.godotengine.org/en/4.7/tutorials/inputs/inputevent.html).
