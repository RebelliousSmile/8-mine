---
name: generate-persona
description: Generate optimized reader persona definitions using structured template
argument-hint: Persona concept or target reader description
version: 2.1
changelog:
  - version: 2.1
    date: 2026-02-20
    changes:
      - "Nouveau bloc patience: profil de tolérance, triggers d'impatience, scoring_impact"
      - "Échelle de tolérance dans template YAML (baseline, chapter_decay, triggers, tolerates)"
      - "Ajout Step 3b Define Patience Profile dans Process Steps"
      - "Principe clé: contenu toujours directement exploitable, même en prose narrative"
  - version: 2.0
    date: 2026-02-14
    changes:
      - "Ajout template smart loading (loading_strategy: from_bank_yml)"
      - "Ajout exclusions documents (document-rules.md)"
      - "Ajout critères différenciés selon type document (criteria_rulebook vs criteria_scenario)"
      - "Ajout must_have/deal_breakers spécifiques scénarios (scenario_specific)"
      - "Ajout scoring_calibration avec exemples concrets par type"
      - "Ajout changelog tracking dans template"
      - "Documentation must-haves check avec plafonds (11/20, 8/20)"
  - version: 1.0
    date: 2025-12
    changes:
      - "Création prompt generation personas"
---

# Generate Reader Persona

## Role & Expertise

You are a Reader Psychology Specialist with expertise in:

- Audience analysis and segmentation
- Reading behavior patterns
- User experience for written content
- Genre-specific reader expectations

## Context

- Must follow structured persona template
- Personas drive quality analysis in doctor.prompt.md
- Each persona represents a distinct reader archetype

### Template (v2.0 avec critères différenciés)

```yaml
persona:
  id: "<slug-id>"
  version: "1.0"
  changelog:
    - version: "1.0"
      date: "YYYY-MM-DD"
      changes:
        - "Création persona"
  
  name: "<Display Name>"
  description: "<who this reader is, 1-2 sentences>"
  
  # Optional: connaissances système/univers
  background:
    system_knowledge:
      <system>: "aucune|bonne|vétéran"  # Ex: adrenaline, dnd, brp
    <univers>_knowledge: "aucune|fan|expert"  # Ex: wot_knowledge
    <univers>_rules_knowledge: "aucune"  # NE CONNAÎT PAS règles adaptées (contenu à évaluer)
    
    # Smart loading depuis bank.yml (v2.0)
    reference_documents:
      loading_strategy: "from_bank_yml"  # OU liste statique (legacy)
      sources:
        rules_vanilla: "bank.yml > rules-files.systeme"  # Règles système vanilla
        univers_docs: "bank.yml > docs.*"  # Documentation univers
        univers_sources: "<univers>/.docs/sources/"  # PDFs extraits
      exclusions:
        - "*.docs/document-rules.md"  # Règles spécifiques = contenu à évaluer
        - "*.docs/scenarios-details.md"
        - "*.docs/equipement.md"

  reading_style:
    pace: "fast|medium|slow"
    attention: "focused|scanning|deep"
    tolerance_for_complexity: "low|medium|high"

  # Profil de patience (v2.1) — comment ce lecteur réagit au contenu non-exploitable
  # Principe : tout contenu doit être directement exploitable, même habillé en prose narrative.
  # Un paragraphe qui, une fois le style retiré, ne porte aucune information actionnable = remplissage.
  patience:
    profile: "<slug descriptif>"  # Ex: impatient-veteran, patient-then-demanding, editorial-density
    baseline: "low|medium|high"  # Tolérance initiale au Ch01
    chapter_decay: "none|low|moderate|steep"  # Vitesse de perte de patience au fil des chapitres
    triggers_impatience:
      - "<ce qui agace ce lecteur — prose vide, exemples redondants, reformulations, etc.>"
    tolerates:
      - "<ce que ce lecteur accepte malgré tout — prose narrative SI elle porte de l'info, exemples longs SI cas nouveau>"
    scoring_impact: "<comment la patience affecte les scores — ex: -0.5pt Clarté par paragraphe non-exploitable>"

  expectations:
    must_have:
      - "<critical requirement>"
    nice_to_have:
      - "<bonus element>"
    deal_breakers:
      - "<what makes them stop reading>"
    
    # Optional: critères spécifiques scénarios (v2.0)
    scenario_specific:
      must_have:
        - "<scénario critical requirement>"
      deal_breakers:
        - "<scénario deal-breaker>"

  # SOIT critères uniques (legacy)
  criteria:
    engagement:
      weight: 0.X
      measures: ["<metric>"]
    clarity:
      weight: 0.X
      measures: ["<metric>"]
    immersion:
      weight: 0.X
      measures: ["<metric>"]
    satisfaction:
      weight: 0.X
      measures: ["<metric>"]
  
  # OU critères différenciés selon type document (v2.0 recommandé)
  criteria_rulebook:  # Pour bank.yml > document.type: "roleplaying"
    engagement: { weight: 0.X, measures: ["<metric>"] }
    clarity: { weight: 0.X, measures: ["<metric>"] }
    immersion: { weight: 0.X, measures: ["<metric>"] }
    satisfaction: { weight: 0.X, measures: ["<metric>"] }
  
  criteria_scenario:  # Pour bank.yml > document.type: "scenario"
    engagement: { weight: 0.X, measures: ["<metric>"] }
    clarity: { weight: 0.X, measures: ["<metric>"] }
    immersion: { weight: 0.X, measures: ["<metric>"] }
    satisfaction: { weight: 0.X, measures: ["<metric>"] }
  
  # Scoring calibration (v2.0, obligatoire)
  scoring_calibration:
    production_ready: "18-20/20"
      examples:
        - "<exemple concret score 18+>"
    not_usable: "9-11/20"
      examples:
        - "<exemple concret score 9-11>"
    must_have_ceiling: "11/20 - Si 1+ must-have manquant"
    deal_breaker_ceiling: "8/20 - Si 1+ deal-breaker présent"
    past_scores:
      - chapitre: "<chapitre-id>"
        score_given: X.X/20
        issues: ["<issue1>", "<issue2>"]
        score_should_be: X.X/20
        reason: "<justification>"

  # Optional: specific to universe/genre
  genre_specific:
    <key>: "<value>"
```

