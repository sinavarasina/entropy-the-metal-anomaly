extends Node
class_name CyborgMovement

@onready var stats: CyborgStats = get_parent().get_node("Stats")
@onready var body: CharacterBody2D = get_parent()

func apply_gravity(delta: float):
	if not body.is_on_floor():
		body.velocity.y += stats.gravity * delta

func move_horizontal(dir_x: float, accel: float, delta: float):
	if dir_x != 0:
		body.velocity.x = move_toward(body.velocity.x, dir_x * stats.move_speed, accel * delta)
		_flip_sprite(dir_x)

func apply_friction(amount: float, delta: float):
	body.velocity.x = move_toward(body.velocity.x, 0, amount * delta)

func jump(force: float):
	body.velocity.y = force

func _flip_sprite(dir_x: float):
	var pivot = body.get_node("Pivot") 
	
	if dir_x < 0:
		pivot.scale.x = -1
	elif dir_x > 0:
		pivot.scale.x = 1
