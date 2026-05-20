# API publique des managers 8-MINE

> Signatures uniquement. Sémantique détaillée dans
> [`MECANIQUES_8MINE.md`](MECANIQUES_8MINE.md). Méthodes avec `[await]`
> sont des **coroutines** : tout appelant doit utiliser `await`.

---

## CountdownManager

Compteurs nominaux à valeur croissante. Identifiés par chaîne.

### Constantes

```gdscript
const CANON_COUNTDOWNS := {
    "audit_marine":     { "max": 15, "description": "Audit Marine par Kaizen" },
    "equipe_nettoyage": { "max": 14, "description": "Équipe Nettoyage Stratom" },
}
```

### Signaux

- `countdown_advanced(id: String, current: int, max: int, reason: String)`
- `countdown_completed(id: String)`
- `threshold_crossed(id: String, threshold: int)` (montant seul, monotone)

### Méthodes

| Méthode | Effet |
|---|---|
| `create_countdown(id, max, description)` | assert id unique |
| `tick(id, amount = 1)` | assert amount > 0, assert id existe |
| `untick(id, amount = 1)` | décrémente, clamp à 0 |
| `pause(id)` / `resume(id)` | tick sans effet quand pause |
| `get_current(id) -> int` | 0 si inconnu |
| `get_remaining(id) -> int` | max - current |
| `is_completed(id) -> bool` | current >= max |
| `reset(id)` | current = 0, active = true |
| `save_state() -> Dictionary` | |
| `load_state(data: Dictionary)` | |
| `reset_all_for_new_game()` | vide + recrée CANON_COUNTDOWNS |

---

## ExProfileManager

