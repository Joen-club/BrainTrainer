extends Settings

#Options for different sprites/objects. Array type for keys.
var object_IDs: Dictionary = {
	0: ["res://Assets/Arr1.png", "res://Assets/Arr1.png"], #"Arrows"
	1: ["res://Assets/Circle.png", "res://Assets/Arr2.png"], #Circle and Arrow
	2: [],
}

#Options for different backgrounds .
# The key is the background ID, and the value is a reference to a background asset
var BG_IDs: Dictionary = {
	0: 0,
	1: 1,
	2: 2,
}

var color_IDs: Dictionary = {
	0: [Color(1,0,0), Color(1, 1, 0)],
	1: [Color(1,1,1), Color(1,1,1)],
	2: [Color(0, 0, 1), Color(0.1, 0.5, 0.5)]
}

#Options for different music
var music_IDs: Dictionary = {
	0: null,
	1: "Path",
	2: "Path2?",
}

#Options for different modes for Game_Mode_Magager node
var mode_IDs: Dictionary = {
	0: "default",
	1: "accuracy",
	2: "speed",
}

func _ready():
	setting_dicts = {
		"BG": BG_IDs,
		"Object": object_IDs, 
		"Music": music_IDs,
		"Mode": mode_IDs,
		"Color": color_IDs,}

#func _on_item_selected(index: int, what_setting: String) -> void:
	#super._on_item_selected(index, what_setting)

func _on_spin_box_value_changed(value: float) -> void:
	settings["Speed_mod"] = value

func _on_mixed_toggled(toggled_on: bool) -> void:
	settings["Mixed"] = toggled_on
