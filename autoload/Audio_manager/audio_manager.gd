# ====================================================================
# File: AudioMaster.gd
# Didaftarkan sebagai Autoload/Singleton di Project Settings.
# ====================================================================

extends Node

# --------------------------------------------------------------------
# Deklarasi Node & Aset
# --------------------------------------------------------------------

# Onready memastikan node sudah siap saat script dieksekusi
@onready var BGM_Player: AudioStreamPlayer = $BGM_Player
@onready var SFX_Player: AudioStreamPlayer = $SFX_Player


# Kamus (Dictionary) untuk memetakan nama SFX ke jalur file (path)
# Anda bisa menambahkan atau memuat kamus ini dari file JSON/Resource lain.
const SFX_PATHS = {
	"jump": ["res://assets/SoundEffect/Jumping/Jump.mp3", -16.0],   # Lebih senyap
	"double_jump": ["res://assets/SoundEffect/Jumping/Jumping 1.mp3", -6.0],
	"shoot": ["res://assets/SoundEffect/Shoot/Shoot 8.mp3", -3.0],   # Paling keras
	"step": ["res://assets/SoundEffect/step/step_metal.ogg", -12.0], # Sangat senyap
}

# --------------------------------------------------------------------
# Fungsi Utilitas Audio (Volume Control)
# --------------------------------------------------------------------

# Fungsi bantu untuk konversi volume linear (0.0-1.0) ke desibel (dB)
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0 # Nilai minimum untuk 'mute'
	return 20 * log(linear) / log(10)

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
	if bus_index != -1: # Pastikan Bus 'BGM' ada
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_vol))

# Mengatur volume Sound Effects (SFX)
func set_sfx_volume(linear_vol: float):
	var bus_index = AudioServer.get_bus_index("SFX")
	if bus_index != -1: # Pastikan Bus 'SFX' ada
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_vol))

# --------------------------------------------------------------------
# Fungsi Pemutaran
# --------------------------------------------------------------------

# Memainkan Sound Effect
# Memainkan Sound Effect
func play_sfx(sfx_name: String):
	# Cek apakah nama SFX ada di kamus
	if SFX_PATHS.has(sfx_name):
		
		# 1. Ambil array [Path, Volume]
		var sfx_data = SFX_PATHS[sfx_name]
		
		var sfx_path = sfx_data[0]        # Ambil Path (index 0)
		var sfx_volume_db = sfx_data[1]   # Ambil Volume dB (index 1)
		
		var stream = load(sfx_path)
		
		# 2. Atur volume pada AudioStreamPlayer sebelum play
		SFX_Player.volume_db = sfx_volume_db
		
		# 3. Mainkan Stream
		SFX_Player.stream = stream
		SFX_Player.play()
	else:
		print("Error: SFX tidak ditemukan: " + sfx_name)

# Memainkan Background Music (BGM)
func play_bgm(bgm_path: String, _fade_duration: float = 0.5):
	# Cek apakah BGM sudah berjalan dan merupakan BGM yang sama
	if BGM_Player.stream and BGM_Player.stream.resource_path == bgm_path and BGM_Player.playing:
		return # Tidak perlu memulai ulang

	# Muat stream baru
	var stream = load(bgm_path)
	if stream:
		BGM_Player.stream = stream
		BGM_Player.play()
		# Jika perlu fade-in, tambahkan Tween di sini

func stop_bgm(_fade_duration: float = 0.5):
	if BGM_Player.playing:
		# Jika perlu fade-out, tambahkan Tween di sini
		BGM_Player.stop()
		
# --------------------------------------------------------------------
