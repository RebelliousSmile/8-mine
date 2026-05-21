---
name: tone-finder
description: Generate/improve output-styles from source texts, questionnaire, or feedback
argument-hint: <univers> [source-files...] [--only novel|rules|scenario] [--extend] [--improve-from-feedback]
---

# Tone Finder Prompt

## Goal

Create or improve output-style files for a universe by:
- **[1] Mode Source** : Analyzing provided documents deeply
- **[1] Mode Questionnaire** : Building style through structured questions
- **[8] Mode Hybride** : Combining partial sources with targeted questions
- **[NEW] Mode Amélioration** : Improving existing styles based on feedback

## Context

### Arguments

```text
$ARGUMENTS

Options:
  --only <type>              Generate only one type (novel, rules, scenario)
  --extend                   Enrich existing styles instead of replacing
  --improve-from-feedback    Improve existing output-style based on comment.prompt.md or doctor.prompt.md feedback
```

## Rules

- Analyze WRITING STYLE first, formatting second
- **[1] Determine mode immediately** (Source / Questionnaire / Hybride / Amélioration)
- Check existing `<univers>/.output-styles/` first
- **[5] In questionnaire mode, co-construct examples with user**
- **[NEW] In amélioration mode, analyze feedback patterns before proposing changes**
- Max 15 questions total in questionnaire mode

---

## Step 1: Initialize & Route [1]

```
Analyzing [univers]...
Sources provided: [list or 'none']
Existing styles: [list or 'none']
Feedback files: [.docs/comments/*.md or doctor reports]

MODE DETECTED: [Source / Questionnaire / Hybride / Amélioration]
```

**Routing:**
- Sources complets → Step 2 (Mode Source)
- Aucun source → Step 3 (Mode Questionnaire)
- Sources partiels → Step 2 puis Step 3 pour compléter [8]
- `--improve-from-feedback` → Step 7 (Mode Amélioration) [NEW]

---

## MODE SOURCE (Steps 2A-2C)

### Step 2A: Deep Style Analysis

#### Philosophie d'écriture (PRIORITÉ)

| Élément | Valeur | Exemple extrait |
|---------|--------|-----------------|
| **Structure des explications** | Paragraphes / Listes / Mixte | [2-3 lignes] |
| **Ratio prose/listes** | X% prose, Y% listes | Calculé |
| **Paragraphes par concept** | 1 / 2-3 / 4+ | Moyenne |
| **Développement des idées** | Linéaire / Contextuel / Technique | [exemple] |
| **Ton didactique** | Guide / Manuel / Référence | [exemple] |

**Question clé :** Comment le source développe-t-il une idée complexe ?

#### Conventions de formatage

| Élément | Valeur |
|---------|--------|
| Atmosphere | [extracted] |
| Register | [extracted] |
| Vocabulary | [specific terms] |
| Typography | [guillemets, tirets] |
| Encadrés techniques | [format] |

### Step 2B: Extract Real Examples

**Obligatoire : 3 exemples minimum**

```markdown
### Exemple 1 : Explication d'un concept
> [2-4 paragraphes du source]

### Exemple 2 : Section technique
> [Section "En jeu" ou équivalent]

### Exemple 3 : Description atmosphérique
> [Passage descriptif]
```

### Step 2C: Create Usage Guidelines

```markdown
## Bon usage (extrait du source)
[Exemple réel montrant le style correct]

## Mauvais usage (contre-exemple)
[Ce qu'il NE FAUT PAS faire]
```

→ Aller au Step 4 (Generate)

---

## MODE QUESTIONNAIRE (Step 3) [2][3]

### Step 3A: Philosophie d'écriture [2]

**Catégorie 1 — Identité du style**

1. **Genre principal ?**
   - Fantasy / Horror / Sci-Fi / Contemporain / Historique / Autre

2. **Ton en 3-5 mots ?**
   - Ex: "sombre, poétique, mélancolique" ou "épique, héroïque, lumineux"

3. **[7] Style de référence ?** Quel livre, jeu ou auteur a un style proche de ce que vous visez ?
   - Ex: "Comme les livres de base Vampire the Masquerade" ou "Style Pratchett"

4. **Registre de langue ?**
   - Soutenu / Courant / Familier / Mixte selon contexte

### Step 3B: Structure d'écriture [3]

**Catégorie 2 — Comment écrire**

5. **[3] Comment structurer les explications ?**
   - A) Prose développée (paragraphes fluides, peu de listes)
   - B) Listes commentées (points avec explications)
   - C) Mixte (prose pour contexte, listes pour détails)
   - D) Technique (tableaux et références)

6. **Combien de paragraphes pour expliquer un concept majeur ?**
   - 1 (concis) / 2-3 (développé) / 4+ (exhaustif)

