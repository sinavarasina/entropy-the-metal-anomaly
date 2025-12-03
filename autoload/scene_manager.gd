extends Node

var world_root: Node2D
var ui_root: CanvasLayer

var current_level: Node = null
var current_menu: Node = null
var is_game_paused: bool = false

var current_level_path: String = "" 

# --- DATABASE PATH SCENE ---
const MAIN_MENU_PATH = "res://scenes/ui/menus/MainMenu/MainMenu.tscn"
const PAUSE_MENU_PATH = "res://scenes/ui/menus/PauseMenu/PauseMenu.tscn"
const SETTINGS_MENU_PATH = "res://scenes/ui/menus/SettingsMenu/SettingsMenu.tscn"
const GAME_OVER_PATH = "res://scenes/ui/GameState/game_over.tscn"
const VICTORY_PATH = "res://scenes/ui/GameState/victory.tscn"
const HUD_PATH = "res://scenes/ui/PlayerHUD/PlayerHUD.tscn"
const LEVEL_1_PATH = "res://scenes/levels/Level1.tscn"
const LEVEL_2_PATH = "res://scenes/levels/Level2.tscn"

func _ready() -> void:
	var main = get_tree().root.get_node("Main")
	if main:
		world_root = main.get_node("WorldRoot")
		ui_root = main.get_node("UiRoot")
		
		load_menu(MAIN_MENU_PATH)
	else:
		printerr("SceneManager Error: Node 'Main' not found in root!")

# ==============================================================================
# LEVEL MANAGEMENT
# ==============================================================================

func load_level(level_path: String) -> void:
	unload_menu()
	unload_level()
	
	current_level_path = level_path
	
	var level_res = load(level_path)
	if level_res:
		current_level = level_res.instantiate()
		world_root.add_child(current_level)
		
		load_hud()
		
		get_tree().paused = false
		is_game_paused = false
		
	else:
		printerr("SceneManager: Failed to load Level at -> ", level_path)

func reload_level() -> void:
	if current_level_path != "":
		load_level(current_level_path)
	else:
		printerr("SceneManager: No Level saved to restart.")

func unload_level() -> void:
	if current_level:
		current_level.queue_free()
		current_level = null
	unload_hud()

# ==============================================================================
# MENU MANAGEMENT
# ==============================================================================

func load_menu(menu_path: String) -> void:
	unload_menu()
	
	var menu_res = load(menu_path)
	if menu_res:
		current_menu = menu_res.instantiate()
		ui_root.add_child(current_menu)
	else:
		printerr("SceneManager: Failed to load menu at -> ", menu_path)

func unload_menu() -> void:
	if current_menu:
		current_menu.queue_free()
		current_menu = null

# ==============================================================================
# HUD MANAGEMENT
# ==============================================================================

func load_hud() -> void:
	if not ui_root.has_node("PlayerHUD"):
		var hud_res = load(HUD_PATH)
		if hud_res:
			var hud = hud_res.instantiate()
			hud.name = "PlayerHUD" 
			ui_root.add_child(hud)
		else:
			printerr("SceneManager: HUD scene not found at -> ", HUD_PATH)

func unload_hud() -> void:
	if ui_root.has_node("PlayerHUD"):
		ui_root.get_node("PlayerHUD").queue_free()

# ==============================================================================
# GAME STATES (PAUSE, WIN, LOSE)
# ==============================================================================

func toggle_pause() -> void:
	if not current_level: return
	
	is_game_paused = !is_game_paused
	get_tree().paused = is_game_paused
	
	if is_game_paused:
		var pause_res = load(PAUSE_MENU_PATH)
		if pause_res:
			var pause_menu = pause_res.instantiate()
			ui_root.add_child(pause_menu)
			current_menu = pause_menu
	else:
		unload_menu()

func show_game_over() -> void:
	await get_tree().create_timer(1.0).timeout
	load_menu(GAME_OVER_PATH)
	get_tree().paused = true #
