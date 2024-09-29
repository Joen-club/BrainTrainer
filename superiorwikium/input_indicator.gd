extends ColorRect

#@onready var mark = $TextureRect #Delete this node maybe?
@onready var timer = $Timer

#Shows only for a fraction of a second, then visible = false
func indicate_input(correct_input: bool):
	self.visible = true
	if correct_input:
		set_new_color(Color(0, 0.604, 0.157, 0.300), Color(0, 1, 0, 0.8))
	else: 
		set_new_color(Color(0.597, 0.14, 0.157, 0.300), Color(1, 0, 0, 0.8))
	timer.start()

func set_new_color(color_self: Color, color_mark: Color):
	self.color = color_self
	#mark.self_modulate = color_mark

func _on_timer_timeout() -> void:
	self.visible = false
