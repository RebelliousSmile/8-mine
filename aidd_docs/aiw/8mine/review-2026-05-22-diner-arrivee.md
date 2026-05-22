# Review consolidée — `diner_arrivee.dtl`

**Date** : 2026-05-22
**Source `.dtl`** : `dialogic/timelines/diner_arrivee.dtl`
**Scene-spec** : `aidd_docs/memory/external/scenes/diner_arrivee.md`
**PNJ-behaviors chargés** : les 8 fiches *(via `pnjs-behavior/_index.md`)*
**Personas appliqués** : 4 *(dramaturge v1.1 · playtester-lgbtqia · playtester-visual-novel v1.1 · playtester-cyberpunk v1.1)*

---

## Synthèse globale

| Persona | Score | Triage |
|---------|-------|--------|
| **Dramaturge v1.1** | **18.5/20** | 🟢 patchable |
| **Playtester LGBTQIA+** | **17.5/20** | 🟢 *(sous réserve clarification Julien/Julie)* |
| **Playtester Visual Novel** | **17/20** | 🟡 *(saturation menu sujets + ref PRO-02 manquante)* |
| **Playtester Cyberpunk** | **18/20** | 🟢 |
| **Moyenne** | **17.75/20** | 🟢-🟡 |

**Verdict global** : `.dtl` solide, prêt à passer en production *(création .tscn manuelle dans Godot Editor)* après 3 corrections mineures *(toutes 🟡)*. Aucun bloquant 🔴 détecté.

---

## 1) Persona Dramaturge v1.1 — Cohérence structurelle

**Score : Précond 17/20 · Postcond 19/20 · Scope 20/20 · Verrous 19/20 · Fins 18/20 · Présence+Seuils 19/20 — Global 18.5/20**

### Vérifications

✅ **Préconditions** : `{emma_prenom}` posé par PRO-01 (canon), routing post A1-01-* documenté en commentaire. **-3 sur Précond** : préconditions documentées en commentaire mais pas testées explicitement via `{if {flag_a1_01_micro_passe}}` au début du `.dtl`. Repose sur le routing amont — acceptable mais moins robuste qu'un test explicite.

✅ **Postconditions** : `flag_diner_presentation_choisie` posé dans les 4 branches (lignes 50, 63, 76, 108). `flag_diner_arrivee_consomme` posé en sortie (270). Tous flags subbranches `flag_diner_presentation_<A/B/C/D>` cohérents.

✅ **Scope jauges** : aucune jauge hors-scope touchée. `mirror`, `surveillance`, `countdown:*` jamais émis *(vérifié par audit auditeur-scene précédent, confirmé)*. **20/20.**

✅ **Verrous canon** : les 8 PNJs respectent leurs verrous *(re-vérifiés contre les 8 fiches pnj-behavior maintenant disponibles)*. **-1 sur Verrous** : Emma à Neutre dans `demander_role` étend le résumé scene-spec — *« dashboards qui ressemblent à des fonds marins »* dépasse *« réponse courte, formelle »*. Expansion acceptable côté voix Emma (canon `pnj-behavior:emma` voix Méfiance/Neutre = *« polie distante, formelles corpo »*), mais marge d'interprétation.

✅ **Fins** : pas de fin orpheline ouverte. Pas de fin canon fermée par erreur. **-2 sur Fins** : le `.dtl` ne déclare aucun impact explicite sur les 9 fins — c'est cohérent pour un premier dîner, mais le commentaire de tête pourrait noter *« Pas d'impact direct sur les fins ; ouvertures différées via flags posés »*.

✅ **Présence + seuils** : exception canon premier dîner respectée *(pas de bloc résolution)*. `event_camille_cliffhanger` correctement guardé one-shot via `flag_event_camille_cliffhanger_consomme`.

### Risques structurels (avocat du diable)

