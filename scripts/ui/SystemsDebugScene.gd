extends Control
## Scène de debug : contrôles manuels pour tous les managers
## 8-MINE + log des signaux. Accessible si Config.DEBUG_MODE.
##
## Voir docs/MANUAL_VALIDATION.md — les 10 cas de référence
## se déroulent depuis cette scène.

@onready var _log_view: TextEdit = $Layout/RightPane/SignalLog/TextEdit
@onready var _label_ex_status: Label = $Layout/LeftPane/ExGroup/ExStatus
@onready var _label_surv: Label = $Layout/LeftPane/SurvGroup/SurvLevel
@onready var _label_mirror: Label = $Layout/LeftPane/MirrorGroup/MirrorLevel
@onready var _label_audit: Label = $Layout/LeftPane/CountGroup/AuditLabel
@onready var _label_nettoyage: Label = $Layout/LeftPane/CountGroup/NettoyageLabel


func _ready() -> void:
	_peupler_trait_select()
	_brancher_signaux()
	_rafraichir_tout()


func _peupler_trait_select() -> void:
	var sel: OptionButton = $Layout/LeftPane/ExGroup/TraitRow/TraitSelect
	for trait_id in ExProfileManager.VALID_TRAITS:
		sel.add_item(trait_id)


# --- Branchement signaux pour le log -------------------------------------

func _brancher_signaux() -> void:
	RelationManager.relation_changed.connect(
		func(p, a, n, r): _log("relation_changed %s %d→%d (%s)" % [p, a, n, r])
	)
	ReputationManager.reputation_changed.connect(
		func(f, a, n, r): _log("reputation_changed %s %d→%d (%s)" % [f, a, n, r])
	)
	SurveillanceManager.surveillance_changed.connect(
		func(a, n, r):
			_log("surveillance_changed %d→%d (%s)" % [a, n, r])
			_rafraichir_surv()
	)
	SurveillanceManager.threshold_crossed.connect(
		func(n): _log("surveillance threshold_crossed %d" % n)
	)
	MirrorStatusManager.mirror_status_changed.connect(
		func(a, n, r):
			_log("mirror_changed %d→%d (%s)" % [a, n, r])
			_rafraichir_mirror()
	)
	MirrorStatusManager.threshold_crossed.connect(
		func(n): _log("mirror threshold_crossed %d" % n)
	)
	CountdownManager.countdown_advanced.connect(
		func(id, c, m, _r):
			_log("countdown_advanced %s %d/%d" % [id, c, m])
			_rafraichir_countdowns()
	)
	CountdownManager.countdown_completed.connect(
		func(id): _log("countdown_completed %s" % id)
	)
	ExProfileManager.ex_name_set.connect(
		func(n):
			_log("ex_name_set %s" % n)
			_rafraichir_ex()
	)
	ExProfileManager.ex_gender_set.connect(
		func(g):
			_log("ex_gender_set %s" % g)
			_rafraichir_ex()
	)


# --- Rafraîchissement labels ---------------------------------------------

func _rafraichir_tout() -> void:
	_rafraichir_ex()
	_rafraichir_surv()
	_rafraichir_mirror()
	_rafraichir_countdowns()


func _rafraichir_ex() -> void:
	var p = ExProfileManager.get_pronouns()
	_label_ex_status.text = "Nom : %s (override=%s)\nGenre : %s (override=%s)\nPronoms : %s\nis_defined : %s" % [
		ExProfileManager.ex_name,
		str(ExProfileManager.is_name_overridden),
		ExProfileManager.ex_gender,
		str(ExProfileManager.is_gender_overridden),
		str(p),
		str(ExProfileManager.is_defined()),
	]


func _rafraichir_surv() -> void:
	_label_surv.text = "Surveillance : %d / %d" % [
		SurveillanceManager.get_level(), SurveillanceManager.MAX
	]


func _rafraichir_mirror() -> void:
	_label_mirror.text = "Mirror : %d / %d" % [
		MirrorStatusManager.get_status(), MirrorStatusManager.MAX
	]


func _rafraichir_countdowns() -> void:
	_label_audit.text = "audit_marine : %d / %d" % [
		CountdownManager.get_current("audit_marine"),
		CountdownManager.get_max("audit_marine"),
	]
	_label_nettoyage.text = "equipe_nettoyage : %d / %d" % [
		CountdownManager.get_current("equipe_nettoyage"),
		CountdownManager.get_max("equipe_nettoyage"),
	]


# --- Helpers -------------------------------------------------------------

func _log(msg: String) -> void:
	_log_view.text += msg + "\n"


# --- Boutons exposés (signal_handler dans le .tscn) ----------------------

func on_new_game() -> void:
	SaveManager.new_game()
	_log("--- NEW GAME ---")
	_rafraichir_tout()


func on_save_slot(slot: int) -> void:
	SaveManager.sauvegarder(slot)
	_log("save slot %d" % slot)


func on_load_slot(slot: int) -> void:
	SaveManager.charger(slot)
	_log("load slot %d" % slot)
	_rafraichir_tout()


# Ex
func on_set_ex_name() -> void:
	var input: LineEdit = $Layout/LeftPane/ExGroup/NameRow/ExNameInput
	if input.text.is_empty():
		return
	ExProfileManager.set_ex_name(input.text)
	_rafraichir_ex()


func on_set_ex_gender(gender: String) -> void:
	ExProfileManager.set_ex_gender(gender)
	_rafraichir_ex()


func on_add_trait() -> void:
	var sel: OptionButton = $Layout/LeftPane/ExGroup/TraitRow/TraitSelect
	if sel.selected < 0:
		return
	var trait_id := sel.get_item_text(sel.selected)
	ExProfileManager.add_trait(trait_id)


# Surveillance / mirror
func on_surv_inc(amount: int) -> void:
	SurveillanceManager.increase(amount, "debug")


func on_surv_dec(amount: int) -> void:
	SurveillanceManager.decrease(amount, "debug")


func on_mirror_inc(amount: int) -> void:
	MirrorStatusManager.increase(amount, "debug")


func on_mirror_dec(amount: int) -> void:
	MirrorStatusManager.decrease(amount, "debug")


# Countdowns
func on_tick_audit() -> void:
	CountdownManager.tick("audit_marine", 1)


func on_tick_nettoyage() -> void:
	CountdownManager.tick("equipe_nettoyage", 1)


# Relations / Reputation
func on_modify_sara(delta: int) -> void:
	RelationManager.modifier("sara", delta, "debug")


func on_modify_stratom(delta: int) -> void:
	ReputationManager.modifier("stratom", delta, "debug")


# Game over
func on_trigger_game_over_mirror() -> void:
	await GameOverHandler.trigger_game_over({
		"type": "mirror",
		"title": "Effondrement",
		"overlay_quote": MirrorStatusManager.get_overlay_quote(),
		"history": [],
	})
