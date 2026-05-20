extends "res://tests/helpers/test_environment.gd"

const HotspotScene := preload("res://scenes/base/Hotspot.tscn")


func _make_hotspot() -> Area2D:
	var h = HotspotScene.instantiate()
	add_child_autofree(h)
	return h


# --- Activation par flag --------------------------------------------------

func test_actif_sans_required_flag() -> void:
	var h = _make_hotspot()
	# Pas de required_flag → toujours actif/visible
	assert_true(h.visible)


func test_inactif_si_flag_absent() -> void:
	GameStateManager.reset_all_for_new_game()
	var h = _make_hotspot()
	h.required_flag = "flag_test"
	h.required_flag_value = true
	h._evaluer_visibilite()
	assert_false(h.visible,
		"hotspot doit être invisible tant que flag_test n'est pas true")


func test_actif_quand_flag_pose() -> void:
	GameStateManager.reset_all_for_new_game()
	var h = _make_hotspot()
	h.required_flag = "flag_test"
	h.required_flag_value = true
	h._evaluer_visibilite()
	GameStateManager.set_flag("flag_test", true)
	# Le signal flag_modifie déclenche un re-eval
	await get_tree().process_frame
	assert_true(h.visible)


func test_position_interaction_avec_offset() -> void:
	var h = _make_hotspot()
	h.global_position = Vector2(500, 300)
	h.interaction_offset = Vector2(0, 80)
	assert_eq(h.get_interaction_position(), Vector2(500, 380))


# --- Execute interaction selon type --------------------------------------

func test_examine_emet_signal_avec_texte() -> void:
	var h = _make_hotspot()
	h.hotspot_type = h.HotspotType.EXAMINE
	h.examine_text = "Un mur fissuré."
	watch_signals(h)
	h.execute_interaction()
	assert_signal_emitted_with_parameters(
		h, "examine_demande", ["Un mur fissuré."])


func test_pickup_emet_signal_avec_hotspot() -> void:
	var h = _make_hotspot()
	h.hotspot_type = h.HotspotType.PICKUP
	h.pickup_item_id = "cle_chambre"
	watch_signals(h)
	h.execute_interaction()
	assert_signal_emitted(h, "pickup_demande")
