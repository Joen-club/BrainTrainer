extends Control

@onready var label: Label = $Score/Scoretext
@onready var time_remains_display: Label = $Timer/Time
@onready var timer = $Timer2

@export var time_remains_default: int = 60
var time_remains: int

@export var performance_review: PackedScene

signal time_is_up

var score = 0

"""Generalize for different games...?"""
var game_performance: Dictionary = {
	"Score": 0,
	"Button_press_count": 0,
	"Correct_press_count": 0,
}

func start():
	time_remains = time_remains_default
	#if Restart is pressed
	for i in game_performance:
		game_performance[i] = 0
	
	timer.start()
	label.text = str(game_performance["Score"])
	time_remains_display.text = str(time_remains)

"""Generalize for different games...?"""
func adjust_score(new_score):
	if new_score > 0:
		game_performance['Correct_press_count'] += 1
	game_performance['Button_press_count'] += 1  
	
	game_performance["Score"] += new_score
	if game_performance["Score"] < 0:
		game_performance["Score"] = 0
	label.text = str(game_performance["Score"])

func _on_timer_timeout() -> void:
	time_remains -= 1
	if time_remains <= 0:
		game_over()
	time_remains_display.text = str(time_remains)

func game_over():
	emit_signal("time_is_up", true)
	timer.stop()
	create_performance_review()

#Creates a panel with results at the end of the session
func create_performance_review():
	var new_review = performance_review.instantiate()
	add_child(new_review)
	new_review.review(game_performance)

func end():
	timer.stop()
