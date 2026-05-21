---
name: init-bank
description: Setup du pipeline 8-MINE. Génère bank.yml depuis aidd_docs/memory/ et scaffold overview.md si absent.
argument-hint: [--dry-run] [--force]
version: 1.1
---

# Init Bank — memory/ → bank.yml (+ scaffold overview.md si absent)

## Goal

Scanner `aidd_docs/memory/external/` et `aidd_docs/memory/internal/`, puis produire
`aidd_docs/aiw/8mine/bank.yml` — registre canonique des ressources que les prompts du
pipeline 8-MINE et les personas peuvent charger.

**À lancer** :
- Au setup initial du pipeline (une fois)
- Après ajout d'un fichier canon dans `memory/external/` ou `memory/internal/`
- Avant `challenge-bank` (qui audite le contenu déclaré)

**À ne pas confondre avec** :
- `challenge-bank` qui **audite** (lore ↔ code) sans modifier bank.yml
- `templates/bank.yml` (AIW) qui est le template générique TTRPG, non adapté à 8-MINE

## Context

**Memory à indexer :**
```
@aidd_docs/memory/external/
@aidd_docs/memory/internal/
```

**Personas dont les `reference_documents:` doivent rester cohérents :**
```
@aidd_docs/aiw/8mine/personas/
```

**Bank cible :**
```
aidd_docs/aiw/8mine/bank.yml
```

## Process

### Step 0 — Scaffold `overview.md` si absent

Vérifier l'existence de `aidd_docs/memory/external/overview.md`.

**Si absent** (et `--dry-run` non passé) → créer un squelette minimal pour que `brainstorm` /
`upgrade` / `arc-spec` aient une cible existante. Contenu du squelette :

```markdown
# 8-MINE — Overview projet

> Synthèse 400-500 lignes. Source de vérité macroscopique pour `arc-spec`.
> Construit et entretenu par `brainstorm` + `upgrade` (workshop AIW).
> Ne pas écrire d'arc complet ici — les arcs vivent dans `memory/external/arcs/`.

## Pitch (1 paragraphe)

`<À remplir via brainstorm.>`

## Cast principal

`<PJ + 17 PNJ principaux. Renvoyer vers bible-jeu.md pour le détail.>`

## Jauges et stakes joueur

- **Mental Stability (MS)** [0-6] · **Personal Danger (PD)** [0-∞]
- **Surveillance externe** [0-100] · **Mirror (dette psychologique)** [0-100]
- **Réputation** : 8 factions (stratom, marine, presse, police, activistes, memorize, nexus, kaizen)

Renvoi détaillé : `memory/internal/variables-register.md`.

## Arcs et arborescence

`<Liste des arcs (PRO, A1, A2-romance-X, A3, A4) avec une ligne chacun.>`

## Fins canoniques

9 fins (A-I). Détail : `memory/external/history.md`.

## Notes auteur

`<…>`
```

