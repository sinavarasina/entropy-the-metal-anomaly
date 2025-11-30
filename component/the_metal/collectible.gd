extends Area2D

@export var score_value: int = 10
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "position:y", -5.0, 1.0).as_relative().set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite, "position:y", 5.0, 1.0).as_relative().set_trans(Tween.TRANS_SINE)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"): return
	
	collision.set_deferred("disabled", true)
	
	GameState.add_score(score_value)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.tween_property(sprite, "position:y", -20.0, 0.3).as_relative()
	
	var text_scene = preload("res://scenes/ui/FloatingText/FloatingText.tscn")
	var text = text_scene.instantiate()
	get_tree().current_scene.add_child(text)
	
	text.global_position = global_position
	text.set_status("+" + str(score_value), Color(1, 0.9, 0.2))
	
	await tween.finished
	queue_free()
