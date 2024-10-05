extends TouchScreenButton

signal button_pressed


func _on_pressed() -> void:
	emit_signal("button_pressed", action)
	pass # Replace with function body.
