extends Area2D
class_name Bullet

@export var speed: float = 600.0
var direction: float = 1.0

var damage: float = 0.0 

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
		
	var notifier = get_node_or_null("VisibleOnScreenNotifier2D")
	if notifier and not notifier.screen_exited.is_connected(_on_visible_on_screen_notifier_2d_screen_exited):
		notifier.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

	if direction < 0:
		$Sprite2D.flip_h = true 

func _physics_process(delta: float) -> void:
	position.x += speed * direction * delta

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("apply_damage"):
			body.apply_damage(damage, global_position) 
		queue_free()
		
	elif body.name != "Cyborg":
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