1. **Routing post A1-01-* non testé** : si un futur fix de routing amont casse les flags `flag_a1_01_*`, le `.dtl` ne le détecte pas. Mitigation : ajouter en tête `{if not (flag_a1_01_micro_passe or ...)}` → push_warning.

2. **Emma palier Confident jamais déclencheur ici** : la condition ligne 131 inclut Favorable-Fusionnel, mais Emma au premier dîner est canoniquement à Neutre par défaut. Si conditions amont (A1-01-confrontation [A]) ont posé `flag_emma_guide=true`, le palier est-il *vraiment* à Favorable+ ? **Vérifier qu'un palier ne saute pas Neutre→Allié** sans Favorable intermédiaire en `RelationManager`.

3. **`flag_camille_attend_meilleure_occasion`** posé en branche `[B]` outro — non documenté dans `scene-spec` ni consommé en aval visible. Risque flag orphelin. Mitigation : documenter dans `scenes/_index.md` ou dans `pnj-behavior:camille`.

**Triage : 🟢 patchable** — 3 fixes ciblés via `write-scene --feedback`.

---

## 2) Persona Playtester LGBTQIA+ — Sensitivity

**Score : Neutralité 16/20 · Représentation 19/20 · Désir 18/20 · Vocabulaire 19/20 · Mécanique 18/20 — Global 17.5/20**

### Verbatims problématiques

> *« Quelqu'un — Julien. Julie. C'est selon les jours. »* *(ligne 53)*
>
> **À interroger** : c'est la première fois que `Julien/Julie` apparaît dans cette scène. Le prénom est-il géré par `ExProfileManager` *(via `{ex_prenom}`)* ou hardcodé ? Si Margot dit *« Julien »* + *« Julie »* selon que le joueur a choisi homme/femme/non-binaire pour son ex via PRO-01, c'est **excellent**. Si c'est hardcodé pour évoquer une *ambivalence canonique* de l'ex *(non-binaire / fluide)*, c'est **acceptable** mais doit être documenté comme canon `ExProfileManager` immutable. *Cf. `pnj-behavior:emma § Verrou Julien` et `ExProfileManager`*. Risque : si pronom du genre de l'ex est hardcodé ailleurs, incohérence.

> *« Sofia te regarde droit dans les yeux, sans appuyer. »* + *« Merci de l'avoir dit ici. Pas obligée. »* *(lignes 56-57)*
>
> ✅ **Modèle**. Sofia respecte verrou canon *force pro ≠ force intime* : elle est en posture éthique pro *(audit de Margot en train de se présenter)*, sans glissement intime. Identité trans **jamais évoquée**, intégrée. Conforme `sofia-kessler-caracterisation.md` axe 1.

> *« Camille consulte sa tablette une seconde de trop. »* *(ligne 226)*
>
> ✅ **Détail canon Camille** *(dark cogni-affectif jamais physique)*. Le profilage passe par les mots et la tablette, pas par l'emprise corporelle. Conforme `pnj-behavior:camille` verrou 1.

### Faiblesses

1. **Pronom Julien/Julie** : à clarifier. Si `ExProfileManager` pilote, c'est résolu ; sinon, bug pronom hardcodé. Test : créer un nouveau personnage avec ex non-binaire en PRO-01, jouer `diner_arrivee [A]`, vérifier l'affichage.

