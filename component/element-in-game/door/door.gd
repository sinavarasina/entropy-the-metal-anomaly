extends Node2D

@export_group("Gate Configuration")
@export var is_boss_gate: bool = false 
@export var required_score: int = 0 


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var door_collision: CollisionShape2D = $DoorCollision/doorcollisionarea
@onready var open_timer: Timer = $TimerDoor
@onready var info_label: Label = $Label

var player_near: bool = false
const OPEN_DELAY := 0.3
var tween_text: Tween

func _ready() -> void:
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)
	
	open_timer.timeout.connect(_on_open_timer_timeout)
	open_timer.one_shot = true
	
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	
	if info_label:
		info_label.modulate.a = 0.0

	sprite.play("doorclose")
	_set_collision(true)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"): return
	player_near = true
	
	if sprite.animation == "dooropen":
		return

	if is_boss_gate:
		_check_boss_gate_conditions()
	else:
		open_timer.start(OPEN_DELAY)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"): return
	player_near = false
	
	_fade_label(false)
	
	if open_timer.time_left > 0.0:
		open_timer.stop()
	
	if sprite.animation == "dooropen":
		sprite.play("doorclose")
		_set_collision(true)

func _on_open_timer_timeout() -> void:
	if not player_near: return
	
	_open_door()

func _check_boss_gate_conditions() -> void:
	var current_score = GameState.score
	var score_met = current_score >= required_score
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	var kroco_left = 0
	for enemy in enemies:
		var entity = enemy as EnemyEntity
		if entity and not entity.is_boss:
			kroco_left += 1
	var enemy_met = kroco_left <= 0
	
	if score_met and enemy_met:
		_open_door()
	else:
		var msg = "GATE LOCKED!\n"
		
		if not enemy_met:
			msg += "Enemies: %d left\n" % kroco_left
		else:
			msg += "Area Cleared (OK)\n"
			
		if required_score > 0:
			if not score_met:
				msg += "Metal: %d / %d" % [current_score, required_score]
			else:
				msg += "Metal Met (OK)"
		
		_update_info_label(msg, Color(1, 0.3, 0.3))
		_fade_label(true)

func _open_door() -> void:
	if sprite.animation != "dooropen":
		sprite.play("dooropen")
		_fade_label(false)

func _on_sprite_animation_finished() -> void:
	if sprite.animation == "dooropen":
		_set_collision(false)


func _set_collision(is_enabled: bool) -> void:
	if is_instance_valid(door_collision):
		door_collision.set_deferred("disabled", not is_enabled)

func _update_info_label(text: String, color: Color) -> void:
	if info_label:
		info_label.text = text
		info_label.modulate = Color(color.r, color.g, color.b, info_label.modulate.a)

func _fade_label(show: bool) -> void:
	if not info_label: return
	
	if tween_text and tween_text.is_valid():
		tween_text.kill()
	
	tween_text = create_tween()
	var target_alpha = 1.0 if show else 0.0
	
	tween_text.tween_property(info_label, "modulate:a", target_alpha, 0.3)
