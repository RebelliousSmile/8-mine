# Point-and-click 8-MINE

> Système d'exploration en perspective fixe — backgrounds 1920×1080,
> sprites en pied dans la scène, navigation par clic, gameplay
> d'infiltration via zones de surveillance.

## Vue d'ensemble

| Brique | Type Godot | Script |
|---|---|---|
| `NavigableRoom` | Node2D | `scripts/world/NavigableRoom.gd` |
| `Margot` (PJ) | CharacterBody2D | `scripts/world/Margot.gd` |
| `Hotspot` (interactif) | Area2D | `scripts/world/Hotspot.gd` |
| `CameraZone` (surveillance) | Area2D | `scripts/world/CameraZone.gd` |
| `NPC` (perso dans scène) | StaticBody2D + Area2D | `scripts/world/NPC.gd` |

Distinct du Hotspot UI hérité du Prompt 1 (`scripts/ui/Hotspot.gd`),
qui est un `Control` plaqué sur un TextureRect plein écran. Le mode
visual novel reste utilisable pour les scènes de transition pures,
mais la majorité du gameplay passe désormais par `NavigableRoom`.

## Structure d'une scène NavigableRoom

```
NavigableRoom (Node2D, script NavigableRoom.gd)
  ├─ Background (Sprite2D ou ColorRect placeholder 1920×1080)
  ├─ CameraZones (Node2D)
  │   └─ XxxCam (CameraZone.tscn)         surveillance_level 1-4
  ├─ Characters (Node2D)
  │   └─ Frank, Sofia... (NPC.tscn)       pnj_id, interaction_offset
  ├─ Hotspots (Node2D)
  │   ├─ HotspotXxx (Hotspot.tscn)        type, payload, required_flag
  ├─ Margot (Margot.tscn instance)
  └─ UI (CanvasLayer)
      ├─ Cursor (TextureRect)
      └─ ExamineLabel (Label, autohide 3s)
```

## Flux d'interaction

```
1. Clic gauche dans le décor (rien dessous)
   → _unhandled_input → Margot.move_to(mouse_pos)

2. Clic gauche sur un Hotspot ou NPC
   → input_event de l'Area2D → interaction_demandee.emit(self)
   → NavigableRoom._on_interaction_demandee :
       _pending_target = cible
       Margot.move_to(cible.get_interaction_position())

3. Margot arrive
   → Margot.arrived(pos) → NavigableRoom._on_margot_arrived :
       _pending_target.execute_interaction()

4. execute_interaction() dispatche selon type :
       DIALOGUE → Dialogic.start(timeline)
       NAVIGATE → LocationManager.aller_a_scene(...)
       EXAMINE  → ExamineLabel affiche le texte 3s
       PICKUP   → signal pickup_demande
       NPC      → Dialogic.start(get_timeline()) — résolu dynamiquement
```

## Hotspot — propriétés exportées

| Propriété | Type | Usage |
|---|---|---|
| `hotspot_type` | enum | DIALOGUE / NAVIGATE / EXAMINE / PICKUP |
| `libelle` | String | label curseur / accessibilité |
| `dialogic_timeline` | path .dtl | type DIALOGUE |
| `target_scene` | path .tscn | type NAVIGATE |
| `examine_text` | String multiline | type EXAMINE |
| `pickup_item_id` | String | type PICKUP |
| `required_flag` | String | flag GameStateManager requis |
| `required_flag_value` | bool | valeur attendue (défaut true) |
| `interaction_offset` | Vector2 | décalage où Margot s'arrête |

Si `required_flag` est posé et que la valeur ne matche pas, le
hotspot devient invisible **et** cesse d'écouter les clics
(`monitoring = false`). Il re-s'active automatiquement quand le
flag passe à la bonne valeur (signal `GameStateManager.flag_modifie`).

## NPC — résolution de timeline

`NPC.get_timeline()` résout dynamiquement la timeline à lancer
selon, dans l'ordre :

1. **Flag explicite** `flag_<pnj_id>_allie` → `<pnj_id>_allie`
2. **Flag explicite** `flag_<pnj_id>_tension` → `<pnj_id>_tension`
3. **Palier de relation** via `RelationManager.get_niveau(pnj_id)` :
   - intime / amitié / confiance → `_allie`
   - sympathie / neutre → `_neutre`
   - froid / méfiance / hostilité / ennemi → `_tension`
