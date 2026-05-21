---
name: graph-audit
description: Audit structurel du graphe narratif 8-MINE. Détecte flags orphelins, branches cassées, fins inatteignables.
argument-hint: [--scope all|<ARC_ID>] [--export mermaid|dot] [--lint]
version: 1.0
---

# Graph Audit — Validation structurelle du graphe narratif

## Goal

Construire le **graphe complet** des transitions entre nodes (à partir des tables `Transitions`
de chaque `nodes/NN.md`) et détecter les anomalies structurelles AVANT écriture ou playtest.

**Complémentaire de** `challenge-bank` :
- `challenge-bank` audite **lore ↔ code** (PNJ canon, dispatchers, factions)
- `graph-audit` audite **structure narrative** (flags croisés, branches, fins, cycles)

**Quand l'invoquer** :
- Après `decompose-arc` (vérifier que la décomposition tient)
- Avant `write-dtl` (s'assurer qu'aucun node ne pointe dans le vide)
- Après chaque `node-manage --update` ou `--retire` (cascade d'impact)
- En continu pendant l'écriture multi-arcs

## Context

**Specs de nodes (source primaire)** :
```
@aidd_docs/memory/external/nodes/
```

**Arc-specs (pour rattachement node ↔ arc)** :
```
@aidd_docs/memory/external/arcs/
```

**Fins canoniques (source de vérité)** :
```
@aidd_docs/memory/external/history.md
```

**Variables canon** :
```
@aidd_docs/memory/internal/variables-register.md
```

**Source de vérité côté code** :
```
@scripts/tools/dtl_linter.gd
```

**Timelines (optionnel, pour `--lint`)** :
```
@dialogic/timelines/
```

## Process

### Step 1 — Parser les tables `Transitions`

Pour chaque `nodes/<NN>.md`, lire la section "Transitions" et extraire les colonnes :

| Branche | Condition d'accès | Flag(s) posé(s) | Jauges | Réputation | Countdown | Next NODE | Fins fermées | Fins ouvertes |

Construire une structure interne :

```python
node = {
  "id": "PRO-02",
  "arc": "PRO",
  "branches": [
    {
      "label": "[A] Poser les micros",
      "condition": None,
      "flags_set": ["flag_micros_poses=true"],
      "gauges": ["MS-1", "PD+1"],
      "reputation": [],
      "countdown": [],
      "next": "A1-01-strategie",
      "endings_closed": ["FIN-A", "FIN-F"],
      "endings_opened": []
    },
    ...
  ],
  "flags_in": ["flag_emma_a_reveele"],  # depuis "Variables à l'entrée" + "Dépendances entrantes"
  "flags_in_sources": {"flag_emma_a_reveele": "PRO-01"}
}
```

Si la section "Transitions" est absente ou malformée → 🔴 `MISSING_TRANSITIONS`.

### Step 2 — Construire le graphe global

Sommets = nodes ; arêtes = branches (chacune typée par flags posés/consommés).

Stocker :
- `nodes_set` : tous les NN.md trouvés
- `referenced_set` : tous les `Next NODE` cités dans une branche, plus toutes les fins
- `flags_posed` : map `flag → liste de (node, branche)` qui le posent
- `flags_consumed` : map `flag → liste de (node)` qui le consomment via Dépendances entrantes
- `endings_declared` : ensemble des fins listées dans `history.md`
- `endings_opened` / `endings_closed` : agrégation depuis les colonnes correspondantes

### Step 3 — Détection d'anomalies

Catégoriser chaque anomalie en 🔴 (bloquant) ou 🟡 (warning).

#### 🔴 Bloquants

| Code | Détection |
|------|-----------|
| `BROKEN_NEXT` | `Next NODE` cite un ID qui n'existe pas dans `nodes/` ni dans `endings_declared` |
| `MISSING_FLAG_SOURCE` | Un flag listé dans `flags_in` n'apparaît dans aucun `flags_set` d'aucun node |
| `MISSING_TRANSITIONS` | Un node-spec n'a pas de section `Transitions` parsable |
| `UNKNOWN_ENDING` | Une `Fins ouvertes`/`Fins fermées` cite une fin absente de `history.md` |
| `UNKNOWN_FACTION` | Colonne `Réputation` cite une faction hors des 8 canon (stratom, marine, presse, police, activistes, memorize, nexus, kaizen) |
| `UNKNOWN_COUNTDOWN` | Colonne `Countdown` cite un countdown non déclaré dans `dtl_linter.gd:COUNTDOWNS_VALIDES` |
| `ORPHAN_ENDING` | Fin déclarée dans `history.md` jamais ouverte par aucune branche |
| `UNREACHABLE_NODE` | Un node n'est cible d'aucun `Next NODE` (sauf nodes-racines d'arc explicitement déclarés) |

#### 🟡 Warnings

| Code | Détection |
|------|-----------|
| `UNCONSUMED_FLAG` | Un flag posé n'est jamais consommé en aval (sauf flags terminaux d'arc `arc_<X>_termine`) |
| `CYCLE` | Le graphe contient un cycle non explicitement déclaré dans l'arc-spec |
| `DENSE_NODE` | Un node a > 4 branches sortantes (risque de surcharge cognitive) |
| `THIN_NODE` | Un node `dense` n'a pas le nombre de branches déclaré (signaler désync spec ↔ complexité) |
| `JAUGE_SPIKE` | Une branche cumule > 3 modifications de jauges (potentiel surcharge mécanique) |
| `MISSING_OUTPUT_STYLE` | Un node-spec ne déclare pas `output_style:` (sera traité comme `scenario` par défaut, mais à expliciter) |

### Step 4 — Sortie graphe (`--export`)

Si `--export mermaid` (défaut visuel), produire un bloc Mermaid :

```mermaid
graph LR
  PRO-01 -->|[A] avouer| PRO-02
  PRO-01 -->|[B] mentir| PRO-02
  PRO-02 -->|[A] poser micros| A1-01-strategie
  PRO-02 -->|[B] refuser| A1-02-doute
  PRO-02 -->|[C] confronter| A1-01-confrontation
  PRO-02 -->|[D] miroir| A1-03-miroir
  A1-03-miroir --> FIN-G

  classDef ending fill:#f9d
  class FIN-A,FIN-G ending
```

Si `--export dot`, produire un Graphviz DOT équivalent (utile pour Obsidian).

Colorer :
- Nodes 🔴 (avec anomalies) en rouge
- Fins en violet
- Branches conditionnelles (avec `Condition d'accès`) en pointillés

### Step 5 — Passe linter (`--lint`)

Si `--lint` est passé, exécuter `scripts/tools/dtl_linter.gd` sur **tous les `.dtl`** présents dans `dialogic/timelines/` qui correspondent à un node-spec parsé :

```bash
godot --headless --path . --script scripts/tools/dtl_linter.gd -- dialogic/timelines/<scene>.dtl
```

Agréger les résultats dans le rapport. Le linter détecte des anomalies au niveau `.dtl` que `graph-audit` ne peut pas voir (typo de dispatcher, faction inconnue dans le texte du `.dtl`, etc.).

### Step 6 — Rapport synthétique

Format de sortie obligatoire :

```markdown
# Graph Audit — <YYYY-MM-DD>

## Bilan global
- Arcs scannés : <liste>
- Nodes scannés : N (dont M avec table Transitions valide)
- Branches : K
- Fins déclarées : 9 · ouvertes par ≥ 1 branche : <m>/9 · orphelines : <liste>
- Anomalies : <X bloquantes> · <Y warnings>

## 🔴 Anomalies bloquantes

### `BROKEN_NEXT`
- `PRO-02 [C]` pointe vers `A1-01-confrontation` → **node inexistant**
  - Fix : créer le node OU corriger l'ID dans la table

### `MISSING_FLAG_SOURCE`
- `A1-02 flags_in: flag_pacte_emma` → aucun node ne le pose
  - Fix : poser dans un node amont OU retirer la dépendance

### `ORPHAN_ENDING`
- `FIN-H` déclarée dans `history.md` → jamais ouverte par aucune branche
  - Fix : ajouter `FIN-H` à `Fins ouvertes` d'au moins un node

(… autres bloquants …)

## 🟡 Warnings

### `UNCONSUMED_FLAG`
- `flag_strategie_double_jeu` posé par `PRO-02 [D]` → jamais consommé
  - Action : prévu pour acte 3 ? Si oui, OK pour l'instant.

(… autres warnings …)

## Linter (si --lint passé)

| Timeline | Statut | Erreurs |
|----------|--------|---------|
| `pro_arrivee.dtl` | PASS | — |
| `pro_cellule.dtl` | FAIL | dispatcher `ms:` inconnu |

## Graphe

(bloc Mermaid ou DOT)

## Recommandations d'ordre

1. <fix bloquant 1>
2. <fix bloquant 2>
3. <fix warning haute priorité>
```

## Output

Stdout : rapport Markdown + bloc graphe.

Sur demande explicite : écrire `aidd_docs/aiw/8mine/graph-audit-<date>.md` (à committer ou pas, selon).

**Ne pas écrire dans les node-specs** — ce prompt diagnostique, il ne patche pas.
Les fixes passent par `node-manage --update` ou édition manuelle.

## Rules

1. **Audit ≠ correction** — diagnostique seulement
2. **Source de vérité = tables Transitions** — si une table est malformée, c'est `MISSING_TRANSITIONS`, pas une excuse pour deviner
3. **Fins canon = `history.md`** — pas d'invention de fin
4. **Factions canon = 8 listées** — pas d'invention de faction
5. **Anomalie sans impact connu = 🟡** — un node orphelin volontaire (ex : node d'arc futur pas encore branché) reste 🟡, à charge à l'auteur de l'acquitter
6. **`--lint` n'est PAS obligatoire** — le linter Godot peut ne pas être exécutable depuis l'environnement du prompt. Si linter indisponible, signaler dans le rapport et continuer
7. **Le rapport tient sur une page si possible** — synthétiser, agréger par catégorie

## Note méthodologique

Le graphe global est précieux à 3 moments :
1. **Après `decompose-arc`** : valider que la décomposition tient avant d'écrire
2. **Après un `node-manage --retire`** : vérifier qu'aucun flag orphelin ne reste
3. **Avant playtest** : s'assurer que les 9 fins sont toutes atteignables

Pour le quotidien, un `node-manage --list` suffit. `graph-audit` est l'outil de mise au point.
