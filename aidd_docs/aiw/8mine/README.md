# Pipeline 8-MINE — Idée → Premier jet abouti

Adaptation AIW pour le jeu narratif Godot/Dialogic.
Unité de travail = **un arc** (PRO, A1, A2-romance-X, A3, A4, FIN-*) composé de plusieurs NODES.

---

## Workflow

```
[Setup bank]    00-init-bank          → bank.yml
[Audit]         00-challenge-bank     → rapport lore↔code

[Conception]    brainstorm + upgrade  → overview.md (400-500 l., projet entier)

[Production arc]
  Stage 1   01-arc-spec       (overview + ARC_ID → arc-spec.md)
  Stage 2   02-decompose-arc  (arc-spec → nodes/NN.md × N, avec output_style + table Transitions)
  Stage 3   03-write-dtl      (node-spec + output-style → .dtl + linter PASS)
  Stage 4a  04-review-persona --light  (1 persona, lecture rapide)
  Stage 4b  04-review-persona          (matrice complète, 2-3 personas)
  Stage 5   doctor / rewrite via 03-write-dtl --feedback

[Transverse]
  node-manage   (list / status / update / retire)
  graph-audit   (validation structurelle du graphe narratif)
```

| Étape | Durée | Acteur | Output |
|-------|-------|--------|--------|
| Setup bank | 5 min | `00-init-bank` | `bank.yml` |
| Audit | 5 min | `00-challenge-bank` | Rapport intégrité lore↔code |
| Conception | itératif | `brainstorm` + `upgrade` (workshop) | `overview.md` |
| Stage 1 | 30 min | `01-arc-spec` | `arc-spec.md` |
| Stage 2 | 20 min | `02-decompose-arc` | `nodes/NN.md` × N |
| Stage 3 | 30-45 min | `03-write-dtl` × N + linter | `.dtl` × N |
| Stage 4a | 10 min | `04-review-persona --light` | Pré-review rapide |
| Stage 4b | 20 min | `04-review-persona` × 2-3 | `review-report.md` |
| Stage 5 | 10-30 min | `doctor` ou `03-write-dtl --feedback` | `.dtl` validés |

---

## Garde-fous

- **NODE ≠ chapitre AIW autonome** → table `Transitions` du node-spec déclare flags entrants/sortants + next nodes ; `graph-audit` valide le graphe.
- **Output-style par node** → chaque node-spec déclare `output_style:` (défaut `scenario`). Le rédactionnel n'est plus global mais paramétrable.
- **Linter mécanique avant LLM** → `scripts/tools/dtl_linter.gd` vérifie variables/flags/factions/signaux/dispatchers. Aucun `.dtl` ne sort de Stage 3 sans linter PASS.
- **Branches multi-fins** → review matricielle (NODE × persona × branche), pas de score scalaire global.
- **Pas d'auto-génération `.tscn`/`.gd`** → seuls les `.dtl` sont produits. Stubs `.tscn` templatés en sortie de Stage 3, finalisés à la main dans Godot.
- **6 personas disponibles** → `margot-joueuse`, `dramaturge`, `playtester-lgbtqia`, `critique-indie-narratif`, `coauteur-ia`, `playtester-accessibilite`. Choisir 2-3 par review selon le risque ; le persona "Dev-Code" est remplacé par le linter.
- **Playtest reste autorité finale** → ce pipeline produit un *premier jet abouti*, pas un produit fini.

---

## Invocations typiques

```
# Setup + audit
@aidd_docs/aiw/8mine/prompts/00-init-bank.prompt.md
@aidd_docs/aiw/8mine/prompts/00-challenge-bank.prompt.md

# Conception (boucle)
@aidd_docs/aiw/prompts/workshop/brainstorm.prompt.md aidd_docs/aiw/8mine
@aidd_docs/aiw/prompts/workshop/upgrade.prompt.md aidd_docs/aiw/8mine

# Production d'un arc
@aidd_docs/aiw/8mine/prompts/01-arc-spec.prompt.md PRO
@aidd_docs/aiw/8mine/prompts/02-decompose-arc.prompt.md aidd_docs/memory/external/arcs/PRO.md
@aidd_docs/aiw/8mine/prompts/03-write-dtl.prompt.md aidd_docs/memory/external/nodes/02.md
@aidd_docs/aiw/8mine/prompts/04-review-persona.prompt.md dialogic/timelines/pro_cellule.dtl margot-joueuse --light
@aidd_docs/aiw/8mine/prompts/04-review-persona.prompt.md dialogic/timelines/pro_cellule.dtl dramaturge

# Transverse
@aidd_docs/aiw/8mine/prompts/node-manage.prompt.md --list
@aidd_docs/aiw/8mine/prompts/graph-audit.prompt.md
```

Stage 3 parallèle : lancer N agents `claude` avec chacun un NODE à écrire.

---

## Ressources canon chargées par les prompts

| Ressource | Rôle |
|-----------|------|
| `aidd_docs/memory/external/overview.md` | Vue projet (400-500 l., piloté par `brainstorm`) |
| `aidd_docs/memory/external/bible-jeu.md` | Vision créative · cast · DA |
| `aidd_docs/memory/external/architecture.md` | Conventions · variables · NODE format |
| `aidd_docs/memory/external/history.md` | Arborescence narrative · 9 fins |
| `aidd_docs/memory/internal/api-cheatsheet.md` | Commandes DialogicBridge · API GDScript |
| `aidd_docs/memory/internal/variables-register.md` | Flags · factions · countdowns |
| `aidd_docs/aiw/8mine/templates/output-styles/` | Styles rédactionnels (défaut : `scenario.md`) |

---

## Test du pipeline : PRO-02

PRO-02 est déjà spécifié dans `aidd_docs/memory/external/nodes/02.md`. On peut entrer directement au **Stage 3** et tester le flow à partir de `03-write-dtl`.
