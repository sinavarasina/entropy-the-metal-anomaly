extends Node
class_name StateWake

var ai

func _init(ai_ref):
	ai = ai_ref

func enter():
	ai.anim.play_wake()

func update(delta):
	if ai.anim.is_finished():
		ai.change_state("run")

func exit():
	pass
