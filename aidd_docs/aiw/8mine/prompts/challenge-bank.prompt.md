---
name: challenge-bank
description: Audit d'intégrité de la bank lore et des liens canon ↔ code.
argument-hint: [--strict] [--scope lore|code|tout]
version: 1.1
---

# Challenge Bank — Audit d'intégrité avant écriture

## Goal

Vérifier que les ressources canon (memory bank), les déclarations dans le code (managers,
linter), et les promesses narratives (pitch, nodes, history) **convergent**. Détecter les
liens cassés AVANT d'écrire une timeline.

**Quand l'invoquer** :
- Après `brainstorm` / mise à jour de la pitch
- Avant `arc-spec` sur un nouvel arc
- Régulièrement pour signaler les dérives entre canon écrit et code implémenté
- Après ajout d'un PNJ, d'une faction, d'un countdown, ou d'un dispatcher

## Context

**Sources canon (lore)** :
```
@aidd_docs/memory/external/bible-jeu.md
@aidd_docs/memory/external/history.md
@aidd_docs/memory/external/pnjs-secondaires.md
@aidd_docs/memory/external/nodes/
```

**Sources canon (code)** :
```
@aidd_docs/memory/internal/architecture.md
@aidd_docs/memory/internal/api-cheatsheet.md
@aidd_docs/memory/internal/variables-register.md
@aidd_docs/memory/internal/etat-prod.md
@scripts/tools/dtl_linter.gd
@autoload/DialogicBridge.gd
@autoload/CharacterRegistry.gd
@autoload/ReputationManager.gd
@autoload/CountdownManager.gd
```

**Timelines existantes** :
```
@dialogic/timelines/
```

## Process

### Step 1 — Inventaire des entités canon

Extraire des sources lore :
- Tous les **PNJ** mentionnés (bible-jeu + pnjs-secondaires + history)
- Toutes les **factions** mentionnées
- Tous les **lieux** mentionnés
- Tous les **countdowns** mentionnés
- Toutes les **fins** déclarées dans history.md
- Toutes les **variables** référencées dans les nodes/*.md (MS, PD, EV, miroir, surveillance, etc.)

Extraire du code :
- `PNJ_VALIDES` de `dtl_linter.gd`
- `FACTIONS_VALIDES` de `dtl_linter.gd` (croiser avec `ReputationManager.FACTION_DEFINITIONS`)
- `COUNTDOWNS_VALIDES` de `dtl_linter.gd` (croiser avec `CountdownManager`)
- `DISPATCHERS_VALIDES` de `dtl_linter.gd` (croiser avec `DialogicBridge._on_signal_event()`)
- `VARIABLES_CANON` de `dtl_linter.gd` (croiser avec `GameStateManager`)
- PNJ déclarés dans `CharacterRegistry.gd`

### Step 2 — Détection de dérives

Pour chaque catégorie, produire :

| Catégorie | Dans lore | Dans code | Diff |
|-----------|-----------|-----------|------|
| PNJ | A, B, C, D | A, B, C | **D manquant côté code** |
| Factions | … | … | … |
| Lieux | … | … | … |
| Countdowns | … | … | … |
| Dispatchers (promis par nodes) | … | … | … |
| Variables (utilisées par nodes) | … | … | … |
| Fins | … (déclarées) | … (atteintes par flags) | … (orphelines) |

**Cas critiques à flagger** :

1. **PNJ cité par un node mais absent de `PNJ_VALIDES`** → le linter warn et le `.dtl` plantera silencieusement
2. **Faction citée par un node mais absente de `FACTIONS_VALIDES`** → blocage `write-dtl`
3. **Effet promis par un node (ex : MS+1) mais dispatcher absent de `DISPATCHERS_VALIDES`** → cause racine du verdict 🔴 PRO-02
4. **Fin déclarée dans history.md mais aucune branche ne pose le flag de sortie** → fin orpheline
5. **Variable utilisée dans un node mais absente de `VARIABLES_CANON` et non-flag** → warning linter
6. **Lieu cité par un node mais aucun `.tscn` correspondant** → transition `lieu:` cassée à l'exécution

### Step 3 — Vérification des `bank.yml` (personas)

Pour chaque persona dans `8mine/personas/*.yml` :

- [ ] `reference_documents:` listés existent tous sur disque
- [ ] La `loading_strategy: from_bank_yml` est cohérente avec ce que le prompt `review-persona` charge
- [ ] Les critères de scoring ont des poids qui somment à 100%

### Step 4 — Vérification des `deal-breakers-log`

Lister les DB ouverts (statut ⚠️ ou 🔴) qui bloquent l'écriture :
- DB-08 (dispatchers `bg:`/`show_char:`/`goto_scene:` fictifs)
- DB-XX si nouveaux

Pour chaque DB ouvert, indiquer **quels nodes/arcs sont bloqués** par lui.

### Step 5 — Rapport

Format de sortie obligatoire :

```markdown
# Challenge Bank — <date>

## Bilan global
- Entités lore : N
- Entités code : M
- Dérives détectées : K (dont J bloquantes 🔴)

## Dérives bloquantes 🔴

### <Catégorie 1>
- **<Entité>** : cité par <source lore> mais absent de <source code>
  - Impact : <quels nodes/arcs sont impactés>
  - Fix : <ajouter à X.gd ou retirer du lore>

## Dérives non-bloquantes 🟡

(idem)

## Personas — État

| Persona | reference_documents OK | Poids = 100% | Statut |
|---------|------------------------|--------------|--------|
| margot-joueuse | ✅ | ✅ | OK |
| dramaturge | ✅ | ✅ | OK |
| … | … | … | … |

## Deal-breakers ouverts qui bloquent l'écriture

- DB-XX : <résumé> → bloque <nodes>

## Recommandations d'ordre

1. <action prioritaire>
2. <…>
```

## Output

Stdout : rapport Markdown. **Ne pas écrire de fichier** — l'auteur décide quoi committer.

Optionnellement, sur demande explicite : écrire `aidd_docs/aiw/8mine/challenge-bank-<date>.md`.

## Rules

1. **Audit ≠ correction** — ce prompt diagnostique, il ne patche pas. Les corrections passent par les fichiers source (`api-cheatsheet.md`, `DialogicBridge.gd`, etc.).
2. **Source de vérité côté code = `dtl_linter.gd`** — il est exécutable et donc factuel. Si lore et linter divergent, c'est au lore de s'aligner OU au linter d'être mis à jour, mais jamais aux deux d'être incohérents.
3. **Une dérive sans impact connu = 🟡, pas 🔴** — un PNJ secondaire mentionné une fois dans history sans node prévu n'est pas bloquant.
4. **Le rapport doit pouvoir tenir sur une page** — synthétiser, ne pas tout lister.

## Note historique

Ce prompt remplace un éventuel `challenge.prompt.md` historique non-commité. Spécialisé
8-MINE : il connaît les 8 dispatchers, les 8 factions, et le couplage `dtl_linter` ↔ canon.
