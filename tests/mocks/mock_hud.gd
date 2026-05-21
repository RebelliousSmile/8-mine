extends Node
class_name MockHud

## Mock léger pour GameOverHandler. Émet immédiatement le signal
## que le vrai HUD émettrait après animation, pour ne pas bloquer
## les tests. Voir docs/TESTING_GUIDE.md pour le pattern.

signal game_over_overlay_finished

var last_quote: String = ""
var cinematic_visible_calls: Array = []


func show_game_over_overlay(quote: String) -> void:
	last_quote = quote
	call_deferred("emit_signal", "game_over_overlay_finished")


func set_visible_for_cinematic(v: bool) -> void:
	cinematic_visible_calls.append(v)


func toggle_visible() -> void:
	pass
