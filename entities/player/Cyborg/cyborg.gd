extends CharacterBody2D
class_name Cyborg

@onready var input: CyborgInput = $Input
@onready var movement: CyborgMovement = $Movement
@onready var anim: CyborgAnimation = $Anim
@onready var stats: CyborgStats = $Stats
@onready var controller: CyborgController = $Controller
@onready var shoot: AudioStreamPlayer = $shoot
@export var bullet_scene: PackedScene = preload("res://component/bullet/bullet.tscn")
@onready var muzzle: Marker2D = $Pivot/Muzzle
@onready var step: AudioStreamPlayer = $step
@onready var jump: AudioStreamPlayer = $jump

func _ready() -> void:
	controller.setup(self)
	
	var sprite_frames = anim.sprite.sprite_frames
	if sprite_frames.has_animation("FiringHotLaserbeam"):
		sprite_frames.set_animation_loop("FiringHotLaserbeam", false)

func _physics_process(delta: float) -> void:
	controller.update(delta)
