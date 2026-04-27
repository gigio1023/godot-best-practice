# Godot Architecture Patterns

Use this reference when designing or refactoring project structure, scene hierarchy, gameplay systems, or reusable patterns.

## Contents

- Core Mental Model
- Scene Boundaries
- Scene Organization
- Scripts Versus Scenes
- Resources
- Signals
- Groups
- Autoloads
- Input
- Agent-Friendly Patterns
- Version Upgrade Pattern

## Core Mental Model

Godot projects work best when each layer has a clear job:

- Scene: composition, ownership, editable hierarchy.
- Node: runtime object with lifecycle and tree membership.
- Script: behavior attached to a node or resource.
- Resource: reusable data or asset-like configuration.
- Signal: event notification across boundaries.
- Group: role tag and broad discovery mechanism.
- Autoload: global service or persistent session state.
- Project settings: engine-level configuration, input actions, render/physics/export defaults.

## Scene Boundaries

Use scenes for reusable units:

- player character
- enemy/NPC
- UI screen or reusable panel
- interactable object
- level segment
- manager that owns a local subsystem

Prefer small scenes that can be instanced and tested independently. Avoid one huge scene where unrelated systems communicate through long node paths.

## Scene Organization

A common layout:

```text
project.godot
scenes/
  levels/
  actors/
  ui/
scripts/
  systems/
  components/
resources/
  items/
  actors/
addons/
tests/
tools/
```

Follow existing project organization when present. Do not reorganize a project unless the user asked for architecture work.

## Scripts Versus Scenes

Put composition in scenes:

- node hierarchy
- exported dependencies
- reusable editor-authored layout
- animation player tracks

Put behavior in scripts:

- state transitions
- input handling
- AI decisions
- inventory/combat/dialogue rules
- checking and generation tools

Put data in resources or data files:

- item definitions
- enemy stats
- dialogue metadata
- level layout
- tuning values

## Resources

Use custom `Resource` classes for reusable data that benefits from inspector editing and typed references.

Good uses:

- item definitions
- ability definitions
- enemy archetypes
- quest/dialogue data
- tuning profiles
- spawn tables

Avoid using resources for mutable per-instance runtime state unless the sharing semantics are intentional. Resources are reference types.

## Signals

Use signals when the sender should not know its listeners:

- health changed
- button pressed
- quest completed
- inventory changed
- interaction requested
- scene transition requested

Connect signals near the owner that composes the relationship. Do not create hidden global event buses unless the project already uses one.

## Groups

Use groups for:

- broad queries such as `damageable`, `interactable`, `saveable`
- debug overlays
- spawn/route/check markers
- systems that operate on roles rather than specific node paths

Do not use groups as a substitute for explicit dependencies when there is exactly one required object.

## Autoloads

Use autoloads for:

- save system
- audio bus/music coordinator
- scene transition service
- persistent profile/session state
- global configuration access

Avoid autoloads for:

- every gameplay manager by default
- objects that should reset with a level
- dependencies that could be exported or scene-owned

Autoloads are convenient, but they hide lifetime and ordering issues. Prefer regular nodes until a global lifetime is clearly needed.

## Input

Use Input Map actions, not raw key checks spread across scripts.

Good:

```gdscript
Input.is_action_pressed(&"move_left")
```

Avoid:

```gdscript
Input.is_key_pressed(KEY_A)
```

unless implementing a remapping UI or editor/tool behavior.

## Agent-Friendly Patterns

When an AI agent will continue editing the project:

- use stable semantic names for important nodes
- keep scene-owned dependencies explicit
- document generated files and their source data
- avoid hidden editor-only state
- add small smoke scripts for critical scenes
- keep official-doc-sensitive decisions linked to docs or local notes

## Version Upgrade Pattern

When upgrading a Godot project or porting ideas from another engine:

1. Identify the source and target Godot versions before editing.
2. Read the official upgrade notes for changed APIs and defaults.
3. Preserve gameplay behavior and data first.
4. Rebuild scenes and scripts around Godot concepts rather than copying another engine's architecture mechanically.
5. Verify with import, smoke, visual, and export checks appropriate to the changed surface.
