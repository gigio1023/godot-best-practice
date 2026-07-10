# Godot Architecture And Ownership

Use this reference when designing or refactoring scene boundaries, gameplay
systems, dependencies, shared data, or global state.

## Contents

- Assign each concern to a Godot primitive
- Design from ownership and lifetime
- Compose scenes and scripts
- Connect systems without hidden coupling
- Keep processing and input explicit
- Generate content without losing authorship

## Assign Each Concern To A Godot Primitive

| Primitive | Use it for | Avoid using it as |
| --- | --- | --- |
| Scene | Reusable composition, editable hierarchy, ownership, local subsystem boundary | A dump of unrelated global systems |
| Node | Runtime lifecycle and scene-tree behavior | A container for every piece of data |
| Script | Behavior, orchestration, editor/runtime tools | A hand-built replacement for large declarative scenes |
| Resource | Reusable typed data and asset-like configuration | Unintentional shared mutable instance state |
| Signal | Event notification where the sender should not know listeners | A global event bus by default |
| Group | Broad role tags and many-object discovery | A hidden lookup for one required dependency |
| Autoload | Truly cross-scene lifetime, persistent session state, broad service | The default home for every manager |
| Project setting/input action | Engine-wide configuration and named input intent | Per-instance gameplay state |

## Design From Ownership And Lifetime

Ask in order:

1. Who creates and frees this object?
2. Which scene owns both sides of the relationship?
3. Does the data belong to one runtime instance, many instances, or the whole
   session?
4. Must a designer edit the relationship in the inspector?
5. Will a rename, reparent, instanced scene, or inherited scene break the link?

Keep dependencies inside the smallest owner that can compose them. A level scene
can connect its player and HUD; the player should not search `/root/Main/HUD`.
Promote a service to an autoload only when its lifetime and access are genuinely
broader than a scene.

## Compose Scenes And Scripts

Use scenes for reusable concepts with meaningful node hierarchies: actors,
interactables, UI panels, level chunks, effects, and local system coordinators.
Use scripts for rules, state transitions, input, movement, AI decisions, and
generation/validation tools.

Prefer a scene when editor composition, instancing, serialization, or engine-side
batch construction matters. Prefer a script or named custom type when the value
is primarily behavior and a node hierarchy would be ceremony.

Follow the existing project layout. Do not reorganize a working repository into
`scenes/`, `scripts/`, and `resources/` merely because that split is common.

## Connect Systems Without Hidden Coupling

- Connect a signal where the receiver and emitter are both known. Disconnect or
  bind lifecycle-sensitive connections deliberately.
- Use exported references for required designer-wired dependencies and typed
  resources for reusable configuration.
- Use scene-unique names only within their owning scene.
- Use groups when a system intentionally operates over a changing set of roles.
- Prefer small local coordinators over a global event bus or service locator.
- Keep save/load boundaries explicit. Persist data, not arbitrary live nodes.

Autoloads fit save/profile state, scene transitions, or audio/session services
only when cross-scene continuity is required. Static helper functions, shared
resources, or regular nodes often solve reuse without global state.

## Keep Processing And Input Explicit

- Put collision-aware movement and physics mutations in `_physics_process`.
- Put frame interpolation, presentation, and non-physics updates in `_process`.
- Prefer event callbacks for discrete input; use polling when continuous state
  is the actual requirement.
- Use named Input Map actions for gameplay. Raw key codes belong in remapping or
  tool code, not scattered through gameplay scripts.
- Separate simulation state from UI presentation so UI changes do not become
  gameplay dependencies.

Check process modes, pause behavior, scene-tree order, deferred calls, and signal
timing when lifecycle affects correctness. Do not infer callback order from file
layout.

## Generate Content Without Losing Authorship

For large or repetitive scenes, keep an explicit source of truth:

```text
data or Resource -> generator/editor tool -> generated scene/resource
```

Use semantic identifiers and relationships rather than opaque coordinate dumps.
Mark generated outputs and preserve a deterministic path back to their source.
Put manual intent in the source data or generator before regenerating.

Validate generated content by loading it through Godot, checking required nodes,
owners, paths, groups, and resources, and collecting visual/runtime evidence when
spatial meaning matters.

## Official Reading Map

- `tutorials/best_practices/scene_organization.rst`
- `tutorials/best_practices/scenes_versus_scripts.rst`
- `tutorials/best_practices/autoloads_versus_regular_nodes.rst`
- `tutorials/best_practices/node_alternatives.rst`
- `tutorials/best_practices/godot_interfaces.rst`
- `tutorials/best_practices/project_organization.rst`
- `tutorials/scripting/scene_tree.rst`
- `tutorials/scripting/groups.rst`
- `tutorials/scripting/resources.rst`
- `tutorials/inputs/inputevent.rst`
