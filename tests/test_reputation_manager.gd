extends "res://tests/helpers/test_environment.gd"


func test_init_apres_new_game() -> void:
	ReputationManager.reset_all_for_new_game()
	assert_eq(ReputationManager.get_valeur("presse"), 10)
	assert_eq(ReputationManager.get_valeur("activistes"), 5)
	assert_eq(ReputationManager.get_valeur("stratom"), 0)


func test_modifier_clamp_haut() -> void:
	ReputationManager.reset_all_for_new_game()
	ReputationManager.modifier("presse", 200, "test")
	assert_eq(ReputationManager.get_valeur("presse"), 100)


func test_modifier_clamp_bas() -> void:
	ReputationManager.reset_all_for_new_game()
	ReputationManager.modifier("stratom", -250, "test")
	assert_eq(ReputationManager.get_valeur("stratom"), -100)


func test_get_niveau_par_seuils() -> void:
	ReputationManager.reset_all_for_new_game()
	ReputationManager.definir("stratom", 30, "test")
	assert_eq(ReputationManager.get_niveau("stratom"), "allie")
	ReputationManager.definir("stratom", -70, "test")
	assert_eq(ReputationManager.get_niveau("stratom"), "hostile")


func test_au_moins() -> void:
	ReputationManager.reset_all_for_new_game()
	ReputationManager.definir("presse", 30, "test")
	assert_true(ReputationManager.au_moins("presse", "favorable"))
	assert_false(ReputationManager.au_moins("presse", "champion"))


func test_modifier_emet_signal() -> void:
	ReputationManager.reset_all_for_new_game()
	watch_signals(ReputationManager)
	ReputationManager.modifier("stratom", 10, "test")
	assert_signal_emitted(ReputationManager, "reputation_changed")


func test_save_load_roundtrip() -> void:
	ReputationManager.reset_all_for_new_game()
	ReputationManager.modifier("stratom", -25, "test")
	ReputationManager.modifier("marine", 15, "test")
	var data = ReputationManager.save_state()
	ReputationManager.reset_all_for_new_game()
	ReputationManager.load_state(data)
	assert_eq(ReputationManager.get_valeur("stratom"), -25)
	assert_eq(ReputationManager.get_valeur("marine"), 15)
