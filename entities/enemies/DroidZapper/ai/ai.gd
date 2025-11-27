extends Node
class_name DroidZapperAI

enum State { IDLE, WAKE, RUN, ATTACK, KNOCKBACK, DEAD }
var state: State = State.IDLE

var knockback_timer := 0.0
var knockback_duration := 0.15
var knockback_force := 200.0

@onready var body = get_parent()
@onready var pivot = body.get_node("Marker2D")
@onready var anim = body.get_node("Anim")
@onready var stats = body.get_node("Stats")
@onready var attack_area = pivot.get_node("AttackArea")
@onready var col_attack = attack_area.get_node("CollisionAttack")
@onready var agro_area = pivot.get_node("AgroArea")
@export var attack_range: float = 40.0


var detection
var movement
var combat

func _ready():
	col_attack.disabled = true

	detection = load("res://entities/enemies/DroidZapper/ai/detection.gd").new(self, agro_area)
	movement = load("res://entities/enemies/DroidZapper/ai/movement.gd").new(self)
	combat    = load("res://entities/enemies/DroidZapper/ai/combat.gd").new(self)

	detection.setup()

func _physics_process(delta):
	match state:
		State.IDLE: _state_idle()
		State.WAKE: _state_wake()
		State.RUN: _state_run(delta)
		State.ATTACK: _state_attack()
		State.KNOCKBACK: _state_knockback(delta)


func _state_idle():
	if detection.player_in_aggro:
		state = State.WAKE
		anim.play_wake()

func _state_wake():
	if anim.is_finished():
		state = State.RUN
		anim.play_run()

func _state_run(delta):
	movement.move_toward_target(delta)
	body.move_and_slide()

	if detection.target and \
		pivot.global_position.distance_to(detection.target.global_position) <= attack_range:
		state = State.ATTACK
		anim.play_attack()

func _state_attack():
	body.velocity.x = 0
	body.move_and_slide()

	col_attack.disabled = false
	combat.check_attack_hit()

	if anim.is_finished():
		col_attack.disabled = true
		state = State.RUN
		anim.play_run()

func _state_knockback(delta):
	body.move_and_slide()
	knockback_timer -= delta
	if knockback_timer <= 0:
		state = State.RUN
		anim.play_run()
