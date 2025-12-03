extends Node
class_name CyborgController

enum State { IDLE, RUN, AIR, ATTACK, DEAD, HURT }
var state: State = State.IDLE

var cyborg: Cyborg
var can_double_jump: bool = true

func setup(player_ref: Cyborg):
	cyborg = player_ref
	cyborg.stats.player_died.connect(_on_player_died)

func update(delta: float):
	if state == State.DEAD:
		_state_dead(delta)
		return
	
	if state == State.HURT:
		_state_hurt(delta)
		return

	if state != State.ATTACK and cyborg.input.is_fire_pressed():
		change_state(State.ATTACK)
		return

	match state:
		State.IDLE: _state_idle(delta)
		State.RUN: _state_run(delta)
		State.AIR: _state_air(delta)
		State.ATTACK: _state_attack(delta)
		State.HURT: _state_hurt(delta)
		
func trigger_hurt():
	if state != State.DEAD:
		change_state(State.HURT)
		AudioManager.play_sfx("hurt")
		
func _state_hurt(delta: float):
	cyborg.movement.apply_gravity(delta)
	cyborg.movement.apply_friction(cyborg.stats.ground_friction, delta)
	cyborg.move_and_slide()
	
	if cyborg.anim.is_finished():
		change_state(State.IDLE)

func _on_player_died():
	if state != State.DEAD:
		change_state(State.DEAD)
		AudioManager.play_sfx("death")
		print("Player dead!")
		
func _state_dead(delta: float):
	cyborg.movement.apply_gravity(delta)
	cyborg.movement.apply_friction(cyborg.stats.ground_friction, delta)
	cyborg.move_and_slide()


func _state_idle(delta: float):
	cyborg.movement.apply_gravity(delta)
	
	cyborg.movement.apply_friction(cyborg.stats.ground_friction, delta)
	cyborg.move_and_slide()

	if cyborg.input.is_jump_pressed():
		_perform_jump()
		change_state(State.AIR)
	elif cyborg.input.get_direction().x != 0:
		change_state(State.RUN)
	elif not cyborg.is_on_floor():
		change_state(State.AIR)

func _state_run(delta: float):
	cyborg.movement.apply_gravity(delta)
	
	cyborg.movement.move_horizontal(
		cyborg.input.get_direction().x, 
		cyborg.stats.ground_acceleration, 
		delta
	)
	cyborg.move_and_slide()

	var dir_x = cyborg.input.get_direction().x



	if cyborg.input.is_jump_pressed():
		_perform_jump()
		change_state(State.AIR)
	elif cyborg.input.get_direction().x == 0:
		change_state(State.IDLE)
	elif not cyborg.is_on_floor():
		change_state(State.AIR)

func _state_air(delta: float):
	cyborg.movement.apply_gravity(delta)
	
	var dir_x = cyborg.input.get_direction().x
	
	if dir_x != 0:
		cyborg.movement.move_horizontal(
			dir_x, 
			cyborg.stats.air_acceleration, 
			delta
		)
	else:
		cyborg.movement.apply_friction(cyborg.stats.air_friction, delta)
		
	cyborg.move_and_slide()

	if cyborg.input.is_jump_pressed() and can_double_jump:
		_perform_double_jump()
	
	if cyborg.is_on_floor():
		can_double_jump = true
		if dir_x != 0:
			change_state(State.RUN)
		else:
			change_state(State.IDLE)

func _state_attack(delta: float):
	cyborg.movement.apply_gravity(delta)
	
	cyborg.movement.apply_friction(cyborg.stats.ground_friction, delta)
	
	cyborg.move_and_slide()
	
	if cyborg.anim.is_finished():
		change_state(State.IDLE)


func fire_bullet():
	if not cyborg.bullet_scene: return
	
	var bullet = cyborg.bullet_scene.instantiate()
	bullet.global_position = cyborg.muzzle.global_position
	var pivot_scale = cyborg.get_node("Pivot").scale.x
	bullet.direction = pivot_scale
	
	var stats = cyborg.stats
	var is_crit = randf() < stats.get_crit_rate()
	var can_knockback = randf() < stats.get_knockback_rate()
	
	var final_damage = stats.attack_damage
	if is_crit:
		final_damage *= stats.crit_multiplier
		
	bullet.damage = final_damage
	bullet.is_critical = is_crit 
	bullet.can_knockback = can_knockback 
	
	get_tree().current_scene.add_child(bullet)

func _perform_jump():
	cyborg.movement.jump(cyborg.stats.jump_force)
	cyborg.anim.play_jump()
	AudioManager.play_sfx("jump")

func _perform_double_jump():
	cyborg.movement.jump(cyborg.stats.double_jump_force)
	cyborg.anim.play_double_jump()
	can_double_jump = false
	AudioManager.play_sfx("double_jump")

func change_state(new_state: State):
	if state == State.RUN and new_state != State.RUN:
		if AudioManager.is_sfx_playing("step"):
			AudioManager.stop_sfx("step")
			
	state = new_state
	
	match state:
		State.IDLE: 
			cyborg.anim.play_idle()
		State.RUN: 
			cyborg.anim.play_run()
			if not AudioManager.is_sfx_playing("step"):
				AudioManager.play_sfx("step")
		State.ATTACK: 
			cyborg.anim.play_attack()
			AudioManager.play_sfx("shoot")
			fire_bullet()
		State.AIR: 
			pass
		State.HURT:
			cyborg.anim.play_hurt()
		State.DEAD:
			cyborg.anim.play_death()
			
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if state != State.DEAD:
			SceneManager.toggle_pause()
