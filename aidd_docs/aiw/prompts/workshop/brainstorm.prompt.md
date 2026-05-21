---
name: brainstorm
description: Itérer sur l'overview du projet, challenger les concepts, proposer des alternatives jusqu'à generate-toc
argument-hint: Chemin vers le projet (ex: "zombiology/quonleurcoupelatete")
---

# Brainstorm

## Goal

Accompagner l'utilisateur dans l'élaboration et le raffinement de son concept de projet, en challengeant les idées, proposant des alternatives, et itérant jusqu'à ce que l'overview soit suffisamment solide pour passer à la génération de la table des matières.

**Durée typique :** 3-8 itérations avant d'atteindre les critères de sortie.

**Boucle :**
```
Analyser → Challenger → Proposer → Valider → Mettre à jour → Répéter
```

## Context

### Configuration Projet

```yaml
@$ARGUMENTS/bank.yml
```

**Si bank.yml est absent ou invalide :**
```
Le projet n'a pas de fichier bank.yml valide.
Veuillez d'abord créer la configuration du projet avec le template :
@docs/templates/bank.yml
```

### Chargement des Ressources

Lire bank.yml et charger **tous** les fichiers déclarés :

1. **Overview :** Le fichier référencé dans `overview`
2. **Documentation :** Tous les fichiers référencés dans la section `docs`
3. **Type de document :** Noter `document.type` pour adapter les questions (défaut : "scenario")
4. **Output-style :** Charger le(s) fichier(s) référencé(s) dans `output-style` pour guider les questions de ton et filtrer la pertinence des alternatives

Ne pas inventer de chemins. Suivre uniquement les liens présents dans bank.yml.

## Rules

