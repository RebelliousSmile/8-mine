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

Néo-Paris est organisée en couches. En bas, les **canaux de Sous-Paris** charrient leurs eaux sombres — les exclus, les endettés, les sans-implants. Au niveau intermédiaire, les **districts commerciaux** : forêt d'enseignes holographiques, marchés gris, Ghost Markets. En haut, les **tours corporatistes** percent la couche de pollution, réservées aux employés valides.

La mobilité sociale n'existe plus. Ce qui existe, c'est le **crédit solidaire** — un système d'endettement collectif qui lie les individus à leurs corporations et entre eux, rendant toute rébellion individuellement impossible.

### L'Immeuble Saint-Michel — Le lieu de jeu

> Tour de 20 étages, verre intelligent, alliages composites. Au sommet : quatre logos holographiques géants. MEMORIZE en bleu `#4a90d9`. KAIZEN en orange `#d9a44a`. NEXUS en vert `#4ad97a`. STRATOM en rouge `#d94a4a`. Le hall : atrium 15 mètres de haut, sol marbre synthétique, cascades d'eau recyclée. Propre. Froid. Aseptisé.

**Statut canon — Trois strates de couverture** :

**N1 — Invisibilité grand public**. C'est un bâtiment de travail entièrement privé, sans communication grand public, sans image marketing. Les 4 logos au sommet sont la seule signature, visibles à qui lève les yeux. Personne ne lève les yeux : dans le Néo-Paris résiduel, chacun marche les yeux dans son agent personnel AR. La cohabitation des 4 corpos n'est pas activement cachée au public ; elle est **invisibilisée par l'indifférence ambiante**.

> *« Si quelqu'un regardait l'immeuble cinq secondes, il verrait. Personne ne regarde cinq secondes. »*

**N2 — Couverture institutionnelle officielle**. Auprès des régulateurs, partenaires institutionnels, investisseurs, élites politiques, autres corpos non-coalisées et clients stratégiques, le projet est présenté comme **« une démonstration que les 4 corpos peuvent œuvrer ensemble »**. Vitrine vertueuse de collaboration interopérable. C'est cette couverture qui rend la coalition acceptable auprès des instances qui pourraient la bloquer (anti-trust, éthique publique) — et qui rend possible d'inviter une **journaliste-documentariste externe** sans susciter la suspicion. Les 8 résidents sont officiellement des **ambassadeurs** sélectionnés par leur corpo pour incarner la démonstration.

**N3 — Projet réel secret**. Sous cette couverture officielle, le **vrai projet commun** est le **Programme Nexus Social** — prototype de contrôle urbain à déployer sur Néo-Paris d'ici 2090. Les 8 résidents sont aussi des sujets d'expérience. Leurs comportements, conflits, solidarités — tout est mesuré.

**Pourquoi Margot est là** : invitée pour réaliser un **documentaire qui valide la couverture N2** (« voyez comme la collaboration corpo fonctionne »). Les 4 corpos parient que son film restera au niveau N2 et n'atteindra pas N3. La clause 12.1 du contrat (accès Memorize à ses rushes) est l'outil de censure prévu si elle s'approche trop. **La crise = quand Margot commence à percer N3**. Elle est la première personne extérieure à *regarder* l'immeuble plus de cinq secondes.

**Qui sait quoi parmi les 8 résidents** *(à valider — draft)* : Sofia (Nexus éthique, sait), Alex (taupe Stratom, sait), Camille et Frank (Stratom, savent) ont conscience de N3. Emma, Léo, Marine, Thomas — *flou* : peut-être ne savent que N2 (ambassadeurs sincères de la démonstration officielle). Cette asymétrie d'information entre résidents est un levier narratif majeur.

**Pourquoi Saint-Michel ?**

