extends Node
## STUB phase 2.

var current_game_over_payload: Dictionary = {}
var _hud = null


func _ready() -> void:
	pass


func set_hud_interface(hud) -> void:
	_hud = hud


func trigger_game_over(_payload: Dictionary) -> void:
	# Coroutine en impl phase 3. Stub : return immediate.
	await get_tree().process_frame
