extends Node
## PRO-01 — Initialisation des variables narratives au démarrage du
## prologue. Appelé par le _ready de scenes/prologue/pro_arrivee.tscn.
##
## Ces valeurs sont LOCALES au prologue, pas des défauts globaux.
## SaveManager.new_game() remet à 0 ; ce script repose les init
## spécifiques du prologue par-dessus.

const TIMELINE_PRO_ARRIVEE := "res://dialogic/timelines/pro_arrivee.dtl"


func _ready() -> void:
	_initialiser_variables()
	_demarrer_timeline()


func _initialiser_variables() -> void:
	# Variables narratives (GameStateManager)
	GameStateManager.mental_stability = 3
	GameStateManager.personal_danger = 0
	GameStateManager.evidence_collected = 0
	GameStateManager.set_flag("flag_emma_a_reveele", false)

	# Countdowns canon (CountdownManager les pose déjà via
	# reset_all_for_new_game appelé par SaveManager.new_game,
	# mais on garantit ici l'état attendu en début de prologue).
	if not CountdownManager.exists("equipe_nettoyage"):
		CountdownManager.create_countdown("equipe_nettoyage", 14,
			"Équipe Nettoyage Stratom")
	else:
		CountdownManager.reset("equipe_nettoyage")
	if not CountdownManager.exists("audit_marine"):
		CountdownManager.create_countdown("audit_marine", 15,
			"Audit Marine par Kaizen")
	else:
		CountdownManager.reset("audit_marine")

	# Chapitre
	GameStateManager.changer_chapitre("prologue")


func _demarrer_timeline() -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic == null:
		push_warning("[PRO-01] Dialogic introuvable — installation requise.")
		return
	if not dialogic.has_method("start"):
		push_warning("[PRO-01] Dialogic.start() introuvable.")
		return
	# Sync variables Dialogic avant le start
	if dialogic.has_subsystem("VAR") and dialogic.VAR.has_method("set_variable"):
		dialogic.VAR.set_variable("ex_prenom", ExProfileManager.ex_name)
		dialogic.VAR.set_variable("ex_genre", ExProfileManager.ex_gender)
		# Prénoms personnalisables — par défaut canonical
		dialogic.VAR.set_variable("emma_prenom", "Emma")
		dialogic.VAR.set_variable("frank_prenom", "Frank")
		dialogic.VAR.set_variable("sofia_prenom", "Sofia")
	dialogic.start(TIMELINE_PRO_ARRIVEE)
