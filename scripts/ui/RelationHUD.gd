extends Control
## HUD discret affichant le niveau de relation des personnages présents.
##
## Pour chaque personnage, on affiche son nom + son niveau textuel
## (« neutre », « confiance », ...). Une animation brève signale
## un changement de palier.

const COULEUR_PAR_NIVEAU := {
	"ennemi":     Color(0.85, 0.20, 0.25),
	"hostilité":  Color(0.90, 0.40, 0.30),
	"méfiance":   Color(0.85, 0.60, 0.30),
	"froid":      Color(0.70, 0.70, 0.75),
	"neutre":     Color(0.85, 0.85, 0.85),
	"sympathie":  Color(0.65, 0.85, 0.65),
	"confiance":  Color(0.45, 0.80, 0.55),
	"amitié":     Color(0.40, 0.75, 0.95),
	"intime":     Color(0.85, 0.55, 0.95),
}

@onready var _liste: VBoxContainer = $Panel/Marge/Liste

var _lignes: Dictionary = {}    ## { "alex": Label, ... }


func _ready() -> void:
	RelationManager.relation_changed.connect(_on_relation_changed)
	RelationManager.palier_change.connect(_on_palier_change)


## Appelé par Location.gd au _ready avec la liste des personnages présents.
func definir_personnages(personnages: Array) -> void:
	for enfant in _liste.get_children():
		enfant.queue_free()
	_lignes.clear()

	for nom in personnages:
		var label := Label.new()
		label.name = nom
		_liste.add_child(label)
		_lignes[nom] = label
		_rafraichir_ligne(nom)


func _rafraichir_ligne(personnage: String) -> void:
	if not _lignes.has(personnage):
		return
	var label: Label = _lignes[personnage]
	var niveau := RelationManager.get_niveau(personnage)
	label.text = "  %s — %s" % [personnage.capitalize(), niveau]
	label.modulate = COULEUR_PAR_NIVEAU.get(niveau, Color.WHITE)


func _on_relation_changed(personnage: String, _ancienne: int, _nouvelle: int, _raison: String) -> void:
	if _lignes.has(personnage):
		_rafraichir_ligne(personnage)


func _on_palier_change(personnage: String, _ancien: String, nouveau: String) -> void:
	if not _lignes.has(personnage):
		return
	# Petit flash visuel sur changement de palier
	var label: Label = _lignes[personnage]
	var tween := create_tween()
	tween.tween_property(label, "modulate:a", 0.2, 0.1)
	tween.tween_property(label, "modulate:a", 1.0, 0.3)
	print("[RelationHUD] %s passe au palier '%s'" % [personnage, nouveau])
