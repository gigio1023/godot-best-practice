extends Node

signal score_changed(score: int)

var _score := 0


func add_point() -> void:
	_score += 1
	get_node("/root/Main/HUD/Score").text = str(_score)
