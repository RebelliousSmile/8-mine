---
name: write-dtl
description: Génère une timeline Dialogic .dtl à partir d'une node-spec + output-style. Linter PASS obligatoire en sortie.
argument-hint: <chemin node-spec.md> [--feedback "<correctif>"]
version: 1.1
---

# Write DTL — Spec NODE → Timeline Dialogic

## Goal

Produire un fichier `.dtl` complet, lintable, exécutable par Dialogic 2, à partir
d'une `node-spec.md`. **Aucune génération de `.tscn` ou `.gd`** — uniquement `.dtl`
+ stub `.tscn` minimal si requis.

## Context

**NODE à écrire :**
```markdown
@$ARGUMENTS[0]
```

**Ressources canon :**
```
@aidd_docs/memory/external/bible-jeu.md
@aidd_docs/memory/internal/api-cheatsheet.md
@aidd_docs/memory/internal/variables-register.md
```

**Output-style** — DÉRIVÉ du node-spec (champ `output_style:` dans le bloc Métadonnées) :
```
@aidd_docs/aiw/8mine/templates/output-styles/<nom>.md
```

Si la node-spec ne déclare pas d'`output_style`, défaut = `scenario`.

**Exemple de référence (PRO-01 implémenté) :**
```
@dialogic/timelines/pro_arrivee.dtl
```

## Process

### Step 1 — Charger la node-spec et valider

Lire la node-spec et vérifier que toutes les sections requises sont présentes :
- Métadonnées (avec `output_style:`)
- Variables à l'entrée
- Flags activés
- Characters
- Choix (si NODE interactif)
- **Transitions** (table canonique — source de vérité)
- Dépendances entrantes
- Transitions sortantes (signaux Dialogic)
- Notes de mise en scène

Si une section critique manque → STOP, demander.

### Step 1.5 — Charger l'output-style déclaré

Lire le champ `output_style:` du bloc Métadonnées :

```yaml
output_style: scenario   # → templates/output-styles/scenario.md
```

Charger le fichier correspondant `aidd_docs/aiw/8mine/templates/output-styles/<nom>.md`.
Si le fichier n'existe pas → STOP, demander à l'auteur (probablement coquille ou variante à créer).

Toutes les règles de prose, lexique, typographie, structure des signaux **viennent de ce fichier**.
**Ne pas dupliquer ici** ce qui est déjà dans l'output-style.

### Step 2 — Charger feedback (si présent)

Si `--feedback "<texte>"` est passé :
- Lire le feedback comme une contrainte de rewrite
- Identifier la branche / le beat ciblé
- Ne réécrire QUE cette portion ; conserver le reste

### Step 3 — Structurer la timeline

Squelette obligatoire :

```dialogic
# === <Titre NODE> ===
# Préconditions :
#   <flags entrants>
# Postconditions :
#   <flags sortants par branche>

# --- ÉTAT INITIAL ---
[character Portrait="<...>"]

# --- BEAT 1 : <titre du beat> ---
<dialogue>

# --- CHOIX (si NODE interactif) ---
[choice text="<libellé [A]>"]
  # Effets [A]
  [signal arg="flag:<X>:true"]
  [signal arg="surveillance:+10:raison"]
  # Dialogue suite [A]
  ...
  [signal arg="lieu:<suivant>"]

[choice text="<libellé [B]>"]
  ...

# --- FIN NODE ---
[signal arg="flag:<node>_termine:true"]
```

### Step 4 — Écrire la prose

Appliquer **strictement** les règles de l'output-style chargé au Step 1.5 :
- Lexique (red-list, vocabulaire à privilégier)
- Typographie (italique Margot interne ≠ narrator, couleurs)
- Longueurs (lignes, paragraphes, blocs)
- Format des dialogues et conditions
- Forme des signaux (avec raison pour `surveillance:`, `miroir:`, `reputation:`)

**Ne pas dupliquer ces règles ici** — l'output-style est la source unique. Si une règle manque, la signaler à l'auteur pour patch du fichier de style, pas l'inventer dans le `.dtl`.

### Step 5 — Brancher les signaux

Pour chaque effet de la node-spec, écrire le `[signal arg="..."]` correspondant.
Référence stricte : `api-cheatsheet.md`.

**Erreurs courantes à éviter** :

