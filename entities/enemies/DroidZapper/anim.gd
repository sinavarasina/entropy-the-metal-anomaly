# from https://penusbmic.itch.io/mega-sci-fi-character-pack
extends Node
class_name DroidZapperAnim

@onready var sprite: AnimatedSprite2D = get_parent().get_node("AnimatedSprite2D")

const ANIM_WAKE := "Wake"
const ANIM_RUN := "Run"
const ANIM_ATTACK := "Attack"
const ANIM_DEATH := "DamagedNDeath" 

var current_anim := ""

func play(name: String) -> void:
	if name == current_anim:
		return
	if sprite.sprite_frames.has_animation(name):
		current_anim = name
		sprite.play(name)

func play_wake(): play(ANIM_WAKE)
func play_run(): play(ANIM_RUN)
func play_attack(): play(ANIM_ATTACK)
func play_death(): play(ANIM_DEATH)

func is_finished() -> bool:
	return sprite.frame == sprite.sprite_frames.get_frame_count(current_anim) - 1 \
		and sprite.frame_progress >= 0.99