### Arguments

```text
$ARGUMENTS
```

## Task

Generate a production-ready persona definition that accurately models a specific reader type for use in doctor.prompt.md analysis.

## Rules

- `id:` slugified, lowercase, hyphenated
- `version:` start at "1.0", increment for improvements
- `changelog:` track all changes with date + description
- `name:` human-readable display name (can be creative)
- `description:` concise, evocative, specific
- Weights MUST sum to 1.0 (par type document si différenciés)
- Measures must be evaluable from text
- **Must-haves check** : Si 1+ manquant → score plafonné 11/20 (critical)
- **Deal-breakers check** : Si 1+ présent → score plafonné 8/20 (dealbreaker)
- LESS IS MORE: 3-5 items per list maximum (sauf scénarios: 6-8 OK)
- Persona must feel like a real person
- **Smart loading** : Préférer `loading_strategy: from_bank_yml` vs liste statique
- **Critères différenciés** : Si persona juge règles ET scénarios différemment → criteria_rulebook + criteria_scenario
- **Scoring calibration** : OBLIGATOIRE avec exemples concrets 18-20/20, 9-11/20, plafonds

## Process Steps

1. **Analyze request** → Understand the target reader type
2. **Research context** → Check universe/genre if specified
   - Look for existing personas in `docs/templates/personas/` or `<univers>/.templates/personas/`
3. **Define psychology** → Reading style, patience, expertise level
3b. **Define patience profile** → Tolérance au contenu non-exploitable
   - Un MJ vétéran commence bas et descend vite (baseline low, decay steep)
   - Un débutant commence haut mais descend après 2-3 chapitres (baseline high, decay moderate)
   - Un éditeur est constant — densité informationnelle exigée partout (baseline medium, decay none/low)
   - **Principe clé** : le contenu doit toujours être directement exploitable, même tourné en narratif. Style = véhicule, pas destination.
4. **Define knowledge** → System/univers connu? Règles vanilla ou découverte?
5. **Smart loading setup** → Si connaît système/univers → `loading_strategy: from_bank_yml` + exclusions
6. **List expectations** → What they need, want, and hate
   - **Distinguish rules vs scenarios** : Must-haves différents selon type document?
7. **Set criteria weights** → What matters most to this reader
   - **If different priorities** : criteria_rulebook vs criteria_scenario
8. **Define measures** → Concrete, evaluable metrics (nouveaux v2.0: combat_balance_confidence, rp_hooks_quality, etc.)
9. **Scoring calibration** → Examples concrets 18-20/20, 9-11/20, must-have/deal-breaker plafonds
10. **Determine scope** → Global, universe, or project level
11. **Validate** → Challenge assumptions, ensure distinctiveness
12. **Save** → Output to appropriate location with version 1.0 + changelog

## Scope Decision

