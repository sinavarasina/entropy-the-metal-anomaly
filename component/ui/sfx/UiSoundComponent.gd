extends Node
func _ready():
	var btn = get_parent()
	if btn is BaseButton:
		btn.mouse_entered.connect(func(): AudioManager.play_sfx("hover"))
		btn.pressed.connect(func(): AudioManager.play_sfx("click"))
