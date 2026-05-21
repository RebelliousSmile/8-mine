extends Node
## Registre des noms de personnages : PJ, PNJ principaux (overrides),
## PNJ secondaires (cités mais sans relations).
##
## Convention :
##   - PC name : un seul override autorisé (engagement narratif,
##     comme ex_name dans ExProfileManager).
##   - NPC display name : un seul override par PNJ. Stockage
##     additionnel à RelationManager.NPC_DEFINITIONS — les valeurs
##     canon restent les labels par défaut.
##   - Secondaires : CRUD libre, créés dynamiquement au cours du
##     jeu. Ils ne portent pas de relation/réputation propre, ils
##     sont juste cités dans les dialogues (collègues, membres
##     corpos, famille, etc.).

signal pc_name_set(new_name: String)
signal npc_renamed(id: String, new_name: String)
signal secondary_added(id: String, data: Dictionary)
signal secondary_renamed(id: String, new_name: String)
signal secondary_removed(id: String)

const DEFAUT_PC_NAME := "Margot"
const VALID_ROLES := ["collegue", "membre_corp", "famille", "voisin", "anonyme"]

var pc_name: String = DEFAUT_PC_NAME
var is_pc_name_overridden: bool = false

## { "sara": "Sara Devereux", ... }  — override sur le label canonical
var _npc_overrides: Dictionary = {}

## { "paul": { name, role, faction, description }, ... }
var _secondaries: Dictionary = {}


# --- PC -------------------------------------------------------------------

func set_pc_name(new_name: String) -> bool:
	if is_pc_name_overridden:
		return false
	pc_name = new_name
	is_pc_name_overridden = true
	pc_name_set.emit(new_name)
	return true


func get_pc_name() -> String:
	return pc_name


# --- Renommage PNJ principaux --------------------------------------------

## Renomme un PNJ principal (référencé dans RelationManager.NPC_DEFINITIONS).
## Retourne false si :
##   - l'id n'est pas un PNJ principal
##   - un override existe déjà (immuable, comme pc_name et ex_name)
func set_npc_display_name(id: String, new_name: String) -> bool:
	var rm := get_node_or_null("/root/RelationManager")
	if rm == null or not rm.NPC_DEFINITIONS.has(id):
		return false
	if _npc_overrides.has(id):
		return false
	_npc_overrides[id] = new_name
	npc_renamed.emit(id, new_name)
	return true


func has_npc_override(id: String) -> bool:
	return _npc_overrides.has(id)


## Renvoie le nom à afficher : override si posé, sinon label canonical
## de RelationManager.NPC_DEFINITIONS, sinon fallback générique.
func get_npc_display_name(id: String) -> String:
	if _npc_overrides.has(id):
		return _npc_overrides[id]
	var rm := get_node_or_null("/root/RelationManager")
	if rm and rm.NPC_DEFINITIONS.has(id):
		return String(rm.NPC_DEFINITIONS[id]["label"])
	return id.capitalize()


# --- PNJ secondaires ------------------------------------------------------

## Ajoute un secondaire. Retourne true si ajouté, false si l'id existe
## déjà.
func add_secondary(
		id: String,
		secondary_name: String,
		role: String,
		faction: String = "",
		description: String = "") -> bool:
	assert(role in VALID_ROLES,
		"add_secondary: rôle '%s' invalide" % role)
	if _secondaries.has(id):
		return false
	var data := {
		"name": secondary_name,
		"role": role,
		"faction": faction,
		"description": description,
	}
	_secondaries[id] = data
	secondary_added.emit(id, data)
	return true


func get_secondary(id: String) -> Dictionary:
	if not _secondaries.has(id):
		return {}
	var entry: Dictionary = _secondaries[id].duplicate(true)
	entry["id"] = id
	return entry


func rename_secondary(id: String, new_name: String) -> void:
	if not _secondaries.has(id):
		return
	_secondaries[id]["name"] = new_name
	secondary_renamed.emit(id, new_name)


func remove_secondary(id: String) -> void:
	if _secondaries.erase(id):
		secondary_removed.emit(id)


func list_secondaries() -> Array:
	var result: Array = []
	for id in _secondaries.keys():
		var entry: Dictionary = _secondaries[id].duplicate()
		entry["id"] = id
		result.append(entry)
	return result


func list_by_faction(faction: String) -> Array:
	var result: Array = []
	for id in _secondaries.keys():
		if String(_secondaries[id].get("faction", "")) == faction:
			var entry: Dictionary = _secondaries[id].duplicate()
			entry["id"] = id
			result.append(entry)
	return result


func list_by_role(role: String) -> Array:
	var result: Array = []
	for id in _secondaries.keys():
		if String(_secondaries[id].get("role", "")) == role:
			var entry: Dictionary = _secondaries[id].duplicate()
			entry["id"] = id
			result.append(entry)
	return result


# --- Sérialisation --------------------------------------------------------

func save_state() -> Dictionary:
	return {
		"pc_name": pc_name,
		"is_pc_name_overridden": is_pc_name_overridden,
		"npc_overrides": _npc_overrides.duplicate(true),
		"secondaries": _secondaries.duplicate(true),
	}


func load_state(data: Dictionary) -> void:
	pc_name = String(data.get("pc_name", DEFAUT_PC_NAME))
	is_pc_name_overridden = bool(data.get("is_pc_name_overridden", false))
	_npc_overrides = (data.get("npc_overrides", {}) as Dictionary).duplicate(true)
	_secondaries = (data.get("secondaries", {}) as Dictionary).duplicate(true)


func reset_all_for_new_game() -> void:
	pc_name = DEFAUT_PC_NAME
	is_pc_name_overridden = false
	_npc_overrides.clear()
	_secondaries.clear()
