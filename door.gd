extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection_area: Area2D = $DetectionArea
@onready var door_collision: CollisionShape2D = $DoorCollision/doorcollisionarea
@onready var open_timer: Timer = $TimerDoor

var player_near: bool = false
const OPEN_DELAY := 1.0

func _ready() -> void:
	detection_area.body_entered.connect(_on_detection_area_body_entered)
	detection_area.body_exited.connect(_on_detection_area_body_exited)

	open_timer.timeout.connect(_on_open_timer_timeout)
	open_timer.one_shot = true

	sprite.animation_finished.connect(_on_sprite_animation_finished)

	# mulai dari tertutup
	sprite.play("doorclose")
	if is_instance_valid(door_collision):
		door_collision.set_deferred("disabled", false)


func _on_detection_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_near = true
	open_timer.start(OPEN_DELAY)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	player_near = false

	# kalau player keluar sebelum 3 detik, cancel buka pintu
	if open_timer.time_left > 0.0:
		open_timer.stop()

	# tutup pintu & aktifkan collision lagi
	sprite.play("doorclose")
	if is_instance_valid(door_collision):
		door_collision.set_deferred("disabled", false)


func _on_open_timer_timeout() -> void:
	# Timer cuma eksekusi kalau player masih di dekat pintu
	if not player_near:
		return

	sprite.play("dooropen")
	#if is_instance_valid(door_collision):
	#	 door_collision.set_deferred("disabled", true)


func _on_sprite_animation_finished() -> void:
	# Cek animasi apa yang baru selesai
	if sprite.animation == "dooropen":
		# baru boleh dilewatin player
		if is_instance_valid(door_collision):
			door_collision.set_deferred("disabled", true)
