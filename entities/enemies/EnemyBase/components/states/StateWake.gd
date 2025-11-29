extends EnemyState

func enter() -> void:
	anim.play("Wake")
	
	if anim.sprite_frames.has_animation("Wake"):
		anim.sprite_frames.set_animation_loop("Wake", false)

func on_animation_finished() -> void:
	if anim.animation == "Wake":
		ai.change_state(ai.get_state_node("Chase"))
