# Testing guide — 8-MINE

## Environnement de test

| Outil | Version | Source |
|---|---|---|
| Godot Engine | 4.6.x stable (.NET) | [godotengine.org/download](https://godotengine.org/download) |
| GUT (Godot Unit Test) | **9.6.0** | `addons/gut/`, voir `GUT_VERSION.txt` |
| OS de test | Linux x86_64 headless | CI ou local |

> Note : GUT 9.6.0 est compatible Godot 4.5+. Le projet a migré vers
> Godot 4.6.2 — `Logger` est devenu une classe native Godot 4.6,
> incompatible avec GUT 9.3.x. Documenté dans `GUT_VERSION.txt`.

## Lancer la suite

```bash
# Linux / macOS
./tests/run_tests.sh

# Windows
tests\run_tests.bat
```

Premier lancement : le script fait un scan éditeur headless pour
reconstruire le cache `class_name` (sinon `GutUtils` n'est pas
résolu en CLI). Les lancements suivants utilisent le cache.

Pour forcer un re-scan : `rm -rf .godot && ./tests/run_tests.sh`.

## Pattern TestEnvironment

Tous les fichiers de tests héritent de
`tests/helpers/test_environment.gd` :

```gdscript
extends "res://tests/helpers/test_environment.gd"

func test_quelquechose() -> void:
    # before_each() a déjà reset tous les managers
    RelationManager.modifier("sara", 25, "test")
    assert_eq(RelationManager.get_niveau("sara"), "sympathie")
```

`before_each()` parcourt la liste des autoloads 8-MINE et appelle
`reset_all_for_new_game()` sur chacun qui implémente la méthode.
Avant la phase 2, certains managers manquent — le helper utilise
`get_node_or_null` et saute silencieusement.

## Pattern Mock (pas d'`interface` en GDScript)

Quand un manager dépend d'un composant scène (SurveillanceHUD), on
crée une classe miroir dans `tests/mocks/` :

```gdscript
# tests/mocks/mock_hud.gd
extends Node
class_name MockHud

signal game_over_overlay_finished
var last_quote : String = ""

func show_game_over_overlay(quote: String) -> void:
    last_quote = quote
    call_deferred("emit_signal", "game_over_overlay_finished")
```

Et dans le test :

```gdscript
func test_trigger_game_over_calls_hud() -> void:
    var mock = MockHud.new()
    add_child_autofree(mock)
    GameOverHandler.set_hud_interface(mock)
    await GameOverHandler.trigger_game_over({
        "type": "test",
        "title": "Test",
        "overlay_quote": "expected quote",
        "history": [],
    })
    assert_eq(mock.last_quote, "expected quote")
```

## Coroutines (méthodes avec `await`)

**Règle d'or** : si une méthode publique contient un `await`, tout
test qui l'appelle doit **lui-même** être `await`-é. Sinon les
asserts qui suivent voient un état intermédiaire (race condition).

Méthodes coroutines en phase 4a :

- `GameOverHandler.trigger_game_over()`
- `LocationManager.aller_a()`
- `LocationManager.aller_a_scene()`

Documenté aussi dans `API_PUBLIQUE.md`.

## Stubs phase 2 (TDD red)

À la phase 2, on crée 7 stubs minimaux pour que les tests
**compilent** sans implémentation :

```
scripts/managers/CountdownManager.gd       (stub)
scripts/managers/SurveillanceManager.gd    (stub)
scripts/managers/MirrorStatusManager.gd    (stub)
scripts/managers/ReputationManager.gd      (stub)
scripts/managers/ExProfileManager.gd       (stub)
scripts/managers/GameOverHandler.gd        (stub)
scripts/ui/SurveillanceHUD.gd              (stub)
```

Chaque stub :

- `extends Node` (sauf `SurveillanceHUD` qui extends `CanvasLayer`)
- Déclare tous les signaux publics
- Déclare toutes les méthodes publiques avec corps `pass` ou retour
  par défaut
- Aucune logique métier

Conséquence attendue à la fin de la phase 2 :
`./tests/run_tests.sh` compile, lance, mais tous les tests
d'implémentation échouent. Seul `test_smoke` passe.

## Stratégie par composant

### Testable GUT
CountdownManager, SurveillanceManager, MirrorStatusManager,
ReputationManager, ExProfileManager, RelationManager (étendu),
SaveManager (étendu, migration v1 → v2), GameOverHandler (avec
MockHud).

### Validation manuelle (voir `MANUAL_VALIDATION.md`)
SurveillanceHUD (rendu, pulses, toggle Shift+F1), GameOverScreen
(affichage, scroll historique), SystemsDebugScene (intégration
bout-en-bout).

### Logique HUD isolée
- `SurveillanceHUD.gd` : rendu, animations (manuel)
- `SurveillanceHUDLogic.gd` : calcul d'état (combien de dots
  visibles, ligne active) — **testable unitairement** via
  instanciation directe sans tree.

## Convention de nommage des tests

```
tests/
├── helpers/
│   └── test_environment.gd
├── mocks/
│   └── mock_hud.gd
├── test_smoke.gd
├── test_countdown_manager.gd
├── test_surveillance_manager.gd
├── test_mirror_status_manager.gd
├── test_reputation_manager.gd
├── test_ex_profile_manager.gd
├── test_relation_manager_extended.gd
├── test_relation_8mine_residents.gd
├── test_save_manager_v2.gd
├── test_game_over_handler.gd
├── test_surveillance_hud_logic.gd
├── test_surveillance_zones.gd
├── test_hotspot_world.gd
├── test_npc_world.gd
├── test_character_registry.gd
├── test_game_state_8mine.gd
└── test_pro_arrivee_init.gd
```

Une méthode = un comportement. Nom au format
`test_<sujet>_<comportement>`.

## Critères de succès

- `./tests/run_tests.sh` retourne **0 fail, 0 pending, 0 errors**.
- Aucun test commenté ou skipped sans justification explicite
  (comment ou doc).
- Couverture API publique = 100 % des méthodes documentées dans
  `API_PUBLIQUE.md` ont au moins un test direct.

## Dépannage

| Symptôme | Cause probable | Remède |
|---|---|---|
| `GutUtils not declared` | cache class_name absent | `rm -rf .godot && ./tests/run_tests.sh` |
| Tests timeout (>60 s) | coroutine non awaitée | vérifier que les tests sur méthodes coroutines sont `await`-és |
| `Logger class already declared` | GUT 9.3.x avec Godot 4.6 (Logger est natif 4.6) | mettre à jour GUT vers 9.6.0 |
| Parse error sur autoload | stub absent ou non enregistré | vérifier ordre `[autoload]` dans `project.godot` |
