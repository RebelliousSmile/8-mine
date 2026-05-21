# 8-MINE — Design Narratif : Arborescence des scènes
> Document de référence narrative — game designer + Claude Code
> Chaque nœud correspond à une scène ou un groupe de dialogues dans Dialogic 2.
> Conventions : NODE [ID] → fichier `.dtl` · FLAG_XXX → variable dans `GameStateManager.gd`
> Variables de progression : EV (Evidence 0-6) · PD (Personal-Danger 0-6) · MS (Mental-Stability 0-6)

---

## CONVENTIONS DE LECTURE

```
◆ NODE [ID] — Titre
  📍 Acte · position dans le chapitre
  [NAV] Nœud navigable — scène .tscn avec hotspots actifs
  🔓 Condition d'accès (variable ou flag requis)
  ⚡ Effets à l'entrée (variables modifiées)
  [A][B][C][D] Choix joueur → cible
  🔒 Condition pour que ce choix soit disponible
  🗝 Ouvre : scènes ou options débloquées
  🚪 Ferme : scènes ou options verrouillées définitivement
  🗺 Hotspots avec conséquence narrative (détail complet → fichier de scène)
```

**Relation PNJ** : score −100 à +100 géré par `RelationManager.gd`
Seuils visibles pour le joueur : Méfiance · Neutre · Sympathie · Confiance · Intime
**Countdowns** : gérés par `CountdownManager.gd` — avancent automatiquement entre les scènes
**[NAV]** : scène navigable en point-and-click. Hotspots sans effet narratif → fichier de scène uniquement. Hotspots avec effet sur flags/variables → aussi signalés ici sous `🗺`.

---

## CRÉATION DE PERSONNAGE

### ◆ NODE [CP-01] — Motivation de départ
> Écran de choix avant le prologue. Détermine le fil thématique de Margot.
> Fichier Dialogic : `cp_motivation.dtl`

```
[A] Reconstruire ma carrière après la rupture
    → Thème : ambition vs reconstruction
    → FLAG_MOTIVATION = "carriere"
    → Dialogue coloré : priorité pro sur l'humain visible dans les choix

[B] Comprendre comment fonctionnent les vraies relations
    → Thème : curiosité vs voyeurisme
    → FLAG_MOTIVATION = "relations"
    → Dialogue coloré : questions plus personnelles, empathie plus forte

[C] Exposer les abus corporatistes
    → Thème : idéalisme vs compromis
    → FLAG_MOTIVATION = "militante"
    → Dialogue coloré : colère sous-jacente, prises de position plus directes

[D] Par nécessité financière pure
    → Thème : pragmatisme vs éthique
    → FLAG_MOTIVATION = "argent"
    → Dialogue coloré : calcul coût/bénéfice visible, détachement affiché

⟹ tous → NODE [PRO-01]
```

> Note : le genre de Julien/Julie est révélé naturellement dans un dialogue de l'Acte I
> (premier moment où Margot en parle) — pas un écran de configuration.

---

## PROLOGUE

### ◆ NODE [PRO-01] — Arrivée à Saint-Michel [NAV]
> Scène d'ouverture. Narration visuelle + dialogue Emma dans l'ascenseur.
> 📍 Prologue · Scène 1
> Fichier Dialogic : `pro_arrivee.dtl`
> Scène Godot : `scenes/prologue/pro_arrivee.tscn` (orchestre Scènes 1→4)
> Assets requis : `bg_tramway_jour.jpg` · `bg_hall_tour.jpg` · `bg_ascenseur.jpg` · `char_emma_*.png`
> Détail hotspots → `pro_arrivee.md`

🗺 Hotspots à conséquence narrative :
  → [zone_commune_frank_sofia] Aperçu Frank & Sofia · toujours · déclenche voix Emma "les plus dangereux"

```
⚡ MS = 3 · PD = 0 · EV = 0 (valeurs initiales)
⚡ Countdowns activés : Équipe_Nettoyage = 14 · Audit_Marine = 15

Emma dans l'ascenseur — révélation :
  "Tu es une variable de stress contrôlée."
  Programme Nexus Social · crédit solidaire 25 ans · 4 corporations
  → FLAG_EMMA_A_REVEELE = true

Première vue sur Frank et Sofia en Zone Commune.
Emma (voix basse) : "Les plus dangereux."

⟹ NODE [PRO-02]
```

### ◆ NODE [PRO-02] — La Cellule : premier choix [NAV]
> Margot seule dans sa chambre. Matériel de surveillance posé sur le lit.
> Question fondatrice du jeu : est-ce qu'elle reproduit Julien/Julie ?
> 📍 Prologue · Scène 1.1
> Fichier Dialogic : `pro_cellule.dtl`
> Scène Godot : `scenes/prologue/pro_cellule.tscn`
> Assets requis : `bg_cellule_margot_jour.jpg` · `ui_materiel_surveillance.png`
> Détail hotspots → `pro_cellule.md`

