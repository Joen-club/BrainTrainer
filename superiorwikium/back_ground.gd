extends Node2D

@onready var main_bg = $MainBG
@onready var timer = $Timer

@export var noise: PackedScene

func set_BG(BG_level: int =0):
	match BG_level:
		0: return
		1: 
			set_main_BG()
		2: 
			set_main_BG()
			timer.start(randi()%5+2)

func set_main_BG():
	main_bg.texture = load("res://Assets/Background.webp")
	main_bg.scale = Vector2(0.645, 0.633)
	main_bg.global_position = Vector2(576.5, 325)

func _on_timer_timeout() -> void:
	var new_noise = noise.instantiate()
	add_child(new_noise)
