extends Node2D
## Scène de base pour le mode point-and-click 8-MINE.
##
## Structure attendue (vois scenes/base/NavigableRoom.tscn) :
##   NavigableRoom (Node2D, ce script)
##     ├─ Background (Sprite2D ou TextureRect)
##     ├─ CameraZones (Node2D)         ← CameraZone enfants
##     ├─ Characters (Node2D)          ← NPC enfants
##     ├─ Hotspots (Node2D)            ← Hotspot enfants
##     ├─ Margot (CharacterBody2D)     ← script Margot.gd
##     └─ UI (CanvasLayer)
##           ├─ Cursor (TextureRect)
##           ├─ SurveillanceHUD (référence au HUD autoload ou local)
##           └─ ExamineLabel (Label)
##
## Responsabilités :
## - Clic gauche sans hotspot → déplacer Margot vers le point
## - Clic gauche sur hotspot/NPC → mémoriser, déplacer Margot,
##   exécuter l'interaction à l'arrivée
## - Suivre l'état d'arrivée pour ne pas perdre l'interaction
## - Synchroniser les variables Dialogic au _ready
## - Reprendre le contrôle quand un timeline se termine

@export var disable_input_during_dialogue: bool = true

const NAVIGABLE_GROUPS_BLOQUANTS := ["hotspot_world", "npc_world"]

@onready var _margot: CharacterBody2D = $Margot if has_node("Margot") else null
@onready var _hotspots: Node2D = $Hotspots if has_node("Hotspots") else null
@onready var _characters: Node2D = $Characters if has_node("Characters") else null
@onready var _ui: CanvasLayer = $UI if has_node("UI") else null
@onready var _examine_label: Label = $UI/ExamineLabel if has_node("UI/ExamineLabel") else null

var _pending_target: Node2D = null
var _dialogue_en_cours: bool = false


func _ready() -> void:
	_brancher_hotspots()
	_brancher_npcs()
	_brancher_margot()
	_brancher_dialogic()
	_synchroniser_dialogic_vars()


# --- Branchements ---------------------------------------------------------

func _brancher_hotspots() -> void:
	if _hotspots == null:
		return
	for h in _hotspots.get_children():
		if h.has_signal("interaction_demandee"):
			h.interaction_demandee.connect(_on_interaction_demandee)
		if h.has_signal("examine_demande"):
			h.examine_demande.connect(_on_examine)


func _brancher_npcs() -> void:
	if _characters == null:
		return
	for n in _characters.get_children():
		if n.has_signal("interaction_demandee"):
			n.interaction_demandee.connect(_on_interaction_demandee)


func _brancher_margot() -> void:
	if _margot and _margot.has_signal("arrived"):
		_margot.arrived.connect(_on_margot_arrived)


func _brancher_dialogic() -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic == null:
		return
	if dialogic.has_signal("timeline_started"):
		dialogic.timeline_started.connect(_on_timeline_started)
	if dialogic.has_signal("timeline_ended"):
		dialogic.timeline_ended.connect(_on_timeline_ended)


func _synchroniser_dialogic_vars() -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic == null or not "VAR" in dialogic:
		return
	var ex := get_node_or_null("/root/ExProfileManager")
	if ex == null:
		return
	if dialogic.has_method("set_variable"):
		dialogic.set_variable("ex_prenom", ex.ex_name)
		dialogic.set_variable("ex_genre", ex.ex_gender)
	else:
		dialogic.VAR.set("ex_prenom", ex.ex_name)
		dialogic.VAR.set("ex_genre", ex.ex_gender)


# --- Input ----------------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if _dialogue_en_cours and disable_input_during_dialogue:
		return
	if event is InputEventMouseButton \
			and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Si la souris est sur un hotspot/NPC, leur input_event a
		# déjà émis interaction_demandee — on n'arrive ici que pour
		# les clics dans le vide. Déplacer Margot.
		if _margot:
			_margot.move_to(get_global_mouse_position())
			_pending_target = null


# --- Logique d'interaction ------------------------------------------------

func _on_interaction_demandee(cible: Node2D) -> void:
	if _dialogue_en_cours and disable_input_during_dialogue:
		return
	_pending_target = cible
	var target_pos: Vector2 = cible.global_position
	if cible.has_method("get_interaction_position"):
		target_pos = cible.get_interaction_position()
	if _margot:
		_margot.move_to(target_pos)


func _on_margot_arrived(_pos: Vector2) -> void:
	if _pending_target == null:
		return
	var cible := _pending_target
	_pending_target = null
	if cible.has_method("execute_interaction"):
		cible.execute_interaction()


func _on_examine(text: String) -> void:
	if _examine_label == null:
		print("[Examine] ", text)
		return
	_examine_label.text = text
	_examine_label.visible = true
	# Auto-hide après 3s
	var timer := get_tree().create_timer(3.0)
	timer.timeout.connect(func(): _examine_label.visible = false)


func _on_timeline_started() -> void:
	_dialogue_en_cours = true
	if _margot:
		_margot.stop()


func _on_timeline_ended() -> void:
	_dialogue_en_cours = false
