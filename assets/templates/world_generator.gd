@tool
extends EditorScript

const OUTPUT_SCENE := "res://scenes/world/generated_world.tscn"

func _run() -> void:
	var root := Node3D.new()
	root.name = "GeneratedWorld"

	var packed := PackedScene.new()
	var pack_error := packed.pack(root)
	if pack_error != OK:
		push_error("Failed to pack generated world: %s" % pack_error)
		return

	var save_error := ResourceSaver.save(packed, OUTPUT_SCENE)
	if save_error != OK:
		push_error("Failed to save generated world: %s" % save_error)
		return

	print("Generated %s" % OUTPUT_SCENE)
