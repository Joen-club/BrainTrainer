extends "res://Submarine.gd"

func _ready() -> void:
	boat_id=1
	setup_map(direction)
	super._ready()

func setup_submarine():
	super.setup_submarine()
	correct_button = boat_rotation