- Sortie en français
- Mode conversationnel : poser des questions, ne pas imposer
- Challenger les idées sans les rejeter
- Proposer des alternatives, pas des remplacements
- **Maximum 2-3 questions par itération** (ne pas submerger l'utilisateur)
- Mettre à jour l'overview **uniquement dans le fichier pointé par `overview:` dans bank.yml**
- Ne jamais inventer de contenu sans validation utilisateur
- MOINS C'EST PLUS : un concept clair vaut mieux que dix idées floues
- Utiliser la documentation univers pour vérifier la cohérence
- Si un sujet manque de documentation, suggérer `@research.prompt.md "<sujet>"`

## Étapes

### 0. Vérifier l'État du Projet

**Si l'overview existe et contient un Pitch + au moins 2 sections complètes :**

```markdown
Je reprends le brainstorm sur [nom du projet].

**Bilan actuel :**
- Concept : [résumé du pitch actuel]
- Éléments validés : [lister]
- Zones encore floues : [lister]

On continue là où on s'est arrêtés. Prochaines questions :
[2-3 questions sur les zones floues identifiées]
```

**Si l'overview n'existe pas :**

> Note : ne jamais inventer de contenu — tout ce qui suit vient des réponses de l'utilisateur.

```markdown
Je vois que le projet n'a pas encore d'overview.

Pour commencer, décris-moi ton concept en quelques phrases :
- De quoi parle ce projet ?
- Quel est le genre/ton visé ?
- Qui sont les protagonistes (ou les joueurs, si c'est un jeu de rôle) ?
```

Après les premières réponses, créer un overview minimal adapté au type :

**Pour `scenario` et `novel` :**
```markdown
# [Titre du projet]

## Pitch
[2-3 phrases de concept]

## Structure
[À définir]

## Protagonistes
[Liste initiale]

## Ton
[Atmosphère visée]
```

**Pour `roleplaying` :**
```markdown
# [Titre du projet]

## Pitch
[2-3 phrases de concept]

## Livrets / Callings visés
[À définir]

## Mécanique centrale
[Règles impliquées]

## Ton
[Atmosphère visée]
```

**Pour `guide` :**
```markdown
# [Titre du projet]

## Pitch
[2-3 phrases de concept]

## Sections prévues
[À définir]

## Public cible
[Qui lit ce guide ?]

## Ton
[Registre visé : référence / tutoriel / essai]
```

**Si l'overview existe et est minimal :** Passer directement à l'étape 1.

### 1. Analyser l'Overview Existant

Lire le fichier overview (depuis bank.yml) et identifier :

**Éléments présents :**
- Concept central (pitch)
- Structure narrative (actes, séances, chapitres)
- Personnages principaux
- Thèmes
- Ton et atmosphère

**Éléments manquants ou flous :**
- Zones d'ombre narratives
- Motivations non explicites
- Conflits non résolus
- Questions sans réponse

**Cohérence de ton :** Vérifier si le ton décrit dans l'overview correspond au style défini dans `output-style`. Si divergence, le signaler et demander si elle est intentionnelle.

### 2. Challenger le Concept

Poser des questions pour tester la solidité du concept. Utiliser la documentation univers pour vérifier la cohérence.

**Format standard de question :**
```
Je remarque que [observation].
- Option A : [alternative 1]
- Option B : [alternative 2]
- Option C : conserver tel quel

Qu'en penses-tu ?
```

**Questions de fond :**
- Pourquoi cette histoire doit-elle être racontée ?
- Qu'est-ce qui la rend unique ?
- Quel est l'enjeu central pour les protagonistes ?

**Questions de cohérence :**
- Les motivations des antagonistes sont-elles crédibles ?
- Les obstacles sont-ils à la hauteur des enjeux ?
- La progression est-elle logique ?

**Questions pratiques :**
- Le scope est-il réaliste pour le format visé ?
- Les ressources documentaires sont-elles suffisantes ?
- Y a-t-il des trous dans l'univers à combler ?

**Questions spécifiques au type :**

| Type | Questions supplémentaires |
|------|--------------------------|
| scenario | Rôle des PJ ? Liberté d'action ? Points de décision ? |
| novel | Point de vue narratif ? Arcs émotionnels ? |
| roleplaying | Règles concernées ? Callings/livrets visés ? Exemples de jeu ? |
| guide | Structure de référence ou de lecture ? Index prévu ? |

**Techniques de questionnement :**

- **"Et si…?"** — Variations radicales (Et si l'antagoniste avait raison ?)
- **"Pourquoi pas…?"** — Challenger les choix implicites (Pourquoi ce lieu ?)
- **"5 Pourquoi"** — Creuser jusqu'à la racine (Pourquoi X ? → Pourquoi Y ? → …)
- **"Conséquences?"** — Explorer les ramifications (Que se passe-t-il si échec ?)
- **"Avocat du diable"** — Défendre le point de vue opposé pour tester la solidité
- **Inversion** — Inverser un élément pour voir ce que ça révèle

**Si lacune documentaire identifiée :**
```
Ce sujet ([sujet]) n'est pas assez documenté pour avancer.
Je suggère : @research.prompt.md "[sujet]"
```

**Si contradiction avec la documentation :**
```
Je note que [élément de l'overview] semble contredire [élément de la doc].
- Est-ce intentionnel (divergence voulue) ?
- Faut-il mettre à jour la documentation ?
- Faut-il modifier l'overview ?
```

### 3. Proposer des Alternatives

Pour chaque zone floue ou problème identifié, proposer 2-3 alternatives.

**Avant de proposer :** vérifier que les options sont compatibles avec le ton et les contraintes définies dans `output-style`. Signaler si une option s'en écarte.

```markdown
## [Sujet]

**Situation actuelle :** [description]
**Problème potentiel :** [ce qui pourrait ne pas fonctionner]

**Option A — [Nom] :** [Description]
  - Avantage : [point fort]
  - Inconvénient : [point faible]
  - Compatibilité output-style : [conforme / diverge sur : ...]

**Option B — [Nom] :** [Description]
  - Avantage : [point fort]
  - Inconvénient : [point faible]
  - Compatibilité output-style : [conforme / diverge sur : ...]

**Option C — Conserver l'actuel :**
  - Avantage : [pourquoi ça peut marcher]
  - Risque : [ce qu'il faut surveiller]
```

### 4. Itérer et Mettre à Jour

Après chaque réponse de l'utilisateur :

1. Intégrer les décisions dans une version mise à jour de l'overview
2. Identifier les nouvelles questions soulevées (max 2-3)
3. Proposer la mise à jour et demander validation :

```markdown
Je vais mettre à jour l'overview avec :

**Ajouts :** [élément 1], [élément 2]
**Modifications :** [avant] → [après]
**Suppressions :** [élément retiré]

Confirmes-tu ?
```

4. Écrire seulement après validation, dans le fichier pointé par `overview:` dans bank.yml.

**Si l'utilisateur rejette la mise à jour :**
```
D'accord, je ne modifie pas l'overview.
Peux-tu préciser ce qui ne convient pas ? Je reformule ma proposition.
```

**Si l'utilisateur veut pivoter/recommencer :**
```
Tu veux repartir sur une nouvelle direction. Avant d'effacer l'overview actuel :
- Veux-tu sauvegarder une copie de la version actuelle ?
- Quel est le nouveau concept de départ ?
```

### 5. Gérer les Fichiers de Détails

**Déclencheur :** créer ces fichiers uniquement si le projet comprend **3 parties distinctes ou plus** (scénarios, nouvelles, livrets, sections). Pour un projet à partie unique, l'overview suffit.

**Pour les campagnes multi-scénarios** (`document.type: scenario`) :
- Créer/mettre à jour `.docs/scenarios-details.md`
- Contenu : synopsis de chaque scénario, liens narratifs, arcs transversaux

**Pour les recueils multi-nouvelles** (`document.type: novel`) :
- Créer/mettre à jour `.docs/novels-details.md`
- Contenu : synopsis de chaque nouvelle, thèmes communs, ordre de lecture

**Pour les documents de jeu de rôle** (`document.type: roleplaying`) :
- Créer/mettre à jour `.docs/livrets-details.md`
- Contenu : liste des Callings/livrets visés, mécanique centrale de chacun, ordre de présentation

**Pour les guides** (`document.type: guide`) :
- Créer/mettre à jour `.docs/sections-details.md`
- Contenu : sections prévues, public cible de chaque section, structure de référence vs lecture linéaire

**Structure type :**
```markdown
# [Scénarios|Nouvelles|Livrets|Sections] : [Nom du projet]

## Vue d'Ensemble
[Description de l'ensemble, thèmes communs, progression]

## [Titre 1]
**Position :** [1er, 2ème, …]
**Synopsis :** [2-3 phrases]
**Liens :** [connexions avec les autres]
**Enjeux spécifiques :** [ce qui est propre à celui-ci]

## [Titre 2]
...

## Arcs Transversaux
- [Arc 1] : [description, progression à travers les épisodes]
- [Arc 2] : ...
```

### 6. Vérifier la Complétude

Avant de passer à la suite, vérifier que l'overview contient :

**Obligatoire (tous types) :**
- [ ] Concept clair en 2-3 phrases (pitch)
- [ ] Structure narrative (début, milieu, fin)
- [ ] Protagonistes identifiés avec motivations
- [ ] Antagonistes/obstacles identifiés
- [ ] Enjeux clairs
- [ ] Ton et atmosphère définis

**Selon document.type :**

| Type | Éléments supplémentaires |
|------|-------------------------|
| scenario | Rôle des PJ, liberté d'action, points de décision |
| novel | Point de vue, arcs émotionnels, dénouement |
| roleplaying | Callings/livrets identifiés, règles applicables, conseils MJ |
| guide | Sections identifiées, public cible, structure de référence |

**Recommandé :**
- [ ] Thèmes explorés
- [ ] Arcs de personnages esquissés
- [ ] Points de bascule identifiés

**Critère de sortie :**
Proposer la suite quand :
- Tous les éléments obligatoires sont présents
- L'utilisateur n'a plus de questions majeures
- Les 2-3 dernières itérations n'ont apporté que des ajustements mineurs

### 7. Valider et Transitionner

Quand l'overview est complet :

```markdown
## Résumé du Concept

[Pitch final en 3-5 phrases]

## Éléments Validés

- Concept : OK | Structure : OK | Personnages : OK | Enjeux : OK | Ton : OK

## Overview écrit

Fichier mis à jour : [chemin pointé par `overview:` dans bank.yml]

## Prêt pour la Suite
```

**Prochaine étape selon le type :**

| document.type | Prochaine étape suggérée |
|---|---|
| scenario | `@docs/prompts/workshop/generate-toc.prompt.md $ARGUMENTS` |
| novel | `@docs/prompts/workshop/generate-toc.prompt.md $ARGUMENTS` |
| guide | `@docs/prompts/workshop/generate-toc.prompt.md $ARGUMENTS` |
| roleplaying | `@docs/prompts/workshop/generate-toc.prompt.md $ARGUMENTS` — ou directement `@docs/prompts/workshop/write-roleplaying.prompt.md 1` si le projet est un livret unique |

## Exemples de Dialogue

**Exemple 1 — Scénario (recherche documentaire)**

```
CLAUDE : Je remarque que le scénario se déroule pendant la Révolution mais
         la documentation sur le vaudou haïtien est absente.
         Le lien avec Saint-Domingue nécessite ces informations.
         Je suggère : @research.prompt.md "vaudou haïtien cérémonie Bois-Caïman"

USER :   Bonne idée, fais la recherche.

[... après research ...]

CLAUDE : La recherche a enrichi la documentation. Je peux maintenant challenger :
         Le scénario mentionne "les PJ découvrent la vérité" mais cette
         vérité n'est pas définie.
         - Option A : La vérité est un complot politique lié aux Jacobins
         - Option B : La vérité est une malédiction vaudou ramenée de Saint-Domingue
         - Option C : Laisser volontairement flou pour l'instant
         Qu'en penses-tu ?

USER :   Option B, ça mélange bien les deux contextes historiques.

CLAUDE : Je vais mettre à jour l'overview avec :
         **Ajouts :** La vérité = malédiction vaudou originaire de Saint-Domingue
         Confirmes-tu ?

USER :   Oui.

CLAUDE : [Met à jour l'overview]
         Nouvelle question : qui a ramené cette malédiction en France ?
```

**Exemple 2 — Jeu de rôle (livret de Calling, divergence de ton)**

```
CLAUDE : Je vois que le projet vise un livret de Calling pour un personnage
         de type "Gardien du temple". Deux questions :
         - Option A : Ce Calling est centré sur la défense passive (Moves défensifs)
           → Conforme à l'output-style "analytique et fonctionnel"
         - Option B : Ce Calling est centré sur la transmission (Moves de transmission de savoir)
           → Conforme à l'output-style "analytique et fonctionnel"
         - Option C : Les deux, avec un dilemme thématique entre les deux postures
           → Diverge légèrement : nécessite une section narrative pour le dilemme
         Et côté ton : l'output-style indique "analytique et fonctionnel" —
         le livret doit-il refléter ça, ou veux-tu une exception plus narrative ?

USER :   Option C, et je veux le ton plus narratif pour ce livret.

CLAUDE : Je note la divergence de ton — je la documente dans l'overview
         pour que write-roleplaying puisse l'appliquer.
         Prochaine question : quel est le Move signature de ce Calling ?
```
