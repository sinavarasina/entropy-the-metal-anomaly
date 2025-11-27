extends Node
class_name DroidZapperDetection

var ai
var agro_area: Area2D

var player_in_aggro: bool = false
var target: Node2D = null

func _init(ai_ref, agro_area_ref):
	ai = ai_ref
	agro_area = agro_area_ref 

func setup():
	agro_area.body_entered.connect(_on_aggro_entered)
	agro_area.body_exited.connect(_on_aggro_exited)

func _on_aggro_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_aggro = true
		target = body as Node2D

func _on_aggro_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_aggro = false
		target = null
