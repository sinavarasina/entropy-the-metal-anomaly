extends CharacterBody2D


const walk_SPEED = 250.0
const JUMP_VELOCITY = -330.0

@onready var animated_sprite = $AnimatedSprite2D

var can_double_jump = false
func _physics_process(delta: float) -> void:
	# Simpan status sebelum move_and_slide untuk deteksi mendarat
	var was_on_floor_before = is_on_floor()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Double jump logic
	if Input.is_action_just_pressed("player_up"):
		if is_on_floor():
			# Normal jump dari lantai
			velocity.y = JUMP_VELOCITY
			can_double_jump = true
		elif can_double_jump:
			# Double jump di udara
			velocity.y = JUMP_VELOCITY
			can_double_jump = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * walk_SPEED, walk_SPEED)
		animated_sprite.flip_h = direction < 0
		if is_on_floor():
			animated_sprite.play("Run")
		elif can_double_jump :
			animated_sprite.play("Jump")
		else :
			animated_sprite.play("DoubleJump")
	else:
		velocity.x = move_toward(velocity.x, 0, walk_SPEED)
		animated_sprite.play("Idle")

	move_and_slide()
	
	# Reset double jump hanya ketika benar-benar mendarat (transisi dari udara ke lantai)
	if is_on_floor() and not was_on_floor_before:
		can_double_jump = false
