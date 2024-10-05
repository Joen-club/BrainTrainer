extends Control


func trainer_chosen(trainer: String):
	get_tree().change_scene_to_file("res://"+trainer+".tscn")
