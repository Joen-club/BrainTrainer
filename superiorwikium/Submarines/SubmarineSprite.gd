extends Sprite2D

var screen_size: Vector2
var sprite = get_texture().get_size()
@onready var mode_indicator: Label = $Label

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(_delta: float) -> void:
	wrap_around_screen()
	pass
	
func wrap_around_screen():
	# Check and wrap the x-coordinate
	if global_position.x > screen_size.x:
		global_position.x -= screen_size.x + sprite.x
	elif global_position.x + sprite.x < 0:
		global_position.x += screen_size.x + sprite.x

	# Check and wrap the y-coordinate
	if global_position.y > screen_size.y:
		global_position.y -= screen_size.y + sprite.y
	elif global_position.y + sprite.y < 0:
		global_position.y += screen_size.y + sprite.y
