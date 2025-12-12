extends Node
class_name CyborgStats

signal health_changed(current_hp: float, max_hp: float)
signal player_died

# ===== Combat Stats =====
@export var max_hp: float = 1750
@export var attack_damage: float = 100
@export var luck: float = 10.0
@export var base_crit_rate: float = 0.1 
@export var base_knockback_rate: float = 0.2
@export var crit_multiplier: float = 2.0

# ===== Movement Stats =====
@export var move_speed: float = 250.0
@export var gravity: float = 900.0
@export var jump_force: float = -330.0
@export var double_jump_force: float = -330.0
@export var ground_acceleration: float = 2500.0
@export var ground_friction: float = 2500.0
@export var air_acceleration: float = 800.0
@export var air_friction: float = 200.0

# ===== Animation Thresholds =====
@export var fall_threshold: float = 2000.0
@export var jump_threshold: float = -10.0
@export var run_threshold: float = 0.1

var current_hp: float

func _ready() -> void:
	current_hp = max_hp
	health_changed.emit(current_hp, max_hp)
	
func take_damage(amount: float) -> void:
	current_hp -= amount
	print("Player HP: ", current_hp)
	
	health_changed.emit(current_hp, max_hp)
	
	if current_hp <= 0:
		current_hp = 0
		player_died.emit()

func get_crit_rate() -> float:
	return base_crit_rate + (luck * 0.001)

func get_knockback_rate() -> float:
	return base_knockback_rate + (luck * 0.002)
