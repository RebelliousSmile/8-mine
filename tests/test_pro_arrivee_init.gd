extends "res://tests/helpers/test_environment.gd"

const InitScript := preload("res://scripts/prologue/pro_arrivee_init.gd")


func _instancier_init() -> Node:
	# On instancie le script seul (sans le start de timeline) pour
	# tester _initialiser_variables en isolation.
	var n := Node.new()
	n.set_script(InitScript)
	add_child_autofree(n)
	return n


func test_init_pose_mental_stability_3() -> void:
	SaveManager.new_game()
	var init = _instancier_init()
	init._initialiser_variables()
	assert_eq(GameStateManager.mental_stability, 3)


func test_init_pose_personal_danger_0() -> void:
	SaveManager.new_game()
	GameStateManager.personal_danger = 5   # pollue
	var init = _instancier_init()
	init._initialiser_variables()
	assert_eq(GameStateManager.personal_danger, 0)


func test_init_pose_evidence_collected_0() -> void:
	SaveManager.new_game()
	GameStateManager.evidence_collected = 10
	var init = _instancier_init()
	init._initialiser_variables()
	assert_eq(GameStateManager.evidence_collected, 0)


func test_init_pose_flag_emma_a_reveele_false() -> void:
	SaveManager.new_game()
	GameStateManager.set_flag("flag_emma_a_reveele", true)
	var init = _instancier_init()
	init._initialiser_variables()
	assert_false(GameStateManager.a_flag("flag_emma_a_reveele"))


func test_init_pose_countdowns_canon() -> void:
	CountdownManager.reset_all_for_new_game()
	# Pollue d'abord
	CountdownManager.tick("audit_marine", 7)
	CountdownManager.tick("equipe_nettoyage", 3)
	var init = _instancier_init()
	init._initialiser_variables()
	assert_eq(CountdownManager.get_current("audit_marine"), 0)
	assert_eq(CountdownManager.get_current("equipe_nettoyage"), 0)
	assert_eq(CountdownManager.get_max("audit_marine"), 15)
	assert_eq(CountdownManager.get_max("equipe_nettoyage"), 14)


func test_init_change_chapitre_prologue() -> void:
	GameStateManager.changer_chapitre("")
	var init = _instancier_init()
	init._initialiser_variables()
	assert_eq(GameStateManager.get_chapitre(), "prologue")
