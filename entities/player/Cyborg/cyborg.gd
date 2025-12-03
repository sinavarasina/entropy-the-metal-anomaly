extends CharacterBody2D
class_name Cyborg

@onready var input: CyborgInput = $Input
@onready var movement: CyborgMovement = $Movement
@onready var anim: CyborgAnimation = $Anim
@onready var stats: CyborgStats = $Stats
@onready var controller: CyborgController = $Controller
@export var bullet_scene: PackedScene = preload("res://component/bullet/bullet.tscn")
@onready var muzzle: Marker2D = $Pivot/Muzzle

func _ready() -> void:
	add_to_group("player")
	controller.setup(self)
	
	var sprite_frames = anim.sprite.sprite_frames
	if sprite_frames.has_animation("FiringHotLaserbeam"):
		sprite_frames.set_animation_loop("FiringHotLaserbeam", false)

func _physics_process(delta: float) -> void:
	controller.update(delta)

func apply_damage(amount: float, source_pos: Vector2 = Vector2.ZERO, is_crit: bool = false, is_kb: bool = false, status_effect: PackedScene = null) -> void:
	if stats:
		stats.take_damage(amount)
	if controller:
		controller.trigger_hurt()
