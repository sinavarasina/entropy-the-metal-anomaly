# ====================================================================
# File: AudioMaster.gd
# Didaftarkan sebagai Autoload/Singleton di Project Settings.
# ====================================================================
extends Node

@onready var BGM_Player: AudioStreamPlayer = $BGM_Player
@onready var SFX_Player: AudioStreamPlayer = $SFX_Player
var current_sfx_name: String = ""



# Kamus (Dictionary) untuk memetakan nama SFX ke jalur file (path)
# Anda bisa menambahkan atau memuat kamus ini dari file JSON/Resource lain.
const SFX_PATHS = {
	"jump": ["res://assets/SoundEffect/Jumping/Jump.mp3", -10.0],
	"double_jump": ["res://assets/SoundEffect/Jumping/Jump.mp3", -10.0],
	"shoot": ["res://assets/SoundEffect/Shoot/Shoot 8.mp3", -3.0],
	"step": ["res://assets/SoundEffect/step/step_metal.ogg", 1.0],
	"hover":["res://assets/SoundEffect/Hover/Hover 4.mp3",1.0],
	"click":["res://assets/SoundEffect/Click/Click 1.mp3",1.0],
	"slash":["res://assets/SoundEffect/Slash/sword-slash-01-266296.mp3",-6.0],
	"death":["res://assets/SoundEffect/death/male-death-sound-128357.mp3",-10.0],
	"hurt":["res://assets/SoundEffect/hurt/male-hurt-sound-95206.mp3",-10.0],
}

# Kamus untuk memetakan nama BGM ke jalur file dan volume default
const BGM_PATHS = {
	"main_menu": ["res://assets/BGM/main_menu/main_menu 2.mp3", 1.0],
	"level_1": ["res://assets/BGM/BGM 7.mp3", 1.0],
	"boss_battle": ["res://assets/Music/BossBattle.mp3", -5.0],
	"victory": ["res://assets/Music/Victory.mp3", -12.0],
}

# Variable untuk menyimpan volume default
var default_bgm_volume: float = 0.0  # dalam dB
var current_bgm_volume: float = 0.0  # volume BGM saat ini

# --------------------------------------------------------------------
# Fungsi Utilitas Audio (Volume Control)
# --------------------------------------------------------------------

# Fungsi bantu untuk konversi volume linear (0.0-1.0) ke desibel (dB)
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0 # Nilai minimum untuk 'mute'
	return 20 * log(linear) / log(10)

# Fungsi bantu untuk konversi desibel (dB) ke linear (0.0-1.0)
func db_to_linear(db: float) -> float:
	if db <= -80.0:
		return 0.0
	return pow(10, db / 20.0)

# --------------------------------------------------------------------
# Fungsi Kontrol Volume Bus
# --------------------------------------------------------------------

# Mengatur volume Master secara global
func set_master_volume(linear_vol: float):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_vol))

# Mengatur volume Music (BGM)
func set_bgm_volume(linear_vol: float):
	var bus_index = AudioServer.get_bus_index("BGM")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_vol))

# Mengatur volume Sound Effects (SFX)
func set_sfx_volume(linear_vol: float):
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_vol))

# --------------------------------------------------------------------
# Fungsi Kontrol Volume BGM Player (Individual)
# --------------------------------------------------------------------

# Mengatur volume BGM Player secara langsung (dalam dB)
func set_bgm_player_volume_db(volume_db: float):
	BGM_Player.volume_db = volume_db
	current_bgm_volume = volume_db

# Mengatur volume BGM Player secara linear (0.0-1.0)
func set_bgm_player_volume_linear(linear_vol: float):
	var db_vol = linear_to_db(linear_vol)
	set_bgm_player_volume_db(db_vol)

# Mendapatkan volume BGM Player saat ini (dalam dB)
func get_bgm_player_volume_db() -> float:
	return BGM_Player.volume_db

# Mendapatkan volume BGM Player saat ini (linear 0.0-1.0)
func get_bgm_player_volume_linear() -> float:
	return db_to_linear(BGM_Player.volume_db)

# --------------------------------------------------------------------
# Fungsi Pemutaran SFX
# --------------------------------------------------------------------

