extends CharacterBody2D

@onready var movement: Movement = $Movement
@onready var input: PlayerInput = $Input
@onready var anim: PlayerAnimation = $Anim

func _physics_process(delta: float) -> void:
	var dir := input.get_direction()

	movement.process_movement(self, dir, input, anim, delta)

	anim.update_animation(dir, velocity, self, input.is_jump_pressed(), delta)
