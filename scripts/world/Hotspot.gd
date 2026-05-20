extends Area2D
## Zone interactive cliquable dans une NavigableRoom.
## Quatre types : DIALOGUE, NAVIGATE, EXAMINE, PICKUP.
## Visibilité conditionnée par un flag GameStateManager optionnel.
##
## Distinct de scripts/ui/Hotspot.gd (Control, hérité du mode visual
## novel du Prompt 1) : ce Hotspot est un Area2D placé dans le monde.

enum HotspotType { DIALOGUE, NAVIGATE, EXAMINE, PICKUP }

signal interaction_demandee(hotspot: Node2D)
signal hover_change(hovered: bool, hotspot: Node2D)
signal examine_demande(text: String)
signal pickup_demande(hotspot: Node2D)

@export var hotspot_type: HotspotType = HotspotType.EXAMINE
@export var libelle: String = ""

## Pour DIALOGUE
@export_file("*.dtl") var dialogic_timeline: String = ""

## Pour NAVIGATE — chemin de scène cible (res://...)
@export_file("*.tscn") var target_scene: String = ""

## Pour EXAMINE
@export_multiline var examine_text: String = ""

## Pour PICKUP — id de l'item ajouté à l'inventaire
@export var pickup_item_id: String = ""

## Condition d'activation (optionnel). Le hotspot devient invisible
## et n'écoute plus les clics tant que le flag ne matche pas.
@export var required_flag: String = ""
@export var required_flag_value: bool = true

## Décalage en pixels où Margot doit s'arrêter pour interagir.
## Souvent un peu décalé du centre du hotspot (devant une porte
## plutôt que dedans).
@export var interaction_offset: Vector2 = Vector2.ZERO

var _actif: bool = true


func _ready() -> void:
	add_to_group("hotspot_world")
	input_pickable = true
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

	_evaluer_visibilite()

	var gs := get_node_or_null("/root/GameStateManager")
	if gs and gs.has_signal("flag_modifie"):
		gs.flag_modifie.connect(_on_flag_modifie)


# --- Activation conditionnelle --------------------------------------------

func _evaluer_visibilite() -> void:
	if required_flag.is_empty():
		_set_actif(true)
		return
	var gs := get_node_or_null("/root/GameStateManager")
	if gs == null or not gs.has_method("get_flag"):
		_set_actif(true)
		return
	var v: Variant = gs.get_flag(required_flag, null)
	_set_actif(v == required_flag_value)


func _set_actif(v: bool) -> void:
	_actif = v
	visible = v
	monitoring = v
	monitorable = v


func _on_flag_modifie(cle: String, _a: Variant, _n: Variant) -> void:
	if cle == required_flag:
		_evaluer_visibilite()


# --- Souris ---------------------------------------------------------------

func _on_mouse_entered() -> void:
	if _actif:
		hover_change.emit(true, self)


func _on_mouse_exited() -> void:
	hover_change.emit(false, self)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not _actif:
		return
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		interaction_demandee.emit(self)


# --- Cible de déplacement -------------------------------------------------

## Position où Margot doit se rendre AVANT que l'interaction
## s'exécute. Par défaut le centre du hotspot + interaction_offset.
func get_interaction_position() -> Vector2:
	return global_position + interaction_offset


# --- Exécution (appelée par NavigableRoom à l'arrivée de Margot) ---------

func execute_interaction() -> void:
	if not _actif:
		return
	match hotspot_type:
		HotspotType.DIALOGUE:
			_lancer_timeline()
		HotspotType.NAVIGATE:
			_changer_scene()
		HotspotType.EXAMINE:
			examine_demande.emit(examine_text)
		HotspotType.PICKUP:
			pickup_demande.emit(self)


func _lancer_timeline() -> void:
	if dialogic_timeline.is_empty():
		return
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic and dialogic.has_method("start"):
		dialogic.start(dialogic_timeline)


func _changer_scene() -> void:
	if target_scene.is_empty():
		return
	var lm := get_node_or_null("/root/LocationManager")
	if lm and lm.has_method("aller_a_scene"):
		lm.aller_a_scene("hotspot_nav", target_scene)
	else:
		get_tree().change_scene_to_file(target_scene)
