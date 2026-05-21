extends Node
## Gestionnaire des transitions entre lieux.
##
## Charge une scène cible avec fondu noir, met à jour l'historique
## de navigation et déclenche les signaux que le HUD/dialogue
## peuvent écouter pour réagir au changement de contexte.
##
## Conventions :
##   - L'identifiant d'un lieu est sa clé courte (« chambre_max »).
##   - Le chemin de scène est résolu via une table déclarative ci-dessous,
##     ou directement avec un res:// chemin si on ne veut pas la table.

signal lieu_quitté(ancien: String)
signal lieu_atteint(nouveau: String)
signal transition_en_cours(progres: float)   ## 0.0 → 1.0

## Table des lieux connus. À étendre au fur et à mesure.
## Le projet d'exemple ne fournit que le template ; les vrais lieux
## hériteront de Location_Template.tscn.
const LIEUX := {
	"template": "res://scenes/locations/Location_Template.tscn",
}

const DUREE_FONDU := 0.4

var _lieu_actuel: String = ""
var _historique: Array[String] = []
var _couche_fondu: CanvasLayer
var _rect_fondu: ColorRect


func _ready() -> void:
	_creer_couche_fondu()


# --- API publique ----------------------------------------------------------

## Transitionne vers un lieu connu de la table LIEUX.
func aller_a(id_lieu: String) -> void:
	if not LIEUX.has(id_lieu):
		push_warning("Lieu inconnu : %s" % id_lieu)
		return
	_transitioner_vers(id_lieu, LIEUX[id_lieu])


## Variante : transitionne vers un chemin de scène arbitraire.
## `id_lieu` reste libre pour identification dans l'historique.
func aller_a_scene(id_lieu: String, chemin_scene: String) -> void:
	_transitioner_vers(id_lieu, chemin_scene)


func get_lieu_actuel() -> String:
	return _lieu_actuel


func get_historique() -> Array[String]:
	return _historique.duplicate()


## Revient au lieu précédent dans l'historique, si possible.
func retour_arriere() -> bool:
	if _historique.size() < 2:
		return false
	_historique.pop_back()         # On retire le lieu courant
	var precedent: String = _historique.pop_back()
	aller_a(precedent)
	return true


# --- Sérialisation ---------------------------------------------------------

func collecter_etat() -> Dictionary:
	return {
		"lieu_actuel": _lieu_actuel,
		"historique": _historique.duplicate(),
	}


func appliquer_etat(etat: Dictionary) -> void:
	var lieu_a_restaurer: String = etat.get("lieu_actuel", "")
	_historique = []
	for h in etat.get("historique", []):
		_historique.append(String(h))
	if lieu_a_restaurer != "":
		# On va à la scène sans rejouer toute la pile d'historique.
		var chemin: String = LIEUX.get(lieu_a_restaurer, "")
		if chemin != "":
			_transitioner_vers(lieu_a_restaurer, chemin)


# --- Interne ---------------------------------------------------------------

func _transitioner_vers(id_lieu: String, chemin_scene: String) -> void:
	var ancien := _lieu_actuel
	lieu_quitté.emit(ancien)

	await _fondu(0.0, 1.0)

	var err := get_tree().change_scene_to_file(chemin_scene)
	if err != OK:
		push_error("Échec du changement de scène vers %s (err=%d)" % [chemin_scene, err])
		await _fondu(1.0, 0.0)
		return

	_lieu_actuel = id_lieu
	_historique.append(id_lieu)
	lieu_atteint.emit(id_lieu)

	# Petite pause pour laisser la scène finir son _ready avant le fondu retour
	await get_tree().process_frame
	await _fondu(1.0, 0.0)


func _creer_couche_fondu() -> void:
	_couche_fondu = CanvasLayer.new()
	_couche_fondu.layer = 100   # Tout au-dessus
	add_child(_couche_fondu)

	_rect_fondu = ColorRect.new()
	_rect_fondu.color = Color(0, 0, 0, 0)
	_rect_fondu.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect_fondu.set_anchors_preset(Control.PRESET_FULL_RECT)
	_couche_fondu.add_child(_rect_fondu)


func _fondu(de: float, vers: float) -> void:
	var tween := create_tween()
	tween.tween_method(
		func(a: float):
			_rect_fondu.color = Color(0, 0, 0, a)
			transition_en_cours.emit(a),
		de,
		vers,
		DUREE_FONDU,
	)
	await tween.finished
