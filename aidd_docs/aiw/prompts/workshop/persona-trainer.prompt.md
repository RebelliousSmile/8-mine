---
name: persona-trainer
description: Improves persona effectiveness based on missed issues and feedback patterns
argument-hint: <persona-id> [--feedback-files] [--issues-missed]
---

# Persona Trainer

Améliore les personas pour qu'ils détectent mieux les vrais problèmes qualité.

**Workflow :** Analyse feedback → Détecte manques → Renforce must-haves/deal-breakers → Test validation

## Goal

**Améliorer efficacité personas** en renforçant leurs `expectations` (must-haves, deal-breakers) basé sur :
1. Issues **non détectées** par personas existants
2. Patterns **récurrents** dans feedback utilisateur
3. Scores **trop indulgents** (validation chapitre avec problèmes structurels)

**Complète tone-finder :** tone-finder améliore output-styles, persona-trainer améliore personas.

## Context

**Persona à améliorer :**
```yaml
@<univers>/.templates/personas/$ARGUMENTS[0].yml
# OU
@docs/templates/personas/$ARGUMENTS[0].yml
```

**Feedback sources :**
```markdown
@.docs/comments/*.md      # Analyses personas existantes
@.docs/doctor-report-*.md # Corrections techniques appliquées
@.docs/review-summary-*.md # Synthèses review-pipeline
```

**Arguments :**
- `$ARGUMENTS[0]` : persona-id (ex: olivier-larue, mj-medfan)
- `--feedback-files <paths>` : Fichiers feedback spécifiques (défaut: tous .docs/)
- `--issues-missed "<description>"` : Issues manuellement identifiées non détectées

## Rules

1. **CONSERVER L'IDENTITÉ** : Ne pas changer role/description/reading_style du persona
2. **RENFORCER EXPECTATIONS** : Ajouter must-haves/deal-breakers spécifiques (pas génériques)
3. **AJUSTER CRITERIA WEIGHTS** : Si persona rate issues clarity → augmenter weight clarity
4. **AJOUTER SCORING_CALIBRATION** : Exemples concrets scores /20 pour ce persona
5. **VERSION +1** : Incrémenter version persona, documenter changements
6. **TESTER SUR ÉCHANTILLON** : Valider amélioration sur chapitre problématique

## Process

### Step 1: Analyze Current Persona

**1.1 Charger persona actuel**
```yaml
@<path>/$ARGUMENTS[0].yml
```

**1.2 Identifier profil**
- Role/description
- Must-haves actuels (nombre)
- Deal-breakers actuels (nombre)
- Criteria weights (engagement/clarity/immersion/satisfaction)
- Scoring philosophy

**1.3 Logger baseline**
```
Persona: <name>
Must-haves: <N> items
Deal-breakers: <N> items
Focus principal: <criterion avec weight max>
```

### Step 2: Detect Missed Issues

**2.1 Analyser feedback files**

Pour chaque `.docs/comments/*.md` :
- Extraire Section 1 (TECHNICAL ISSUES)
- Extraire Section 2 (SYSTEMIC PATTERNS)
- Extraire Section 3 (QUALITATIVE SCORES) pour ce persona

**2.2 Identifier issues non détectées**

Croiser avec `.docs/doctor-report-*.md` :
```
Issues détectées par doctor MAIS absentes du feedback persona
→ Manque potential dans must-haves
```

**2.3 Analyser scores trop indulgents**

```yaml
# Exemple problématique
chapitre02:
  olivier-larue_score: 14/20  # Score initial
  issues_found_post: 
    - "Stats PNJ absentes (Trolloc, Myrddraal)"
    - "Règles incomplètes Fatale [X]+"
  expected_score: 11/20 MAX (must-have manquant)
  gap: +3 pts (trop indulgent)
```

**2.4 Parser --issues-missed manuel**

Si fourni par utilisateur :
```
Issues critiques non remontées par <persona>:
- "<description issue 1>"
- "<description issue 2>"
```

### Step 3: Propose Improvements

**3.1 Renforcer must-haves**

Pour chaque issue critique manquée :
```yaml
# AVANT
must_have:
  - "Règles complètes"

# APRÈS (plus spécifique)
must_have:
  - "Règles complètes avec tous paramètres définis (aucun placeholder [X], TBD, TODO)"
  - "Stats complètes PNJ antagonistes (CAR/COMP/SP/SM/DP)"
```

**3.2 Ajouter deal-breakers**

Pour patterns récurrents graves :
```yaml
# Si persona rate contradictions internes répétées
deal_breakers:
  - "Contradiction interne (règles, stats, exemples)"
  - "Exemple impossible à reproduire avec données fournies"
```

**3.3 Ajuster criteria weights**

Si persona rate issues **clarity** mais détecte bien **immersion** :
```yaml
# AVANT
clarity: { weight: 0.3 }
immersion: { weight: 0.4 }

# APRÈS (rebalance)
clarity: { weight: 0.4 }  # +0.1
immersion: { weight: 0.3 }  # -0.1
```

**3.4 Ajouter scoring_calibration**

```yaml
scoring_calibration:
  # Échelle /20
  production_ready: "18-20/20 - Exemples: stats PNJ complets, règles sans placeholder, références valides"
  not_usable: "9-11/20 - Exemples: stats manquantes, règles Fatale [X]+ non définie, tableaux incohérents"
  
  must_have_ceiling: "11/20 - Si 1+ must-have manquant"
  deal_breaker_ceiling: "8/20 - Si 1+ deal-breaker présent"
  
  past_scores:
    - chapitre: "chapitre02-v1"
      score_given: 14/20
      score_should_be: 11/20
      reason: "Stats PNJ absentes (must-have), score plafonné"
```

### Step 4: Generate Improved Persona

