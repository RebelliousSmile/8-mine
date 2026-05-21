extends "res://tests/helpers/test_environment.gd"


# --- Défauts canoniques ---------------------------------------------------

func test_defaut_ex_name_julien() -> void:
	ExProfileManager.reset_all_for_new_game()
	assert_eq(ExProfileManager.ex_name, "Julien")
	assert_false(ExProfileManager.is_name_overridden)


func test_defaut_ex_gender_masculin() -> void:
	ExProfileManager.reset_all_for_new_game()
	assert_eq(ExProfileManager.ex_gender, "masculin")
	assert_false(ExProfileManager.is_gender_overridden)


# --- set_ex_name ----------------------------------------------------------

func test_set_ex_name_premier_appel_reussit() -> void:
	ExProfileManager.reset_all_for_new_game()
	var ok = ExProfileManager.set_ex_name("Naoki")
	assert_true(ok)
	assert_eq(ExProfileManager.ex_name, "Naoki")
	assert_true(ExProfileManager.is_name_overridden)


func test_set_ex_name_second_appel_refuse() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_name("Naoki")
	var ok = ExProfileManager.set_ex_name("Autre")
	assert_false(ok)
	assert_eq(ExProfileManager.ex_name, "Naoki",
		"nom doit rester immuable après premier override")


# --- set_ex_gender (v7) ---------------------------------------------------

func test_set_ex_gender_premier_appel_reussit() -> void:
	ExProfileManager.reset_all_for_new_game()
	var ok = ExProfileManager.set_ex_gender("feminin")
	assert_true(ok)
	assert_eq(ExProfileManager.ex_gender, "feminin")
	assert_true(ExProfileManager.is_gender_overridden)


func test_set_ex_gender_second_appel_refuse() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_gender("feminin")
	var ok = ExProfileManager.set_ex_gender("non_binaire")
	assert_false(ok)
	assert_eq(ExProfileManager.ex_gender, "feminin")


func test_get_pronouns_feminin() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_gender("feminin")
	var p = ExProfileManager.get_pronouns()
	assert_eq(p.subject, "elle")
	assert_eq(p.object, "la")
	assert_eq(p.possessive, "sa")


func test_get_pronouns_non_binaire() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_gender("non_binaire")
	var p = ExProfileManager.get_pronouns()
	assert_eq(p.subject, "iel")


func test_set_ex_gender_emet_signal() -> void:
	ExProfileManager.reset_all_for_new_game()
	watch_signals(ExProfileManager)
	ExProfileManager.set_ex_gender("feminin")
	assert_signal_emitted_with_parameters(
		ExProfileManager, "ex_gender_set", ["feminin"])


# --- Traits ---------------------------------------------------------------

func test_add_trait_valide() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.add_trait("manipulateur")
	assert_true(ExProfileManager.has_trait("manipulateur"))


func test_add_trait_pas_de_doublon() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.add_trait("manipulateur")
	ExProfileManager.add_trait("manipulateur")
	# Doublon silencieux, le trait reste présent une seule fois
	assert_eq(ExProfileManager.ex_traits.size(), 1)


# --- is_defined ----------------------------------------------------------

func test_is_defined_false_par_defaut() -> void:
	ExProfileManager.reset_all_for_new_game()
	assert_false(ExProfileManager.is_defined())


func test_is_defined_true_apres_set_name() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_name("Naoki")
	assert_true(ExProfileManager.is_defined())


func test_is_defined_true_apres_set_gender_seul() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_gender("feminin")
	assert_true(ExProfileManager.is_defined(),
		"is_defined doit être true si gender override seul (v7)")


func test_is_defined_true_apres_add_trait() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.add_trait("absent")
	assert_true(ExProfileManager.is_defined())


# --- Echo phrase ----------------------------------------------------------

func test_echo_phrase_undefined() -> void:
	ExProfileManager.reset_all_for_new_game()
	var phrase = ExProfileManager.get_echo_phrase()
	assert_eq(phrase, "Tu reproduis un pattern que tu connais trop bien.")


func test_echo_phrase_defined_avec_nom() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_name("Naoki")
	var phrase = ExProfileManager.get_echo_phrase()
	assert_eq(phrase, "Comme Naoki faisait.")


# --- Save / load ---------------------------------------------------------

func test_save_load_roundtrip_avec_genre() -> void:
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_name("Naoki")
	ExProfileManager.set_ex_gender("non_binaire")
	ExProfileManager.add_trait("manipulateur")
	var data = ExProfileManager.save_state()
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.load_state(data)
	assert_eq(ExProfileManager.ex_name, "Naoki")
	assert_eq(ExProfileManager.ex_gender, "non_binaire")
	assert_true(ExProfileManager.is_gender_overridden)
	assert_true(ExProfileManager.has_trait("manipulateur"))


func test_reset_all_remet_defauts() -> void:
	ExProfileManager.set_ex_name("Naoki")
	ExProfileManager.set_ex_gender("feminin")
	ExProfileManager.add_trait("absent")
	ExProfileManager.reset_all_for_new_game()
	assert_eq(ExProfileManager.ex_name, "Julien")
	assert_eq(ExProfileManager.ex_gender, "masculin")
	assert_false(ExProfileManager.is_name_overridden)
	assert_false(ExProfileManager.is_gender_overridden)
	assert_eq(ExProfileManager.ex_traits.size(), 0)
