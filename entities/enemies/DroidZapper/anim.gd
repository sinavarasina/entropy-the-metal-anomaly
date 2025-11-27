extends Node
class_name DroidZapperAnim

@onready var sprite: AnimatedSprite2D = get_parent().get_node("Marker2D/AnimatedSprite2D")

const ANIM_WAKE: String  = "Wake"
const ANIM_RUN: String   = "Run"
const ANIM_ATTACK: String = "Attack"
const ANIM_DEATH: String  = "DamagedNDeath"

var current_anim: String = ""


func _ready() -> void:
	var frames: SpriteFrames = sprite.sprite_frames

	if frames.has_animation(ANIM_WAKE):
		frames.set_animation_loop(ANIM_WAKE, false)
	if frames.has_animation(ANIM_ATTACK):
		frames.set_animation_loop(ANIM_ATTACK, false)
	if frames.has_animation(ANIM_DEATH):
		frames.set_animation_loop(ANIM_DEATH, false)

	if frames.has_animation(ANIM_RUN):
		frames.set_animation_loop(ANIM_RUN, true)

	current_anim = sprite.animation


func play(name: String) -> void:
	if name == current_anim:
		return
	if sprite.sprite_frames.has_animation(name):
		current_anim = name
		sprite.play(name)


func play_wake() -> void:
	play(ANIM_WAKE)

func play_run() -> void:
	play(ANIM_RUN)

func play_attack() -> void:
	play(ANIM_ATTACK)

func play_death() -> void:
	play(ANIM_DEATH)


#func set_flip(dir: float) -> void:
	#if dir < 0.0:
		#sprite.flip_h = true
	#elif dir > 0.0:
		#sprite.flip_h = false


func is_finished() -> bool:
	return not sprite.is_playing()