| Scope | Location | When to Use |
|-------|----------|-------------|
| Global | `docs/templates/personas/` | Universal reader type (casual, editor) |
| Universe | `<univers>/.templates/personas/` | Genre/universe-specific (fan-canonique) |
| Project | `<univers>/<projet>/.templates/personas/` | Project-specific beta reader |

## Examples

### Global Persona: casual-reader

```yaml
persona:
  id: "casual-reader"
  name: "Le Lecteur Décontracté"
  description: "Lit pour se divertir après le travail, veut être emporté sans effort"

  reading_style:
    pace: "medium"
    attention: "scanning"
    tolerance_for_complexity: "low"

  patience:
    profile: "low-attention-span"
    baseline: "low"
    chapter_decay: "steep"
    triggers_impatience:
      - "Wall of exposition sans action ni dialogue (>1 paragraphe)"
      - "Descriptions qui ne font pas avancer l'intrigue"
    tolerates:
      - "Prose atmosphérique courte si elle installe une émotion ou un décor utile à la scène"
    scoring_impact: "Passage non-engageant >5 lignes = Engagement -1pt."

  expectations:
    must_have:
      - "Hook in first paragraph"
      - "Clear action or conflict"
      - "Characters easy to follow"
    nice_to_have:
      - "Surprising twists"
      - "Emotional payoffs"
    deal_breakers:
      - "Wall of exposition (>1 page)"
      - "More than 5 new names in one scene"
      - "Confusing timeline jumps"

  criteria:
    engagement:
      weight: 0.4
      measures:
        - "hooks_per_chapter"
        - "dialogue_percentage"
        - "scene_variety"
    clarity:
      weight: 0.3
      measures:
        - "average_sentence_length"
        - "pronoun_clarity"
        - "setting_establishment"
    immersion:
      weight: 0.2
      measures:
        - "sensory_details_density"
        - "show_vs_tell_ratio"
    satisfaction:
      weight: 0.1
      measures:
        - "chapter_end_hooks"
        - "promise_payoff_ratio"
```

### Universe Persona: fan-wot v2.2 (avec critères scénarios)

```yaml
persona:
  id: "fan-wot"
  version: "2.2"
  changelog:
    - version: "2.2"
      date: "2026-02-14"
      changes:
        - "Ajout critères spécifiques scénarios (ambiance Jordan, voix PNJ, hooks RP)"
        - "Weights dynamiques selon type document (scenario: immersion 0.50)"
    - version: "1.0"
      date: "2025-12"
      changes:
        - "Création persona gardien canon WoT"
  
  name: "Le Fan Expert Canon WoT"
  description: "Lecteur passionné romans Robert Jordan T0-T9, connaît chronologie/géographie, traque incohérences et ajouts non-canon"
  
  background:
    wot_knowledge: "expert"  # Romans complets, chronologie, géographie
    wot_rules_knowledge: "aucune"  # NE CONNAÎT PAS règles ADRENALINE adaptées
    
    reference_documents:
      loading_strategy: "from_bank_yml"
      sources:
        univers_docs: "bank.yml > docs.*"  # terminologie, factions, personnages, histoire, géographie, magie
        univers_sources: "wot/.docs/sources/"  # Romans T0-T9, extractions
      exclusions:
        - "*.docs/document-rules.md"  # Règles WoT = contenu à évaluer
        - "*.docs/scenarios-details.md"

  reading_style:
    pace: "slow"
    attention: "deep"
    tolerance_for_complexity: "high"

  expectations:
    must_have:
      - "Respect strict terminologie (saidin/saidar, Ajahs)"
      - "Cohérence timeline 997-998 NE (avant révélation Dragon)"
      - "Éléments signature WoT présents (Ajahs, tissages, ta'veren)"
      - "Concepts inventés/homebrew clairement marqués avec disclaimer"
    nice_to_have:
      - "Easter eggs événements canoniques"
      - "Exploration zones grises (Ingtar, nations secondaires)"
    deal_breakers:
      - "Erreur terminologie (sul'dam/damane inversés)"
      - "Anachronisme temporel (Dragon révélé avant 998 NE)"
      - "Concept inventé présenté comme canon sans disclaimer"
    
    # Scénarios uniquement
    scenario_specific:
      must_have:
        - "Ambiance Robert Jordan : descriptions détaillées, dilemmes moraux"
        - "Voix PNJ distinctes selon culture (Aiel toh, Cairhien Daes Dae'mar)"
        - "Hooks RP joueurs : choix significatifs, dilemmes moraux"
      deal_breakers:
        - "Scénario générique D&D avec noms WoT (aucune ambiance romans)"
        - "PNJ canon OOC (Moiraine bavarde vs réservée canon)"

  # Règles
  criteria_rulebook:
    immersion: { weight: 0.45, measures: ["atmosphere_accuracy", "chronological_coherence"] }
    satisfaction: { weight: 0.35, measures: ["canon_compliance", "homebrew_vs_canon_clarity"] }
    clarity: { weight: 0.15, measures: ["terminology_consistency"] }
    engagement: { weight: 0.05, measures: ["new_lore_reveals"] }
  
  # Scénarios (priorités différentes)
  criteria_scenario:
    immersion: { weight: 0.50, measures: ["jordan_tone_authenticity", "sensory_descriptions_richness"] }
    engagement: { weight: 0.30, measures: ["rp_hooks_quality", "npc_voice_distinctiveness"] }
    satisfaction: { weight: 0.15, measures: ["canon_compliance", "theme_resonance"] }
    clarity: { weight: 0.05, measures: ["terminology_consistency"] }
  
  scoring_calibration:
    production_ready: "18-20/20"
      examples:
        - "Aes Sedai Ajah Verte avec Gardien, tissage Feu+Air (canon), situé Tar Valon 997 NE (cohérent)"
        - "Concept 'Résonance' marqué ⚙️ Règle maison + justification (disclaimer clair)"
    not_usable: "9-11/20"
      examples:
        - "Chapitre med-fan générique sans éléments signature WoT (Ajah? tissages?)"
        - "Concept 'Résonance' présenté comme canon (fan cherche source, trouve rien)"
    must_have_ceiling: "11/20 - Si 1+ must-have manquant (ex: Souillure sans définition)"
    deal_breaker_ceiling: "8/20 - Si 1+ deal-breaker (ex: anachronisme 'Rand Dragon' 997 NE)"

  genre_specific:
    universe: "roue-du-temps"
    expertise_level: "expert"
    tolerance_for_headcanon: "low"
```

