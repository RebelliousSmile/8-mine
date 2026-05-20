extends Node
## Scène d'entrée du jeu.
## Délègue immédiatement au LocationManager pour charger le premier lieu.
##
## Quand vous brancherez Maaack's Game Template, le menu principal
## appellera ce script (ou directement LocationManager.aller_a(...))
## après que le joueur a cliqué « Nouvelle partie ».

@export var lieu_de_depart: String = "template"


func _ready() -> void:
	# Laisse une frame pour que tous les autoloads finissent leur _ready.
	await get_tree().process_frame
	LocationManager.aller_a(lieu_de_depart)
