extends Node2D

"""Можно сделать так, чтобы каждый спрайт ротейтил сам по себе, вместо этой ноды
для того чтобы избезать непропорциональных ротейтов. Но в таком случае нужно
вводить отдельную переменную rotation для этой ноды"""

var direction: Array = [0, 90, 180, 270]
var boat_rotation = 0
var motion_direction: Array = [Vector2(0,-1), Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0)]
var velocity: Vector2 = Vector2.ZERO
var speed_modifier: float = 1
var correct_button
var boat_id: int = 0 #Two types of boats

var action_map: Array = ["Up", "Right", "Down", "Left"]

var button_map: Dictionary

signal input_check(bool)

func _ready() -> void:
	setup_submarine()
	assign_right_button()

func setup_sprite_color_and_speed(sprite_path: Array, color: Array, speed: float):
	for i in get_children():
		if i is Sprite2D:
			i.texture = load(sprite_path[boat_id])
			i.self_modulate = color[boat_id]
	speed_modifier = speed

# Function to randomize the submarine's initial rotation and movement.
func setup_submarine():
	boat_rotation = direction.pick_random()
	for i in get_children():
		if i.is_in_group("Boat"):
			i.set_rotation_degrees(boat_rotation)
	#set_rotation_degrees(direction.pick_random()) # Randomly rotates the submarine to one of the four directions.
	velocity = motion_direction.pick_random() #Sets the velocity according to the random direction-motion chosen
	
func _physics_process(_delta: float) -> void:
	position += velocity*speed_modifier

#Takes either 'direction' of 'motion_direction' array as a map parameter
#Basically assigns the angle/Vector2 with the string describing the direction.
func setup_map(map: Array):
	var count = 0
	for i in map:
		button_map[map[count]] = action_map[count]
		count+= 1

# Function to assign the correct button that needs to be pressed
func assign_right_button():
	correct_button = button_map[correct_button]

# Handles user input and checks whether the correct button was pressed.
func _input(event: InputEvent) -> void:
	for action in action_map: #Only registering the necessary inputs
		if event.is_action_pressed(action):
			if action == correct_button:
				emit_signal("input_check", true)
			else:
				emit_signal("input_check", false)
