extends Node

@onready var _score_label: Label = $HUD/Score


func _ready() -> void:
	$Player.score_changed.connect(_on_player_score_changed)


func _on_player_score_changed(score: int) -> void:
	_score_label.text = str(score)
