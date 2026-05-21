# État réel du code — 8-MINE
_Dernière mise à jour : 2026-05-21_

> Snapshot du code Godot (managers, scripts, conventions de NODE).
> Pour le tracker tâches/scènes/assets → `etat-prod.md`. Pour les conventions canon → `architecture.md`.

---

## Infrastructure ✅ (tout implémenté)

### 14 Autoloads
Tous présents dans `project.godot` et `scripts/managers/`.

| Manager | Fichier | Testé |
|---------|---------|-------|
| Config | `scripts/config.gd` | — |
| SaveManager | `scripts/managers/SaveManager.gd` | ✅ GUT |
| GameStateManager | `scripts/managers/GameStateManager.gd` | ✅ GUT |
| RelationManager | `scripts/managers/RelationManager.gd` | ✅ GUT |
| CharacterRegistry | `scripts/managers/CharacterRegistry.gd` | ✅ GUT |
| LocationManager | `scripts/managers/LocationManager.gd` | — |
| CountdownManager | `scripts/managers/CountdownManager.gd` | ✅ GUT |
| ExProfileManager | `scripts/managers/ExProfileManager.gd` | — |
| SurveillanceManager | `scripts/managers/SurveillanceManager.gd` | ✅ GUT |
| MirrorStatusManager | `scripts/managers/MirrorStatusManager.gd` | ✅ GUT |
| ReputationManager | `scripts/managers/ReputationManager.gd` | — |
| SurveillanceHUD | `scenes/ui/SurveillanceHUDAutoload.tscn` | — |
| GameOverHandler | `scripts/managers/GameOverHandler.gd` | — |
| DialogicBridge | `scripts/managers/DialogicBridge.gd` | — |

### Point-and-click (6 scripts)
Tous présents dans `scripts/world/` et `scripts/ui/`.

| Script | Fichier | Rôle |
|--------|---------|------|
| NavigableRoom | `scripts/world/NavigableRoom.gd` | Scène-hôte, orchestration |
| Margot | `scripts/world/Margot.gd` | PJ, mouvement ligne droite |
| Hotspot (world) | `scripts/world/Hotspot.gd` | Zone interaction Area2D |
| CameraZone | `scripts/world/CameraZone.gd` | Zone surveillance Area2D |
| NPC | `scripts/world/NPC.gd` | PNJ statique + résolution timeline |
| Location | `scripts/ui/Location.gd` | Composant UI location |

### Dialogic custom events
| Event | Fichier | Status |
|-------|---------|--------|
| `ask_name` | `addons/dialogic_additions/AskName/` | ✅ |

---

## Contenu narratif

### Timelines .dtl
| Timeline | Status | Notes |
|----------|--------|-------|
| `pro_arrivee.dtl` | ✅ jouable | Playtest 2025-11-21 validé (120 min) |
| `exemple_relation.dtl` | ✅ démo | Exemple technique, pas narratif |
| `pro_cellule.dtl` | ❌ manquant | Spec : `nodes/02.md` |
| Tous A1/A2/A3/A4 | ❌ manquants | Spec : `history.md` |

### Scènes Godot par NODE
| NODE | .tscn | .gd | _init.gd | .dtl |
|------|-------|-----|----------|------|
| PRO-01 arrivée | ✅ `pro_arrivee.tscn` | ✅ `pro_arrivee.gd` | ✅ `pro_arrivee_init.gd` | ✅ `pro_arrivee.dtl` |
| PRO-01 zone commune | ✅ `pro_zone_commune.tscn` | — | — | — |
| PRO-02 cellule | ❌ | ❌ | ❌ | ❌ |
| A1-xx → A4-xx | ❌ | ❌ | ❌ | ❌ |

### Assets
| Asset | Status |
|-------|--------|
| Characters Dialogic (emma, margot, narrator, voix_synth) | ✅ `.dch` |
| Backgrounds (bg_tramway, bg_hall, bg_ascenseur, bg_zone_commune) | ❌ LoRA à générer |
| Sprites Emma (neutre, tension, + 4 expressions) | ❌ LoRA à générer |
| Sprites 7 autres PNJ | ❌ |

---

## Convention structure d'un NODE

**4 fichiers obligatoires** (cf. `architecture.md` § convention NODE) :

```
dialogic/timelines/<node_id>.dtl        ← dialogue Dialogic
scenes/<chapitre>/<node_id>.tscn        ← scène Godot
scripts/<chapitre>/<node_id>.gd         ← logique scène (signal handling)
scripts/<chapitre>/<node_id>_init.gd    ← init variables (testable GUT)
```

Exemple : PRO-01 → `pro_arrivee.dtl` / `pro_arrivee.tscn` / `pro_arrivee.gd` / `pro_arrivee_init.gd`
