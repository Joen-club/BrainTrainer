extends Node2D

@onready var main_bg = $MainBG
@onready var timer = $Timer

##Different particles that float occasionally on the screen
@export var noise: PackedScene

##BG_level from Settings["BG"] Ranges from 0 to 2 (for now) and determines whether
##There will be any BG and what kind of BG
func set_BG(BG_level: int =0):
	match BG_level:
		0: return
		1: 
			set_main_BG()
		2: 
			set_main_BG()
			timer.start(randi()%5+2)

##Function for the general BG
func set_main_BG():
	main_bg.texture = load("res://Assets/Background.webp")
	
	#Not the best implementation
	main_bg.scale = Vector2(0.645, 0.633) 
	main_bg.global_position = Vector2(576.5, 325)

##Function creates different particles floating on the screen 
func _on_timer_timeout() -> void:
	var new_noise = noise.instantiate()
	add_child(new_noise)

func end():
	timer.stop()
	main_bg.texture = null