**Raison première — Zone neutre négociée**. Les 4 corpos se sont partagé Néo-Paris par juridictions de facto : chaque corpo a la mainmise sur sa propre zone d'influence (contrats locaux, intimidation, contrôle des flux). La répartition est **hybride** : un cœur cohérent avec le métier de chaque corpo (affinité fonctionnelle des arrondissements où elles règnent) + une périphérie irrégulière constituée par rachat opportuniste sur des décennies, avec des **zones grises franches** où aucune corpo n'a réussi à prendre pied. Saint-Michel est l'une de ces zones non-conquises — trop patrimonial, trop visible, trop contesté pour qu'une seule corpo puisse l'annexer. Cette neutralité de fait a été convertie en **zone de médiation négociée** pour héberger l'expérience Nexus Social : personne n'y joue à domicile. Le symbole archangélique (Saint-Michel = médiateur, archange justicier neutre, vainqueur du dragon) renforce le choix : terrain mythologiquement *au-dessus* de la lutte.

> **Note canon** — La cartographie arrondissement-par-arrondissement n'est **pas tranchée**. On grave le principe (mainmise hybride affinité + historique, zones grises possibles, Saint-Michel neutre) ; les arcs concrétiseront au cas par cas si Margot doit sortir de l'immeuble.

**Raison secondaire — Prestige**. Initialement prévu à Oberkampf, déplacé à Saint-Michel pour la valeur du quartier — fontaine, Seine, Quartier Latin résiduel, adresse de très haute valeur foncière. Cobayes corporatistes en cadre haut de gamme historique. Le luxe matériel dissimule la dépossession — la haute culture européenne ancienne (pierre, eau, lumière) sert de revêtement à l'expérience cyberpunk.

**Conséquence canon** : à Saint-Michel, **aucune corpo ne peut faire valoir une autorité juridictionnelle locale**. Frank (Stratom) ne peut pas déclencher l'Équipe Nettoyage sur place sans validation des 3 autres corpos. Sofia (Nexus) ne peut pas convoquer un audit éthique unilatéral. Memorize ne peut pas saisir les rushes de Margot par simple injonction de palier — il faut passer par la clause 12.1 du contrat (canal contractuel, pas territorial). La neutralité de Saint-Michel est ce qui *protège partiellement Margot* — mais c'est aussi ce qui rend les 4 corpos d'autant plus *coordonnées* face à elle (aucune n'agit seule, donc toute action est négociée à 4).

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

> La Synergie Quadri-Corp n'est **pas une alliance naturelle**. Les 4 corpos visent toutes la croissance économique par tous les moyens et l'accumulation de pouvoir — elles sont **rivales par essence**. Saint-Michel est l'exception, pas la règle : un projet unique (Nexus Social) les a fait converger. *Pourquoi ce projet précis fait collaborer 4 carnivores, et est-ce répréhensible ?* — question canon que Margot pose à mesure qu'elle creuse, et que le jeu **ne tranche pas hors arc Macro**.

> **Note de design** — Les corporations ne sont jamais des adversaires directs dans le gameplay. Elles passent toutes par leurs agents humains. Margot interagit avec des *personnes*, pas des structures abstraites. Les frictions inter-corpos sont du carburant narratif.

> **Note de design #2 — Pas de « missions secrètes »**. Les 8 PNJ résidents n'ont pas reçu d'ordre spécial concernant Margot. Ils **font leur job** (profilage, scan biométrique, audit, éthique, design, sécurité, manufacturing, data), plus leurs **ambitions personnelles d'agents corporatistes**. Le job s'applique à Margot par défaut parce qu'elle est dans leur périmètre. L'instrumentalisation vient du *quotidien professionnel exécuté sur une cible*, pas d'un complot. Margot les voit en *vie quotidienne* — cf. mémoire `margot-terrain-neutre`.

> **Note de design #3 — Culture corpo vs cohabitation longue**. Chaque corpo a une culture d'entreprise qui pousse ses agents à refléter sa ligne (rivalités, coups bas accumulés, mépris hérité). **En vie quotidienne dans Saint-Michel** (les résidents y vivent depuis des mois), les liens personnels ont largement *dépassé* ces clivages — on partage les repas, on s'entraide, on parle. **Mais le travail réactive les rancœurs corpo** : dossier sensible, audit, demande hiérarchique, scan biométrique — et la ligne corpo revient à la surface chez l'agent. Margot doit lire ces *bascules contextuelles* : la même personne, chaleureuse au petit-déjeuner, peut devenir tranchante en réunion technique parce que le job réactive l'animosité Memorize/Stratom ou Kaizen/Nexus.

