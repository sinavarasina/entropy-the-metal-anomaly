extends Node
class_name CyborgStats

# ===== Combat Stats =====
@export var attack_damage: float = 1000

# ===== Movement Stats =====
@export var move_speed: float = 250.0
@export var gravity: float = 900.0
@export var jump_force: float = -330.0
@export var double_jump_force: float = -330.0
@export var ground_acceleration: float = 2500.0
@export var ground_friction: float = 2500.0
@export var air_acceleration: float = 800.0
@export var air_friction: float = 200.0

# ===== Animation Thresholds =====
@export var fall_threshold: float = 2000.0
@export var jump_threshold: float = -10.0
@export var run_threshold: float = 0.1
