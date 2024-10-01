extends GameManager
"""Прогрессирующая сложность???"""
@export var card: PackedScene
@export var seeds: Array = [1,2,3]

@onready var card_container = $HBoxContainer

#Dictionary contains only two keys, with values being assigned via create_card() func
var values: Dictionary = {"Left": 0,
						"Right": 0}

var correct_input: String

func start(settings: Dictionary):
	if settings["Seed"] is int: #If not int, then the seed is Random
		seed(settings["Seed"])
	super.start(settings)

func _create_new_game_object():
	for child in card_container.get_children():
		child.queue_free()
	create_card("Left")
	create_card("Right")
	determine_greater_value()

func create_card(left_or_right: String):
	var new_card = card.instantiate()
	card_container.add_child(new_card)
	values[left_or_right] = new_card.value

func determine_greater_value():
	if values['Left'] > values['Right']:
		correct_input = "Left"
	else: correct_input = "Right"

func _input(event: InputEvent) -> void:
	for action in values.keys(): #Only registering the necessary inputs ("Right" or "Left")
		if event.is_action_pressed(action):
			var is_pressed_correctly = (action == correct_input) #Returns True or False
			$HUD/InputIndicator.indicate_input(is_pressed_correctly)
			super.user_input(is_pressed_correctly)

func _after_user_input(_correct: bool):
	_create_new_game_object()

func end(finished: bool = false) -> void:
	for i in card_container.get_children():
		i.queue_free()
	if finished: #To be moved to the parent class
		DataBase.gather_data({"Game_mode": game_settings["Seed"], "File_name": file_name})
