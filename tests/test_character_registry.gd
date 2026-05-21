extends "res://tests/helpers/test_environment.gd"


# --- PC (personnage joueur) -----------------------------------------------

func test_pc_name_defaut_margot() -> void:
	CharacterRegistry.reset_all_for_new_game()
	assert_eq(CharacterRegistry.pc_name, "Margot")
	assert_false(CharacterRegistry.is_pc_name_overridden)


func test_set_pc_name_premier_appel_reussit() -> void:
	CharacterRegistry.reset_all_for_new_game()
	var ok = CharacterRegistry.set_pc_name("Maïa")
	assert_true(ok)
	assert_eq(CharacterRegistry.pc_name, "Maïa")
	assert_true(CharacterRegistry.is_pc_name_overridden)


func test_set_pc_name_second_appel_refuse() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.set_pc_name("Maïa")
	var ok = CharacterRegistry.set_pc_name("Autre")
	assert_false(ok)
	assert_eq(CharacterRegistry.pc_name, "Maïa")


func test_set_pc_name_emet_signal() -> void:
	CharacterRegistry.reset_all_for_new_game()
	watch_signals(CharacterRegistry)
	CharacterRegistry.set_pc_name("Maïa")
	assert_signal_emitted_with_parameters(
		CharacterRegistry, "pc_name_set", ["Maïa"])


# --- Renommage PNJ principaux --------------------------------------------

func test_set_npc_display_name_premier_appel_reussit() -> void:
	CharacterRegistry.reset_all_for_new_game()
	var ok = CharacterRegistry.set_npc_display_name("sara", "Sara Devereux")
	assert_true(ok)
	assert_eq(CharacterRegistry.get_npc_display_name("sara"), "Sara Devereux")


func test_set_npc_display_name_second_appel_refuse() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.set_npc_display_name("sara", "Sara D.")
	var ok = CharacterRegistry.set_npc_display_name("sara", "Autre nom")
	assert_false(ok)
	assert_eq(CharacterRegistry.get_npc_display_name("sara"), "Sara D.")


func test_set_npc_display_name_assert_id_inconnu() -> void:
	CharacterRegistry.reset_all_for_new_game()
	# ID hors NPC_DEFINITIONS → false (pas un PNJ principal)
	var ok = CharacterRegistry.set_npc_display_name("inconnu_xyz", "Bidule")
	assert_false(ok,
		"set_npc_display_name doit refuser un id hors NPC_DEFINITIONS")


func test_get_npc_display_name_fallback_canonical() -> void:
	CharacterRegistry.reset_all_for_new_game()
	RelationManager.reset_all_for_new_game()
	assert_eq(CharacterRegistry.get_npc_display_name("sara"), "Sara")
	assert_eq(CharacterRegistry.get_npc_display_name("viktor"), "Viktor")


func test_relation_manager_get_label_utilise_override() -> void:
	CharacterRegistry.reset_all_for_new_game()
	RelationManager.reset_all_for_new_game()
	CharacterRegistry.set_npc_display_name("sara", "Sara Devereux")
	assert_eq(RelationManager.get_label("sara"), "Sara Devereux",
		"RelationManager.get_label doit refléter le rename du registry")


func test_has_npc_override() -> void:
	CharacterRegistry.reset_all_for_new_game()
	assert_false(CharacterRegistry.has_npc_override("sara"))
	CharacterRegistry.set_npc_display_name("sara", "Sara D.")
	assert_true(CharacterRegistry.has_npc_override("sara"))
	assert_false(CharacterRegistry.has_npc_override("kaizen"))


# --- PNJ secondaires ------------------------------------------------------

func test_valid_roles_constante() -> void:
	for r in ["collegue", "membre_corp", "famille", "voisin", "anonyme"]:
		assert_true(r in CharacterRegistry.VALID_ROLES,
			"rôle '%s' attendu dans VALID_ROLES" % r)


func test_add_secondary_basique() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("paul", "Paul", "collegue", "presse")
	var s = CharacterRegistry.get_secondary("paul")
	assert_eq(s.name, "Paul")
	assert_eq(s.role, "collegue")
	assert_eq(s.faction, "presse")


func test_add_secondary_avec_description() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary(
		"yael", "Yaël", "membre_corp", "stratom",
		"Cheffe de produit, croisée à la cantine")
	assert_eq(CharacterRegistry.get_secondary("yael").description,
		"Cheffe de produit, croisée à la cantine")


func test_add_secondary_emet_signal() -> void:
	CharacterRegistry.reset_all_for_new_game()
	watch_signals(CharacterRegistry)
	CharacterRegistry.add_secondary("paul", "Paul", "collegue")
	assert_signal_emitted(CharacterRegistry, "secondary_added")


