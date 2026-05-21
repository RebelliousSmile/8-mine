extends "res://tests/helpers/test_environment.gd"


# --- Zones spatiales -----------------------------------------------------

func test_register_zone_entered_remplit_zones_actives() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.register_zone_entered(42, 3)
	assert_eq(SurveillanceManager.get_zones_actives().size(), 1)
	assert_eq(SurveillanceManager.get_max_zone_level(), 3)


func test_register_zone_exited_vide_zones_actives() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.register_zone_entered(42, 3)
	SurveillanceManager.register_zone_exited(42)
	assert_eq(SurveillanceManager.get_zones_actives().size(), 0)
	assert_eq(SurveillanceManager.get_max_zone_level(), 0)


func test_max_level_avec_deux_zones() -> void:
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.register_zone_entered(1, 2)
	SurveillanceManager.register_zone_entered(2, 4)
	assert_eq(SurveillanceManager.get_max_zone_level(), 4)


# --- Déclenchement alerte ------------------------------------------------

func test_declencher_alerte_increments_PD_et_tick_nettoyage() -> void:
	GameStateManager.reset_all_for_new_game()
	CountdownManager.reset_all_for_new_game()
	SurveillanceManager.reset_all_for_new_game()

	# Appel direct du déclencheur interne (le _process fait pareil
	# une fois temps_expose >= SEUIL_ALERTE)
	SurveillanceManager._declencher_alerte(3)

	assert_eq(GameStateManager.personal_danger, 1)
	assert_eq(CountdownManager.get_current("equipe_nettoyage"), 1)


func test_process_accumule_temps_et_declenche_au_seuil() -> void:
	GameStateManager.reset_all_for_new_game()
	CountdownManager.reset_all_for_new_game()
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager.register_zone_entered(1, 2)   # ×2 → 5s pour seuil 10

	# Simule 6 secondes (deux passes de 3s)
	SurveillanceManager._process(3.0)
	SurveillanceManager._process(3.0)

	# 6s * level 2 = 12s d'exposition → >= 10s → alerte
	assert_eq(GameStateManager.personal_danger, 1,
		"PD doit être incrémenté quand temps_expose franchit le seuil")
	assert_eq(CountdownManager.get_current("equipe_nettoyage"), 1)


func test_process_sans_zone_ne_fait_rien() -> void:
	GameStateManager.reset_all_for_new_game()
	SurveillanceManager.reset_all_for_new_game()
	SurveillanceManager._process(20.0)   # 20s sans zone
	assert_eq(GameStateManager.personal_danger, 0)


func test_reset_vide_zones_et_temps() -> void:
	SurveillanceManager.register_zone_entered(1, 3)
	SurveillanceManager._process(2.0)
	SurveillanceManager.reset_all_for_new_game()
	assert_eq(SurveillanceManager.get_zones_actives().size(), 0)
	assert_eq(SurveillanceManager.get_temps_expose(), 0.0)


# --- GameStateManager EV/PD -----------------------------------------------

func test_personal_danger_setter_emet_signal() -> void:
	GameStateManager.reset_all_for_new_game()
	watch_signals(GameStateManager)
	GameStateManager.personal_danger = 3
	assert_signal_emitted_with_parameters(
		GameStateManager, "personal_danger_changed", [0, 3])


func test_evidence_collected_clamp_zero() -> void:
	GameStateManager.reset_all_for_new_game()
	GameStateManager.evidence_collected = -10
	assert_eq(GameStateManager.evidence_collected, 0)


func test_save_load_inclut_PD_EV_MS() -> void:
	const SLOT := 2
	SaveManager.effacer_slot(SLOT)
	SaveManager.new_game()
	GameStateManager.personal_danger = 4
	GameStateManager.evidence_collected = 25
	GameStateManager.mental_stability = 3
	SaveManager.sauvegarder(SLOT)
	SaveManager.new_game()
	SaveManager.charger(SLOT)
	assert_eq(GameStateManager.personal_danger, 4)
	assert_eq(GameStateManager.evidence_collected, 25)
	assert_eq(GameStateManager.mental_stability, 3)
	SaveManager.effacer_slot(SLOT)


func test_get_mirror_status_proxy() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	MirrorStatusManager.increase(35, "test")
	assert_eq(GameStateManager.get_mirror_status(), 35)


# --- CountdownManager alias ----------------------------------------------

func test_avancer_nettoyage_alias() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.avancer_nettoyage(2)
	assert_eq(CountdownManager.get_current("equipe_nettoyage"), 2)


func test_avancer_audit_alias() -> void:
	CountdownManager.reset_all_for_new_game()
	CountdownManager.avancer_audit(3)
	assert_eq(CountdownManager.get_current("audit_marine"), 3)
