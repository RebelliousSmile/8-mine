extends GutTest
class_name TestEnvironment

# Helper de base pour les tests 8-MINE.
# Reset tous les managers avant chaque test. Les managers sont
# accédés par nom d'autoload — si un autoload n'est pas encore
# enregistré (phase 0 par exemple), on saute silencieusement
# son reset. À partir de la phase 2 tous les stubs existent et
# la méthode tape effectivement les 6 managers.


func before_each() -> void:
	_reset_all_managers()


func _reset_all_managers() -> void:
	# Liste explicite (volontairement pas de découverte dynamique)
	for nom in [
		"CountdownManager",
		"SurveillanceManager",
		"MirrorStatusManager",
		"ReputationManager",
		"ExProfileManager",
		"RelationManager",
	]:
		var node := get_node_or_null("/root/" + nom)
		if node and node.has_method("reset_all_for_new_game"):
			node.reset_all_for_new_game()
