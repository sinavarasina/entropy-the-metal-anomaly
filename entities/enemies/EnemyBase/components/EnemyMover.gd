extends Node
class_name EnemyMover

@export var speed: float = 100.0
@export var gravity: float = 900.0

@onready var body: CharacterBody2D = get_parent()
@onready var pivot: Marker2D = body.get_node("Marker2D")

func apply_gravity(delta: float) -> void:
	if not body.is_on_floor():
		body.velocity.y += gravity * delta

func move_towards(target_position: Vector2, delta: float) -> void:
	apply_gravity(delta)
	
	var dx = target_position.x - body.global_position.x
	var dir = sign(dx)
	
	if dir != 0:
		_flip(dir)
		body.velocity.x = dir * speed
	
	body.move_and_slide()

func stop(delta: float) -> void:
	apply_gravity(delta)
	body.velocity.x = move_toward(body.velocity.x, 0, speed * delta * 5)
	body.move_and_slide()

func _flip(dir: float) -> void:
	if dir > 0:
		pivot.scale.x = abs(pivot.scale.x)
	elif dir < 0:
		pivot.scale.x = -abs(pivot.scale.x)

func apply_entropy(multiplier: float) -> void:
	speed *= multiplier
