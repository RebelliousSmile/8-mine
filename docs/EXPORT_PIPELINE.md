# Pipeline d'export 8-MINE — de la scene-spec au jeu jouable

> Documentation du flux complet : artefact narratif (Markdown) → projet Godot jouable.
> Référence pour tout contributeur narrative ou dev. Statut canon.

---

## Vue d'ensemble

```
┌─────────────────────┐
│  CANON SOURCES      │  overview.md, bible-jeu.md, history.md, variables-register.md
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│  SPECS NARRATIVES   │  scene-spec / pnj-behavior / node-spec (Markdown)
└─────────┬───────────┘
          │ write-scene / write-dtl
          ▼
┌─────────────────────┐
│  DIALOGIC TIMELINES │  .dtl  (généré automatiquement)
└─────────┬───────────┘
          │ dtl_linter.gd
          ▼
┌─────────────────────┐
│  VALIDATIONS        │  linter PASS → auditeur-scene → dramaturge → personas qualitatifs
└─────────┬───────────┘
          │ création manuelle dans Godot
          ▼
┌─────────────────────┐
│  GODOT SCENES       │  .tscn  (manuel, suit le stub markdown)
│  + SCRIPTS          │  .gd    (manuel, signal handling)
│  + ASSETS           │  backgrounds, sprites, audio
└─────────┬───────────┘
          │ enregistrement
          ▼
┌─────────────────────┐
│  ORCHESTRATION      │  LocationManager, CharacterRegistry, Main.tscn, autoloads
└─────────┬───────────┘
          │ tests
          ▼
┌─────────────────────┐
│  TESTS              │  GUT (mécanique) + playtest manuel
└─────────────────────┘
```

---

## Artefacts par couche

### Couche 1 — Specs narratives (Markdown)

| Type | Localisation | Prompt producteur | Contenu |
|------|--------------|-------------------|---------|
| `scene-spec` | `aidd_docs/memory/external/scenes/<scene_id>.md` | `scene-spec` | scène-type réutilisable : lieu, PNJs candidats, scope jauges, sujets, événements seuil |
| `pnj-behavior` | `aidd_docs/memory/external/pnjs-behavior/<pnj>.md` | `pnj-behavior` | catalogue PNJ : voix par palier, verrous canon, événements seuil one-shot |
| `node-spec` | `aidd_docs/memory/external/nodes/<NN>.md` | `decompose-arc` *(legacy)* / écriture directe | scène scriptée non-réutilisable (prologue, codas FIN) |

### Couche 2 — Timelines Dialogic

| Type | Localisation | Prompt producteur | Notes |
|------|--------------|-------------------|-------|
| `.dtl` *(depuis scene-spec)* | `dialogic/timelines/<scene_id>.dtl` | `write-scene` | inclut bloc de résolution PNJ runtime, sujets filtrés, événements de seuil injectés |
| `.dtl` *(depuis node-spec, legacy)* | `dialogic/timelines/<scene>.dtl` | `write-dtl` | linéaire, branches d'arc |
| `.tscn.stub.md` | `dialogic/timelines/<scene>.tscn.stub.md` | `write-scene` / `write-dtl` | instructions de finalisation manuelle pour le `.tscn` |

### Couche 3 — Scènes Godot (manuelles, suivent le stub)

| Type | Localisation | Source | Contenu |
|------|--------------|--------|---------|
| `.tscn` | `scenes/<acte>/<scene>.tscn` | création manuelle dans Godot Editor | NavigableRoom (root), TextureRect (background), Hotspots, NPCs (Node2D), CameraZones |
| `.gd` | `scripts/<acte>/<scene>.gd` | création manuelle | logique de la scène : `_ready` lance Dialogic, signal handling hotspots, transitions de lieu |
| `_init.gd` | `scripts/<acte>/<scene>_init.gd` | création manuelle | uniquement si premier NODE d'un arc — initialise flags/jauges |

### Couche 4 — Assets

