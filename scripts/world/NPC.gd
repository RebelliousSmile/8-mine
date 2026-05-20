extends StaticBody2D
## PNJ dans une scène point-and-click. Sprite en pied, cliquable
## via une Area2D enfant. Lance le bon timeline Dialogic selon
## l'état narratif (flags + relation).

signal interaction_demandee(npc: Node2D)
signal hover_change(hovered: bool, npc: Node2D)

@export var pnj_id: String = ""
@export var interaction_offset: Vector2 = Vector2(0, 30)
## Décalage de Margot au moment de parler (devant le PNJ, pas dessus).

## Mapping optionnel niveau de relation → suffixe de timeline.
## Si non personnalisé, on utilise les valeurs par défaut ci-dessous.
@export var timeline_suffix_par_niveau: Dictionary = {
	"intime":    "_allie",
	"amitié":    "_allie",
	"confiance": "_allie",
	"sympathie": "_neutre",
	"neutre":    "_neutre",
	"froid":     "_tension",
	"méfiance":  "_tension",
	"hostilité": "_tension",
	"ennemi":    "_tension",
}

@onready var _area: Area2D = $Area2D if has_node("Area2D") else null


func _ready() -> void:
	add_to_group("npc_world")
	if _area:
		_area.input_pickable = true
		_area.mouse_entered.connect(func(): hover_change.emit(true, self))
		_area.mouse_exited.connect(func(): hover_change.emit(false, self))
		_area.input_event.connect(_on_input_event)


# --- Interactions ---------------------------------------------------------

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		interaction_demandee.emit(self)


func get_interaction_position() -> Vector2:
	return global_position + interaction_offset


## Appelée par NavigableRoom quand Margot est arrivée.
func execute_interaction() -> void:
	var timeline := get_timeline()
	if timeline.is_empty():
		return
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic and dialogic.has_method("start"):
		dialogic.start(timeline)


# --- Résolution de timeline ----------------------------------------------

## Algorithme :
## 1. Flag explicite `flag_<pnj>_allie` (priorité absolue)
## 2. Flag explicite `flag_<pnj>_tension`
## 3. Sinon, palier de relation via RelationManager.get_niveau
## 4. Sinon, suffix "_neutre"
##
## Le timeline final est `<pnj_id><suffix>` (ex: `frank_allie`,
## `sofia_neutre`). Le scénariste crée les .dtl correspondants ;
## les manquants seront pris en charge par Dialogic (erreur ou
## fallback selon sa config).
func get_timeline() -> String:
	if pnj_id.is_empty():
		return ""

	var gs := get_node_or_null("/root/GameStateManager")
	if gs and gs.has_method("a_flag"):
		if gs.a_flag("flag_" + pnj_id + "_allie"):
			return pnj_id + "_allie"
		if gs.a_flag("flag_" + pnj_id + "_tension"):
			return pnj_id + "_tension"

	var rm := get_node_or_null("/root/RelationManager")
	if rm and rm.has_method("get_niveau"):
		var niv: String = rm.get_niveau(pnj_id)
		var suffix: String = String(timeline_suffix_par_niveau.get(niv, "_neutre"))
		return pnj_id + suffix

	return pnj_id + "_neutre"


# --- Affichage ------------------------------------------------------------

## Nom affichable (passe par CharacterRegistry si override posé).
func get_display_name() -> String:
	var rm := get_node_or_null("/root/RelationManager")
	if rm and rm.has_method("get_label"):
		return rm.get_label(pnj_id)
	return pnj_id.capitalize()
