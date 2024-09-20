extends Node2D

@onready var HUD = %HUD
var game_mode: String = "default" #speed, accuracy or default

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
