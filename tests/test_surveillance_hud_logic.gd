extends GutTest

# Tests de la logique d'affichage du HUD (SurveillanceHUDLogic),
# instanciée DIRECTEMENT (pas via autoload, pas via TestEnvironment).
# Cela permet de tester le calcul d'état sans dépendre du rendu.


const HUDLogic := preload("res://scripts/ui/SurveillanceHUDLogic.gd")


func test_nb_dots_pour_niveau_zero() -> void:
	var logic = HUDLogic.new()
	assert_eq(logic.compute_dots(0, 100, 4), 0)


func test_nb_dots_pour_niveau_intermediaire() -> void:
	var logic = HUDLogic.new()
	# 50/100 sur 4 dots → 2 dots allumés
	assert_eq(logic.compute_dots(50, 100, 4), 2)


func test_nb_dots_pour_niveau_max() -> void:
	var logic = HUDLogic.new()
	assert_eq(logic.compute_dots(100, 100, 4), 4)


func test_nb_dots_clamp_au_dessus_max() -> void:
	var logic = HUDLogic.new()
	assert_eq(logic.compute_dots(150, 100, 4), 4,
		"compute_dots doit clamper même si value > max")


func test_ligne_active_quand_threshold_franchi() -> void:
	var logic = HUDLogic.new()
	assert_eq(logic.line_label(0, 25), "")
	assert_eq(logic.line_label(25, 25), "ÉCOUTE PARTIELLE")


func test_ligne_active_par_niveau() -> void:
	var logic = HUDLogic.new()
	assert_eq(logic.line_label(60, 50), "ÉCOUTE ACTIVE")
	assert_eq(logic.line_label(80, 75), "TU ES SUIVIE")
	assert_eq(logic.line_label(100, 90), "EXTRACTION IMMINENTE")