### MEMORIZE *(Bleu `#4a90d9`)*

**Domaine officiel** : Data · Mémoire numérique · IA prédictive
**Rôle Saint-Michel** : Coordinateur officiel du consortium. Vend ses modèles aux 3 autres. Contrôle le contrat de Margot (clause 12.1 : accès à ses rushes). Peut valider ou censurer son documentaire.

**Ce que Memorize couvre (zones grises — à valider)** : *(draft)* vente de profils intimes sans consentement explicite ; modèles prédictifs entraînés sur populations vulnérables (Sous-Paris) ; ventes croisées à régimes étrangers ou polices privées. La « clause 12.1 » est l'extension polie de cette logique : tout ce que Margot filme alimente le corpus.

**Agents résidents — leurs jobs (pas des missions)** :
- **Emma Castellane** : analyste flux Memorize. *Job ordinaire* = trier les flux internes de l'immeuble (filer les patterns à Memorize HQ). *Ambition personnelle* = montée hiérarchique sans casser le lien cousinal avec Margot.
- **Léo Mars** : designer interfaces de surveillance. *Job ordinaire* = améliorer la lisibilité des flux. *Ambition* (à préciser, thread ouvert) — surface esthétique sincère + agenda caché.

**Frictions** : tensions avec Stratom (contrôle prédictif vs coercitif), méfiance de Nexus (surveille l'éthique des prédictions).

**Pourquoi Memorize est dans Saint-Michel** : c'est la corpo qui *récolte la donnée brute* — l'expérience entière nourrit son cœur de métier. Si Saint-Michel se déploie sur Néo-Paris, Memorize devient l'opérateur de référence du contrôle urbain.

### KAIZEN *(Orange `#d9a44a`)*

**Domaine officiel** : Manufacturing · Performance · Optimisation comportementale
**Rôle Saint-Michel** : Fournit le modèle d'optimisation comportementale. Veut prouver que le contrôle social augmente la productivité. Audite les sous-performants. Marine (audit en cours, 45 k€ de dette) est leur plus gros risque d'effondrement *interne au projet*.

**Ce que Kaizen couvre (zones grises — à valider)** : *(draft)* exclusions silencieuses des sous-performants (licenciements présentés en démissions volontaires) ; pression psychologique encadrée comme « coaching » ; suicides post-audit non publiés (le cas Marine en construction). Le « crédit solidaire » est l'arme financière qui rend tout audit raté contagieux pour l'entourage.

**Agents résidents — leurs jobs (pas des missions)** :
- **Marine Dubois** : performeuse marketing 75 k abonnés. *Job ordinaire* = produire du contenu performant, faire bonne figure. *Ambition* = tenir jusqu'à l'audit (déni actif).
- **Thomas Renard** : ingénieur systèmes Kaizen. *Job ordinaire* = maintenir les infrastructures internes de l'immeuble. *Ambition* = aucune — l'épuisement a effacé l'ambition (vulnérabilité canon : peut révéler par fatigue).

**Frictions** : voit Memorize comme bavard et inefficace, méprise la philosophie éthique de Nexus.

**Pourquoi Kaizen est dans Saint-Michel** : ils fournissent la *métrique* (rendement, performance, conformité). Sans Kaizen, Nexus Social n'a pas de KPI vendable aux clients urbains.

### NEXUS *(Vert `#4ad97a`)*

**Domaine officiel** : Biotech · Augmentations · Éthique corporatiste
**Rôle Saint-Michel** : Caution éthique du projet. Collecte données biométriques via implants. Justifie la surveillance comme « protection ». Paradoxe canon : leur département éthique participe à l'expérience qu'il devrait dénoncer.

**Ce que Nexus couvre (zones grises — à valider)** : *(draft)* effets secondaires des implants neuronaux jamais publiés (cf. scan biométrique passif d'Alex — qui en porte la charge ?) ; **altération active des enregistrements biométriques** par Alex selon mission Nexus/Stratom (il *fait* la donnée qu'il transmet, ne se contente pas de la capter) ; validations éthiques internes payées d'avance pour passer ; études de population biométrique vendues sous label « santé publique ». L'éthique n'est pas mensongère, elle est *structurellement complice* (Sofia l'incarne : sincère + complice). Précision canon : Alex *ne* trafique *pas* pour Sofia — transparence totale dans le couple, il ne ferait pas ce qu'elle ignore.

