extends Node
## Dette d'authenticité. 0 à 100. À 100 → game over miroir
## (flashback de l'ex).

signal mirror_status_changed(ancien: int, nouveau: int, raison: String)
signal threshold_crossed(niveau: int)
signal breakdown_imminent

const THRESHOLDS := [30, 60, 90]
const MAX := 100

var _status: int = 0
var _thresholds_already_crossed: Array[int] = []


# --- API ------------------------------------------------------------------

func increase(amount: int, raison: String = "") -> void:
	assert(amount > 0, "increase: amount doit être > 0")
	_set_status(_status + amount, raison)


func decrease(amount: int, raison: String = "") -> void:
	assert(amount > 0, "decrease: amount doit être > 0")
	_set_status(_status - amount, raison)


func get_status() -> int:
	return _status


## Phrase narrative pour l'overlay du game over miroir.
## Consomme ExProfileManager.
func get_overlay_quote() -> String:
	var ex := get_node_or_null("/root/ExProfileManager")
	if ex and ex.has_method("get_echo_phrase"):
		return ex.get_echo_phrase()
	return ""


# --- Sérialisation --------------------------------------------------------

func save_state() -> Dictionary:
	return {
		"status": _status,
		"thresholds_already_crossed": _thresholds_already_crossed.duplicate(),
	}


func load_state(data: Dictionary) -> void:
	_status = clampi(int(data.get("status", 0)), 0, MAX)
	_thresholds_already_crossed.clear()
	for v in data.get("thresholds_already_crossed", []):
		_thresholds_already_crossed.append(int(v))


func reset_all_for_new_game() -> void:
	_status = 0
	_thresholds_already_crossed.clear()


# --- Interne --------------------------------------------------------------

func _set_status(nouveau: int, raison: String) -> void:
	var ancien := _status
	_status = clampi(nouveau, 0, MAX)
	if _status == ancien:
		return
	mirror_status_changed.emit(ancien, _status, raison)
	_check_thresholds(ancien, _status)
	if _status >= MAX and not (MAX + 1) in _thresholds_already_crossed:
		_thresholds_already_crossed.append(MAX + 1)
		breakdown_imminent.emit()


func _check_thresholds(ancien: int, nouveau: int) -> void:
	for seuil in THRESHOLDS:
		if seuil > ancien and seuil <= nouveau and not seuil in _thresholds_already_crossed:
			_thresholds_already_crossed.append(seuil)
			threshold_crossed.emit(seuil)
