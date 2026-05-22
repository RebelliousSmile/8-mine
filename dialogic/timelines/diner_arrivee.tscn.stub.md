# Stub `.tscn` — `diner_arrivee`

> Instructions de finalisation manuelle. Le `.tscn` Godot doit être créé dans l'Editor à partir de ces indications. Ne pas générer automatiquement (risque corruption projet).

## Localisation

- **Fichier à créer** : `scenes/acte1/diner_arrivee.tscn`
- **Script associé** : `scripts/acte1/diner_arrivee.gd`

## Composition de scène

```
diner_arrivee.tscn  (root: NavigableRoom OU Node2D simple si pas de hotspots)
├── TextureRect (background)
│     └─ texture = res://assets/backgrounds/bg_zone_commune_soir.jpg
│     └─ anchor full rect, stretch
├── PNJsContainer (Node2D, organise les positions à table)
│     ├── NPC_Emma    (Sprite2D + position canon)
│     ├── NPC_Leo
│     ├── NPC_Marine
│     ├── NPC_Thomas
│     ├── NPC_Sofia
│     ├── NPC_Alex
│     ├── NPC_Camille
│     └── NPC_Frank
├── DialogicLayer  (DialogicNode — invoque la timeline)
└── (pas de hotspots — scène dialoguée pure, pas de point-and-click)
```

## Position canon des PNJs autour de la table

D'après `session-exemple-01.md` et la canon : Margot est *entre les deux blocs* (Memorize/Kaizen à gauche, Nexus/Stratom à droite).

Suggestion de placement (vue de dessus, depuis l'entrée) :

```
              [Camille] [Frank]
                  ┃
[Leo]            [TABLE]            [Alex]
[Emma]                              [Sofia]
                  ┃
[Marine]                            [Margot]
[Thomas]                            (POV)
```

Margot étant le POV, elle peut être hors-champ visuel (caméra à sa place) ou représentée par un sprite à gauche du cadre selon préférence de mise en scène.

## Script `diner_arrivee.gd` (squelette)

```gdscript
extends NavigableRoom  # ou Node2D si non-navigable

func _ready() -> void:
    # Vérification précondition : sortie d'un NODE A1-01-*
    if not _precondition_ok():
        push_warning("diner_arrivee chargée sans précondition A1-01-*. Routing erroné ?")
        return

    # Démarrage timeline
    Dialogic.start("diner_arrivee")

    # Connexion sortie : la timeline pose lieu:coursive_residents_nuit en fin
    # LocationManager interceptera et routera automatiquement.

func _precondition_ok() -> bool:
    return (
        GameStateManager.get_flag("flag_a1_01_micro_passe")
        or GameStateManager.get_flag("flag_a1_01_ethique_passe")
        or GameStateManager.get_flag("flag_a1_01_confrontation_passe")
        or GameStateManager.get_flag("flag_a1_01_stratege_passe")
    )
```

## Assets requis

### Background

`assets/backgrounds/bg_zone_commune_soir.jpg` (1920x1080)

Prompt suggéré pour génération AI :
```
neo-paris 2084 corporate residential dining hall, evening, fixed perspective
wide shot, dining table for nine set with white tableware, eight seats occupied
by figures (suggested only, not detailed), warm tungsten lighting from above,
rain visible through large bay window on the right wall, view onto interior
Saint-Michel courtyard, wood-and-glass partitions, photorealistic concept art,
cinematic composition, 1920x1080
```

### Sprites PNJ (8)

Set d'expressions par PNJ pour cette scène. Convention :
- `char_<pnj>_diner_neutre.png`
- `char_<pnj>_diner_attention.png` *(quand le PNJ s'adresse à Margot)*
- `char_<pnj>_diner_inquiet.png` *(uniquement Camille quand elle pose le cliffhanger)*

PNJs : emma, leo, marine, thomas, sofia, alex, camille, frank.

Voir `bible-jeu.md § fiches PNJ` pour la description physique canon de chaque.

## Enregistrement requis

### LocationManager

Aucun nouveau lieu — `zone_commune_soir` doit déjà être enregistré (utilisé pour le dîner d'arrivée canon). Vérifier dans `scripts/managers/location_manager.gd` :

```gdscript
# Doit contenir :
"zone_commune_soir": {
    "background": "res://assets/backgrounds/bg_zone_commune_soir.jpg",
    "scene": "res://scenes/acte1/diner_arrivee.tscn"
}
```

### CharacterRegistry

Les 8 PNJs résidents doivent déjà être enregistrés (cf. `pro_arrivee.dtl` où Emma est utilisée). Vérifier que `leo`, `marine`, `thomas`, `sofia`, `alex`, `camille`, `frank` ont leur entrée + `<pnj>_prenom` var.

### DialogicBridge

Aucun nouveau dispatcher requis — tous les signaux utilisés sont canon (`relation:`, `flag:`, `ms:`, `pd:`, `ev:`, `reputation:`, `decision:`, `lieu:`).

### Autoloads

Aucun nouvel autoload requis.

## Variables Dialogic introduites

| Variable | Usage | Initialisation |
|----------|-------|----------------|
| `diner_sujets_consommes` | compteur de sujets joués (cap = 2) | initialisée à 0 par `[set var="..." value="0"]` en début de timeline |

✅ **Enregistrée dans `aidd_docs/memory/internal/variables-register.md § Variables de scènes`** (fix audit 2026-05-22).

## Tests à prévoir

- [ ] La timeline démarre quand on charge `diner_arrivee.tscn` depuis le menu test (F6 dans Editor)
- [ ] Le sujet `presentation` est forcé en premier (aucun autre choix avant)
- [ ] `[C] mensonge` n'apparaît que si `FLAG_MOTIVATION ∈ {argent, carriere}`
- [ ] La vérification cachée Sofia sur `[C]` : test avec `mental_stability = 4` (réussite) puis `mental_stability = 2` (échec)
- [ ] Le sujet `evoquer_witness` n'apparaît qu'après présentation `[B]` ou `[D]`
- [ ] Le compteur `diner_sujets_consommes` cap bien à 2
- [ ] L'événement `event_camille_cliffhanger` se déclenche si présentation ∈ {A, C, D}, pas si B
- [ ] Sortie : routing vers `coursive_residents_nuit` *(scène à créer ultérieurement)*

## Notes de mise en scène (rappel scene-spec)

- Margot **entre les deux blocs** (Memorize/Kaizen à gauche, Nexus/Stratom à droite). Décision de mise en scène à ancrer dans la disposition `.tscn`.
- Position relative des deux couples : Camille/Frank ensemble *(glacial mais soudés)*, Sofia/Alex ensemble *(couple démonstratif transparent)*.
- Pluie sur la baie = ambiance sonore subtile, pas de cinematic.
- Éclairage tungstène chaud, baisse imperceptible vers la fin (cf. narrateur d'outro).
