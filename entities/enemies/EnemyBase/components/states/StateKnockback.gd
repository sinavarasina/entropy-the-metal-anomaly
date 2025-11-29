extends EnemyState

var timer: float = 0.0
var knockback_duration: float = 0.3 
var knockback_force: float = 300.0


func enter() -> void:
	timer = knockback_duration
	anim.stop() 
	
	if anim.sprite_frames.has_animation("DamagedNDeath"):
		anim.play("DamagedNDeath")
		anim.frame = 0
	elif anim.sprite_frames.has_animation("Run"):
		anim.play("Run")

func apply_force(source_pos: Vector2):
	var dir = sign(ai.entity.global_position.x - source_pos.x)
	if dir == 0: dir = 1
	
	ai.mover.body.velocity.x = dir * knockback_force
	ai.mover.body.velocity.y = -150 

func physics_update(delta: float) -> void:
	ai.mover.apply_gravity(delta)
	
	ai.mover.body.velocity.x = move_toward(ai.mover.body.velocity.x, 0, 10 * delta)
	
	ai.entity.move_and_slide()
	
	timer -= delta
	if timer <= 0:
		if ai.vision.get_target():
			ai.change_state(ai.get_state_node("Chase"))
		else:
			ai.change_state(ai.get_state_node("Idle"))
