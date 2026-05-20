extends Node
## Orchestrateur du game over. Reçoit un payload générique,
## anime via le HUD (injectable pour tests), puis transitionne
## vers GameOverScreen via LocationManager.

const CHEMIN_GAME_OVER := "res://scenes/core/GameOverScreen.tscn"

var current_game_over_payload: Dictionary = {}
var _hud = null


func _ready() -> void:
	# Auto-wire avec le HUD autoload réel
	_hud = get_node_or_null("/root/SurveillanceHUD")


func set_hud_interface(hud) -> void:
	_hud = hud


## Coroutine. Appelants doivent utiliser `await`.
func trigger_game_over(payload: Dictionary) -> void:
	_validate_payload(payload)
	current_game_over_payload = payload

	if _hud and _hud.has_method("show_game_over_overlay"):
		_hud.show_game_over_overlay(payload["overlay_quote"])
		if _hud.has_signal("game_over_overlay_finished"):
			await _hud.game_over_overlay_finished
	else:
		# Fallback : pas de HUD branché (cas test minimal)
		await get_tree().process_frame

	# Transition de scène — utilise LocationManager existant (Prompt 1)
	# si présent ; sinon change_scene_to_file direct.
	var lm := get_node_or_null("/root/LocationManager")
	if lm and lm.has_method("aller_a_scene"):
		lm.aller_a_scene("game_over_" + String(payload["type"]), CHEMIN_GAME_OVER)


func _validate_payload(payload: Dictionary) -> void:
	for cle in ["type", "title", "overlay_quote", "history"]:
		assert(payload.has(cle), "trigger_game_over: payload sans clé '%s'" % cle)
