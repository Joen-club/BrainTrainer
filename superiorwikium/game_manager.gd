extends Node2D

##Submarine for now

##Contains random objects (e.g. two types of submarines)
@export var executables: Array 
@export var file_name: String = "week1"

@onready var HUD: Control = $HUD
@onready var game_mode_manager = $GameModeManager
@onready var background = $BackGround
var my_boat: Node2D ##Current boat object at play

var input_received: Callable = user_input #Each boat connects a signal to this Callable

var game_settings: Dictionary = { #For debug purposes
	#"Speed_mod": 1,
	#"Object": "res://Assets/Arr1.png",
	#"Color": "?",
	#"BG": null,
	#"Music": null,
	#"Mode": "default",
}

func start(new_settings: Dictionary = game_settings):
	game_settings = new_settings
	game_mode_manager.setup_mode(game_settings["Mode"], game_settings["Mixed"])
	background.set_BG(game_settings["BG"])
	create_boat()
	HUD.start()

##FOR SUBMARINE FOR NOW
##Picks randomly the type of boat and creates it 
##in the same position as the old one (if exists)
func create_boat():
	var new_boat = executables.pick_random().instantiate()
	new_boat.connect("input_check", input_received)
	
	if my_boat != null:
		var old_position = my_boat.global_position
		new_boat.global_position = old_position
		my_boat.queue_free()

	my_boat = new_boat
	add_child(new_boat)
	new_boat.setup_sprite_color_and_speed(game_settings["Object"], game_settings["Color"], game_settings["Speed_mod"])

#Can be emitted by either a call from a main node or a signal from the HUD
func end(finished: bool = false):
	if finished:
		game_mode_manager.deliver_data(file_name)
		game_mode_manager.end() #Stops the timer when the HUD signal is emitted

	if my_boat == null: return
	my_boat.queue_free()

func user_input(correct: bool):
	if !correct: 
		game_mode_manager.adjust_score(-200)
	else: 
		game_mode_manager.adjust_score(200)
		create_boat()
	$HUD/InputIndicator.indicate_input(correct)
