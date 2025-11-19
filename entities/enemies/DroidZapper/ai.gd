extends Node
class_name DroidZapperAI

enum State { IDLE, WAKE, RUN, ATTACK, KNOCKBACK, DEAD }

var knockback_timer := 0.0
var knockback_duration := 0.15
var knockback_force := 200.0

var state: State = State.IDLE

@onready var body: CharacterBody2D = get_parent()
@onready var anim = body.get_node("Anim")
@onready var stats = body.get_node("Stats")

@export var aggro_range: float = 200
@export var attack_range: float = 40
@export var move_speed: float = 80


func _get_player() -> Node2D:
	var players := get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return null
	return players[0]


func _has_player_in_range() -> bool:
	var player: Node2D = _get_player()
	if player == null:
		return false
	return body.global_position.distance_to(player.global_position) <= aggro_range

func _physics_process(delta):
	match state:
		State.IDLE: _process_idle()
		State.WAKE: _process_wake()
		State.RUN: _process_run(delta)
		State.ATTACK: _process_attack()
		State.KNOCKBACK: _process_knockback(delta)



func _process_idle() -> void:
	if _has_player_in_range():
		state = State.WAKE
		anim.play("Wake")


func _process_wake() -> void:
	if anim.is_finished():
		state = State.RUN
		anim.play("Run")


func _process_run(delta: float) -> void:
	var player: Node2D = _get_player()
	if player == null:
		return

	var dx: float = player.global_position.x - body.global_position.x
	var dir: float = sign(dx)

	body.velocity.x = dir * stats.speed

	body.move_and_slide()

	anim.play("Run")

	if body.global_position.distance_to(player.global_position) <= attack_range:
		state = State.ATTACK
		anim.play("Attack")


func _process_attack() -> void:
	if anim.is_finished():
		state = State.RUN
		
func apply_knockback(source_pos: Vector2):
	state = State.KNOCKBACK
	knockback_timer = knockback_duration

	var dir: float = sign(body.global_position.x - source_pos.x)
	body.velocity.x = dir * knockback_force

	anim.play_run() 
	
func _process_knockback(delta):
	body.move_and_slide()

	knockback_timer -= delta
	if knockback_timer <= 0:
		state = State.RUN

func _ready():
	stats.max_hp *= entropy_system.multiplier
	stats.attack *= entropy_system.multiplier
	stats.defense *= entropy_system.multiplier
