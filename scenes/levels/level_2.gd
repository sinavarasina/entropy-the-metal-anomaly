extends Node2D

const HUD_SCENE = preload("res://scenes/ui/PlayerHUD/PlayerHUD.tscn")

func _ready() -> void:
	AudioManager.play_bgm("level_2")
	GameState.level_completed.connect(_on_level_won)
	call_deferred("setup_hud")

func _on_level_won() -> void:
	GameState.level_completed.disconnect(_on_level_won)
	await get_tree().create_timer(2.0).timeout
	SceneManager.load_menu(SceneManager.VICTORY_PATH)

func setup_hud():
	if HUD_SCENE:
		var hud_instance = HUD_SCENE.instantiate()
		
		var canvas_layer = CanvasLayer.new()
		
		add_child(canvas_layer)
		
		canvas_layer.add_child(hud_instance)
		
	else:
		print("Error: HUD not found")
