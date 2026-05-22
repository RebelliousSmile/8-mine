---
name: scene-spec
description: Production 8-MINE. Spécifier une scène-type réutilisable avec ses sujets et événements de seuil.
argument-hint: <SCENE_ID> [--overview <chemin>]
version: 1.0
---

# Scene Spec — Overview → Scène développée

## Goal

Produire un `scene-spec.md` pour **une scène-type** (dîner, nuit cellule, coursive, atelier, poste technique…), à partir de l'**overview du projet** et des `pnj-behavior` des PNJs concernés. Cette scene-spec sert de contrat pour `write-dtl` qui produira le `.dtl` jouable.

L'overview reste la source de vérité macroscopique ; les `pnj-behavior` portent la voix par palier et les événements de seuil ; la scene-spec est la matrice locale d'interaction.

**Modèle narratif (cf. `overview.md § Architecture narrative`)** :
```
SCÈNE → SUJETS modifient JAUGES → SEUIL franchi déclenche ÉVÉNEMENT (one-shot) → DÉVERROUILLE contenu
```

## Context

**Scène à développer** : `$ARGUMENTS[0]` *(ex : `diner_arrivee`, `cellule_nuit`, `coursive_residents`)*

**Overview projet (source primaire)** :
```markdown
@aidd_docs/memory/external/overview.md
```

**Ressources canon (OBLIGATOIRES)** :
```
@aidd_docs/memory/external/bible-jeu.md
@aidd_docs/memory/internal/architecture.md
@aidd_docs/memory/internal/variables-register.md
```

**PNJ-behaviors existants (consommés)** :
```
@aidd_docs/memory/external/pnjs-behavior/
```

**Template de sortie** :
```
@aidd_docs/aiw/8mine/templates/scene-spec.md
```

## Process

### Step 1 — Cadrage de la scène

- Type : récurrente ou unique ?
- Acte(s) où elle peut se jouer
- Conditions narratives d'apparition
- Cooldown / cap si récurrente

### Step 2 — Inventaire des PNJs présents

Pour chaque PNJ susceptible d'être présent :
- Condition de présence (toujours / sous flag X / si relation Y / tirage narratif)
- Sprite par défaut
- Croiser avec `pnj-behavior/<pnj>.md` existants — si manquant, signaler (la scene-spec dépend du PNJ-behavior pour les répliques par palier)

### Step 3 — Déclarer le scope des jauges activables

**Section obligatoire**. Lister explicitement les jauges que cette scène peut modifier. Aucun sujet ne pourra modifier une jauge hors-scope (verrou de design, vérifié par graph-audit).

Justifier chaque jauge incluse : pourquoi cette scène la touche, dans quelle plage de delta.

### Step 4 — Dialogues d'ambiance

Pseudocode Dialogic :
- Intro à l'entrée (Margot arrive)
- Ambiance sonore / environnementale
- Outro à la sortie

### Step 5 — Lister les sujets disponibles

3-6 sujets typiques. Pour chaque sujet :
- Libellé court (visible côté joueur)
- Condition d'apparition (jauges, flags, paliers)
- Cible (PNJ spécifique / tous PNJs présents / Margot seule)
- Effets de base sur jauges
- Cap d'utilisation
- **Table de réponses** : pour chaque PNJ susceptible d'être ciblé × chaque palier pertinent → réplique (résumé) + effets supplémentaires

**Règle d'or** : un sujet ne peut pas exister sans poser au moins un changement d'état (jauge ou flag). Cf. règle canon Margot terrain neutre — pas de sujet "ne rien faire" sans effet.

### Step 6 — Inventorier les événements de seuil susceptibles de s'y jouer

Pour chaque PNJ présent, lister ses événements de seuil (depuis `pnj-behavior/<pnj>.md`) qui peuvent se déclencher dans le contexte de cette scène. Documenter le mode (immédiat ou différé).

### Step 7 — Conditions de sortie

- Cap sujets par visite (en général 2-4)
- Forced exit narratif si applicable

### Step 8 — Risques structurels

3 risques :
- Sujet jamais déclenchable (condition trop stricte) ?
- Saturation : trop de sujets visibles en même temps ?
- Combinaison de sujets qui pousse une jauge hors plage déclarée ?

## Output

Écrire `aidd_docs/memory/external/scenes/<SCENE_ID>.md` au format `scene-spec.md`.

Si `scenes/` n'existe pas, le créer.

## Validation locale

- [ ] Toutes les jauges modifiées par les sujets sont déclarées dans la table « Jauges activables »
- [ ] Aucune jauge hors-scope touchée
- [ ] Toutes les jauges existent dans `variables-register.md`
- [ ] Toutes les factions citées sont parmi les 8 valides
- [ ] Tous les `pnj-behavior` référencés existent (sinon flagger en risque)
- [ ] Aucun sujet sans effet
- [ ] Tables de réponses couvrent au moins Méfiance, Neutre, Allié, Confident pour les PNJ-cibles
- [ ] Verrous canon des pnj-behavior respectés

## Rules

1. **Pas de dialogue intégral** — c'est le rôle de `write-dtl`. Les répliques sont résumées dans les tables.
2. **Pas de "sujet neutre"** — chaque sujet doit avoir des effets concrets.
3. **Verrous canon = sacrés** — toujours consulter les `pnj-behavior` pour les phrases/comportements interdits.
4. **Scope jauges = contrat** — déclaré en Step 3, vérifié en validation. Un sujet ne peut pas violer ce scope.
5. **Stakes joueur explicites** — si on ne peut pas dire ce qui se gagne/perd en choisissant un sujet, le sujet est faux.
