extends Node
class_name StateRun

var ai

func _init(ai_ref):
	ai = ai_ref

func enter():
	ai.anim.play_run()

func update(delta):
	if ai.target == null:
		return

	var dx = ai.target.global_position.x - ai.pivot.global_position.x
	var dir = sign(dx)

	ai.pivot.scale.x = -1 if dir < 0 else 1

	ai.body.velocity.x = dir * ai.stats.speed
	ai.body.move_and_slide()

	if ai.pivot.global_position.distance_to(ai.target.global_position) <= ai.attack_range:
		ai.change_state("attack")

func exit():
	ai.body.velocity.x = 0
