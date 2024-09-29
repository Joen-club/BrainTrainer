extends Control

@onready var score: Label = $Panel/VBoxContainer/Score
@onready var pressed: Label = $Panel/VBoxContainer/Pressed
@onready var accuracy: Label = $Panel/VBoxContainer/Accuracy
@onready var pressed_correctly: Label = $Panel/VBoxContainer/CorrectPress

var game_ended: Callable = queue_free

func review(data: Dictionary):
	if data["Correct_press_count"] == 0:
		breakpoint
		print_debug("CorrectPresses = 0; smth wrong?")
	score.text = "Score: " + str(data["Score"])
	pressed.text = "Pressed: " + str(data["Button_press_count"])
	pressed_correctly.text = "Correcty: " + str(data["Correct_press_count"])
	
	var new_accuracy = float(data["Correct_press_count"])/float(data["Button_press_count"])
	accuracy.text = "Accuracy: " + str(snapped(new_accuracy*100, 0.01)) + "%"
	
	DataBase.gather_data({"Score": data["Score"], "Accuracy": new_accuracy, "Press_count": data["Button_press_count"]})

func end():
	queue_free()
