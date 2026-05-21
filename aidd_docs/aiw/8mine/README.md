# Pipeline 8-MINE — Idée → Premier jet abouti

Adaptation AIW pour le jeu narratif Godot/Dialogic.
Unité de travail = **un arc** (PRO, A1, A2-romance-X, A3, A4, FIN-*) composé de plusieurs NODES.

---

## Workflow

Le pipeline n'est pas strictement linéaire — `write-dtl --feedback`, `review-persona`, `node-manage --update` se bouclent entre eux. La séquence ci-dessous décrit le **chemin nominal** d'un arc.

```
[Setup]         init-bank          → bank.yml (+ scaffold overview.md si absent)
                challenge-bank     → rapport lore↔code

[Conception]    brainstorm + upgrade  → overview.md (400-500 l., projet entier)

[Production arc — boucle de profusion + élagage]
  arc-spec               overview + ARC_ID  → arcs/<ARC>.md
  decompose-arc          arc-spec           → nodes/NN.md × N (output_style + table Transitions)
  write-dtl              node-spec          → .dtl + linter PASS
  review-persona --light 1 persona          → pré-review rapide (filtre)
  review-persona         matrice complète   → review-report.md
  doctor / write-dtl --feedback             → .dtl validés

[Transverse — à invoquer à tout moment]
  node-manage   list / status / update / retire d'un node
  graph-audit   validation structurelle du graphe narratif
```

| Phase | Durée | Prompt | Output |
|-------|-------|--------|--------|
| Setup | 5 min | `init-bank` | `bank.yml` |
| Audit | 5 min | `challenge-bank` | Rapport intégrité lore↔code |
| Conception | itératif | `brainstorm` + `upgrade` (workshop) | `overview.md` |
| Arc spec | 30 min | `arc-spec` | `arc-spec.md` |
| Décomposition | 20 min | `decompose-arc` | `nodes/NN.md` × N |
| Écriture | 30-45 min | `write-dtl` × N + linter | `.dtl` × N |
| Pré-review | 10 min | `review-persona --light` | Pré-review rapide |
| Review complète | 20 min | `review-persona` × 2-3 | `review-report.md` |
| Rewrite | 10-30 min | `doctor` ou `write-dtl --feedback` | `.dtl` validés |

---

## Garde-fous

- **NODE ≠ chapitre AIW autonome** → table `Transitions` du node-spec déclare flags entrants/sortants + next nodes ; `graph-audit` valide le graphe.
- **Output-style par node** → chaque node-spec déclare `output_style:` (défaut `scenario`). Le rédactionnel n'est plus global mais paramétrable.
- **Linter mécanique avant LLM** → `scripts/tools/dtl_linter.gd` vérifie variables/flags/factions/signaux/dispatchers. Aucun `.dtl` ne sort de `write-dtl` sans linter PASS.
- **Branches multi-fins** → review matricielle (NODE × persona × branche), pas de score scalaire global.
- **Pas d'auto-génération `.tscn`/`.gd`** → seuls les `.dtl` sont produits. Stubs `.tscn` templatés en sortie de `write-dtl`, finalisés à la main dans Godot.
- **6 personas disponibles** → `margot-joueuse`, `dramaturge`, `playtester-lgbtqia`, `critique-indie-narratif`, `coauteur-ia`, `playtester-accessibilite`. Choisir 2-3 par review selon le risque ; le persona "Dev-Code" est remplacé par le linter.
- **Playtest reste autorité finale** → ce pipeline produit un *premier jet abouti*, pas un produit fini.

---

## Invocations typiques

```
# Setup + audit
@aidd_docs/aiw/8mine/prompts/init-bank.prompt.md
@aidd_docs/aiw/8mine/prompts/challenge-bank.prompt.md

# Conception (boucle)
@aidd_docs/aiw/prompts/workshop/brainstorm.prompt.md aidd_docs/aiw/8mine
@aidd_docs/aiw/prompts/workshop/upgrade.prompt.md aidd_docs/aiw/8mine

# Production d'un arc
@aidd_docs/aiw/8mine/prompts/arc-spec.prompt.md PRO
@aidd_docs/aiw/8mine/prompts/decompose-arc.prompt.md aidd_docs/memory/external/arcs/PRO.md
@aidd_docs/aiw/8mine/prompts/write-dtl.prompt.md aidd_docs/memory/external/nodes/02.md
@aidd_docs/aiw/8mine/prompts/review-persona.prompt.md dialogic/timelines/pro_cellule.dtl margot-joueuse --light
@aidd_docs/aiw/8mine/prompts/review-persona.prompt.md dialogic/timelines/pro_cellule.dtl dramaturge

# Transverse
@aidd_docs/aiw/8mine/prompts/node-manage.prompt.md --list
@aidd_docs/aiw/8mine/prompts/graph-audit.prompt.md
```

Écriture parallèle : lancer N agents `claude` avec chacun un NODE à écrire via `write-dtl`.

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

PRO-02 est déjà spécifié dans `aidd_docs/memory/external/nodes/02.md`. On peut entrer directement à l'écriture et tester le flow à partir de `write-dtl`.
