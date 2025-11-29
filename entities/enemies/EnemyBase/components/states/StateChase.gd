extends EnemyState

@export var attack_range: float = 40.0

var can_attack: bool = false
var attack_cooldown: float = 1.0
var timer: float = 0.0

func enter() -> void:
	anim.play("Run")
	
	timer = attack_cooldown
	can_attack = false 

func physics_update(delta: float) -> void:
	var target = ai.vision.get_target()
	
	if not target:
		ai.change_state(ai.get_state_node("Idle"))
		return
	
	if not can_attack:
		timer -= delta
		if timer <= 0:
			can_attack = true
	
	ai.mover.move_towards(target.global_position, delta)
	
	var dist = ai.entity.global_position.distance_to(target.global_position)
	
	if dist <= attack_range and can_attack:
		ai.change_state(ai.get_state_node("Attack"))
