extends Node

class_name GameManager

@onready var HUD: Control = $HUD
@export var game_settings: Dictionary
var current_game_object
@export var file_name: String = "week1"

func start(settings: Dictionary):
	game_settings = settings
	HUD.start()
	_create_new_game_object()

func _create_new_game_object():
	# Abstract method to be implemented in subclasses
	pass

func user_input(correct: bool):
	var score_delta = _calculate_score(correct)
	adjust_score(score_delta)
	_after_user_input(correct)

#Handles specific progress-logic after input depending on a game
func _after_user_input(_correct: bool):
	# Abstract method to be implemented in subclasses
	pass

func adjust_score(score_delta: int):
	HUD.adjust_score(score_delta)

func end(_finished: bool = false):
	if current_game_object != null:
		current_game_object.queue_free()
	# Additional cleanup if necessary

func _calculate_score(correct: bool) -> int:
	# Default score calculation; can be overridden
	return 200 if correct else -200

func _input(_event: InputEvent) -> void:
	# Default input handling; can be overridden
	pass
