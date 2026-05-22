# Prompt 4a — Fondations 8-MINE

## Vue d'ensemble

Cette branche ajoute la couche systèmes du jeu 8-MINE par-dessus
les fondations du Prompt 1 (Save/State/Relation/Location managers,
Maaack template, Dialogic bridge).

Aucun appel runtime à Dialogic. Tous les managers sont testables
en isolation (GUT) et combinables manuellement via
`SystemsDebugScene`.

## Documents

| Document | Pour qui ? |
|---|---|
| [`ARCHITECTURE_8MINE.md`](ARCHITECTURE_8MINE.md) | Architectes, intégrateurs |
| [`API_PUBLIQUE.md`](API_PUBLIQUE.md) | Tout dev qui écrit du gameplay |
| [`API_DIALOGIC.md`](API_DIALOGIC.md) | Scénariste / dev Dialogic (Prompt 4c) |
| [`MECANIQUES_8MINE.md`](MECANIQUES_8MINE.md) | Game designer |
| [`TESTING_GUIDE.md`](TESTING_GUIDE.md) | Quiconque lance la suite GUT |
| [`MANUAL_VALIDATION.md`](MANUAL_VALIDATION.md) | QA / dev avant release |

## Phases produites

| Phase | Contenu | Commit |
|---|---|---|
| 0 | GUT 9.3.0 cloné + plugin off + CLI + smoke test vert | `[4a] phase 0 - GUT setup` |
| 1 | 7 docs (cette page incluse) | `[4a] phase 1 - docs` |
| 2 | 7 stubs autoloads + 10 fichiers tests rouges | `[4a] phase 2 - tests + stubs (failing)` |
| 3 | Implémentations dans l'ordre de dépendances → tests verts | `[4a] phase 3 - tests passing` |
| 4 | SystemsDebugScene + validation manuelle remplie | `[4a] phase 4 - validated` |

## Critère de réussite global

1. `./tests/run_tests.sh` → **100 % green, 0 skipped**
2. `MANUAL_VALIDATION.md` → 30 / 30 cases cochées (ou justifiées
   N/A)
3. Aucune régression visible sur les autoloads Prompt 1
   (`SaveManager`, `GameStateManager`, `RelationManager`,
   `LocationManager`)

## Risques résiduels acceptés

1. **GUT migré vers 9.6.0** : migration effectuée lors du passage à
   Godot 4.6.2 (`Logger` est natif en 4.6, incompatible avec 9.3.x).
2. **Maaack ↔ SaveManager.new_game()** : à câbler dans un prompt
   ultérieur (le menu Maaack doit appeler `SaveManager.new_game()`
   sur clic « Nouvelle partie »).
3. **Migration v2 → v3 future** : prévue, non bloquante. Bumper
   `VERSION_FORMAT` + écrire `migrer_v2_vers_v3`.
4. **Async/await contagion** : `trigger_game_over` est coroutine.
   Toute scène qui l'invoque doit être coroutine-aware (`await`
   ou `call_deferred`).
5. **SurveillanceHUDLogic non-autoload** : helper instancié par
   `SurveillanceHUD._ready()`. Testable directement par
   instanciation hors arbre.

## Hors-scope 4a (notés pour la dette)

- Custom Events Dialogic appelant les nouveaux managers (Prompt 4c)
- Scènes de gameplay réelles utilisant les systèmes (Prompts 5+)
- Tutoriel onboarding pour le panneau Ex Profile (4c)
- Localisation EN / autres