Si présent → ne pas toucher. Si `--force` → ne pas écraser non plus (l'overview est précieux).
Signaler la création dans le rapport final.

### Step 1 — Inventaire `memory/`

Lister exhaustivement :
- Tous les `.md` dans `memory/external/` (racine + sous-dossiers comme `nodes/`)
- Tous les `.md` dans `memory/internal/`

Pour chaque fichier, extraire **le rôle canonique** depuis la première ligne d'intro
(titre H1) ou le frontmatter. Si rôle ambigu → flagger pour décision auteur.

### Step 2 — Catégoriser

Classer chaque fichier dans une catégorie 8-MINE :

| Catégorie | Contenu | Exemples |
|-----------|---------|----------|
| `lore.bible` | Vision créative, cast, DA | `bible-jeu.md` |
| `lore.history` | Arborescence narrative, fins | `history.md` |
| `lore.pnjs` | PNJ secondaires | `pnjs-secondaires.md` |
| `lore.nodes` | Spec d'un NODE | `nodes/NN.md` |
| `lore.session` | Trace de playtest | `session-exemple-01.md` |
| `code.architecture` | Conventions structurelles, format NODE | `internal/architecture.md` |
| `code.api` | Cheatsheet DialogicBridge | `internal/api-cheatsheet.md` |
| `code.variables` | Flags, factions, countdowns | `internal/variables-register.md` |
| `code.state` | État du code | `internal/code-state.md` |
| `tracking.prod` | État de production · tâches · log playtests | `internal/etat-prod.md` |
| `design_rules.*` | Règles d'écriture canoniques | `internal/design-rules/*.md` |

### Step 3 — Structure du `bank.yml` 8-MINE

Format adapté (pas de TTRPG, pas d'ICML) :

```yaml
# bank.yml — Registre des ressources 8-MINE
# Généré par init-bank · Audité par challenge-bank
# NE PAS ÉDITER MANUELLEMENT — relancer init-bank après ajout d'un canon

projet:
  nom: 8-MINE
  type: jeu-narratif-godot-dialogic
  version: "0.4"  # de etat-prod.md si présent
  date_generation: "<YYYY-MM-DD>"

# --- Overview projet (synthèse 400-500 lignes, source pour arc-spec) ---
# Consommé par brainstorm/upgrade (workshop) en écriture, par arc-spec en lecture.
overview: aidd_docs/memory/external/overview.md

# --- Ressources LORE (canon narratif détaillé) ---
lore:
  bible: aidd_docs/memory/external/bible-jeu.md
  history: aidd_docs/memory/external/history.md
  pnjs_secondaires: aidd_docs/memory/external/pnjs-secondaires.md
  nodes:
    - aidd_docs/memory/external/nodes/02.md
    # ...
  # Optionnels
  sessions:
    - aidd_docs/memory/external/session-exemple-01.md

# --- Ressources CODE (canon technique) ---
code:
  architecture: aidd_docs/memory/internal/architecture.md
  api_cheatsheet: aidd_docs/memory/internal/api-cheatsheet.md
  variables_register: aidd_docs/memory/internal/variables-register.md
  code_state: aidd_docs/memory/internal/code-state.md
  linter: scripts/tools/dtl_linter.gd
  dialogic_bridge: autoload/DialogicBridge.gd

# --- Tracking interne (état de prod, suivi tâches, log playtests) ---
tracking:
  prod: aidd_docs/memory/internal/etat-prod.md

# --- Design rules (règles d'écriture canoniques, toujours actives) ---
# Référencées dans CLAUDE.md du projet.
design_rules:
  # Exemples 8-MINE :
  # sofia: aidd_docs/memory/internal/design-rules/sofia-kessler-caracterisation.md
  # margot_terrain: aidd_docs/memory/internal/design-rules/margot-terrain-neutre.md

# --- Output styles (rédactionnels) ---
# Défaut consommé par write-dtl ; variantes déclarables par node-spec.
output_styles:
  default: aidd_docs/aiw/8mine/templates/output-styles/scenario.md
  # introspection: aidd_docs/aiw/8mine/templates/output-styles/introspection.md
  # action: aidd_docs/aiw/8mine/templates/output-styles/action.md

# Document type (utilisé par brainstorm pour adapter ses questions)
document:
  type: videogame   # 8-MINE = narratif Godot/Dialogic ; questions adaptées

# --- Personas disponibles + ressources qu'iels chargent ---
# Source de vérité = reference_documents: du YAML persona
# Cette section est miroir, pour audit rapide
personas:
  margot-joueuse:
    file: aidd_docs/aiw/8mine/personas/margot-joueuse.yml
    loads: [lore.bible, lore.history, code.api_cheatsheet]
  dramaturge:
    file: aidd_docs/aiw/8mine/personas/dramaturge.yml
    loads: [lore.architecture, lore.history, lore.bible, code.variables_register]
  playtester-lgbtqia:
    file: aidd_docs/aiw/8mine/personas/playtester-lgbtqia.yml
    loads: [lore.bible, lore.pnjs_secondaires, code.api_cheatsheet]
  critique-indie-narratif:
    file: aidd_docs/aiw/8mine/personas/critique-indie-narratif.yml
    loads: [lore.bible, lore.history, code.api_cheatsheet]
  coauteur-ia:
    file: aidd_docs/aiw/8mine/personas/coauteur-ia.yml
    loads: [lore.bible, code.api_cheatsheet]
  playtester-accessibilite:
    file: aidd_docs/aiw/8mine/personas/playtester-accessibilite.yml
    loads: [lore.bible, code.api_cheatsheet]

# --- Pipeline outputs ---
outputs:
  arc_specs: aidd_docs/memory/external/arcs/   # arc-spec
  node_specs: aidd_docs/memory/external/nodes/ # decompose-arc
  timelines: dialogic/timelines/               # write-dtl
  reviews: aidd_docs/aiw/8mine/reviews/        # review-persona
```

### Step 4 — Vérification de cohérence personas ↔ bank

Pour chaque persona dans `personas/`, lire son `reference_documents:` et vérifier que
chaque entrée correspond à un chemin déclaré dans le bank. Si un persona référence un
fichier absent du bank → warning explicite (pas un blocage, peut indiquer un ajout en
cours côté persona).

### Step 5 — Écriture du bank

Si `--dry-run` : afficher en stdout sans écrire.
Sinon : écrire `aidd_docs/aiw/8mine/bank.yml`.
Si le fichier existe déjà et `--force` n'est pas passé → demander confirmation.

### Step 6 — Rapport synthétique

```
Bank généré : aidd_docs/aiw/8mine/bank.yml
- Overview : <créé · présent · absent (dry-run)>
- Lore : X fichiers (dont N nodes)
- Code : Y fichiers
- Personas : 6
- Warnings : Z (références persona non trouvées dans memory/)
```

## Output

- `aidd_docs/aiw/8mine/bank.yml` (sauf `--dry-run`)
- `aidd_docs/memory/external/overview.md` (uniquement si absent, et hors `--dry-run`)
- Rapport stdout

## Rules

1. **Le bank reflète l'état réel de `memory/`** — ne pas inventer de fichier, ne pas garder un fichier supprimé.
2. **Source de vérité personas = leur YAML** — la section `personas:` du bank est un miroir d'audit, pas une source.
3. **Pas de TTRPG / ICML / chapitres** — ce bank est spécialisé jeu narratif Godot.
4. **Aucune édition manuelle** — toute modification doit passer par `init-bank` (régénération) ou éditer directement le YAML persona pour `reference_documents:`.
5. **À relancer après chaque ajout canon** — un nouveau `nodes/03.md` ou un nouveau `pnjs-tertiaires.md` n'apparaît dans le bank qu'après `init-bank`.

## Note historique

`templates/bank.yml` est l'ancien template AIW (TTRPG/InDesign). Il reste pour référence
mais n'est **pas** consommé par le pipeline 8-MINE. Le seul bank actif est
`8mine/bank.yml` produit par ce prompt.
