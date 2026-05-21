<!-- v3 (upgrade 2026-05-21 · suggestions #1-#26 appliquées) -->
# 8-MINE — Overview projet

> Synthèse macroscopique. Source de vérité pour `arc-spec`.
> Construite par `brainstorm` (session 2026-05-21) à partir de `bible-jeu.md`, `history.md`, `internal/architecture.md`, `internal/variables-register.md`, `session-exemple-01.md`.
> Ne pas écrire d'arc complet ici — les arcs vivent dans `memory/external/arcs/`.

---

<!-- #1 + #8 : en-tête, TOC, quick start -->
## Pour démarrer

**Audience** : auteur·rice d'arc, reviewer canon, narrative designer entrant·e.
**Ordre de lecture conseillé** : *Pitch* → *Glossaire* → *Cast principal* → *Jauges et stakes* → *Arborescence des arcs* → *Notes auteur*. Tout le reste sert de référence ponctuelle.
**Convention canon** : la sous-section *Notes auteur · Décisions canon* est prescriptive (à respecter). Le reste est descriptif (à connaître).

### Table des matières
1. [Pitch](#pitch)
2. [Glossaire](#glossaire)
3. [Cast principal](#cast-principal)
4. [Jauges et stakes joueur](#jauges-et-stakes-joueur)
5. [Arborescence des arcs](#arborescence-des-arcs)
6. [Fins canoniques A-I](#fins-canoniques-a-i)
7. [Topologie corporatiste](#topologie-corporatiste)
8. [Notes auteur](#notes-auteur)
9. [Conventions de production](#conventions-de-production)
10. [Liens canon](#liens-canon)
11. [Archive — threads tranchés](#archive--threads-tranchés-2026-05-21)

---

## Pitch

**8-MINE** est un jeu narratif cyberpunk sociologique. Margot Sinclair, journaliste documentariste post-rupture, s'installe trois mois dans un coliving expérimental de Néo-Paris (immeuble Saint-Michel) sous prétexte de tourner un documentaire sur *« les couples modernes ».* La vraie raison : un cousin l'a contactée — l'immeuble est le laboratoire vivant du **Programme Nexus Social**, expérience secrète de contrôle prédictif menée conjointement par quatre corporations (MEMORIZE, KAIZEN, NEXUS, STRATOM). Les huit résidents sont des sujets, organisés en quatre binômes-couples corporatistes. Chaque couple a ses failles ; Margot, dont c'est le métier, va les découvrir une par une. À chaque faille découverte, un choix : *documentaire, journalisme, romance, levier, arme.* Le jeu mesure l'écart entre ce que Margot prétend faire et ce qu'elle fait vraiment.

---

<!-- #2 : glossaire des sigles -->
## Glossaire

<!-- #22 : tableau séparé en deux — jauges numériques d'un côté, lexique structurel de l'autre -->

**Jauges numériques** (plage chiffrée, ressource technique)

| Sigle | Sens | Plage | Autorité technique |
|---|---|---|---|
| **MS** | Mental Stability (santé narrative) | 0-6 | `GameStateManager.mental_stability` |
| **PD** | Personal Danger (pression physique) | 0-∞ | `GameStateManager.personal_danger` |
| **EV** | Evidence (preuves sur le Programme) | 0-6 | `GameStateManager.evidence_collected` |
| **Mirror** | Dette d'authenticité = instrumentalisation subie | 0-100 | `MirrorStatusManager` |
| **Surveillance** | Pression Stratom / caméras | 0-100 | `SurveillanceManager` |

**Lexique structurel** (concepts non chiffrés)

| Terme | Sens | Référence |
|---|---|---|
| **NODE** | Unité narrative atomique (1 scène ou 1 sous-arc) | `nodes/*.md` |
| **FIN-A à FIN-I** | 9 fins canoniques | `history.md` ch. 9 |
| **N1 / N2 / N3** | Strates de couverture du Programme (public · institutionnel · secret) | [Topologie corporatiste](#topologie-corporatiste) |
| **Tick** <!-- #18 --> | Unité de décompte des countdowns = 1 NODE narratif consommé (pas 1 jour in-game ; un même jour peut contenir plusieurs NODEs et donc plusieurs ticks) | `CountdownManager` |
| **Trigger** <!-- #26 --> | Événement marqueur qui se déclenche puis se grave (one-shot). Deux familles : *triggers externes* (Stratom déploie, Witness exige) comptés FIN-A ; *triggers internes* (5 marqueurs de bascule Margot vers Julien) comptés FIN-I | `GameStateManager.log_decisions` |
| **Pool romance** | Ensemble des 8 PNJ accessibles en relation affective ambiguë. *Distinct du pool FIN-E* : être au pool romance ≠ résoudre en FIN-E (cf. Emma : pool oui, FIN-E non) <!-- #17 --> | `A2-04` |

<!-- #3 : système Tier explicité -->
### Système Tier (poids narratif PNJ)

| Tier | Critère | Volume canon attendu |
|---|---|---|
| **Tier 1** | Pivot d'arc, présent dans plusieurs actes, fiche complète obligatoire | Emma, Thomas, Frank |
| **Tier 2** | Romance pool ou faille structurelle exploitable, fiche complète | Léo, Marine, Sofia, Alex, Camille |
| **Tier 3** | Cité, contextuel, non interactif | voir `pnjs-secondaires.md` |

---

## Cast principal

### Protagoniste — Margot Sinclair

**Journaliste documentariste · 32 ans · post-rupture · orientation inférée par défaut, jamais thématisée** <!-- #12 : âge tranché 32 (point), orientation explicitement non-thématisée -->

Couverture : documentaire CNC sur le coliving. Mission réelle : enquêter sur le Programme Nexus Social après alerte de sa cousine Emma. Outils : caméra légère, micros (option PRO-02), Witness Networks comme diffuseur sous contrat (pression sensationnaliste).

**Trois règles canon — appliquées partout, énoncées une seule fois ici** <!-- #4 : dédup des règles Margot répétées en 3 endroits -->:

1. *Margot = terrain neutre*. Sans choix joueur conscient, les PNJ agissent (profilage, scan, séduction, manipulation). Cf. `margot-terrain-neutre`.
2. *Registre sociologique sur compétences d'investigation*. Elle vient comprendre, pas révéler — mais ses outils rendent le glissement techniquement possible. Cf. `margot-documentariste-sincere`.
3. *Double instrumentalisation*. Les 4 corpos parient sur N2 ; Witness Networks espère secrètement un scoop. Margot est l'enjeu silencieux entre deux logiques.

### Les 8 résidents et leurs 4 couples

Les binômes corporatistes du Programme sont **aussi** des couples réels. Quatre dyades, quatre statuts intimes, quatre failles structurelles.

| Binôme corpo | Couple | Statut conjugal canon | Faille principale |
|---|---|---|---|
| MEMORIZE *(bleu `#4a90d9`)* | **Emma × Léo** | Couple intime acté, intimité audible | Léo cultive une surface esthétique ; agenda à 3 couches dont Emma ne sait rien |
| KAIZEN *(orange `#d9a44a`)* | **Marine × Thomas** | Couple en tension visible, dispute étouffée | Dette cachée 45 k€ de Marine + résignation de Thomas qui n'y croit plus |
| NEXUS *(vert `#4ad97a`)* | **Sofia × Alex** | Couple solide, démonstratif, transparent | Sofia (éthique) suspecte ce qu'Alex (taupe Stratom) cache — mais Alex ne ment pas à Sofia |
| STRATOM *(rouge `#d94a4a`)* | **Camille × Frank** | Couple réel mais glacial — profileuse + ex-opératif se lisent en permanence | Aucun amour partagé, intimité étouffée |

<!-- #13 : usage couleurs corpo documenté -->
> **Usage des codes couleur corpo** : balisage UI (HUD réputation), bannières de NODE dans Dialogic (header de scène), tags de spec dans les arc-spec markdown. Pas de couleur dans les dialogues eux-mêmes.

**Conséquence** : 6 résidents sur 8 sont engagés intra-coliving. Toute romance Margot × PNJ_marié est une intrusion conjugale assumée, qui **doit** se lire en double-jeu (chaque PNJ a une raison propre de sortir de son couple via Margot — ce n'est jamais une intrusion unilatérale). *Exception canon* : Sofia/Alex est un couple si solide que `A2-romance-alex` est conçu en **romance refusée** (D), sauf branche trahison opt-in explicite.

<!-- #7 : matrice asymétrie d'info N3 -->
### Asymétrie d'information sur N3 (Programme secret)

Qui des 8 résidents sait que l'immeuble est le laboratoire du Programme Nexus Social ?

| Résident | Connaissance N3 | Source |
|---|---|---|
| Emma | **Sait** | Position interne Memorize, a alerté Margot |
| Léo | **Sait partiellement** | Sait que Memorize prépare *quelque chose* pour Emma, protège sans tout savoir |
| Marine | Évite activement | Le mot « Programme » la tétanise — elle change de pièce. Évitement compatible avec le soupçon de Thomas qu'elle refuse d'entendre <!-- #23 --> |
| Thomas | Soupçonne (« on est déjà filmés 24/7 ») | Lucidité résignée sans accès — n'insiste pas auprès de Marine par épuisement |
| Sofia | **Sait** | Département éthique Nexus, posture critique interne |
| Alex | **Sait** (acteur) | Taupe Stratom, altère les bio-flux |
| Camille | **Sait** (acteur) | Profileuse Stratom, exploite |
| Frank | **Sait** (exécutant) | Mission canon : évaluer Margot pour Stratom |

> *4 sachants pleins, 1 partiel (Léo), 1 soupçonneux (Thomas), 1 évitant (Marine), 0 ignorant total.* Toute scène doit respecter cette grille : un sachant ne peut être surpris par N3, Marine ne peut pas le décrire spontanément (elle change de sujet), Thomas peut formuler des intuitions vagues mais jamais nommer le Programme. <!-- #23 : matrice rectifiée -->

### Statut canon des 8 résidents — agents importants

Les 8 résidents sont des **agents importants avec responsabilités significatives** (Saint-Michel = immeuble prestigieux, zone stratégique négociée — pas de poste subalterne). Tension d'écriture : **fragilité visible quotidienne ≠ inexpérience** — chacun a un vrai pouvoir d'action en contexte pro.

*→ Détail canon : `bible-jeu.md § 6` (Note de design #4) · mémoire `corpos-job-ordinaire`*

### Fiches synthétiques par PNJ

#### Emma Castellane · MEMORIZE · 28 ans · femme · Tier 1
*La cousine tiraillée*. **Cousine germaine de Margot — éloignement vécu** : branches familiales coupées par brouille ancienne dans leur enfance, peu de souvenirs partagés robustes, reconnexion adulte tardive dont Julien (ex de Margot) fut le catalyseur. L'appel d'Emma à Saint-Michel = réparation de la brouille. Loyale au système qui l'emploie, coupable de ce qu'il fait. C'est elle qui a fait venir Margot — l'aide *« avant d'en avoir le courage de partir »*. **Power Tags** : accès flux Memorize, connaissance interne, liens familiaux activables. **Couple** : Emma × Léo (intime, acté).

#### Léo Mars · MEMORIZE · 30 ans · homme · Tier 2 <!-- #20 : âge tranché -->
*Le saboteur silencieux*. **Agenda à trois couches** : (a) **surface publique** = lassitude esthétique cultivée pour passer sous radar ; (b) **couche 1** = protection d'Emma à son insu (il a compris ce que Memorize prépare pour sa cousine et sabote pour la couvrir) ; (c) **couche 2** = il monte aussi un coup structuré sur les flux vidéo Memorize, qu'il *justifie* par la protection d'Emma mais qui le sert lui-même. Le couple Emma/Léo gagne ainsi une asymétrie canon : elle aime ; il aime + il protège + il opère. Couche révélée selon EV + relation Léo. **Couple** : Emma × Léo.

#### Marine Dubois · KAIZEN · 26 ans · femme · Tier 2
*La performeuse au bord du gouffre*. 75 k abonnés, sourire crispé, **45 k€ de dette cachée**. Audit Kaizen en cours (countdown 15 ticks). Si elle tombe, cascade crédit solidaire → tout l'immeuble s'effondre. **Piège Margot** : si Margot expose Marine pour gagner EV, elle déclenche elle-même la cascade. **Couple** : Marine × Thomas (tension).

#### Thomas Renard · KAIZEN · 29 ans · homme · Tier 1
*Le résigné*. Ingénieur systèmes épuisé. Pull informe, cernes prononcés, café tardif. Cynisme désarmant. **Power Tags** : connaissance systèmes Kaizen, invisibilité par épuisement. *« On est déjà filmés 24/7. Fais ce que tu veux. »* — son point d'entrée. **Couple** : Marine × Thomas.

#### Sofia Kessler · NEXUS · 28 ans · femme trans · Tier 2
*La vigilante éthique*. Département éthique d'une corpo qui collecte biométrie — paradoxe incarné. Sincère, structurellement complice. Registre : analytique → accusatrice → protectrice. **Sa force n'est pas la même au travail et dans l'intimité** : autorité éthique tenue en posture pro, plus exposée en intimité — une trahison intime ne peut pas être affrontée en posture d'autorité. **Power Tags** : alliance tacite avec Frank (professionnelle). **Couple** : Sofia × Alex. *Identité trans, paradoxe éthique, couple Alex : règles d'écriture intégrales dans `sofia-kessler-caracterisation`.* <!-- #4 : 3 redites Sofia condensées en un renvoi -->

#### Alex Norvège · NEXUS → STRATOM · 29 ans · homme · Tier 2
*Le double agent*. Implants neuronaux, scan biométrique passif permanent. Officiellement Nexus, réellement taupe Stratom. **Se salit les mains pour la corpo sans hésiter** (altération active des enregistrements biométriques selon mission), **mais jamais dans le dos de Sofia** — transparence totale dans le couple. **Weakness Tag** : triple loyauté impossible — si démasqué, perd les trois soutiens. **Condition canon d'un retournement contre Stratom** : décision de couple (Sofia & Alex basculent ensemble) — sauf branche optionnelle où Margot pousse Alex à trahir, auquel cas il bascule seul, effondré, et Sofia est très blessée. **Couple** : Sofia × Alex.

#### Camille Armand · STRATOM · 32 ans · femme · Tier 2
*La profileuse*. Voix chaleureuse, fausse intimité, profilage psychologique en temps réel. Contrôle de la pièce par la voix. **Power Tag** : réseau Stratom. **Caractérisation romance** : *dark cogni-affectif* (manipulation, jamais physique — le « dark » est dans l'asymétrie d'information et les mots qui déstabilisent ; aucune emprise corporelle). **Couple** : Camille × Frank (glacial).

#### Frank Désière · STRATOM · 42 ans · homme · Tier 1 <!-- #20 : âge tranché -->
*Le test*. Ex-opératif. Cicatrices visibles, parle peu, observe long. **Verdict en cours** : sa mission canon est d'**évaluer Margot pour Stratom** — décider si elle est menace à neutraliser ou ressource à retourner. Countdown Équipe Nettoyage (14 ticks) recule via tests d'intégrité réussis auprès de lui. **Couple** : Camille × Frank.

---

## Jauges et stakes joueur

### Jauges principales

Cf. [Glossaire](#glossaire) pour la définition de chaque sigle. Détail technique : `variables-register.md`.

| Jauge | Plage | Effet narratif principal |
|---|---|---|
| **MS** | 0-6 | < 2 colorie les dialogues, débloque/verrouille options. 0 → FIN-I |
| **PD** | 0-∞ (clamp 0+) | 6 → FIN-H |
| **EV** | 0-6 | 6 = exposé possible |
| **Surveillance** | 0-100 | Seuils 25 (HUD) / 50 (alerte) / 75 (cinematic) / 90 / 100 (game over) |
| **Mirror** | 0-100 | Seuils 30 (flashback) / 60 (hésitation) / 90 (option verrouillée) / 100 (game over) |
| **Réputation × 8 factions** | -100 à +100 | stratom · marine · presse · police · activistes · memorize · nexus · kaizen |
| **Relations × 17 PNJ** | -100 à +100 | 9 paliers visibles (Méfiance → Intime). *Décomposition des 17 : 8 résidents Saint-Michel + 9 PNJ Tier 1-2 hors-immeuble (Emma-cousine externes, contact Witness, contact activistes, contact police, etc. — détail dans `pnjs-secondaires.md`)* <!-- #19 --> |
| **Countdowns** | ticks ↓ | `equipe_nettoyage` (14) · `audit_marine` (15) |

### Stakes joueur

**Le jeu mesure l'écart entre ce que Margot prétend faire et ce qu'elle fait vraiment.**

**Plus elle cherche à comprendre, plus elle se retrouve à savoir ce qu'elle ne devrait pas savoir** — l'info indésirable s'accumule par effet de bord. Sa question morale est *« quoi faire de ce que j'ai vu sans le chercher »*, pas *« comment exposer »*.

Chaque faille découverte chez un couple propose un usage :

1. **Documentaire** — la faille intègre le tournage public, Margot tient son rôle. Mirror stable.
2. **Journalisme** — la faille devient un rush vendable à Witness Networks. EV +, mais coût sur les concerné·es.
3. **Romance** — la faille devient levier d'intimité personnelle. Active `FLAG_ROMANCE_ACTIF`. Mirror +.
4. **Levier** — la faille sert à obtenir autre chose (chantage tacite, faveur, info). Mirror ++.
5. **Arme** — exposition publique, déclenchement de cascade. Mirror +++ et conséquences corpo. *Choix de fin possible, jamais intention initiale.*

### Règles de gameplay canon

- **Règle 1 — Défaut sans choix = manipulation par PNJ.** Si le joueur ne pousse pas, le PNJ agit. Chaque `[choice]` doit comporter une option « subir/esquiver » qui déclenche un effet *PNJ-driven* (relation, surveillance, info captée), pas un no-op.
- **Règle 2 — Pression externe refusable.** Witness Networks et Stratom peuvent exiger ; Margot peut toujours refuser, contre PD / faction / contrat. **Mirror ne monte JAMAIS sur action involontaire externe** — uniquement sur action joueur confirmée.
- **Règle 3 — Failles hybrides.** Chaque faille a un tag déclaré dans son arc-spec : `transferable` (info Marine peut servir dans l'arc Camille) ou `anchored` (le silence Camille/Frank ne s'utilise nulle part ailleurs).

---

## Arborescence des arcs

Référence détaillée : `history.md`.

### CP — Création de personnage
Un seul nœud. Choix de **motivation de départ** (4 options : carrière, relations, militante, argent) qui colorie l'ensemble du dialogue. Sortie : `FLAG_MOTIVATION ∈ {carriere, relations, militante, argent}`.

### PRO — Prologue
- **PRO-01** Arrivée à Saint-Michel *(scène point-and-click implémentée)*
- **PRO-02** La Cellule, premier choix : poser les micros ou non *(à implémenter, spec dans `nodes/02.md`)*

Sortie prologue : valeurs initiales `MS=3 · PD=0 · EV=0`, countdowns activés, `FLAG_MICROS_POSES` posé.

### A1 — Acte I : Installation et collecte
Six séquences canoniques (cf. `history.md` ch. 1-7). Margot s'installe, observe, collecte premières preuves. Alliance avec Léo (flux vidéo). Premier contact décisif. Alex commence à se révéler.

Beats clés : A1-01 (confrontation Emma/Léo) · A1-03 (dîner d'arrivée) · A1-05 (nuit d'écoute) · A2-01 (rencontre Camille).

### A2 — Acte II : Romance optionnelle + pivot
Le NODE **A2-04** est le **point d'entrée romance** (un seul arc par run, premier PNJ atteignant relation ≥ +30 avec le bon flag).

**Pool romance complet — 8 PNJ accessibles, intrusion conjugale assumée :**

> ⚠ **Pool de tensions affectives, pas menu de drague.** Initiative variable (PNJ ou Margot), motivation variable (attirance / calcul / désamorçage / besoin affectif), lisibilité variable (geste ambigu, jamais étiqueté), aboutissement non garanti. Pas d'écran « choisis ton partenaire ». Cf. `pool-romance-pas-drague`.

<!-- #4 : tableau A2 condensé, retrait colonne « statut » devenue uniforme -->

| Arc | Particularité d'écriture |
|---|---|
| **A2-romance-frank** | Verdict basculé : Frank cherche à se racheter via Margot |
| **A2-romance-thomas** | Condition canon : *« Marine/Thomas : rupture visible »*. Mélancolique |
| **A2-romance-sofia** | Moteur éthique, pas séduction. Intrusion dans couple Sofia/Alex avec conséquences sur Alex |
| **A2-romance-marine** | Urgence, fragilité, livestream. Risque cascade |
| **A2-romance-camille** | Dark cogni-affectif. Margot retourne le profilage |
| **A2-romance-emma** | **Fusion-confusion non consommée.** Bascule cognitive (« tu es ma moitié biographique, pas mon amante »), pas morale. Pas de FIN-E variante Emma — fins fraternelles uniquement |
| **A2-romance-alex** | **Romance refusée** (D) par défaut : alliance opérationnelle profonde, tension non consommée. Branche **trahison opt-in** (B) verrouillée par choix joueur explicite |
| **A2-romance-leo** | Devient possible quand Margot perce la couche 1 (protection Emma) ou la couche 2 (coup personnel). Trois colorations selon la couche atteinte |

### A3 — Acte III : Confrontation et basculement
Confrontation avec Camille (retourner le profilage ?). Verdict de Frank (mission Stratom : Margot menace ou ressource ?). Tentative d'exposition partielle. Stratom déploie. Emma craque sous pression. Crédit solidaire menace. Point de bascule moral de Margot.

### A4 — Acte IV : Résolution
<!-- #25 : section étoffée pour parité avec A1/A2/A3 -->
Convergence vers une des 9 fins selon ratio EV/MS/PD/Mirror/Surveillance + flags. La résolution s'ouvre par un NODE-charnière où Margot pose le dernier choix éditorial *(que faire des rushes ?)*, puis chaque fin déroule sa coda spécifique (1-2 NODEs : conséquence immédiate + plan moral). Aucune fin n'est « bonne » au sens absolu — chacune mesure un type de coût différent. Les fins romance (FIN-E) intègrent une coda à 2 temps : sortie effective puis épilogue 6 mois après.

Beats clés : A4-01 (choix éditorial final) · A4-02-A à A4-02-I (coda spécifique à la fin atteinte).

---

## Fins canoniques (A-I)

Détail complet : `history.md` lignes 660-900.

| Fin | Nom | Conditions clé | Ton |
|---|---|---|---|
| **FIN-A** | La Reconstruction | EV=6 · MS=6 · Emma>+50 · micros=false · 0 trigger | Documentaire intact, Margot indemne |
| **FIN-B** | L'Exposé | EV=6 · MS≥3 · Emma>+50 · ≥1 allié | Fin principale, victoire avec coût |
| **FIN-C** | Le Pacte de Sang | EV=6 · Emma sacrifiée · MS=2-4 | Vérité au prix d'Emma |
| **FIN-D** | L'Alliance Corporate | EV=4-5 · deal corpo · Sofia/Léo/Emma>+60 | Compromis politique, variantes Nexus/Memorize <!-- #16 --> |
| **FIN-E** | La Romance comme Sortie | EV=3-5 · romance active · relation PNJ ≥+60 | Voir variantes ci-dessous |
| **FIN-F** | Les Mains Propres | EV=4-5 · MS≥5 · micros=false · mains_propres=true | Intégrité, victoire partielle |
| **FIN-G** | Le Silence | EV<4 · Witness vendu · toutes relations<+40 | Inaction comme choix |
| **FIN-H** | La Capture | PD=6 · countdown Équipe Nettoyage=0 · Frank hostile | Game over physique |
| **FIN-I** | Julien | MS=0 · 5/5 triggers internes | Game over thématique — Margot devient son ex |

<!-- #14 : rappel des axes sous le tableau -->
> *Axes communs aux conditions ci-dessus :* **EV** preuves (0-6), **MS** stabilité mentale (0-6), **PD** danger physique (0-∞), **Mirror** & **Surveillance** non explicitement listés mais peuvent verrouiller des branches via les seuils.

<!-- #9 : variantes FIN-E listées exhaustivement post-trancheage -->
### Variantes FIN-E (Romance comme Sortie) — état canon

| Variante | Statut | Note |
|---|---|---|
| FIN-E · Frank | ✅ canon | Verdict basculé, sortie possible |
| FIN-E · Thomas | ✅ canon | Mélancolique, rupture Marine/Thomas requise |
| FIN-E · Sofia | ✅ canon | Couple Sofia/Alex brisé en conséquence |
| FIN-E · Marine | ✅ canon | Sortie + protection cascade |
| FIN-E · Camille | ✅ canon | Retournement profilage |
| FIN-E · Léo | ⚠ conditionnel | Possible uniquement si couche 1 ou 2 percée — coloration variable |
| FIN-E · Alex | ⚠ opt-in trahison | Requiert branche trahison explicite ; Sofia très blessée |
| FIN-E · Emma | ❌ exclu | Fusion-confusion non consommée : fins fraternelles uniquement (cf. FIN-C) |

---

## Topologie corporatiste

<!-- #10 + #21 : diagramme augmenté avec double appartenance Alex, réaligné proprement -->

```
                  ┌────────────────────────┐
                  │    STRATOM CORP        │  bras armé +
                  │ (autorité de dernière  │  autorité ultime
                  │      instance)         │  sur les 4 corpos
                  └────────────┬───────────┘
                               │
            ┌──────────┬───────┴───────┬──────────┐
            ▼          ▼               ▼          ▼
        MEMORIZE    KAIZEN          NEXUS      STRATOM
         (bleu)     (orange)        (vert)     (rouge)
            │          │               │          │
        Emma ────  Marine ────    Sofia ────  Camille
         ×           ×               ×           ×
        Léo        Thomas          Alex* ──┐    Frank
                                           │
                                           ▼
                                     taupe Stratom
                                  (* Alex : Nexus public,
                                     Stratom réel ; transparent
                                     avec Sofia, opaque ailleurs)
```

### Statut canon du rassemblement

**Trois strates de couverture** :
- **N1 (grand public)** : bâtiment privé sans communication, invisibilisé par l'indifférence.
- **N2 (institutionnel)** : *« démonstration que les 4 corpos peuvent œuvrer ensemble »* — vitrine vertueuse. Les 8 résidents sont officiellement ambassadeurs.
- **N3 (secret)** : **Programme Nexus Social**, prototype contrôle urbain Néo-Paris 2090. Les 8 résidents sont aussi sujets d'expérience.

Margot est invitée pour valider N2 ; la crise survient quand elle perce N3. *Asymétrie d'information entre résidents — voir [matrice dédiée](#asymétrie-dinformation-sur-n3-programme-secret).*

**Saint-Michel = zone neutre** : aucune corpo n'a d'autorité juridictionnelle unilatérale → toute action contre Margot doit être négociée à 4. Cartographie d'arrondissement non tranchée, les arcs concrétiseront. Voir `bible-jeu.md § 3` (immeuble + symbolique archangélique).

### Pourquoi 4 carnivores collaborent

Rivales par essence, convergées par Nexus Social. Chaque corpo apporte une brique nécessaire :

| Corpo | Brique apportée à Nexus Social | Sans elle |
|---|---|---|
| MEMORIZE | Donnée brute + modèles prédictifs | Pas d'opérateur de déploiement urbain |
| KAIZEN | Métrique (KPI rendement/conformité) | Pas de produit vendable |
| NEXUS | Légitimité éthique + biométrie passive | Attaquable juridiquement, aveugle au corps |
| STRATOM | Menace de dernière instance | Aucun moyen d'action sur un perturbateur réel |

> **Question canon ouverte** : *est-ce répréhensible ?* — Margot la pose ; le jeu ne tranche pas hors arc Macro.

### Culture corpo, jobs, frictions

- **Cohabitation vs travail** : les liens quotidiens ont dépassé les clivages, mais le contexte pro réactive les rancœurs corpo. Cf. `corpos-job-ordinaire`.
- **Pas de missions secrètes** : les 8 PNJ font leur job ordinaire + ambitions perso.
- **Frictions corpo** : Memorize ↔ Stratom (prédictif vs coercitif), Kaizen méprise Nexus, Nexus méfie Memorize, Stratom = bras armé. Détail + zones grises par corpo dans `bible-jeu.md § 4`.

---

## Notes auteur

<!-- #6 : restructuré en 3 sous-sections nettes -->

### Décisions canon (prescriptif)

- **Inversion défaut Margot** : Margot terrain, PNJ acteurs. Pas de no-op silencieux dans les `[choice]`.
- **Mirror sur action confirmée uniquement** : pas de Mirror involontaire sur pression externe acceptée sous contrainte.
- **Failles hybrides** : déclarer `transferable`/`anchored` dans chaque arc-spec. *Exemple : la dette Marine est `transferable` (utilisable dans arc Camille comme levier de profilage) ; le silence Camille/Frank est `anchored` (n'a de sens que dans le couple où il se joue).*
- **Identité trans Sofia** : intégrée, jamais plot-point, pronoms `elle`, vocabulaire actuel, pas d'outing involontaire. Vérification persona `playtester-lgbtqia`.
- **Camille dark = cogni-affectif** : pas d'emprise physique. Le « dark » est dans le profilage et l'asymétrie d'information.
- **Emma A2-romance = fusion-confusion non consommée** : pas de FIN-E variante Emma — fins fraternelles uniquement.
- **Pool A2-romance ≠ menu de drague** : initiative variable, motivation variable, aboutissement non garanti.
- **Pas de chiffre affiché pour Mirror et Surveillance** au joueur — icônes/registres visuels (hérité de la règle RÉSILIENCES, [[CLAUDE.md]]).
- **Posture éthique Sofia inattaquable en intimité romantique** : tout dialogue contredisant le paradoxe éthique de Sofia est suspect (si la romance lui fait lâcher sa posture d'autorité, personnage cassé).

<!-- #11 : section anti-patterns consolidée -->
### Anti-patterns d'écriture (red flags à refuser en review)

- ❌ `[choice]` avec une option « ne rien faire » qui ne déclenche rien (viole Règle 1).
- ❌ Mirror appliqué sur une pression externe subie (viole Règle 2).
- ❌ Scène où un *ignorant N3* (Marine) décrit le Programme spontanément (viole asymétrie info).
- ❌ Romance Camille avec emprise physique (viole « dark = cogni-affectif »).
- ❌ Outing Sofia comme révélation dramatique (viole `sofia-kessler-caracterisation`).
- ❌ PNJ secondaire qui acquiert relation ou réputation (réservé aux 17 PNJ Tier 1-2).
- ❌ Variante FIN-E Emma (exclue canon — n'écrire que des fins fraternelles).
- ❌ Cascade Marine déclenchée par naïveté journalistique sans préavis playtester.

### Zones de risque à surveiller

- **Cascade Marine** : exposer Marine pour gagner EV déclenche la chute de tout l'immeuble. Documenter clairement dans l'arc-spec qu'il s'agit d'un *piège* — éviter qu'un playtester sympathique au journalisme la déclenche par naïveté.
- **Asymétrie surveillance × identités queer** : la mécanique Surveillance s'applique sans biais. Vérifier qu'aucun signal `surveillance:` n'est conditionné à un trait queer du PNJ visité.
- **Camille dark + sensitivity reader** : toute branche dark cogni-affectif doit passer `review-persona` avec `playtester-lgbtqia` ET `playtester-margot` (consentement informationnel lisible).

### Threads ouverts résiduels

*Aucun thread narratif majeur ouvert à ce jour.* Cause de la brouille familiale Margot/Emma laissée variable libre (héritage, choix de vie, accident, conflit politique) — à arbitrer si un arc-spec a besoin de la fixer.

<!-- #15 : production todos structurées -->
### Production todos

| Priorité | Tâche | Owner | État |
|---|---|---|---|
| P0 | Spec arc-spec A2-romance-emma (fusion-confusion non consommée) | narrative | À brainstormer |
| P0 | Spec arc-spec A2-romance-alex (D par défaut + branche B opt-in) | narrative | À brainstormer |
| P0 | Spec arc-spec A2-romance-leo (3 colorations par couche) | narrative | À brainstormer |
| P1 | Spec A3 (verdict Frank + confrontation Camille) | narrative | À brainstormer |
| P1 | Lint passe `dtl_linter.gd` sur tous les `.dtl` produits | dev | En cours |
| P2 | Arbitrer cause de brouille familiale Margot/Emma (si arc le requiert) | narrative | Différé |

---

## Conventions de production

- Toutes les ressources canon sont en français (variables, méthodes publiques, dialogues, commentaires) — sauf hooks Godot (`_ready`, `_input`).
- Méthodes impératives (`modifier`, `aller_a`, `sauvegarder`).
- snake_case strict GDScript.
- Dialogues écrits en `.dtl` (Dialogic 2), pilotage des managers via `DialogicBridge` (10 dispatchers : relation, flag, decision, lieu, surveillance, miroir, reputation, countdown, ms, pd).
- Linter mécanique : `scripts/tools/dtl_linter.gd` à passer en pre-LLM-review sur tout `.dtl`.

---

## Liens canon

| Document | Rôle |
|---|---|
| `bible-jeu.md` | Worldbuilding, fiches PNJ Tier 1-3, fiches corpo, palettes, registres vocaux |
| `history.md` | Arborescence des scènes (NODES), 9 fins détaillées, threads playtest |
| `internal/architecture.md` | 14 autoloads, conventions de fichiers par NODE |
| `variables-register.md` | Liste exhaustive variables et flags |
| `session-exemple-01.md` | Référence de ton sur PRO-01 + A1 (playtest 2025-11-21) |
| `pnjs-secondaires.md` | PNJ Tier 2/3 cités mais non interactifs |
| `nodes/*.md` | Spec détaillée par NODE (point-and-click hotspots, choix) |
| `internal/etat-prod.md` | État d'implémentation des scripts et `.dtl` |

| Mémoire interne | Rôle |
|---|---|
| `internal/api-cheatsheet.md` | Syntaxe complète DialogicBridge (10 dispatchers, exemples) |<!-- #24 : architecture.md retiré ici (déjà dans la table Documents canon ci-dessus) -->
| `internal/code-state.md` | Snapshot du code Godot (managers, scripts) |
| `internal/design-rules/sofia-kessler-caracterisation.md` | Règles d'écriture spécifiques Sofia (trans · vigilante éthique · couple Alex) |
| `internal/design-rules/margot-terrain-neutre.md` | Règle centrale : défaut sans choix = PNJ mènent. Mirror = instrumentalisation subie |
| `internal/design-rules/margot-documentariste-sincere.md` | Registre sociologique · double instrumentalisation corpos × Witness |
| `internal/design-rules/corpos-job-ordinaire.md` | Pas de missions secrètes · agents importants · culture corpo vs cohabitation |
| `internal/design-rules/pool-romance-pas-drague.md` | Pool A2 = tensions affectives, pas drague |

---

<!-- #5 : threads tranchés déplacés en archive de bas de doc -->
## Archive — threads tranchés 2026-05-21

*Historique opérationnel conservé pour mémoire. Toutes ces décisions sont maintenant intégrées au corps du document ci-dessus.*

- ~~Léo — agenda caché précis~~ → **hybride à 3 couches** : esthétique publique / protection Emma / coup personnel justifié. Cf. fiche Léo.
- ~~Alex — condition de retournement contre Stratom~~ → **acte de couple** (Sofia & Alex ensemble) ; branche trahison opt-in à point de bascule. Cf. fiche Alex.
- ~~Margot — orientation/genre~~ → **inférée par défaut, jamais thématisée** dans CP. Pool 8 PNJ reste accessible. Cohérent avec `ExProfileManager` (ex de tout genre).
- ~~Margot — âge~~ → **32 ans** (tranché upgrade v2).
- ~~Emma — degré de cousinage et histoire commune~~ → **germaines + éloignement vécu** (brouille familiale ancienne, peu de souvenirs partagés, reconnexion adulte tardive via Julien). A2-romance-emma = **fusion-confusion non consommée**. Cf. fiche Emma + `bible-jeu.md § 6`.
- ~~Pool A2-romance — statut de jeu~~ → **tensions affectives ambiguës, pas drague**. Initiative variable, motivation variable, aboutissement non garanti.
- ~~Variantes FIN-E~~ → **5 canon + 2 conditionnelles (Léo, Alex opt-in) + Emma exclue** (tranché upgrade v2).

---

*Overview v3 (upgrade 2026-05-21). Prochaine étape : `arc-spec` sur les arcs A2-romance Emma/Alex/Léo (3 à brainstormer) puis A3.*
