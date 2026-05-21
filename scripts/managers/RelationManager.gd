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

## 9 PNJ canon hérités du Prompt 4a (thriller externe à la tour) +
## 8 résidents 8-MINE (les 4 corpos × 2 employés du programme coliving).
##
## Note collision : "kaizen" est ici un PERSONNAGE (Prompt 4a, faction
## marine). Dans le brief 8-MINE, KAIZEN est aussi un NOM DE CORPO.
## Les deux coexistent dans des dictionnaires distincts (NPC_DEFINITIONS
## vs FACTION_DEFINITIONS), pas de conflit technique, mais on documente
## ici l'ambiguïté pour quand il faudra renommer le PNJ.
##
## Note collision "marine" : faction militaire (Prompt 4a) ET prénom
## de résidente future (8-MINE A1-03). Idem, pas de conflit technique
## (NPC_DEFINITIONS["marine"] vs FACTION_DEFINITIONS["marine"]) mais
## affichage potentiellement confus.
const NPC_DEFINITIONS := {
	# --- Prompt 4a (rester compatibles) -----------------------------------
	"sara":    { "label": "Sara",    "faction": "presse",     "init": 0   },
	"kaizen":  { "label": "Kaizen",  "faction": "marine",     "init": -10 },
	"lior":    { "label": "Lior",    "faction": "activistes", "init": 5   },
	"marl":    { "label": "Marl",    "faction": "stratom",    "init": 0   },
	"tess":    { "label": "Tess",    "faction": "police",     "init": 0   },
	"viktor":  { "label": "Viktor",  "faction": "stratom",    "init": -20 },
	"mira":    { "label": "Mira",    "faction": "presse",     "init": 15  },
	"aslan":   { "label": "Aslan",   "faction": "activistes", "init": 0   },
	"nadia":   { "label": "Nadia",   "faction": "marine",     "init": 0   },
	# --- 8-MINE résidents (introduits PRO-01 + A1-03) ---------------------
	# 8 résidents = 4 corpos × 2 employés.
	# stratom est partagé avec les externes Prompt 4a (viktor/marl).
	"emma":    { "label": "Emma",    "faction": "memorize",   "init": 20  },
	"frank":   { "label": "Frank",   "faction": "stratom",    "init": 0   },
	"sofia":   { "label": "Sofia",   "faction": "nexus",      "init": 0   },
	# --- Résidents nommés au brief mais introduits à A1-03 ----------------
	"marine":  { "label": "Marine",  "faction": "memorize",   "init": 0   },
	"thomas":  { "label": "Thomas",  "faction": "stratom",    "init": 0   },
	"leo":     { "label": "Léo",     "faction": "kaizen",     "init": 0   },
	"camille": { "label": "Camille", "faction": "kaizen",     "init": 0   },
	"alex":    { "label": "Alex",    "faction": "nexus",      "init": 0   },
}

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


# --- API 8-MINE phase 4a -------------------------------------------------

func save_state() -> Dictionary:
	return collecter_etat()


func load_state(data: Dictionary) -> void:
	appliquer_etat(data)


## Vide tout et repose les 9 PNJs canon à leur valeur init.
func reset_all_for_new_game() -> void:
	_relations.clear()
	_historique.clear()
	for personnage in NPC_DEFINITIONS.keys():
		_relations[personnage] = NPC_DEFINITIONS[personnage]["init"]


## Renvoie le nom à afficher. Délègue à CharacterRegistry si un
## override y est posé, sinon retourne le label canonical des
## NPC_DEFINITIONS.
func get_label(personnage: String) -> String:
	var cr := get_node_or_null("/root/CharacterRegistry")
	if cr and cr.has_method("has_npc_override") and cr.has_npc_override(personnage):
		return cr.get_npc_display_name(personnage)
	var def: Dictionary = NPC_DEFINITIONS.get(personnage, {})
	return String(def.get("label", personnage.capitalize()))


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
