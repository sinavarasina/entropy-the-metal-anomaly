extends Node
class_name DroidZapperAI

enum State { IDLE, WAKE, RUN, ATTACK, KNOCKBACK, DEAD }

var state: State = State.IDLE

var knockback_timer: float = 0.0
var knockback_duration: float = 0.15
var knockback_force: float = 200.0

@onready var body: CharacterBody2D = get_parent()
@onready var anim: DroidZapperAnim = body.get_node("Anim")
@onready var stats: DroidZapperStats = body.get_node("Stats")
@onready var col_standard: CollisionShape2D = body.get_node("CollisionStandard")
@onready var col_attack: CollisionShape2D = body.get_node("CollisionAttack")

@onready var entropy_system: EntropySystem = get_node("/root/entropy_system") as EntropySystem

@export var aggro_range: float = 200.0
@export var attack_range: float = 40.0


func _ready() -> void:
	col_attack.disabled = true

	stats.apply_entropy(entropy_system.multiplier)


func _physics_process(delta: float) -> void:

	if state == State.DEAD:
		return

	match state:
		State.IDLE:
			_process_idle()
		State.WAKE:
			_process_wake()
		State.RUN:
			_process_run(delta)
		State.ATTACK:
			_process_attack()
		State.KNOCKBACK:
			_process_knockback(delta)


func _get_player() -> Node2D:
	var players: Array = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null
	return players[0] as Node2D


func _has_player_in_range() -> bool:
	var player: Node2D = _get_player()
	if player == null:
		return false

	return body.global_position.distance_to(player.global_position) <= aggro_range


func _process_idle() -> void:
	if _has_player_in_range():
		state = State.WAKE
		anim.play_wake()


func _process_wake() -> void:
	if anim.is_finished():
		state = State.RUN
		anim.play_run()


func _process_run(delta: float) -> void:
	var player: Node2D = _get_player()
	if player == null:
		return

	var dx: float = player.global_position.x - body.global_position.x
	var dir: float = sign(dx)

	_update_facing(dir)

	body.velocity.x = dir * stats.speed
	body.move_and_slide()

	anim.play_run()

	if body.global_position.distance_to(player.global_position) <= attack_range:
		state = State.ATTACK
		anim.play_attack()


func _process_attack() -> void:
	# Selama animasi attack, musuh berhenti maju
	body.velocity.x = 0.0
	body.move_and_slide()

	col_attack.disabled = false
	_check_attack_hit()

	if anim.is_finished():
		col_attack.disabled = true
		state = State.RUN


func _check_attack_hit() -> void:
	var player: Node2D = _get_player()
	if player == null:
		return

	var rect_shape: RectangleShape2D = col_attack.shape as RectangleShape2D
	if rect_shape == null:
		return

	var xform: Transform2D = col_attack.get_global_transform()
	var size: Vector2 = rect_shape.size
	var global_rect: Rect2 = Rect2(xform.origin - size * 0.5, size)

	if global_rect.has_point(player.global_position):
		if player.has_method("apply_damage"):
			player.apply_damage(stats.attack, body.global_position)


func apply_knockback(source_pos: Vector2) -> void:
	if state == State.DEAD:
		return

	state = State.KNOCKBACK
	knockback_timer = knockback_duration

	var dir: float = sign(body.global_position.x - source_pos.x)
	if dir == 0.0:
		dir = 1.0

	body.velocity.x = dir * knockback_force
	anim.play_run()


func _process_knockback(delta: float) -> void:
	body.move_and_slide()
	knockback_timer -= delta

	if knockback_timer <= 0.0:
		state = State.RUN


func apply_damage(amount: float, source_pos: Vector2) -> void:
	var real_damage: float = max(amount - stats.defense * 0.1, 1.0)
	stats.apply_damage(real_damage)

	if stats.current_hp <= 0.0:
		_die()
	else:
		apply_knockback(source_pos)


func _die() -> void:
	state = State.DEAD

	body.velocity = Vector2.ZERO

	col_standard.disabled = true
	col_attack.disabled = true

	col_attack.disabled = true
	anim.play_death()


func _update_facing(dir: float) -> void:
	if dir == 0.0:
		return

	anim.flip_h(dir)

	var pos: Vector2 = col_attack.position
	pos.x = abs(pos.x) * (dir < 0.0 ? -1.0 : 1.0)
	col_attack.position = pos
