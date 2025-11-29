extends Node
class_name EnemyStats

signal health_depleted

@export_group("Attributes")
@export var max_hp: float = 100.0
@export var attack_damage: float = 10.0
@export var defense: float = 0.0

var current_hp: float = 0.0

func _ready() -> void:
	current_hp = max_hp

func take_damage(amount: float) -> void:
	var actual_damage = max(0, amount - defense)
	current_hp -= actual_damage
	
	if current_hp <= 0.0:
		current_hp = 0.0
		health_depleted.emit()

func apply_entropy(multiplier: float) -> void:
	max_hp *= multiplier
	attack_damage *= multiplier
	defense *= multiplier
	current_hp = max_hp
