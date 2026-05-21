# 8-MINE — Overview projet

> Synthèse macroscopique. Source de vérité pour `arc-spec`.
> Construite par `brainstorm` (session 2026-05-21) à partir de `bible-jeu.md`, `history.md`, `internal/architecture.md`, `internal/variables-register.md`, `session-exemple-01.md`.
> Ne pas écrire d'arc complet ici — les arcs vivent dans `memory/external/arcs/`.

---

## Pitch

**8-MINE** est un jeu narratif cyberpunk sociologique. Margot Sinclair, journaliste documentariste post-rupture, s'installe trois mois dans un coliving expérimental de Néo-Paris (immeuble Saint-Michel) sous prétexte de tourner un documentaire sur *« les couples modernes ».* La vraie raison : un cousin l'a contactée — l'immeuble est le laboratoire vivant du **Programme Nexus Social**, expérience secrète de contrôle prédictif menée conjointement par quatre corporations (MEMORIZE, KAIZEN, NEXUS, STRATOM). Les huit résidents sont des sujets, organisés en quatre binômes-couples corporatistes. Chaque couple a ses failles ; Margot, dont c'est le métier, va les découvrir une par une. À chaque faille découverte, un choix : *documentaire, journalisme, romance, levier, arme.* Le jeu mesure l'écart entre ce que Margot prétend faire et ce qu'elle fait vraiment.

---

## Cast principal

### Protagoniste — Margot Sinclair

**Journaliste documentariste · ~32 ans · post-rupture · orientation à déterminer (cf. threads ouverts)**

Couverture : documentaire CNC sur le coliving. Mission réelle : enquêter sur le Programme Nexus Social après alerte de sa cousine Emma. Outils : caméra légère, micros (option PRO-02), Witness Networks comme diffuseur sous contrat (pression sensationnaliste).

**Règle de design centrale** : Margot n'est pas un personnage qui « dérive vers l'instrumentalisation ». C'est un **terrain neutre** sur lequel les PNJ agissent activement (profilage, scan biométrique, test, séduction, manipulation). Sans choix joueur conscient, ce sont les PNJ qui mènent. Mirror [0-100] mesure l'**instrumentalisation subie**, pas la dérive interne. Cf. mémoire `margot-terrain-neutre`.

### Les 8 résidents et leurs 4 couples

Les binômes corporatistes du Programme sont **aussi** des couples réels. Quatre dyades, quatre statuts intimes, quatre failles structurelles.

| Binôme corpo | Couple | Statut conjugal canon | Faille principale |
|---|---|---|---|
| MEMORIZE *(bleu `#4a90d9`)* | **Emma × Léo** | Couple intime acté, intimité audible | Léo cultive une surface esthétique ; il a un agenda réel caché *(à préciser — cf. threads ouverts)* dont Emma ne sait rien |
| KAIZEN *(orange `#d9a44a`)* | **Marine × Thomas** | Couple en tension visible, dispute étouffée | Dette cachée 45 k€ de Marine + résignation de Thomas qui n'y croit plus |
| NEXUS *(vert `#4ad97a`)* | **Sofia × Alex** | Couple actuel, scène nocturne = confrontation éthique de couple | Sofia (éthique) suspecte ce qu'Alex (taupe Stratom) cache ; Alex la considère comme sa « faille émotionnelle » |
| STRATOM *(rouge `#d94a4a`)* | **Camille × Frank** | Couple réel mais glacial — chacun lit l'autre en permanence (profileuse + ex-opératif) | Aucun amour partagé, intimité étouffée par leurs métiers respectifs |

