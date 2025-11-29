extends Node
class_name EnemyAI

@export var initial_state: NodePath

@onready var entity: CharacterBody2D = get_parent()
@onready var stats: EnemyStats = entity.get_node("Stats")
@onready var mover: EnemyMover = entity.get_node("Mover")
@onready var vision: EnemyVision = entity.get_node("Marker2D/VisionArea") 
@onready var attack_area: Area2D = entity.get_node("Marker2D/AttackArea")

var current_state: EnemyState

func _ready() -> void:
	await get_parent().ready
	
	var anim = entity.get_node("Marker2D/AnimatedSprite2D")
	if not anim.animation_finished.is_connected(_on_anim_finished):
		anim.animation_finished.connect(_on_anim_finished)
	
	stats.health_depleted.connect(_on_death)
	
	for child in get_children():
		if child.has_method("setup"): 
			child.setup(self)
	
	if initial_state:
		change_state(get_node(initial_state))

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state: EnemyState) -> void:
	if not new_state: 
		printerr("AI Error: tryna move to empty state")
		return
	
	var old_state_name = "None"
	if current_state:
		old_state_name = current_state.name
		current_state.exit()
	
	print(entity.name, " Change State: ", old_state_name, " -> ", new_state.name)
	
	current_state = new_state
	current_state.enter()

func get_state_node(state_name: String) -> EnemyState:
	if has_node(state_name):
		return get_node(state_name) as EnemyState
	else:
		printerr(entity.name, " AI Error: no child has named '", state_name, "'")
		return null

func trigger_knockback(source_pos: Vector2):
	if current_state and current_state.name == "Death":
		return

	if has_node("Knockback"):
		var kb_state = get_node("Knockback") as EnemyState
		
		if kb_state:
			change_state(kb_state)
			if kb_state.has_method("apply_force"):
				kb_state.apply_force(source_pos)
		else:
			printerr(entity.name, " Error: Node 'Knockback' exist, but wrong class")

func _on_anim_finished() -> void:
	if current_state:
		current_state.on_animation_finished()

func _on_death() -> void:
	var death_node = get_state_node("Death")
	if death_node:
		change_state(death_node)
