extends "res://tests/helpers/test_environment.gd"


func test_npc_definitions_contient_9_pnjs_prompt4a() -> void:
	# Les 9 PNJ canon du Prompt 4a doivent toujours être présents
	# (extension à 17 incluant les résidents 8-MINE — voir
	# test_relation_8mine_residents.gd).
	for id in ["sara", "kaizen", "lior", "marl", "tess",
			"viktor", "mira", "aslan", "nadia"]:
		assert_true(RelationManager.NPC_DEFINITIONS.has(id),
			"PNJ Prompt 4a '%s' manquant" % id)


func test_npc_definitions_ids_attendus() -> void:
	var attendus = ["sara", "kaizen", "lior", "marl", "tess",
		"viktor", "mira", "aslan", "nadia"]
	for id in attendus:
		assert_true(RelationManager.NPC_DEFINITIONS.has(id),
			"NPC_DEFINITIONS doit avoir l'entrée '%s'" % id)


func test_reset_pose_valeurs_init() -> void:
	RelationManager.reset_all_for_new_game()
	assert_eq(RelationManager.get_valeur("kaizen"), -10)
	assert_eq(RelationManager.get_valeur("viktor"), -20)
	assert_eq(RelationManager.get_valeur("mira"), 15)


func test_get_label_pour_pnj_canon() -> void:
	RelationManager.reset_all_for_new_game()
	assert_eq(RelationManager.get_label("sara"), "Sara")
	assert_eq(RelationManager.get_label("viktor"), "Viktor")


func test_save_state_renvoie_dict_non_vide() -> void:
	RelationManager.reset_all_for_new_game()
	RelationManager.modifier("sara", 20, "test")
	var data = RelationManager.save_state()
	assert_true(data is Dictionary)
	assert_true(data.size() > 0,
		"save_state doit retourner les valeurs et l'historique")


func test_load_state_roundtrip() -> void:
	RelationManager.reset_all_for_new_game()
	RelationManager.modifier("sara", 25, "test")
	RelationManager.modifier("viktor", -10, "test")
	var data = RelationManager.save_state()
	RelationManager.reset_all_for_new_game()
	RelationManager.load_state(data)
	assert_eq(RelationManager.get_valeur("sara"), 25)
	assert_eq(RelationManager.get_valeur("viktor"), -30,
		"viktor part de -20 init puis -10 de modif = -30")


func test_reset_revient_aux_inits() -> void:
	RelationManager.reset_all_for_new_game()
	RelationManager.modifier("sara", 30, "test")
	RelationManager.reset_all_for_new_game()
	assert_eq(RelationManager.get_valeur("sara"), 0)
	assert_eq(RelationManager.get_valeur("viktor"), -20)
