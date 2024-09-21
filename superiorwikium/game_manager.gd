extends Node2D

##Submarine for now

##Contains random objects (e.g. two types of submarines or numbers to compare)
@export var executables: Array 

@onready var HUD: Control = $HUD
@onready var game_mode_manager = $GameModeManager
@onready var background = $BackGround
var my_boat: Node2D ##Reference for the end() func

var game_settings: Dictionary = {
	#"Speed_mod": 1,
	#"Object": "res://Assets/Arr1.png",
	#"Color": "?",
	#"BG": null,
	#"Music": null,
	#"Mode": "default",
}

#func _ready() -> void:
	#start()

func start(new_settings: Dictionary = game_settings):
	game_settings = new_settings
	game_mode_manager.game_mode = game_settings["Mode"]
	background.set_BG(game_settings["BG"])
	create_boat()
	HUD.start()

##FOR SUBMARINE FOR NOW
##Picks randomly the type of boat and creates it 
##in the same position as the old one (if exists)
func create_boat(boat = null):
	var new_boat = executables.pick_random().instantiate()
	var input_received = Callable(self, "user_input")
	new_boat.connect("input_check", input_received)
	
	
	if boat != null:
		var old_position = boat.global_position
		new_boat.global_position = old_position
		boat.queue_free()
		
	add_child(new_boat)
	new_boat.setup_sprite_color_and_speed(game_settings["Object"], game_settings["Color"], game_settings["Speed_mod"])
	my_boat = new_boat

func end():
	if my_boat == null: return
	my_boat.queue_free()

func user_input(correct: bool, boat):
	if !correct: 
		game_mode_manager.adjust_score(-200)
	else: 
		game_mode_manager.adjust_score(200)
		create_boat(boat)
	$HUD/InputIndicator.indicate_input(correct)
