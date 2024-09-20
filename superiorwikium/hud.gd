extends Control

@onready var label: Label = $Score/Scoretext
@onready var time_remains_display: Label = $Timer/Time
@onready var timer = $Timer2

@export var time_remains_default: int = 60
@export var performance_review: PackedScene

signal time_is_up

var score = 0

var game_performance: Dictionary = {
	"Score": 0,
	"Button_press_count": 0,
	"Correct_press_count": 0,
}

func start():
	
	#Restart
	for i in game_performance:
		game_performance[i] = 0
	
	timer.start()
	label.text = str(game_performance["Score"])
	time_remains_display.text = str(time_remains_default)

func adjust_score(new_score):
	if new_score > 0:
		game_performance['Correct_press_count'] += 1
	game_performance['Button_press_count'] += 1  
	
	game_performance["Score"] += new_score
	if game_performance["Score"] < 0:
		game_performance["Score"] = 0
	label.text = str(game_performance["Score"])

func _on_timer_timeout() -> void:
	time_remains_default -= 1
	if time_remains_default <= 0:
		game_over()
	time_remains_display.text = str(time_remains_default)

func game_over():
	emit_signal("time_is_up")
	timer.stop()
	create_performance_review()

func create_performance_review():
	var new_review = performance_review.instantiate()
	add_child(new_review)
	$Main_menu.connect("pressed", new_review.game_ended)
	new_review.review(game_performance)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Restart"):
		_on_main_menu_pressed()

func _on_main_menu_pressed() -> void:
	timer.stop()
