---
name: coding-assertions
description: Checklist qualité à valider après chaque génération de code GDScript
scope: all
---

# Coding Guidelines

> Ces règles sont minimales : elles **doivent** être vérifiées après chaque génération de code.

## Requirements to complete a feature

Une feature est complète **si et seulement si toutes les assertions ci-dessous sont vertes**. Sinon itérer jusqu'à résolution.

- Pas de référence inter-managers dans `_ready()`
- Si la méthode est publique : nom impératif français (`modifier()`, `aller_a()`)
- Si dépendance optionnelle : `get_node_or_null()` + log warn silencieux si absent
- Si nouvelle variable d'état : enregistrée dans `save_state()` / `load_state()` / `reset_all_for_new_game()` du manager concerné
- Si nouvelle clé save : registre `SaveManager` mis à jour
- Si coroutine `await` : tout appelant `await` ou `call_deferred()`
- Si nouveau seuil : monotone et persisté dans `_thresholds_already_crossed`
- Si timeline `.dtl` ajoutée : signaux Dialogic parsables par `DialogicBridge`

## Commands to run

### Before commit

| Order | Command | Description |
| ----- | ------- | ----------- |
| 1 | `godot --editor --path .` (compile-check) | Godot recompile tous les `.gd`, détecte erreurs de parse |
| 2 | `tests\run_tests.bat` (Windows) ou `./tests/run_tests.sh` | Tous les tests GUT doivent passer |
| 3 | Smoke manuel | Lancer le jeu, valider la scène impactée (F5/F9 si save touchée) |

### Before push

| Order | Command | Description |
| ----- | ------- | ----------- |
| 1 | `godot --headless --path . -s addons/gut/gut_cmdln.gd -gdir=res://tests -gexit` | Tests GUT en mode headless (CI-friendly) |
| 2 | Walkthrough manuel | Checklist `docs/MANUAL_VALIDATION.md` sur le scope touché |
| 3 | Vérification cross-doc | Si l'architecture change → mettre à jour `docs/ARCHITECTURE_8MINE.md` et `aidd_docs/memory/internal/architecture.md` |
