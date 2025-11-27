extends Node
class_name DroidZapperCombat

var ai

func _init(ai_ref):
	ai = ai_ref

func check_attack_hit():
	var target : Node2D = ai.detection.target
	if target == null:
		return

	var rect := ai.col_attack.shape as RectangleShape2D
	var xform : Transform2D = ai.col_attack.get_global_transform()
	var area := Rect2(xform.origin - rect.size * 0.5, rect.size)

	if area.has_point(target.global_position):
		if target.has_method("apply_damage"):
			target.apply_damage(ai.stats.attack, ai.pivot.global_position)


func apply_knockback(source_pos: Vector2):
	var dir: float = sign(ai.pivot.global_position.x - source_pos.x)
	if dir == 0.0:
		dir = 1.0

	ai.knockback_timer = ai.knockback_duration
	ai.state = ai.State.KNOCKBACK

	ai.body.velocity.x = dir * ai.knockback_force
	ai.anim.play_run()
