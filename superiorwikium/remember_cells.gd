extends Control

"""Add main node, set up HUD."""

@export var grid: PackedScene
@export var level: int = 10

var current_grid = null

var create_next_grid: Callable = _on_next_grid

func _ready() -> void:
	create_new_grid()

func create_new_grid(prev_specs: Array =[]):
	var new_grid = grid.instantiate()
	
	if prev_specs.size() != 0:
		new_grid.rows = prev_specs[0]
		new_grid.columns = prev_specs[1]

	new_grid.create_grid(level)
	new_grid.connect("next_grid", create_next_grid)
	current_grid = new_grid
	add_child(new_grid)

func _on_next_grid():
	var prev_specs = [current_grid.rows, current_grid.columns]
	level += 1
	await get_tree().create_timer(0.5).timeout
	current_grid.queue_free()
	await get_tree().create_timer(0.5).timeout
	create_new_grid(prev_specs)

func _on_start_game_pressed() -> void:
	current_grid.start_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start"):
		current_grid.start_game()