4. **Fallback** : `<pnj_id>_neutre`

Le mapping palier → suffix est configurable par instance via la
propriété exportée `timeline_suffix_par_niveau`.

## Surveillance — zones spatiales

`CameraZone` est un Area2D qui détecte le groupe `"player"`
(Margot s'y ajoute au _ready).

```gdscript
# Entrée
body_entered → SurveillanceManager.register_zone_entered(zone_id, level)
# Sortie
body_exited  → SurveillanceManager.register_zone_exited(zone_id)
```

`SurveillanceManager._process(delta)` :

```python
niveau = max_zone_level()
if niveau > 0:
    temps_expose += delta * niveau
    if temps_expose >= SEUIL_ALERTE:    # 10.0 secondes
        temps_expose = 0
        GameStateManager.personal_danger += 1
        CountdownManager.avancer_nettoyage(1)
        increase(niveau, "exposition_zone")   # bump level [0,100]
```

`SEUIL_ALERTE = 10.0` (configurable). Une zone de niveau 1 met
10 s à déclencher une alerte ; niveau 4 met 2.5 s.

Signaux exposés :
- `exposure_tick(zone_level, temps_expose)` — chaque frame en zone
- `exposure_alerte_declenchee(zone_level)` — quand le seuil tombe

## Intégration Dialogic

`NavigableRoom._ready()` :
1. Connecte `Dialogic.timeline_started` → bloque les inputs
2. Connecte `Dialogic.timeline_ended` → rend la main
3. Synchronise `Dialogic.VAR.ex_prenom` et `ex_genre` depuis
   `ExProfileManager`

Si Dialogic n'est pas installé, ces hooks deviennent des no-op
(garde `get_node_or_null("/root/Dialogic")`).

## Scène d'exemple : PRO-01 / Zone Commune

`scenes/prologue/pro_zone_commune.tscn` :

- Background : couleur uniforme placeholder (l'asset
  `bg_zone_commune_soir.jpg` n'existe pas encore — modulate posée
  sur le Sprite2D)
- Frank en bas-gauche (`pnj_id="frank"`), Sofia en bas-droite
  (`pnj_id="sofia"`)
- HotspotFrank désactivé par `required_flag="flag_emma_a_reveele"`
  (s'activera plus tard dans la scénarisation)
- HotspotCouloir actif, type NAVIGATE vers
  `res://scenes/base/NavigableRoom.tscn` (placeholder couloir)
- CameraZone niveau 3 couvrant la pièce centrale (1600×700 au
  centre 960,540)

## Couches de collision

| Layer | Usage |
|---|---|
| 1 | Margot (collision physique, navigation) |
| 2 | Hotspot (clic souris uniquement) |
| 4 | CameraZone (détection passage du joueur) |
| 8 | NPC body (collision physique) |
| 16 | NPC click area (clic souris) |

Les Area2D « clic » ont `monitoring = false`, `monitorable = false`
et `input_pickable = true` — elles ne consomment pas de CPU pour
la détection physique, juste les inputs souris.

## Cas non couverts (dette à noter)

- **Pathfinding** : déplacement en ligne droite, pas
  d'obstacle-avoidance. Pour des scènes plus complexes, ajouter
  un NavigationAgent2D + NavigationRegion2D.
- **Curseur contextuel** : la TextureRect `UI/Cursor` existe mais
  n'a pas de texture par défaut. Brancher des sprites via les
  signaux `hover_change` des hotspots/npcs.
- **Inventaire** : `PICKUP` émet `pickup_demande` mais aucun
  manager n'écoute. Ajouter un `InventoryManager` quand le
  scénario en exige.
- **Sprites Margot / NPC** : `PlaceholderTexture2D` actuellement.
  Remplacer par les assets définitifs (`char_frank_neutre.png`
  etc.) en éditant les `Sprite2D` instanciés.

## Tests automatisés

- `test_surveillance_zones.gd` — register/exit, accumulation
  temps, déclenchement PD + tick nettoyage
- `test_npc_world.gd` — résolution timeline (4 cas), display name
- `test_hotspot_world.gd` — activation par flag, interaction_offset,
  signaux EXAMINE / PICKUP

UI/animation visuels (curseur contextuel, mouvement de Margot
en temps réel, fondus) : à valider manuellement dans l'éditeur
(`scenes/prologue/pro_zone_commune.tscn` F6).
