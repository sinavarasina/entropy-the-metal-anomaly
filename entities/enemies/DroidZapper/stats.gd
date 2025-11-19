extends Node
class_name DroidZapperStats

@export var max_hp: float = 100.0
@export var attack: float = 6.0
@export var defense: float = 80.0
@export var speed: float = 60.0

var current_hp: float = 0.0


func _ready() -> void:
	current_hp = max_hp


func apply_damage(amount: float) -> void:
	current_hp -= amount
	if current_hp < 0.0:
		current_hp = 0.0


func apply_entropy(multiplier: float) -> void:
	max_hp *= multiplier
	attack *= multiplier
	defense *= multiplier
	speed *= multiplier

	current_hp = max_hp
