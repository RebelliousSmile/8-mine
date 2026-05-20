extends "res://tests/helpers/test_environment.gd"


func test_set_hud_interface_remplace_hud() -> void:
	var mock = MockHud.new()
	add_child_autofree(mock)
	GameOverHandler.set_hud_interface(mock)
	# Pas d'assert direct sur _hud (privé), on vérifie via trigger
	await GameOverHandler.trigger_game_over({
		"type": "test",
		"title": "Test",
		"overlay_quote": "quote",
		"history": [],
	})
	assert_eq(mock.last_quote, "quote")


func test_trigger_game_over_stocke_payload() -> void:
	var mock = MockHud.new()
	add_child_autofree(mock)
	GameOverHandler.set_hud_interface(mock)
	await GameOverHandler.trigger_game_over({
		"type": "surveillance",
		"title": "Surveillance Maximale",
		"overlay_quote": "Ils savent.",
		"history": [],
	})
	assert_eq(GameOverHandler.current_game_over_payload.type, "surveillance")
	assert_eq(GameOverHandler.current_game_over_payload.title, "Surveillance Maximale")


func test_trigger_game_over_passe_quote_au_hud() -> void:
	var mock = MockHud.new()
	add_child_autofree(mock)
	GameOverHandler.set_hud_interface(mock)
	await GameOverHandler.trigger_game_over({
		"type": "mirror",
		"title": "Effondrement",
		"overlay_quote": "Comme Naoki faisait.",
		"history": [],
	})
	assert_eq(mock.last_quote, "Comme Naoki faisait.")
