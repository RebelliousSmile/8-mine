---
name: write-scene
description: Génère une timeline Dialogic .dtl à partir d'une scene-spec + pnj-behaviors. Linter PASS obligatoire. Auto-trigger tone-finder si seuil échantillon atteint.
argument-hint: <chemin scene-spec.md> [--feedback "<correctif>"]
version: 1.1
---

# Write Scene — Scene-spec → Timeline Dialogic

## Goal

Produire un fichier `.dtl` complet, lintable, exécutable par Dialogic 2, à partir d'une `scene-spec.md` (modèle 3 couches : scène × sujets × seuils) et des `pnj-behavior` des PNJs candidats.

**Aucune génération de `.tscn` ou `.gd`** — uniquement `.dtl` + stub `.tscn` minimal si requis.

**Complémentaire de** `write-dtl` (qui consomme une `node-spec` linéaire pour les scènes scriptées non-réutilisables : prologue, codas FIN).

## Context

**Scène à écrire** :
```markdown
@$ARGUMENTS[0]
```

**Ressources canon (OBLIGATOIRES)** :
```
@aidd_docs/memory/external/overview.md
@aidd_docs/memory/external/bible-jeu.md
@aidd_docs/memory/internal/api-cheatsheet.md
@aidd_docs/memory/internal/variables-register.md
```

**PNJ-behaviors des candidats** *(à charger dynamiquement depuis le pool déclaré dans la scene-spec)* :
```
@aidd_docs/memory/external/pnjs-behavior/<pnj>.md       (par PNJ candidat)
```

**Output-style** — dérivé du champ `output_style:` de la scene-spec :
```
@aidd_docs/aiw/8mine/templates/output-styles/<nom>.md
```
Si absent, défaut = `scenario`.

**Exemple de référence** *(arc/node-spec, à transposer)* :
```
@dialogic/timelines/pro_arrivee.dtl
```

## Process

### Step 1 — Charger la scene-spec et valider

Vérifier que toutes les sections requises sont présentes :
- Métadonnées (avec `output_style:`, `acces_requis:`, `recurring:`, `actes:`)
- Jauges activables *(scope déclaratif)*
- Variables PNJ (résolution de présence) avec pool de candidats
- Trigger d'apparition (conditions narratives + cooldown/cap)
- Dialogues d'ambiance (intro + outro avec variantes)
- Sujets disponibles avec tables de réponses par palier
- Événements de seuil susceptibles de s'y jouer

Si une section critique manque → STOP, demander.

### Step 2 — Charger les pnj-behaviors des candidats

Pour chaque PNJ du pool de candidats déclaré dans la scene-spec :
- Lire `pnjs-behavior/<pnj>.md`
- Extraire : voix par palier, verrous canon, événements de seuil cités par la scène
- Si un `pnj-behavior` manque → STOP, demander spec préalable

### Step 3 — Charger l'output-style et le feedback (si présent)

- Lire `templates/output-styles/<nom>.md` — règles de prose, lexique, typographie, format signaux
- Si `--feedback "<texte>"` est passé : identifier la portion ciblée, ne rewrite que celle-ci

### Step 4 — Structurer la timeline avec résolution PNJ

Squelette obligatoire :

```dialogic
# === SCENE : <scene_id> ===
# Acces : <acces_requis>
# Jauges activables : <liste>
# Pool PNJ : <liste candidats>

# --- RÉSOLUTION DE PRÉSENCE PNJ (au _ready) ---
# Chaque PNJ candidat évalue sa règle de présence
{if <règle_de_présence_pnj1>}
  [set var="present_pnj1" value="true"]
{endif}
# ... (répéter pour chaque candidat)

# --- VÉRIFIER LES SEUILS BUFFERÉS À INJECTER ---
{if {flag_event_<pnj>_<palier>_pending}}
  [set var="inject_event_<pnj>_<palier>" value="true"]
{endif}

# --- INTRO AMBIANCE ---
[character Portrait="..."]
[narrator] <intro variante selon flag_premiere_fois ou autre>

# --- INJECTION ÉVÉNEMENT DE SEUIL (si pending et contexte OK) ---
{if {inject_event_<pnj>_<palier>}}
  # Scène prolongée : réaction scriptée du PNJ
  [character "<pnj>" ...] 
  ...
  [signal arg="flag:event_<pnj>_<palier>_consomme:true"]
  [signal arg="flag:event_<pnj>_<palier>_pending:false"]
  # Déverrouillages
  [signal arg="flag:<déverrouillage>:true"]
{endif}

# --- MENU DES SUJETS DISPONIBLES ---
# Filtrer selon : présence PNJ, condition d'apparition, paliers, flags
{if <condition_sujet1>}
  [choice text="<libellé sujet1>"]
    # ... contenu du sujet : table de réponses par PNJ ciblé × palier
{endif}
# ... (répéter par sujet)

# --- OUTRO ---
[narrator] <outro variante selon état final>
[signal arg="lieu:<sortie>"]
```

