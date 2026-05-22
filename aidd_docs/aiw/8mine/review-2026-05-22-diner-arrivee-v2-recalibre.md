# Review consolidée — `diner_arrivee.dtl` *(v2 après recalibration)*

**Date** : 2026-05-22 (passe 2)
**Personas appliqués** : 4 *(dramaturge v1.1+anchors · playtester-lgbtqia+anchors · playtester-visual-novel v1.1+anchors · playtester-cyberpunk v1.1+anchors)*
**Changement clé** : application des **`scoring_anchors`** ancrés + **tags sévérité par finding** + **règles de plafond automatique**.

---

## Synthèse — avant vs après recalibration

| Persona | v1 *(2026-05-22 matin)* | v2 *(recalibré)* | Delta | Note |
|---------|--------------------------|-------------------|-------|------|
| Dramaturge | 18.5/20 🟢 | **15/20 🟡** | **−3.5** | Plafond 17 enclenché *(seulement 🟡 mineurs)* + un 🟠 majeur redécouvert *(scope jauges complet ?)* |
| Playtester LGBTQIA+ | 17.5/20 🟢 | **14/20 🟡** | **−3.5** | Plafond 14 enclenché *(1 🟠 majeur sur pronom Julien/Julie)* |
| Playtester Visual Novel | 17/20 🟡 | **13/20 🟡** | **−4** | Plafond 14 enclenché *(2 🟠 majeurs : saturation menu + amnésie PNJ PRO-02)* |
| Playtester Cyberpunk | 18/20 🟢 | **14/20 🟡** | **−4** | Plafond 14 enclenché *(1 🟠 majeur sur augmentations sans coût)* |
| **Moyenne** | **17.75/20 🟢-🟡** | **14/20 🟡** | **−3.75** | Concordance maintenue mais à un niveau plus crédible |

**Verdict révisé** : `.dtl` de qualité **moyenne-correcte** *(14/20)*, **patchable** mais avec **3 fixes structurels** *(🟠 majeurs)* à appliquer avant `.tscn` Godot, pas seulement du polish.

---

## 1) Dramaturge v1.1 + anchors — Recalibration

**Score : Précond 14/20 *(ancrage 14 : « 1-2 violations mineures »)* · Postcond 17/20 · Scope 14/20 *(🟠 majeur découvert)* · Verrous 17/20 · Fins 17/20 · Présence+Seuils 17/20 — Global 15/20 🟡**

### Recherche active déclarée

- ✅ Grep des `[signal arg="<jauge>:`*  vérifié contre scope déclaré scene-spec
- ✅ Cross-vérification des 8 verrous canon contre les 8 fiches `pnjs-behavior/`
- ✅ Vérification routing amont *(préconditions A1-01-*)*
- ✅ Vérification consommation des flags posés en aval *(scenes/_index.md)*

### Faiblesses *(avec tags sévérité)*

1. **[🟠 majeur] Scope jauges incomplet déclaré** — *« relation:emma:+1:question_role »* posée systématiquement sans condition contextuelle *(ligne 130, sur sujet `demander_role_pnj`)*. **Impact** : la scene-spec déclare *« relation:<pnj>:±2 par sujet »* mais ne précise pas *« +1 sans condition »*. Si Margot pose 2 sujets `demander_role` à Emma *(impossible mécaniquement car cap, mais doctrinale)*, c'est +2 confirmé. **Le scope déclaratif est OK, mais le canon scene-spec ne documente pas le déterminisme des deltas par sujet** — risque de divergence si Margot passe par 2 chemins différents au même PNJ. Patcher la scene-spec pour expliciter *« +1 fixe par sujet × cap 1 par sujet »*.

2. **[🟡 mineur] Routing amont non testé** — préconditions documentées en commentaire mais pas vérifiées via `{if not flag_a1_01_*}`. Si le routing amont casse, silence. Mitigation : ajouter `_init.gd` check.

3. **[🟡 mineur] `flag_camille_attend_meilleure_occasion` non documenté en aval** — flag orphelin posé ligne 265 mais aucun consommateur identifié dans `pnj-behavior:camille` ni `scenes/_index.md`. À documenter ou retirer.