🗺 Hotspots à conséquence narrative :
  → [materiel_surveillance] Valise ouverte · toujours · déclenche le choix [A/B/C/D]
  → [fenetre_vue_immeuble] Vue sur les étages · toujours · examine-text (pas d'effet variable)

```
[A] Installer les micros en Zone Commune
    ⚡ FLAG_MICROS_POSES = true · PD +1 · MS −1
    🗝 Accès aux conversations nocturnes (NODE [A1-05] version enrichie)
    🚪 Ferme FIN-F et FIN-A définitivement
    ⟹ NODE [A1-01-micro]

[B] Refuser. Documentaire éthique malgré tout.
    ⚡ FLAG_MICROS_POSES = false · MS +1
    🗝 FIN-F et FIN-A restent accessibles
    🗝 Option de dialogue Frank "intégrité" débloquée en Acte II
    ⟹ NODE [A1-01-ethique]

[C] Confronter Emma maintenant, avant le dîner
    ⚡ FLAG_CONFRONTATION_EMMA_PRECOCE = true
    ⟹ NODE [A1-01-confrontation] — Appartement Emma/Léo

[D] Accepter le rôle et l'utiliser consciemment
    ⚡ FLAG_STRATEGIE_MIROIR = true · PD +1
    🗝 Options de dialogue "miroir" débloquées en Acte I
    ⟹ NODE [A1-01-stratege]
```

---

## ACTE I — L'OBSERVATRICE

### ◆ NODE [A1-01-micro] — Avant le dîner : micros posés
> Margot sort poser un micro. 17 caméras. Tension.
> Fichier Dialogic : `a1_micro_pose.dtl`

```
RÉUSSITE (variable cachée basée sur PD actuel)
    → FLAG_MICROS_DISCRETS = true
    ⟹ NODE [A1-03]

RÉUSSITE PARTIELLE
    → FLAG_MICROS_DISCRETS = false · FLAG_SOFIA_SUSPECTE = true · PD +1
    ⟹ NODE [A1-03]

ÉCHEC (PD ≥ 3 au moment du jet)
    → FLAG_MICROS_DECOUVERTS = true · PD +2
    → Relation tous PNJs −15 pour les 2 prochaines scènes
    ⟹ NODE [A1-03] (atmosphère dégradée)
```

### ◆ NODE [A1-01-ethique] — Avant le dîner : décision assumée
> Margot range le matériel. Prépare sa caméra visible, son contrat, son carnet.
> Fichier Dialogic : `a1_decision_ethique.dtl`
> ⟹ NODE [A1-03]

### ◆ NODE [A1-01-confrontation] — Appartement Emma/Léo
> Léo présent, discret. Emma révèle tout en détail : le dossier psy, le Ghost Market.
> Fichier Dialogic : `a1_confrontation_emma.dtl`
> Assets requis : `bg_appart_emma_leo.png` · `char_leo_*.png`

```
[A] "Aide-moi. Dis-moi comment survivre ici."
    → Relation Emma +20 · FLAG_EMMA_GUIDE = true
    🗝 Emma envoie des alertes discrètes dès l'Acte II
    ⟹ NODE [A1-03]

[B] "Je comprends ta position, mais ne compte pas sur ma sympathie."
    → Relation Emma neutre
    ⟹ NODE [A1-03]

[C] "Tu es exactement comme eux."
    → Relation Emma −20 · PD +2
    🚪 Ferme FIN-A et FIN-B (Emma requiert relation > +50)
    ⟹ NODE [A1-03]

[D] "Montre-moi tout ce que tu sais sur les autres résidents."
    → EV +1 · Relation Emma +10 · MS −1
    🗝 Options de dialogue ciblées débloquées dès le dîner
    ⟹ NODE [A1-03]
```

### ◆ NODE [A1-01-stratege] — Avant le dîner : acceptation stratégique
> Margot note sa stratégie dans son carnet. Lucidité froide.
> Fichier Dialogic : `a1_stratege.dtl`
> ⟹ NODE [A1-03]

---

### ◆ NODE [A1-03] — Dîner collectif : les huit *(convergence)* [NAV]
> Présentation officielle. Premier vrai contact avec tous les résidents.
> 📍 Acte I · Scène 1.3
> Fichier Dialogic : `a1_diner.dtl`
> Scène Godot : `scenes/acte1/a1_diner.tscn`
> Assets requis : `bg_zone_commune_soir.jpg` · tous les `char_[pnj]_*.png`
> ✅ SCÈNE JOUÉE EN PLAYTEST (2025-11-21)
> Détail hotspots → fichier de scène à créer (`a1_diner.md`)

🗺 Hotspots à conséquence narrative :
  → [place_table_margot] Position à table · toujours · ancre la mise en scène (Margot entre les deux blocs)
  → [pnj_*] Chaque résident · toujours · dialogue court avant présentation officielle

```
Comment Margot se présente-t-elle ?

[A] Honnêteté complète : parler de Julien/Julie et de la reconstruction
    → Relation Sofia +10 · Relation Frank neutre (note la vulnérabilité)
    → FLAG_CAMILLE_PROFIL_TRAUMA = true ⚠ (Camille recueille ce trauma)
    → MS +1 (dire la vérité allège)
    🗝 Dialogue profond Sofia débloqué dès l'Acte II

[B] Professionnalisme strict : documentaire sur le coliving
    → Tous PNJs neutre · FLAG_MARINE_VEUT_COUVERTURE = true

[C] Mensonge valorisant : grande mediacorp
    🔒 Disponible uniquement si FLAG_MOTIVATION = "argent" ou "carriere"
    → Vérification cachée : Sofia a accès à toutes les productions Witness
    RÉUSSITE → Relation Marine +15 · respect général +5
    ÉCHEC → Relation Sofia −20 · FLAG_MENTEUSE_DEMASQUEE = true · PD +1

[D] Transparence technique : contrat + droit de veto + caméra visible
    → Relation Frank +10 · Relation Sofia +5
    → EV +0 mais légitimité documentaire établie
    [CHOIX JOUÉ EN PLAYTEST]

⚡ Après le choix de présentation → scènes courtes avec chaque PNJ
⚡ Léo confirme (quelle que soit la présentation) : accès croisé des 4 corpos aux flux vidéo

⟹ NODE [A1-04]
```

### ◆ NODE [A1-04] — Cliffhanger Camille ⏸
> "Parle-nous un peu de toi. Tu viens d'où ?"
> Question anodine. Profilage en cours. La scène se fige.
> 📍 Acte I · Scène 1.3 (fin) · **Point de reprise playtest suivant**
> Fichier Dialogic : `a1_camille_question.dtl`

```
[A] Réponse standard professionnelle
    → Relation Camille neutre · FLAG_CAMILLE_PROFIL_PARTIEL = true

[B] Partager le trauma Julien/Julie
    → Relation Camille +15 (fausse intimité)
    → FLAG_CAMILLE_PROFIL_TRAUMA = true ⚠
    → MS −1 (Camille utilise exactement les techniques de Julien/Julie)

[C] Retourner la question sur Camille
    🔒 Disponible si MS ≥ 3
    → Relation Camille −5 · FLAG_CAMILLE_DEMASQUEE_PRECOCE = true
    🗝 Option "jouer le jeu en le sachant" débloquée en Acte II

[D] Observer le groupe sans répondre directement
    → EV +1 (dynamique de groupe lue) · Relation Camille neutre (frustrée)

⟹ tous → NODE [A1-05]
```

### ◆ NODE [A1-05] — Première nuit : bruits de l'immeuble
> 23h. Cellule. Sons qui filtrent à travers les murs.
> Marine/Thomas : dispute étouffée. Emma/Léo : intimité audible.
> Sofia/Alex : conversation intense à voix basse. Camille/Frank : silence total.
> Fichier Dialogic : `a1_nuit.dtl`
> Assets requis : `bg_cellule_margot_nuit.png` · ambiance sonore

```
[A] Écouter activement et noter
    🔒 Si FLAG_MICROS_POSES = true → flux audio clair, pas de vérification
    🔒 Si FLAG_MICROS_POSES = false → vérification cachée (PD actuel)
    → EV +1 · MS −1 (trigger voyeurisme)

[B] Mettre des écouteurs, ne pas écouter
    → MS +1
    🗝 Maintient FIN-F et FIN-A accessibles

[C] Écouter sans documenter, juste comprendre
    → Vérification cachée (relation avec les PNJs entendus)
    RÉUSSITE → compréhension des dynamiques · MS neutre
    ÉCHEC → fragments confus · MS neutre · EV +0

[D] Descendre croiser quelqu'un d'encore éveillé
    → Vérification cachée (PD actuel + relation avec le PNJ rencontré)
    RÉUSSITE → Rencontre nocturne avec Frank, Thomas ou Léo (selon relations actuelles)
               Relation [PNJ] +10 · FLAG_RENCONTRE_NOCTURNE_[PNJ] = true
    ÉCHEC → Alerte caméra · PD +1

⟹ NODE [A1-06]
```

### ◆ NODE [A1-06] — Fin Acte I : choix d'approche
> Jour 2, matin. Margot a un plan. Quelle alliance en premier ?
> Fichier Dialogic : `a1_plan.dtl`

```
[A] Approcher Léo (accès aux flux vidéo)
    ⟹ NODE [A2-01A]

[B] Approfondir le lien avec Emma (canal d'information)
    ⟹ NODE [A2-01B]

[C] Observer Marine et Thomas (levier du crédit solidaire)
    ⟹ NODE [A2-01C]

[D] Tester Sofia (alliance éthique)
    ⟹ NODE [A2-01D]
```

---

## ACTE II — SURVEILLANCE

### ◆ NODE [A2-01A] — Alliance Léo : accès aux flux vidéo
> Léo est un saboteur discret. Il a créé des angles morts dans la surveillance.
> Fichier Dialogic : `a2_leo_alliance.dtl`

```
🔓 Relation Léo ≥ 0

Vérification cachée (relation + FLAG_MOTIVATION)

RÉUSSITE
    → Léo donne accès aux flux existants · EV +2 · Relation Léo +20
    → FLAG_ACCES_FLUX_LEO = true
    🗝 NODE [A2-03] — Première preuve solide

RÉUSSITE PARTIELLE
    → Léo veut quelque chose en échange (choix) :
    [a] Aider Léo à créer un angle mort supplémentaire
        → FLAG_ANGLE_MORT_LEO = true · EV +1
    [b] Couvrir sa relation avec Emma (il la trompe ?)
        → MS −1 si Margot accepte · EV +1

ÉCHEC
    → Relation Léo neutre · FLAG_LEO_MEFIANT = true
    → Retour vers NODE [A1-06]
```

### ◆ NODE [A2-01B] — Alliance Emma : canal d'information
> Emma peut couvrir Margot dans les rapports Memorize — au risque de sa propre carrière.
> Fichier Dialogic : `a2_emma_alliance.dtl`
> 🔓 Relation Emma ≥ +10

```
Si FLAG_EMMA_GUIDE = true → scène plus longue, info sans vérification
Si FLAG_EMMA_GUIDE = false → vérification cachée (relation Emma)

Emma révèle :
  — La dette exacte de Marine (45k€) → EV +1
  — Alex est un double agent Stratom → FLAG_ALEX_DOUBLE_AGENT = true · EV +1
  — Le vrai nom du Programme : "Synergie Quadri-Corp / Nexus Social Phase 2"

Risque systémique :
  Si Margot utilise cette info → FLAG_EMMA_EXPOSEE = true
  → Memorize peut détecter la fuite → Audit Emma possible
```

### ◆ NODE [A2-01C] — Arc Marine : la dette et le crédit solidaire
> Marine est le maillon faible. Audit Kaizen en cours (Countdown = 15).
> Fichier Dialogic : `a2_marine_dette.dtl`

```
[A] L'aider discrètement (sans exposer sa dette)
    → Relation Marine +20 · Countdown Audit_Marine −2
    → FLAG_MARINE_ALLIEE = true
    🗝 Marine comme alliée (info sur Thomas) · FIN-E romance Marine accessible

[B] Documenter la dette sans exposer
    → EV +1 · Relation Marine neutre
    🗝 Levier utilisable en Acte III

[C] Menacer d'exposer pour obtenir des informations
    → EV +2 · MS −2 · Countdown Equipe_Nettoyage +1
    🚪 Ferme FIN-F et FIN-A
    → FLAG_MARINE_ENNEMIE = true
```

### ◆ NODE [A2-01D] — Alliance Sofia : la vigilante éthique
> Sofia sait que l'expérience est contraire à l'éthique — et est structurellement complice.
> Fichier Dialogic : `a2_sofia_alliance.dtl`
> 🔓 Relation Sofia ≥ +5

```
Sofia teste Margot sur ses méthodes avant de parler.

[A] Répondre avec intégrité sur ses propres limites
    → Relation Sofia +20 · FLAG_SOFIA_ALLIEE = true · EV +1
    🗝 Sofia peut bloquer un rapport Memorize en Acte III
    🗝 FIN-E romance Sofia accessible si relation > +50

[B] Défense de la liberté de la presse
    → Relation Sofia +5 · EV +1

[C] Esquiver la question
    → FLAG_SOFIA_SUSPECTE_METHODES = true
    🚪 Ferme l'alliance profonde avec Sofia
```

---

### ◆ NODE [A2-02] — Pression Witness Networks *(convergence, déclenchée automatiquement)*
> Margot reçoit un message de sa rédaction. "On a besoin de sensationnel."
> Fichier Dialogic : `a2_witness_pression.dtl`
> ⚡ Déclenché automatiquement quand EV ≥ 1 ET aucun rush envoyé depuis 7 jours in-game

```
[A] Envoyer un rush "propre" (ce que Margot peut assumer)
    → Relation Witness −10 · pression monte
    🗝 Maintient FIN-F et FIN-A accessibles

[B] Envoyer un rush sensationnel (Marine ou Thomas partiellement exposés)
    → Relation Witness +10 · Relation [PNJ exposé] −15
    → MS −1 si le PNJ exposé était en confiance
    → Commence à fermer les fins "intègres"

[C] Ignorer Witness Networks
    → FLAG_WITNESS_SILENCIEUX = true
    🗝 Déclenche NODE [A3-witness] automatiquement en Acte III
```

### ◆ NODE [A2-03] — Première preuve solide *(convergence)*
> EV = 3. Le Programme est documentable. Camille remarque que quelque chose a changé.
> Fichier Dialogic : `a2_premiere_preuve.dtl`
> ⚡ Countdown Equipe_Nettoyage +1 automatique (rapport Camille transmis)

```
Camille entre : "Tu sembles plus... déterminée, ces derniers jours."

Si relation [PNJ romantique potentiel] ≥ +30 → FLAG_ROMANCE_POSSIBLE = true
  → Choix : activer l'arc romance ou continuer sans
  ⟹ NODE [A2-04] (romance, optionnel)
  OU
⟹ NODE [A2-05] (confrontation Camille)
```

### ◆ NODE [A2-04] — Arc romance *(optionnel, LGBTQIA+ friendly)*
> 📍 Acte II · Semaine 2-3
> Un seul arc romance par run — le premier PNJ à atteindre relation ≥ +30 avec le bon flag.
> Fichier Dialogic : `a2_romance_[pnj].dtl` (un fichier par PNJ)

```
FRANK — "Le Protecteur"
  🔓 Relation Frank ≥ +30 · FLAG_RENCONTRE_NOCTURNE_FRANK = true ou ≥ 2 tests intégrité réussis
  Arc : Frank voit quelqu'un d'assez intègre pour mériter sa protection.
        La proximité devient quelque chose d'autre — ni analysé ni nommé.
  → Aide Fin E : dossier Stratom interne + blocage administratif de l'Équipe Nettoyage
  ⟹ NODE [A2-04F]

THOMAS — "Le Désabusé"
  🔓 Relation Thomas ≥ +30 · Marine/Thomas ont eu une scène de tension visible
  Arc : Thomas croit que tout le monde finit par trahir.
        Margot teste cette conviction jusqu'au bout.
  → Aide Fin E : données Kaizen internes pour sauver Marine sans l'exposer
  ⟹ NODE [A2-04T]

SOFIA — "La Vigilante"
  🔓 Relation Sofia ≥ +50 · FLAG_SOFIA_ALLIEE = true
  Arc : Deux femmes qui observent le même système depuis des angles opposés.
        La confiance se construit sur l'éthique avant d'aller ailleurs.
  → Aide Fin E : dossier complet comité éthique Nexus
  ⟹ NODE [A2-04S]

MARINE — "La Performeuse"
  🔓 Relation Marine ≥ +40 · FLAG_MARINE_ALLIEE = true
  Arc : Derrière 75 000 abonnés il y a quelqu'un qui s'est perdu dedans.
        Margot voit Marine sans le filtre. Marine n'a pas l'habitude.
  → Aide Fin E : livestream impromptu qui craque en direct — aide chaotique et décisive
  ⟹ NODE [A2-04M]

CAMILLE — "La Dangereuse"
  🔓 Relation Camille ≥ +40 · FLAG_CAMILLE_FASCINATION = true
  Arc : Camille a profilé tout le monde sauf quelqu'un qui résiste.
        Fascination professionnelle → obsession → quelque chose d'innommable.
  ⚠ Dark romance : oscille entre genuinement touchant et instrumental.
  → Aide Fin E : Camille sabote son propre rapport à Stratom
  ⟹ NODE [A2-04C]
```

### ◆ NODE [A2-05] — Confrontation Camille
> Camille a presque complété son profil sur Margot.
> Fichier Dialogic : `a2_confrontation_camille.dtl`

```
[A] Jouer l'intimité feinte — donner ce qu'elle cherche
    → Relation Camille +15 · MS −1
    → FLAG_CAMILLE_PROFIL_COMPLET = true
    → Countdown Equipe_Nettoyage +2

[B] Nommer explicitement le profilage en face
    🔒 Vérification cachée (relation Camille + MS actuel)
    RÉUSSITE → FLAG_CAMILLE_DEMASQUEE = true · Countdown −1
               Relation Camille −10 · FLAG_CAMILLE_FASCINATION = true
    ÉCHEC → MS −1 · PD +1 (Camille a retourné l'accusation)

[C] Transmettre l'info à Sofia
    🔓 FLAG_SOFIA_ALLIEE = true
    → Relation Sofia +10 · Countdown −2

[D] Observer, laisser Camille croire qu'elle gagne
    → EV +1 (techniques de profilage documentées)
    → Countdown +1 automatique
```

### ◆ NODE [A2-06] — Révélation Alex
> Alex est un double agent Stratom infiltré chez Nexus.
> Fichier Dialogic : `a2_revelation_alex.dtl`

```
Margot découvre via :
  — Emma (si FLAG_EMMA_GUIDE = true) → Emma exposée en retour
  — Léo (si FLAG_ACCES_FLUX_LEO = true) → footage Alex/Frank en discussion
  — Sofia directement (si relation > +50) → Sofia le sait, ne sait pas quoi faire

[A] Exposer Alex immédiatement à Sofia
    → FLAG_ALEX_EXPOSE = true · Relation Sofia +15 · Relation Alex −30 · PD +1
    🗝 Alex peut déclencher l'Équipe Nettoyage par réaction

[B] Garder l'info comme levier
    → EV +2 · FLAG_LEVIER_ALEX = true
    🗝 Option chantage soft en Acte III

[C] Continuer à documenter sans agir
    → EV +1 · PD +1 passif (Alex continue à scanner Margot)
```

---

## ACTE III — CONFRONTATION

### ◆ NODE [A3-01] — Verdict Frank *(nœud critique)*
> Frank a observé Margot depuis le début. Il rend son verdict.
> 📍 Acte III · Semaine 3
> Fichier Dialogic : `a3_verdict_frank.dtl`
> ⚡ Déclenché automatiquement quand Countdown Equipe_Nettoyage ≤ 7

```
ALLIÉ (Margot a prouvé son intégrité ≥ 3 fois)
    → "J'ai dit 'on verra'. J'ai vu."
    → FLAG_FRANK_ALLIE = true · Countdown suspendu
    🗝 FIN-E romance Frank · aide décisive Acte IV

NEUTRE (intégrité ambiguë)
    → "Je ne peux pas te protéger. Mais je ne t'empêcherai pas non plus."
    → FLAG_FRANK_NEUTRE = true · Countdown continue

HOSTILE (PD ≥ 4 ou trop de transgressions)
    → Countdown à 0 immédiat
    ⟹ NODE [FIN-H]
```

### ◆ NODE [A3-02] — Emma sous pression : la trahison possible
> Memorize a détecté des fuites. Emma est convoquée.
> Fichier Dialogic : `a3_emma_pression.dtl`
> ⚡ Déclenché si FLAG_EMMA_EXPOSEE = true OU EV ≥ 4

```
Emma : "Ils m'ont donné un choix : produire un rapport accablant sur toi,
        ou perdre mon poste."

[A] "Sauve-toi. Produis le rapport."
    → FLAG_EMMA_SAUVEE = true · Relation Emma +25
    → Margot perd l'accès aux flux Memorize (EV −1) · PD +2
    🗝 FIN-A et FIN-B accessibles (Emma hors de danger)

[B] "Reste. Je vais trouver une autre façon."
    → Emma reste sous surveillance maximale · FLAG_EMMA_RISQUE = true
    → Margot doit construire une preuve en urgence

[C] Utiliser Emma comme écran pour sortir les dernières preuves
    → EV +2 · FLAG_EMMA_SACRIFIEE = true · MS −2
    🚪 Ferme FIN-A et FIN-B
    🗝 Ouvre FIN-C
```

### ◆ NODE [A3-C] — Branche Mains Propres
> Margot arrive en Acte III avec EV 4-5, toutes les preuves construites proprement.
> Fichier Dialogic : `a3_mains_propres.dtl`
> 🔓 FLAG_MICROS_POSES = false · MS ≥ 5

```
⚡ FLAG_MAINS_PROPRES = true
🗝 FIN-F directement accessible
⟹ NODE [A4-01]
```

### ◆ NODE [A3-witness] — Witness Networks lâche
> Déclenché automatiquement si Margot a trop déçu ou ignoré la rédaction.
> ⚡ Déclenché si EV < 4 ET Witness Networks relation < 0
> Fichier Dialogic : `a3_witness_lache.dtl`

```
Message : "Votre position a été communiquée à nos partenaires de sécurité."
→ FLAG_WITNESS_VENDU = true · PD +3 · Countdown +3

Si aucune alliance → ⟹ NODE [FIN-G]
Si relation [PNJ] ≥ +50 → ⟹ NODE [A4-01] (fragile mais possible)
```

---

## ACTE IV — DÉNOUEMENT

### ◆ NODE [A4-01] — La Grande Révélation : quel vecteur ? *(convergence)*
> EV ≥ 3. Il est temps. Mais comment faire sortir ça ?
> 📍 Acte IV · Semaine 4
> Fichier Dialogic : `a4_revelation_choix.dtl`

```
[A] Publication via Witness Networks (si encore allié)
    🔓 Relation Witness ≥ 0
    → EV 6 ⟹ FIN-B ou FIN-A selon Emma et MS
    → EV 4-5 ⟹ FIN-F

[B] Deal avec une corpo contre les trois autres
    🔓 Relation Sofia > +60 OU Relation Léo/Emma > +60
    → FLAG_DEAL_CORPO = true
    ⟹ NODE [FIN-D]

[C] Aide d'un PNJ romance
    🔓 FLAG_ROMANCE_ACTIF = true · Relation [PNJ] ≥ +60
    ⟹ NODE [FIN-E]

[D] Partir sans publier
    → EV < 4 ou décision active de silence
    ⟹ NODE [FIN-G] ou [FIN-H] selon PD
```

### ◆ NODE [A4-02] — Mode Montage : quelle version publier ?
> Margot a ses rushes. Elle choisit ce qui sort.
> 📍 Acte IV · Scène décisive unique
> Fichier Dialogic : `a4_montage.dtl`

```
[A] Version brute — tout, sans montage
    → EV utilisé au maximum · tous les PNJs concernés exposés
    → MS −1 (Margot se voit dans la caméra — a-t-elle le droit ?)
    🗝 FIN-B (victoire, dégâts collatéraux)

[B] Version sélective — protéger certaines personnes
    → EV −1 · MS neutre
    🗝 FIN-A ou FIN-B selon Emma et MS

[C] Version arrangée — minimiser les dégâts d'Emma
    → EV −2
    → MS −1 si Margot reconnaît qu'elle manipule l'information
    → MS +1 si elle l'assume consciemment comme protection
    🗝 FIN-A maintenu si MS ≥ 5

[D] Ne rien publier
    ⟹ FIN-G ou FIN-I selon MS
```

---

## FINS

> Les fins ne s'annoncent pas. Elles arrivent comme des conséquences logiques.
> Chaque fin est un nœud terminal avec ses conditions, son récit et ce qu'elle dit thématiquement.

### Carte des fins

```
                EV = 6          EV = 4-5        EV = 3-5        EV < 4
MS = 6        FIN-A
MS = 3-5      FIN-B
MS = 2-4      FIN-C            FIN-D
MS ≥ 5                         FIN-F
Romance                                         FIN-E
Silence                                                          FIN-G

MS = 0    ──── FIN-I (indépendant de EV)
PD = 6    ──── FIN-H (indépendant de EV)
```

---

### ◆ NODE [FIN-A] — "La Reconstruction" ★★★★★
*~5% des runs · La fin la plus difficile*

```
CONDITIONS
  EV = 6/6
  MS = 6/6
  FLAG_EMMA_SACRIFIEE = false
  FLAG_MICROS_POSES = false
  Relation Emma > +50
  0 trigger interne activé (5/5 évités)
```

Le documentaire sort. Le Programme est stoppé. Emma s'en sort. Margot aussi — intacte. Elle n'a reproduit aucun pattern de Julien/Julie. Elle a fait du journalisme en restant elle-même. La fin ne se célèbre pas : elle se vit, simplement, comme quelque chose qui méritait d'être.

**Romance possible** (non requise) : n'importe quel PNJ — ajoute une scène de départ ou de séparation consciente.

*Ce que ça dit : Que c'était possible. Que ça exigeait de ne jamais tricher.*

---

### ◆ NODE [FIN-B] — "L'Exposé" ★★★★
*~25% des runs · Fin principale*

```
CONDITIONS
  EV = 6/6
  MS ≥ 3/6
  Relation Emma > +50
  Au moins un allié actif (Frank / Léo / Sofia)
```

Le documentaire sort. Witness Networks diffuse. Une enquête médiatique s'ouvre. Le déploiement est suspendu. Emma est protégée ou en fuite couverte. Margot rentre chez elle. Quelque chose a changé — en elle et dans la ville.

**Variantes** : Emma protégée (rare) · Emma en fuite couverte par Léo · avec ou sans romance.

*Ce que ça dit : Que certaines victoires ont un coût. Que c'est quand même une victoire.*

---

### ◆ NODE [FIN-C] — "Le Pacte de Sang" ★★★
*~10% des runs · Fin famille, sombre*

```
CONDITIONS
  EV = 6/6
  FLAG_EMMA_SACRIFIEE = true
  MS = 2/6 à 4/6
  Relation Emma entre −25 et +50
```

Le documentaire sort parce qu'Emma a tout pris. Renvoyée. Crédit solidaire déclenché pour elle seule. Deep-Paris. 200 000 crédits de dette. Margot le savait. Elle a publié quand même. Le documentaire existe. Emma n'a plus d'appartement.

**Variante MS = 2** : Margot attend. Le documentaire sort des mois plus tard, depuis une autre ville. Emma est déjà en Deep-Paris.

*Ce que ça dit : Que la vérité peut détruire ceux qu'on aime. Le jeu ne juge pas. Il enregistre.*

---

### ◆ NODE [FIN-D] — "L'Alliance Corporate" ★★★
*~10% des runs · Fin compromis politique*

```
CONDITIONS
  EV = 4/6 à 5/6
  FLAG_DEAL_CORPO = true
  Relation Sofia > +60 OU Relation Léo/Emma > +60
  ≥ 1 trigger interne activé
  MS = 2/6 à 4/6
```

Margot a fait un deal. Une corpo l'aide à sortir les preuves sur les trois autres en échange d'une immunité médiatique. Le Programme est restructuré au profit d'une seule corpo. Margot survit. Elle a choisi un système contre un autre. Elle le sait.

**Variante Nexus** : Sofia propose. Nexus sort "blanc". Rapport éthique publié.
**Variante Memorize** : Léo propose. Memorize sort "blanc". Emma est protégée.

*Ce que ça dit : Que la frontière entre journalisme et communication est plus mince qu'on ne le croit.*

---

### ◆ NODE [FIN-E] — "La Romance comme Sortie de Secours" ★★★★
*~15% des runs · LGBTQIA+ friendly · 5 variantes*

```
CONDITIONS COMMUNES
  EV = 3/6 à 5/6
  FLAG_ROMANCE_ACTIF = true
  Relation [PNJ romantique] ≥ +60
  MS ≥ 3/6
```

Margot n'a pas toutes les preuves. Mais un PNJ fait quelque chose d'inattendu — quelque chose qu'il/elle ne ferait pour personne d'autre. Le documentaire sort incomplet. Le Programme est fragilisé, pas stoppé. Margot part — avec quelqu'un, ou seule mais transformée.

*Ce que ça dit : Que les relations humaines peuvent être la chose la plus subversive dans un système de contrôle.*

---

**FIN-E · FRANK — "Le Verdict final"**
```
🔓 Relation Frank ≥ +60 · FLAG_FRANK_ALLIE = true · ≥ 2 tests intégrité réussis
```
Frank donne le dossier Stratom interne sur l'Équipe Nettoyage. Il déclenche lui-même une alerte administrative qui bloque l'intervention. Sa carrière Stratom est finie.

*"J'ai dit 'on verra'. Il y a longtemps que je cherchais quelqu'un d'assez intègre pour mériter ça."*

**Ton : grave, tendre, irréversible.**

---

**FIN-E · THOMAS — "La Révélation"**
```
🔓 Relation Thomas ≥ +60 · Marine/Thomas : rupture visible · MS ≥ 3
```
Thomas donne les données Kaizen internes sur la dette de Marine — pour la sauver sans l'exposer. Il a arrêté de croire que rien ne change. C'est Margot qui l'a fait changer d'avis.

*"Je pensais que t'étais comme tous les autres. T'étais là pour prendre."*

**Ton : mélancolique, doux, réel.**

---

**FIN-E · SOFIA — "L'Acte éthique"**
```
🔓 Relation Sofia ≥ +60 · FLAG_SOFIA_ALLIEE = true
```
Sofia transmet le dossier complet du comité éthique Nexus — preuve que le département éthique a validé l'expérience en connaissance de cause. Le scandale éthique est plus dévastateur que le scandale technique.

*"J'aurais dû faire ça depuis le début. Je t'attendais peut-être."*

**Ton : intellectuel, ancré, précis.**

---

**FIN-E · MARINE — "Le Livestream"**
```
🔓 Relation Marine ≥ +60 · FLAG_MARINE_ALLIEE = true · Countdown Audit_Marine ≤ 5
```
Marine craque en direct devant ses 75 000 abonnés. Elle parle de sa dette, du Programme, des caméras. Chaotique, imparfait, incontrôlable. La chose la plus vraie qu'elle ait jamais dite.

*"Je sais même plus qui j'étais avant cet immeuble."*

**Ton : urgent, fragile, vivant.**

---

**FIN-E · CAMILLE — "La Trahison de l'Analyste"**
```
🔓 Relation Camille ≥ +60 · FLAG_CAMILLE_FASCINATION = true · FLAG_CAMILLE_DEMASQUEE = true
```
Camille sabote son propre rapport à Stratom. Elle ne peut pas l'expliquer rationnellement.

*"Je t'ai profilée depuis le début. Ce que j'ai trouvé, c'est que tu étais réelle. C'est plus rare que tu ne le crois."*

**Ton : ambigu, dangereux, étrange.**

---

### ◆ NODE [FIN-F] — "Les Mains Propres" ★★★★
*~10% des runs · Fin intègre, victoire partielle*

```
CONDITIONS
  EV = 4/6 à 5/6
  MS ≥ 5/6
  FLAG_MICROS_POSES = false
  0 trigger interne activé
  FLAG_MAINS_PROPRES = true
```

Margot publie ce qu'elle peut assumer. Pas assez pour stopper le Programme — assez pour planter une fracture. Une enquête parlementaire est demandée. Le déploiement est retardé. Elle n'est pas devenue Julien/Julie. Elle rentre les mains vides et les mains propres.

*Ce que ça dit : Que l'intégrité a un coût réel. Que "assez bien" peut être la victoire disponible.*

---

### ◆ NODE [FIN-G] — "Le Silence" ★★
*~10% des runs · Fin passive*

```
CONDITIONS
  EV < 4/6
  FLAG_WITNESS_VENDU = true
  Toutes les relations < +40
```

Witness Networks a vendu sa position. Margot part — vivante, non exposée. Le Programme se déploie. Dans six ans, tout Néo-Paris fonctionnera comme l'immeuble Saint-Michel. Elle le sait. Elle s'en va quand même.

*Ce que ça dit : Que l'inaction est aussi un choix. Que survivre n'est pas suffisant.*

---

### ◆ NODE [FIN-H] — "La Capture" ★
*~5% des runs · Game over physique*

```
CONDITIONS
  PD = 6/6
  Countdown Equipe_Nettoyage = 0
  FLAG_FRANK_ALLIE = false
  Verdict Frank = hostile
```

Countdown à 0. L'Équipe Nettoyage est là. Ce qu'ils font à Margot n'est pas montré. Une porte qui se ferme. Un noir. Un silence. Le Programme continue.

*Ce que ça dit : Que le système a gagné. Que ce n'était pas inévitable.*

---

### ◆ NODE [FIN-I] — "Julien" ★★
*~10% des runs · Game over thématique*

```
CONDITIONS
  MS = 0/6
  5/5 triggers internes activés
  (Indépendant de EV — peut survenir même si EV = 6)
```

Margot a le documentaire. Elle a les preuves. Mais en regardant ses rushes dans la cellule, elle se voit. Elle voit Julien/Julie. Elle voit ce qu'elle est devenue. Elle publie — ou pas. Peu importe.

**Variante haute EV** : Margot publie un documentaire brillant. L'exposé est une réussite totale. Ce qui rentre chez elle n'est plus tout à fait Margot Sinclair.

*Ce que ça dit : Que devenir ce qu'on déteste est possible. Que ça arrive progressivement. Que chaque étape semblait raisonnable sur le moment.*

---

*Document vivant · dernière mise à jour après playtest du 2025-11-21*
*Prochaine étape : écrire les fichiers `.dtl` de l'Acte I (scènes non encore scriptées)*

---

## NOTES DE PLAYTEST — observations narratives

> Retours sur ce qui fonctionne / ce qui est à ajuster dans l'écriture.
> Retours mécaniques et de production → `etat-prod.md`.

### Playtest 01 — 2025-11-21

**Ce qui fonctionne**
- Révélation Emma dans l'ascenseur : ton juste, rythme bon. La formule "variable de stress contrôlée" frappe bien.
- Dilemme des micros (PRO-02) : ressenti immédiatement sans explication. La voix de la psy comme mécanisme intérieur est efficace.
- Présentation à table (A1-03) : chaque PNJ réagit distinctement — pas de masse informe. Sofia / Frank / Marine sonnent tous différemment.
- Camille en cliffhanger : la question anodine comme fin de scène crée une vraie tension.
- La description de Néo-Paris stratifiée établit le monde sans exposition maladroite.

**À ajuster**
- PRO-02 (cellule) : un peu long — resserrer d'un tiers.
- Emma disant "fais attention à Frank et Sofia, ce sont les plus dangereux" : trop explicite. Reformuler en signal plus subtil.
- Position de table en A1-03 (Margot entre les deux blocs) : involontaire dans le playtest, à ancrer comme décision de mise en scène dans le `.dtl`.

**Threads narratifs ouverts à résoudre avant d'écrire A1-05 à A2-01**
- Que cachent Sofia et Alex dans leur conversation nocturne ? ("expériences continuent" — c'est quoi, exactement ?)
- Comment signaler subtilement que Frank cherche quelqu'un à protéger, sans le dire ?
- Léo "saboteur discret" selon Emma — quel est son agenda réel, et comment Margot le découvre-t-elle organiquement ?
- Marine et sa dette 45k€ — quand et par quel canal la révéler au joueur ?
- Camille et Frank : aucun son la nuit de leur côté — couple de façade, ou autre chose ? À décider avant d'écrire leurs arcs.