extends Node

# --- KONFIGURASI ---
const NUM_SFX_PLAYERS = 12 
const BUS_BGM = "BGM"
const BUS_SFX = "SFX"

# --- DATABASE  ---
var SFX_LIBRARY: Dictionary = {}
var BGM_LIBRARY: Dictionary = {}

# --- INTERNAL VARIABLES ---
var _bgm_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_pool_index: int = 0
var _loaded_resources: Dictionary = {}

func _ready() -> void:
	_load_banks()
	
	_setup_bgm_player()
	_setup_sfx_pool()

# --- LOAD DATA ---
func _load_banks() -> void:
	SFX_LIBRARY.merge(SfxPlayer.data)
	SFX_LIBRARY.merge(SfxUI.data)
	# SFX_LIBRARY.merge(SfxEnemy.data)
	
	BGM_LIBRARY.merge(BgmList.data)
	
	print("AudioManager: rede! Total SFX: ", SFX_LIBRARY.size(), " | Total BGM: ", BGM_LIBRARY.size())

# --- SETUP NODES ---
func _setup_bgm_player() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.name = "BGM_Player"
	_bgm_player.bus = BUS_BGM
	add_child(_bgm_player)

func _setup_sfx_pool() -> void:
	for i in range(NUM_SFX_PLAYERS):
		var sfx = AudioStreamPlayer.new()
		sfx.name = "SFX_Pool_" + str(i)
		sfx.bus = BUS_SFX
		add_child(sfx)
		_sfx_pool.append(sfx)

# --- PUBLIC SFX FUNCTIONS ---

func play_sfx(sfx_name: String) -> void:
	if not SFX_LIBRARY.has(sfx_name):
		printerr("AudioManager: SFX not found -> ", sfx_name)
		return
		
	var data = SFX_LIBRARY[sfx_name]
	var path = data[0]
	var vol_db = data[1]
	
	var stream = _get_resource(path)
	if not stream: return
	
	var player = _sfx_pool[_sfx_pool_index]
	player.stream = stream
	player.volume_db = vol_db
	
	# Sedikit variasi pitch (0.95 - 1.05)
	if "step" in sfx_name or "shoot" in sfx_name: 
		player.pitch_scale = randf_range(0.95, 1.05)
	else:
		player.pitch_scale = 1.0
		
	player.play()
	
	_sfx_pool_index = (_sfx_pool_index + 1) % NUM_SFX_PLAYERS

func is_sfx_playing(sfx_name: String) -> bool:
	if not SFX_LIBRARY.has(sfx_name): return false
	var path = SFX_LIBRARY[sfx_name][0]
	
	for player in _sfx_pool:
		if player.playing and player.stream and player.stream.resource_path == path:
			return true
	return false

func stop_sfx(sfx_name: String) -> void:
	if not SFX_LIBRARY.has(sfx_name): return
	var path = SFX_LIBRARY[sfx_name][0]
	
	for player in _sfx_pool:
		if player.playing and player.stream and player.stream.resource_path == path:
			player.stop()

# --- PUBLIC BGM FUNCTIONS ---

func play_bgm(bgm_name: String, fade_time: float = 0.5) -> void:
	if not BGM_LIBRARY.has(bgm_name): 
		printerr("AudioManager: BGM tidak ditemukan -> ", bgm_name)
		return
	
	var data = BGM_LIBRARY[bgm_name]
	var path = data[0]
	var target_vol = data[1]
	
	if _bgm_player.playing and _bgm_player.stream and _bgm_player.stream.resource_path == path:
		return

	var stream = _get_resource(path)
	if not stream: return
	
	# Crossfade Logic
	if _bgm_player.playing:
		var tween = create_tween()
		tween.tween_property(_bgm_player, "volume_db", -80.0, fade_time * 0.5)
		tween.tween_callback(func(): _start_bgm_stream(stream, target_vol, fade_time * 0.5))
	else:
		_start_bgm_stream(stream, target_vol, fade_time)

func _start_bgm_stream(stream: AudioStream, target_vol: float, fade_in_time: float):
	_bgm_player.stream = stream
	_bgm_player.volume_db = -80.0
	_bgm_player.play()
	
	var tween = create_tween()
	tween.tween_property(_bgm_player, "volume_db", target_vol, fade_in_time)

func stop_bgm(fade_time: float = 0.5):
	var tween = create_tween()
	tween.tween_property(_bgm_player, "volume_db", -80.0, fade_time)
	tween.tween_callback(_bgm_player.stop)

# --- UTILITIES ---

func _get_resource(path: String) -> AudioStream:
	if _loaded_resources.has(path):
		return _loaded_resources[path]
	
	if ResourceLoader.exists(path):
		var res = load(path)
		_loaded_resources[path] = res
		return res
	
	printerr("AudioManager: File not found at path -> ", path)
	return null

# --- VOLUME CONTROL HELPERS ---

func set_master_volume(linear_vol: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(linear_vol))

func set_bgm_volume(linear_vol: float):
	var idx = AudioServer.get_bus_index(BUS_BGM)
	if idx != -1: AudioServer.set_bus_volume_db(idx, linear_to_db(linear_vol))

func set_sfx_volume(linear_vol: float):
	var idx = AudioServer.get_bus_index(BUS_SFX)
	if idx != -1: AudioServer.set_bus_volume_db(idx, linear_to_db(linear_vol))

func linear_to_db(linear: float) -> float:
	return -80.0 if linear <= 0 else 20 * log(linear) / log(10)
