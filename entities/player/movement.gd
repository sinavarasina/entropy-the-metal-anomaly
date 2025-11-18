extends Node
class_name Movement

@export var speed: float = 200.0
@export var gravity: float = 900.0
@export var jump_force: float = -450.0
@export var double_jump_force: float = -350.0
@export var glide_gravity_scale: float = 0.2
@export var roll_speed: float = 2000
@export var leap_speed: float = 2500

var has_double_jumped := false

func process_movement(
	body: CharacterBody2D,
	dir: Vector2,
	input: PlayerInput,
	anim: PlayerAnimation,
	delta: float
) -> void:

	var on_ground := body.is_on_floor()


	body.velocity.x = dir.x * speed

	body.velocity.y += gravity * delta

	if input.is_jump_pressed() and on_ground:
		body.velocity.y = jump_force
		has_double_jumped = false


	if input.is_jump_pressed() and not on_ground and not has_double_jumped:
		body.velocity.y = double_jump_force
		has_double_jumped = true

	if input.is_glide_pressed() and not on_ground:
		body.velocity.y *= glide_gravity_scale

	if input.is_roll_pressed() and on_ground:
		body.velocity.x = (sign(body.velocity.x) if body.velocity.x != 0 else 1) * roll_speed


	if input.is_leap_pressed() and on_ground:
		var dir_sign := sprite_flip_dir(body) 
		body.velocity.x = dir_sign * leap_speed
		body.velocity.y = jump_force * 0.02

	body.move_and_slide()


func sprite_flip_dir(body: CharacterBody2D) -> int:
	var sprite: AnimatedSprite2D = body.get_node("AnimatedSprite2D")
	if sprite.flip_h:
		return -1
	return 1
