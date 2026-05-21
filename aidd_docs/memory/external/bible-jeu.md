# 8-MINE — Bible du Jeu Vidéo

> Néo-Paris · 2084 · Jeu Narratif Cyberpunk — Version 1.0

*Huit résidents corporatistes. Une journaliste sans protection. Un immeuble-laboratoire où chacun tire la couverture à soi. Tes choix détermineront qui survit.*

---

## Sommaire

1. [Vision & Pitch](#1-vision--pitch)
2. [Expérience Joueur & Thématiques](#2-expérience-joueur--thématiques)
3. [Univers — Néo-Paris 2084](#3-univers--néo-paris-2084)
4. [Les 4 Corporations](#4-les-4-corporations)
5. [Personnage Joueur — Margot Sinclair](#5-personnage-joueur--margot-sinclair)
6. [Cast — Les 8 Résidents](#6-cast--les-8-résidents)
7. [Mécaniques de Jeu](#7-mécaniques-de-jeu)
8. [Structure Narrative](#8-structure-narrative)
9. [Direction Artistique](#9-direction-artistique)
10. [Inspirations](#10-inspirations)
11. [Stack Technique](#11-stack-technique)

---

## 1. Vision & Pitch

### Pitch

**8-MINE** est un jeu narratif cyberpunk en vue subjective où vous incarnez **Margot Sinclair**, journaliste freelance infiltrée dans un immeuble-laboratoire de contrôle social corporatiste.

Vous êtes officiellement là pour documenter le *coliving parisien nouvelle génération*. En réalité, vous êtes une **variable de stress contrôlée** dans un test de contrôle social avant déploiement urbain massif.

L'immeuble observe. Vous observez. Et la question qui n'aura de réponse qu'à la fin du jeu : *en cherchant à exposer le système, êtes-vous en train de le reproduire ?*

### Format

| Critère | Valeur |
|---|---|
| Genre | Visual novel / Jeu d'investigation narratif (type *Life is Strange*, *Disco Elysium*) |
| Durée | 2 à 3 heures de jeu · 4 actes · 32 chapitres |
| Plateforme | Desktop (Windows / macOS) — Moteur : Godot 4 |
| Public | Adulte — contenu mature (surveillance, manipulation, trauma relationnel) |

### Phrase-clé

> « L'ambiance est celle d'une prison de luxe. L'oppression n'est pas violente mais omniprésente : 17 caméras, analyse comportementale, crédit solidaire qui enchaîne. La vraie horreur est sociale : devenir ce qu'on déteste pour survivre. »

### Thèmes porteurs

| Thème | Description |
|---|---|
| 👁 Surveillance vs liberté | Être observé en permanence change le comportement. Qui regarde qui ? |
| 🏢 Contrôle corporatiste | L'interdépendance financière comme auto-régulation. La prison dorée. |
| 🪞 Devenir ce qu'on déteste | Margot reproduit-elle les patterns de Julien/Julie ? La vérité justifie-t-elle les moyens ? |
| 📰 Éthique journalistique | Exposer vs protéger. Information publique vs respect des personnes. |
| 🗡 Trahisons multiples | Personne n'est sûr, même la famille. La loyauté a un prix corporatiste. |
| 💔 Trauma relationnel | Guérir de Julien/Julie sans reproduire ses patterns de contrôle et surveillance. |

### Calibrage tonal

| Axe | Score /10 | Signification |
|---|---|---|
| Intensité | **8** | Menace de mort réelle, effondrement psychologique possible |
| Espoir | **4** | Sombre mais pas désespéré — l'espoir se mérite |
| Réalisme | **7** | Technologies crédibles, psychologie authentique |

---

## 2. Expérience Joueur & Thématiques

### Ce que le joueur doit ressentir

**Démêler sans fracturer.**
Chaque résident a ses secrets — personnels, de couple, corporatistes. Le joueur veut l'information, mais forcer, exposer trop vite, mal choisir ses mots ferme des portes définitivement. La patience et la nuance sont des outils autant que la ruse. Les secrets sont en couches : démêler l'un peut en révéler un autre involontairement.

**Trouver les bons mots.**
Margot est journaliste — la même question posée différemment donne des réponses différentes. Le joueur ne choisit pas seulement *quoi* demander mais *comment*. Le langage est une arme, un outil, et parfois un piège.

**Accepter l'altérité.**
Les exécutants du système ne sont pas des monstres. Chacun a ses raisons. Comprendre sans absoudre. Le joueur peut être en désaccord total avec quelqu'un et quand même le comprendre — et choisir de le protéger ou de l'exposer en connaissance de cause.

**Être regardée en retour.**
Margot n'est pas le seul sujet observant. Chaque résident a sa propre lecture d'elle, ses propres intentions envers elle. Elle est aussi l'objet de leurs stratégies. Certains veulent l'amadouer, d'autres la neutraliser, d'autres encore la tester. La pression est dans les deux sens.

**Construire par fragments.**
Ni le monde ni les personnages ne se livrent d'un coup. Le joueur assemble une compréhension progressive — et peut se tromper, réviser, être surpris. L'information incomplète est l'état normal du jeu.

**Choisir sans filet.**
Pas de bonne réponse évidente. Les conséquences arrivent tard, parfois là où on ne les attendait pas. Le jeu ne juge pas — il applique une logique cohérente.

---

### Thématiques narratives

Ce que Margot vit. Ce que le joueur ressent à travers elle.

#### La surveillance comme transformation

Être observé en permanence ne laisse pas indemne. Les résidents ont intégré les caméras au point de performer leur propre vie. Margot arrive avec ses propres outils de surveillance — et risque de faire la même chose. La question n'est pas *qui regarde* mais *ce que regarder fait à celui qui regarde*.

#### L'exécutant et le système

Les corporations ont des projets dégueulasses. Ceux qui les exécutent ne sont pas tous mauvais — ils ont des dettes, des familles, des peurs. Le jeu refuse le manichéisme : comprendre les raisons d'un personnage n'est pas l'excuser, et l'exposer n'est pas forcément le condamner.

#### Les secrets en couches

Chaque personnage porte plusieurs niveaux de secret simultanément. Ce que l'immeuble ne sait pas. Ce que sa corporation ignore. Ce que son partenaire cache. Ce qu'il se cache à lui-même. Démêler l'un peut en révéler un autre involontairement.

#### Les bons mots comme outil

Une journaliste sait que la formulation change tout. Le jeu doit faire ressentir ce pouvoir — et ses limites, quand les gens en face sont aussi rodés à manier le langage.

#### Le documentaire comme miroir

Décrire le comportement des autres oblige Margot à décrire le sien. Chaque note dans son carnet est aussi une auto-analyse. Le documentaire qu'elle construit parle d'elle autant que de l'immeuble.

#### Guérir dans un système pathologique

Peut-on se reconstruire dans un environnement conçu pour surveiller, contrôler, fracturer ? Margot essaie de guérir de Julien/Julie tout en utilisant les mêmes outils que lui/elle.

---

### Thématiques de monde

Ce que le jeu dit du monde — pas nommé, pas expliqué. Visible dans l'architecture, les silences, ce que les personnages taisent autant que ce qu'ils disent. Le joueur les ressent sans qu'on les lui annonce.

**Femmes et pouvoir** — dans un monde corporatiste, le pouvoir a des visages genrés. La rhétorique d'égalité est parfaitement huilée. Les structures de domination sont intactes.

**La place du genre dans le futur** — 2084 n'a pas résolu les inégalités, il les a reconfigurées. Plus de fluidité dans les représentations, autant de rigidité dans les rapports de force réels.

**L'impact de la tech et de l'IA** — les augmentations appartiennent à ceux qui les ont conçues. La technologie transforme les relations humaines — à qui profite cette transformation ?

**La séduction du futur** — l'immeuble est beau, l'air est pur, les surfaces réfléchissent une lumière parfaite. Les corporations ont rendu l'oppression désirable. C'est leur génie. Margot elle-même n'est pas immunisée.

**Sociologie d'un Paris cyberpunk** — ce n'est pas une ville futuriste générique, c'est Paris. L'architecture haussmannienne sous le verre intelligent, les classes sociales recomposées, la langue française infiltrée de terminologie corpo. Le lieu doit se sentir.

---

## 3. Univers — Néo-Paris 2084

### La ville stratifiée

Néo-Paris est organisée en couches. En bas, les **canaux de Deep-Paris** charrient leurs eaux sombres — les exclus, les endettés, les sans-implants. Au niveau intermédiaire, les **districts commerciaux** : forêt d'enseignes holographiques, marchés gris, Ghost Markets. En haut, les **tours corporatistes** percent la couche de pollution, réservées aux employés valides.

La mobilité sociale n'existe plus. Ce qui existe, c'est le **crédit solidaire** — un système d'endettement collectif qui lie les individus à leurs corporations et entre eux, rendant toute rébellion individuellement impossible.

### L'Immeuble Saint-Michel — Le lieu de jeu

> Tour de 20 étages, verre intelligent, alliages composites. Au sommet : quatre logos holographiques géants. MEMORIZE en bleu `#4a90d9`. KAIZEN en orange `#d9a44a`. NEXUS en vert `#4ad97a`. STRATOM en rouge `#d94a4a`. Le hall : atrium 15 mètres de haut, sol marbre synthétique, cascades d'eau recyclée. Propre. Froid. Aseptisé.

L'immeuble est officiellement une expérience de coliving corporatiste nouvelle génération. Réalité : c'est un **laboratoire**. Les 8 résidents sont des sujets. Leurs comportements, conflits, solidarités — tout est mesuré.

### Cartographie du Niveau 8 (zone principale)

| Zone | Description | Surveillance |
|---|---|---|
| Zone Commune | Cuisine, table ronde, canapés, écran collectif. Cœur social. | `●●●○○` Surveilled-3 |
| Couloirs | Passages entre cellules. Conversations risquées. | `●●○○○` Surveilled-2 |
| Cellule Margot | 25 m², 1 caméra, fenêtre sur puits de lumière. | `●○○○○` Surveilled-1 |
| Salle de bain / Douche | L'eau couvre la voix. Seul refuge audio. | `○○○○○` Surveilled-0 |
| Terrasse Ouest | Angle mort caméras (mais pas micros). Vue sur la ville. | `●○○○○` Surveilled-1 |
| Locaux Techniques | Accès restreint. Serveurs de flux vidéo. | `●●●●○` Surveilled-4 |

> **⚠ Règle de survie #1** — Ne JAMAIS chuchoter (active automatiquement les alertes). Parler normalement (80% ignoré). La douche est le seul refuge audio. L'angle mort de la terrasse ouest n'est pas sonore.

### Infrastructure de surveillance

- **17 caméras** en Zone Commune — **3** dans les couloirs — **1** dans la cellule de Margot — **0** en salle de bain
- Les 4 corporations ont **accès croisé** aux flux
- **Alex Norvège** scanne biométriquement via implants neuronaux (passif, permanent)
- Chaque conversation est analysée, chaque relation mesurée

### Le Programme Nexus Social

Prototype de contrôle urbain que les 4 corporations veulent déployer dans **tout Néo-Paris d'ici 2090**. L'immeuble Saint-Michel est le test de résistance face à un perturbateur (Margot).

- **Si l'expérience aboutit sans exposition** → Néo-Paris entier sous contrôle corporatiste intégral
- **Si Margot accumule 6 preuves et les publie** → scandale ingérable, enquête médiatique, possible arrêt du programme

---

## 4. Les 4 Corporations

> La Synergie Quadri-Corp n'est pas un bloc monolithique. C'est une coalition fragile de quatre entités aux intérêts contradictoires, unies par l'appât d'un déploiement urbain massif.

> **Note de design** — Les corporations ne sont jamais des adversaires directs dans le gameplay. Elles passent toutes par leurs agents humains. Margot interagit avec des *personnes*, pas des structures abstraites. Les frictions inter-corpos sont du carburant narratif.

### MEMORIZE *(Bleu `#4a90d9`)*

**Domaine** : Data · Mémoire numérique · IA prédictive

**Coordinateur officiel** du consortium. Analyse comportementale, prédictions, vente de modèles aux autres corpos. Contrôle le contrat de Margot (clause 12.1 : accès à ses rushes). Peut valider ou censurer son documentaire.

**Agents internes** : Emma (loyale coupable) · Léo (saboteur discret)

**Frictions** : tensions avec Stratom (contrôle prédictif vs coercitif), méfiance de Nexus (surveille l'éthique des prédictions)

### KAIZEN *(Orange `#d9a44a`)*

**Domaine** : Manufacturing · Performance · Optimisation comportementale

**Fournit le modèle d'optimisation**. Veut prouver que le contrôle social augmente la productivité. Audite les sous-performants. Marine (audit en cours, 45k€ de dette) est leur plus gros risque d'effondrement.

**Agents internes** : Marine (performeuse désespérée) · Thomas (résigné)

**Frictions** : voit Memorize comme bavard et inefficace, méprise la philosophie éthique de Nexus

### NEXUS *(Vert `#4ad97a`)*

**Domaine** : Biotech · Augmentations · Éthique corporatiste de façade

**La caution éthique du projet**. Collecte données biométriques via implants. Justifie la surveillance comme « protection ». Paradoxe : leur département éthique participe à l'expérience qu'il devrait dénoncer.

**Agents internes** : Sofia (sincère mais structurellement complice) · Alex (double agent Stratom)

### STRATOM *(Rouge `#d94a4a`)*

**Domaine** : Sécurité · Opérationnel · Exécution coercitive

**Le bras armé**. Contrôle de l'Équipe Nettoyage, opérations terrain. Si Margot devient trop menaçante, Stratom agit. Handler de Frank.

**Agents internes** : Camille (profileuse psychologique) · Frank (ex-opératif, verdict en cours)

---

## 5. Personnage Joueur — Margot Sinclair

### Identité

- **Nom complet** : Margot Vanderberghe (nom de plume : **Sinclair**)
- **Âge** : 26 ans
- **Profession** : Journaliste culture/société freelance, documentariste
- **Lien** : Cousine éloignée d'Emma Castellane
- **Situation** : Célibataire (rupture Julien, 3 mois)

### Apparence

1m68, silhouette élancée. Cheveux brun chocolat mi-longs, coupe carré flou déstructuré. Yeux noisette perçants. Cicatrice sourcil gauche (accident vélo). Style : blazers unstructurés, chemises oversize, tons neutres (beige, camel, kaki). **Signature** : foulard en soie hérité de sa grand-mère.

### Façade vs réalité

| | Détail |
|---|---|
| **Prétexte officiel** | Documentaire sur le coliving parisien : *« Comment les couples modernes négocient espace et intimité »*. Financement : bourse CNC + avance éditeur. Durée : 3 mois. |
| **Vraie raison** | Besoin de refuge post-rupture. Fascination morbide pour les couples qui « réussissent ». Voyeurisme intellectualisé comme mécanisme de défense. |

### Les 4 Thèmes — Compétences & Vulnérabilités

#### Theme 1 — Investigative Journalist *(SELF / Expertise)*

> *« The truth must be documented, no matter the cost. »*

Depuis Julien, l'objectivité est devenue une armure qui la coupe des autres.

- **Power Tags** : `Eye for inconsistencies` · `Sharp questions`
- **Weakness Tag** : `Crosses ethical lines`

#### Theme 2 — Toxic Relationship Survivor *(SELF / Troubled Past)*

> *« I will never be controlled again. »*

Trauma de Julien : manipulation, gaslighting, contrôle financier, infidélité. Terrifiée de reproduire ses patterns.

- **Power Tags** : `Detects manipulation instantly` · `Fiercely independent`
- **Weakness Tag** : `Paranoid about intimacy`

#### Theme 3 — Compulsive Observer *(SELF / Personality)*

> *« I must understand how people truly connect. »*

Fascination malsaine pour l'intimité des autres. Intellectualisée en « recherche anthropologique » mais c'est une addiction.

- **Power Tags** : `Reads microexpressions` · `Invisible when watching`
- **Weakness Tag** : `Can't stop snooping`

#### Theme 4 — Professional Equipment *(SELF / Assets)*

> *« My tools are for journalism, not surveillance. »* *(frontière floue…)*

Arsenal journalistique professionnel + dispositifs clandestins Ghost Market. La frontière entre documentation légitime et violation devient floue.

- **Power Tags** : `HD camera with night vision` · `Directional microphones`
- **Weakness Tag** : `Conspicuous gear`

### Le fil rouge de Margot

**Question centrale** : *Margot reproduit-elle Julien ?*

Chaque fois qu'elle installe un dispositif clandestin, manipule une information, utilise la confiance d'Emma contre elle, ou justifie une transgression par « la vérité » — elle avance vers ce qu'elle déteste. **Emma** (qui a connu Julien) est la seule à pouvoir nommer le pattern à temps.

**Triggers qui font perdre 1 Mental-Stability** :
- Installer un dispositif de surveillance non consenti
- Manipuler une information pour pousser quelqu'un à une décision
- Utiliser la confiance d'Emma contre elle
- Justifier une transgression par « la vérité »
- Documenter sans consentement explicite

**Menace finale (Mental-Stability à 0)** : Margot *est* Julien. Rupture identitaire. Game over thématique.

### Statuses de progression (début de jeu)

| Status | Valeur initiale | Effet |
|---|---|---|
| **Evidence-Collected** | 0 / 6 | Lié au Programme Nexus Social. À 6 → exposé possible. |
| **Personal-Danger** | 0 / 6 | Lié au countdown Équipe Nettoyage. À 6 → intervention armée. |
| **Mental-Stability** | 3 / 6 | À 0 → game over thématique. À 6 → lucidité maximale. |

### Création de personnage

Au lancement, une question détermine l'arc thématique :

| Choix | Motivation | Tag gagné |
|---|---|---|
| **A** | Reconstruire ta carrière après Julien | `carrière-avant-tout` |
| **B** | Comprendre comment fonctionnent les vraies relations | `quête-de-vérité-relationnelle` |
| **C** | Exposer les abus corporatistes | `idéaliste-militante` |
| **D** | Par nécessité financière pure | `pragmatique-financière` |

---

## 6. Cast — Les 8 Résidents

> Huit employés corporatistes liés par un crédit solidaire de 25 ans. Si l'un tombe, tous tombent. Cette interdépendance est à la fois leur prison et leur dynamique relationnelle centrale.

---

### Emma Castellane — *La cousine tiraillée* · MEMORIZE

**Tier 2 · Ally/Betrayer · 28 ans · Data Analyst**

Cousine éloignée de Margot. Elle a placé Margot dans l'expérience — et s'en repent immédiatement. Tiraillée entre loyauté familiale et survie corporatiste.

**Power Tags** : `Accès flux Memorize` · `Connaissance du système interne` · `Liens familiaux activables`

**Weakness Tags** : `Culpabilité visible` · `Crédit solidaire = chantage permanent` · `Carrière vs famille`

**Spectre** : Alliée précieuse (canal d'info privilégié) ↔ Trahison forcée (rapport accablant remis à Memorize)

**Lien mécanique** : Emma a connu Julien. Elle est la SEULE qui peut nommer le pattern à Margot avant qu'il soit trop tard. La rendre muette = Margot perd sa boussole morale.

> *« Tu es une variable de stress contrôlée. »* / *« Je ne sais plus si j'ai bien fait. »*

---

### Camille Armand — *La profileuse* · STRATOM

**Tier 3 · Attacker psychologique · 32 ans · Psychologue opérationnelle**

Chaleureuse en surface, redoutable en dessous. Profile Margot depuis leur première rencontre. Cliffhanger actif depuis Session 01.

**Power Tags** : `Profilage psychologique` · `Fausse intimité chaleureuse` · `Contrôle de la pièce par la voix` · `Réseau Stratom`

**Weakness Tags** : `Fascination pour Margot peut devenir obsession` · `Margot reconnaît ses techniques (trauma Julien)` · `Si démasquée, perd toute autorité morale`

**Spectre** : Neutre (observe, collecte) ↔ Hostile (utilise le profil contre Margot, alimente countdown Équipe Nettoyage)

> *« Oh ! On a de la visite ! »* / *« Parle-nous un peu de toi. Tu viens d'où ? »*

---

### Frank Dosière — *Le test* · STRATOM

**Tier 3 · Threat/Protector (spectre fluide) · 42 ans · Ex-opératif**

Homme de peu de mots. Positionnement tactique permanent. Il teste Margot pour décider si elle mérite protection ou élimination. Cherche la rédemption.

**Power Tags** : `Fluidité militaire` · `Position tactique permanente` · `Handler de l'Équipe Nettoyage`

**Weakness Tags** : `Cherche la rédemption` · `Fatigué du système qu'il sert` · `Le test = Margot peut le réussir ou l'échouer`

**Countdown attaché** : Équipe Nettoyage Stratom (14 ticks). Avance via Personal-Danger ↑ ou alertes sécurité. Recule via tests d'intégrité réussis.

**Spectre** : Allié protecteur ↔ Hostile (déclenche le countdown)

> *« Filme tout. Pas juste ce qui arrange ton narratif. »* / *« On verra. »*

---

### Sofia Kessler — *La vigilante éthique* · NEXUS

**Tier 2 · Watcher éthique · 28 ans · Département éthique Nexus · femme trans**

Sincère dans ses convictions, mais structurellement complice du système qu'elle prétend surveiller. Paradoxe incarné.

**Power Tags** : `Autorité éthique reconnue` · `Lecture rapide des contrats` · `Alliance tacite avec Frank`

**Weakness Tags** : `Travaille pour ceux qui violent l'éthique` · `Mission "éthique" est elle-même corporatiste`

**Spectre** : Alliée (expose les abus avec Margot) ↔ Hostile (dénonce Margot à Nexus pour violation éthique)

> *« J'aimerais voir le contrat. »* / *« Je vais probablement voir tes rushes. Pas pour censurer. »*

---

### Marine Dubois — *La performeuse au bord du gouffre* · KAIZEN

**Tier 2 · Countdown (Audit) · 26 ans · Marketing digital**

75k abonnés. Enthousiasme contagieux, sourire crispé. Cache 45k€ de dette. Audit Kaizen imminent. Si elle tombe, tout l'immeuble s'effondre via cascade crédit solidaire.

**Power Tags** : `Réseau influenceuse 75k` · `Enthousiasme contagieux performé` · `Acceptée par tous`

**Weakness Tags** : `45k€ de dette cachée` · `Sourire crispé sous pression` · `Audit Kaizen (15 ticks)`

**Countdown attaché** : Audit Marine (15 ticks). Avance via échec social, critique publique. À 0 : licenciement → cascade crédit solidaire → tout l'immeuble s'effondre.

**Piège Margot** : si Margot *expose* Marine pour gagner Evidence-Collected, elle déclenche la cascade entière.

> *« Oh ! La journaliste ! Bienvenue, bienvenue ! »* / *« C'est super excitant ! »*

---

### Alex Norvège — *Le double agent* · NEXUS → STRATOM

**Tier 2 · Watcher/Double Agent · 29 ans · Technicien cybernétique**

Implants neuronaux. Scan biométrique passif permanent. Officiellement Nexus. Réellement : taupe Stratom. Sofia est sa faille émotionnelle.

**Power Tags** : `Scan biométrique passif via implants` · `Flux d'info Nexus + Stratom` · `Peut altérer les enregistrements biométriques`

**Weakness Tags** : `Triple loyauté impossible` · `Si démasqué, perd les trois soutiens` · `Sofia est sa faille émotionnelle`

**Spectre** : Allié improbable (retournement contre Stratom) ↔ Hostile (alimente countdown Équipe Nettoyage avec ses scans)

---

### Léo Mars — *Le saboteur silencieux* · MEMORIZE

**Tier 1 · Neutral/Saboteur · 30 ans · Designer interfaces — Cible d'alliance prioritaire**

Sabote les systèmes Memorize par lassitude esthétique, pas par idéologie. Détaché, donc imprévisible. Clé pour l'accès aux flux vidéo existants.

**Power Tags** : `Accès design des systèmes de surveillance` · `Peut créer des angles morts` · `Autorité technique reconnue`

**Weakness Tags** : `Aucune cause militante (sabote par lassitude)` · `Emma le surveille`

**Spectre** : Neutre (observe sans agir) ↔ Allié technique (partage l'accès aux flux vidéo si Margot propose un sabotage stylé)

> *« Accord de transparence inter-corporatiste. »* / *« Du moment que tu floutes mon écran. »*

---

### Thomas Renard — *Le résigné* · KAIZEN

**Tier 1 · Neutral/Resigned · 29 ans · Ingénieur systèmes**

Épuisé chronique. Cynisme absolu. Aucun investissement émotionnel. Peut révéler par pure fatigue ce qu'il devrait taire.

**Power Tags** : `Connaissance des systèmes Kaizen` · `Invisibilité par épuisement` · `Cynisme désarmant`

**Weakness Tags** : `Épuisé` · `Peut révéler par fatigue ce qu'il devrait taire`

**Spectre** : Allié passif (témoignage involontaire) ↔ Neutre (par défaut)

> *« On est déjà filmés 24/7. »* / *« Fais ce que tu veux. »*

---

### Registres de tension par PNJ

| PNJ | Calme | Tension | Crise |
|---|---|---|---|
| Emma | Corporatiste | Humaine | Panique |
| Camille | Chaleureuse | Profilage | Manipulation |
| Frank | Silencieux | Test | Verdict |
| Sofia | Analytique | Accusatrice | Protectrice |
| Marine | Enthousiaste | Forcée | Effondrée |
| Alex | Absent | Alerte | Menaçant |
| Léo | Détaché | Sarcastique | Impliqué |
| Thomas | Marmonne | Cynique | Révélation |

---

## 7. Mécaniques de Jeu

### La Mécanique Centrale — Le Double Regard

Deux flux coexistent en permanence dans l'interface. Margot observe l'immeuble. L'immeuble observe Margot.

```
[👁 MARGOT]  ●●●○○○  flux actifs (3/6 caméras accessibles)
[👁 NEXUS ]  ●●●●○○  niveau d'alerte corporatiste

Plus Margot accède à des flux → Plus elle est visible → Plus l'alerte monte
Plus l'alerte monte → Plus l'Équipe Nettoyage avance sur son countdown
```

### Dialogues — Roue d'intention

Les choix de dialogue ne présentent pas le texte exact que Margot va dire — ils présentent une **intention**. Le joueur choisit une posture, pas une réplique.

```
        [ Empathique ]
             ↑
[ Directe ] ← → [ Manipulatrice ]
             ↓
        [ Distante ]
```

Chaque intention a un coût et un effet différent selon le personnage en face et l'état de la relation. Une approche empathique avec Frank peut être lue comme de la faiblesse. Une approche directe avec Camille l'alerte. Rien n'est universellement "bon".

### Réputation par personnage

Chaque résident a un score de relation indépendant (`RelationManager`, −100 à +100) qui évolue à chaque interaction. Ce score détermine :

- les **options de dialogue disponibles** (certaines répliques sont verrouillées si la relation est trop basse ou trop haute)
- le **comportement du PNJ** dans les scènes où Margot n'est pas présente (flags narratifs)
- les **fins accessibles** — certaines fins nécessitent un niveau minimal avec Emma, Frank, ou Léo

Les seuils ne sont jamais affichés explicitement. Le joueur lit les signaux dans les dialogues et les expressions — exactement comme dans une vraie relation.

| Niveau | Seuil | Effet visible |
|---|---|---|
| Méfiance | < −25 | Options fermées, PNJ se protège, informations retenues |
| Neutre | −25 à +25 | Interactions de surface, politesse corporatiste |
| Sympathie | +25 à +50 | Confidence possible, info partagée si enjeu faible |
| Confiance | +50 à +75 | Alliances activables, secrets révélés |
| Intime | > +75 | Accès aux motivations profondes — et aux trahisons les plus douloureuses |

Les conséquences d'un choix peuvent ne se manifester qu'un ou deux actes plus tard — le joueur ne sait pas toujours ce qu'il vient de déclencher.

### Mode Montage — Outil d'enquête

Accessible depuis la cellule de Margot dès qu'elle a au moins un rush dans son inventaire. Ce n'est pas une mécanique récurrente de fabrication — c'est un **outil d'analyse** avec un moment de choix narratif à la fin.

**Trois usages distincts :**

**1. Chercher des indices** *(le plus fréquent)*
Relire une séquence, zoomer, ralentir, isoler l'audio. Trouver le détail manqué sur le moment : Camille qui consulte sa tablette une seconde de trop, Alex qui scanne discrètement, le reflet de Frank dans une vitre. Débloque des flags narratifs et des options de dialogue.

**2. Recouper deux sources**
Synchroniser deux flux (camera de Margot + flux corporatiste intercepté) pour révéler une incohérence — quelqu'un dit être ailleurs, le footage prouve le contraire. Devient une preuve utilisable en confrontation directe.

**3. Choisir la version à publier** *(moment narratif unique, Acte IV)*
Version brute, version sélective, ou version arrangée. Chaque choix a des conséquences sur les fins possibles et sur le status MIROIR de Margot.

**UI minimale :**

```
┌─ MODE MONTAGE ──────────────────────┐
│  [Rush_Zone_Commune_J1_2147.mp4]    │
│  ▶ ━━━●━━━━━━━━━━━━ 02:14 / 04:30   │
│  [◀◀] [▶/❚❚] [▶▶]  Vitesse: 0.5x    │
│                                      │
│  Pistes :  📹 Vidéo                  │
│            🔊 Audio                  │
│            👁 Visages détectés       │
│                                      │
│  [🔍 Zoom]  [✂ Découper]  [📌 Note]  │
└──────────────────────────────────────┘
```

**Règle de surveillance** : utiliser le mode Montage sur ses propres rushes n'augmente pas l'alerte. En revanche, analyser un **flux corporatiste intercepté** (`tainted_source = true` dans `RushData`) peut faire monter le status MIROIR — Margot utilise les outils du système pour ses propres fins.

> **Tension centrale** : arranger une vidéo pour "protéger" quelqu'un, c'est manipuler l'information — exactement ce que faisait Julien. Diffuser brut, c'est potentiellement détruire des vies au nom de la vérité. Il n'y a pas de bonne réponse — seulement des conséquences à assumer.

### Countdowns actifs

| Countdown | Ticks initiaux | Avance si... | Recule si... | Conséquence à 0 |
|---|---|---|---|---|
| **Équipe Nettoyage Stratom** | 14 | Personal-Danger ↑ ou alertes sécurité | Tests d'intégrité réussis auprès de Frank | Intervention armée |
| **Audit Marine — Kaizen** | 15 | Échec social, critique publique, perte followers | — | Cascade crédit solidaire → tout l'immeuble s'effondre |

### Challenge — *Margot devient Julien*

Le challenge interne le plus important. Chaque transgression fait perdre 1 Mental-Stability. À 0 : rupture identitaire, game over thématique.

**Allié si** Margot reconnaît le pattern et choisit explicitement de le briser (chaque résolution restaure 1 Mental-Stability).

---

## 8. Structure Narrative

### Vue d'ensemble

4 actes · 32 chapitres · Multiples fins · Conséquences différées

### Acte I — L'Observatrice *(Ch. 1-8)*

Margot arrive. Emma révèle la vérité. Décision : rester malgré le danger. Présentation aux résidents, premier dîner, cliffhanger Camille. Établissement des alliances potentielles, lecture de l'espace, plan stratégique (accès aux flux vidéo).

- ✅ Ch. 1 — Arrivée, révélation Emma, premier dîner *(Session 01 jouée)*
- ⟳ Ch. 2 — Réponse à Camille *(cliffhanger actif)*
- Ch. 3 — Première nuit (bruits à travers les murs)
- Ch. 4-5 — Approcher Léo pour l'accès aux flux vidéo
- Ch. 6-8 — Lecture du terrain, premières alliances

### Acte II — Surveillance *(Ch. 9-16)*

Alliance avec Léo pour les flux vidéo. Premier contact décisif. Découverte d'une preuve substantielle du Programme Nexus Social. Pression de Witness Networks pour du sensationnel. Alex commence à se révéler.

- Ch. 9-10 — Alliance Léo, accès aux flux
- Ch. 11-12 — Premier allié solide
- Ch. 13-14 — Preuve #1 (Evidence-Collected ↑)
- Ch. 15-16 — Pression Witness Networks

### Acte III — Confrontation *(Ch. 17-24)*

Confrontation avec Camille (retourner le profilage ?). Verdict de Frank. Tentative d'exposition partielle. Stratom réagit. Emma craque sous pression. Le crédit solidaire menace. Margot atteint son point de bascule moral.

- Ch. 17-18 — Confrontation Camille
- Ch. 19-20 — Verdict Frank (allié ou cible ?)
- Ch. 21-22 — Exposition partielle, Witness Networks ou tiers ?
- Ch. 23-24 — Stratom déploie, Emma craque

### Acte IV — Dénouement *(Ch. 25-32)*

La grande révélation publique (ou pas). Choix éthique final : sacrifier Emma pour la vérité, ou la protéger au prix du documentaire ? Survivre à la rétorsion corporatiste.

- Ch. 25-26 — Grande révélation (ou silence)
- Ch. 27-28 — **Choix final** : Emma vs vérité
- Ch. 29-30 — Rétorsion corporatiste
- Ch. 31-32 — Départ — qui est Margot maintenant ?

### Fins possibles

Les fins se distribuent selon deux axes : *a-t-elle exposé le Programme ?* et *a-t-elle évité de devenir Julien ?*

| Fin | Condition | Résumé |
|---|---|---|
| **L'Exposé** | Evidence 6/6 + Stability > 0 | Programme stoppé. Emma sacrifiée ou protégée. Margot survit. |
| **Le Silence** | Witness Networks lâche | Le Programme se déploie. Margot part indemne mais complice. |
| **Julien** | Mental-Stability à 0 | Margot est devenue ce qu'elle détestait. Game over thématique. |
| **La Reconstruction** | Expose + préserve Emma + reste elle-même | La fin la plus difficile à atteindre. |

---

## 9. Direction Artistique

### Identité visuelle

**Noir cyberpunk** — semi-réaliste illustré, concept art propre. Oppression visuelle de la surveillance omniprésente, contrebalancée par la chaleur fragile des espaces privés.

### Palette chromatique

| Rôle | Code | Usage |
|---|---|---|
| Noir base | `#0a0a0f` | Fond principal |
| Memorize | `#4a90d9` | UI Memorize, Emma, Léo |
| Kaizen | `#d9a44a` | UI Kaizen, Marine, Thomas |
| Nexus | `#4ad97a` | UI Nexus, Sofia, Alex |
| Stratom | `#d94a4a` | UI Stratom, Camille, Frank, danger |
| Accent | `#e0c97a` | Margot, éléments critiques |

### Convention de nommage des assets

```
# Backgrounds
bg_[lieu]_[moment]_[variante].png
bg_zone_commune_soir_normal.png
bg_cellule_margot_nuit_pluie.png

# Personnages
char_[perso]_[expression]_[tenue].png
char_camille_chaleureuse_tailleur.png
char_frank_neutre_civil.png

# UI
ui_[composant]_[état].png
ui_double_regard_mem_active.png
```

### Expressions requises par PNJ principal

Chaque PNJ principal nécessite 5 expressions minimum : **neutre · légère tension · tension · sourire · crise**

Ces expressions correspondent aux registres de tension définis dans l'état de jeu.

---

## 10. Inspirations

Ces œuvres ont nourri la réflexion sur le projet — en termes de *ton*, d'*ambiance* et de *questions posées*, pas de mécaniques à reproduire.

**Sliver** (film, 1993) — un immeuble comme espace de désir et de contrôle mutuel. La question de qui regarde qui, et ce que ça dit de celui qui observe.

**Deus Ex : Human Revolution** (jeu, 2011) et **Deus Ex : Mankind Divided** (jeu, 2016) — l'ambiance d'un monde où la frontière entre humain et corporatiste s'est brouillée. Des villes stratifiées, une paranoïa ordinaire, des personnages coincés entre survie et idéaux. Le sentiment que le système est trop grand pour être renversé — mais qu'on essaie quand même.

**Life is Strange** (jeu, 2015) — des personnages ordinaires dans une situation extraordinaire. Des choix sans bonne réponse évidente, dont les conséquences émotionnelles arrivent tard et fort. La tension entre vouloir sauver tout le monde et devoir choisir.

**Star Wars : The Old Republic** (jeu, 2011) — la roue de dialogue comme outil narratif : on choisit une intention, pas un texte. Et les relations avec les personnages secondaires s'accumulent sur la durée, ouvrent ou ferment des arcs entiers.

**Remember Me** (jeu, 2013) — l'esthétique de Néo-Paris : haussmannien recouvert de verre intelligent, de néons corpo et de pluie permanente. Le quotidien ordinaire des gens dans un monde qui a basculé.

**Disco Elysium** (jeu, 2019) — une intériorité fragmentée comme moteur narratif. Les contradictions d'un personnage qui se débat avec lui-même autant qu'avec le monde.

**Papers, Please** (jeu, 2013) — la complicité ordinaire avec un système injuste. Le coût moral de chaque décision banale, accumulé sur la durée.

---

## 11. Stack Technique

### Outils

| Couche | Outil | Rôle |
|---|---|---|
| Moteur | **Godot 4 .NET** | Runtime, export desktop/mobile |
| Dialogue | **Dialogic 2** | Dialogues branchés, portraits, backgrounds |
| Fondation | **Maaack's Game Template** | Menus, save system, options |
| Images | **Flux.1 Dev + ComfyUI** | Backgrounds et portraits générés en local (RTX 2080 Super) |
| Cohérence perso | **LoRA par personnage** | Même visage dans toutes les expressions |
| Code | **Claude Code** | Génération GDScript, scènes, intégration |
| Dialogue écrit | **Claude** | Fichiers `.dtl`, arcs narratifs, voix PNJ |

### Systèmes core GDScript (autoloads)

| Script | Responsabilité |
|---|---|
| `RelationManager.gd` | Relations −100 à +100 par PNJ · niveaux (neutre/sympathie/confiance/amitié/intime) · signal `relation_changed` |
| `GameStateManager.gd` | Flags narratifs + état global · historique des décisions · intégration variables Dialogic |
| `SaveManager.gd` | 3 slots JSON · relations + flags + lieu + chapitre |
| `CountdownManager.gd` | Équipe Nettoyage (14 ticks) · Audit Marine (15 ticks) · Mental-Stability (progress) |

### Workflow de production par scène

```
Fiche de scène (game design)
    ↓
Génération assets Flux.1 Dev via script Python batch
    ↓
Écriture dialogue .dtl (Claude)
    ↓
Création scène Godot .tscn (Claude Code)
    ↓
Intégration et validation (script d'intégrité)
    ↓
Commit
```

---

*Document interne — Version 1.0 — Mai 2026*
*8-MINE Game Bible · Néo-Paris 2084 · Huit résidents. Une journaliste. Un immeuble-laboratoire.