### Step 5 — Écrire les sujets en filtrant par présence + paliers

Pour chaque sujet de la scene-spec :
- Vérifier la condition d'apparition (compose avec présence PNJ ciblé si applicable)
- Si sujet ciblant un PNJ absent → ne pas générer le sujet
- Pour chaque PNJ susceptible d'être ciblé × chaque palier : générer un bloc `{if palier:<pnj> == <palier>}` avec la réplique correspondante (depuis la table de réponses + voix du pnj-behavior)
- Émettre les signaux d'effet (jauges, flags, réputation) — référencer `api-cheatsheet.md`

### Step 6 — Brancher les signaux (respect du scope)

Pour chaque effet de sujet/réplique :
- Émettre `[signal arg="..."]` conforme à `api-cheatsheet.md`
- **Vérifier que la jauge modifiée est dans le scope déclaré** (section *Jauges activables* de la scene-spec). Si pas dans le scope → STOP, erreur de scene-spec à fixer par l'auteur avant write.

**Erreurs courantes à éviter** :
- ❌ `[signal arg="reputation:5"]` → manque la faction
- ✅ `[signal arg="reputation:stratom:+5:raison"]`
- ❌ `[signal arg="miroir:+5"]` sans raison → traçabilité perdue
- ✅ `[signal arg="miroir:+5:ecoute_voyeuriste"]`
- ❌ Modifier une jauge hors-scope → **violation contrat scene-spec**

### Step 7 — Conditions de palier

Format Dialogic pour vérifier les paliers de relation :

```dialogic
{if {relation_<pnj>_palier} == "Confident"}
  <pnj>: "Tu peux tout savoir maintenant."
{elseif {relation_<pnj>_palier} == "Allié"}
  <pnj>: "Bon. Voilà..."
{elseif {relation_<pnj>_palier} == "Favorable"}
  <pnj>: "Tu veux vraiment savoir ?"
{else}
  <pnj>: "Je préfère pas en parler ici."
{endif}
```

Notes :
- `relation_<pnj>_palier` est exposé par `RelationManager` (lecture en string lisible).
- Toujours fournir un fallback `{else}` pour les paliers les plus bas.
- Verrous canon du `pnj-behavior` doivent être appliqués (paliers inaccessibles → ne pas générer le bloc).

### Step 8 — Cap sortie et conditions de sortie

- Implémenter le cap sujets par visite (compteur Dialogic)
- Implémenter les forced exits (événement de seuil → outro spéciale, échec sortie nocturne → outro alerte)
- Émettre `[signal arg="lieu:<suivant>"]` à la sortie

### Step 9 — Stub .tscn (si point-and-click)

Si la scene-spec implique un `<scene>.tscn` :

```
# Stub à finaliser manuellement dans Godot :
# scenes/<acte>/<scene>.tscn
#
# Composition attendue :
#   - NavigableRoom (root)
#   - TextureRect (background bg_<lieu>.jpg)
#   - Hotspot × N (si point-and-click)
#   - NPC × N (selon résolution PNJ runtime)
```

**NE PAS générer le `.tscn` binaire ni le `.gd`.**

### Step 10 — Validation locale avant linter

Auto-checklist :

