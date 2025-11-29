extends EnemyState

func enter() -> void:
	if anim.sprite_frames.has_animation("Idle"):
		anim.play("Idle")
	else:
		anim.play("Wake")
		anim.stop()
		anim.frame = 0

func physics_update(delta: float) -> void:
	ai.mover.stop(delta)
	
	if ai.vision.get_target():
		# print("Idle: Target Found")
		
		var next_state = ai.get_state_node("Wake")
		
		if not next_state:
			next_state = ai.get_state_node("Chase")
			
		if next_state:
			ai.change_state(next_state)
#		else:
#			printerr("CRITICAL ERROR: StateIdle wont changes to Node 'Wake' or 'Chase' due of child arent found")
