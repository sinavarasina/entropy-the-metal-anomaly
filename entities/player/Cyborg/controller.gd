extends Node
class_name CyborgController

enum State { IDLE, RUN, AIR, ATTACK }
var state: State = State.IDLE

var cyborg: Cyborg
var can_double_jump: bool = true

func setup(player_ref: Cyborg):
	cyborg = player_ref

func update(delta: float):
	if cyborg.input.is_fire_pressed():
		change_state(State.ATTACK)
		return

	match state:
		State.IDLE: _state_idle(delta)
		State.RUN: _state_run(delta)
		State.AIR: _state_air(delta)
		State.ATTACK: _state_attack(delta)


func _state_idle(delta: float):
	cyborg.movement.apply_gravity(delta)
	cyborg.movement.apply_friction(delta)
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
	cyborg.movement.move_horizontal(cyborg.input.get_direction().x, delta)
	cyborg.move_and_slide()

	if cyborg.input.is_jump_pressed():
		_perform_jump()
		change_state(State.AIR)
	elif cyborg.input.get_direction().x == 0:
		change_state(State.IDLE)
	elif not cyborg.is_on_floor():
		change_state(State.AIR)

func _state_air(delta: float):
	cyborg.movement.apply_gravity(delta)
	cyborg.movement.move_horizontal(cyborg.input.get_direction().x, delta)
	cyborg.move_and_slide()

	if cyborg.input.is_jump_pressed() and can_double_jump:
		_perform_double_jump()
	
	if cyborg.is_on_floor():
		can_double_jump = true
		change_state(State.IDLE)

func _state_attack(delta: float):
	cyborg.movement.apply_friction(delta) 
	cyborg.movement.apply_gravity(delta)
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


func change_state(new_state: State):
	state = new_state
	
	match state:
		State.IDLE: cyborg.anim.play_idle()
		State.RUN: cyborg.anim.play_run()
		State.ATTACK: 
			cyborg.anim.play_attack()
			fire_bullet()
		State.AIR: 
			pass 

func _perform_jump():
	cyborg.movement.jump(cyborg.stats.jump_force)
	cyborg.anim.play_jump()

func _perform_double_jump():
	cyborg.movement.jump(cyborg.stats.double_jump_force)
	cyborg.anim.play_double_jump()
	can_double_jump = false
