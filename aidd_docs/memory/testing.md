---
name: testing
description: Stratégie de tests 8-MINE (GUT 9.6.0)
scope: all
---

# Testing Guidelines

## Tools and Frameworks

- **GUT 9.6.0** (Godot Unit Testing) — installé sous `addons/gut/`
- Migration depuis GUT 9.3.0 lors du passage à Godot 4.6.2 (`Logger` devenu classe native Godot 4.6 → incompatible 9.3.x)

## Testing Strategy

- **Tests unitaires** par manager autoload (state mutation, save/load, seuils monotones).
- **Tests d'intégration** par flow : DialogicBridge → managers → signaux UI.
- **Pas de tests E2E automatisés** — validation point-and-click manuelle via `docs/MANUAL_VALIDATION.md`.

### Convention test file

```gdscript
extends "res://tests/helpers/test_environment.gd"
# before_each() reset automatique de tous les managers via reset_all_for_new_game()
# Les coroutines doivent être await
await GameOverHandler.trigger_game_over(payload)
assert_eq(GameStateManager.flag_X, true)
```

## Mocks et stubs

- `tests/mocks/` — mocks réutilisables
- `MockHud` — émet ses signaux via `call_deferred` (ne bloque pas les coroutines)
- Aucun mock pour Dialogic : si Dialogic absent, les managers warn et continuent (par design)

## Test Execution

### Windows

```bat
tests\run_tests.bat
```

### Linux / macOS

```bash
./tests/run_tests.sh
```

### Headless / CI

```bash
godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit
```

## Référence détaillée

- `docs/TESTING_GUIDE.md` — écriture de tests, patterns spécifiques, mocks
- `docs/MANUAL_VALIDATION.md` — checklist QA manuelle