- ❌ `[signal arg="reputation:5"]` → manque la faction
- ✅ `[signal arg="reputation:stratom:+5"]`
- ❌ `[signal arg="miroir:+5"]` sans raison → traçabilité perdue
- ✅ `[signal arg="miroir:+5:mensonge_emma"]`
- ❌ `[signal arg="countdown:+1"]` → manque l'ID
- ✅ `[signal arg="countdown:equipe_nettoyage:1"]`

### Step 6 — Conditions dialogiques

Pour les branches conditionnelles :

```dialogic
{if {flag_emma_a_reveele}}
  emma: "Tu sais ce que j'ai fait."
{else}
  emma: "Margot, on doit se parler."
{endif}
```

Notes :
- Les `.` dans les flags deviennent `_` automatiquement
- Les variables Dialogic se lisent `{var_name}` directement

### Step 7 — Stub .tscn (si point-and-click)

Si la node-spec déclare un `<scene>.tscn` ET un `.gd`, produire un stub minimal :

```
# Stub à finaliser manuellement dans Godot :
# scenes/<acte>/<scene>.tscn
#
# Composition attendue :
#   - NavigableRoom (root)
#   - TextureRect (background bg_<...>.jpg)
#   - Hotspot × N (selon node-spec)
#   - CameraZone × N (selon node-spec)
#   - NPC × N (selon node-spec)
#
# Code .gd minimal :
#   extends NavigableRoom
#   func _ready() -> void:
#       Dialogic.start("<timeline>")
```

**NE PAS générer le `.tscn` binaire ni le `.gd` final** — risque de corruption projet.

### Step 8 — Validation locale avant sortie

Auto-checklist :

- [ ] Tous les `[signal arg="..."]` sont conformes à `api-cheatsheet.md`
- [ ] Toutes les variables `{...}` sont déclarées ou viennent d'un NODE amont
- [ ] Tous les choix mènent à un `[signal arg="lieu:..."]` ou `[signal arg="flag:arc_termine:true"]`
- [ ] Aucune branche n'oublie de poser ses postconditions
- [ ] Pas de PNJ inconnu (vérifier `bible-jeu.md` + `pnjs-secondaires.md`)
- [ ] Aucun `[signal]` orphelin (commande non reconnue par DialogicBridge)

### Step 9 — Lancer le linter (OBLIGATOIRE)

Après écriture, exécuter :

```bash
godot --headless --path . --script scripts/tools/dtl_linter.gd -- dialogic/timelines/<scene>.dtl
```

Le linter vérifie :
- PNJ valides (croisement `PNJ_VALIDES`)
- Factions valides (croisement `FACTIONS_VALIDES`)
- Countdowns valides (croisement `COUNTDOWNS_VALIDES`)
- Dispatchers valides (croisement `DISPATCHERS_VALIDES` du `DialogicBridge`)
- Variables canon (croisement `VARIABLES_CANON`)
- Format syntaxique des `[signal arg="..."]`

Si linter renvoie `FAIL` :
1. Lire le rapport
2. Corriger automatiquement les erreurs mécaniques (typo de flag, ordre d'arguments, dispatcher absent)
3. Ré-écrire le `.dtl` corrigé
4. Relancer le linter

Si encore `FAIL` après 2 tentatives → STOP et reporter à l'auteur (signal probable d'un manque côté code : nouveau dispatcher à ajouter dans `DialogicBridge.gd`, nouveau PNJ dans `PNJ_VALIDES`, etc.).

**Aucun `.dtl` ne sort de ce prompt en statut `FAIL`.** C'est le contrat avec `review-persona`.

## Output

- `dialogic/timelines/<scene>.dtl` (fichier principal)
- `dialogic/timelines/<scene>.tscn.stub.md` (instructions pour finalisation manuelle)
- Log linter en stdout

## Rules

1. **Output unique = .dtl** — pas de .tscn ni .gd générés
2. **API stricte** — référence canon `api-cheatsheet.md`
3. **Pas d'invention de variable** — toute nouvelle variable doit être ajoutée à `variables-register.md` PAR L'AUTEUR avant `write-dtl`
4. **Pas de tutoriel déguisé** — ne pas expliquer Néo-Paris au joueur
5. **Sous-texte > exposition** — ce qu'on ne dit pas porte le sens
6. **Stub .tscn = note Markdown** — pas de binaire
