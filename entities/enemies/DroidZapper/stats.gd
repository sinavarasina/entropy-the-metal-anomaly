extends Node
class_name DroidZapperStats

@export var max_hp := 100
@export var attack := 6
@export var defense := 80
@export var speed := 60

var current_hp := max_hp

func apply_damage(amount: float):
	current_hp -= amount
	if current_hp <= 0:
		current_hp = 0
		if get_parent().has_method("die"):
			get_parent().die()
