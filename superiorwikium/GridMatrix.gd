extends Control

@onready var grid = $Grid

var tile_pressed: Callable = _on_tile_pressed
var chosen_cells: Array = []

var amount_of_clicks: int #How to name it properly?
var game_started: bool = false

@export var rows: int = 2
@export var columns: int = 4

@warning_ignore("unused_signal")
signal next_grid

signal input_check

func create_grid(new_level: int):
	grid = get_child(0)
	grid.columns = columns
	check_level(new_level)
	#columns = new_level #Temp
	var new_grid: Array = []
	for cell in rows*columns:
		new_grid.append(create_new_cell())
	choose_cells(new_grid, new_level)

func check_level(new_level: int):
	if new_level > 12: return
	if new_level % 2 ==0:
		add_rows()
	else: add_columns()

func add_rows():
	rows += 1 

func add_columns():
	grid.columns +=1 
	columns = grid.columns

func choose_cells(new_grid: Array, new_level: int):
	for k in new_level+1:
		var chosen_cell = new_grid.find(new_grid.pick_random())
		new_grid[chosen_cell].modulate = Color(1, 1, 0)
		chosen_cells.append(new_grid.pop_at(chosen_cell))
	amount_of_clicks = chosen_cells.size()

func create_new_cell() -> TextureButton:
	var new_tile = TextureButton.new()
	new_tile.connect("pressed", _on_tile_pressed.bind(new_tile))
	new_tile.texture_normal = load("res://Assets/Tile.png")
	grid.add_child(new_tile)
	return new_tile

func _on_tile_pressed(tile):
	if !game_started: return
	if tile.modulate != Color(1, 1, 1): return

	if chosen_cells.has(tile):
		tile.modulate = Color(0, 1, 0)
		emit_signal("input_check", true)
	else: 
		tile.modulate = Color(1, 0, 0)
		emit_signal("input_check", false)
		"""-points"""

	amount_of_clicks -=1
	if amount_of_clicks <= 0:
		game_started = false
		emit_signal("next_grid")

func hide_cells() -> void:
	for k in chosen_cells:
		k.modulate = Color(1,1,1)

	game_started = true
	
	
