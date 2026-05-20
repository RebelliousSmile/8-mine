extends Node
## Gestionnaire d'état global du monde narratif.
##
## Centralise tous les flags qui pilotent la branchitude du récit
## (objets pris, événements vus, choix faits, etc.) et garde un journal
## chronologique des décisions importantes.
##
## Convention de nommage des flags :
##   chapitre_1.cle_volee
##   chapitre_2.alex_a_pardonné
##   meta.tutoriel_termine
##
## Pour Dialogic : à chaque set_flag(), on pousse aussi la valeur
## dans `Dialogic.VAR` afin que les conditions dans les timelines
## puissent y accéder via {var_name}. Voir DialogicBridge pour le
## chemin inverse (Dialogic → ici).

signal flag_modifie(cle: String, ancienne_valeur: Variant, nouvelle_valeur: Variant)
signal decision_enregistree(decision: Dictionary)
signal chapitre_change(ancien: String, nouveau: String)

var _flags: Dictionary = {}
var _decisions: Array = []   ## Liste de Dictionary { id, libelle, timestamp, contexte }
var _chapitre: String = ""


# --- Flags -----------------------------------------------------------------

## Pose un flag narratif. Émet flag_modifie si la valeur change.
func set_flag(cle: String, valeur: Variant) -> void:
	var ancien: Variant = _flags.get(cle, null)
	if ancien == valeur:
		return
	_flags[cle] = valeur
	flag_modifie.emit(cle, ancien, valeur)
	_synchroniser_dialogic(cle, valeur)


## Récupère un flag, ou la valeur par défaut s'il n'est pas posé.
func get_flag(cle: String, defaut: Variant = null) -> Variant:
	return _flags.get(cle, defaut)


## Pratique pour les flags booléens : true si présent et truthy.
func a_flag(cle: String) -> bool:
	return bool(_flags.get(cle, false))


## Supprime un flag (équivalent à le mettre à null).
func effacer_flag(cle: String) -> void:
	if _flags.has(cle):
		var ancien: Variant = _flags[cle]
		_flags.erase(cle)
		flag_modifie.emit(cle, ancien, null)


# --- Décisions -------------------------------------------------------------

## Enregistre une décision importante dans le journal narratif.
## `id` doit être unique et stable (utilisé pour vérifications futures).
## `contexte` est libre : qui était présent, quel lieu, quelle heure...
func enregistrer_decision(id: String, libelle: String, contexte: Dictionary = {}) -> void:
	var decision := {
		"id": id,
		"libelle": libelle,
		"timestamp": Time.get_unix_time_from_system(),
		"chapitre": _chapitre,
		"contexte": contexte,
	}
	_decisions.append(decision)
	decision_enregistree.emit(decision)
	# Pose aussi un flag dédié pour faciliter les conditions Dialogic
	set_flag("decision." + id, true)


## Vrai si la décision a déjà été prise (utile pour les conséquences différées).
func a_pris_decision(id: String) -> bool:
	for d in _decisions:
		if d.get("id", "") == id:
			return true
	return false


func get_decisions() -> Array:
	return _decisions.duplicate(true)


# --- Chapitres -------------------------------------------------------------

func changer_chapitre(nom: String) -> void:
	if _chapitre == nom:
		return
	var ancien := _chapitre
	_chapitre = nom
	chapitre_change.emit(ancien, nom)


func get_chapitre() -> String:
	return _chapitre


# --- Sérialisation (appelée par SaveManager) -------------------------------

func collecter_etat() -> Dictionary:
	return {
		"flags": _flags.duplicate(true),
		"decisions": _decisions.duplicate(true),
		"chapitre": _chapitre,
	}


func appliquer_etat(etat: Dictionary) -> void:
	_flags = etat.get("flags", {}).duplicate(true)
	_decisions = etat.get("decisions", []).duplicate(true)
	var nouveau_chap: String = etat.get("chapitre", "")
	if nouveau_chap != _chapitre:
		var ancien := _chapitre
		_chapitre = nouveau_chap
		chapitre_change.emit(ancien, _chapitre)
	# Re-pousse tout dans Dialogic après chargement
	for cle in _flags.keys():
		_synchroniser_dialogic(cle, _flags[cle])


# --- Pont Dialogic ---------------------------------------------------------

## Si Dialogic est installé, expose le flag comme variable Dialogic
## (transformée en nom plat compatible : "chapitre_1.cle" → "chapitre_1_cle").
func _synchroniser_dialogic(cle: String, valeur: Variant) -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic == null:
		return
	if not "VAR" in dialogic:
		return
	var cle_plate := cle.replace(".", "_")
	# L'accès direct VAR.X = ... n'est pas toujours scriptable :
	# on passe par set_variable() quand disponible.
	if dialogic.has_method("set_variable"):
		dialogic.set_variable(cle_plate, valeur)
	else:
		# Fallback : assignation dynamique via Object.set()
		dialogic.VAR.set(cle_plate, valeur)
