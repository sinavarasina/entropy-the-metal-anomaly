extends CharacterBody2D
class_name EnemyEntity

@onready var stats: EnemyStats = $Stats
@onready var mover: EnemyMover = $Mover
@onready var ai: EnemyAI = $AI

func _ready() -> void:
	add_to_group("enemies")

func apply_damage(amount: float, source_pos: Vector2 = Vector2.ZERO) -> void:
	if stats:
		stats.take_damage(amount)
	
	if ai and source_pos != Vector2.ZERO:
		ai.trigger_knockback(source_pos)

func apply_entropy(multiplier: float) -> void:
	if stats: stats.apply_entropy(multiplier)
	if mover: mover.apply_entropy(multiplier)
