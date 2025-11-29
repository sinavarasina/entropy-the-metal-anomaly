extends Node
class_name CyborgController

enum State { IDLE, RUN, AIR, ATTACK }
var state: State = State.IDLE

var cyborg: Cyborg
var can_double_jump: bool = true

func setup(player_ref: Cyborg):
	cyborg = player_ref

func update(delta: float):
	if state != State.ATTACK and cyborg.input.is_fire_pressed():
		change_state(State.ATTACK)
		return

	match state:
		State.IDLE: _state_idle(delta)
		State.RUN: _state_run(delta)
		State.AIR: _state_air(delta)
		State.ATTACK: _state_attack(delta)


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

	if cyborg.is_on_wall() and cyborg.step.playing:
		cyborg.step.stop()
	elif not cyborg.is_on_wall() and not cyborg.step.playing and cyborg.is_on_floor():
		cyborg.step.play()

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
	if not cyborg.bullet_scene:
		return

	var bullet = cyborg.bullet_scene.instantiate()
	
	bullet.global_position = cyborg.muzzle.global_position
	
	var pivot_scale = cyborg.get_node("Pivot").scale.x
	bullet.direction = pivot_scale
	bullet.damage = cyborg.stats.attack_damage
	
	get_tree().current_scene.add_child(bullet)

func _perform_jump():
	cyborg.movement.jump(cyborg.stats.jump_force)
	cyborg.anim.play_jump()
	cyborg.jump.play()

func _perform_double_jump():
	cyborg.movement.jump(cyborg.stats.double_jump_force)
	cyborg.anim.play_double_jump()
	can_double_jump = false
	cyborg.jump.play()

func change_state(new_state: State):
	if state == State.RUN and new_state != State.RUN:
		if cyborg.step.playing:
			cyborg.step.stop()
			
	state = new_state
	
	match state:
		State.IDLE: 
			cyborg.anim.play_idle()
		State.RUN: 
			cyborg.anim.play_run()
			if not cyborg.step.playing:
				cyborg.step.play()
		State.ATTACK: 
			cyborg.anim.play_attack()
			cyborg.shoot.play()
			fire_bullet()
		State.AIR: 
			pass
