extends Node2D
## Scène-racine A1-03 — Dîner d'arrivée. Délègue l'init à diner_arrivee_init,
## écoute la fin de la timeline et déclenche la transition vers la scène
## suivante (coursive_residents_nuit, à créer).
##
## Hiérarchie attendue :
##   DinerArrivee (Node2D, ce script)
##     ├─ Init (Node, scripts/acte1/diner_arrivee_init.gd)
##     ├─ Background (Sprite2D)         ← swappé par signaux Dialogic bg:
##     ├─ Characters (Node2D)           ← sprites des 8 PNJ à la table
##     └─ DialogueLayer (CanvasLayer)   ← Dialogic ajoute son layout ici
##
## Précondition d'exécution :
##   - Sortie d'un NODE A1-01-* (micros / éthique / confrontation / stratège)
##   - {emma_prenom} posé par PRO-01 (ask_name déjà déclenché)
##
## Sortie : signal Dialogic lieu:coursive_residents_nuit en fin de timeline.

const CHEMIN_COURSIVE_NUIT := "res://scenes/acte1/coursive_residents_nuit.tscn"

const BACKGROUNDS := {
	"bg_zone_commune_soir": "res://assets/backgrounds/bg_zone_commune_soir.jpg",
}

@onready var _background: Sprite2D = $Background


func _ready() -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic and dialogic.has_signal("signal_event"):
		dialogic.signal_event.connect(_on_dialogic_signal)
	if dialogic and dialogic.has_signal("timeline_ended"):
		dialogic.timeline_ended.connect(_on_timeline_ended)


func _on_dialogic_signal(arg: String) -> void:
	# Intercepte les signaux bg: pour mettre à jour le background
	# (les autres signaux relation:, flag:, etc. sont gérés par DialogicBridge)
	if arg.begins_with("bg:"):
		var bg_id := arg.substr(3)
		_changer_background(bg_id)


func _changer_background(bg_id: String) -> void:
	if not bg_id in BACKGROUNDS:
		push_warning("DinerArrivee : background inconnu '%s'" % bg_id)
		return
	var chemin: String = BACKGROUNDS[bg_id]
	if ResourceLoader.exists(chemin):
		var texture: Texture2D = load(chemin)
		_background.texture = texture
	else:
		push_warning("DinerArrivee : fichier background introuvable '%s' " % chemin
			+ "(à générer dans assets/backgrounds/)")


func _on_timeline_ended() -> void:
	# Vérifier le flag de sortie posé en fin de timeline
	if not GameStateManager.has_flag("flag_diner_arrivee_consomme"):
		push_warning("DinerArrivee : timeline terminée sans flag de sortie")
		return

	# Transition vers la scène suivante
	if ResourceLoader.exists(CHEMIN_COURSIVE_NUIT):
		get_tree().change_scene_to_file(CHEMIN_COURSIVE_NUIT)
	else:
		# Scène coursive_residents_nuit pas encore créée — log + retour menu
		push_warning("DinerArrivee : coursive_residents_nuit.tscn pas encore créée. "
			+ "Retour à l'écran d'accueil ou continuer en placeholder.")
		# get_tree().change_scene_to_file("res://scenes/Main.tscn")
