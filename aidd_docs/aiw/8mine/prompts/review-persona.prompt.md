---
name: review-persona
description: Review d'un .dtl par un persona — mode complet ou light. Calibration /20 ancrée + tags sévérité par finding + plafond automatique. Supporte scene-spec (nouveau modèle 3 couches) et node-spec (legacy).
argument-hint: <chemin .dtl> <persona-name> [--scene-spec <chemin> | --node-spec <chemin>] [--pnj-behaviors <chemin1,chemin2,...>] [--light]
version: 1.4
---

# Review Persona — .dtl + spec → Verbatims + Triage

## Goal

Faire jouer un persona (Margot-joueuse, Dramaturge, auditeur-scene, playtester-lgbtqia…) à travers chaque branche/sujet d'un .dtl et produire :
- Scores /20 par branche ou sujet
- Verbatims (citations + réactions)
- 3 faiblesses ou risques minimum (avocat du diable)
- Triage 🟢/🟡/🔴

Supporte les deux modèles :
- **Modèle scenes** (nouveau) : `.dtl` produit par `write-scene` à partir d'une `scene-spec`. Passer `--scene-spec` + `--pnj-behaviors`.
- **Modèle node** (legacy) : `.dtl` produit par `write-dtl` à partir d'une `node-spec`. Passer `--node-spec`.

## Context

**Timeline à reviewer :**
```
@$ARGUMENTS[0]
```

**Persona à incarner :**
```yaml
@aidd_docs/aiw/8mine/personas/$ARGUMENTS[1].yml
```

**Spec source (selon modèle)** :
- Si `--scene-spec <chemin>` passé : charger la scene-spec ET la liste des pnj-behaviors via `--pnj-behaviors`
- Si `--node-spec <chemin>` passé : charger la node-spec (legacy)

```
@$ARGUMENTS[--scene-spec ou --node-spec]
@aidd_docs/memory/external/pnjs-behavior/<pnj>.md       (par PNJ, si --pnj-behaviors)
```

**Personas disponibles** *(4 actifs au total — cap design)*:
- `dramaturge` — structure (préconditions, postconditions, scope jauges, verrous canon, fins, beats). **Adapté scene-spec en v1.1** et absorbe le rôle ex-auditeur-scene *(strict mécanique)*.
- `playtester-lgbtqia` — représentation, pronoms, tropes, verrous pnj-behavior Sofia/Emma/Camille. **Charge automatiquement** `sofia-kessler-caracterisation.md` + `pool-romance-pas-drague.md` en référence.
- `playtester-visual-novel` — pacing, choix significatifs, PNJ mémoire active, sous-texte, voix Margot. Référence VN/LiS/Disco Elysium. *(Absorbe le rôle ex-margot-joueuse — voix Margot couverte dans son scoring 10%.)*
- `playtester-cyberpunk` — worldbuilding cohérent, corpos distinctes, surveillance vécue, anti cyber-jargon, cyberpunk de l'intime. Référence Gibson / Cyberpunk 2077 / Citizen Sleeper.

> **Personas archivés** *(dans `personas/_archive/`)* — non invocables, conservés pour référence :
> `margot-joueuse` *(rôle absorbé par playtester-visual-novel)* · `auditeur-scene` *(rôle absorbé par dramaturge v1.1)* · `coauteur-ia` *(anti-patterns IA — peu invoqué)* · `critique-indie-narratif` *(densité prose — chevauche playtester-visual-novel)* · `playtester-accessibilite` *(charge cognitive — couvert par playtester-visual-novel)*.

**Ressources canon : lues automatiquement via `reference_documents:` du YAML** (loading_strategy `from_bank_yml`). Ne pas hardcoder ici.

## Préalable obligatoire — Linter PASS

Avant toute review LLM, le `.dtl` doit avoir passé `scripts/tools/dtl_linter.gd` avec
statut `PASS`. Si non vérifié, exécuter :

