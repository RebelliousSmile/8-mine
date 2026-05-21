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
signal personal_danger_changed(ancien: int, nouveau: int)
signal evidence_collected_changed(ancien: int, nouveau: int)
signal mental_stability_changed(ancien: int, nouveau: int)

## Variables canon 8-MINE exposées par GameStateManager :
## - personal_danger    (PD) : incidents où Margot a été repérée
## - evidence_collected (EV) : valeur cumulée des preuves accumulées
## - mental_stability   (0-6) : état narratif (colorie dialogues, débloque
##                              options, détermine fins). Distinct de
##                              MirrorStatusManager (mécanique de game over).
## - mirror_status      (MS) : déléguée à MirrorStatusManager (autoload séparé)
##                             accessible via get_mirror_status() ci-dessous.
const MENTAL_STABILITY_MIN := 0
const MENTAL_STABILITY_MAX := 6

var personal_danger: int = 0     : set = _set_personal_danger
var evidence_collected: int = 0  : set = _set_evidence_collected
var mental_stability: int = 0    : set = _set_mental_stability

var _flags: Dictionary = {}
var _decisions: Array = []   ## Liste de Dictionary { id, libelle, timestamp, contexte }
var _chapitre: String = ""

## Refs cachées — évitent les lookups répétés dans set_flag() et get_mirror_status()
var _dialogic: Node = null
var _mirror: Node = null


func _ready() -> void:
	_dialogic = get_node_or_null("/root/Dialogic")
	_mirror   = get_node_or_null("/root/MirrorStatusManager")


func _set_personal_danger(nouveau: int) -> void:
	var ancien := personal_danger
	personal_danger = maxi(0, nouveau)
	if personal_danger != ancien:
		personal_danger_changed.emit(ancien, personal_danger)


func _set_evidence_collected(nouveau: int) -> void:
	var ancien := evidence_collected
	evidence_collected = maxi(0, nouveau)
	if evidence_collected != ancien:
		evidence_collected_changed.emit(ancien, evidence_collected)


func _set_mental_stability(nouveau: int) -> void:
	var ancien := mental_stability
	mental_stability = clampi(nouveau, MENTAL_STABILITY_MIN, MENTAL_STABILITY_MAX)
	if mental_stability != ancien:
		mental_stability_changed.emit(ancien, mental_stability)


## Proxy vers MirrorStatusManager pour les consommateurs qui pensent
## en termes "GameStateManager.mirror_status".
func get_mirror_status() -> int:
	if _mirror and _mirror.has_method("get_status"):
		return _mirror.get_status()
	return 0


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
		"personal_danger": personal_danger,
		"evidence_collected": evidence_collected,
		"mental_stability": mental_stability,
	}


func appliquer_etat(etat: Dictionary) -> void:
	_flags = etat.get("flags", {}).duplicate(true)
	_decisions = etat.get("decisions", []).duplicate(true)
	personal_danger = int(etat.get("personal_danger", 0))
	# Migration douce : ancien nom "evidence_value" → "evidence_collected"
	evidence_collected = int(etat.get("evidence_collected",
		etat.get("evidence_value", 0)))
	mental_stability = int(etat.get("mental_stability", 0))
	var nouveau_chap: String = etat.get("chapitre", "")
	if nouveau_chap != _chapitre:
		var ancien := _chapitre
		_chapitre = nouveau_chap
		chapitre_change.emit(ancien, _chapitre)
	# Re-pousse tout dans Dialogic après chargement
	for cle in _flags.keys():
		_synchroniser_dialogic(cle, _flags[cle])


## Pour SaveManager (équivalent collecter_etat / appliquer_etat).
func save_state() -> Dictionary:
	return collecter_etat()


func load_state(data: Dictionary) -> void:
	appliquer_etat(data)


func reset_all_for_new_game() -> void:
	_flags.clear()
	_decisions.clear()
	_chapitre = ""
	personal_danger = 0
	evidence_collected = 0
	mental_stability = 0


# --- Pont Dialogic ---------------------------------------------------------

## Si Dialogic est installé, expose le flag comme variable Dialogic
## (transformée en nom plat compatible : "chapitre_1.cle" → "chapitre_1_cle").
func _synchroniser_dialogic(cle: String, valeur: Variant) -> void:
	if _dialogic == null:
		return
	if not "VAR" in _dialogic:
		return
	var cle_plate := cle.replace(".", "_")
	# L'accès direct VAR.X = ... n'est pas toujours scriptable :
	# on passe par set_variable() quand disponible.
	if _dialogic.has_method("set_variable"):
		_dialogic.set_variable(cle_plate, valeur)
	else:
		# Fallback : assignation dynamique via Object.set()
		_dialogic.VAR.set(cle_plate, valeur)
