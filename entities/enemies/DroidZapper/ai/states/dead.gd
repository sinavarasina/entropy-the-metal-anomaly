extends Node
class_name StateDead

var ai

func _init(ai_ref):
	ai = ai_ref

func enter():
	ai.body.velocity = Vector2.ZERO
	ai.anim.play_death()
	ai.col_standard.disabled = true
	ai.col_attack.disabled = true

func update(delta):
	pass

func exit():
	pass
