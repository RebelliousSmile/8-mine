extends Node
## Gestionnaire de sauvegarde JSON multi-slots.
##
## Trois slots indépendants (0, 1, 2) stockés dans `user://saves/`.
## Chaque sauvegarde contient un instantané complet de l'état du jeu :
## relations, flags narratifs, lieu courant, chapitre, horodatage.
##
## Utilisation :
##   SaveManager.sauvegarder(0)              # écrit le slot 0
##   var data = SaveManager.charger(0)       # lit le slot 0
##   SaveManager.appliquer_etat(data)        # restaure managers
##
## Le manager ne connaît pas la structure interne des autres managers :
## il leur demande leur état via collecter_etat() / appliquer_etat().

signal sauvegarde_effectuee(slot: int)
signal chargement_effectue(slot: int)
signal sauvegarde_echec(slot: int, raison: String)

const NB_SLOTS := 3
const DOSSIER_SAUVE := "user://saves/"

## STUB phase 2 : on garde VERSION_FORMAT=1.
## Phase 3 bumpera à 2 et ajoutera la migration.
const VERSION_FORMAT := 1

## STUB phase 2 — sera peuplé phase 3.
## Liste explicite (autoload, key JSON).
const MANAGERS_ENREGISTRES := []


func _ready() -> void:
	# Crée le dossier de sauvegardes si absent
	DirAccess.make_dir_recursive_absolute(DOSSIER_SAUVE)


# --- API publique ----------------------------------------------------------

## Sauvegarde l'état complet du jeu dans le slot demandé.
func sauvegarder(slot: int) -> bool:
	if not _slot_valide(slot):
		sauvegarde_echec.emit(slot, "Slot invalide")
		return false

	var etat := _collecter_etat_global()
	var chemin := _chemin_slot(slot)
	var fichier := FileAccess.open(chemin, FileAccess.WRITE)
	if fichier == null:
		sauvegarde_echec.emit(slot, "Ouverture impossible : %s" % chemin)
		return false

	fichier.store_string(JSON.stringify(etat, "\t"))
	fichier.close()
	sauvegarde_effectuee.emit(slot)
	return true


## Charge le slot demandé et restaure l'état des managers.
## Retourne le dictionnaire chargé (vide si échec).
func charger(slot: int) -> Dictionary:
	if not _slot_valide(slot):
		return {}
	if not slot_existe(slot):
		return {}

	var fichier := FileAccess.open(_chemin_slot(slot), FileAccess.READ)
	if fichier == null:
		return {}

	var contenu := fichier.get_as_text()
	fichier.close()

	var parse := JSON.parse_string(contenu)
	if typeof(parse) != TYPE_DICTIONARY:
		return {}

	_appliquer_etat_global(parse)
	chargement_effectue.emit(slot)
	return parse


## Vrai si le fichier du slot existe.
func slot_existe(slot: int) -> bool:
	return FileAccess.file_exists(_chemin_slot(slot))


## Métadonnées d'un slot sans tout charger (timestamp, chapitre, lieu).
func meta_slot(slot: int) -> Dictionary:
	if not slot_existe(slot):
		return {}
	var fichier := FileAccess.open(_chemin_slot(slot), FileAccess.READ)
	var parse: Variant = JSON.parse_string(fichier.get_as_text())
	fichier.close()
	if typeof(parse) != TYPE_DICTIONARY:
		return {}
	return {
		"timestamp": parse.get("timestamp", 0),
		"chapitre": parse.get("chapitre", ""),
		"lieu": parse.get("lieu", ""),
		"version": parse.get("version", 0),
	}


## Supprime le fichier d'un slot.
func effacer_slot(slot: int) -> bool:
	if not slot_existe(slot):
		return false
	return DirAccess.remove_absolute(_chemin_slot(slot)) == OK


# --- Interne ---------------------------------------------------------------

func _slot_valide(slot: int) -> bool:
	return slot >= 0 and slot < NB_SLOTS


func _chemin_slot(slot: int) -> String:
	return "%ssave_%d.json" % [DOSSIER_SAUVE, slot]


## Demande son état à chaque manager et empaquette le tout.
func _collecter_etat_global() -> Dictionary:
	var etat := {
		"version": VERSION_FORMAT,
		"timestamp": Time.get_unix_time_from_system(),
		"date_lisible": Time.get_datetime_string_from_system(),
	}

	# Accès paresseux : les autres managers peuvent ne pas être prêts
	# lors des premiers tests. On utilise get_node_or_null pour rester souple.
	var rm := get_node_or_null("/root/RelationManager")
	var gs := get_node_or_null("/root/GameStateManager")
	var lm := get_node_or_null("/root/LocationManager")

	if rm and rm.has_method("collecter_etat"):
		etat["relations"] = rm.collecter_etat()
	if gs and gs.has_method("collecter_etat"):
		var gs_data: Dictionary = gs.collecter_etat()
		etat["flags"] = gs_data.get("flags", {})
		etat["decisions"] = gs_data.get("decisions", [])
		etat["chapitre"] = gs_data.get("chapitre", "")
	if lm and lm.has_method("collecter_etat"):
		var lm_data: Dictionary = lm.collecter_etat()
		etat["lieu"] = lm_data.get("lieu_actuel", "")
		etat["historique_lieux"] = lm_data.get("historique", [])

	return etat


## Restaure l'état de chaque manager depuis un dictionnaire chargé.
func _appliquer_etat_global(etat: Dictionary) -> void:
	var rm := get_node_or_null("/root/RelationManager")
	var gs := get_node_or_null("/root/GameStateManager")
	var lm := get_node_or_null("/root/LocationManager")

	if rm and rm.has_method("appliquer_etat"):
		rm.appliquer_etat(etat.get("relations", {}))
	if gs and gs.has_method("appliquer_etat"):
		gs.appliquer_etat({
			"flags": etat.get("flags", {}),
			"decisions": etat.get("decisions", []),
			"chapitre": etat.get("chapitre", ""),
		})
	if lm and lm.has_method("appliquer_etat"):
		lm.appliquer_etat({
			"lieu_actuel": etat.get("lieu", ""),
			"historique": etat.get("historique_lieux", []),
		})


# --- API 8-MINE phase 4a (stubs phase 2) ----------------------------------

## STUB phase 2. Phase 3 → reset_all_for_new_game sur chaque manager
## de MANAGERS_ENREGISTRES.
func new_game() -> void:
	pass


## STUB phase 2. Phase 3 → comble les clés manquantes par défauts.
func migrer_v1_vers_v2(data: Dictionary) -> Dictionary:
	return data


# --- Raccourcis globaux (utilisables depuis n'importe où) ------------------

## Appelée depuis l'action "quick_save" (F5 par défaut).
func sauvegarde_rapide() -> void:
	sauvegarder(0)


## Appelée depuis l'action "quick_load" (F9 par défaut).
func chargement_rapide() -> void:
	charger(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_save"):
		sauvegarde_rapide()
	elif event.is_action_pressed("quick_load"):
		chargement_rapide()
