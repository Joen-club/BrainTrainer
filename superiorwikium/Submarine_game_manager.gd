extends GameManager

##Submarine for now

##Contains random objects (e.g. two types of submarines)
@export var executables: Array 

@onready var game_mode_manager = $GameModeManager
@onready var background = $BackGround
@onready var touch_buttons = $TouchButtons

var input_received: Callable = user_input #Each boat connects a signal to this Callable

func start(new_settings: Dictionary = game_settings):
	
	background.set_BG(new_settings["BG"])
	super.start(new_settings)
	game_mode_manager.setup_mode(new_settings["Mode"], new_settings["Mixed"])

##Picks randomly the type of boat and creates it 
##in the same position as the old one (if exists)
func _create_new_game_object():
	var new_boat = executables.pick_random().instantiate()
	new_boat.connect("input_check", input_received)
	
	if current_game_object != null:
		var old_position = current_game_object.global_position
		new_boat.global_position = old_position
		current_game_object.queue_free()

	current_game_object = new_boat
	add_child(new_boat)
	new_boat.setup_sprite_color_and_speed(game_settings["Object"], game_settings["Color"], game_settings["Speed_mod"], (game_mode_manager.game_mode if game_mode_manager.game_mode != "" else game_settings["Mode"]))

#Can be emitted by either a call from a main node or a signal from the HUD
func end(finished: bool = false):
	super.end(finished)
	if finished:
		game_mode_manager.deliver_data(file_name)
		game_mode_manager.end() #Stops the timer when the HUD signal is emitted

func touch_button_pressed(action: String):
	current_game_object._input(action)

#func connect_touch_buttons():
	#var new_call = Callable(self, "new_input")
	#for i in touch_buttons.get_children():
		#i.connect("pressed", input_received)

func user_input(correct: bool):
	super.user_input(correct)
	$HUD/InputIndicator.indicate_input(correct)

func _after_user_input(correct: bool):
	if !correct:return
	_create_new_game_object()

func adjust_score(score_delta):
	game_mode_manager.adjust_score(score_delta)

func _on_game_mode_manager_mode_changed(new_mode) -> void:
	current_game_object.show_mode(new_mode)
