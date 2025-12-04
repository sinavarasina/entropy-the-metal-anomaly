extends EnemyState

var collision_attack: CollisionShape2D 
var has_dealt_damage: bool = false

func setup(controller: EnemyAI) -> void:
	super.setup(controller)
	if ai.attack_area:
		collision_attack = ai.attack_area.get_node("CollisionAttack")

func enter() -> void:
	anim.play("Attack")
	if ai.entity.id == 1:
		AudioManager.play_sfx("droid_shoot")
	elif ai.entity.id == 2:
		AudioManager.play_sfx("slash")
	elif ai.entity.id == 99:
		AudioManager.play_sfx("boss_slash")
	if anim.sprite_frames.has_animation("Attack"):
		anim.sprite_frames.set_animation_loop("Attack", false)
	
	ai.mover.body.velocity = Vector2.ZERO 
	has_dealt_damage = false
	
	if collision_attack:
		collision_attack.set_deferred("disabled", false)

func physics_update(delta: float) -> void:
	ai.mover.apply_gravity(delta)
	ai.entity.move_and_slide()
	
	ai.mover.stop(delta) 
	
	if not has_dealt_damage:
		_check_hit()

func exit() -> void:
	if collision_attack:
		collision_attack.set_deferred("disabled", true)

func on_animation_finished() -> void:
	if anim.animation == "Attack":
		var chase_node = ai.get_state_node("Chase")
		if chase_node:
			ai.change_state(chase_node)

func _check_hit() -> void:
	var bodies = ai.attack_area.get_overlapping_bodies()
	for b in bodies:
		if b.is_in_group("player") and b.has_method("apply_damage"):
			b.apply_damage(ai.stats.attack_damage)
			has_dealt_damage = true
