extends CanvasLayer
## STUB phase 2 — autoload de scène.

signal game_over_overlay_finished


func set_visible_for_cinematic(_v: bool) -> void: pass
func toggle_visible() -> void: pass

func show_game_over_overlay(_quote: String) -> void:
	# Impl phase 3 sera une coroutine. Stub : émet immédiatement.
	call_deferred("emit_signal", "game_over_overlay_finished")
