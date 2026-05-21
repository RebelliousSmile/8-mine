extends "res://tests/helpers/test_environment.gd"


# --- Mental stability (0-6, clamp, signal) -------------------------------

func test_mental_stability_defaut_zero() -> void:
	GameStateManager.reset_all_for_new_game()
	assert_eq(GameStateManager.mental_stability, 0)


func test_mental_stability_clamp_haut() -> void:
	GameStateManager.reset_all_for_new_game()
	GameStateManager.mental_stability = 12
	assert_eq(GameStateManager.mental_stability,
		GameStateManager.MENTAL_STABILITY_MAX)


func test_mental_stability_clamp_bas() -> void:
	GameStateManager.reset_all_for_new_game()
	GameStateManager.mental_stability = -5
	assert_eq(GameStateManager.mental_stability,
		GameStateManager.MENTAL_STABILITY_MIN)


func test_mental_stability_emet_signal() -> void:
	GameStateManager.reset_all_for_new_game()
	watch_signals(GameStateManager)
	GameStateManager.mental_stability = 3
	assert_signal_emitted_with_parameters(
		GameStateManager, "mental_stability_changed", [0, 3])


# --- Rename evidence_value → evidence_collected --------------------------

func test_evidence_collected_existe() -> void:
	GameStateManager.reset_all_for_new_game()
	GameStateManager.evidence_collected = 10
	assert_eq(GameStateManager.evidence_collected, 10)


func test_migration_save_v1_evidence_value() -> void:
	# Un save v1 (ancien nom) doit être chargé silencieusement
	GameStateManager.reset_all_for_new_game()
	GameStateManager.appliquer_etat({
		"evidence_value": 7,   # ancien nom
		"flags": {},
		"decisions": [],
		"chapitre": "",
	})
	assert_eq(GameStateManager.evidence_collected, 7,
		"appliquer_etat doit reconnaître l'ancien nom evidence_value")
