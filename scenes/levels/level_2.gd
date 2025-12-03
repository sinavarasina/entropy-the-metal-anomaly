extends Node2D

func _ready() -> void:
	#AudioManager.play_bgm("level_2")
	GameState.level_completed.connect(_on_level_won)

func _on_level_won() -> void:
	GameState.level_completed.disconnect(_on_level_won)
	SceneManager.load_menu(SceneManager.VICTORY_PATH)
