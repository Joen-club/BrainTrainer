extends Node

@onready var buttons: Control = $Buttons

@export var settings_path: NodePath #Each game has its own settings
@onready var settings = get_node(settings_path)

@export var game_manager_path: NodePath #Each game has its own manager
@onready var game_manager = get_node(game_manager_path)

func start_game():
	change_visibility()
	game_manager.start(settings.settings)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Restart"):
		_on_main_menu_pressed()
		start_game()

#When session is started, Settings, Debug and Start_button are hidden
#When in the main_menu, Game_Manager and Main_menu are hidden
func change_visibility():
	for button in buttons.get_children():
		button.visible = !button.visible
	game_manager.visible = !game_manager.visible
	settings.visible = !settings.visible

func _on_main_menu_pressed() -> void:
	propagate_call("end") #end() informs all the necessary members that session has been stopped
	change_visibility()
	DataBase.clear_database() #Temporary

#Database will not gather info about session if toggled_on = true
func _on_debug_toggled(toggled_on: bool) -> void:
	DataBase.debug = toggled_on


func _on_trainers_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")

func _on_database_pressed() -> void:
	$TextEdit.visible = !$TextEdit.visible
	if not $TextEdit.visible: return
	var file_path = "user://" + game_manager.file_name + ".csv"
	var file = FileAccess.open(file_path, FileAccess.ModeFlags.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		$TextEdit.text = content
	else:
		$TextEdit.text = "No data available."