**Agents résidents — leurs jobs (pas des missions)** :
- **Sofia Kessler** : département éthique Nexus. *Job ordinaire* = auditer le respect des chartes éthiques dans l'immeuble. *Ambition* = tenir la posture d'autorité éthique tout en sachant que Nexus exploite cette posture (cf. mémoire `sofia-kessler-caracterisation`).
- **Alex Norvège** : technicien cybernétique Nexus. *Job ordinaire* = maintenance implants, scan biométrique passif permanent. *Ambition* = survivre à sa double loyauté Nexus/Stratom — Sofia est sa faille émotionnelle.

**Pourquoi Nexus est dans Saint-Michel** : ils apportent la *légitimité* (le tampon éthique qui rend l'expérience défendable si jamais elle remonte). Et la *biométrie* (collecte passive). Sans Nexus, l'expérience est attaquable juridiquement et techniquement aveugle au corps.

### STRATOM *(Rouge `#d94a4a`)*

**Domaine officiel** : Sécurité · Opérationnel · Exécution coercitive
**Rôle Saint-Michel** : Le bras armé. Contrôle de l'Équipe Nettoyage, opérations terrain. Si Margot devient trop menaçante, Stratom agit (countdown 14 ticks). Handler de Frank.

**Ce que Stratom couvre (zones grises — à valider)** : *(draft)* disparitions de perturbateurs présentées comme suicides ou départs volontaires ; opérations off-the-books pour comptes corpos et régimes ; profilage prédictif (Camille) doublé d'élimination (Équipe Nettoyage). La frontière entre « sécurité » et « assassinat ciblé » est dans la main du handler de service.

**Agents résidents — leurs jobs (pas des missions)** :
- **Camille Armand** : profileuse psychologique Stratom. *Job ordinaire* = cartographier qui peut être manipulé/retourné/neutralisé. Margot est par défaut dans son périmètre. *Ambition* = monter dans Stratom (la séduction est outil pro, pas écart personnel — dark cogni-affectif, jamais physique).
- **Frank Dosière** : ex-opératif Stratom. *Job ordinaire actuel* = évaluer Margot pour Stratom (menace à neutraliser ou ressource à retourner). *Ambition latente* = recherche de rédemption (pas un objectif déclaré, vulnérabilité activable rétroactivement — cf. fiche Frank).

**Pourquoi Stratom est dans Saint-Michel** : ils sont la *menace de dernière instance*. Sans Stratom, l'expérience n'a aucun moyen d'action sur un perturbateur réel. Memorize prédit, Kaizen mesure, Nexus valide — Stratom *exécute*.

---

## 5. Personnage Joueur — Margot Sinclair

### Identité

- **Nom complet** : Margot Vanderberghe (nom de plume : **Sinclair**)
- **Âge** : 26 ans
- **Profession** : Journaliste culture/société freelance, documentariste
- **Lien** : Cousine germaine d'Emma Castellane — *éloignement vécu, pas généalogique* (brouille familiale ancienne ayant coupé les deux branches dans leur enfance ; reconnexion adulte tardive)
- **Situation** : Célibataire (rupture Julien, 3 mois)

### Intention initiale (canon)

Margot **a un passé d'investigation** — elle sait faire, elle a déjà fait. Elle n'est pas naïve techniquement. **Mais sur ce projet précis, son registre est sociologique** — curieusement, ce n'est pas son registre habituel. Elle vient documenter la cohabitation des 8 résidents, comprendre comment 4 corpos rivales font équipe au quotidien, restituer un portrait sociologique honnête. Démarche d'observation patiente — cinéma direct, sociologie observationnelle (Wiseman, Depardon).

**Double instrumentalisation Saint-Michel × Witness Networks** :
- **Les 4 corpos** misent que son documentaire restera au **niveau N2** (validation officielle « démonstration que les corpos peuvent œuvrer ensemble »). Son dossier de documentariste sociologue est compatible avec ce qu'elles veulent voir filmé.
- **Witness Networks** l'a peut-être envoyée *au casse-pipe* — commande sociologique officielle (compatible N2, vendable aux corpos) **+ espoir secret qu'elle déterre un scoop** grâce à ses compétences d'investigatrice. Witness joue les deux tableaux : si Margot tient le registre sociologique, ils ont un produit. Si elle déraille vers l'investigation, ils ont l'or.

Margot est donc l'**enjeu silencieux entre deux logiques** — sans nécessairement savoir qu'elle l'est au départ.

**Le glissement canon** : plus elle cherche à *comprendre* ce qu'elle a sous les yeux, plus elle se retrouve à savoir *plus qu'elle ne devrait*. L'information indésirable s'accumule **par effet de bord de l'attention soutenue**. Ses compétences d'investigatrice rendent le glissement *techniquement possible* — sans qu'il soit *intentionné* initialement. Sa question morale n'est pas « comment révéler ? » mais « qu'est-ce que je fais de ce que j'ai vu sans le chercher ? ». L'arme (option 5 des Stakes) est un *choix de fin* possible, jamais l'intention de départ.

**Conséquence d'écriture** : dans les premiers arcs (CP, PRO, A1), Margot ne traque pas activement. `evidence_collected` monte *en creux* par observation honnête. La bascule vers la traque délibérée (si elle a lieu) est un moment narratif explicite. La pression Witness peut être un déclencheur de cette bascule (Règle 2 — refusable, avec coûts contrat/PD/faction). Cf. mémoire `margot-documentariste-sincere`.

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

> **Note de design #4 — Agents importants, pas figurants** *(arbitrage 2026-05-21)*. Saint-Michel est un immeuble prestigieux dans une zone stratégique négociée. **Aucune corpo n'y enverrait des employés moyens.** Les 8 résidents sont des **agents importants avec des responsabilités significatives** dans leur corpo respective — leur présence à Saint-Michel est la preuve de leur poids interne. Marine n'est pas une influenceuse junior ; Thomas n'est pas un ingé subalterne ; Léo n'est pas un designer débutant ; Emma n'est pas une analyste de premier niveau ; et les 4 Tier 2 (Camille, Frank, Sofia, Alex) sont, eux, des cadres senior. **Tension à tenir en écriture** : si *fragiles* qu'ils puissent paraître sous le regard de leur vie quotidienne (couples en tension, dettes cachées, doubles loyautés, résignation, séduction-outil), ils ont un **travail important** avec un *vrai pouvoir d'action* (signer un contrat, autoriser un audit, débloquer un accès, ordonner une intervention). La fragilité visible cache la responsabilité — c'est précisément ce qui rend le portrait sociologique intéressant. Cf. mémoire `corpos-job-ordinaire`.

### Les 4 binômes corporatistes sont 4 couples réels

| Corpo | Couple | Statut conjugal (arbitrage 2026-05-21) |
|---|---|---|
| MEMORIZE | Emma × Léo | Couple intime acté — intimité audible la nuit |
| KAIZEN | Marine × Thomas | Couple en tension visible — dispute étouffée la nuit |
| NEXUS | Sofia × Alex | Couple actuel — conversation nocturne = confrontation éthique de couple |
| STRATOM | Camille × Frank | Couple réel mais glacial — silence nocturne par routine et contrôle mutuel |

**Conséquence design** : 6 PNJ sur 8 sont engagés intra-coliving. Toute romance Margot × PNJ_marié est une intrusion conjugale qui se lit en double-jeu (chaque PNJ a une raison propre de sortir de son couple via Margot). Référence : `overview.md`.

---

### Emma Castellane — *La cousine tiraillée* · MEMORIZE

**Tier 2 · Ally/Betrayer · 28 ans · Data Analyst**

**Cousine germaine de Margot, éloignement vécu** *(tranché 2026-05-21)* : leurs deux branches familiales ont été coupées par une brouille ancienne (cause exacte non tranchée — héritage, choix de vie, accident, conflit politique — variable libre). Peu de souvenirs partagés robustes : quelques événements familiaux résiduels (enterrement, mariage de civilité), pas de vacances communes. Reconnexion adulte tardive — Julien (l'ex de Margot) a été le catalyseur de cette reprise de contact (rencontré par Emma lors d'un de ces événements où les deux cousines se sont enfin reparlé). L'appel d'Emma à Saint-Michel est une **réparation de la brouille** : elle tend la main par-delà l'ancien conflit. Elle a placé Margot dans l'expérience — et s'en repent immédiatement. Tiraillée entre loyauté familiale et survie corporatiste.

**Power Tags** : `Accès flux Memorize` · `Connaissance du système interne` · `Liens familiaux activables`

**Weakness Tags** : `Culpabilité visible` · `Crédit solidaire = chantage permanent` · `Carrière vs famille`

**Spectre** : Alliée précieuse (canal d'info privilégié) ↔ Trahison forcée (rapport accablant remis à Memorize)

**Couple** : Emma × Léo — intimité audible, couple acté. Léo cultive une surface esthétique ; agenda réel caché qu'Emma ignore (à arbitrer).

**Lien mécanique** : Emma a connu Julien (pendant la phase de reconnexion adulte). Elle est la SEULE qui peut nommer le pattern à Margot avant qu'il soit trop tard — Julien est presque l'unique événement adulte partagé entre elles avant Saint-Michel, ce qui rend cette nomination doublement précieuse. La rendre muette = Margot perd sa boussole morale.

**A2-romance-emma — fusion-confusion non consommée** *(tranché 2026-05-21)* : pas un arc de drague (cf. [[pool-romance-pas-drague]]). L'absence d'histoire commune robuste rend les retrouvailles surchargées — chacune projette sur l'autre une intimité fantasmée, faute de barrières d'enfance ordinaires. L'ADN + culture + traumatismes générationnels les rendent troublantement similaires. La charge n'est *pas* franchie — pas par interdit moral (elles sont adultes, urbaines, post-conservatrices), mais par **bascule cognitive** : quand l'une se révèle pleinement à l'autre, l'évidence arrive que « ce n'est pas ça » — l'attraction se retraduit en « tu es ma moitié manquante biographique, pas mon amante ». Aucune variante FIN-E Emma ; les fins Emma sont fraternelles (pacte scellé, sacrifice, rupture). Écriture : pas de « tu te souviens quand on… » de complicité d'enfance ; l'intimité se construit *à* Saint-Michel.

> *« Tu es une variable de stress contrôlée. »* / *« Je ne sais plus si j'ai bien fait. »*

---

### Camille Armand — *La profileuse* · STRATOM

**Tier 3 · Attacker psychologique · 32 ans · Psychologue opérationnelle**

Chaleureuse en surface, redoutable en dessous. Profile Margot depuis leur première rencontre. Cliffhanger actif depuis Session 01.

**Power Tags** : `Profilage psychologique` · `Fausse intimité chaleureuse` · `Contrôle de la pièce par la voix` · `Réseau Stratom`

**Weakness Tags** : `Fascination pour Margot peut devenir obsession` · `Margot reconnaît ses techniques (trauma Julien)` · `Si démasquée, perd toute autorité morale`

**Spectre** : Neutre (observe, collecte) ↔ Hostile (utilise le profil contre Margot, alimente countdown Équipe Nettoyage)

**Couple** : Camille × Frank — couple réel mais glacial. Aucun son la nuit. Chacun lit l'autre en permanence (profileuse + ex-opératif), intimité fossilisée.

**Romance Margot × Camille — registre** : *dark cogni-affectif* (manipulation, asymétrie d'information, mots qui déstabilisent). Pas d'emprise corporelle, pas de sexualisation explicite. Le « dark » est dans le profilage.

> *« Oh ! On a de la visite ! »* / *« Parle-nous un peu de toi. Tu viens d'où ? »*

---

### Frank Dosière — *Le test* · STRATOM

**Tier 3 · Threat/Protector (spectre fluide) · 42 ans · Ex-opératif**

Homme de peu de mots. Positionnement tactique permanent. Il teste Margot pour décider si elle mérite protection ou élimination. Cherche la rédemption.

**Power Tags** : `Fluidité militaire` · `Position tactique permanente` · `Handler de l'Équipe Nettoyage`

**Weakness Tags** : `Cherche la rédemption` · `Fatigué du système qu'il sert` · `Le test = Margot peut le réussir ou l'échouer`

**Countdown attaché** : Équipe Nettoyage Stratom (14 ticks). Avance via Personal-Danger ↑ ou alertes sécurité. Recule via tests d'intégrité réussis.

**Spectre** : Allié protecteur ↔ Hostile (déclenche le countdown)

**Couple** : Camille × Frank — voir fiche Camille. Couple réel mais glacial.

**Verdict canon** : la mission active de Frank est **d'évaluer Margot pour Stratom** (menace à neutraliser ou ressource à retourner). La « recherche de rédemption » mentionnée plus haut est latente — pas un objectif déclaré, mais une vulnérabilité que l'intégrité de Margot peut activer rétroactivement (cf. FIN-E Frank : *« il y a longtemps que je cherchais quelqu'un d'assez intègre pour mériter ça »*).

> *« Filme tout. Pas juste ce qui arrange ton narratif. »* / *« On verra. »*

---

### Sofia Kessler — *La vigilante éthique* · NEXUS

**Tier 2 · Watcher éthique · 28 ans · Département éthique Nexus · femme trans**

Sincère dans ses convictions, mais structurellement complice du système qu'elle prétend surveiller. Paradoxe incarné.

**Power Tags** : `Autorité éthique reconnue` · `Lecture rapide des contrats` · `Alliance tacite avec Frank`

**Weakness Tags** : `Travaille pour ceux qui violent l'éthique` · `Mission "éthique" est elle-même corporatiste`

**Spectre** : Alliée (expose les abus avec Margot) ↔ Hostile (dénonce Margot à Nexus pour violation éthique)

**Couple** : Sofia × Alex — couple solide, démonstratif en public, transparent. Asymétrie *fonctionnelle* (Sofia tient le symbolique éthique, Alex tient l'opérationnel sale), pas affective : ils s'aiment, point. Alex est partie de ce qui rend possible son intégration en milieu corpo conservateur (femme trans avec un partenaire qui assume publiquement le couple). **Sa force pro ≠ sa force intime** : autorité tenue en posture éthique au travail, plus exposée en intimité — une blessure intime ne peut pas être affrontée en posture d'autorité. La conversation nocturne `a1_nuit.dtl` (history.md L262) est intime de couple, traversée d'une tension éthique en sous-texte mais le registre dominant est le couple, pas la confrontation. L'« alliance tacite avec Frank » est professionnelle/éthique, parallèle au couple, n'entre pas en collision avec lui.

**Identité trans** : Sofia est femme trans. Cette identité est **connue de tous les résidents depuis longtemps, intégrée, jamais le sujet d'une scène**. Pronoms `elle` par défaut, vocabulaire actuel, pas d'outing ni de révélation. Référence d'écriture : mémoire `sofia-kessler-caracterisation`.

> *« J'aimerais voir le contrat. »* / *« Je vais probablement voir tes rushes. Pas pour censurer. »*

---

### Marine Dubois — *La performeuse au bord du gouffre* · KAIZEN

**Tier 2 · Countdown (Audit) · 26 ans · Marketing digital**

75k abonnés. Enthousiasme contagieux, sourire crispé. Cache 45k€ de dette. Audit Kaizen imminent. Si elle tombe, tout l'immeuble s'effondre via cascade crédit solidaire.

**Power Tags** : `Réseau influenceuse 75k` · `Enthousiasme contagieux performé` · `Acceptée par tous`

**Weakness Tags** : `45k€ de dette cachée` · `Sourire crispé sous pression` · `Audit Kaizen (15 ticks)`

**Countdown attaché** : Audit Marine (15 ticks). Avance via échec social, critique publique. À 0 : licenciement → cascade crédit solidaire → tout l'immeuble s'effondre.

**Piège Margot** : si Margot *expose* Marine pour gagner Evidence-Collected, elle déclenche la cascade entière.

**Couple** : Marine × Thomas — couple en tension visible. Dispute étouffée audible la nuit. La dette 45 k€ + la résignation de Thomas sont la double faille du binôme. La « rupture visible » est condition canon de FIN-E Thomas (history.md L787).

> *« Oh ! La journaliste ! Bienvenue, bienvenue ! »* / *« C'est super excitant ! »*

---

### Alex Norvège — *Le double agent* · NEXUS → STRATOM

**Tier 2 · Watcher/Double Agent · 29 ans · Technicien cybernétique**

Implants neuronaux. Scan biométrique passif permanent. Officiellement Nexus. Réellement : taupe Stratom. **Se salit les mains pour la corpo sans hésiter** — altération active des enregistrements biométriques selon mission. Sofia est sa raison de tenir.

**Power Tags** : `Scan biométrique passif via implants` · `Flux d'info Nexus + Stratom` · `Peut altérer les enregistrements biométriques`

**Weakness Tags** : `Triple loyauté impossible` · `Si démasqué, perd les trois soutiens` · `Sofia est sa raison de tenir — toute menace contre elle peut le faire basculer`

**Spectre** : Allié improbable (retournement contre Stratom) ↔ Hostile (alimente countdown Équipe Nettoyage avec ses scans)

**Couple** : Alex × Sofia — couple solide, démonstratif, **transparent**. Alex assume publiquement le couple ; il protège Sofia si nécessaire mais **jamais dans son dos** (pas de stalker bienveillant). Asymétrie fonctionnelle uniquement : Alex tient le terrain sale, Sofia tient le symbolique éthique. Aucune asymétrie affective. **Condition canon d'un retournement contre Stratom** *(tranché 2026-05-21)* : décision de couple — Sofia & Alex basculent ensemble face à une menace partagée. **Branche optionnelle B** : si Margot pousse Alex à la trahison via choix joueur explicite à point de bascule (verrou EV ≥ 4 + flag), Alex bascule seul, effondré, et Sofia est très blessée *en intimité* (pas en posture pro — cf. design-rule Sofia § force pro ≠ force intime).

---

### Léo Mars — *Le saboteur silencieux* · MEMORIZE

**Tier 1 · Neutral/Saboteur · 30 ans · Designer interfaces — Cible d'alliance prioritaire**

Sabote les systèmes Memorize par lassitude esthétique, pas par idéologie. Détaché, donc imprévisible. Clé pour l'accès aux flux vidéo existants.

**Power Tags** : `Accès design des systèmes de surveillance` · `Peut créer des angles morts` · `Autorité technique reconnue`

**Weakness Tags** : `Aucune cause militante (sabote par lassitude)` · `Emma le surveille`

**Spectre** : Neutre (observe sans agir) ↔ Allié technique (partage l'accès aux flux vidéo si Margot propose un sabotage stylé)

**Couple** : Léo × Emma — couple Memorize. Surface esthétique sincère (Léo apprécie réellement Emma sur le plan formel) mais Emma le surveille (cf. Weakness Tag), et Léo porte un agenda caché à préciser en arc-spec. Le couple fonctionne comme observation mutuelle silencieuse plus que comme intimité. La faille est cognitive : Léo sait que sa surface ne convaincra pas indéfiniment.

> *« Accord de transparence inter-corporatiste. »* / *« Du moment que tu floutes mon écran. »*

---

### Thomas Renard — *Le résigné* · KAIZEN

**Tier 1 · Neutral/Resigned · 29 ans · Ingénieur systèmes**

Épuisé chronique. Cynisme absolu. Aucun investissement émotionnel. Peut révéler par pure fatigue ce qu'il devrait taire.

**Power Tags** : `Connaissance des systèmes Kaizen` · `Invisibilité par épuisement` · `Cynisme désarmant`

**Weakness Tags** : `Épuisé` · `Peut révéler par fatigue ce qu'il devrait taire`

**Spectre** : Allié passif (témoignage involontaire) ↔ Neutre (par défaut)

**Couple** : Thomas × Marine — couple en tension visible. Dispute étouffée la nuit. Thomas, résigné, encaisse en silence la performance de Marine et la dette 45 k€ qui menace tout l'immeuble. La « rupture visible » du couple est condition canon de FIN-E Thomas (history.md L787) — c'est par la fissure conjugale que Thomas devient accessible romance Margot.

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