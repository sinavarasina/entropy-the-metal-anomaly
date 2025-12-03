extends CharacterBody2D
class_name EnemyEntity

@export_group("Enemy Identity")
@export var is_boss: bool = false 
@export var entropy_reward: float = 1.0   
@export var id: int = 0

@export_group("Visuals")
@export var floating_text_scene: PackedScene = preload("res://scenes/ui/FloatingText/FloatingText.tscn")

@onready var stats: EnemyStats = $Stats
@onready var mover: EnemyMover = $Mover
@onready var ai: EnemyAI = $AI

func _ready() -> void:
	add_to_group("enemies")
	var current_mult = EntropySystem.multiplier
	apply_entropy(current_mult)

func apply_damage(amount: float, source_pos: Vector2 = Vector2.ZERO, is_crit: bool = false, is_kb: bool = false) -> void:
	if stats:
		var damage_dealt = stats.take_damage(amount)
		_spawn_damage_text(damage_dealt, is_crit)
	
	if ai and source_pos != Vector2.ZERO and is_kb:
		ai.trigger_knockback(source_pos)

func _spawn_damage_text(amount: float, is_crit: bool) -> void:
	if not floating_text_scene: return
	var txt = floating_text_scene.instantiate()
	get_tree().current_scene.add_child(txt)
	txt.set_damage(amount, is_crit)
	txt.global_position = global_position + Vector2(randf_range(-10, 10), -30)

func apply_entropy(multiplier: float) -> void:
	if stats: stats.apply_entropy(multiplier)
	if mover: mover.apply_entropy(multiplier)
	