2. **Aucun positif explicite sur la diversité** des résidents *(Sofia trans, possiblement d'autres orientations non documentées)*. Acceptable car canon = *« jamais sujet de scène »*, mais cela signifie aussi que le joueur ne reçoit aucun *signal* que l'immeuble est queer-inclusive. Risque : un joueur·euse queer pourrait douter de la position du jeu sur la représentation. **Mitigation** : pas dans ce `.dtl`, mais à surveiller globalement *(une scène A1/A2 pourrait poser le sujet ambiance, ex. un PNJ secondaire de l'immeuble avec ex de tout genre cité)*.

3. **Mécanique inclusive** : choix `[C]` mensonge mediacorp gated par `FLAG_MOTIVATION ∈ {argent, carriere}`. Risque que les motivations `relations` et `militante` *(plus stéréotypées queer/féminines ?)* soient privées d'option stratégique. Vérifier que les motivations `relations`/`militante` ont des compensations stratégiques équivalentes ailleurs.

### Apprentissages possibles pour 8-MINE

- Pour atteindre le niveau de *True Colors*, 8-MINE pourrait : ajouter un échange anodin entre 2 résidents *(Sofia/Alex)* qui *normalise* leur intimité par un détail quotidien *(un geste, une mention de soirée commune)* — sans en faire un sujet.
- Pour atteindre le niveau de *Tell Me Why*, 8-MINE pourrait : documenter explicitement *(en commentaire `.dtl`)* la résolution de `{ex_prenom}` pour rendre auditable la cohérence pronoms.

**Triage : 🟢** *(sous réserve clarification Julien/Julie)*

---

## 3) Persona Playtester Visual Novel v1.1 — Narratif

**Score : Choix 18/20 · PNJ mémoire 14/20 · Pacing 16/20 · Sous-texte 19/20 · Voix Margot 18/20 · Cyberpunk 18/20 — Global 17/20**

### Ce qui marche

> *« Tu reconnais le ton. Le ton « je-sais-ce-que-je-fais-et-ne-pose-pas-de-questions ». Il marche, en général. Pas toujours ici. »* *(ligne 68)*
>
> ✅ **Voix Margot reconnaissable**. C'est exactement le grain narrator italique qu'on cherche — pensée interne, observatrice, ironique sans amertume. Comparable au travail de la voix Harry dans *Disco Elysium* *(skill checks internes qui commentent les choix)* mais plus sobre, plus journalistique. *Excellent.*

> *« Sourire crispé. Elle attend ta réaction. »* *(ligne 152, Marine)*
>
> ✅ **Sous-texte canon**. Marine ne dit pas *« je suis stressée »*, le sourire crispé le dit. Comparable au travail de *Pentiment* où les expressions des PNJ portent plus que les dialogues.

> *« Camille consulte sa tablette une seconde de trop. »* *(ligne 226)*
>
> ✅ **Détail sensoriel qui travaille narrativement**. *« Une seconde de trop »* est précisément le type d'observation qu'un VN sait faire et qu'un autre média (cinéma, série) couperait. Référence : *Pentiment*, *Norco*.

### Faiblesses

1. **8 sujets *« Demander à X »* simultanés dans le menu** *(lignes 129-194)* = **saturation visuelle**. Le joueur voit 8 options + Witness + Observer = 10 boutons. Comparaison : *Disco Elysium* regroupe les *« skill checks »* via un menu hiérarchique ; *Pentiment* limite à 3-4 options visibles. Mitigation : transformer en sous-menu *« Demander à quelqu'un »* puis sélection du PNJ, OU déclencher les 8 sujets via interaction directe avec le portrait du PNJ *(point-and-click sur sprite)*.

2. **Aucun PNJ ne référence un choix de PRO-02** *(micros posés ou non)*. Le `.dtl` traite le dîner comme une scène indépendante, sans mémoire des choix amont. Comparaison : *LiS* — Chloé fait des références constantes aux choix passés de Max, c'est ce qui donne le poids aux choix. **Mitigation suggérée** : Emma (qui a alerté Margot) pourrait poser une question discrète conditionnée à `flag_micros_poses` *(« Tu as bien installé ce qu'il fallait ? »* — code privé entre cousines)*. Hook pour la prochaine itération.

3. **Choix `[C]` mensonge — feedback échec partiel**. Sofia démasque *« Lead européen, vraiment ? »* mais le joueur ne sait pas *quand* exactement Sofia a vérifié. Risque *« choix-décor »* perçu : pour le joueur, le mensonge peut paraître arbitraire si la mécanique de vérification cachée n'est pas signalée. Mitigation : narrator italique pourrait dire *« Sofia repose sa fourchette plus tôt que prévu. Tu reconnais le geste — quelqu'un qui vient de vérifier quelque chose. »*

### Apprentissages possibles pour 8-MINE

- Pour atteindre le niveau de *LiS True Colors*, 8-MINE pourrait : faire référencer **explicitement** au moins un choix PRO-02 par un PNJ au dîner *(canal Emma, signal discret)*. La mémoire active des PNJ est *le* différenciateur narratif des bons VN.
- Pour atteindre le niveau de *Pentiment* / *Disco Elysium*, regrouper les 8 sujets *« Demander à X »* en sous-menu hiérarchique pour éviter la saturation menu de 10 boutons.
- Pour atteindre *Norco* (sous-texte par environnement), ajouter un signal visuel/sonore à la vérification cachée Sofia *(narrator italique « Sofia repose sa fourchette plus tôt »)* — le sous-texte mécanique se rend lisible sans surexpliquer.

**Triage : 🟡 corrections mineures** — saturation menu + référence PRO-02 + feedback mensonge.

---

## 4) Persona Playtester Cyberpunk v1.1 — Worldbuilding

**Score : Worldbuilding 17/20 · Corpos 20/20 · Surveillance 18/20 · Augmentations 14/20 · Anti-jargon 20/20 · Intime 19/20 — Global 18/20**

### Ce qui marche

> *« Memorize et Kaizen à sa gauche. Nexus et Stratom à sa droite. La géométrie compte ici. Elle le sait sans qu'on le lui ait dit. »* *(ligne 34)*
>
> ✅ **Worldbuilding par géométrie sociale**. C'est très Gibson : *« the street finds its own uses for things »* — Margot lit l'espace social comme un opérateur. La phrase pose les 4 corpos comme **forces structurelles** sans exposition. Comparable à *Cyberpunk 2077* District-by-District lecture, mais en intérieur, plus subtil.

> *« Design d'interfaces. Memorize. Ce que tu vois quand tu vois rien. »* *(Léo, ligne 143)*
>
> ✅ **Phrase qui dit le monde en passant**. Très Cadigan (*Synners*) : la corpo se définit par ce qu'elle *cache*, pas par ce qu'elle montre. Une seule réplique pose la philosophie design Memorize. *Standard cyberpunk littéraire atteint.*

> *« Profilage comportemental, Stratom. Je lis les gens. »* + *« Et toi tu écris sur les gens. On a peut-être des choses à se dire. »* *(Camille, lignes 183-184)*
>
> ✅ **Cyberpunk de l'intime via le profilage**. Camille pose la *parenté méthodologique* avec Margot — *toutes deux observent les gens, mais pour des fins opposées*. C'est exactement la tension cyberpunk qu'on veut entre la journaliste et la psychologue corporatiste. *Très Citizen Sleeper / Deus Ex MD niveau écriture.*

### Faiblesses

1. **Stratification Néo-Paris N1/N2/N3 absente** dans cette scène. Premier dîner intérieur, justifiable canoniquement *(scène contenue dans Saint-Michel = N2 vitrine)*, mais une **micro-référence environnementale** *(vue par la baie sur les couches inférieures Sous-Paris ?)* renforcerait la stratification ressentie. Comparaison : *Deus Ex MD Praha* — chaque scène intérieure montre par une fenêtre ou un détail visuel que d'autres quartiers existent. Mitigation : ajouter une ligne narrator *« Pluie dehors sur la baie. Quelque part en bas, les canaux. »* en intro.

2. **Augmentations Alex mentionnées sans coût visible** *(ligne 175 : « Implants, scan biométrique, ce genre »)*. Alex *décrit* son travail mais ne *porte* pas le coût visiblement. Comparaison : *Deus Ex MD* — Adam Jensen a des tics nerveux liés à ses augmentations, *Cyberpunk 2077* — V a des effets visibles de cyberware. Pour atteindre ce niveau, ajouter un détail Alex *(clignement plus lent, pause avant chaque réplique pour traiter, etc.)*. **-6 sur Augmentations**.

3. **Surveillance vécue mais pas montée d'un cran narratif**. La lumière qui baisse *« sans qu'on s'en aperçoive »* (ligne 268) est canonique — surveillance comme oxygène. Mais aucun moment où la surveillance *devient sensible* dans la scène *(une caméra qui pivote au plafond ?)*. Comparaison : *Citizen Sleeper* — les caméras existent *partout*, et un moment de scène les fait remarquer par un détail. Mitigation optionnelle, pas critique.

### Apprentissages possibles pour 8-MINE

- Pour atteindre *Neuromancien* niveau worldbuilding, ajouter **une phrase d'ambiance environnementale** en intro qui *dit Néo-Paris* *(« Pluie dehors sur la baie. Plus bas, les canaux. »)*. Une seule phrase suffit.
- Pour atteindre *Deus Ex MD* niveau augmentations, ajouter **un tic Alex** *(pause cognitive, regard vers Sofia avant chaque réplique technique)*. Le scan biométrique permanent doit *peser*.
- Pour atteindre *Citizen Sleeper* niveau surveillance, ajouter **un moment où la surveillance devient sensible** *(une caméra qui s'oriente vers Margot pendant qu'elle observe le silence)*. Pas suspense, mais *présence*.

**Triage : 🟢** *(20/20 sur corpos distinctes + anti-jargon — bench cyberpunk atteint)*

---

## Synthèse des corrections suggérées

### 🔴 Bloquantes : aucune.

### 🟡 Corrections mineures (priorité haute)

1. **[VN]** Saturation menu 8 sujets *« Demander à X »* → regrouper en sous-menu hiérarchique
2. **[VN]** Aucune référence PRO-02 *(micros)* par un PNJ → ajouter signal Emma conditionnel à `flag_micros_poses`
3. **[LGBTQIA+]** Clarifier la résolution de `Julien/Julie` *(ExProfileManager piloté vs hardcodé canon ex non-binaire)*

### 🟢 Améliorations possibles (priorité basse)

4. **[Dramaturge]** Ajouter un test explicit du routing amont *(`{if not (flag_a1_01_*)}`)* en tête
5. **[Dramaturge]** Documenter `flag_camille_attend_meilleure_occasion` dans `pnj-behavior:camille` *(consommateur aval)*
6. **[VN]** Ajouter signal visuel à la vérification cachée Sofia *(« repose sa fourchette plus tôt »)*
7. **[Cyberpunk]** Micro-référence environnementale stratification *(« pluie dehors. Plus bas, les canaux. »)*
8. **[Cyberpunk]** Tic Alex sur scan biométrique permanent *(pause cognitive, etc.)*

### Apprentissages transversaux

- **Force partagée des 4 reviews** : voix Margot reconnaissable, sous-texte travaillé, 8 corpos distinctes par le vocabulaire. Le `.dtl` atteint des standards cyberpunk + VN sur ces axes.
- **Faiblesse partagée des 4 reviews** : pas assez de *mémoire active des PNJ* face aux choix amont *(PRO-02 spécifiquement)*. Hook pour `pnj-behavior` futur ?

---

## Recommandation finale

`.dtl` **prêt pour création `.tscn` manuelle** dans Godot Editor *(suite du pipeline export)*. Les 3 corrections 🟡 sont à appliquer via **un seul `write-scene --feedback`** *(consolidées en un passage)*. Les 5 améliorations 🟢 peuvent être différées à une itération ultérieure ou intégrées au moment de la production des `pnj-behavior` futurs *(notamment référence PRO-02 → hook canal Emma à documenter)*.

Score global **17.75/20** — **🟢-🟡**. Production canon de qualité validée par 4 reviewers complémentaires.
