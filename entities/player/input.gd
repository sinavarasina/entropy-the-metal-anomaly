extends Node
class_name PlayerInput

func get_direction() -> Vector2:
	var x: float = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	var y: float = Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	return Vector2(x, y)

func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("player_up")

func is_roll_pressed() -> bool:
	return Input.is_action_just_pressed("player_roll")

func is_glide_pressed() -> bool:
	return Input.is_action_pressed("player_glide")

func is_leap_pressed() -> bool:
	return Input.is_action_just_pressed("player_leap")
