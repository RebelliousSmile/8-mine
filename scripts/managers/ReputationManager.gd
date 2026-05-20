extends Node
## STUB phase 2.

signal reputation_changed(faction: String, ancienne: int, nouvelle: int, raison: String)
signal palier_change(faction: String, ancien: String, nouveau: String)

const VALEUR_MIN := -100
const VALEUR_MAX := 100

const FACTION_DEFINITIONS := {
	"stratom":    { "label": "Stratom Corp",        "init": 0  },
	"marine":     { "label": "Marine Nationale",    "init": 0  },
	"presse":     { "label": "Presse indépendante", "init": 10 },
	"police":     { "label": "Police judiciaire",   "init": 0  },
	"activistes": { "label": "Cellule activiste",   "init": 5  },
}

const SEUILS := [
	[-100, "ennemi_jure"],
	[-60,  "hostile"],
	[-25,  "mefiant"],
	[-5,   "indifferent"],
	[5,    "favorable"],
	[25,   "allie"],
	[60,   "champion"],
]


func modifier(_faction: String, _delta: int, _raison: String = "") -> void: pass
func definir(_faction: String, _valeur: int, _raison: String = "") -> void: pass
func get_valeur(_faction: String) -> int: return 0
func get_niveau(_faction: String) -> String: return ""
func get_label(_faction: String) -> String: return ""
func au_moins(_faction: String, _niveau_min: String) -> bool: return false
func save_state() -> Dictionary: return {}
func load_state(_data: Dictionary) -> void: pass
func reset_all_for_new_game() -> void: pass