**4.1 Créer version +1**

```yaml
persona:
  id: "<persona-id>"
  version: "2.0"  # Incrémenter
  changelog:
    - version: "2.0"
      date: "2026-02-13"
      changes:
        - "Ajout must-have: Stats complètes PNJ antagonistes"
        - "Ajout deal-breaker: Contradiction interne règles"
        - "Rebalance weights: clarity 0.3→0.4, immersion 0.4→0.3"
        - "Ajout scoring_calibration avec exemples concrets"
  
  # ... reste du persona avec améliorations
```

**4.2 Documenter changements**

Créer `.docs/personas-changelog.md` :
```markdown
# <persona-id> v2.0 (2026-02-13)

## Issues Ratées (v1.0)
- Chapitre 02: Stats PNJ absentes (Trolloc, Myrddraal)
- Chapitre 02: Règles incomplètes "Fatale [X]+"

## Améliorations
1. Must-have ajouté: "Stats complètes PNJ antagonistes"
2. Deal-breaker ajouté: "Contradiction interne"
3. Weight clarity: 0.3 → 0.4

## Test Validation (chapitre02)
- v1.0 score: 14/20 (trop indulgent)
- v2.0 score attendu: 11/20 (must-have manquant détecté)
```

### Step 5: Validation Test

**5.1 Re-run comment.prompt.md**

Sur chapitre problématique avec persona v2.0 :
```bash
@docs/prompts/workshop/comment.prompt.md <chapitre-test> \
  --personas "<persona-id>-v2"
```

**5.2 Comparer scores**

```markdown
| Métrique | v1.0 | v2.0 | Δ | Validation |
|----------|------|------|---|------------|
| Score donné | 14/20 | 11/20 | -3 | ✅ Plus exigeant |
| Must-haves check | Non détecté | Détecté | ✅ | Amélioration |
| Issues critiques | 2 ratées | 0 ratée | ✅ | Efficace |
```

**5.3 Décision**

- **IF améliorations validées :** Remplacer v1.0 par v2.0
- **ELSE :** Affiner must-haves/deal-breakers, réitérer Step 3-5

## Output

**Fichiers générés :**
```
<univers>/.templates/personas/<persona-id>.yml (v2.0)
.docs/personas-changelog.md
.docs/persona-validation-<persona-id>-v2.md
```

**Summary report :**
```markdown
# Persona Trainer Report - <persona-id> v2.0

## Baseline (v1.0)
- Must-haves: <N>
- Deal-breakers: <N>
- Issues ratées: <N> sur <total>

## Improvements (v2.0)
- Must-haves: <N> (+<delta>)
- Deal-breakers: <N> (+<delta>)
- Weights ajustés: [liste]
- Scoring calibration: Ajouté

## Validation Test
- Chapitre: <test-file>
- Score v1.0: X/20
- Score v2.0: Y/20 (Δ <delta>)
- Issues détectées: <N>/<total>

## Statut
✅ Persona amélioré, prêt à remplacer v1.0
⚠️ Validation partielle, affiner must-haves
❌ Pas d'amélioration, conserver v1.0
```

## Examples

**Exemple 1 : Olivier LaRue (relecteur pro)**

```bash
# Améliorer olivier-larue basé sur feedback chapitre02
@docs/prompts/workshop/persona-trainer.prompt.md olivier-larue \
  --feedback-files ".docs/comments/chapitre02-personas-it*.md" \
  --issues-missed "Stats PNJ Trolloc/Myrddraal absentes, Règles Fatale [X]+ non définie"
```

**Résultat attendu :**
```yaml
# v1.0 → v2.0
must_have:
  - "Stats complètes PNJ antagonistes (CAR/COMP/SP/SM/DP)"  # Nouveau
  - "Règles avec paramètres définis (aucun [X], TBD, TODO)"  # Renforcé

deal_breakers:
  - "Règle introduite référencée mais jamais définie"  # Nouveau
```

**Exemple 2 : MJ Med-Fan**

```bash
# mj-medfan trop indulgent sur portabilité
@docs/prompts/workshop/persona-trainer.prompt.md mj-medfan \
  --issues-missed "Scénario trop lié WoT (PNJ Aes Sedai non portable)"
```

**Résultat attendu :**
```yaml
# Ajustement weights
clarity: { weight: 0.3 → 0.4 }  # Prioriser structure claire
satisfaction: { weight: 0.1 → 0.2 }  # Portabilité = satisfaction

# Deal-breaker renforcé
deal_breakers:
  - "PNJ clés impossibles à porter hors univers (pouvoirs uniques, organisations spécifiques)"
```

## Integration avec Review-Pipeline

**Workflow complet :**
```
review-pipeline → chapitre score 14/20 mais issues structurelles
    ↓
Utilisateur identifie: "Personas trop indulgents"
    ↓
persona-trainer → améliore personas (must-haves + deal-breakers)
    ↓
review-pipeline re-run → chapitre score 11/20 (réaliste)
    ↓
Recommandations claires (must-haves manquants listés)
```

**Cycle amélioration continue :**
```
Personas v1.0 → Feedback → persona-trainer → Personas v2.0 → Validation
```

## Validation Checklist

- [ ] Persona v2.0 conserve identité (role/description)
- [ ] Must-haves spécifiques ajoutés (pas génériques)
- [ ] Deal-breakers couvrent issues graves récurrentes
- [ ] Scoring_calibration avec exemples concrets
- [ ] Changelog documenté (version, date, changes)
- [ ] Test validation sur chapitre problématique
- [ ] Score v2.0 plus exigeant ET plus juste que v1.0

---

**Version:** 1.0  
**Date:** 2026-02-13  
**Complète:** tone-finder.prompt.md (améliore output-styles)
