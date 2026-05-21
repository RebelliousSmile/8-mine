extends CanvasLayer
## Popup modale pour saisir un prénom (PJ, PNJ principal).
## Bloquante : fond noir 60% opacité, focus auto sur le LineEdit.
##
## Usage standalone :
##   var popup = preload("res://scenes/ui/NameInputDialog.tscn").instantiate()
##   popup.var_name = "emma_prenom"
##   popup.default_value = "Emma"
##   add_child(popup)
##   var saisie: String = await popup.name_chosen
##
## Usage Dialogic : voir addons/dialogic_additions/AskName/event_ask_name.gd

signal name_chosen(var_name: String, value: String)

@export var var_name: String = ""
@export var default_value: String = ""
@export var prompt_text: String = "Comment tu l'appelles..."

@onready var _bg: ColorRect = $Bg
@onready var _line_edit: LineEdit = $Panel/V/LineEdit
@onready var _prompt_label: Label = $Panel/V/Prompt
@onready var _valider: Button = $Panel/V/Buttons/Valider
@onready var _garder: Button = $Panel/V/Buttons/Garder


func _ready() -> void:
	layer = 200   # au-dessus de tout
	_prompt_label.text = prompt_text
	_line_edit.placeholder_text = default_value
	_line_edit.text = default_value
	_line_edit.grab_focus()
	_line_edit.select_all()
	_garder.text = "Garder « %s »" % default_value
	_valider.pressed.connect(_on_valider)
	_garder.pressed.connect(_on_garder)
	_line_edit.text_submitted.connect(_on_line_submit)
	_line_edit.text_changed.connect(_on_text_changed)
	_refresh_valider()


func _on_text_changed(_t: String) -> void:
	_refresh_valider()


func _refresh_valider() -> void:
	_valider.disabled = _line_edit.text.strip_edges().is_empty()


func _on_line_submit(_t: String) -> void:
	if not _valider.disabled:
		_on_valider()


func _on_valider() -> void:
	var v: String = _line_edit.text.strip_edges()
	if v.is_empty():
		v = default_value
	name_chosen.emit(var_name, v)
	queue_free()


func _on_garder() -> void:
	name_chosen.emit(var_name, default_value)
	queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_garder()
		get_viewport().set_input_as_handled()
