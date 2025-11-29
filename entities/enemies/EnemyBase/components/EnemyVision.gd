extends Area2D
class_name EnemyVision

var target: Node2D = null

func _ready() -> void:
	monitoring = true 
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	print("VISION: something are detected -> ", body.name)
	if body.is_in_group("player"):
		print("VISION: Player detected") 
		target = body as Node2D

func _on_body_exited(body: Node) -> void:
	if body == target:
		target = null

func get_target() -> Node2D:
	if target and is_instance_valid(target):
		return target
	return null