Caractérisation de l'ex référencé dans le récit. Tous les overrides
sont **immuables après le premier set** (le joueur s'engage).

### Constantes

```gdscript
const VALID_TRAITS := [
    "manipulateur", "absent", "violent_verbal", "envahissant",
    "infidele", "controlant", "froid", "instable", "menteur",
    "sain"  # cas où la relation s'est bien finie
]

const VALID_GENDERS := ["masculin", "feminin", "non_binaire", "unspecified"]

const PRONOUNS := {
    "masculin":    { "subject": "il",      "object": "le",     "possessive": "son",    "stress": "lui" },
    "feminin":     { "subject": "elle",    "object": "la",     "possessive": "sa",     "stress": "elle" },
    "non_binaire": { "subject": "iel",     "object": "le/la",  "possessive": "ses",    "stress": "iel" },
    "unspecified": { "subject": "il/elle", "object": "le/la",  "possessive": "son/sa", "stress": "lui/elle" },
}
```

### État interne (lecture publique)

| Champ | Type | Défaut |
|---|---|---|
| `ex_name` | String | `"Julien"` |
| `is_name_overridden` | bool | `false` |
| `ex_gender` | String | `"masculin"` |
| `is_gender_overridden` | bool | `false` |
| `ex_traits` | Dictionary[String, bool] | `{}` |
| `relationship_duration_months` | int | `0` |
| `relationship_ended_months_ago` | int | `0` |
| `relationship_end_circumstance` | String | `""` |

### Signaux

- `ex_name_set(new_name: String)`
- `ex_gender_set(new_gender: String)`
- `trait_added(trait_id: String)`

### Méthodes

| Méthode | Retour | Notes |
|---|---|---|
| `set_ex_name(name)` | bool | false si déjà override |
| `set_ex_gender(gender)` | bool | false si déjà override, assert ∈ VALID_GENDERS |
| `get_display_name()` | String | renvoie `ex_name` |
| `get_pronouns()` | Dictionary | `PRONOUNS[ex_gender]` |
| `add_trait(trait_id)` | void | assert ∈ VALID_TRAITS |
| `has_trait(trait_id)` | bool | |
| `set_duration(months)` | void | |
| `set_ended(months_ago)` | void | |
| `set_end_circumstance(text)` | void | |
| `is_defined()` | bool | true si **au moins un** parmi : name override, gender override, ex_traits non vide |
| `get_echo_phrase()` | String | phrase narrative selon `is_defined()` |
| `save_state()` / `load_state()` / `reset_all_for_new_game()` | | |

---

## ReputationManager

Réputation publique par faction. Valeur clampée `[-100, +100]`.

### Constantes

```gdscript
const FACTION_DEFINITIONS := {
    "stratom":  { "label": "Stratom Corp",          "init": 0 },
    "marine":   { "label": "Marine Nationale",      "init": 0 },
    "presse":   { "label": "Presse indépendante",   "init": 10 },
    "police":   { "label": "Police judiciaire",     "init": 0 },
    "activistes": { "label": "Cellule activiste",   "init": 5 },
}

const SEUILS := [
    [-100, "ennemi_jure"],
    [-85,  "hostile"],
    [-50,  "mefiant"],
    [-20,  "indifferent"],
    [5,    "favorable"],
    [25,   "allie"],
    [60,   "champion"],
]
```

### Signaux

- `reputation_changed(faction: String, ancienne: int, nouvelle: int, raison: String)`
- `palier_change(faction: String, ancien: String, nouveau: String)`

### Méthodes

| Méthode | |
|---|---|
| `modifier(faction, delta, raison)` | clamp, émet signaux |
| `definir(faction, valeur)` | force, calcule delta |
| `get_valeur(faction) -> int` | |
| `get_niveau(faction) -> String` | |
| `au_moins(faction, niveau_min) -> bool` | |
| `save_state()` / `load_state()` / `reset_all_for_new_game()` | |

---

## RelationManager (étendu)

API existante du Prompt 1 conservée. Ajouts :

### Constantes

```gdscript
const NPC_DEFINITIONS := {
    "sara":   { "label": "Sara",   "faction": "presse",     "init": 0 },
    "kaizen": { "label": "Kaizen", "faction": "marine",     "init": -10 },
    "lior":   { "label": "Lior",   "faction": "activistes", "init": 5 },
    "marl":   { "label": "Marl",   "faction": "stratom",    "init": 0 },
    "tess":   { "label": "Tess",   "faction": "police",     "init": 0 },
    "viktor": { "label": "Viktor", "faction": "stratom",    "init": -20 },
    "mira":   { "label": "Mira",   "faction": "presse",     "init": 15 },
    "aslan":  { "label": "Aslan",  "faction": "activistes", "init": 0 },
    "nadia":  { "label": "Nadia",  "faction": "marine",     "init": 0 },
}
```

### Méthodes ajoutées

| Méthode | |
|---|---|
| `save_state() -> Dictionary` | wrap `collecter_etat()` |
| `load_state(data)` | wrap `appliquer_etat()` |
| `reset_all_for_new_game()` | repose toutes les valeurs init des NPC_DEFINITIONS |
| `get_label(personnage) -> String` | label affichage |

L'API française historique (`modifier`, `get_niveau`...) reste
publique.

---

## SurveillanceManager

Niveau de surveillance externe. Valeur `[0, 100]`. À 100 →
game over surveillance.

### Constantes

```gdscript
const THRESHOLDS := [25, 50, 75, 90]
const MAX := 100
```

### Signaux

- `surveillance_changed(ancien: int, nouveau: int, raison: String)`
- `threshold_crossed(niveau: int)` (monotone)
- `surveillance_max_atteint`

### Méthodes

| Méthode | |
|---|---|
| `increase(amount, raison)` | clamp, tick countdowns liés |
| `decrease(amount, raison)` | clamp |
| `get_level() -> int` | |
| `save_state()` / `load_state()` / `reset_all_for_new_game()` | |

---

## MirrorStatusManager

Dette d'authenticité. Valeur `[0, 100]`. À 100 → game over miroir
(dialogue d'effondrement où l'ex est cité).

### Constantes

```gdscript
const THRESHOLDS := [30, 60, 90]
const MAX := 100
```

### Signaux

- `mirror_status_changed(ancien: int, nouveau: int, raison: String)`
- `threshold_crossed(niveau: int)`
- `breakdown_imminent`

### Méthodes

| Méthode | |
|---|---|
| `increase(amount, raison)` | |
| `decrease(amount, raison)` | |
| `get_status() -> int` | |
| `get_overlay_quote() -> String` | consomme `ExProfileManager.get_echo_phrase()` |
| `save_state()` / `load_state()` / `reset_all_for_new_game()` | |

---

## GameOverHandler

### État

- `current_game_over_payload : Dictionary` (lecture publique)

### Méthodes

| Méthode | Notes |
|---|---|
| `set_hud_interface(hud)` | swap pour tests |
| `trigger_game_over(payload)` | **[await]** valide payload, anime HUD, transitionne |

### Validation payload

Champs requis : `type`, `title`, `overlay_quote`, `history`.
Champ optionnel : `history_formatter` (Callable).

---

## SurveillanceHUD

Scène autoload (CanvasLayer, layer=50). API publique pour
`GameOverHandler` et tests :

### Signaux

- `game_over_overlay_finished`

### Méthodes

| Méthode | Notes |
|---|---|
| `set_visible_for_cinematic(visible: bool)` | masquage temporaire |
| `show_game_over_overlay(quote: String)` | démarre animation, émet `game_over_overlay_finished` à la fin |
| `toggle_visible()` | bindé sur Shift+F1 |

---

## SaveManager (étendu v2)

API du Prompt 1 conservée. Ajouts :

### Constantes

```gdscript
const VERSION_FORMAT := 2
const MANAGERS_ENREGISTRES := [...]
```

### Méthodes ajoutées

| Méthode | |
|---|---|
| `new_game()` | appelle `reset_all_for_new_game()` sur tous les managers enregistrés |
| `migrer_v1_vers_v2(data) -> Dictionary` | helper interne exposé pour test |

---

## Résumé des coroutines

| Méthode | Pourquoi |
|---|---|
| `GameOverHandler.trigger_game_over(...)` | await sur `game_over_overlay_finished` puis transition de scène |
| `LocationManager.aller_a(...)` | déjà coroutine (await fondu) |

Tout test qui les appelle doit utiliser `await`.
