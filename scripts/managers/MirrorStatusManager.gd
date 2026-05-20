extends Node
## STUB phase 2.

signal mirror_status_changed(ancien: int, nouveau: int, raison: String)
signal threshold_crossed(niveau: int)
signal breakdown_imminent

const THRESHOLDS := [30, 60, 90]
const MAX := 100


func increase(_amount: int, _raison: String = "") -> void: pass
func decrease(_amount: int, _raison: String = "") -> void: pass
func get_status() -> int: return 0
func get_overlay_quote() -> String: return ""
func save_state() -> Dictionary: return {}
func load_state(_data: Dictionary) -> void: pass
func reset_all_for_new_game() -> void: pass
