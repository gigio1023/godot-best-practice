# GDScript And C#

Use this reference when writing scripts, reviewing Godot syntax, or explaining language choices.

## Contents

- GDScript Defaults
- Common GDScript Patterns
- Script Placement
- Node References
- Process And Physics
- C# Guidance
- When To Read Official Docs

## GDScript Defaults

For new agent-written GDScript:

- Use Godot 4.x syntax.
- Prefer explicit static types for exported APIs, fields, return values, and non-trivial locals.
- Use tabs for indentation unless the project already standardizes otherwise.
- Prefix private helpers and private fields with `_`.
- Keep lifecycle callbacks short; move behavior into named methods.
- Prefer `@export`, `@onready`, `@tool`, and other Godot 4 annotations over Godot 3 style.
- Use `await` for signals/coroutines; do not use old `yield(...)` patterns.

Skeleton:

```gdscript
extends Node

signal completed(result: Dictionary)

@export var enabled: bool = true
@export var speed: float = 240.0

@onready var _timer: Timer = $Timer

var _state: Dictionary = {}

func _ready() -> void:
	_timer.timeout.connect(_on_timer_timeout)

func start(payload: Dictionary) -> void:
	_state = payload.duplicate(true)
	_timer.start()

func _on_timer_timeout() -> void:
	completed.emit(_state)
```

## Common GDScript Patterns

Signals:

```gdscript
button.pressed.connect(_on_button_pressed)
health.depleted.connect(func() -> void:
	queue_free()
)
```

Typed collections:

```gdscript
var scores: Array[int] = []
var by_id: Dictionary[StringName, Node] = {}
```

Enums and match:

```gdscript
enum State { IDLE, MOVING, ATTACKING }

func _set_state(next: State) -> void:
	match next:
		State.IDLE:
			_stop()
		State.MOVING:
			_move()
		_:
			push_warning("Unhandled state: %s" % next)
```

Resources:

```gdscript
extends Resource
class_name ItemDefinition

@export var id: StringName
@export var display_name: String
@export var icon: Texture2D
```

Groups:

```gdscript
for actor in get_tree().get_nodes_in_group(&"damageable"):
	if actor.has_method(&"apply_damage"):
		actor.apply_damage(10)
```

## Script Placement

Use scripts for behavior, not raw data tables. Use custom resources, JSON, CSV, or project-specific data files for large structured data.

Good boundaries:

- `PlayerController.gd`: input and movement orchestration
- `Health.gd`: health state and damage signal emission
- `Inventory.gd`: behavior around item collection
- `ItemDefinition.gd`: reusable item data resource
- `LevelDefinition.tres` or `level_layout.json`: authored data

Avoid:

- one global script controlling unrelated systems
- long `NodePath` chains for every dependency
- scene files containing complex expressions
- side effects in `_init()` that depend on the scene tree

## Node References

Prefer exported references for designer-wired dependencies:

```gdscript
@export var target: Node3D
```

Prefer `@onready` for stable child nodes in the same scene:

```gdscript
@onready var _camera: Camera3D = %Camera3D
```

Use scene-unique names (`%Name`) only when the scene owns the node and the name is intentionally stable.

Avoid brittle absolute paths unless the project has an established convention.

## Process And Physics

- Use `_process(delta)` for visual interpolation, timers, input polling that is not physics-bound, and UI updates.
- Use `_physics_process(delta)` for physics movement and deterministic body updates.
- Use `CharacterBody2D`/`CharacterBody3D` movement APIs rather than manually changing transforms for colliding characters.
- Do not mix physics state changes across both callbacks without a clear reason.

## C# Guidance

Use C# when the project already uses C#, the user asks for it, or the feature needs .NET ecosystem integration.

Defaults:

- Use the .NET build of Godot.
- Follow Godot C# naming conventions and generated API names.
- Use `[Export]` for editor-exposed fields/properties.
- Use partial classes for Godot scripts.
- Check official C# docs for signals, collections, variants, and platform limitations.

Skeleton:

```csharp
using Godot;

public partial class PlayerController : CharacterBody3D
{
    [Export] public float Speed { get; set; } = 6.0f;

    public override void _PhysicsProcess(double delta)
    {
        var direction = Vector3.Zero;
        Velocity = direction * Speed;
        MoveAndSlide();
    }
}
```

## When To Read Official Docs

Read `references/local/official-docs-index.md`, then the relevant official page when touching:

- exported property syntax
- typed GDScript edge cases
- signal connection syntax
- C# signals/collections/variants
- coroutine behavior
- script templates
- warning suppression
- class reference method signatures