7. **Quelle densité d'information ?**
   - Dense (beaucoup d'info par paragraphe)
   - Aérée (une idée par paragraphe)
   - Progressive (simple → complexe)

8. **Comment introduire les règles/mécaniques ?**
   - Intégrées au texte narratif
   - Encadrés séparés ("En jeu", "Règle")
   - Sections dédiées en fin de chapitre

### Step 3C: Conventions [2]

**Catégorie 3 — Formatage**

9. **POV pour la fiction ?**
   - 1ère personne / 3ème personne / Variable

10. **Format des dialogues ?**
    - Tirets cadratins (— Texte) / Guillemets ("Texte")

11. **Adresse au lecteur/MJ ?**
    - Tutoiement / Vouvoiement / Impersonnel

12. **Typographie spéciale ?**
    - Guillemets français («») / Anglais ("")
    - Italique pour termes étrangers : Oui / Non

### Step 3D: Exemples co-construits [4][5]

**[5] Construire des exemples ensemble**

13. **Voici un exemple de paragraphe explicatif dans ce style. Est-il correct ?**

```
[Générer un paragraphe exemple basé sur les réponses]
```
- Oui, c'est le bon ton
- Non, c'est trop [formel/informel/dense/léger]
- Ajuster : [feedback utilisateur]

14. **Voici un exemple d'encadré technique. Est-il correct ?**

```
[Générer un encadré exemple]
```
- Oui / Non / Ajuster

15. **Optionnel : Avez-vous un extrait de votre propre écriture à utiliser comme référence ?**

→ Aller au Step 4 (Generate)

---

## MODE HYBRIDE [8]

Si sources partiels :
1. Exécuter Step 2A-2C sur les sources disponibles
2. Identifier les lacunes (sections non couvertes)
3. Poser uniquement les questions du Step 3 correspondant aux lacunes
4. Fusionner les données extraites et les réponses

---

## Step 4: Generate Output-Style

Structure obligatoire du fichier généré :

```markdown
# Output Style: [Univers] — [Type]

**Source:** [documents analysés OU "Questionnaire"]
**Version:** X.0

---

## Philosophie d'écriture

[Paragraphe synthétisant le style fondamental]

### Principes fondamentaux

1. **[Principe 1]** — [justification]
2. **[Principe 2]** — [justification]
3. **[Principe 3]** — [justification]

---

## Structure des sections

### Paragraphes explicatifs
[Description + exemple]

**Exemple :**
> [Exemple extrait ou co-construit]

### Listes (usage [limité/normal/fréquent])
[Quand les utiliser]

### Tableaux (usage [limité/normal/fréquent])
[Quand les utiliser]

### Encadrés techniques
[Format et usage]

---

## Bon usage / Mauvais usage

### Bon usage
[Exemple complet]

### Mauvais usage
[Contre-exemple avec explication]

---

## Conventions de formatage

### Typographie
[Règles]

### Vocabulaire spécifique
[Termes et usage]

### Dialogues et citations
[Format]

---

## Exemples complets

### Exemple 1 : [Type]
[Contenu]

### Exemple 2 : [Type]
[Contenu]

---

## Checklist

- [ ] [Critère 1]
- [ ] [Critère 2]
- [ ] [Critère 3]
```

---

## Step 5: Validate [6]

### Mode Source
```
COMPARAISON:
- Caractéristiques du source : [liste]
- Output-style généré : [liste]
- Match : [Oui / Écarts à corriger]
```

### Mode Questionnaire [6]
```
VALIDATION UTILISATEUR:

Voici l'output-style généré. Veuillez confirmer :

1. La philosophie d'écriture est-elle correcte ? [Oui/Non/Ajuster]
2. Les exemples correspondent-ils à votre vision ? [Oui/Non/Ajuster]
3. Les conventions sont-elles complètes ? [Oui/Non/Ajouter]

Si ajustements nécessaires, préciser.
```

---

## Step 6: Write & Report

```
Created:
- <univers>/.output-styles/<univers>-[type].md (v1.0)

Mode utilisé: [Source / Questionnaire / Hybride]
Métriques:
- Ratio prose/listes : X%/Y%
- Paragraphes par concept : N
- Exemples inclus : M

bank.yml update:
output-style:
  [type]: "<univers>/.output-styles/<univers>-[type].md"
```

---

## Checklist Finale

- [ ] Mode correctement identifié (Source/Questionnaire/Hybride/Amélioration) [1]
- [ ] Questionnaire complet si mode sans source [2]
- [ ] Questions sur structure prose posées [3]
- [ ] Exemples co-construits si pas de source [4][5]
- [ ] Validation adaptée au mode [6]
- [ ] Style de référence demandé [7]
- [ ] Mode hybride géré si sources partiels [8]
- [ ] Feedback patterns analysés si mode amélioration [9]
- [ ] Fichiers sauvegardés

---

## MODE AMÉLIORATION (Step 7) [NEW]

### Step 7A: Analyze Feedback Patterns

**Load feedback sources:**
```bash
# Comment feedback (persona analysis)
.docs/comments/chapitre*-personas.md

# Doctor reports (technical corrections)
<rechercher doctor reports récents>

# User remarks
<arguments fournis>
```

**Extract patterns:**

| Pattern | Occurrences | Chapitres affectés | Catégorie |
|---------|-------------|---------------------|-----------|
| Guillemets droits → français | 15 | 01, 03, 05 | Typographie |
| Phrases > 40 mots | 8 | 02, 04 | Style |
| Jargon non expliqué | 12 | 02, 05, 06 | Clarté |

**Severity classification:**

- 🔴 **CRITICAL** : Affect 50%+ chapitres, deal-breaker pour ≥1 persona
- 🟡 **IMPORTANT** : Affect 25-50% chapitres, impact score < 7/10
- 🟢 **OPTIONAL** : Affect < 25% chapitres, amélioration marginale

### Step 7B: Propose Output-Style Changes

Pour chaque pattern 🔴 ou 🟡 :

```markdown
### Amélioration #1 : Guillemets Français

**Problème détecté :**
- 15 corrections dans 3 chapitres (novel)
- Deal-breaker pour "Professeure de Français" persona
- Score clarté : 6.2/10 (vs 8+ attendu)

**Règle actuelle (wot-novel.md) :**
> Dialogues : Utiliser les guillemets pour les répliques.

**Règle améliorée :**
> **Dialogues :** TOUJOURS utiliser les guillemets français `« »` avec espaces insécables.
> - ❌ "Je ne peux pas", dit-il.
> - ✅ « Je ne peux pas », dit-il.
> 
> **Référence :** @docs/typographie.md (section Guillemets)

**Impact estimé :**
- Chapitres concernés : 01, 03, 05, 08, 11 (5 nouvelles)
- Personas impactés : +2.5 points (Professeure), +1.2 (Fan WoT)
- Réduction corrections doctor : ~80% sur ce point

**Action requise :**
- [ ] Approuver modification
- [ ] Re-run doctor.prompt.md sur chapitres 01, 03, 05, 08, 11
- [ ] Re-évaluer avec comment.prompt.md
```

### Step 7C: Validation Pattern-by-Pattern

**Présenter au user :**

```
🔴 #1 : Guillemets français (15 occurrences, 3 chapitres)
   → [Appliquer] [Modifier] [Ignorer]

🟡 #2 : Phrases longues >40 mots (8 occurrences, 2 chapitres)
   → [Appliquer] [Modifier] [Ignorer]

🟢 #3 : Variété structures (4 occurrences, 1 chapitre)
   → [Appliquer] [Modifier] [Ignorer]
```

**Pour chaque approbation :**
1. Mettre à jour `<univers>/.output-styles/<type>.md`
2. Incrémenter version (1.0 → 1.1 si mineur, 2.0 si majeur)
3. Logger dans `.docs/output-style-changelog.md`

### Step 7D: Generate Changelog

**Créer/mettre à jour :** `.docs/output-style-changelog.md`

```markdown
# Changelog Output-Style : WoT

## v1.1 (2026-02-13) - Amélioration Typographie

**Source :** Feedback personas (chapitres 01, 03, 05)

### Added
- Règle explicite guillemets français « » avec exemples
- Référence à @docs/typographie.md

### Changed
- Dialogue : clarification tirets cadratins obligatoires

### Impact
- Chapitres à re-générer : 01, 03, 05, 08, 11
- Personas améliorés : Professeure (+2.5), Fan WoT (+1.2)

---

## v1.0 (2026-01-15) - Création Initiale
...
```

### Step 7E: Suggest Remediation Plan

```markdown
## 📋 Plan de Remédiation

### Étape 1 : Mise à jour output-style
- [x] wot-novel.md v1.0 → v1.1

### Étape 2 : Re-correction chapitres affectés
```bash
# Re-run doctor sur chapitres avec ancien style
doctor.prompt.md chapitres/chapitre01.md
doctor.prompt.md chapitres/chapitre03.md
doctor.prompt.md chapitres/chapitre05.md
```

### Étape 3 : Re-évaluation personas
```bash
# Vérifier amélioration scores
comment.prompt.md chapitres/chapitre01.md professeure-francais
```

### Étape 4 : Validation
- [ ] Scores personas ≥ 7/10
- [ ] Corrections doctor réduites de 50%+
- [ ] Aucune régression sur autres personas
```