func test_list_secondaries() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("a", "Alex", "collegue")
	CharacterRegistry.add_secondary("b", "Bob", "membre_corp", "stratom")
	assert_eq(CharacterRegistry.list_secondaries().size(), 2)


func test_list_by_faction() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("a", "Alex", "collegue", "presse")
	CharacterRegistry.add_secondary("b", "Bob", "membre_corp", "stratom")
	CharacterRegistry.add_secondary("c", "Chloé", "membre_corp", "stratom")
	var stratom_list = CharacterRegistry.list_by_faction("stratom")
	assert_eq(stratom_list.size(), 2)
	var ids := []
	for entry in stratom_list:
		ids.append(entry.id)
	assert_true("b" in ids)
	assert_true("c" in ids)


func test_list_by_role() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("a", "Alex", "collegue", "presse")
	CharacterRegistry.add_secondary("b", "Bob", "collegue", "stratom")
	CharacterRegistry.add_secondary("c", "Chloé", "famille")
	assert_eq(CharacterRegistry.list_by_role("collegue").size(), 2)
	assert_eq(CharacterRegistry.list_by_role("famille").size(), 1)


func test_rename_secondary() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("a", "Alex", "collegue")
	CharacterRegistry.rename_secondary("a", "Alexandre")
	assert_eq(CharacterRegistry.get_secondary("a").name, "Alexandre")


func test_rename_secondary_inconnu_silencieux() -> void:
	CharacterRegistry.reset_all_for_new_game()
	# Pas d'assert : rename d'un id inconnu doit être un no-op
	CharacterRegistry.rename_secondary("inexistant", "Bidule")
	assert_eq(CharacterRegistry.get_secondary("inexistant").size(), 0)


func test_remove_secondary() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("a", "Alex", "collegue")
	CharacterRegistry.remove_secondary("a")
	assert_eq(CharacterRegistry.get_secondary("a").size(), 0)
	assert_eq(CharacterRegistry.list_secondaries().size(), 0)


func test_add_secondary_doublon_refuse() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.add_secondary("a", "Alex", "collegue")
	var ok = CharacterRegistry.add_secondary("a", "Autre Alex", "famille")
	assert_false(ok,
		"add_secondary doit refuser un id déjà utilisé")
	assert_eq(CharacterRegistry.get_secondary("a").name, "Alex")


# --- Save / load / reset --------------------------------------------------

func test_save_load_roundtrip_complet() -> void:
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.set_pc_name("Maïa")
	CharacterRegistry.set_npc_display_name("sara", "Sara Devereux")
	CharacterRegistry.set_npc_display_name("viktor", "V. Stratom")
	CharacterRegistry.add_secondary("paul", "Paul", "collegue", "presse",
		"Rédacteur sport")
	CharacterRegistry.add_secondary("yael", "Yaël", "membre_corp", "stratom")
	var data = CharacterRegistry.save_state()
	CharacterRegistry.reset_all_for_new_game()
	CharacterRegistry.load_state(data)
	assert_eq(CharacterRegistry.pc_name, "Maïa")
	assert_true(CharacterRegistry.is_pc_name_overridden)
	assert_eq(CharacterRegistry.get_npc_display_name("sara"), "Sara Devereux")
	assert_eq(CharacterRegistry.get_npc_display_name("viktor"), "V. Stratom")
	assert_eq(CharacterRegistry.get_secondary("paul").description,
		"Rédacteur sport")
	assert_eq(CharacterRegistry.list_secondaries().size(), 2)


func test_save_manager_inclut_registry() -> void:
	const SLOT := 2
	SaveManager.effacer_slot(SLOT)
	SaveManager.new_game()
	CharacterRegistry.set_pc_name("Maïa")
	CharacterRegistry.add_secondary("paul", "Paul", "collegue", "presse")
	SaveManager.sauvegarder(SLOT)
	SaveManager.new_game()
	SaveManager.charger(SLOT)
	assert_eq(CharacterRegistry.pc_name, "Maïa")
	assert_eq(CharacterRegistry.get_secondary("paul").name, "Paul")
	SaveManager.effacer_slot(SLOT)


func test_reset_remet_defauts() -> void:
	CharacterRegistry.set_pc_name("Maïa")
	CharacterRegistry.set_npc_display_name("sara", "Sara D.")
	CharacterRegistry.add_secondary("paul", "Paul", "collegue")
	CharacterRegistry.reset_all_for_new_game()
	assert_eq(CharacterRegistry.pc_name, "Margot")
	assert_false(CharacterRegistry.is_pc_name_overridden)
	assert_false(CharacterRegistry.has_npc_override("sara"))
	assert_eq(CharacterRegistry.list_secondaries().size(), 0)
