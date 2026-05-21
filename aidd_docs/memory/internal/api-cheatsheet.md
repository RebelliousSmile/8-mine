# API Cheatsheet — 8-MINE
_Pour écrire rapidement du code GDScript ou des timelines .dtl_

---

## Commandes DialogicBridge (dans les timelines .dtl)

```
[signal arg="relation:<npc_id>:<delta>:<raison?>"]
[signal arg="flag:<cle>:<valeur>"]
[signal arg="decision:<id>:<libelle>"]
[signal arg="lieu:<id_lieu>"]
[signal arg="surveillance:<delta>:<raison?>"]
[signal arg="miroir:<delta>:<raison?>"]
[signal arg="reputation:<faction>:<delta>:<raison?>"]
[signal arg="countdown:<id>:<delta>"]
[signal arg="ms:<delta>:<raison?>"]
[signal arg="pd:<delta>:<raison?>"]
```

**Exemples concrets :**
```
[signal arg="relation:emma:+5:confidence"]
[signal arg="flag:flag_micros_poses:true"]
[signal arg="decision:refus_micros:Margot refuse de poser les micros"]
[signal arg="lieu:pro_cellule"]
[signal arg="surveillance:+10:camera_couloir"]
[signal arg="miroir:+5:mensonge_emma"]
[signal arg="reputation:stratom:-20:fuite_documents"]
[signal arg="countdown:equipe_nettoyage:1"]
[signal arg="ms:-1:mensonge_emma"]
[signal arg="pd:+1:repere_camera"]
```

**Notes :**
- `delta` négatif autorisé pour `surveillance:` et `miroir:` (decrease)
- `delta` négatif = `untick` pour `countdown:`
- `ms:` modifie `mental_stability` (clampé 0..MAX par le setter) — la raison est informative
- `pd:` modifie `personal_danger` (clampé ≥ 0 par le setter) — la raison est informative
- Factions valides : `stratom`, `marine`, `presse`, `police`, `activistes`, `memorize`, `nexus`, `kaizen`
- Countdowns valides : `equipe_nettoyage` (max 14), `audit_marine` (max 15)

---

## Ouvrir une NameInputDialog dans une timeline

```
[ask_name var="emma_prenom" default="Emma" npc_id="emma" prompt="Comment l'appelles-tu ?"]
```

- `var` → nom dans `Dialogic.VAR` (et auto-mis dans `CharacterRegistry`)
- `npc_id` → si `var` = `<id>_prenom`, déduit auto
- `prompt` → texte affiché dans le popup

---

## API GDScript rapide

### RelationManager
```gdscript
RelationManager.modifier("emma", +5, "raison")
RelationManager.get_niveau("emma")          # "allie", "neutre", "tension"...
RelationManager.au_moins("emma", "neutre")  # bool
```

### GameStateManager
```gdscript
GameStateManager.set_flag("pro_01.micros_poses", true)
GameStateManager.a_flag("pro_01.micros_poses")        # bool
GameStateManager.get_flag("pro_01.micros_poses")      # Variant
GameStateManager.enregistrer_decision("refus_micros", "Refuse les micros", {})
GameStateManager.mental_stability       # int 0–6
GameStateManager.personal_danger        # int ≥ 0
GameStateManager.evidence_collected     # int ≥ 0
```

### SurveillanceManager
```gdscript
SurveillanceManager.increase(10, "raison")
SurveillanceManager.decrease(5, "raison")
SurveillanceManager.get_level()          # int 0–100
```

### MirrorStatusManager
```gdscript
MirrorStatusManager.increase(5, "raison")
MirrorStatusManager.decrease(3, "raison")
MirrorStatusManager.get_status()         # int 0–100
```

### ReputationManager
```gdscript
ReputationManager.modifier("stratom", -20, "raison")
ReputationManager.get_niveau("stratom")  # "hostile", "mefiant", "indifferent", "favorable", "allie", "champion"
ReputationManager.au_moins("presse", "favorable")  # bool
```

### CountdownManager
```gdscript
CountdownManager.tick("equipe_nettoyage", 1)
CountdownManager.get_current("equipe_nettoyage")   # int
CountdownManager.get_remaining("equipe_nettoyage") # int
CountdownManager.is_completed("equipe_nettoyage")  # bool
```

### CharacterRegistry
```gdscript
CharacterRegistry.get_pc_name()                   # "Margot" par défaut
CharacterRegistry.get_npc_display_name("emma")    # override ou "Emma"
CharacterRegistry.set_npc_display_name("emma", "Ma cousine")
```

### LocationManager
```gdscript
LocationManager.aller_a("pro_cellule")
LocationManager.get_lieu_actuel()        # String
```

---

## Initialiser un NODE (_init.gd)

```gdscript
extends Node

func _ready() -> void:
    # Variables canon
    GameStateManager.mental_stability = 3
    GameStateManager.personal_danger = 0
    GameStateManager.evidence_collected = 0
    
    # Flags narratifs du NODE
    GameStateManager.set_flag("pro_02.choix_fait", false)
    
    # Démarrer la timeline Dialogic
    Dialogic.start("pro_cellule")
```

---

## Conditions dans .dtl (accès aux variables)

```
{flag_emma_a_reveele}      ← flag posé via [signal arg="flag:..."]
{pro_01_micros_poses}      ← "." remplacé par "_" automatiquement
{emma_prenom}              ← variable Dialogic.VAR
```

---

## Signaux utiles à connecter dans les scènes

```gdscript
# Depuis une scène NavigableRoom :
DialogicBridge.dialogue_demarre.connect(_bloquer_hotspots)
DialogicBridge.dialogue_termine.connect(_debloquer_hotspots)

# Depuis un HUD :
SurveillanceManager.surveillance_changed.connect(_on_surveillance_changed)
SurveillanceManager.threshold_crossed.connect(_on_seuil_surveillance)
MirrorStatusManager.mirror_status_changed.connect(_on_mirror_changed)
MirrorStatusManager.breakdown_imminent.connect(_on_game_over_miroir)
```

---

## Game Over

```gdscript
await GameOverHandler.trigger_game_over({
    "type": "surveillance",   # "surveillance" | "miroir"
    "raison": "Découverte par Stratom",
})
```

⚠️ **Toujours `await`** — c'est une coroutine (animation + transition scène).
