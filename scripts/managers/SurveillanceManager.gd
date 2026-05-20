extends Node
## Pression externe (Stratom, Marine, drones, écoutes). 0 à 100.
## À 100 → game over surveillance.

signal surveillance_changed(ancien: int, nouveau: int, raison: String)
signal threshold_crossed(niveau: int)
signal surveillance_max_atteint
signal exposure_tick(zone_level: int, temps_expose: float)
signal exposure_alerte_declenchee(zone_level: int)

const THRESHOLDS := [25, 50, 75, 90]
const MAX := 100
const SEUIL_TICK_NETTOYAGE := 75
const SEUIL_ALERTE := 10.0

var _level: int = 0
var _thresholds_already_crossed: Array[int] = []

## Tracking spatial pour le point-and-click : zones actives où
## Margot se trouve actuellement, et secondes d'exposition cumulées.
## Quand temps_expose atteint SEUIL_ALERTE, on incrémente le PD
## (GameStateManager) et on tick equipe_nettoyage.
var _zones_actives: Dictionary = {}   ## { zone_id (int) : level (int 1-4) }
var _temps_expose: float = 0.0


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
	_zones_actives.clear()
	_temps_expose = 0.0


# --- Zones spatiales (point-and-click) ------------------------------------

## Appelée par CameraZone quand Margot entre dans son cône.
func register_zone_entered(zone_id: int, level: int) -> void:
	_zones_actives[zone_id] = level


## Appelée par CameraZone quand Margot quitte le cône.
func register_zone_exited(zone_id: int) -> void:
	_zones_actives.erase(zone_id)


func get_zones_actives() -> Dictionary:
	return _zones_actives.duplicate()


func get_max_zone_level() -> int:
	if _zones_actives.is_empty():
		return 0
	var m := 0
	for v in _zones_actives.values():
		m = maxi(m, int(v))
	return m


func get_temps_expose() -> float:
	return _temps_expose


func _process(delta: float) -> void:
	var niveau := get_max_zone_level()
	if niveau <= 0:
		return
	_temps_expose += delta * float(niveau)
	exposure_tick.emit(niveau, _temps_expose)
	if _temps_expose >= SEUIL_ALERTE:
		_temps_expose = 0.0
		_declencher_alerte(niveau)


func _declencher_alerte(zone_level: int) -> void:
	# Incrémente PD côté GameStateManager
	var gs := get_node_or_null("/root/GameStateManager")
	if gs and "personal_danger" in gs:
		gs.personal_danger = int(gs.personal_danger) + 1
	# Tick le countdown nettoyage si présent
	var cm := get_node_or_null("/root/CountdownManager")
	if cm and cm.has_method("avancer_nettoyage"):
		cm.avancer_nettoyage(1)
	# Émet la pression interne (level [0,100]) — la mécanique
	# de seuil monotone existe déjà sur ce canal.
	if _level < MAX:
		increase(maxi(1, zone_level), "exposition_zone")
	exposure_alerte_declenchee.emit(zone_level)


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