**Conséquence** : 6 résidents sur 8 sont engagés intra-coliving. Toute romance Margot × PNJ_marié est une intrusion conjugale assumée, qui **doit** se lire en double-jeu (chaque PNJ a une raison propre de sortir de son couple via Margot — ce n'est jamais une intrusion unilatérale). *Exception canon* : Sofia/Alex est un couple si solide et transparent que `A2-romance-alex` est conçu en **romance refusée** (D) — l'intrusion n'aboutit pas, sauf branche trahison opt-in explicite (cf. fiche Alex + tableau A2).

---

### Statut canon des 8 résidents — agents importants

Les 8 résidents sont des **agents importants avec responsabilités significatives** (Saint-Michel = immeuble prestigieux, zone stratégique négociée — pas de poste subalterne). Tension d'écriture : **fragilité visible quotidienne ≠ inexpérience** — chacun a un vrai pouvoir d'action en contexte pro.

*→ Détail canon : `bible-jeu.md § 6` (Note de design #4) · mémoire [[corpos-job-ordinaire]]*

### Fiches synthétiques par PNJ

#### Emma Castellane · MEMORIZE · 28 ans · femme · Tier 1
*La cousine tiraillée*. **Cousine germaine de Margot — éloignement vécu** *(tranché 2026-05-21)* : branches familiales coupées par brouille ancienne dans leur enfance, peu de souvenirs partagés robustes, reconnexion adulte tardive dont Julien (ex de Margot) fut le catalyseur. L'appel d'Emma à Saint-Michel = réparation de la brouille. Loyale au système qui l'emploie, coupable de ce qu'il fait. C'est elle qui a fait venir Margot — l'aide *« avant d'en avoir le courage de partir »*. Power Tags : accès flux Memorize, connaissance interne, liens familiaux activables. Couple : Emma × Léo (intime, acté).

#### Léo Mars · MEMORIZE · ~30 ans · homme · Tier 2
*Le saboteur silencieux*. **Agenda à trois couches** *(tranché 2026-05-21)* : (a) **surface publique** = lassitude esthétique cultivée pour passer sous radar ; (b) **couche 1** = protection d'Emma à son insu (il a compris ce que Memorize prépare pour sa cousine et sabote pour la couvrir) ; (c) **couche 2** = il monte aussi un coup structuré sur les flux vidéo Memorize, qu'il *justifie* par la protection d'Emma mais qui le sert lui-même. Le couple Emma/Léo gagne ainsi une asymétrie canon : elle aime ; il aime + il protège + il opère. Couche révélée selon EV + relation Léo. Couple : Emma × Léo.

#### Marine Dubois · KAIZEN · 26 ans · femme · Tier 2
*La performeuse au bord du gouffre*. 75 k abonnés, sourire crispé, **45 k€ de dette cachée**. Audit Kaizen en cours (countdown 15 ticks). Si elle tombe, cascade crédit solidaire → tout l'immeuble s'effondre. **Piège Margot** : si Margot expose Marine pour gagner EV, elle déclenche elle-même la cascade. Couple : Marine × Thomas (tension).

#### Thomas Renard · KAIZEN · 29 ans · homme · Tier 1
*Le résigné*. Ingénieur systèmes épuisé. Pull informe, cernes prononcés, café tardif. Cynisme désarmant. Power Tags : connaissance systèmes Kaizen, invisibilité par épuisement. *« On est déjà filmés 24/7. Fais ce que tu veux. »* — son point d'entrée. Couple : Marine × Thomas.

#### Sofia Kessler · NEXUS · 28 ans · femme trans · Tier 2
*La vigilante éthique*. Département éthique d'une corpo qui collecte biométrie — paradoxe incarné. Sincère, structurellement complice. Registre : analytique → accusatrice → protectrice. **Identité trans** : connue de tous les résidents depuis longtemps, intégrée, jamais le sujet d'une scène. Power Tag #3 : *alliance tacite avec Frank* (professionnelle, pas romantique). Couple : Sofia × Alex — solide, démonstratif, transparent ; Alex est partie de ce qui rend possible son intégration en milieu corpo conservateur. **Sa force n'est pas la même au travail et dans l'intimité** : autorité éthique tenue en posture pro, plus exposée en intimité — une trahison intime ne peut pas être affrontée en posture d'autorité. Cf. mémoire `sofia-kessler-caracterisation`.

#### Alex Norvège · NEXUS → STRATOM · 29 ans · homme · Tier 2
*Le double agent*. Implants neuronaux, scan biométrique passif permanent. Officiellement Nexus, réellement taupe Stratom. **Se salit les mains pour la corpo sans hésiter** (altération active des enregistrements biométriques selon mission), **mais jamais dans le dos de Sofia** — transparence totale dans le couple. Weakness Tag : *triple loyauté impossible — si démasqué, perd les trois soutiens*. Couple : Sofia × Alex (solide, démonstratif, vie de couple assumée). **Condition canon d'un retournement contre Stratom** : décision de couple (Sofia & Alex basculent ensemble) — sauf branche optionnelle où Margot pousse Alex à trahir, auquel cas il bascule seul, effondré, et Sofia est très blessée.

#### Camille Armand · STRATOM · 32 ans · femme · Tier 2
*La profileuse*. Voix chaleureuse, fausse intimité, profilage psychologique en temps réel. Contrôle de la pièce par la voix. Power Tag : réseau Stratom. Caractérisation romance : *dark cogni-affectif* (manipulation, jamais physique — le « dark » est dans l'asymétrie d'information et les mots qui déstabilisent ; aucune emprise corporelle). Couple : Camille × Frank (glacial).

#### Frank Désière · STRATOM · ~40 ans · homme · Tier 1
*Le test*. Ex-opératif. Cicatrices visibles, parle peu, observe long. **Verdict en cours** : sa mission canon est d'**évaluer Margot pour Stratom** — décider si elle est menace à neutraliser ou ressource à retourner. Countdown Équipe Nettoyage (14 ticks) recule via tests d'intégrité réussis auprès de lui. Couple : Camille × Frank.

---

## Jauges et stakes joueur

### Jauges principales (variables-register.md)

| Jauge | Plage | Source autorité | Effet narratif principal |
|---|---|---|---|
| **MS** — Mental Stability | 0-6 | `GameStateManager.mental_stability` | Score de santé narrative. < 2 colorie les dialogues, débloque/verrouille options. 0 → FIN-I |
| **PD** — Personal Danger | 0-∞ (clamp 0+) | `GameStateManager.personal_danger` | Pression physique. 6 → FIN-H |
| **EV** — Evidence Collected | 0-6 | `GameStateManager.evidence_collected` | Preuves accumulées sur le Programme. 6 = exposé possible |
| **Surveillance externe** | 0-100 | `SurveillanceManager` | Pression Stratom/caméras. Seuils 25/50/75/90/100 (100 = game over) |
| **Mirror** — dette d'authenticité | 0-100 | `MirrorStatusManager` | **Mesure de l'instrumentalisation subie**. Seuils 30/60/90/100 (100 = game over miroir) |
| **Réputation × 8 factions** | -100 à +100 | `ReputationManager` | stratom, marine, presse, police, activistes, memorize, nexus, kaizen |
| **Relations × 17 PNJ** | -100 à +100 | `RelationManager` | 9 paliers visibles (Méfiance → Intime) |
| **Countdowns** | ticks décroissants | `CountdownManager` | `equipe_nettoyage` (14) · `audit_marine` (15) |

### Stakes joueur

**Le jeu mesure l'écart entre ce que Margot prétend faire et ce qu'elle fait vraiment.**

**Intention initiale canon** : Margot **a un passé d'investigation** (compétences acquises, pas naïve techniquement) **mais son registre actuel est sociologique — curieusement**, pas son registre habituel. Elle vient observer la cohabitation pour *comprendre*, pas pour révéler.

**Double instrumentalisation** : les 4 corpos parient sur N2 (documentaire reste à la couverture officielle « démonstration collaboration »). **Witness Networks** l'a peut-être envoyée au casse-pipe — commande sociologique vendable + espoir secret qu'elle déterre un scoop grâce à ses compétences d'investigatrice. Margot est l'enjeu silencieux entre deux logiques, sans nécessairement le savoir au départ.

**Plus elle cherche à comprendre, plus elle se retrouve à savoir ce qu'elle ne devrait pas savoir** — l'info indésirable s'accumule par effet de bord de l'attention soutenue. Ses compétences d'investigatrice rendent le glissement *techniquement possible* sans qu'il soit *intentionné*. Sa question morale est *« quoi faire de ce que j'ai vu sans le chercher »*, pas *« comment exposer »*. La pression Witness peut être déclencheur de bascule (Règle 2). Cf. mémoire `margot-documentariste-sincere`.

Chaque faille découverte chez un couple propose un usage :

1. **Documentaire** — la faille intègre le tournage public, Margot tient son rôle. Mirror stable.
2. **Journalisme** — la faille devient un rush vendable à Witness Networks. EV +, mais coût sur les concerné·es.
3. **Romance** — la faille devient levier d'intimité personnelle. Active `FLAG_ROMANCE_ACTIF`. Mirror +.
4. **Levier** — la faille sert à obtenir autre chose (chantage tacite, faveur, info). Mirror ++.
5. **Arme** — exposition publique, déclenchement de cascade. Mirror +++ et conséquences corpo. *Choix de fin possible, jamais intention initiale.*

**Règle 1 — Défaut sans choix = manipulation par PNJ.** Si le joueur ne pousse pas, le PNJ agit. Chaque `[choice]` doit comporter une option « subir/esquiver » qui déclenche un effet *PNJ-driven* (relation, surveillance, info captée), pas un no-op.

**Règle 2 — Pression externe refusable.** Witness Networks et Stratom peuvent exiger ; Margot peut toujours refuser, contre PD / faction / contrat. **Mirror ne monte JAMAIS sur action involontaire externe** — uniquement sur action joueur confirmée.

**Règle 3 — Failles hybrides.** Chaque faille a un tag déclaré dans son arc-spec : `transferable` (info Marine peut servir dans l'arc Camille) ou `anchored` (le silence Camille/Frank ne s'utilise nulle part ailleurs).

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

> ⚠ **Pool de tensions affectives, pas menu de drague.** Initiative variable (PNJ ou Margot), motivation variable (attirance / calcul / désamorçage / besoin affectif), lisibilité variable (geste ambigu, jamais étiqueté), aboutissement non garanti. Pas d'écran « choisis ton partenaire ». Cf. `internal/design-rules/pool-romance-pas-drague.md`.

| Arc | Statut | Particularité d'écriture |
|---|---|---|
| **A2-romance-frank** | ✅ documenté `history.md` | Verdict basculé : Frank cherche à se racheter via Margot |
| **A2-romance-thomas** | ✅ documenté `history.md` | Condition canon : *« Marine/Thomas : rupture visible »*. Mélancolique |
| **A2-romance-sofia** | ✅ documenté `history.md` | Moteur éthique, pas séduction. Intrusion dans couple Sofia/Alex avec conséquences sur Alex |
| **A2-romance-marine** | ✅ documenté `history.md` | Urgence, fragilité, livestream. Risque cascade |
| **A2-romance-camille** | ✅ documenté `history.md` | Dark cogni-affectif. Margot retourne le profilage |
| **A2-romance-emma** | ✅ tranché 2026-05-21 | **Fusion-confusion non consommée.** Cousines germaines avec éloignement vécu — l'absence d'histoire commune robuste surcharge les retrouvailles (intimité fantasmée par projection). Non-franchissement *cognitif* (« tu es ma moitié biographique, pas mon amante »), pas moral. Pas de variante FIN-E Emma — fins fraternelles : pacte scellé, sacrifice (FIN-C), rupture |
| **A2-romance-alex** | ✅ tranché 2026-05-21 | **Romance refusée** (D) : alliance opérationnelle profonde + tension d'attirance jamais consommée — Sofia perçoit, n'est pas jalouse, Alex ne franchit pas. Branche **trahison opt-in** (B) verrouillée par choix joueur explicite à point de bascule : Alex bascule, Sofia très blessée *en intimité* (pas en posture pro) |
| **A2-romance-leo** | ✅ tranché 2026-05-21 | Devient possible quand Margot perce la couche 1 (protection Emma) ou la couche 2 (coup personnel) de l'agenda Léo. Trois colorations selon la couche atteinte |

### A3 — Acte III : Confrontation et basculement
Confrontation avec Camille (retourner le profilage ?). Verdict de Frank (mission Stratom : Margot menace ou ressource ?). Tentative d'exposition partielle. Stratom déploie. Emma craque sous pression. Crédit solidaire menace. Point de bascule moral de Margot.

### A4 — Acte IV : Résolution
Convergence vers une des 9 fins selon ratio EV/MS/PD/Mirror/Surveillance + flags.

---

## Fins canoniques (A-I)

Détail complet : `history.md` lignes 660-900. Synthèse des conditions de tête :

| Fin | Nom | Conditions clé | Ton |
|---|---|---|---|
| **FIN-A** | La Reconstruction | EV=6 · MS=6 · Emma>+50 · micros=false · 0 trigger | Documentaire intact, Margot indemne |
| **FIN-B** | L'Exposé | EV=6 · MS≥3 · Emma>+50 · ≥1 allié | Fin principale, victoire avec coût |
| **FIN-C** | Le Pacte de Sang | EV=6 · Emma sacrifiée · MS=2-4 | Vérité au prix d'Emma |
| **FIN-D** | L'Alliance Corporate | EV=4-5 · deal corpo · Sofia/Léo/Emma>+60 | Compromis politique, variantes Nexus/Memorize |
| **FIN-E** | La Romance comme Sortie | EV=3-5 · romance active · relation PNJ ≥+60 | 5 variantes (Frank · Thomas · Sofia · Marine · Camille) + 3 à brainstormer |
| **FIN-F** | Les Mains Propres | EV=4-5 · MS≥5 · micros=false · mains_propres=true | Intégrité, victoire partielle |
| **FIN-G** | Le Silence | EV<4 · Witness vendu · toutes relations<+40 | Inaction comme choix |
| **FIN-H** | La Capture | PD=6 · countdown Équipe Nettoyage=0 · Frank hostile | Game over physique |
| **FIN-I** | Julien | MS=0 · 5/5 triggers internes | Game over thématique — Margot devient son ex |

---

## Topologie corporatiste

```
                ┌─────────────────┐
                │  STRATOM CORP   │  (couvre les 4)
                └─────────────────┘
                       │
        ┌──────┬───────┼───────┬──────┐
        ▼      ▼               ▼      ▼
   MEMORIZE  KAIZEN          NEXUS  STRATOM
    bleu    orange           vert    rouge
   Emma ×   Marine ×        Sofia ×  Camille ×
    Léo     Thomas           Alex     Frank
```

### Statut canon du rassemblement

**Trois strates de couverture** :
- **N1 (grand public)** : bâtiment privé sans communication, invisibilisé par l'indifférence.
- **N2 (institutionnel)** : *« démonstration que les 4 corpos peuvent œuvrer ensemble »* — vitrine vertueuse. Les 8 résidents sont officiellement ambassadeurs.
- **N3 (secret)** : **Programme Nexus Social**, prototype contrôle urbain Néo-Paris 2090. Les 8 résidents sont aussi sujets d'expérience.

Margot est invitée pour valider N2 ; la crise survient quand elle perce N3. Asymétrie d'information entre résidents (qui sait N3) = levier narratif majeur — détail dans `bible-jeu.md § 3`.

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

- **Cohabitation vs travail** : les liens quotidiens ont dépassé les clivages, mais le contexte pro réactive les rancœurs corpo. Cf. `internal/design-rules/corpos-job-ordinaire.md`.
- **Pas de missions secrètes** : les 8 PNJ font leur job ordinaire + ambitions perso. Même mémoire.
- **Frictions corpo** : Memorize ↔ Stratom (prédictif vs coercitif), Kaizen méprise Nexus, Nexus méfie Memorize, Stratom = bras armé. Détail + zones grises par corpo dans `bible-jeu.md § 4`.

---

## Notes auteur

### Threads ouverts résiduels (à arbitrer avant écriture des arcs concernés)

*Aucun thread narratif majeur ouvert à ce jour.* Cause de la brouille familiale Margot/Emma laissée variable libre (héritage, choix de vie, accident, conflit politique) — à arbitrer si un arc-spec a besoin de la fixer.

### Threads tranchés 2026-05-21 *(historique récent — pour mémoire)*

- ~~Léo — agenda caché précis~~ → **hybride à 3 couches** : esthétique publique / protection Emma / coup personnel justifié. Cf. fiche Léo.
- ~~Alex — condition de retournement contre Stratom~~ → **acte de couple** (Sofia & Alex ensemble) ; branche trahison opt-in à point de bascule. Cf. fiche Alex.
- ~~Margot — orientation/genre~~ → **inférée par défaut, jamais thématisée** dans CP. Pool 8 PNJ reste accessible. Cohérent avec `ExProfileManager` (ex de tout genre).
- ~~Emma — degré de cousinage et histoire commune~~ → **germaines + éloignement vécu** (brouille familiale ancienne, peu de souvenirs partagés, reconnexion adulte tardive via Julien). A2-romance-emma = **fusion-confusion non consommée** (bascule cognitive, pas morale). Cf. fiche Emma + `bible-jeu.md § 6`.
- ~~Pool A2-romance — statut de jeu~~ → **tensions affectives ambiguës, pas drague**. Initiative variable, motivation variable, aboutissement non garanti. Cf. `internal/design-rules/pool-romance-pas-drague.md`.

### Décisions de design à respecter

- **Inversion défaut Margot** : Margot terrain, PNJ acteurs. Pas de no-op silencieux dans les `[choice]`.
- **Mirror sur action confirmée uniquement** : pas de Mirror involontaire sur pression externe acceptée sous contrainte.
- **Failles hybrides** : déclarer `transferable`/`anchored` dans chaque arc-spec.
- **Identité trans Sofia** : intégrée, jamais plot-point, pronoms `elle`, vocabulaire actuel, pas d'outing involontaire. Vérification persona `playtester-lgbtqia`.
- **Camille dark = cogni-affectif** : pas d'emprise physique. Le « dark » est dans le profilage et l'asymétrie d'information.
- **Emma A2-romance = fusion-confusion non consommée** : intensité affective surchargée par les retrouvailles tardives, bascule cognitive (« tu es ma moitié biographique »), pas franchie. Pas de FIN-E variante Emma — fins fraternelles uniquement. Cf. `pool-romance-pas-drague.md`.
- **Pool A2-romance ≠ menu de drague** : initiative variable, motivation variable, aboutissement non garanti — règle transversale.
- **Pas de chiffre affiché pour Mirror et Surveillance** au joueur — icônes/registres visuels (cohérence avec règle RÉSILIENCES, hérité via [[CLAUDE.md]] du repo).
- **Tout dialogue contredisant le paradoxe éthique de Sofia est suspect** (si la romance lui fait lâcher sa posture d'autorité, personnage cassé).

### Zones de risque à surveiller

- **Cascade Marine** : exposer Marine pour gagner EV déclenche la chute de tout l'immeuble. Documenter clairement dans l'arc-spec qu'il s'agit d'un *piège* — éviter qu'un playtester sympathique au journalisme la déclenche par naïveté.
- **Asymétrie surveillance × identités queer** : la mécanique Surveillance s'applique sans biais. Vérifier qu'aucun signal `surveillance:` n'est conditionné à un trait queer du PNJ visité.
- **Camille dark + sensitivity reader** : toute branche dark cogni-affectif doit passer `review-persona` avec `playtester-lgbtqia` ET `playtester-margot` (consentement informationnel lisible).

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
| `internal/architecture.md` | Conventions · 14 autoloads · pipeline · structure NODE |
| `internal/api-cheatsheet.md` | Syntaxe complète DialogicBridge (10 dispatchers, exemples) |
| `internal/code-state.md` | Snapshot du code Godot (managers, scripts) |
| `internal/design-rules/sofia-kessler-caracterisation.md` | Règles d'écriture spécifiques Sofia (trans · vigilante éthique · couple Alex) |
| `internal/design-rules/margot-terrain-neutre.md` | Règle centrale : défaut sans choix = PNJ mènent. Mirror = instrumentalisation subie |
| `internal/design-rules/margot-documentariste-sincere.md` | Registre sociologique · double instrumentalisation corpos × Witness |
| `internal/design-rules/corpos-job-ordinaire.md` | Pas de missions secrètes · agents importants · culture corpo vs cohabitation |

---

*Overview construit le 2026-05-21. Prochaine étape : `arc-spec` sur les 8 arcs A2-romance (5 documentés + 3 à brainstormer) et A3.*
