extends "res://tests/helpers/test_environment.gd"


# --- Initialisation -------------------------------------------------------

func test_canon_countdowns_existent_apres_new_game() -> void:
	CountdownManager.reset_all_for_new_game()
	assert_true(CountdownManager.exists("audit_marine"),
		"audit_marine doit exister après new_game")
	assert_true(CountdownManager.exists("equipe_nettoyage"),
		"equipe_nettoyage doit exister après new_game")


func test_canon_countdowns_max_corrects() -> void:
	CountdownManager.reset_all_for_new_game()
	assert_eq(CountdownManager.get_max("audit_marine"), 15)
	assert_eq(CountdownManager.get_max("equipe_nettoyage"), 14)


# --- create_countdown -----------------------------------------------------

func test_create_countdown_ajoute_id_custom() -> void:
	CountdownManager.create_countdown("test_custom", 10, "Test custom")
	assert_true(CountdownManager.exists("test_custom"))
	assert_eq(CountdownManager.get_max("test_custom"), 10)


# --- tick / untick --------------------------------------------------------

func test_tick_incremente_current() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.tick("audit_marine", 3)
	assert_eq(CountdownManager.get_current("audit_marine"), 3)


func test_tick_emet_countdown_advanced() -> void:
	CountdownManager.reset_all_for_new_game()
	watch_signals(CountdownManager)
	CountdownManager.tick("audit_marine", 2)
	assert_signal_emitted(CountdownManager, "countdown_advanced")


func test_tick_jusqua_max_emet_completed() -> void:
	CountdownManager.reset_all_for_new_game()
	watch_signals(CountdownManager)
	CountdownManager.tick("audit_marine", 15)
	assert_signal_emitted(CountdownManager, "countdown_completed")
	assert_true(CountdownManager.is_completed("audit_marine"))


func test_untick_decremente_avec_clamp() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.tick("audit_marine", 5)
	CountdownManager.untick("audit_marine", 10)
	assert_eq(CountdownManager.get_current("audit_marine"), 0,
		"untick au-delà de 0 doit clamper à 0")


# --- Pause / resume -------------------------------------------------------

func test_pause_bloque_tick() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.pause("audit_marine")
	CountdownManager.tick("audit_marine", 5)
	assert_eq(CountdownManager.get_current("audit_marine"), 0,
		"tick sur countdown en pause doit être ignoré")


func test_resume_relance_tick() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.pause("audit_marine")
	CountdownManager.resume("audit_marine")
	CountdownManager.tick("audit_marine", 3)
	assert_eq(CountdownManager.get_current("audit_marine"), 3)


# --- save / load ---------------------------------------------------------

func test_save_load_roundtrip() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.tick("audit_marine", 5)
	CountdownManager.create_countdown("custom_x", 8, "Custom X")
	CountdownManager.tick("custom_x", 2)
	var snapshot = CountdownManager.save_state()
	CountdownManager.reset_all_for_new_game()
	CountdownManager.load_state(snapshot)
	assert_eq(CountdownManager.get_current("audit_marine"), 5)
	assert_eq(CountdownManager.get_current("custom_x"), 2)
	assert_eq(CountdownManager.get_max("custom_x"), 8)