| Type | Localisation | Format | Source |
|------|--------------|--------|--------|
| Backgrounds | `assets/backgrounds/bg_<lieu>.jpg` | 1920x1080 JPG | génération AI (prompts cf. `nodes/02.md`) puis placement manuel |
| Sprites PNJ | `assets/characters/char_<pnj>_<expression>.png` | PNG transparent | génération AI puis placement |
| Audio musique | `assets/music/<id>.ogg` | OGG Vorbis | pistes d'ambiance, placement manuel |
| Audio effets | `assets/sfx/<id>.ogg` | OGG Vorbis | sons d'interaction, placement manuel |

### Couche 5 — Orchestration (autoloads + registries)

| Manager | Fichier | Action requise quand on ajoute |
|---------|---------|--------------------------------|
| `LocationManager` | `scripts/managers/LocationManager.gd` | nouveau lieu → ajouter l'ID dans la liste connue et son background |
| `CharacterRegistry` | `scripts/managers/CharacterRegistry.gd` | nouveau PNJ → enregistrer ID Dialogic + prénom par défaut + sprite_set |
| `DialogicBridge` | `scripts/managers/DialogicBridge.gd` | nouveau dispatcher → ajouter à `DISPATCHERS_VALIDES` *(et au registre `dtl_linter.gd`)* |
| `Main.tscn` | scène racine | nouveau point d'entrée → router depuis le menu |
| `project.godot [autoload]` | config | nouveau manager autoload → ajouter en respectant l'ordre canon (cf. CLAUDE.md) |

---

## Workflow étape par étape

### Étape 1 — Spec narrative (1 ou 2 prompts)

```bash
# Si la scène implique un nouveau PNJ ou des comportements PNJ non encore spec :
/pnj-behavior <pnj_id>
# → produit aidd_docs/memory/external/pnjs-behavior/<pnj>.md

# Spec la scène (référence les pnj-behaviors existants) :
/scene-spec <scene_id>
# → produit aidd_docs/memory/external/scenes/<scene_id>.md
```

### Étape 2 — Génération de la timeline

```bash
/write-scene aidd_docs/memory/external/scenes/<scene_id>.md
# → produit dialogic/timelines/<scene_id>.dtl
# → produit dialogic/timelines/<scene_id>.tscn.stub.md
# → lance dtl_linter automatiquement, STOP si FAIL
```

### Étape 3 — Audit structurel

```bash
# Audit strict mécanique du .dtl vs scene-spec + pnj-behaviors :
/review-persona dialogic/timelines/<scene_id>.dtl auditeur-scene \
  --scene-spec aidd_docs/memory/external/scenes/<scene_id>.md \
  --pnj-behaviors <chemin1,chemin2,...>

# Audit structurel narratif (cohérence inter-scènes, verrous, fins) :
/review-persona dialogic/timelines/<scene_id>.dtl dramaturge \
  --scene-spec aidd_docs/memory/external/scenes/<scene_id>.md

# Audit sensibilité (obligatoire pour scènes intimes / verrous PNJ trans / dark cogni-affectif) :
/review-persona dialogic/timelines/<scene_id>.dtl playtester-lgbtqia \
  --scene-spec aidd_docs/memory/external/scenes/<scene_id>.md \
  --pnj-behaviors aidd_docs/memory/external/pnjs-behavior/<pnj>.md
```

Si triage 🔴 → retour `write-scene --feedback` avec le résumé du feedback. Si 🟡 → patch local via `doctor`. Si 🟢 → étape 4.

### Étape 4 — Audit qualitatif

```bash
/review-persona dialogic/timelines/<scene_id>.dtl margot-joueuse \
  --scene-spec aidd_docs/memory/external/scenes/<scene_id>.md

/review-persona dialogic/timelines/<scene_id>.dtl critique-indie-narratif --light  # filtre rapide
# etc. selon priorités
```

### Étape 5 — Création des fichiers Godot (manuelle)

Suivre le `<scene_id>.tscn.stub.md` :

