extends "res://tests/helpers/test_environment.gd"


func test_npc_definitions_contient_17_entrees() -> void:
	# 9 Prompt 4a + 8 résidents 8-MINE = 17
	assert_eq(RelationManager.NPC_DEFINITIONS.size(), 17)


func test_residents_8mine_presents() -> void:
	for id in ["emma", "frank", "sofia",
			"marine", "thomas", "leo", "camille", "alex"]:
		assert_true(RelationManager.NPC_DEFINITIONS.has(id),
			"résident '%s' attendu dans NPC_DEFINITIONS" % id)


func test_emma_init_relation_positive() -> void:
	RelationManager.reset_all_for_new_game()
	# Emma = cousine de Margot, init > 0
	assert_eq(RelationManager.get_valeur("emma"), 20)


func test_residents_factions_par_corpo() -> void:
	# 2 employés par corpo : memorize, stratom, nexus, kaizen
	var par_faction := {}
	for id in ["emma", "frank", "sofia", "marine", "thomas",
			"leo", "camille", "alex"]:
		var f: String = RelationManager.NPC_DEFINITIONS[id]["faction"]
		par_faction[f] = par_faction.get(f, 0) + 1
	assert_eq(par_faction.get("memorize", 0), 2)
	assert_eq(par_faction.get("nexus", 0), 2)
	assert_eq(par_faction.get("kaizen", 0), 2)
	# stratom = 2 résidents (frank/thomas), partagé avec viktor/marl externes
	assert_eq(par_faction.get("stratom", 0), 2)


func test_get_label_residents() -> void:
	RelationManager.reset_all_for_new_game()
	assert_eq(RelationManager.get_label("emma"), "Emma")
	assert_eq(RelationManager.get_label("leo"), "Léo")
	assert_eq(RelationManager.get_label("camille"), "Camille")


# --- Réputation corpos 8-MINE --------------------------------------------

func test_faction_definitions_inclut_corpos_8mine() -> void:
	for f in ["memorize", "nexus", "kaizen"]:
		assert_true(ReputationManager.FACTION_DEFINITIONS.has(f),
			"faction '%s' attendue dans FACTION_DEFINITIONS" % f)


func test_get_label_corpos_8mine() -> void:
	ReputationManager.reset_all_for_new_game()
	assert_eq(ReputationManager.get_label("memorize"), "Memorize Corp")
	assert_eq(ReputationManager.get_label("nexus"), "Nexus Biotech")
	assert_eq(ReputationManager.get_label("kaizen"), "Kaizen Corp")


# --- Rename via CharacterRegistry sur résidents 8-MINE -------------------

func test_renommer_emma_via_registry() -> void:
	CharacterRegistry.reset_all_for_new_game()
	var ok = CharacterRegistry.set_npc_display_name("emma", "Emma Sinclair")
	assert_true(ok, "emma doit être renommable (présente dans NPC_DEFINITIONS)")
	assert_eq(RelationManager.get_label("emma"), "Emma Sinclair")