# Memainkan Sound Effect
func play_sfx(sfx_name: String):
	if SFX_PATHS.has(sfx_name):
		var sfx_data = SFX_PATHS[sfx_name]
		var sfx_path = sfx_data[0]
		var sfx_volume_db = sfx_data[1]
		
		var stream = load(sfx_path)
		if stream:
			current_sfx_name = sfx_name
			SFX_Player.volume_db = sfx_volume_db
			SFX_Player.stream = stream
			SFX_Player.play()
		else:
			print("Error: Tidak dapat memuat SFX: " + sfx_path)
	else:
		print("Error: SFX tidak ditemukan: " + sfx_name)

# Menghentikan Sound Effect yang sedang diputar
func stop_sfx(name: String):
	if current_sfx_name == name and SFX_Player.playing:
		SFX_Player.stop()
		current_sfx_name = ""


# Mengecek apakah SFX sedang diputar
func is_sfx_playing(name: String) -> bool:
	return current_sfx_name == name and SFX_Player.playing


# --------------------------------------------------------------------
# Fungsi Pemutaran BGM
# --------------------------------------------------------------------

# Memainkan BGM dengan nama (menggunakan BGM_PATHS)
func play_bgm_by_name(bgm_name: String, fade_duration: float = 0.5):
	if BGM_PATHS.has(bgm_name):
		var bgm_data = BGM_PATHS[bgm_name]
		var bgm_path = bgm_data[0]
		var bgm_volume = bgm_data[1]
		
		play_bgm(bgm_path, fade_duration, bgm_volume)
	else:
		print("Error: BGM tidak ditemukan: " + bgm_name)

# Memainkan Background Music (BGM) dengan path langsung
func play_bgm(bgm_path: String, fade_duration: float = 0.5, volume_db: float = 0.0):
	# Cek apakah BGM sudah berjalan dan merupakan BGM yang sama
	if BGM_Player.stream and BGM_Player.stream.resource_path == bgm_path and BGM_Player.playing:
		return
	
	var stream = load(bgm_path)
	if stream:
		# Stop BGM sebelumnya jika ada
		if BGM_Player.playing:
			stop_bgm(fade_duration)
			await get_tree().create_timer(fade_duration).timeout
		
		BGM_Player.stream = stream
		BGM_Player.volume_db = volume_db
		current_bgm_volume = volume_db
		
		# Fade-in effect
		if fade_duration > 0:
			BGM_Player.volume_db = -80.0
			BGM_Player.play()
			
			var tween = create_tween()
			tween.tween_property(BGM_Player, "volume_db", volume_db, fade_duration)
		else:
			BGM_Player.play()
	else:
		print("Error: Tidak dapat memuat BGM: " + bgm_path)

# Menghentikan BGM dengan fade-out
func stop_bgm(fade_duration: float = 0.5):
	if BGM_Player.playing:
		if fade_duration > 0:
			var tween = create_tween()
			tween.tween_property(BGM_Player, "volume_db", -80.0, fade_duration)
			tween.tween_callback(BGM_Player.stop)
		else:
			BGM_Player.stop()

# Pause BGM
func pause_bgm():
	if BGM_Player.playing:
		BGM_Player.stream_paused = true

# Resume BGM
func resume_bgm():
	if BGM_Player.stream_paused:
		BGM_Player.stream_paused = false

# Mengecek apakah BGM sedang diputar
func is_bgm_playing() -> bool:
	return BGM_Player.playing and not BGM_Player.stream_paused

# --------------------------------------------------------------------
# Fungsi Tambahan
# --------------------------------------------------------------------

# Mute/Unmute semua audio
func set_mute_all(muted: bool):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus_index, muted)

# Mute/Unmute BGM
func set_mute_bgm(muted: bool):
	var bus_index = AudioServer.get_bus_index("BGM")
	if bus_index != -1:
		AudioServer.set_bus_mute(bus_index, muted)

# Mute/Unmute SFX
func set_mute_sfx(muted: bool):
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1:
		AudioServer.set_bus_mute(bus_index, muted)

# --------------------------------------------------------------------
