extends Control

@onready var health_bar: ProgressBar = $HealthBar
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
	await get_tree().process_frame
	
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		player.stats.health_changed.connect(_update_health)
		_update_health(player.stats.current_hp, player.stats.max_hp)
	else:
		printerr("HUD Error: No player found in 'player' groups")
	
	GameState.score_changed.connect(_update_score)
	_update_score(GameState.score)

func _update_health(current: float, max_val: float) -> void:
	health_bar.max_value = max_val
	health_bar.value = current

func _update_score(new_score: int) -> void:
	score_label.text = "Metal: " + str(new_score)
