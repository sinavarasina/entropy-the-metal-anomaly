extends EnemyState

func enter() -> void:
	anim.play("DamagedNDeath")
	if anim.sprite_frames.has_animation("DamagedNDeath"):
		# protection, bcs idk why it loop.
		anim.sprite_frames.set_animation_loop("DamagedNDeath", false) 
	ai.mover.body.velocity.x = 0
	ai.entity.collision_layer = 0

func physics_update(delta: float) -> void:
	ai.mover.apply_gravity(delta)
	ai.entity.move_and_slide()

func on_animation_finished() -> void:
	ai.entity.queue_free()
