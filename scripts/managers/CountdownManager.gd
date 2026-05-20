extends Node
## Compteurs nominaux à valeur croissante (audit Marine, équipe
## nettoyage Stratom, etc.). Voir docs/MECANIQUES_8MINE.md.

signal countdown_advanced(id: String, current: int, max_value: int, reason: String)
signal countdown_completed(id: String)
signal threshold_crossed(id: String, threshold: int)

const CANON_COUNTDOWNS := {
	"audit_marine":     { "max": 15, "description": "Audit Marine par Kaizen" },
	"equipe_nettoyage": { "max": 14, "description": "Équipe Nettoyage Stratom" },
}

## { id: { max, current, active, description, completed,
##         thresholds_crossed: Array[int] } }
var _countdowns: Dictionary = {}


# --- Création / cycle de vie ----------------------------------------------

func reset_all_for_new_game() -> void:
	_countdowns.clear()
	for id in CANON_COUNTDOWNS.keys():
		var def: Dictionary = CANON_COUNTDOWNS[id]
		_countdowns[id] = _new_countdown(def["max"], def["description"])


func create_countdown(id: String, max_value: int, description: String) -> void:
	assert(not _countdowns.has(id), "create_countdown: id '%s' déjà existant" % id)
	assert(max_value > 0, "create_countdown: max doit être > 0")
	_countdowns[id] = _new_countdown(max_value, description)


func _new_countdown(max_value: int, description: String) -> Dictionary:
	return {
		"max": max_value,
		"current": 0,
		"active": true,
		"description": description,
		"completed": false,
		"thresholds_crossed": [],
	}


# --- Manipulation ---------------------------------------------------------

func tick(id: String, amount: int = 1) -> void:
	assert(amount > 0, "tick: amount doit être > 0")
	assert(_countdowns.has(id), "tick: countdown '%s' inconnu" % id)
	var cd: Dictionary = _countdowns[id]
	if not cd["active"] or cd["completed"]:
		return

	var ancien: int = cd["current"]
	cd["current"] = mini(cd["current"] + amount, cd["max"])
	countdown_advanced.emit(id, cd["current"], cd["max"], "")

	_check_thresholds(id, ancien, cd["current"], cd["max"])

	if cd["current"] >= cd["max"] and not cd["completed"]:
		cd["completed"] = true
		countdown_completed.emit(id)


func untick(id: String, amount: int = 1) -> void:
	if not _countdowns.has(id):
		return
	var cd: Dictionary = _countdowns[id]
	cd["current"] = maxi(0, cd["current"] - amount)


func pause(id: String) -> void:
	if _countdowns.has(id):
		_countdowns[id]["active"] = false


func resume(id: String) -> void:
	if _countdowns.has(id):
		_countdowns[id]["active"] = true


func reset(id: String) -> void:
	if not _countdowns.has(id):
		return
	var cd: Dictionary = _countdowns[id]
	cd["current"] = 0
	cd["completed"] = false
	cd["active"] = true
	cd["thresholds_crossed"] = []


# --- Lectures -------------------------------------------------------------

func get_current(id: String) -> int:
	return _countdowns[id]["current"] if _countdowns.has(id) else 0


func get_remaining(id: String) -> int:
	if not _countdowns.has(id):
		return 0
	return _countdowns[id]["max"] - _countdowns[id]["current"]


func get_max(id: String) -> int:
	return _countdowns[id]["max"] if _countdowns.has(id) else 0


func is_completed(id: String) -> bool:
	return _countdowns.has(id) and _countdowns[id]["completed"]


func is_active(id: String) -> bool:
	return _countdowns.has(id) and _countdowns[id]["active"]


func exists(id: String) -> bool:
	return _countdowns.has(id)


# --- Sérialisation --------------------------------------------------------

func save_state() -> Dictionary:
	return { "countdowns": _countdowns.duplicate(true) }


func load_state(data: Dictionary) -> void:
	_countdowns = data.get("countdowns", {}).duplicate(true)


# --- Interne --------------------------------------------------------------

## Seuils par défaut : 1/3 et 2/3 du max.
func _check_thresholds(id: String, ancien: int, nouveau: int, max_value: int) -> void:
	var cd: Dictionary = _countdowns[id]
	var seuils := [int(max_value / 3.0), int(2.0 * max_value / 3.0)]
	for seuil in seuils:
		if seuil > ancien and seuil <= nouveau and not seuil in cd["thresholds_crossed"]:
			cd["thresholds_crossed"].append(seuil)
			threshold_crossed.emit(id, seuil)
