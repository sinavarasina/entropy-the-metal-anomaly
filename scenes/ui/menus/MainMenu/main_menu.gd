extends Control

func _ready() -> void:
	$VBoxContainerStart/BtnStart.pressed.connect(_on_start_pressed)
	$VBoxContainerSettings/BtnSettings.pressed.connect(_on_settings_pressed)
	$VBoxContainerQuit/BtnQuit.pressed.connect(_on_quit_pressed)
	AudioManager.play_bgm("main_menu")

func _on_start_pressed() -> void:
	SceneManager.load_level(SceneManager.LEVEL_1_PATH)

func _on_settings_pressed() -> void:
	SceneManager.load_menu(SceneManager.SETTINGS_MENU_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()
