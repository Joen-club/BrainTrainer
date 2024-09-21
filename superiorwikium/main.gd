extends Node

@onready var settings = $Settings
@onready var game_manager = $GameManager

func start_game():
	game_manager.visible = true
	settings.visible = false
	$Start_button.hide()
	game_manager.start(settings.settings)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Restart"):
		_on_main_menu_pressed()
		start_game()

func _on_main_menu_pressed() -> void:
	propagate_call("end")
	game_manager.visible = false
	settings.visible = true
	$Start_button.show()
