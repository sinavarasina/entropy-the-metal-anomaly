extends EnemyState

func enter() -> void:
	anim.play("DamagedNDeath")
	ai.mover.body.velocity = Vector2.ZERO
	ai.entity.get_node("CollisionStandard").set_deferred("disabled", true)

func physics_update(delta: float) -> void:
	ai.mover.apply_gravity(delta)
	ai.entity.move_and_slide()

func on_animation_finished() -> void:
	ai.entity.queue_free()
