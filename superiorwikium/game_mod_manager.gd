extends Node2D

@onready var HUD = %HUD
@onready var timer = $Timer
@onready var mode_indicator = $Game_Mode_Indicator

var game_mode: String = "default" #speed, accuracy or default
var mixed_mode: bool = false
@export var chance: int = 50 #Greater value means more frequent chance of modes if mixed is on, 

func setup_mode(new_mode: String, mixed: bool = false):
	game_mode = new_mode
	mode_indicator.text = game_mode
	mixed_mode = mixed
	if mixed: mixed_mode_toggled()
	#if mixed != mixed_mode:

func adjust_score(new_score):
	match game_mode:
		"default":
			HUD.adjust_score(new_score)
		"speed":
			speed_mode(new_score)
		"accuracy":
			accuracy_mode(new_score)

func speed_mode(new_score):
	if new_score < 0:
		new_score = 0
	HUD.adjust_score(new_score)

func accuracy_mode(new_score):
	HUD.adjust_score(new_score)
	if new_score < 0:
		HUD.game_over()

#Delete this func?
func mixed_mode_toggled():
	#mixed_mode = true
	timer.start(randi()% 4+2)
	#else: timer.stop()

func end():
	timer.stop()

func _on_timer_timeout() -> void:
	var random_number = randi_range(0, 100)
	if random_number < chance:
		var game_modes = ["default", "speed", "accuracy"]
		game_modes.erase(game_mode)
		setup_mode(game_modes.pick_random(), mixed_mode)

func deliver_data():
	DataBase.gather_data({"Game_mode": "mixed"}) if mixed_mode else DataBase.gather_data({"Game_mode": game_mode})
