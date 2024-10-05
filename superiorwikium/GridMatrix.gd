extends Control

@onready var grid: GridContainer = $Grid
@onready var amount_of_clicks_indicator: Label = $AmountOfClicks

var tile_pressed: Callable = _on_tile_pressed
var chosen_cells: Array = []

var amount_of_clicks: int : set = display_amount_of_clicks #How to name it properly?
var game_started: bool = false

@export var rows: int = 2
@export var columns: int = 2

@warning_ignore("unused_signal")
signal next_grid

signal input_check

func _ready():
	amount_of_clicks_indicator.text = "Cells: "+ str(amount_of_clicks)

func create_grid(new_level: int):
	grid = get_child(0)
	grid.columns = columns
	check_level(new_level)
	var new_grid: Array = []
	for cell in rows*columns:
		new_grid.append(create_new_cell())
	choose_cells(new_grid, new_level)

func check_level(new_level: int):
	if new_level <=1: return
	if new_level > 12: new_level = 12
	for i in new_level-1:
		if i % 2 ==0:
			add_columns()
		else: add_rows()
	#if new_level % 2 ==0:

func add_rows():
	rows += 1 

func add_columns():
	grid.columns +=1 
	columns = grid.columns

func display_amount_of_clicks(value):
	amount_of_clicks = value
	if !is_node_ready():
		return
	
	amount_of_clicks_indicator.text = "Cells: "+ str(amount_of_clicks)

func choose_cells(new_grid: Array, new_level: int):
	for k in new_level+1:
		var chosen_cell = new_grid.find(new_grid.pick_random())
		new_grid[chosen_cell].modulate = Color(1, 1, 0)
		chosen_cells.append(new_grid.pop_at(chosen_cell))
	self.amount_of_clicks = chosen_cells.size()

func create_new_cell() -> TextureButton:
	var new_tile = TextureButton.new()
	new_tile.connect("pressed", _on_tile_pressed.bind(new_tile))
	new_tile.texture_normal = load("res://Assets/Tile.png")
	grid.add_child(new_tile)
	return new_tile

func _on_tile_pressed(tile: TextureButton):
	if !game_started: return
	if tile.modulate != Color(1, 1, 1): return
	var share  =1
	if chosen_cells.has(tile):
		tile.modulate = Color(0, 1, 0)
		emit_signal("input_check", true)
	else: 
		tile.modulate = Color(1, 0, 0)
		emit_signal("input_check", false)
		"""-points"""
	tile.texture_hover = null

	self.amount_of_clicks -= 1
	if amount_of_clicks <= 0:
		game_started = false
		emit_signal("next_grid")

func hide_cells() -> void:
	for i in grid.get_children():
		i.texture_hover = load("res://Assets/TileSelected.png")
	for k in chosen_cells:
		k.modulate = Color(1,1,1)

	game_started = true
