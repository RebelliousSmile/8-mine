extends Node
## Gestionnaire de sauvegarde JSON multi-slots.
##
## Trois slots indépendants (0, 1, 2) stockés dans `user://saves/`.
## Chaque sauvegarde contient un instantané complet de l'état du
## jeu, agrégé depuis la liste explicite MANAGERS_ENREGISTRES.
##
## API publique :
##   sauvegarder(slot), charger(slot), meta_slot(slot),
##   effacer_slot(slot), new_game(), migrer_v1_vers_v2(data).

signal sauvegarde_effectuee(slot: int)
signal chargement_effectue(slot: int)
signal sauvegarde_echec(slot: int, raison: String)

const NB_SLOTS := 3
const DOSSIER_SAUVE := "user://saves/"
const VERSION_FORMAT := 2

## Liste explicite (autoload, clé JSON). Pas de découverte dynamique.
## Clés spéciales :
##   "_inline_"      : aplatit les clés du save_state directement dans le root
##   "_inline_lieu_" : map lieu_actuel/historique vers lieu/historique_lieux
const MANAGERS_ENREGISTRES := [
	["RelationManager",      "relations"],
	["CharacterRegistry",    "characters"],
	["GameStateManager",     "_inline_"],
	["LocationManager",      "_inline_lieu_"],
	["CountdownManager",     "countdowns"],
	["SurveillanceManager",  "surveillance"],
	["MirrorStatusManager",  "mirror"],
	["ReputationManager",    "reputation"],
	["ExProfileManager",     "ex_profile"],
]


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(DOSSIER_SAUVE)


# --- API publique ----------------------------------------------------------

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

	var parse: Variant = JSON.parse_string(contenu)
	if typeof(parse) != TYPE_DICTIONARY:
		return {}

	var etat: Dictionary = parse
	# Migration en amont pour que la valeur retournée au caller
	# soit la version v2 (le test test_charger_v1_silencieux
	# vérifie la présence des clés post-migration).
	if int(etat.get("version", 1)) < VERSION_FORMAT:
		etat = migrer_v1_vers_v2(etat)
	_appliquer_etat_global(etat)
	chargement_effectue.emit(slot)
	return etat


func slot_existe(slot: int) -> bool:
	return FileAccess.file_exists(_chemin_slot(slot))


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


func effacer_slot(slot: int) -> bool:
	if not slot_existe(slot):
		return false
	return DirAccess.remove_absolute(_chemin_slot(slot)) == OK


# --- API 8-MINE phase 4a ---------------------------------------------------

## Reset tous les managers enregistrés. Appelé par bouton « Nouvelle
## partie » (Maaack) et après Game Over → Recommencer.
func new_game() -> void:
	for entry in MANAGERS_ENREGISTRES:
		var nom: String = entry[0]
		var node := get_node_or_null("/root/" + nom)
		if node and node.has_method("reset_all_for_new_game"):
			node.reset_all_for_new_game()


## Migration v1 → v2 : ajoute les clés manquantes pour qu'un load v1
## ne crashe pas sur les nouveaux managers (qui chargeront leurs
## défauts via load_state({}) puis reset).
func migrer_v1_vers_v2(data: Dictionary) -> Dictionary:
	var migre: Dictionary = data.duplicate(true)
	migre["version"] = VERSION_FORMAT
	for entry in MANAGERS_ENREGISTRES:
		var cle: String = entry[1]
		if cle.begins_with("_inline_"):
			continue
		if not migre.has(cle):
			migre[cle] = {}
	return migre


# --- Sérialisation interne ------------------------------------------------

func _collecter_etat_global() -> Dictionary:
	var etat := {
		"version": VERSION_FORMAT,
		"timestamp": Time.get_unix_time_from_system(),
		"date_lisible": Time.get_datetime_string_from_system(),
	}

	for entry in MANAGERS_ENREGISTRES:
		var nom: String = entry[0]
		var cle: String = entry[1]
		var node := get_node_or_null("/root/" + nom)
		if node == null:
			continue
		# Pour GameState/Location existants, on tolère collecter_etat
		# au lieu de save_state pour rester compatible Prompt 1.
		var data: Dictionary = {}
		if node.has_method("save_state"):
			data = node.save_state()
		elif node.has_method("collecter_etat"):
			data = node.collecter_etat()
		else:
			continue

		match cle:
			"_inline_":
				for k in data.keys():
					etat[k] = data[k]
			"_inline_lieu_":
				etat["lieu"] = data.get("lieu_actuel", "")
				etat["historique_lieux"] = data.get("historique", [])
			_:
				etat[cle] = data

	return etat


func _appliquer_etat_global(etat: Dictionary) -> void:
	if int(etat.get("version", 1)) < VERSION_FORMAT:
		etat = migrer_v1_vers_v2(etat)

	for entry in MANAGERS_ENREGISTRES:
		var nom: String = entry[0]
		var cle: String = entry[1]
		var node := get_node_or_null("/root/" + nom)
		if node == null:
			continue
		var charge_method := "load_state"
		if not node.has_method(charge_method):
			if node.has_method("appliquer_etat"):
				charge_method = "appliquer_etat"
			else:
				continue
		match cle:
			"_inline_":
				# On passe l'etat complet : GameStateManager.load_state
				# pioche les clés qu'il connaît (flags, decisions,
				# chapitre, personal_danger, evidence_value...).
				node.call(charge_method, etat)
			"_inline_lieu_":
				node.call(charge_method, {
					"lieu_actuel": etat.get("lieu", ""),
					"historique": etat.get("historique_lieux", []),
				})
			_:
				node.call(charge_method, etat.get(cle, {}))


# --- Interne --------------------------------------------------------------

func _slot_valide(slot: int) -> bool:
	return slot >= 0 and slot < NB_SLOTS


func _chemin_slot(slot: int) -> String:
	return "%ssave_%d.json" % [DOSSIER_SAUVE, slot]


# --- Raccourcis globaux (utilisables depuis n'importe où) ------------------

func sauvegarde_rapide() -> void:
	sauvegarder(0)


func chargement_rapide() -> void:
	charger(0)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quick_save"):
		sauvegarde_rapide()
	elif event.is_action_pressed("quick_load"):
		chargement_rapide()
