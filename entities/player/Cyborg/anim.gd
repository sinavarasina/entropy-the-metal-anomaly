extends Node
class_name CyborgAnimation

@onready var sprite: AnimatedSprite2D = get_parent().get_node("AnimatedSprite2D")
#@onready var fireEf: AnimatedSprite2D = get_parent().get_node("FireEf")

var can_double_jump = false

func set_can_double_jump(value: bool) -> void:
	can_double_jump = value

func update_animation(
	dir: Vector2,
	vel: Vector2,
	body: CharacterBody2D,
	jump_pressed: bool,
	fire_pressed: bool,
	delta: float
) -> void:
	var stats: CyborgStats = body.get_node("Stats")
	var on_ground := body.is_on_floor()

	# Flip sprite based on direction
	if dir.x < 0:
		sprite.flip_h = true
	elif dir.x > 0:
		sprite.flip_h = false

	# ====== LOGIKA FIRING ======
	if fire_pressed:
		sprite.play("FiringHotLaserbeam")
		return

	# ====== LOGIKA ANIMASI ======
	if on_ground:
		# Gunakan run_threshold untuk menentukan Run vs Idle
		if abs(dir.x) > stats.run_threshold:
			sprite.play("Run2Laserbeam")
		else:
			sprite.play("Idle2Laserbeam")
	else:
		# Di udara
		if vel.y < stats.jump_threshold:
			# Lagi naik
			if can_double_jump:
				# Loncat pertama
				sprite.play("Jump2Laserbeam")
			else:
				# Setelah double jump
				sprite.play("DoubleJump")
		else:
			# Lagi jatuh (velocity.y > 0)
			if dir.x == 0:
				# Jatuh tanpa gerakan horizontal → Fall
				sprite.play("Fall")
			else:
				# Jatuh dengan gerakan horizontal → Jump
				sprite.play("Jump2Laserbeam")