- [ ] Tous les `[signal arg="..."]` sont conformes à `api-cheatsheet.md`
- [ ] Aucune jauge modifiée hors du scope déclaré
- [ ] Toutes les variables `{...}` sont déclarées ou viennent d'une scène/event amont
- [ ] Tous les sujets ont une condition d'apparition correctement traduite
- [ ] Tous les PNJs cités existent dans `bible-jeu.md` + `pnj-behavior` chargés
- [ ] Tous les événements de seuil cités existent dans le pnj-behavior correspondant
- [ ] Verrous canon respectés (aucune phrase/réplique en contradiction avec un verrou)
- [ ] Acces_requis traduit *(noter en commentaire haut de fichier — la gating est vérifiée en amont par le hub de scène, pas dans le .dtl lui-même)*
- [ ] Aucun sujet sans effet de jauge/flag

### Step 11 — Lancer le linter (OBLIGATOIRE)

```bash
godot --headless --path . --script scripts/tools/dtl_linter.gd -- dialogic/timelines/<scene>.dtl
```

Le linter vérifie :
- PNJ valides
- Factions valides
- Countdowns valides
- Dispatchers valides
- Variables canon
- Format syntaxique des `[signal arg="..."]`

Si `FAIL` :
1. Lire le rapport
2. Corriger les erreurs mécaniques
3. Ré-écrire et relancer
4. Après 2 tentatives échouées → STOP et reporter à l'auteur (probable manque côté code : nouveau dispatcher, PNJ, etc.)

**Aucun `.dtl` ne sort de ce prompt en statut `FAIL`.**

### Step 12 — Auto-invocation tone-finder *(chaînage conditionnel post-linter)*

Après linter PASS, **évaluer les triggers tone-finder** sur l'output-style consommé.

### Triggers tone-finder *(write-scene side)*

1. **Output-style atteint son 3ème `.dtl` produit** : `find dialogic/timelines/ -name "*.dtl" -exec grep -l "output_style: <style>" {} \;` → si compte ≥ 3, déclencher
2. **Output-style non revu depuis > 5 `.dtl`** : vérifier version output-style vs nombre de `.dtl` produits depuis dernier bump
3. **Pattern lexical détecté automatiquement** *(grep mécanique)* :
   - `_:` italique narrator > 70% des lignes du `.dtl` produit
   - Répétitions de tournures *(« sourire bref », « regard prolongé », etc.)* > 3 fois dans le `.dtl`
   - Variabilité longueur de répliques faible *(σ < 15 caractères entre lignes)*

### Action chaînée

Si trigger activé après linter PASS, **enchaîner immédiatement** :

```
## 🎨 Auto-trigger tone-finder : <output-style>

**Raison du trigger** : <condition activée>

**Patterns lexicaux détectés** :
- <pattern 1 + fréquence>
- <pattern 2>

**Modifications proposées à l'output-style** :
- Lexique à BANNIR : `<terme>`
- Lexique à PRIVILÉGIER : `<terme>`
- Précision typographie : `<règle>`

**Bump version** : `<output-style>.md v<X.Y> → v<X.Y+1>` *(commit dédié recommandé)*
```

## Output

- `dialogic/timelines/<scene_id>.dtl` (fichier principal)
- `dialogic/timelines/<scene_id>.tscn.stub.md` *(si point-and-click — instructions de finalisation manuelle)*
- Log linter en stdout
- **Patch tone-finder en post-script si trigger** *(à commit séparément)*

## Rules

1. **Output unique = .dtl** — pas de .tscn ni .gd générés (stub markdown uniquement).
2. **Scope jauges = contrat** — un sujet qui modifie une jauge hors scope déclaré dans la scene-spec → STOP. C'est une erreur de spec, à fixer en amont.
3. **Verrous canon = sacrés** — toute réplique en contradiction avec un verrou pnj-behavior → STOP.
4. **Pas d'invention de variable** — toute nouvelle variable doit être ajoutée à `variables-register.md` par l'auteur avant write.
5. **Présence PNJ = résolue runtime** — toujours générer le bloc de résolution au `_ready` de la scène, jamais hard-coder la présence dans le corps du .dtl.
6. **Événements de seuil = injectés au début** — toujours vérifier les pending au début, jouer l'événement avant le menu des sujets si conditions OK.
7. **Pas de tutoriel déguisé** — ne pas expliquer Néo-Paris au joueur.
8. **Sous-texte > exposition** — ce qu'on ne dit pas porte le sens.
9. **Référence stricte API** — `api-cheatsheet.md` est source unique pour la syntaxe des signaux.
