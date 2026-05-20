extends Node
## STUB phase 2.

signal surveillance_changed(ancien: int, nouveau: int, raison: String)
signal threshold_crossed(niveau: int)
signal surveillance_max_atteint

const THRESHOLDS := [25, 50, 75, 90]
const MAX := 100


func increase(_amount: int, _raison: String = "") -> void: pass
func decrease(_amount: int, _raison: String = "") -> void: pass
func get_level() -> int: return 0
func save_state() -> Dictionary: return {}
func load_state(_data: Dictionary) -> void: pass
func reset_all_for_new_game() -> void: pass
