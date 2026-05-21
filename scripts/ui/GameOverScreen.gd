extends Control
## Écran final de game over. Lit le payload via GameOverHandler.
## Voir docs/MANUAL_VALIDATION.md pour les cases G1-G7.

@onready var _label_titre: Label = $Vertical/Titre
@onready var _label_quote: Label = $Vertical/Quote
@onready var _liste_historique: VBoxContainer = $Vertical/Scroll/Historique
@onready var _bouton_recommencer: Button = $Vertical/Boutons/Recommencer
@onready var _bouton_menu: Button = $Vertical/Boutons/Menu


func _ready() -> void:
	var payload: Dictionary = GameOverHandler.current_game_over_payload
	_label_titre.text = String(payload.get("title", "Fin"))
	_label_quote.text = String(payload.get("overlay_quote", ""))

	var formatter: Variant = payload.get("history_formatter", null)
	var history: Array = payload.get("history", [])
	for event in history:
		var ligne := Label.new()
		if formatter is Callable:
			ligne.text = String((formatter as Callable).call(event))
		else:
			ligne.text = String(event)
		_liste_historique.add_child(ligne)

	_bouton_recommencer.pressed.connect(_on_recommencer)
	_bouton_menu.pressed.connect(_on_menu)


func _on_recommencer() -> void:
	SaveManager.new_game()
	get_tree().change_scene_to_file("res://scenes/core/Main.tscn")


func _on_menu() -> void:
	# Branche le menu Maaack une fois installé. Pour l'instant fallback Main.
	get_tree().change_scene_to_file("res://scenes/core/Main.tscn")


# Esc ne ferme pas l'écran (G7 dans MANUAL_VALIDATION)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
