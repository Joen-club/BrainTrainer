extends Sprite2D

"""GPT created"""


# Adjust the screen boundary if needed
var screen_size: Vector2

# Speed of the object
var speed = 3

# Random direction (either left-to-right, top-to-bottom, etc.)
var direction: Vector2

func _ready():
	screen_size = get_viewport_rect().size
	randomize()

	# Randomly pick the spawn position off-screen
	var spawn_edge = randi() % 4 # 0 = left, 1 = right, 2 = top, 3 = bottom
	match spawn_edge:
		0:  # Left of the screen
			position.x = -50
			position.y = randf_range(0, screen_size.y)
			direction = Vector2(1, randf_range(-0.5, 0.5)).normalized() # Move to the right
		1:  # Right of the screen
			position.x = screen_size.x + 50
			position.y = randf_range(0, screen_size.y)
			direction = Vector2(-1, randf_range(-0.5, 0.5)).normalized() # Move to the left
		2:  # Above the screen
			position.x = randf_range(0, screen_size.x)
			position.y = -50
			direction = Vector2(randf_range(-0.5, 0.5), 1).normalized() # Move down
		3:  # Below the screen
			position.x = randf_range(0, screen_size.x)
			position.y = screen_size.y + 50
			direction = Vector2(randf_range(-0.5, 0.5), -1).normalized() # Move up

func _process(delta):
	# Move the object
	position += direction * speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
