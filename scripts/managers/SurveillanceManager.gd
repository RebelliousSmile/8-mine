extends Node
## Pression externe (Stratom, Marine, drones, écoutes). 0 à 100.
## À 100 → game over surveillance.

signal surveillance_changed(ancien: int, nouveau: int, raison: String)
signal threshold_crossed(niveau: int)
signal surveillance_max_atteint

const THRESHOLDS := [25, 50, 75, 90]
const MAX := 100
const SEUIL_TICK_NETTOYAGE := 75

var _level: int = 0
var _thresholds_already_crossed: Array[int] = []


# --- API ------------------------------------------------------------------

func increase(amount: int, raison: String = "") -> void:
	assert(amount > 0, "increase: amount doit être > 0")
	_set_level(_level + amount, raison)


func decrease(amount: int, raison: String = "") -> void:
	assert(amount > 0, "decrease: amount doit être > 0")
	_set_level(_level - amount, raison)


func get_level() -> int:
	return _level


# --- Sérialisation --------------------------------------------------------

func save_state() -> Dictionary:
	return {
		"level": _level,
		"thresholds_already_crossed": _thresholds_already_crossed.duplicate(),
	}


func load_state(data: Dictionary) -> void:
	_level = clampi(int(data.get("level", 0)), 0, MAX)
	_thresholds_already_crossed.clear()
	for v in data.get("thresholds_already_crossed", []):
		_thresholds_already_crossed.append(int(v))


func reset_all_for_new_game() -> void:
	_level = 0
	_thresholds_already_crossed.clear()


# --- Interne --------------------------------------------------------------

func _set_level(nouveau: int, raison: String) -> void:
	var ancien := _level
	_level = clampi(nouveau, 0, MAX)
	if _level == ancien:
		return
	surveillance_changed.emit(ancien, _level, raison)
	_check_thresholds(ancien, _level)
	if _level >= MAX and not "_max_emitted" in _thresholds_already_crossed:
		# Marqueur interne pour éviter double émission
		_thresholds_already_crossed.append(MAX + 1)
		surveillance_max_atteint.emit()


func _check_thresholds(ancien: int, nouveau: int) -> void:
	for seuil in THRESHOLDS:
		if seuil > ancien and seuil <= nouveau and not seuil in _thresholds_already_crossed:
			_thresholds_already_crossed.append(seuil)
			threshold_crossed.emit(seuil)
			# Couplage explicite : franchir 75 tick equipe_nettoyage
			if seuil == SEUIL_TICK_NETTOYAGE:
				_tick_equipe_nettoyage()


func _tick_equipe_nettoyage() -> void:
	var cm := get_node_or_null("/root/CountdownManager")
	if cm and cm.has_method("tick") and cm.has_method("exists") \
			and cm.exists("equipe_nettoyage"):
		cm.tick("equipe_nettoyage", 1)
