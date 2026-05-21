---
name: 01-arc-spec
description: Stage 2 du pipeline 8-MINE. Dérive un arc-spec court d'un overview projet.
argument-hint: <ARC_ID> [--overview <chemin>]
version: 1.1
---

# Arc Spec — Overview → Arc développé

## Goal

Produire un `arc-spec.md` (3-5 pages) pour **un seul arc** (PRO, A1, A2-romance-X, A3, A4, FIN-*),
à partir de l'**overview du projet**. Cet arc-spec sert de contrat pour le découpage en NODES
en Stage 3. Il doit être **structuré, testable, et vérifiable par le persona Dramaturge**.

L'overview reste la source de vérité macroscopique ; l'arc-spec est sa déclinaison locale pour
un arc donné.

## Context

**Arc à développer** : `$ARGUMENTS[0]` (ID arc, ex : `PRO`, `A1`, `A2-romance-aiko`)

**Overview projet (source primaire)** :
```markdown
@aidd_docs/memory/external/overview.md
```

(ou chemin alternatif passé via `--overview <chemin>`)

**Ressources canon (OBLIGATOIRES) :**
```
@aidd_docs/memory/external/bible-jeu.md
@aidd_docs/memory/external/history.md
@aidd_docs/memory/external/architecture.md
@aidd_docs/memory/internal/variables-register.md
```

**Template de sortie :**
```
@aidd_docs/aiw/8mine/templates/arc-spec.md
```

## Process

### Step 1 — Localiser l'arc dans l'overview

Lire l'overview, trouver la section qui mentionne l'arc demandé (`$ARGUMENTS[0]`).
Identifier :
- Position dans l'arborescence (acte, scène, fin visée)
- Prémisse locale (ce que cet arc fait avancer)
- Stakes joueur spécifiques à cet arc
- Fins potentiellement ouvertes/fermées par cet arc
- Arc émotionnel attendu

Si l'arc n'apparaît pas dans l'overview → STOP. Soit l'overview est incomplet (le compléter
via `brainstorm`/`upgrade`), soit l'ID arc est mauvais.

### Step 2 — Inventaire des préconditions

Pour chaque variable mentionnée dans l'overview pour cet arc (PNJs, lieux, jauges) :
- Vérifier qu'elle existe dans `variables-register.md`
- Si elle est nouvelle, la déclarer dans la section "Préconditions" de l'arc-spec
- Mapper : qu'est-ce qui DOIT être vrai avant cet arc ? D'où ça vient (arc amont) ?

### Step 3 — Décomposition en beats

Produire 3 à 7 beats. Chaque beat = un événement narratif avec :
- Lieu (vérifier qu'il existe ou doit être créé)
- PNJs présents
- Niveau de tension (montée / pic / chute)
- Lien explicite avec un beat suivant

**Règle d'or** : un beat ne peut pas exister sans poser au moins un changement d'état
(flag, jauge, relation). Sinon c'est du remplissage.

### Step 4 — Branches majeures

Identifier les points de bifurcation. Pour chaque branche :
- Effets sur jauges (MS, PD, EV, Surveillance, Miroir)
- Effets sur réputation (factions concrètes parmi les 8)
- Fins ouvertes / fermées
- NODE de destination

**Contrainte** : pas de branche neutre. Chaque option déplace au moins une jauge.

### Step 5 — Postconditions

Pour chaque branche, lister les flags garantis en sortie. Format strict :
```yaml
flag_<nom>: <valeur>
```

### Step 6 — Liste des NODES à produire

Inventorier les NODES nécessaires. Pour chaque NODE :
- ID conforme à la convention (`<ARC>-NN` ou `<ARC>-NN-<modifier>`)
- Rôle dans l'arc (exposition / confrontation / résolution)
- Complexité (simple / moyen / dense)
- Nombre de choix

### Step 7 — Identifier les risques structurels

Avant de finaliser, lister 3 risques potentiels :
- Fin laissée orpheline ?
- PNJ utilisé hors de son arc personnel ?
- Jauge poussée trop haut/bas ?

Ces risques alimentent la review Dramaturge en Stage 5.

## Output

Écrire `aidd_docs/memory/external/arcs/<ARC_ID>.md` au format `arc-spec.md`.

Si `aidd_docs/memory/external/arcs/` n'existe pas, le créer.

## Validation locale

Avant de rendre, vérifier :

- [ ] Toutes les jauges mentionnées existent dans `variables-register.md`
- [ ] Toutes les factions citées sont parmi les 8 valides
- [ ] Les fins citées sont parmi A-I
- [ ] Tous les NODES proposés ont un ID unique
- [ ] Aucune branche ne mène à un cul-de-sac sans flag de sortie

## Rules

1. **Ne jamais inventer de variable** — toujours croiser avec `variables-register.md`
2. **Ne pas écrire de dialogue** — c'est le rôle de Stage 4 (`03-write-dtl`)
3. **Pas de jauge "neutre"** — chaque branche doit avoir des effets concrets
4. **Stakes joueur explicites** — si on ne peut pas dire ce qui se perd ou se gagne, le beat est faux
5. **Output unique = arc-spec.md** — pas de .dtl, pas de .tscn à ce stade
