---
name: pnj-behavior
description: Production 8-MINE. Spécifier le catalogue de comportement d'un PNJ à travers les paliers de relation et les événements de seuil.
argument-hint: <PNJ_ID> [--overview <chemin>]
version: 1.0
---

# PNJ Behavior — Overview → Catalogue PNJ

## Goal

Produire un `pnjs-behavior/<pnj>.md` pour **un PNJ** des 17 canon, à partir de `bible-jeu.md` + `overview.md` + design rules. Ce fichier est consommé par `scene-spec` (pour les répliques par palier) et `write-dtl` (pour les voix).

**Modèle narratif (cf. `overview.md § Architecture narrative`)** :
```
SCÈNE → SUJETS modifient JAUGES → SEUIL franchi déclenche ÉVÉNEMENT (one-shot) → DÉVERROUILLE contenu
```

Un `pnj-behavior` décrit le **comportement traversant** d'un PNJ : sa voix à chaque palier, ses événements de seuil, ses verrous canon.

## Context

**PNJ à spécifier** : `$ARGUMENTS[0]` *(ex : `emma`, `frank`, `sofia`)*

**Sources canon (OBLIGATOIRES)** :
```markdown
@aidd_docs/memory/external/overview.md
@aidd_docs/memory/external/bible-jeu.md
@aidd_docs/memory/internal/variables-register.md
```

**Design rules spécifiques (si existent)** :
```
@aidd_docs/memory/internal/design-rules/
```

**Template de sortie** :
```
@aidd_docs/aiw/8mine/templates/pnj-behavior.md
```

## Process

### Step 1 — Identité et verrous canon

- Tier, corpo, sprite_set, ID Dialogic, variable de prénom
- Lister explicitement TOUS les verrous canon (phrases interdites, comportements interdits, conditions hard) extraits de `bible-jeu.md` + design rules + overview
- Identifier si sensitivity reader requis (LGBTQIA+, persona spécifique)

### Step 2 — Voix par palier

Pour chacun des 9 paliers (Ennemi juré → Fusionnel), décrire :
- Registre vocal (ex. "analytique → accusateur → protectrice" pour Sofia)
- Vocabulaire / lexique typique
- Ton physique (attitude corporelle)

Marquer explicitement les paliers structurellement inaccessibles par canon (ex. *« Camille ne va jamais à Fusionnel — sa nature de profileuse exclut la fusion »*).

### Step 3 — Événements de seuil

Pour chaque seuil de relation significatif (Favorable, Allié, Confident en général ; parfois Méfiance basse), définir un événement de seuil one-shot :
- Conditions de déclenchement (palier franchi + contexte + jauges/flags)
- Mode (immédiat ou différé/buffered)
- Réaction scriptée (résumé — la formulation exacte se valide en `tone-finder` ultérieur)
- Déverrouillage (sujets / scènes / actions ajoutés au pool)

**Règle** : tous les paliers n'ont pas nécessairement un événement. Concentrer sur les paliers significatifs du PNJ. Au minimum un événement à Confident (le seuil intime maximal accessible canon pour la plupart des PNJs).

**Type de seuil** : par défaut `montée` (hausse de palier, monotone, one-shot). Si un événement déclenche aussi sur `descente` (chute de palier après pacte par exemple), le déclarer explicitement.

### Step 4 — Hooks scènes

Lister les scènes-types où ce PNJ apparaît typiquement (`scenes/*.md` ou à spec) avec ses actions génériques par palier dans ce contexte.

### Step 5 — Risques structurels

3 risques :
- Verrou canon qui contredit un événement de seuil ?
- Palier inatteignable mécaniquement vu les contraintes (relation max bornée par flag externe par exemple) ?
- Sensitivity reader requis et déjà identifié ?

## Output

Écrire `aidd_docs/memory/external/pnjs-behavior/<pnj>.md`.

Si `pnjs-behavior/` n'existe pas, le créer.

## Validation locale

- [ ] Les 9 paliers ont une voix décrite (ou marqués inaccessibles avec justification canon)
- [ ] Au moins 1 événement de seuil par palier significatif (typiquement Confident, parfois Allié)
- [ ] Verrous canon explicites et alignés avec `bible-jeu.md` + design rules
- [ ] Hooks scènes pointent vers `scenes/` existants ou à créer (flagger si à créer)
- [ ] Sensitivity reader identifié si applicable

## Rules

1. **Verrous canon = sacrés** — toute scène/sujet qui les viole en aval doit être refusé en review. Les lister exhaustivement ici.
2. **Pas de dialogue intégral** — les formulations seuils sont des résumés, pas des `.dtl`.
3. **Cohérence avec voix existante** — si le PNJ a déjà des répliques dans les NODES PRO-01/02 ou `session-exemple-01.md`, sa voix par palier doit s'aligner.
4. **Une fiche par PNJ** — si la canon est dense, le fichier peut faire plusieurs pages. Pas de scission par sous-aspect.
5. **Événements monotones** — par défaut, les événements sont one-shot par run, déclenchés sur hausse de palier uniquement. Tout événement sur descente doit être explicité.
