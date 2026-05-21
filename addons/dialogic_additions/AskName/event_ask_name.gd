@tool
class_name DialogicAskNameEvent
extends DialogicEvent

## Custom event 8-MINE : popup texte libre pour saisir un prénom.
##
## Syntaxe dans une timeline .dtl :
##   [ask_name var="emma_prenom" default="Emma"]
##   [ask_name var="frank_prenom" default="Frank" npc_id="frank"]
##
## Effet :
##   1. Spawn scenes/ui/NameInputDialog.tscn (modal, centré)
##   2. Bloque la timeline pendant que le joueur saisit
##   3. Stocke la valeur dans Dialogic.VAR[var_name]
##   4. Si npc_id (ou si var_name se termine par "_prenom"),
##      appelle CharacterRegistry.set_npc_display_name(npc_id, value)
##      pour que les renames soient persistés et visibles partout
##   5. Reprend la timeline


const POPUP_SCENE := "res://scenes/ui/NameInputDialog.tscn"

# Paramètres du shortcode
var variable_name: String = ""
var default_value: String = ""
var npc_id: String = ""             ## optionnel — déduit si vide
var prompt: String = "Comment tu l'appelles..."


# --- Exécution -----------------------------------------------------------

func _execute() -> void:
	dialogic.current_state = dialogic.States.WAITING

	var popup_scene := load(POPUP_SCENE)
	if popup_scene == null:
		push_error("[ask_name] Scène introuvable : %s" % POPUP_SCENE)
		finish()
		return

	var popup: CanvasLayer = popup_scene.instantiate()
	popup.var_name = variable_name
	popup.default_value = default_value
	popup.prompt_text = prompt

	var root := dialogic.get_tree().current_scene
	if root == null:
		root = dialogic.get_tree().root
	root.add_child(popup)

	var result_args: Array = await popup.name_chosen
	var value: String = String(result_args[1]) if result_args.size() >= 2 else default_value

	# Stocke dans Dialogic.VAR
	if dialogic.has_subsystem("VAR"):
		dialogic.VAR.set_variable(variable_name, value)

	# Stocke dans CharacterRegistry pour persistance + reflète dans
	# RelationManager.get_label.
	var cr := dialogic.get_node_or_null("/root/CharacterRegistry")
	if cr and cr.has_method("set_npc_display_name"):
		var id_resolu := _resoudre_npc_id()
		if not id_resolu.is_empty():
			cr.set_npc_display_name(id_resolu, value)

	dialogic.current_state = dialogic.States.IDLE
	finish()


## Si npc_id n'est pas fourni, on essaie d'extraire de variable_name
## (convention : `<id>_prenom` → `<id>`). Sinon chaîne vide.
func _resoudre_npc_id() -> String:
	if not npc_id.is_empty():
		return npc_id
	if variable_name.ends_with("_prenom"):
		return variable_name.substr(0, variable_name.length() - "_prenom".length())
	return ""


# --- Identification de l'event -------------------------------------------

func _init() -> void:
	event_name = "Ask Name"
	event_description = "Popup texte libre pour saisir un prénom (PJ ou PNJ)."
	event_category = "Logic"
	event_sorting_index = 50
	set_default_color('Color3')


# --- Shortcode (format texte .dtl) ---------------------------------------

func get_shortcode() -> String:
	return "ask_name"


func get_shortcode_parameters() -> Dictionary:
	return {
		"var":     { "property": "variable_name", "default": "" },
		"default": { "property": "default_value", "default": "" },
		"npc_id":  { "property": "npc_id",        "default": "" },
		"prompt":  { "property": "prompt",        "default": "Comment tu l'appelles..." },
	}


# --- Représentation éditeur (panneau Dialogic) ---------------------------

func build_event_editor() -> void:
	add_header_edit('variable_name', ValueType.SINGLELINE_TEXT,
		{ 'left_text': 'Stocke dans var :', 'placeholder': 'emma_prenom' })
	add_header_edit('default_value', ValueType.SINGLELINE_TEXT,
		{ 'left_text': 'Défaut :', 'placeholder': 'Emma' })
	add_body_edit('npc_id', ValueType.SINGLELINE_TEXT,
		{ 'left_text': 'NPC id (optionnel) :', 'placeholder': 'auto si var = X_prenom' })
	add_body_edit('prompt', ValueType.SINGLELINE_TEXT,
		{ 'left_text': 'Prompt :' })
