# Architecture 8-MINE

> Couche systèmes du jeu narratif 8-MINE (thriller cyberpunk,
> journaliste sous surveillance). Indépendante de Dialogic, testable
> en isolation.

## Vue domaine (DDD)

Six domaines distincts, chacun encapsulé dans un autoload :

| Domaine | Manager | Responsabilité |
|---|---|---|
| Temps narratif | `CountdownManager` | Compteurs déclenchant des conséquences (audit Marine, équipe Stratom…) |
| Relations PJ↔PNJ | `RelationManager` (étendu) | Valeur affective par PNJ, paliers |
| Réputation publique | `ReputationManager` | Standing par faction (Stratom, Marine, presse, etc.) |
| État psychique | `MirrorStatusManager` | Dette d'authenticité — déclenche le game over miroir |
| Surveillance | `SurveillanceManager` | Pression externe — déclenche le game over surveillance |
| Profil ex | `ExProfileManager` | Caractérisation de l'ex référencé (nom, genre, traits) |

Deux orchestrateurs :

| Rôle | Manager | Responsabilité |
|---|---|---|
| Game over | `GameOverHandler` | Reçoit un payload, anime via HUD, transitionne |
| HUD surveillance | `SurveillanceHUD` (scène autoloadée) | Rendu temps réel, overlay game over |

## Ordre d'autoload (project.godot)

```
1. SaveManager           ; existant
2. GameStateManager      ; existant
3. RelationManager       ; existant, étendu phase 3
4. LocationManager       ; existant
5. CountdownManager
6. ExProfileManager
7. SurveillanceManager
8. MirrorStatusManager
9. ReputationManager
10. SurveillanceHUD      ; CanvasLayer (autoload de scène)
11. GameOverHandler
12. DialogicBridge       ; existant (à laisser après le tout)
```

Justification de l'ordre :
- SaveManager n'a pas de dépendance, doit être prêt avant les autres
  pour qu'ils puissent enregistrer leur état au load.
- GameStateManager pareil, indépendant.
- ExProfileManager avant les managers qui consomment ses pronoms
  (MirrorStatusManager pour les phrases écho).
- GameOverHandler tout à la fin : il référence SurveillanceHUD au
  `_ready()` via auto-wire.

## Graphe de dépendances

```
SaveManager (registre)
   └── chacun appelle save_state() / load_state() sur la liste enregistrée

CountdownManager        (aucune dép)
ExProfileManager        (config/echo_phrases.gd)
ReputationManager       (aucune dép)
RelationManager         (ExProfileManager.get_display_name pour overlays)
SurveillanceManager     (CountdownManager — tick d'horloges quand pression monte)
                        (GameOverHandler — déclenche le game over)
MirrorStatusManager     (ExProfileManager — phrase écho)
                        (GameOverHandler — déclenche le game over miroir)
SurveillanceHUD         (consomme signaux des 5 managers, ne dépend pas de leur état interne)
GameOverHandler         (SurveillanceHUD — overlay)
                        (LocationManager — transition scène)
```

Aucune propagation automatique. Les managers émettent des signaux,
les écouteurs réagissent.

## Pattern Save/Load

Chaque manager sauvegardable implémente le trio :

```gdscript
func save_state() -> Dictionary
func load_state(data: Dictionary) -> void
func reset_all_for_new_game() -> void
```

SaveManager maintient une **liste explicite** (pas de découverte
dynamique) des managers enregistrés :

```gdscript
const MANAGERS_ENREGISTRES := [
    "RelationManager",
    "GameStateManager",
    "CountdownManager",
    "SurveillanceManager",
    "MirrorStatusManager",
    "ReputationManager",
    "ExProfileManager",
    "LocationManager",
]
```

Format JSON v2 :

```json
{
  "version": 2,
  "timestamp": 1716220800,
  "lieu": "chambre_max",
  "chapitre": "ch1",
  "relations": {...},
  "flags": {...},
  "decisions": [...],
  "surveillance": {...},
  "mirror": {...},
  "countdowns": {...},
  "reputation": {...},
  "ex_profile": {...}
}
```

Migration v1 → v2 : si `version <= 1` ou absent, les clés manquantes
sont chargées avec leur état par défaut (`reset_all_for_new_game()`
appelé en amont, puis chaque manager comble ce qu'il peut).

## Pattern Dependency Injection

**Autoload → autoload** : référence directe par nom global.

**Autoload → composant scène** (cas `SurveillanceHUD`) : référence
swappable via setter.

```gdscript
# GameOverHandler.gd
var _hud = null

func _ready() -> void:
    _hud = SurveillanceHUD  # auto-wire

func set_hud_interface(hud) -> void:
    _hud = hud  # swap en test
```

En tests, on injecte un `MockHud` qui émet immédiatement le signal
attendu pour ne pas bloquer.

## Signaux monotones (threshold_crossed)

Les managers à seuils (`Surveillance`, `Mirror`) émettent
`threshold_crossed(level: int)` **uniquement sur franchissement
montant**, et **une seule fois par seuil et par partie**.

Implémentation :

```gdscript
var _thresholds_already_crossed: Array[int] = []

func _check_threshold(ancien: int, nouveau: int) -> void:
    for seuil in THRESHOLDS:
        if seuil > ancien and seuil <= nouveau and not seuil in _thresholds_already_crossed:
            _thresholds_already_crossed.append(seuil)
            threshold_crossed.emit(seuil)
```

`_thresholds_already_crossed` est persisté dans `save_state()`.

## Game Over — payload générique

```gdscript
{
  "type": String,              # "surveillance", "mirror", "custom"
  "title": String,             # ex. "Surveillance Maximale"
  "overlay_quote": String,     # phrase écran d'animation
  "history": Array,            # événements à afficher dans l'écran final
  "history_formatter": Callable # facultatif, signature : (event: Dictionary) -> String
}
```

`trigger_game_over(payload)` est une **coroutine** (`await` interne
sur l'animation HUD). Tout appelant doit `await` ou utiliser
`call_deferred`.

## Conventions Godot critiques rappelées

- Référence autoload par nom = vérifié à la compilation (parse error
  si l'autoload n'existe pas).
- Pas de mot-clé `interface` en GDScript : on duplique l'API via
  `class_name MockXxx`.
- En tests, toute méthode contenant `await` doit être appelée avec
  `await` côté test, sinon les asserts voient un état intermédiaire.

## Frontière hors-scope

Aucune référence à Dialogic dans cette couche. Le pont
`DialogicBridge.gd` du Prompt 1 reste en place mais n'est pas
utilisé pour invoquer les nouveaux managers (un futur prompt 4c
ajoutera des Custom Events Dialogic).
