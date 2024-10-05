extends Control

class_name Settings

@onready var file_name_node: TextEdit = $DataBaseFileName
#Settings that affect the match
@export var settings: Dictionary = {}

# A dictionary that groups the object, background, and music setting options for easy reference.
# This will be used in a function to dynamically update the settings based on user input.
var setting_dicts: Dictionary = {}

func _ready() -> void:
	settings["File_name"] = file_name_node.text

# Function triggered when an item is selected from an OptionButton node.
# The 'index' is the ID of the selected option, and 'what_setting' is the category (e.g., "Object", "BG", "Music").
# what_setting is binded to the nodes' signals.
# It updates the relevant setting in the 'settings' dictionary based on the user's selection.
func _on_item_selected(index: int, what_setting: String) -> void:
	var new_setting = setting_dicts[what_setting][index]
	settings[what_setting] = new_setting

func _on_data_base_file_name_text_changed() -> void:
	settings["File_name"] = file_name_node.text
	print("This one")
