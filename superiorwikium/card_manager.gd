extends Control
"""Прогрессирующая сложность"""
@export var card: PackedScene
@export var seeds: Array = [1,2,3]

@onready var card_container = $HBoxContainer
@onready var HUD = $HUD

var values: Dictionary = {"Left": 0,
						"Right": 0}

var correct_input: String

func start(settings: Dictionary):
	if settings["Seed"] != 0:
		seed(settings["Seed"])
	new_cycle()
	HUD.start()

func new_cycle():
	for child in card_container.get_children():
		child.queue_free()
	create_card("Left")
	create_card("Right")
	determine_greater_value()

func create_card(left_right: String):
	var new_card = card.instantiate()
	card_container.add_child(new_card)
	values[left_right] = new_card.value

func determine_greater_value():
	if values['Left'] > values['Right']:
		correct_input = "Left"
	else: correct_input = "Right"

func _input(event: InputEvent) -> void:
	for action in values.keys(): #Only registering the necessary inputs
		if event.is_action_pressed(action):
			if action == correct_input:
				HUD.adjust_score(200)
			else: HUD.adjust_score(-200)
			new_cycle()

func end(_finished: bool = false) -> void:
	for i in card_container.get_children():
		i.queue_free()
