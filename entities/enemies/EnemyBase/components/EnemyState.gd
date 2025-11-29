extends Node
class_name EnemyState

var ai: EnemyAI
var entity: CharacterBody2D
var anim: AnimatedSprite2D

func setup(controller: EnemyAI) -> void:
	ai = controller
	entity = ai.entity
	anim = entity.get_node("Marker2D/AnimatedSprite2D")

func enter() -> void: pass
func exit() -> void: pass
func physics_update(delta: float) -> void: pass
func on_animation_finished() -> void: pass
