extends Control
## Zone cliquable sur un décor. Émet `clique` ou lance directement
## une timeline Dialogic, selon ce qui est configuré dans l'inspecteur.
##
## Trois actions possibles (testées dans cet ordre) :
##   - `timeline` : démarre une timeline Dialogic
##   - `lieu`     : transition vers un autre lieu via LocationManager
##   - sinon      : émet simplement le signal `clique` pour scripting custom

signal clique(id_hotspot: String)

@export var id_hotspot: String = "hotspot"
@export var libelle: String = ""
@export_file("*.dtl") var timeline: String = ""
@export var lieu_cible: String = ""

## Condition optionnelle : flag requis (vide = toujours visible).
@export var flag_requis: String = ""

var _bouton: Button
var _actif: bool = true


func _ready() -> void:
	add_to_group("hotspot")
	mouse_filter = Control.MOUSE_FILTER_PASS

	_bouton = Button.new()
	_bouton.text = libelle
	_bouton.flat = true
	_bouton.modulate = Color(1, 1, 1, 0.85)
	_bouton.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_bouton)
	_bouton.pressed.connect(_on_pressed)

	# Cache si le flag requis n'est pas posé
	_evaluer_visibilite()
	GameStateManager.flag_modifie.connect(_on_flag_change)


func set_actif(v: bool) -> void:
	_actif = v
	if _bouton:
		_bouton.disabled = not v


func _on_pressed() -> void:
	if not _actif:
		return
	clique.emit(id_hotspot)

	if not timeline.is_empty():
		var dialogic := get_node_or_null("/root/Dialogic")
		if dialogic and dialogic.has_method("start"):
			dialogic.start(timeline)
		return

	if not lieu_cible.is_empty():
		LocationManager.aller_a(lieu_cible)


func _evaluer_visibilite() -> void:
	if flag_requis.is_empty():
		visible = true
		return
	visible = GameStateManager.a_flag(flag_requis)


func _on_flag_change(cle: String, _ancien: Variant, _nouveau: Variant) -> void:
	if cle == flag_requis:
		_evaluer_visibilite()
