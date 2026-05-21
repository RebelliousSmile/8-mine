extends CanvasLayer
## HUD de surveillance. Autoload de scène. Rendu validé manuellement
## (voir docs/MANUAL_VALIDATION.md). Le calcul d'état est délégué
## à SurveillanceHUDLogic, testable unitairement.

signal game_over_overlay_finished

const HUDLogicClass := preload("res://scripts/ui/SurveillanceHUDLogic.gd")
const DUREE_OVERLAY := 1.2

var _logic: SurveillanceHUDLogic
var _container: Control
var _label_palier: Label
var _label_quote: Label
var _overlay: ColorRect
var _overlay_label: Label
var _dots: Array[ColorRect] = []
const NB_DOTS := 4


func _ready() -> void:
	layer = 50
	_logic = HUDLogicClass.new()
	_build_ui()
	_branche_signaux()
	_rafraichir()


# --- Construction UI ------------------------------------------------------

func _build_ui() -> void:
	_container = Control.new()
	_container.name = "Container"
	_container.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_container.offset_left = -380.0
	_container.offset_top = 24.0
	_container.offset_right = -24.0
	_container.offset_bottom = 220.0
	_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_container)

	# Label palier
	_label_palier = Label.new()
	_label_palier.position = Vector2(0, 0)
	_label_palier.size = Vector2(356, 32)
	_label_palier.add_theme_font_size_override("font_size", 20)
	_container.add_child(_label_palier)

	# Conteneur dots
	var dots_box := HBoxContainer.new()
	dots_box.position = Vector2(0, 40)
	dots_box.size = Vector2(356, 24)
	dots_box.add_theme_constant_override("separation", 8)
	_container.add_child(dots_box)
	for i in NB_DOTS:
		var dot := ColorRect.new()
		dot.custom_minimum_size = Vector2(60, 20)
		dot.color = Color(0.2, 0.2, 0.25, 0.8)
		dots_box.add_child(dot)
		_dots.append(dot)

	# Quote miroir
	_label_quote = Label.new()
	_label_quote.position = Vector2(0, 80)
	_label_quote.size = Vector2(356, 60)
	_label_quote.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_label_quote.add_theme_color_override("font_color", Color(0.7, 0.7, 0.75))
	_container.add_child(_label_quote)

	# Overlay game over (plein écran, transparent au départ)
	_overlay = ColorRect.new()
	_overlay.color = Color(0, 0, 0, 0)
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.visible = false
	add_child(_overlay)

	_overlay_label = Label.new()
	_overlay_label.set_anchors_preset(Control.PRESET_CENTER)
	_overlay_label.offset_left = -400
	_overlay_label.offset_right = 400
	_overlay_label.offset_top = -40
	_overlay_label.offset_bottom = 40
	_overlay_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_overlay_label.add_theme_font_size_override("font_size", 36)
	_overlay.add_child(_overlay_label)


# --- Signaux managers -----------------------------------------------------

func _branche_signaux() -> void:
	var sm := get_node_or_null("/root/SurveillanceManager")
	if sm:
		sm.surveillance_changed.connect(func(_a, _n, _r): _rafraichir())
		sm.threshold_crossed.connect(func(_n): _pulse())
	var mm := get_node_or_null("/root/MirrorStatusManager")
	if mm:
		mm.mirror_status_changed.connect(func(_a, _n, _r): _rafraichir())


func _rafraichir() -> void:
	if not _logic:
		return
	var sm := get_node_or_null("/root/SurveillanceManager")
	if sm == null:
		return
	var v: int = sm.get_level()
	var nb := _logic.compute_dots(v, sm.MAX, NB_DOTS)
	for i in _dots.size():
		_dots[i].color = Color(0.95, 0.35, 0.25, 0.9) if i < nb else Color(0.2, 0.2, 0.25, 0.6)
	_label_palier.text = _logic.line_label(v, 25)

	var mm := get_node_or_null("/root/MirrorStatusManager")
	if mm and mm.get_status() >= 30:
		_label_quote.text = mm.get_overlay_quote()
	else:
		_label_quote.text = ""


func _pulse() -> void:
	var tween := create_tween()
	tween.tween_property(_container, "modulate:a", 0.4, 0.08)
	tween.tween_property(_container, "modulate:a", 1.0, 0.20)


# --- API publique ---------------------------------------------------------

func set_visible_for_cinematic(v: bool) -> void:
	_container.visible = v


func toggle_visible() -> void:
	_container.visible = not _container.visible


func show_game_over_overlay(quote: String) -> void:
	_overlay_label.text = quote
	_overlay.visible = true
	var tween := create_tween()
	tween.tween_property(_overlay, "color:a", 1.0, DUREE_OVERLAY / 2.0)
	tween.tween_interval(DUREE_OVERLAY / 4.0)
	await tween.finished
	game_over_overlay_finished.emit()


# --- Toggle Shift+F1 ------------------------------------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F1 and event.shift_pressed:
			toggle_visible()
