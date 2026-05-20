extends Node2D
## Logique d'un lieu narratif.
##
## Une « location » contient :
##   - un Background (TextureRect plein écran)
##   - une CanvasLayer "Dialogue" où Dialogic affiche ses scènes
##   - un HUD montrant les relations des personnages présents
##   - une liste de Hotspots cliquables
##
## La scène template définit la structure et les noeuds. Les vrais
## lieux dupliquent cette scène et changent le background, le
## fichier .dtl à lancer et la liste des personnages présents.

@export_file("*.dtl") var timeline_entree: String = ""
@export var personnages_presents: Array[String] = []
@export var titre: String = ""

@onready var _hud: Control = $HUD


func _ready() -> void:
	if not titre.is_empty():
		print("[Location] Entrée : %s" % titre)

	# Le HUD a besoin de savoir qui afficher
	if _hud and _hud.has_method("definir_personnages"):
		_hud.definir_personnages(personnages_presents)

	# Bloque les hotspots quand un dialogue est en cours
	DialogicBridge.dialogue_demarre.connect(_on_dialogue_demarre)
	DialogicBridge.dialogue_termine.connect(_on_dialogue_termine)

	# Démarre le dialogue d'entrée si défini
	if not timeline_entree.is_empty():
		await get_tree().process_frame
		var dialogic := get_node_or_null("/root/Dialogic")
		if dialogic and dialogic.has_method("start"):
			dialogic.start(timeline_entree)


func _on_dialogue_demarre() -> void:
	_set_hotspots_actifs(false)


func _on_dialogue_termine() -> void:
	_set_hotspots_actifs(true)


func _set_hotspots_actifs(actif: bool) -> void:
	for h in get_tree().get_nodes_in_group("hotspot"):
		if h is CanvasItem:
			h.visible = actif
		if h.has_method("set_actif"):
			h.set_actif(actif)