1. Dans Godot Editor : créer `scenes/<acte>/<scene_id>.tscn`
2. Structure suggérée :
   ```
   NavigableRoom (root)
     ├── TextureRect (background bg_<lieu>.jpg)
     ├── Hotspot[] (si point-and-click)
     ├── NPC[] (Node2D positionnés selon scène)
     └── CameraZone[] (surveillance)
   ```
3. Créer `scripts/<acte>/<scene_id>.gd` :
   ```gdscript
   extends NavigableRoom

   func _ready() -> void:
       Dialogic.start("<scene_id>")
       # connexions hotspots si applicable
   ```
4. Tester la scène en isolation (F6 dans Godot Editor).

### Étape 6 — Enregistrement orchestration

Si le lieu est nouveau :
- Ajouter l'ID dans `LocationManager` *(scripts/managers/LocationManager.gd)*
- Référencer le background dans `LocationManager._backgrounds`

Si un PNJ est nouveau :
- Ajouter l'ID dans `CharacterRegistry` *(scripts/managers/CharacterRegistry.gd)*
- Ajouter `DISPATCHERS_VALIDES` et `PNJ_VALIDES` dans `scripts/tools/dtl_linter.gd` si nouveau dispatcher ou PNJ

Si un nouveau seuil est introduit :
- Étendre `RelationManager` pour émettre `threshold_crossed(pnj, palier)` (cf. signal natif Surveillance/Mirror — pattern existant à généraliser)
- Câbler dans `DialogicBridge` les dispatchers correspondants

### Étape 7 — Tests

```bash
# Tests GUT mécaniques (managers, signaux) :
tests/run_tests.sh        # Linux/macOS
tests\run_tests.bat       # Windows

# Playtest manuel — checklist :
# Lancer le jeu, naviguer jusqu'à la scène, jouer les variantes de sujets,
# vérifier que les jauges évoluent comme prévu, que les événements de seuil
# se déclenchent au bon moment, que les voix off d'ambiance jouent.
# Cf. docs/MANUAL_VALIDATION.md pour la checklist détaillée.
```

---

## Ce qui est automatisé vs manuel

| Étape | Automatisation |
|-------|---------------|
| Spec narrative *(scene-spec, pnj-behavior)* | 🤖 prompts |
| Génération `.dtl` | 🤖 `write-scene` |
| Linter `.dtl` | 🤖 `dtl_linter.gd` |
| Audits review-persona | 🤖 prompts (LLM) |
| Création `.tscn` Godot | ✋ manuel dans Editor |
| Création `.gd` signal handling | ✋ manuel (gabarit minimal) |
| Génération assets (backgrounds, sprites) | 🤖 prompts AI génératifs + ✋ placement manuel |
| Enregistrement `LocationManager`, `CharacterRegistry`, autoloads | ✋ manuel (mais convention claire) |
| Tests GUT | 🤖 `run_tests.sh` |
| Playtest manuel | ✋ manuel |

**Pourquoi `.tscn` reste manuel** : les `.tscn` Godot 4.x sont denses *(références NodePath, sub-resources, configurations visuelles)* et toute génération automatique risque de corrompre le projet. Le `.tscn.stub.md` produit par `write-scene` donne la composition attendue ; le designer ou dev la matérialise dans Godot Editor pour bénéficier de la validation visuelle immédiate.

---

## Validations à chaque couche

| Couche | Validation | Outil |
|--------|-----------|-------|
| Scene-spec / pnj-behavior | Sections complètes, scope jauges déclaré | self-check du prompt `scene-spec` / `pnj-behavior` |
| `.dtl` syntaxique | `[signal arg="..."]` conformes, dispatchers valides | `dtl_linter.gd` (obligatoire avant tout review) |
| `.dtl` structurel | Scope jauges respecté, verrous pnj-behavior tenus, présence runtime correcte | `review-persona auditeur-scene` |
| `.dtl` narratif | Cohérence inter-scènes, fins, beats | `review-persona dramaturge` |
| `.dtl` sensitivity | Verrous trans/dark cogni-affectif tenus, pronoms, tropes | `review-persona playtester-lgbtqia` |
| `.dtl` qualité prose | Voix Margot, sous-texte, choix non punitifs | `review-persona margot-joueuse` |
| `.tscn` Godot | Compile dans l'éditeur, scène lance Dialogic | F6 Editor |
| Mécanique managers | Signaux, jauges, threshold | `tests/run_tests.sh` (GUT) |
| Expérience finale | Tout le pipeline | playtest manuel |

