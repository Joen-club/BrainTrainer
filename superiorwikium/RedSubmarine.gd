extends "res://Submarine.gd"

func _ready() -> void:
	boat_id = 0
	setup_map(motion_direction)
	super._ready()

func setup_submarine():
	super.setup_submarine()
	correct_button = velocity
