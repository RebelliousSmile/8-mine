---
name: 04-review-persona
description: Stage 4/5 du pipeline 8-MINE. Review d'un .dtl par un persona — mode complet ou light.
argument-hint: <chemin .dtl> <persona-name> [--node-spec <chemin>] [--light]
version: 1.1
---

# Review Persona — .dtl + spec → Verbatims + Triage

## Goal

Faire jouer un persona (Margot-joueuse OU Dramaturge) à travers chaque branche
d'un NODE et produire :
- Scores /20 par branche
- Verbatims (citations + réactions)
- 3 faiblesses ou risques minimum (avocat du diable)
- Triage 🟢/🟡/🔴 par branche

**Ne pas confondre avec `comment.prompt.md` (AIW générique)** — celui-ci est
spécialisé pour les .dtl Dialogic + jauges 8-MINE.

## Context

**Timeline à reviewer :**
```
@$ARGUMENTS[0]
```

**Persona à incarner :**
```yaml
@aidd_docs/aiw/8mine/personas/$ARGUMENTS[1].yml
```

**Spec du NODE (recommandée pour `dramaturge` et `coherence-checker`) :**
```
@$ARGUMENTS[2]
```

**Personas disponibles :**
- `margot-joueuse` — voix de la joueuse cible (crédibilité, sous-texte)
- `dramaturge` — structure (préconditions, postconditions, jauges, beats)
- `playtester-lgbtqia` — représentation, pronoms, tropes
- `critique-indie-narratif` — densité prose, choix significatifs, voix d'auteur·rice
- `coauteur-ia` — anti-patterns IA, concret > abstrait
- `playtester-accessibilite` — longueur de blocs, libellés, charge cognitive

**Ressources canon : lues automatiquement via `reference_documents:` du YAML** (loading_strategy
`from_bank_yml`). Ne pas hardcoder ici.

## Préalable obligatoire — Linter PASS

Avant toute review LLM, le `.dtl` doit avoir passé `scripts/tools/dtl_linter.gd` avec
statut `PASS`. Si non vérifié, exécuter :

```bash
godot --headless --path . --script scripts/tools/dtl_linter.gd -- <chemin .dtl>
```

Si `FAIL` → STOP. La review LLM est inutile sur un `.dtl` mécaniquement cassé.
Retour à Stage 3 (`03-write-dtl --feedback`) ou correction manuelle.

## Modes

### Mode `--light` (Stage 4a — pré-review rapide)

Une seule passe, un seul persona, 5-10 min :

- Pas de matrice multi-branches : revue globale d'ensemble
- Score unique pondéré (pas de détail par critère)
- 2 verbatims max (pas 3)
- 1 faiblesse "tête de pont" (pas 3)
- Triage 🟢/🟡/🔴 unique pour le `.dtl` entier

Objectif : détecter rapidement une catastrophe avant la review complète (gain de temps).
Si `--light` revient 🔴 → ne PAS lancer la review complète, repartir en Stage 3.

### Mode complet (défaut, Stage 4b — review matricielle)

Matrice complète NODE × branche × persona, format détaillé ci-dessous.
Utilisé après un `--light` 🟢 ou 🟡, ou directement si auteur skip `--light`.

## Process

### Step 0 — Choix du mode

Si `--light` est passé dans les arguments → suivre le **mode light** (Step 1-L à Step 4-L).
Sinon → suivre le **mode complet** (Step 1 à Step 7).

### Mode light

#### Step 1-L — Lecture globale

Lire le `.dtl` en entier (pas branche par branche). Identifier le ton, le rythme,
les beats majeurs. Pas de scoring détaillé.

#### Step 2-L — Application de 2-3 items de la Craft Checklist