---

## Erreurs courantes et fixes

| Symptôme | Cause probable | Fix |
|----------|---------------|-----|
| `dtl_linter FAIL : dispatcher inconnu` | Nouveau dispatcher utilisé dans le `.dtl` mais pas enregistré | Ajouter le match dans `DialogicBridge.gd` + enregistrer dans `dtl_linter.gd → DISPATCHERS_VALIDES` |
| `auditeur-scene : jauge hors scope` | `write-scene` a émis un signal sur une jauge non déclarée par la scene-spec | Soit corriger la scene-spec *(scope incomplet)*, soit corriger le sujet *(touche jauge non prévue)* |
| `dramaturge : fin laissée orpheline` | Une fin canon de `history.md` n'est ouverte par aucun chemin | Ajouter une branche/sujet qui l'ouvre, OU déprécier la fin dans `history.md` |
| Sprite PNJ pas chargé en jeu | Sprite absent de `assets/characters/` ou ID mal référencé dans `CharacterRegistry` | Vérifier filename + ID Dialogic + entrée registry |
| Lieu inconnu au runtime | `LocationManager.aller_a()` appelé avec ID non enregistré | Ajouter l'ID + background dans `LocationManager` |
| Événement de seuil se re-déclenche | `flag_event_<X>_consomme` pas posé | Vérifier l'injection dans le `.dtl` ; sinon corriger via `write-scene --feedback` |

---

## Convention de nommage

| Type | Convention | Exemple |
|------|-----------|---------|
| scene_id | `snake_case`, descriptif de l'événement ou du lieu | `diner_arrivee`, `cellule_nuit`, `appart_emma_leo` |
| Lieu | `snake_case` du lieu narratif | `zone_commune_soir`, `coursive_residents_nuit` |
| PNJ ID | `lowercase` du prénom | `emma`, `frank`, `sofia` |
| Flag | `snake_case`, préfixé par le contexte | `flag_emma_a_reveele`, `flag_event_emma_confident_consomme` |
| Background asset | `bg_<lieu>.<ext>` | `bg_zone_commune_soir.jpg` |
| Sprite asset | `char_<pnj>_<expression>.png` | `char_emma_diner_neutre.png` |
| Timeline `.dtl` | match `scene_id` | `dialogic/timelines/diner_arrivee.dtl` |
| Scène `.tscn` | match `scene_id` | `scenes/acte1/diner_arrivee.tscn` |
| Script `.gd` | match `scene_id` | `scripts/acte1/diner_arrivee.gd` |

---

## Pour aller plus loin

| Sujet | Référence |
|-------|-----------|
| Modèle narratif 3 couches | `aidd_docs/memory/external/overview.md § Architecture narrative` |
| Catalogue scenes | `aidd_docs/memory/external/scenes/_index.md` |
| Catalogue PNJs | `aidd_docs/memory/external/pnjs-behavior/*.md` |
| Conventions code Godot | `aidd_docs/memory/internal/architecture.md` |
| API DialogicBridge | `aidd_docs/memory/internal/api-cheatsheet.md` |
| Tests GUT | `docs/TESTING_GUIDE.md` |
| Playtest manuel | `docs/MANUAL_VALIDATION.md` |
| Linter Dialogic | `scripts/tools/dtl_linter.gd` *(source de vérité pour PNJ_VALIDES, FACTIONS_VALIDES, etc.)* |