4. **[🟢 polish] Emma à Neutre — réplique élargie** *« dashboards qui ressemblent à des fonds marins »*. Voix Emma cohérente mais dépasse résumé scene-spec *« réponse courte, formelle »*. Acceptable mais marge.

### Justification plafond

1 🟠 majeur trouvé → score plafonné à 14 *(règle Step 3)*. Le critère **Scope jauges** est noté 14/20 *(ancrage : « scope dépassement < 5%, patchable »)*. Les autres critères restent à 17/20. Moyenne pondérée recalculée : **15/20**.

---

## 2) Playtester LGBTQIA+ + anchors — Recalibration

**Score : Neutralité 11/20 *(🟠 majeur)* · Représentation 17/20 · Désir 17/20 · Vocabulaire 17/20 · Mécanique 14/20 — Global 14/20 🟡**

### Recherche active déclarée

- ✅ Grep des pronoms hardcodés *(« il », « elle »)* dans tous les blocs de dialogue
- ✅ Vérification que tous les PNJ queer canon respectent leurs verrous *(Sofia croisée avec sofia-kessler-caracterisation.md auto-chargée)*
- ✅ Vérification absence d'outing involontaire
- ✅ Cross-vérification motivations FLAG_MOTIVATION × disponibilité choix `[C]`

### Faiblesses *(avec tags sévérité)*

1. **[🟠 majeur] Pronom Julien/Julie : statut canon non documenté** — *« Quelqu'un — Julien. Julie. C'est selon les jours. »* *(ligne 53)*. **Impact** : le `.dtl` traite l'ex de Margot comme *binaire-fluide-canon* *(« selon les jours »)* sans référencer `ExProfileManager`. Si le joueur a configuré son ex via PRO-01 avec un genre spécifique *(homme, femme, non-binaire)*, le dialogue impose Julien/Julie en dur, écrasant la configuration utilisateur. **Risque** : invisibilisation de la configuration `ExProfileManager`. **Fix** : remplacer par `{ex_prenom}` + condition selon `ex_genre` *(ou documenter explicitement que cet ex est canon non-binaire et que `ExProfileManager` n'autorise pas la variabilité pour Margot)*.

2. **[🟡 mineur] Mécanique motivations potentiellement asymétrique** — choix `[C]` mensonge mediacorp gated par `FLAG_MOTIVATION ∈ {argent, carriere}`. Les motivations `relations` et `militante` *(potentiellement plus marquées queer/féminines selon stéréotypes ChatGPT)* n'ont pas d'équivalent stratégique ici. **Risque léger** : sous-représentation des choix avantageux pour ces motivations. À cross-vérifier sur l'ensemble du jeu.

3. **[🟡 mineur] Aucun signal positif explicite sur la diversité** — l'immeuble *est* diversifié *(Sofia trans canon, configurations relationnelles variées)* mais aucune réplique de surface ne le *normalise* dans cette scène. **Acceptable** car verrou *« identité jamais sujet »* mais perte d'opportunité pour signaler positivement.

4. **[🟢 polish] Sofia *« droit dans les yeux »* + *« sans appuyer »*** — modèle de respect verrou *force pro ≠ force intime*. À conserver.

### Justification plafond

1 🟠 majeur trouvé → plafond 14. Critère Neutralité noté 11 *(ancrage 11 : « défaut majeur, retour à pnj-behavior »)*. Moyenne pondérée : **14/20**.

---

## 3) Playtester Visual Novel v1.1 + anchors — Recalibration

**Score : Choix 14/20 · PNJ mémoire 7/20 *(🟠 majeur ancrage 11)* · Pacing 11/20 *(🟠 majeur ancrage 11)* · Sous-texte 17/20 · Voix Margot 17/20 · Cyberpunk 17/20 — Global 13/20 🟡**

### Recherche active déclarée

- ✅ Grep des branches qui convergent sur les mêmes flags *(détection choix-décor)*
- ✅ Vérification PNJ mémoire active *(références à des choix de PRO-01, PRO-02)* — **aucune trouvée**
- ✅ Comparaison voix Margot interne vs PNJ — distinction nette
- ✅ Comptage des sujets simultanés visibles dans le menu post-presentation

### Faiblesses *(avec tags sévérité)*

