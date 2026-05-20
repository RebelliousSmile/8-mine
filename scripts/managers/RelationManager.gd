extends Node
## Gestionnaire des relations PJ ↔ PNJ.
##
## Chaque personnage a une valeur entière dans [-100, +100]. La valeur
## est convertie en libellé (« neutre », « sympathie », ...) selon des
## seuils. Toute modification émet `relation_changed` ; un changement
## de palier émet en plus `palier_change` pour déclencher des cinématiques.
##
## Le manager ne crée pas les personnages à l'avance : la première
## interaction les insère en mode « neutre » (valeur 0).

signal relation_changed(personnage: String, ancienne_valeur: int, nouvelle_valeur: int, raison: String)
signal palier_change(personnage: String, ancien_niveau: String, nouveau_niveau: String)

const VALEUR_MIN := -100
const VALEUR_MAX := 100

## Seuils ordonnés du plus négatif au plus positif.
## `get_niveau()` retourne le libellé du dernier seuil dont la borne
## inférieure est <= valeur.
const SEUILS := [
	[-100, "ennemi"],
	[-85,  "hostilité"],
	[-60,  "méfiance"],
	[-30,  "froid"],
	[-10,  "neutre"],
	[10,   "sympathie"],
	[30,   "confiance"],
	[60,   "amitié"],
	[85,   "intime"],
]

## STUB phase 2 — sera peuplé phase 3 avec les 9 PNJs 8-MINE.
const NPC_DEFINITIONS := {}

var _relations: Dictionary = {}       ## { "alex": 25, "sam": -12, ... }
var _historique: Array = []           ## Liste de modifications horodatées


# --- API publique ----------------------------------------------------------

## Modifie la relation avec un personnage (valeur additionnée, clampée).
## `raison` est libre, sert au log et à l'UI (« vous avez menti », etc.).
func modifier(personnage: String, valeur: int, raison: String = "") -> void:
	var ancienne: int = _relations.get(personnage, 0)
	var nouvelle: int = clamp(ancienne + valeur, VALEUR_MIN, VALEUR_MAX)
	if nouvelle == ancienne:
		return

	var ancien_niveau := _libelle_pour(ancienne)
	var nouveau_niveau := _libelle_pour(nouvelle)
	_relations[personnage] = nouvelle

	_historique.append({
		"personnage": personnage,
		"delta": valeur,
		"valeur": nouvelle,
		"raison": raison,
		"timestamp": Time.get_unix_time_from_system(),
	})

	relation_changed.emit(personnage, ancienne, nouvelle, raison)
	if ancien_niveau != nouveau_niveau:
		palier_change.emit(personnage, ancien_niveau, nouveau_niveau)


## Force une valeur absolue (pour scripts d'introduction, debug, etc.).
func definir(personnage: String, valeur: int, raison: String = "init") -> void:
	var ancienne: int = _relations.get(personnage, 0)
	var delta := valeur - ancienne
	if delta != 0:
		modifier(personnage, delta, raison)


## Valeur brute (-100 à +100). 0 par défaut si inconnu.
func get_valeur(personnage: String) -> int:
	return _relations.get(personnage, 0)


## Libellé textuel (« neutre », « confiance », ...).
func get_niveau(personnage: String) -> String:
	return _libelle_pour(get_valeur(personnage))


## Vrai si le niveau est >= au libellé demandé. Ex. au_moins("alex", "confiance").
func au_moins(personnage: String, niveau_min: String) -> bool:
	var index_actuel := _index_niveau(get_niveau(personnage))
	var index_seuil := _index_niveau(niveau_min)
	return index_actuel >= index_seuil


## Liste tous les personnages connus avec leur valeur et libellé.
func snapshot() -> Array:
	var resultat: Array = []
	for nom in _relations.keys():
		var v: int = _relations[nom]
		resultat.append({
			"personnage": nom,
			"valeur": v,
			"niveau": _libelle_pour(v),
		})
	return resultat


func get_historique() -> Array:
	return _historique.duplicate(true)


# --- Sérialisation ---------------------------------------------------------

func collecter_etat() -> Dictionary:
	return {
		"valeurs": _relations.duplicate(true),
		"historique": _historique.duplicate(true),
	}


func appliquer_etat(etat: Dictionary) -> void:
	_relations = etat.get("valeurs", {}).duplicate(true)
	_historique = etat.get("historique", []).duplicate(true)


# --- API 8-MINE phase 4a (stubs phase 2) ----------------------------------

func save_state() -> Dictionary:
	# STUB. Phase 3 → renvoie collecter_etat()
	return {}


func load_state(_data: Dictionary) -> void:
	# STUB. Phase 3 → appliquer_etat(_data)
	pass


func reset_all_for_new_game() -> void:
	# STUB. Phase 3 → vide et repose les 9 PNJs canon.
	pass


func get_label(_personnage: String) -> String:
	# STUB. Phase 3 → NPC_DEFINITIONS[_personnage].label
	return ""


# --- Interne ---------------------------------------------------------------

func _libelle_pour(valeur: int) -> String:
	var libelle := "neutre"
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
