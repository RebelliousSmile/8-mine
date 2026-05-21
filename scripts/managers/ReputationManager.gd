extends Node
## Réputation publique par faction. Distincte de RelationManager
## (lien privé PJ↔PNJ).

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

## Bornes inférieures de chaque palier. La valeur testée tombe dans
## le palier le plus haut dont la borne est ≤ valeur.
## Ex: -70 ≥ -85 → hostile, -70 ≥ -50 ? non → reste hostile.
const SEUILS := [
	[-100, "ennemi_jure"],
	[-85,  "hostile"],
	[-50,  "mefiant"],
	[-20,  "indifferent"],
	[5,    "favorable"],
	[25,   "allie"],
	[60,   "champion"],
]

var _reputations: Dictionary = {}


# --- API ------------------------------------------------------------------

func modifier(faction: String, delta: int, raison: String = "") -> void:
	var ancienne: int = _reputations.get(faction, _init_pour(faction))
	var nouvelle: int = clampi(ancienne + delta, VALEUR_MIN, VALEUR_MAX)
	if nouvelle == ancienne:
		return
	var ancien_niveau := _libelle_pour(ancienne)
	var nouveau_niveau := _libelle_pour(nouvelle)
	_reputations[faction] = nouvelle
	reputation_changed.emit(faction, ancienne, nouvelle, raison)
	if ancien_niveau != nouveau_niveau:
		palier_change.emit(faction, ancien_niveau, nouveau_niveau)


func definir(faction: String, valeur: int, raison: String = "") -> void:
	var ancienne: int = _reputations.get(faction, _init_pour(faction))
	modifier(faction, valeur - ancienne, raison)


func get_valeur(faction: String) -> int:
	return _reputations.get(faction, _init_pour(faction))


func get_niveau(faction: String) -> String:
	return _libelle_pour(get_valeur(faction))


func get_label(faction: String) -> String:
	var def: Dictionary = FACTION_DEFINITIONS.get(faction, {})
	return String(def.get("label", faction))


func au_moins(faction: String, niveau_min: String) -> bool:
	return _index_niveau(get_niveau(faction)) >= _index_niveau(niveau_min)


# --- Sérialisation --------------------------------------------------------

func save_state() -> Dictionary:
	return { "valeurs": _reputations.duplicate(true) }


func load_state(data: Dictionary) -> void:
	_reputations = (data.get("valeurs", {}) as Dictionary).duplicate(true)


func reset_all_for_new_game() -> void:
	_reputations.clear()
	for faction in FACTION_DEFINITIONS.keys():
		_reputations[faction] = FACTION_DEFINITIONS[faction]["init"]


# --- Interne --------------------------------------------------------------

func _init_pour(faction: String) -> int:
	var def: Dictionary = FACTION_DEFINITIONS.get(faction, {})
	return int(def.get("init", 0))


func _libelle_pour(valeur: int) -> String:
	var libelle := "indifferent"
	for seuil in SEUILS:
		if valeur >= seuil[0]:
			libelle = seuil[1]
		else:
			break
	return libelle


func _index_niveau(libelle: String) -> int:
	for i in SEUILS.size():
		if SEUILS[i][1] == libelle:
			return i
	return -1
