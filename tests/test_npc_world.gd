extends "res://tests/helpers/test_environment.gd"

const NPCScene := preload("res://scenes/base/NPC.tscn")


func _make_npc(id: String) -> Node:
	var npc = NPCScene.instantiate()
	npc.pnj_id = id
	add_child_autofree(npc)
	return npc


# --- get_timeline --------------------------------------------------------

func test_timeline_par_defaut_neutre() -> void:
	RelationManager.reset_all_for_new_game()
	var npc = _make_npc("sara")
	# sara init = 0 → palier "neutre" → suffix "_neutre"
	assert_eq(npc.get_timeline(), "sara_neutre")


func test_timeline_flag_allie_priorite() -> void:
	RelationManager.reset_all_for_new_game()
	GameStateManager.reset_all_for_new_game()
	GameStateManager.set_flag("flag_sara_allie", true)
	var npc = _make_npc("sara")
	assert_eq(npc.get_timeline(), "sara_allie")


func test_timeline_flag_tension_si_pas_allie() -> void:
	RelationManager.reset_all_for_new_game()
	GameStateManager.reset_all_for_new_game()
	GameStateManager.set_flag("flag_sara_tension", true)
	var npc = _make_npc("sara")
	assert_eq(npc.get_timeline(), "sara_tension")


func test_timeline_palier_confiance_donne_allie() -> void:
	RelationManager.reset_all_for_new_game()
	GameStateManager.reset_all_for_new_game()
	RelationManager.modifier("sara", 40, "test")   # → confiance
	var npc = _make_npc("sara")
	assert_eq(npc.get_timeline(), "sara_allie")


func test_timeline_palier_mefiance_donne_tension() -> void:
	RelationManager.reset_all_for_new_game()
	GameStateManager.reset_all_for_new_game()
	RelationManager.modifier("viktor", -20, "test")   # viktor init = -20 → -40 → méfiance
	var npc = _make_npc("viktor")
	assert_eq(npc.get_timeline(), "viktor_tension")


# --- get_display_name (passe par RelationManager.get_label → registry) ----

func test_display_name_canonical() -> void:
	CharacterRegistry.reset_all_for_new_game()
	var npc = _make_npc("sara")
	assert_eq(npc.get_display_name(), "Sara")


func test_display_name_avec_rename() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.set_npc_display_name("sara", "Sara Devereux")
	var npc = _make_npc("sara")
	assert_eq(npc.get_display_name(), "Sara Devereux")
