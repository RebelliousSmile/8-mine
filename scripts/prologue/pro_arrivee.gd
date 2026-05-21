extends Node2D
## Scène-racine du prologue PRO-01. Délègue l'init à pro_arrivee_init,
## écoute la fin de la timeline et déclenche la transition vers
## pro_zone_commune.tscn (scène navigable).
##
## Hiérarchie attendue :
##   ProArrivee (Node2D, ce script)
##     ├─ Init (Node, scripts/prologue/pro_arrivee_init.gd)
##     ├─ Background (Sprite2D)         ← swappé par signaux Dialogic
##     ├─ Characters (Node2D)           ← sprites posés par signaux
##     └─ DialogueLayer (CanvasLayer)   ← Dialogic ajoute son layout ici

const CHEMIN_ZONE_COMMUNE := "res://scenes/prologue/pro_zone_commune.tscn"

const BACKGROUNDS := {
	"bg_tramway_jour":     "res://assets/backgrounds/bg_tramway_jour.jpg",
	"bg_hall_tour":        "res://assets/backgrounds/bg_hall_tour.jpg",
	"bg_ascenseur":        "res://assets/backgrounds/bg_ascenseur.jpg",
	"bg_zone_commune_soir": "res://assets/backgrounds/bg_zone_commune_soir.jpg",
}

@onready var _background: Sprite2D = $Background


func _ready() -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic and dialogic.has_signal("signal_event"):
		dialogic.signal_event.connect(_on_dialogic_signal)
	if dialogic and dialogic.has_signal("timeline_ended"):
		dialogic.timeline_ended.connect(_on_timeline_ended)


# --- Signaux Dialogic ----------------------------------------------------

func _on_dialogic_signal(argument: Variant) -> void:
	var texte := ""
	if typeof(argument) == TYPE_STRING:
		texte = String(argument)
	elif typeof(argument) == TYPE_DICTIONARY:
		texte = String(argument.get("argument", ""))

	var morceaux := texte.split(":", false)
	if morceaux.is_empty():
		return

	match morceaux[0]:
		"bg":
			# bg:<id>
			if morceaux.size() >= 2:
				_changer_background(morceaux[1])
		"goto_scene":
			# goto_scene:<id> — pour l'instant un seul cas, zone commune
			if morceaux.size() >= 2 and morceaux[1] == "pro_zone_commune":
				get_tree().change_scene_to_file(CHEMIN_ZONE_COMMUNE)
		# Les autres signaux (relation, flag, decision, lieu, show_char...)
		# sont consommés par DialogicBridge pour les managers, ou ignorés
		# silencieusement ici (les show_char concernent Dialogic, pas notre
		# orchestrateur scénique).


func _on_timeline_ended() -> void:
	# Si la timeline se termine sans avoir émis goto_scene (par
	# exemple un test partiel), on reste sur la scène courante.
	pass


# --- Background swap -----------------------------------------------------

func _changer_background(id: String) -> void:
	if _background == null:
		return
	if not BACKGROUNDS.has(id):
		push_warning("[ProArrivee] Background inconnu : %s" % id)
		return
	var chemin: String = BACKGROUNDS[id]
	if not ResourceLoader.exists(chemin):
		# Asset pas encore livré → on garde la couleur uniforme
		# placeholder. Documenté dans MANUAL_VALIDATION.
		print("[ProArrivee] Asset manquant (placeholder) : %s" % chemin)
		return
	_background.texture = load(chemin)
