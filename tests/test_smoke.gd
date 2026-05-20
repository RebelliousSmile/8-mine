extends "res://tests/helpers/test_environment.gd"

# Smoke test phase 0 : valide que GUT tourne et que les autoloads
# du Prompt 1 sont accessibles. Les nouveaux autoloads 8-MINE ne
# sont pas encore enregistrés à ce stade, c'est attendu.


func test_gut_works() -> void:
	assert_eq(1 + 1, 2)


func test_existing_autoloads_accessible() -> void:
	assert_not_null(SaveManager, "SaveManager autoload manquant")
	assert_not_null(GameStateManager, "GameStateManager autoload manquant")
	assert_not_null(RelationManager, "RelationManager autoload manquant")
	assert_not_null(LocationManager, "LocationManager autoload manquant")
