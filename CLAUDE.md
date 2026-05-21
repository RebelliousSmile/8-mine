# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Présentation du projet

**8-MINE** est un jeu narratif cyberpunk (Godot 4.4.1 .NET, tout en GDScript) avec deux modes de jeu :
- **Roman visuel** : dialogues Dialogic 2 avec des choix à conséquences
- **Point-and-click** : exploration de lieux avec hotspots, PNJ et caméras de surveillance

La protagoniste Margot, journaliste, enquête sur Stratom Corp. Le jeu suit ses relations avec 17 PNJ, sa pression de surveillance externe [0-100] et sa dette d'authenticité psychologique (Mirror) [0-100].

## Commandes principales

```bash
# Ouvrir dans l'éditeur Godot
godot --editor --path .

# Lancer les tests GUT
tests\run_tests.bat          # Windows
./tests/run_tests.sh         # Linux/macOS

# Raccourcis in-game
F5          # Quick save (slot 0)
F9          # Quick load (slot 0)
Shift+F1    # Basculer SurveillanceHUD
```

Les tests utilisent GUT **9.6.0** (mis à jour depuis 9.3.0 lors du passage à Godot 4.6.2 — `Logger` est devenu une classe native Godot 4.6, incompatible avec GUT 9.3.x).

## Architecture des systèmes

### 14 Autoloads (ordre strict)

L'ordre dans `project.godot [autoload]` est critique. Référence canonique : `docs/ARCHITECTURE_8MINE.md`.

| Ordre | Autoload | Responsabilité |
|---|---|---|
| 1 | `Config` | `DEBUG_MODE` flag |
| 2 | `SaveManager` | 3 slots JSON (v2), migration v1→v2 |
| 3 | `GameStateManager` | Flags globaux, log de décisions, `personal_danger`, `mental_stability` |
| 4 | `RelationManager` | Affection PNJ [-100,+100], 9 paliers, 17 PNJ |
| 5 | `CharacterRegistry` | Nom du PJ, renames PNJ, PNJ secondaires |
| 6 | `LocationManager` | Transitions avec fondu (0.4s), historique de lieux |
| 7 | `CountdownManager` | Timers narratifs (`audit_marine` max 15, `equipe_nettoyage` max 14) |
| 8 | `ExProfileManager` | Caractérisation de l'ex (nom, genre, traits) — **immutable après premier appel** |
| 9 | `SurveillanceManager` | Pression externe [0-100], seuils automatiques |
| 10 | `MirrorStatusManager` | Dette psychologique [0-100], game over miroir |
| 11 | `ReputationManager` | Standing par faction [-100,+100] (8 factions : stratom, marine, presse, police, activistes, memorize, nexus, kaizen) |
| 12 | `SurveillanceHUD` | CanvasLayer overlay (layer 50), affichage temps réel |
| 13 | `GameOverHandler` | Coroutine : HUD animation → transition scène |
| 14 | `DialogicBridge` | Dialogic events → appels managers |

### Pattern Save/Load

