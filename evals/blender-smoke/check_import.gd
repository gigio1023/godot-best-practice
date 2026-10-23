extends SceneTree
## Check an imported GLB through a game-owned scene before and after reimport.


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var arguments: PackedStringArray = OS.get_cmdline_user_args()
	if arguments.size() != 1 or arguments[0] not in ["initial", "reimport"]:
		push_error("Expected stage initial or reimport")
		quit(1)
		return
	var stage: String = arguments[0]
	var packed: PackedScene = load("res://wrapper.tscn") as PackedScene
	if not _require(packed != null, "Wrapper must load as PackedScene"):
		quit(1)
		return
	var wrapper: Node = packed.instantiate()
	root.add_child(wrapper)
	var valid: bool = _check_wrapper(wrapper)
	valid = _check_exported_timing() and valid
	valid = _check_model(wrapper, stage) and valid
	wrapper.queue_free()
	if valid:
		print("PASS stage=", stage, " geometry, axis, animation, wrapper")
	quit(0 if valid else 1)


func _check_wrapper(wrapper: Node) -> bool:
	if not _require(wrapper.get_meta("smoke_owner", "") == "game", "Wrapper metadata must survive"):
		return false
	var marker: Marker3D = wrapper.get_node_or_null("GameOwnedMarker") as Marker3D
	if not _require(marker != null, "Game-owned child must survive"):
		return false
	if not _require(marker.position.is_equal_approx(Vector3(4, 5, 6)), "Child transform must survive"):
		return false
	print("WRAPPER metadata=game child=GameOwnedMarker position=", marker.position)
	return true


func _check_exported_timing() -> bool:
	var file: FileAccess = FileAccess.open("res://assets/fixture.glb", FileAccess.READ)
	if not _require(file != null, "Exported GLB must be readable"):
		return false
	if not _require(file.get_buffer(4).get_string_from_ascii() == "glTF", "Expected a GLB header"):
		return false
	file.seek(12)
	var chunk_length: int = file.get_32()
	if not _require(file.get_32() == 0x4e4f534a, "Expected a JSON chunk"):
		return false
	var parsed: Variant = JSON.parse_string(file.get_buffer(chunk_length).get_string_from_utf8())
	file.close()
	if not _require(parsed is Dictionary, "GLB JSON must parse"):
		return false
	var document: Dictionary = parsed
	var animations: Array = document.get("animations", [])
	if not _require(animations.size() == 1, "Expected one exported animation"):
		return false
	var animation: Dictionary = animations[0]
	var samplers: Array = animation["samplers"]
	for sampler: Dictionary in samplers:
		var accessor: Dictionary = document["accessors"][sampler["input"]]
		var first_time: float = accessor["min"][0]
		var last_time: float = accessor["max"][0]
		print("GLB SAMPLER first=", first_time, " last=", last_time)
		if not _require(is_equal_approx(first_time, 1.0 / 24.0), "Exported first sample time changed"):
			return false
		if not _require(is_equal_approx(last_time, 25.0 / 24.0), "Exported last sample time changed"):
			return false
	return _require(not samplers.is_empty(), "Exported animation samplers are missing")


func _check_model(wrapper: Node, stage: String) -> bool:
	var meshes: Array[Node] = wrapper.find_children("*", "MeshInstance3D", true, false)
	var players: Array[Node] = wrapper.find_children("*", "AnimationPlayer", true, false)
	if not _require(meshes.size() == 1 and players.size() == 1, "Expected one mesh and AnimationPlayer"):
		return false
	var mesh: MeshInstance3D = meshes[0] as MeshInstance3D
	var player: AnimationPlayer = players[0] as AnimationPlayer
	var width: float = 2.0 if stage == "initial" else 3.0
	var bounds: AABB = mesh.mesh.get_aabb()
	print("MESH stage=", stage, " size=", bounds.size, " position=", mesh.global_position)
	if not _require(bounds.size.is_equal_approx(Vector3(width, 2, 2)), "Imported mesh dimensions changed"):
		return false
	if not _require(mesh.global_position.is_equal_approx(Vector3(0, 1, 0)), "Blender Z must map to Godot Y"):
		return false
	if not _require(mesh.global_basis.is_equal_approx(Basis.IDENTITY), "Imported object scale and rotation changed"):
		return false
	if not _require(player.has_animation("Slide"), "Slide animation is missing"):
		return false
	var clip: Animation = player.get_animation("Slide")
	var track: int = clip.find_track(NodePath("FixtureCube"), Animation.TYPE_POSITION_3D)
	if not _require(track >= 0, "Cube position track is missing"):
		return false
	var keys: int = clip.track_get_key_count(track)
	if not _require(keys >= 2, "Position track must contain its endpoints"):
		return false
	var first_time: float = clip.track_get_key_time(track, 0)
	var last_time: float = clip.track_get_key_time(track, keys - 1)
	print("CLIP length=", clip.length, " tracks=", clip.get_track_count(), " first=", first_time, " last=", last_time)
	# Godot adds the initial value at t=0 while retaining the exported endpoint.
	if not _require(is_zero_approx(first_time), "Imported initial key time changed"):
		return false
	if not _require(is_equal_approx(last_time, 25.0 / 24.0), "Last key time changed"):
		return false
	if not _require(is_equal_approx(clip.length, last_time), "Clip length must include its exported time origin"):
		return false
	player.play("Slide")
	player.seek(clip.length, true)
	print("ENDPOINT position=", mesh.global_position)
	return _require(mesh.global_position.is_equal_approx(Vector3(width, 1, 0)), "Animation endpoint changed")


func _require(condition: bool, message: String) -> bool:
	if not condition:
		push_error(message)
	return condition