Choisir 2-3 items les plus discriminants de la persona pour le scope `.dtl` (ne pas
appliquer tous les items — c'est ça qui rend la passe rapide).

#### Step 3-L — Verdict synthétique

Format strict :

```markdown
## Persona <name> — Pré-review `<dtl>`

**Score global** : <n>/20 (1 persona, 1 passe)

**Verbatims (2 max)** :
« <citation 1> » — <réaction>
« <citation 2> » — <réaction>

**Faiblesse principale** : <description courte + citation>

**Triage** : 🟢 OK pour review complète · 🟡 à surveiller · 🔴 retour Stage 3
```

#### Step 4-L — Recommandation

- 🟢 → "Lancer la review complète avec 2-3 personas (dont au moins Dramaturge)"
- 🟡 → "Faisable mais lancer la review complète sur les branches sensibles seulement"
- 🔴 → "Ne PAS lancer la review complète. Retour `03-write-dtl --feedback` avec : <résumé du feedback>"

### Step 1 — Identifier les branches

Parser le .dtl pour extraire :
- Chaque bloc `[choice text="..."]`
- La branche linéaire (si NODE simple sans choix)
- Les conditionnelles `{if ...}` qui constituent des sous-branches

Si N branches → produire N évaluations.

### Step 2 — Pour CHAQUE branche : Craft Checklist

Charger la section **Craft Checklist** du YAML persona et appliquer ses items un à un sur la
branche. Ne pas inventer de critères hors-YAML. Si la persona déclare un `reference_documents:`,
ces documents sont chargés avant la review (ex : `node-spec.md` pour `dramaturge`).

### Step 3 — Scoring

Charger la table **Scoring** du YAML persona (critères + poids). Donner un score /20 par
critère, puis calculer le global pondéré selon les poids déclarés. Ne pas modifier les poids.

**Format scoring uniforme** :

```
Score : <crit_1> <n>/20 · <crit_2> <n>/20 · … — Global <n>/20
```

### Step 4 — Verbatims (3 lignes max par branche)

Citer **textuellement** des passages du .dtl et réagir :

```
« <citation exacte du .dtl> »
→ <réaction du persona : ce qui marche / ce qui rate>
```

3 citations max. Pas de paraphrase, pas de généralité.

### Step 5 — Avocat du diable (3 faiblesses minimum)

Après avoir scoré, lister **3 faiblesses précises** selon les critères de la persona.
Citation exacte exigée. **Forcer la recherche active de problèmes.** Si moins de 3
faiblesses trouvées → relire ; il y en a toujours 3.

### Step 6 — Triage

Pour chaque branche, attribuer :

| Triage | Critère | Action Stage 6 |
|--------|---------|----------------|
| 🟢 patchable | Tous scores ≥ 14 | `doctor.prompt.md` (patch ciblé) |
| 🟡 structurel | Au moins un score 11-13 | rewrite local via `03-write-dtl --feedback` |
| 🔴 systémique | Au moins un score ≤ 10 OU divergence > 4 entre personas | retour Stage 3 (revoir node-spec ou arc-spec) |

### Step 7 — Format de sortie

Écrire un fragment Markdown destiné à être consolidé dans `review-report.md` :

```markdown
## Persona <name> — NODE <id>

### Branche [<X>] · <libellé>

**Score** : <crit1> <n>/20 · <crit2> <n>/20 · … — **Global <n>/20**

**Vérifications craft checklist** :
- ✅/❌ <critère> : <détail>
- …

**Verbatims** :
« <citation 1> » — <réaction>
« <citation 2> » — <réaction>
« <citation 3> » — <réaction>

**Faiblesses (avocat du diable)** :
1. <faiblesse + citation>
2. <…>
3. <…>

**Triage** : 🟢 / 🟡 / 🔴
```

Une section par branche, dans l'ordre du .dtl.

## Output

Stdout : fragment Markdown prêt à coller dans `review-report.md`.

Ne pas écrire de fichier — la consolidation est faite par l'auteur ou par un agent
orchestrateur.

## Rules

1. **Linter PASS obligatoire** — pas de review LLM sur un `.dtl` cassé mécaniquement
2. **Une seule passe** — pas de boucle de validation interne
3. **Citations exactes** — pas de paraphrase, le .dtl est la source de vérité
4. **3 faiblesses minimum (mode complet)** — forcer l'avocat du diable. Mode `--light` : 1 faiblesse suffit
5. **Triage strict** — appliquer les seuils sans indulgence
6. **Persona ≠ auteur** — incarner le profil défini dans le YAML, pas l'opinion du LLM
7. **Pas de réécriture** — la review constate, le rewrite est en Stage 5
8. **Light = filtre, pas substitut** — un `--light` 🟢 ne dispense pas de la review complète sur les arcs sensibles