Chaque manager implémente `save_state()`, `load_state(data)`, `reset_all_for_new_game()`. `SaveManager` maintient un registre **explicite** (pas d'auto-discovery) de 9 managers. Format JSON v2 dans `user://saves/save_N.json`.

### Seuils à franchissement unique (monotone)

`SurveillanceManager` et `MirrorStatusManager` émettent `threshold_crossed(level)` **une seule fois par partie, uniquement vers le haut**. Implémenté via `_thresholds_already_crossed: Array[int]` persisté en save.

**Seuils Surveillance :** 25 (HUD visible), 50 (alerte), 75 (cinematic + auto-tick nettoyage), 90 (palier avancé, sans couplage hardcodé), 100 (game over)  
**Seuils Mirror :** 30 (flashback), 60 (hésitation), 90 (option verrouillée), 100 (game over)

### Coroutine critique

`GameOverHandler.trigger_game_over(payload)` est **async**. Tout appelant doit `await` ou utiliser `call_deferred()`.

### Résolution de timeline PNJ (point-and-click)

Quatre niveaux de fallback : flag override → palier spécifique → `<npc_id>_allie/neutre/tension` → défaut. Si aucune timeline n'existe, Dialogic warn silencieusement.

## Conventions de code

- **Tout en français** : noms de variables, méthodes publiques, commentaires, labels UI — sauf les hooks Godot (`_ready`, `_input`, `_physics_process`)
- **Méthodes impératives** : `modifier()`, `aller_a()`, `sauvegarder()` (pas `update_relation`, `go_to`, `save`)
- **Signaux > polling** : les UI n'ont jamais de copie locale d'état — elles écoutent les signaux des managers
- `get_node_or_null()` pour les dépendances optionnelles (dégradation gracieuse si plugin absent)
- Pas de références inter-managers directes dans `_ready()` — utiliser le nom global de l'autoload ou le setter d'injection

## Tests

```gdscript
# Tous les tests héritent de test_environment.gd
extends "res://tests/helpers/test_environment.gd"

# before_each() reset automatique de tous les managers
# Les coroutines doivent être await dans les tests
await GameOverHandler.trigger_game_over(payload)
assert_eq(...)
```

Les mocks se trouvent dans `tests/mocks/`. Le `MockHud` émet ses signaux via `call_deferred` pour ne pas bloquer les coroutines.

## Points critiques à ne pas oublier

1. **Hotspot visibility** : utilise les flags de `GameStateManager`. Si `required_flag` est faux, le bouton ET la zone de collision sont désactivés (`monitoring = false`). Réactivation automatique sur changement de flag via signal.

2. **PNJ secondaires** : existent uniquement dans `CharacterRegistry`. Pas de relation, pas de réputation. Pour les personnages cités mais non interactifs.

3. **Margot ne pathfinde pas** : mouvement en ligne droite. Les scènes NavigableRoom doivent être à géométrie ouverte.

4. **Dialogic non installé** : `GameOverHandler` et `DialogicBridge` warn mais ne crashent pas. Les hotspots de type DIALOGUE n'ont simplement aucun effet.

5. **Maaack supprimé** : le dossier `addons/maaacks_game_template/` a été retiré — Godot parse tous les `.gd` du projet même pour les plugins désactivés, ce qui causait des erreurs. Le jeu démarre directement sur `Main.tscn`.

6. **`ExProfileManager` immutable** : tous les setters (`set_ex_name`, `set_ex_gender`, `add_trait`) ne fonctionnent qu'au premier appel. Prévu par design (engagement du joueur).

## Documentation de référence

| Sujet | Fichier |
|---|---|
| Dépendances entre autoloads | `docs/ARCHITECTURE_8MINE.md` |
| Toutes les signatures publiques | `docs/API_PUBLIQUE.md` |
| Équilibre et chiffres de design | `docs/MECANIQUES_8MINE.md` |
| Système point-and-click | `docs/POINT_AND_CLICK.md` |
| Écriture de tests GUT | `docs/TESTING_GUIDE.md` |
| Events Dialogic custom | `docs/API_DIALOGIC.md` |
| Checklist QA manuelle | `docs/MANUAL_VALIDATION.md` |

## Règles de design canoniques (à charger en mémoire active)

Ces fichiers contiennent des règles d'écriture qui conditionnent **toute production narrative** (arcs, dialogues, fiches PNJ, reviews). À lire au démarrage de toute session d'écriture/audit canon. Référencés dans `aidd_docs/aiw/8mine/bank.yml § design_rules`.

| Règle | Fichier |
|---|---|
| Sofia Kessler — caractérisation (trans intégrée · vigilante éthique paradoxale · couple Sofia/Alex) | `aidd_docs/memory/internal/design-rules/sofia-kessler-caracterisation.md` |
| Margot terrain neutre — défaut sans choix joueur = manipulation PNJ. Mirror = instrumentalisation subie | `aidd_docs/memory/internal/design-rules/margot-terrain-neutre.md` |
| Margot documentariste sincère — registre sociologique, double instrumentalisation corpos (N2) × Witness (scoop) | `aidd_docs/memory/internal/design-rules/margot-documentariste-sincere.md` |
| Corpos — job ordinaire, pas missions secrètes. Agents importants, fragilité quotidienne ≠ subalterne | `aidd_docs/memory/internal/design-rules/corpos-job-ordinaire.md` |

## Tracking interne Claude (état + structure technique)

| Sujet | Fichier |
|---|---|
| État de production (tâches prioritaires, scènes, assets, log playtests) | `aidd_docs/memory/internal/etat-prod.md` |
| Architecture canon (14 autoloads, conventions de fichiers, variables) | `aidd_docs/memory/internal/architecture.md` |
| API DialogicBridge (10 dispatchers, exemples) | `aidd_docs/memory/internal/api-cheatsheet.md` |
| Registre des variables/flags | `aidd_docs/memory/internal/variables-register.md` |
| Snapshot code Godot | `aidd_docs/memory/internal/code-state.md` |
