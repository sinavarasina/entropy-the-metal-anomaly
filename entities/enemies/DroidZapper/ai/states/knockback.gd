extends Node
class_name StateKnockback

var ai
var timer := 0.15

func _init(ai_ref):
	ai = ai_ref

func enter():
	timer = 0.15

func update(delta):
	ai.body.move_and_slide()
	timer -= delta
	if timer <= 0:
		ai.change_state("run")

func exit():
	pass
