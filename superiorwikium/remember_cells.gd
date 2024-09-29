extends Control

"""Add main node, set up HUD."""

@export var grid: PackedScene
@export var level_initial: int = 1
@export var file_name: String = "week1"
var level: int 

@onready var HUD = $HUD

var current_grid = null
var input_received: Callable = user_input
var create_next_grid: Callable = _on_next_grid

func start(_new_settings: Dictionary) -> void:
	level = level_initial
	#var row: int = 0
	#var column: int = 0
	#for  i in level-2:
		#if level <=0: break
		#if i %2 == 0:
			#row +=1
		#else: column +=1
		#print([2+row, 2+column])
	create_new_grid()
	HUD.start()

func create_new_grid() -> void:
	var new_grid = grid.instantiate()
	
	#if prev_specs.size() != 0:
		#new_grid.rows = prev_specs[0]
		#new_grid.columns = prev_specs[1]

	new_grid.create_grid(level)
	new_grid.connect("input_check", input_received)
	new_grid.connect("next_grid", create_next_grid)
	current_grid = new_grid
	add_child(new_grid)

func _on_next_grid() -> void:
	#var prev_specs = [current_grid.rows, current_grid.columns]
	level += 1
	#print(level)
	
	"""Add animations"""
	await get_tree().create_timer(0.5).timeout 
	if current_grid != null:
		current_grid.queue_free()
	await get_tree().create_timer(0.5).timeout
	
	create_new_grid()

func _on_hide_cells_pressed() -> void:
	if current_grid == null: return
	current_grid.hide_cells()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start"):
		_on_hide_cells_pressed()

func user_input(correct: bool):
	if !correct: 
		HUD.adjust_score(-50 - level*10)
	else: 
		HUD.adjust_score(100 + level*10)

func end(finished: bool = false):
	if current_grid != null:
		current_grid.queue_free()
	if finished: 
		DataBase.gather_data({"Game_mode": "default", "File_name": file_name})