```bash
godot --headless --path . --script scripts/tools/dtl_linter.gd -- <chemin .dtl>
```

Si `FAIL` → STOP. La review LLM est inutile sur un `.dtl` mécaniquement cassé.
Retour à `write-dtl --feedback` ou correction manuelle.

## Modes

### Mode `--light` (pré-review rapide)

Une seule passe, un seul persona, 5-10 min :

- Pas de matrice multi-branches : revue globale d'ensemble
- Score unique pondéré (pas de détail par critère)
- 2 verbatims max (pas 3)
- 1 faiblesse "tête de pont" (pas 3)
- Triage 🟢/🟡/🔴 unique pour le `.dtl` entier

Objectif : détecter rapidement une catastrophe avant la review complète (gain de temps).
Si `--light` revient 🔴 → ne PAS lancer la review complète, repartir à l'écriture (`write-dtl --feedback`).

### Mode complet (défaut, review matricielle)

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

**Triage** : 🟢 OK pour review complète · 🟡 à surveiller · 🔴 retour à l'écriture (`write-dtl --feedback`)
```

#### Step 4-L — Recommandation

- 🟢 → "Lancer la review complète avec 2-3 personas (dont au moins Dramaturge)"
- 🟡 → "Faisable mais lancer la review complète sur les branches sensibles seulement"
- 🔴 → "Ne PAS lancer la review complète. Retour `write-dtl --feedback` avec : <résumé du feedback>"

### Step 1 — Identifier les unités à reviewer (branches OU sujets)

**Selon modèle source** :

- **Modèle scene-spec** : parser le .dtl pour extraire :
  - Chaque **sujet** Margot (`[choice text="..."]` dans le menu sujets disponibles)
  - Les **événements de seuil** injectés (blocs `{if {inject_event_<X>}}`)
  - L'**ambiance** (intro + outro avec variantes)
  - Pour chaque sujet : ses **sous-branches par palier PNJ** *(blocs `{if {relation_<pnj>_palier} == "..."}`)* — comptent comme sous-unités si elles altèrent significativement la prose
- **Modèle node-spec** (legacy) : parser comme avant — chaque `[choice text="..."]` = branche, conditionnelles = sous-branches

Si N unités → produire N évaluations. Pour scene-spec avec sujets denses, prioriser :
1. Tous les événements de seuil (les plus narrativement chargés)
2. Tous les sujets non-triviaux *(plus de 2 paliers de réplique distincts)*
3. Outro variants
4. Sujets simples *(passe rapide groupée)*

### Step 2 — Pour CHAQUE branche : Craft Checklist

Charger la section **Craft Checklist** du YAML persona et appliquer ses items un à un sur la
branche. Ne pas inventer de critères hors-YAML. Si la persona déclare un `reference_documents:`,
ces documents sont chargés avant la review (ex : `node-spec.md` pour `dramaturge`).

### Step 3 — Scoring AVEC CALIBRATION ANCRÉE

Charger la table **Scoring** du YAML persona (critères + poids) **ET** la section
**`scoring_anchors`** du YAML persona (ancrages /20 vs standards externes nommés).

Donner un score /20 par critère, **en justifiant via l'ancrage** :

```
Score : <crit_1> <n>/20 (ancrage : "<niveau scoring_anchors atteint>") · <crit_2> <n>/20 · … — Global <n>/20
```

**Règles de plafond automatique** *(à vérifier après les findings du Step 5)* :
- Si **≥ 1 faiblesse 🔴 critique** trouvée → triage 🔴 systémique automatique, score global ≤ 11/20
- Si **≥ 1 faiblesse 🟠 majeur** trouvée → score global plafonné à 14/20
- Si **seulement des faiblesses 🟡 mineur** trouvées → score global plafonné à 17/20
- Si **seulement des polish 🟢** identifiés → 18-19/20 possible
- **20/20** exige *« aucune faiblesse identifiable malgré recherche active déclarée »*

### Step 4 — Verbatims (3 lignes max par branche)

Citer **textuellement** des passages du .dtl et réagir :

```
« <citation exacte du .dtl> »
→ <réaction du persona : ce qui marche / ce qui rate>
```

3 citations max. Pas de paraphrase, pas de généralité.

### Step 5 — Avocat du diable AVEC TAGS DE SÉVÉRITÉ

Après scoring initial, lister **3 faiblesses minimum** avec **tag de sévérité obligatoire** :

```
1. [🔴 critique] <description> — « <citation exacte> » — <impact>
2. [🟠 majeur] <description> — « <citation> » — <impact>
3. [🟡 mineur] <description> — « <citation> » — <impact>
4. [🟢 polish] <description> *(optionnel, n'affecte pas le score)*
```

**Définition des sévérités** :
- **🔴 critique** : viole un verrou canon, casse une mécanique de jeu, rend une fin inaccessible ou un PNJ incohérent au point de fracturer la canon
- **🟠 majeur** : défaut structurel patchable mais qui affecte significativement l'expérience joueur ou la cohérence inter-arcs
- **🟡 mineur** : polish ergonomique, lisibilité, redondance, sous-utilisation d'une ressource canon
- **🟢 polish** : suggestion d'amélioration discrétionnaire, n'affecte ni la canon ni l'expérience de manière notable

**Règle de recherche active** : avant de conclure *« moins de 3 faiblesses trouvées »*,
le persona doit déclarer explicitement avoir cherché les 5 risques typiques de sa
craft checklist *(grep `.dtl`, croisement avec scene-spec, pnj-behavior, design-rules)*.
Si recherche active déclarée et aucune faiblesse 🟠+ trouvée, le justifier dans le rapport.

**Mise à jour du score** *(après tagging)* : recalculer le score global en appliquant
les règles de plafond automatique du Step 3.

### Step 6 — Triage

Pour chaque branche, attribuer :

| Triage | Critère | Action |
|--------|---------|----------------|
| 🟢 patchable | Tous scores ≥ 14 | `doctor.prompt.md` (patch ciblé) |
| 🟡 structurel | Au moins un score 11-13 | rewrite local via `write-dtl --feedback` |
| 🔴 systémique | Au moins un score ≤ 10 OU divergence > 4 entre personas | retour `arc-spec` / `decompose-arc` |

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
4. **3 faiblesses minimum (mode complet) avec tags sévérité obligatoires** — forcer l'avocat du diable. Mode `--light` : 1 faiblesse suffit
5. **Triage strict + plafonds automatiques** — appliquer les seuils sans indulgence (cf. Step 3 règles plafond)
6. **Calibration ancrée obligatoire** — chaque score critère cite l'ancrage `scoring_anchors` atteint
7. **Persona ≠ auteur** — incarner le profil défini dans le YAML, pas l'opinion du LLM
8. **Pas de réécriture** — la review constate, le rewrite est dans `doctor` ou `write-dtl --feedback`
9. **Light = filtre, pas substitut** — un `--light` 🟢 ne dispense pas de la review complète sur les arcs sensibles
10. **Concordance suspecte = signal** — si plusieurs personas en parallèle scorent à ±1 point l'un de l'autre, déclarer explicitement *« concordance étroite — vérifier calibration via persona-trainer »*

## Détecteurs anti-indulgence

Si l'un de ces patterns apparaît dans le rapport, le persona est probablement trop kind :

- Score ≥ 17/20 + aucune faiblesse 🟠+ trouvée → vérifier que la recherche active a été déclarée et exhaustive
- Score ≥ 18/20 + faiblesses listées en bullets *(sans tag sévérité)* → invalide, relancer avec tags
- Score ≥ 19/20 + critères tous ≥ 17 → improbable sur premier passage ; déclarer concordance suspecte
- 4 personas concordent à ±1 point → invoquer `persona-trainer` sur le persona dominant le moins discriminant
