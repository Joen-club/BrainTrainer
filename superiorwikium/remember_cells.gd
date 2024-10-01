extends GameManager

@export var grid: PackedScene
@export var level_initial: int = 1 #Set the inital amount of rows/columns (min 2x2)
var level: int #level adds up more rows and columns (+row/+column per 2 levels)

var input_received: Callable = user_input
var create_next_grid: Callable = _on_next_grid

func start(_new_settings: Dictionary) -> void:
	level = level_initial
	super.start(_new_settings)

func _create_new_game_object() -> void:
	var new_grid = grid.instantiate()

	new_grid.create_grid(level)
	new_grid.connect("input_check", input_received)
	new_grid.connect("next_grid", create_next_grid)
	current_game_object = new_grid
	add_child(new_grid)

func _on_next_grid() -> void:
	level += 1
	"""Add animations"""
	await get_tree().create_timer(0.5).timeout 
	if current_game_object != null:
		current_game_object.queue_free()
	await get_tree().create_timer(0.5).timeout
	
	_create_new_game_object()

func _on_hide_cells_pressed() -> void:
	if current_game_object == null: return
	current_game_object.hide_cells()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start"):
		_on_hide_cells_pressed()

func _calculate_score(correct: bool) -> int:
	return 100 + level*10 if correct else -50 - level*10

func end(finished: bool = false):
	super.end(finished)
	if finished: #To be moved to the parent class
		DataBase.gather_data({"Game_mode": "default", "File_name": file_name})
