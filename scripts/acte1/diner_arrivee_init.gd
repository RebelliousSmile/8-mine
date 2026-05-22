extends Node
## A1-03 Dîner d'arrivée — Initialisation des variables narratives.
## Appelé par le _ready de scenes/acte1/diner_arrivee.tscn.
##
## Précondition : sortie d'un NODE A1-01-* (flags posés en amont).

const TIMELINE_DINER_ARRIVEE := "res://dialogic/timelines/diner_arrivee.dtl"


func _ready() -> void:
	if not _verifier_preconditions():
		# Routing erroné — la scène a été chargée hors séquence
		push_warning("DinerArrivee : préconditions A1-01-* non remplies. "
			+ "La scène attend une sortie de A1-01-micro/ethique/confrontation/stratege.")
		# En production : retour menu ou écran d'erreur ; en debug : continuer
		# pour permettre les tests isolés (F6 dans Editor).

	_initialiser_variables()
	_demarrer_timeline()


func _verifier_preconditions() -> bool:
	var flags := [
		"flag_a1_01_micro_passe",
		"flag_a1_01_ethique_passe",
		"flag_a1_01_confrontation_passe",
		"flag_a1_01_stratege_passe",
	]
	for f: String in flags:
		if GameStateManager.has_flag(f) and GameStateManager.get_flag(f) == true:
			return true
	return false


func _initialiser_variables() -> void:
	# Variable Dialogic compteur cap sujets (canon variables-register.md)
	# La pose ici garantit l'initialisation avant tout choix du joueur.
	# La timeline elle-même fait aussi [set var=...] en début mais c'est
	# une double sécurité.
	if get_node_or_null("/root/Dialogic"):
		Dialogic.VAR.set("diner_sujets_consommes", 0)

	# Pas d'autres jauges à initialiser ici — toutes posées par PRO-01
	# ou les NODES A1-01-*.


func _demarrer_timeline() -> void:
	if not get_node_or_null("/root/Dialogic"):
		push_error("DinerArrivee : Dialogic non disponible (plugin manquant ?)")
		return

	if not ResourceLoader.exists(TIMELINE_DINER_ARRIVEE):
		push_error("DinerArrivee : timeline introuvable %s" % TIMELINE_DINER_ARRIVEE)
		return

	Dialogic.start(TIMELINE_DINER_ARRIVEE)
