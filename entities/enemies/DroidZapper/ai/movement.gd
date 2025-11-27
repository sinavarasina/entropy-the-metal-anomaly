extends Node
class_name DroidZapperMovement

var ai

const MAX_FALL_SPEED := 1500.0

func _init(ai_ref):
	ai = ai_ref


func apply_gravity(delta):
	if not ai.body.is_on_floor():
		ai.body.velocity.y = min(ai.body.velocity.y + ai.stats.gravity * delta, MAX_FALL_SPEED)
	else:
		ai.body.velocity.y = 0


func move_toward_target(delta):
	apply_gravity(delta)

	if ai.detection.target == null:
		ai.body.velocity.x = 0
		return

	var target: Node2D = ai.detection.target
	var dx = target.global_position.x - ai.pivot.global_position.x
	var dir = sign(dx)

	apply_flip(dir)

	ai.body.velocity.x = dir * ai.stats.speed


func apply_flip(dir: float):
	if dir == 0.0:
		return

	ai.pivot.scale.x = -1 if dir < 0 else 1
	ai.agro_area.position.x = abs(ai.agro_area.position.x) * ai.pivot.scale.x
	ai.attack_area.position.x = abs(ai.attack_area.position.x) * ai.pivot.scale.x
