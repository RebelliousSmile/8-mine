extends Node
## STUB phase 2. Implémentation phase 3.
## Voir docs/API_PUBLIQUE.md pour la spec complète.

signal countdown_advanced(id: String, current: int, max: int, reason: String)
signal countdown_completed(id: String)
signal threshold_crossed(id: String, threshold: int)

const CANON_COUNTDOWNS := {
	"audit_marine":     { "max": 15, "description": "Audit Marine par Kaizen" },
	"equipe_nettoyage": { "max": 14, "description": "Équipe Nettoyage Stratom" },
}


func create_countdown(_id: String, _max: int, _description: String) -> void: pass
func tick(_id: String, _amount: int = 1) -> void: pass
func untick(_id: String, _amount: int = 1) -> void: pass
func pause(_id: String) -> void: pass
func resume(_id: String) -> void: pass
func get_current(_id: String) -> int: return 0
func get_remaining(_id: String) -> int: return 0
func get_max(_id: String) -> int: return 0
func is_completed(_id: String) -> bool: return false
func is_active(_id: String) -> bool: return false
func exists(_id: String) -> bool: return false
func reset(_id: String) -> void: pass
func save_state() -> Dictionary: return {}
func load_state(_data: Dictionary) -> void: pass
func reset_all_for_new_game() -> void: pass
