extends Node

var score: int = 0
var coins: int = 0

signal score_changed(new_score: int)
signal coins_changed(new_amount: int)
signal level_completed

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func add_coin(amount: int) -> void:
	coins += amount
	coins_changed.emit(coins)

func on_enemy_killed(is_boss: bool) -> void:
	if not is_boss:
		add_score(50) 
		return
	else:
		add_score(200)

	print("BOSS DEFEATED! LEVEL COMPLETE!")
	
	#AudioManager.play_bgm("victory", 0.5)
	
	level_completed.emit()
	
	Engine.time_scale = 0.5
	await get_tree().create_timer(1.0).timeout
	Engine.time_scale = 1.0
