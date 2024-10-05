extends Node2D

@onready var HUD = %HUD
@onready var timer = $Timer

var game_mode: String = "" #speed, accuracy or default
var mixed_mode: bool = false
@export var chance: int = 50 #Greater value means more frequent chance of modes if mixed is on, 
var change_count: int = 0

signal mode_changed

func setup_mode(new_mode: String, mixed: bool = false):
	emit_signal("mode_changed", new_mode)
	game_mode = new_mode
	mixed_mode = mixed
	
	if mixed: timer.start(randi()% 4+2)

func adjust_score(new_score):
	match game_mode:
		"default":
			HUD.adjust_score(new_score)
		"speed":
			speed_mode(new_score)
		"accuracy":
			accuracy_mode(new_score)

#Mistakes do not deduct points
func speed_mode(new_score):
	if new_score < 0:
		new_score = 0
	HUD.adjust_score(new_score)

#1 mistake = game_over
func accuracy_mode(new_score):
	HUD.adjust_score(new_score)
	if new_score < 0:
		HUD.game_over()

func end():
	timer.stop()

#Randomly changes a game_mode
func _on_timer_timeout() -> void:
	var random_number = randi_range(0, 100)
	if random_number < chance:
		change_count += 1 
		var game_modes = ["default", "speed", "accuracy"]
		game_modes.erase(game_mode) #Current mode can not be chosen
		setup_mode(game_modes.pick_random(), mixed_mode)

func deliver_data(file_name: String):
	DataBase.gather_data({"Game_mode": "mixed", "File_name": file_name, "Mode_changed": change_count}) if mixed_mode else DataBase.gather_data({"Game_mode": game_mode, "File_name": file_name})
