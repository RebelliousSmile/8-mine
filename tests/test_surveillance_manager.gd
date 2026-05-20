extends "res://tests/helpers/test_environment.gd"


func test_init_a_zero() -> void:
	SurveillanceManager.reset_all_for_new_game()
	assert_eq(SurveillanceManager.get_level(), 0)


func test_increase_clamp() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.increase(200, "test")
	assert_eq(SurveillanceManager.get_level(), 100)


func test_decrease_clamp_zero() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.increase(10, "test")
	SurveillanceManager.decrease(20, "test")
	assert_eq(SurveillanceManager.get_level(), 0)


func test_threshold_crossed_montant_unique() -> void:
	SurveillanceManager.reset_all_for_new_game()
	watch_signals(SurveillanceManager)
	SurveillanceManager.increase(30, "test")  # franchit 25
	assert_signal_emitted(SurveillanceManager, "threshold_crossed")


func test_threshold_monotone_pas_re_emis() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.increase(60, "test")  # franchit 25 et 50
	watch_signals(SurveillanceManager)
	SurveillanceManager.decrease(20, "test")  # 60 → 40
	SurveillanceManager.increase(20, "test")  # 40 → 60 : re-franchit 50
	# Ne doit PAS re-émettre 25 ni 50
	assert_signal_not_emitted(SurveillanceManager, "threshold_crossed")


func test_max_atteint_emet_signal_dedie() -> void:
	SurveillanceManager.reset_all_for_new_game()
	watch_signals(SurveillanceManager)
	SurveillanceManager.increase(100, "test")
	assert_signal_emitted(SurveillanceManager, "surveillance_max_atteint")


func test_franchir_75_tick_equipe_nettoyage() -> void:
	SurveillanceManager.reset_all_for_new_game()
	CountdownManager.reset_all_for_new_game()
	SurveillanceManager.increase(80, "test")
	# Couplage explicite : franchir 75 tick equipe_nettoyage de 1
	assert_eq(CountdownManager.get_current("equipe_nettoyage"), 1)


func test_save_load_roundtrip_inclut_thresholds() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.increase(60, "test")  # franchit 25, 50
	var data = SurveillanceManager.save_state()
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.load_state(data)
	assert_eq(SurveillanceManager.get_level(), 60)
	# Après reload, re-monter à 60 ne doit pas re-émettre 50
	watch_signals(SurveillanceManager)
	SurveillanceManager.decrease(20, "test")
	SurveillanceManager.increase(20, "test")
	assert_signal_not_emitted(SurveillanceManager, "threshold_crossed")