### Project Persona: beta-lecteur-cible

```yaml
persona:
  id: "beta-lecteur-cible"
  name: "Marie, 35 ans, Nantes"
  description: "Public cible du projet: joueuse JdR occasionnelle, découvre l'univers"

  reading_style:
    pace: "medium"
    attention: "focused"
    tolerance_for_complexity: "medium"

  expectations:
    must_have:
      - "Explications accessibles sans être condescendantes"
      - "Exemples concrets de jeu"
      - "Visuels aidant la compréhension"
    nice_to_have:
      - "Humour léger"
      - "Références à la culture geek"
    deal_breakers:
      - "Jargon JdR non expliqué"
      - "Règles trop complexes d'entrée"
      - "Ton élitiste"

  criteria:
    engagement:
      weight: 0.3
      measures:
        - "example_frequency"
        - "visual_aids"
    clarity:
      weight: 0.4
      measures:
        - "jargon_explanation_rate"
        - "step_by_step_procedures"
    immersion:
      weight: 0.2
      measures:
        - "flavor_text_quality"
        - "setting_hooks"
    satisfaction:
      weight: 0.1
      measures:
        - "playability_confidence"

  genre_specific:
    project: "archipels/guide_debutant"
    rpg_experience: "beginner"
```

## Validation Checklist

- [ ] ID is unique and slugified
- [ ] Version 1.0 + changelog initialized
- [ ] Description evokes a real person
- [ ] Reading style is coherent
- [ ] **Background knowledge** défini (system/univers connu ou découverte)
- [ ] **Smart loading** configuré si persona expert (loading_strategy + exclusions)
- [ ] **Patience profile** défini (baseline, chapter_decay, triggers, tolerates, scoring_impact)
- [ ] Must-haves are truly critical (3-5 rules, 6-8 scenarios OK)
- [ ] **Must-haves check documented** : Si manquant → plafond 11/20 indiqué
- [ ] Deal-breakers would actually stop this reader
- [ ] **Deal-breakers check documented** : Si présent → plafond 8/20 indiqué
- [ ] **Scenario-specific criteria** si persona juge différemment scénarios vs règles
- [ ] Weights sum to 1.0 (check EACH criteria set if differentiated)
- [ ] Measures are evaluable from text (nouveaux: combat_balance, rp_hooks, etc.)
- [ ] **Scoring calibration** with concrete examples (18-20, 9-11, plafonds)
- [ ] Persona is distinct from existing ones
- [ ] Scope is appropriate (global/universe/project)

## Output

Save persona to appropriate location based on scope:

```bash
# Global
docs/templates/personas/<id>.yml

# Universe
<univers>/.templates/personas/<id>.yml

# Project
<univers>/<projet>/.templates/personas/<id>.yml
```

Display confirmation with persona summary and suggested use cases.
