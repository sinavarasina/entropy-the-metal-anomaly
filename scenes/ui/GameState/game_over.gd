extends Control

func _ready() -> void:
	# Hubungkan tombol
	$VBoxContainer/BtnRestart.pressed.connect(_on_restart_pressed)
	$VBoxContainer/BtnQuit.pressed.connect(_on_quit_pressed)
	
	# (Opsional) Pasang suara hover/click manual jika belum pakai komponen
	# Tapi sebaiknya pasang UiSoundComponent di editor ke child tombol ini
func _on_restart_pressed() -> void:
	SceneManager.reload_level()

func _on_quit_pressed() -> void:
	SceneManager.unload_level() # Bersihkan level
	SceneManager.load_menu(SceneManager.MAIN_MENU_PATH)
