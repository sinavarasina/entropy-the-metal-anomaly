extends Node
class_name CyborgInput

func get_direction() -> Vector2:
	var x: float = Input.get_action_strength("player_right") - Input.get_action_strength("player_left")
	return Vector2(x, 0)

func is_jump_pressed() -> bool:
	return Input.is_action_just_pressed("player_up")

func is_fire_pressed() -> bool:
	return Input.is_action_just_pressed("player_fire")