1. **[🟠 majeur] Saturation menu — 10 sujets simultanés post-presentation** *(lignes 129-238)*. **Impact** : le joueur voit 8 sujets *« Demander à <PNJ> »* + Witness + Observer dans une seule liste. **Comparaison canon VN** : *Disco Elysium* regroupe ses « skill checks » hiérarchiquement *(7-8 options visibles max)* ; *Pentiment* limite à 3-4 options visibles ; *Citizen Sleeper* utilise une carte/menu hiérarchique. **Niveau atteint actuellement** : ancrage 11 *(« VN dialogue-driven sans craft : scène-tunnel sans enjeu »)* car le joueur fait *2 choix* parmi 10 sans hiérarchie de prise de décision. **Fix structurel** : regrouper en sous-menu *« Parler avec quelqu'un »* → 8 sous-cibles, OU déclencher via interaction directe sur le sprite PNJ *(point-and-click)*.

2. **[🟠 majeur] Amnésie PNJ : aucune référence à PRO-02 (micros)** — **Impact** : le `.dtl` traite le dîner comme **scène indépendante** sans mémoire des choix de la scène immédiatement précédente. **Comparaison canon VN** : *LiS* — Chloé fait des références constantes aux choix de Max ; *Pentiment* — Andreas est *signalé* par les villageois selon ses choix antécédents. **Niveau atteint actuellement** : ancrage 7 *(« roman visuel old-school : voix uniforme »)* — c'est précisément le défaut qui distingue un *VN avec mémoire* d'un *VN sans craft*. **Fix structurel** : Emma *(la cousine, qui sait pour les micros)* pourrait poser une question codée conditionnelle à `flag_micros_poses` *(« Tu as bien installé ce qu'il fallait ? »)*. Hook canon disponible — c'est juste pas écrit.

3. **[🟡 mineur] Feedback échec mensonge `[C]` opaque** — Sofia démasque *« Lead européen, vraiment ? »* mais le joueur ne *voit pas* le mécanisme de vérification. **Comparaison** : *Disco Elysium* — chaque échec skill check est annoncé visuellement. Risque *« choix-décor »* perçu. Mitigation : narrator italique *« Sofia repose sa fourchette plus tôt que prévu »* avant la réplique.

4. **[🟡 mineur] Choix présentation : 4 options qui forcent une réponse — pas d'option *« refuser de répondre »*** — Margot ne peut pas dire *« non »* à Camille. **Comparaison** : *Disco Elysium* — Harry peut *toujours* refuser. Risque : choix factice par absence. Mitigation discrétionnaire.

### Apprentissages possibles pour 8-MINE

- Pour atteindre niveau ***LiS True Colors***, **fix amnésie PNJ** est P0 — c'est le différenciateur narratif principal entre un VN moyen et un VN solide.
- Pour atteindre niveau ***Disco Elysium***, regrouper le menu sujets en hiérarchie + ajouter une option *« refuser de répondre »* à la présentation.
- Pour atteindre niveau ***Citizen Sleeper***, signaler visuellement les vérifications cachées.

### Justification plafond

2 🟠 majeurs trouvés → plafond 14 enclenché. PNJ mémoire à 7/20 *(ancrage 7)* est le point le plus bas. Pacing à 11/20 *(ancrage 11 — sujets sans hiérarchie crée scène-tunnel décisionnelle)*. Moyenne pondérée : **13/20**.

---

## 4) Playtester Cyberpunk v1.1 + anchors — Recalibration

**Score : Worldbuilding 14/20 *(🟡 stratification absente — proche du 🟠)* · Corpos 17/20 *(ancrage 17 atteint, pas 20)* · Surveillance 17/20 · Augmentations 11/20 *(🟠 majeur)* · Anti-jargon 17/20 · Intime 17/20 — Global 14/20 🟡**

### Recherche active déclarée

- ✅ Grep des termes cyber-jargon performatif *(« datacore », « nanofibre », « quantique »)* — **aucun trouvé**
- ✅ Cross-vérification voix corpos vs canon `pnjs-behavior/<pnj>.md` — 8/8 distinctes
- ✅ Recherche stratification Néo-Paris N1/N2/N3 dans l'ambiance scène — **absente**
- ✅ Recherche coût visible des augmentations Alex *(scan biométrique permanent canon)* — **non porté**

### Faiblesses *(avec tags sévérité)*

1. **[🟠 majeur] Augmentations Alex sans coût visible** *(ligne 175 : « Implants, scan biométrique, ce genre »)*. **Impact** : Alex *décrit* son équipement comme un fait banal, sans aucun signal somatique ou comportemental qui *porte* le coût. **Comparaison canon cyberpunk** : *Deus Ex MD* — Jensen a des tics nerveux liés aux augmentations ; *Cyberpunk 2077* — V a des effets visibles de cyberware ; *Ghost in the Shell* — Motoko Kusanagi a des moments de doute identitaire liés à son corps. **Niveau atteint** : ancrage 11 *(« cyberpunk superficiel : néon + tours, augmentations gratuites »)*. **Fix structurel** : ajouter un détail Alex *(clignement plus lent, pause cognitive avant chaque réplique technique, regard vers Sofia comme ancrage identitaire)*. C'est canon `pnj-behavior:alex` *(« scan biométrique passif permanent »* et *« Sofia est sa raison de tenir »)* — il suffit de le *montrer*.

2. **[🟡 mineur] Stratification Néo-Paris N1/N2/N3 absente** — la scène se passe en intérieur Saint-Michel, justifiable, mais **aucune mention environnementale** *(vue par baie, écho lointain)* ne *rappelle* qu'il y a Sous-Paris en dessous. **Comparaison** : *Deus Ex MD Praha* — chaque scène intérieure rappelle visuellement les autres quartiers. **Niveau atteint** : ancrage 14 — frontière 🟡 / 🟠. Mitigation discrétionnaire mais souhaitable.

3. **[🟡 mineur] Surveillance vécue mais pas activée narrativement** — *« la lumière qui baisse imperceptiblement »* (ligne 268) est canonique mais aucune *caméra* n'est sensible à un moment précis. **Comparaison** : *Citizen Sleeper* — les caméras sont *partout* mais un moment de scène les rend visibles par un détail. Mitigation : ajouter narrator italique *« Une caméra au plafond s'oriente d'un degré. »* pendant un sujet à risque.

4. **[🟢 polish] *« Memorize et Kaizen à sa gauche. Nexus et Stratom à sa droite. La géométrie compte ici. »*** — atteint niveau Gibson sur le worldbuilding par géométrie sociale. À conserver textuellement.

### Apprentissages possibles pour 8-MINE

- Pour atteindre niveau ***Deus Ex MD***, **porter le coût des augmentations Alex** est P0 — *« scan biométrique permanent »* doit *peser* somatiquement.
- Pour atteindre niveau ***Gibson***, ajouter une phrase d'ambiance environnementale qui *dit Néo-Paris* via la baie *(« Pluie dehors. Plus bas, les canaux. »)*.
- Pour atteindre niveau ***Citizen Sleeper***, rendre la surveillance *visible* à au moins un moment précis dans la scène *(une caméra qui s'oriente)*.

### Justification plafond

1 🟠 majeur trouvé → plafond 14. Augmentations à 11/20 *(ancrage 11)*. Worldbuilding à 14/20 *(frontière 🟡)*. Moyenne pondérée : **14/20**.

---

## Concordance vs divergence

**v1** : 4 personas convergent à 17.75 ± 0.7 *(distribution étroite)* → suspect de calibration trop indulgente. **Signal détecté tardivement par utilisateur**.

**v2** : 4 personas convergent à 14 ± 0.5 *(distribution toujours étroite mais à un niveau plus crédible pour un premier passage)*. La convergence à un même niveau de 14 *(plafond 🟠 majeur)* indique que **chaque persona trouve au moins 1 🟠 majeur** — c'est cohérent pour un premier `.dtl` non itéré.

**Pas de signal anti-indulgence déclenché** côté detector v1.4 :
- Aucun persona ≥ 18/20 sans faiblesse 🟠+ trouvée
- Aucune concordance ≥ 17 avec absence de findings majeurs
- La concordance v2 *(14 ± 0.5)* à un niveau plafonné par règles automatiques est *attendue*, pas suspecte

---

## Synthèse des findings réels *(post-recalibration)*

### 🟠 Majeurs *(4 corrections structurelles)*

1. **[Dramaturge]** Scope jauges scene-spec incomplet — déterminisme par sujet non documenté
2. **[LGBTQIA+]** Pronom Julien/Julie hardcodé — invisibilise potentiellement la configuration `ExProfileManager`
3. **[VN]** Saturation menu 10 sujets — pas de hiérarchie de prise de décision
4. **[VN]** Amnésie PNJ : aucune référence à PRO-02 — pas de mémoire active inter-scènes
5. **[Cyberpunk]** Augmentations Alex sans coût visible — *« scan permanent »* canon non porté

### 🟡 Mineurs *(7 corrections de polish)*

6. Routing amont non testé *(Dramaturge)*
7. `flag_camille_attend` orphelin *(Dramaturge)*
8. Mécanique motivations potentiellement asymétrique *(LGBTQIA+)*
9. Pas de signal positif diversité *(LGBTQIA+)*
10. Feedback échec mensonge `[C]` opaque *(VN)*
11. Pas d'option *« refuser de répondre »* à la présentation *(VN)*
12. Stratification Néo-Paris absente *(Cyberpunk)*
13. Surveillance pas activée narrativement *(Cyberpunk)*

### 🟢 Polish *(2 améliorations discrétionnaires)*

14. Emma à Neutre — réplique élargie acceptable
15. Sofia *« droit dans les yeux »* modèle canon — à conserver

---

## Comparaison avec v1 — qu'est-ce que la recalibration a *vraiment* changé ?

**Nouveaux findings 🟠 majeurs détectés grâce aux anchors** *(non vus en v1)* :

- **Augmentations Alex sans coût visible** — en v1 noté en risque mais à 14/20 *(jugé acceptable)*. En v2, l'**ancrage cyberpunk 11/20** *(« cyberpunk superficiel »)* le force à être traité comme majeur, pas mineur.
- **Amnésie PNJ : aucune référence PRO-02** — en v1 noté en *« hook pour itération »* à 14/20. En v2, l'**ancrage VN 7/20** *(« roman visuel old-school »)* le force à être traité comme majeur structurel.
- **Saturation menu 10 sujets** — en v1 noté à 16/20 *(pacing « bon »)*. En v2, l'**ancrage VN 11/20** *(« scène-tunnel sans enjeu »)* le force à 🟠 majeur.

**Ce que les anchors ont *forcé* à reconnaître** : les défauts structurels qui *empêchent d'atteindre un standard externe nommé* deviennent automatiquement 🟠 majeurs, pas 🟡 polish.

---

## Verdict révisé

`.dtl` de qualité **moyenne-correcte** *(14/20 — score plafonné par 4 🟠 majeurs identifiés)*. **5 fixes structurels** à appliquer avant production `.tscn` Godot :

1. Documenter le déterminisme scope jauges dans scene-spec
2. Résoudre `Julien/Julie` *(canon non-binaire documenté OU via `ExProfileManager`)*
3. Regrouper menu sujets en hiérarchie *(sous-menu « Parler avec »)*
4. Ajouter référence PRO-02 via signal Emma conditionnel
5. Porter le coût des augmentations Alex *(détail somatique)*

Score réaliste après ces 5 fixes : **17-18/20** *(score 17 atteint pour les 4 critères)*.

---

## Méta-observation sur le workflow

**Avant patch des prompts** : moyenne 17.75/20 sur premier passage = *score gonflé* — signal de calibration insuffisante.

**Après patch des prompts** *(scoring_anchors + tags sévérité + plafonds automatiques)* : moyenne 14/20 = *score réaliste* qui force à identifier les fixes structurels avant de progresser.

**Conclusion** : le workflow d'amélioration itérative **fonctionne correctement** quand les prompts encodent explicitement les calibrations et les règles de plafond. Le test confirme l'hypothèse utilisateur *« scores trop bons pour un premier passage »*.

**Prochaine étape suggérée** : invoquer `persona-trainer` formellement sur les 4 personas pour ancrer les patterns de findings v2 dans leurs craft checklists *(pour qu'au prochain `.dtl` produit, les personas trouvent ces findings *à la première lecture* sans avoir besoin d'une seconde passe)*.
