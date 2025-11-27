extends Node
class_name StateAttack

var ai

func _init(ai_ref):
	ai = ai_ref

func enter():
	ai.anim.play_attack()
	ai.attack_area.get_node("CollisionAttack").disabled = false

func update(delta):
	ai.body.velocity.x = 0
	ai.body.move_and_slide()

	var shape = ai.attack_area.get_node("CollisionAttack").shape
	var xform = ai.attack_area.get_node("CollisionAttack").get_global_transform()
	var rect = Rect2(xform.origin - shape.size * 0.5, shape.size)

	if ai.target and rect.has_point(ai.target.global_position):
		ai.target.apply_damage(ai.stats.attack, ai.pivot.global_position)

	if ai.anim.is_finished():
		ai.change_state("run")

func exit():
	ai.attack_area.get_node("CollisionAttack").disabled = true
