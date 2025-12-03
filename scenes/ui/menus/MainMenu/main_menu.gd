extends Control

func _ready() -> void:
	$VBoxContainer/BtnStart.pressed.connect(_on_start_pressed)
	$VBoxContainer/BtnSettings.pressed.connect(_on_settings_pressed)
	$VBoxContainer/BtnQuit.pressed.connect(_on_quit_pressed)
	AudioManager.play_bgm_by_name("main_menu")

func _on_start_pressed() -> void:
	AudioManager.play_bgm_by_name("level_1")
	SceneManager.load_level(SceneManager.LEVEL_1_PATH)

func _on_settings_pressed() -> void:
	SceneManager.load_menu(SceneManager.SETTINGS_MENU_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()
