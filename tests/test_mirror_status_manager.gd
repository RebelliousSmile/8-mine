extends "res://tests/helpers/test_environment.gd"


func test_init_a_zero() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	assert_eq(MirrorStatusManager.get_status(), 0)


func test_increase_clamp_100() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	MirrorStatusManager.increase(150, "test")
	assert_eq(MirrorStatusManager.get_status(), 100)


func test_decrease_clamp_zero() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	MirrorStatusManager.decrease(50, "test")
	assert_eq(MirrorStatusManager.get_status(), 0)


func test_threshold_crossed_30_60_90() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	watch_signals(MirrorStatusManager)
	MirrorStatusManager.increase(95, "test")  # franchit 30, 60, 90
	assert_signal_emit_count(MirrorStatusManager, "threshold_crossed", 3)


func test_overlay_quote_undefined() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	ExProfileManager.reset_all_for_new_game()
	var q = MirrorStatusManager.get_overlay_quote()
	assert_eq(q, "Tu reproduis un pattern que tu connais trop bien.")


func test_overlay_quote_avec_ex_nomme() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	ExProfileManager.reset_all_for_new_game()
	ExProfileManager.set_ex_name("Naoki")
	var q = MirrorStatusManager.get_overlay_quote()
	assert_eq(q, "Comme Naoki faisait.")


func test_save_load_roundtrip() -> void:
	MirrorStatusManager.reset_all_for_new_game()
	MirrorStatusManager.increase(45, "test")
	var data = MirrorStatusManager.save_state()
	MirrorStatusManager.reset_all_for_new_game()
	MirrorStatusManager.load_state(data)
	assert_eq(MirrorStatusManager.get_status(), 45)
