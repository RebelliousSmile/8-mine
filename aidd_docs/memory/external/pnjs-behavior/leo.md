# PNJ Behavior — `leo`

> *Le saboteur silencieux · MEMORIZE · 30 ans · homme · Tier 1*
> Source canon : `bible-jeu.md § Léo Mars` + `overview.md § Cast` + arc-spec archivé `_archive/A2-romance-leo.md` (3 colorations) + `history.md L932` (trancheage agenda 3 couches 2026-05-21).
>
> Fiche **la plus dense** du catalogue PNJ — recyclage intégral de l'arc-spec archivé en événements de seuil par coloration.

---

## Métadonnées

```yaml
pnj_id: leo
tier: 1
corpo: memorize
sprite_set: char_leo_*.png
voix_dialogic_id: leo
prenom_var: leo_prenom
```

---

## Verrous canon (sacrés)

1. **Agenda à 3 couches** *(tranché 2026-05-21, `history.md L932`)* :
   - **(a) Surface publique** : lassitude esthétique cultivée. *Léo sabote par lassitude, pas par idéologie* (Weakness Tag canon). Cette surface est sincère — Léo apprécie réellement le sabotage stylé, l'élégance technique. C'est aussi un *masque pour passer sous radar*.
   - **(b) Couche 1** : protection d'Emma à son insu. Léo a compris ce que Memorize prépare pour sa cousine et sabote *pour la couvrir*. Emma l'ignore.
   - **(c) Couche 2** : Léo monte aussi un coup structuré sur les flux vidéo Memorize, qu'il *justifie* par la protection d'Emma mais qui le sert lui-même *(intérêt personnel masqué par alibi cousinage)*.
   Ces 3 couches sont **non-réductibles** — toute écriture qui les aplatit (« Léo est juste un saboteur lassé » OU « Léo est un cynique opportuniste ») viole canon.

2. **Couple Léo × Emma — observation mutuelle silencieuse, pas intimité**. Surface canon : couple Memorize intime audible la nuit *(cf. `cellule_nuit` ambiance sonore canon)*. Réalité canon : *« Emma le surveille »* (Weakness Tag), *« Le couple fonctionne comme observation mutuelle silencieuse plus que comme intimité »* (bible-jeu L532). Toute écriture qui montre le couple en romance simple viole canon.

3. **Aucune cause militante**. Léo ne sabote pas pour une cause, pas par éthique, pas par révolte. Il sabote *par lassitude esthétique* (Weakness Tag canon). Toute scène qui montre Léo en militant ou en activiste viole canon. C'est *précisément ce qui le rend imprévisible* — pas d'axe moral fixe.

4. **Léo sait que sa surface ne convaincra pas indéfiniment** (canon bible-jeu L532, *« La faille est cognitive »*). Il n'est pas naïf sur la précarité de son masque. Toute écriture qui montre Léo surpris d'être démasqué viole canon — il s'y attend, il *gère* le moment de la révélation.

5. **Verrou d'accès au pool romance Léo**. L'arc romance n'est accessible qu'avec **au moins une couche percée** (`flag_leo_couche_1_percee OR flag_leo_couche_2_percee`). La coloration de surface seule (lassitude esthétique) ne suffit pas. *Cf. arc archivé `_archive/A2-romance-leo.md § Préconditions`.*

6. **3 colorations d'arc romance**, fixées au beat 1 selon flags d'entrée :
   - **A — Solidaire** : `couche_1 AND NOT couche_2`. Margot voit le protecteur. Léo ne sait pas qu'elle voit. *Complicité tendre, asymétrique*.
   - **B — Asymétrique** : `couche_2 AND NOT couche_1`. Margot voit l'ambition. Léo croit qu'elle voit la protection. *Ambiguïté contrôlée, jeu de masque*.
   - **C — Pleine ambiguïté** : `couche_1 AND couche_2`. Margot voit tout. Léo le sait. Plus de masque. *Adultes lucides face à une situation impossible*.

7. **Émma intercepte si pacte fraternel scellé**. Si `flag_pacte_emma = true` *(via `pnjs-behavior/emma.md § event_emma_confident`)*, Emma intervient au beat 3 de l'arc Léo pour *« protéger Margot d'un faux pas »* (registre boussole morale, pas jalousie de cousine). *Cf. arc archivé `_archive/A2-romance-leo.md § Beat 3`.*

**Sensitivity reader requis** : non spécifique *(pas de tropé identitaire majeur sur Léo lui-même)* — mais **review `dramaturge` obligatoire** sur les 3 colorations pour vérifier non-aplatissement des couches.

---

## Voix par palier

Tonalité commune : *fatigué qui s'amuse encore par défi intellectuel*. Pas cynique, pas amer. Lassitude cultivée + lucidité piquante.

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *quasi-inaccessible* — requiert dénonciation publique par Margot OU exposition de la couche 2 à Memorize | bref, technique, distance pro irrévocable | Présence ostensible, scan rapide, retrait |
| Hostile | Si Margot expose Léo à Emma sans alliance préalable | mots tranchants, ironie froide | Distance, regard appuyé, range ses écrans |
| Méfiance | Par défaut si Margot l'a interpellé de façon menaçante | bref, neutre pro | Sourire qui ne va pas aux yeux |
| Neutre *(défaut au dîner)* | Détaché, sourire bref, ne développe pas | *« Design d'interfaces »*, *« Ce que tu vois quand tu vois rien »* | Économie de gestes, sourire formel |
| Favorable | Reconnaît Margot comme interlocutrice intéressante | *« Du moment que tu floutes mon écran »*, partage anecdote technique | Pose son stylet, garde le regard plus longtemps |
| Allié *(`flag_acces_flux_leo = true` canon)* | Alliance technique scellée — Léo partage l'accès aux flux | *« Accord de transparence inter-corporatiste »*, ironie complice | Plus présent physiquement, gestes plus précis |
| Proche | Confiance technique approfondie *(rare avant couche percée)* | *« Tu m'intrigues »*, lâche un peu sur sa lassitude | Posture détendue, peut s'asseoir face à Margot |
| Confident *(plafond canon coloration A/B/C — ouvre FIN-E Léo trois variantes)* | Ton spécifique à la coloration *(voir événements de seuil ci-dessous)* | dépend de la coloration — registre différent par couche révélée | dépend de la coloration |
| Fusionnel | *inaccessible canon* — Léo garde toujours une distance esthétique, ne se fond pas | — | — |

---

## Événements de seuil

### `event_leo_favorable` — palier Favorable franchi *(via sabotage stylé)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:leo` franchit Favorable (≥ +20)
  - + Margot a proposé un **sabotage stylé** ou une **complicité technique élégante** *(canon bible-jeu L527 : « Allié technique si Margot propose un sabotage stylé »)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Léo lève un sourcil, dépose son stylet. *« Pas mal. Tu n'es pas obligée d'expliquer. »* — c'est la première fois qu'il ne réduit pas la conversation à une formule. Il propose un accord transparent : flouter son écran en échange d'un accès partagé aux flux vidéo.
- **Déverrouille** :
  - sujet `proposer_acces_flux_leo` dans `atelier_leo` et `cellule_nuit` *(post-couvre-feu)*
  - flag `flag_leo_propose_acces = true`

### `event_leo_acces_flux` — *scénique, ouvre couche 2 potentielle*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - `flag_leo_propose_acces = true`
  - Margot accepte l'accord *(sujet `proposer_acces_flux_leo` choix accepter)*
- **Mode** : immédiat
- **Effet** :
  - Pose `flag_acces_flux_leo = true` *(canon `history.md L510` — débloque révélation Alex via footage)*
  - `relation:leo:+10:alliance_technique`
  - **Hook couche 2** : à partir d'ici, si Margot examine les flux avec attention (`EV ≥ 3`), elle peut détecter le coup personnel de Léo → `flag_leo_couche_2_percee = true`. *Détection passive narrative, pas joueur-initiée.*

### `event_leo_couche_1_aperçue` — *scénique, ouvre couche 1*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** *(deux canaux canon — `_archive/A2-romance-leo.md § Préconditions`)* :
  - Canal 1 : Margot a choisi `A1-01-confrontation [D]` *(alliance Emma + bonnes questions)* → flag posé par scene amont
  - Canal 2 : Margot croise les révélations Emma `A2-01B` *(canon history L338)* avec une scène Léo → croisement
- **Mode** : immédiat lors du canal qui le déclenche
- **Effet** :
  - Pose `flag_leo_couche_1_percee = true`
  - Pas de changement de relation directe — c'est une *information acquise par Margot*, Léo ne sait pas (encore) qu'elle sait

### `event_leo_couche_2_percee` — *scénique, ouvre couche 2*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - `flag_acces_flux_leo = true` *(via event_leo_acces_flux)*
  - `EV ≥ 3`
  - Sujet `examiner_flux_leo_avec_attention` consommé dans `cellule_nuit` ou `poste_memorize_partage`
- **Mode** : immédiat
- **Effet** :
  - Pose `flag_leo_couche_2_percee = true`
  - Léo ne sait pas que Margot a percé — *information passive*

### `event_leo_aveu_mutuel` — palier Confident franchi *(événement principal arc, 3 colorations)*

- **Type** : montée, one-shot — **événement central de l'arc Léo**
- **Conditions** *(toutes requises)* :
  - `relation:leo` franchit Confident (≥ +60)
  - + verrou d'entrée : `flag_leo_couche_1_percee OR flag_leo_couche_2_percee` *(verrou canon)*
  - + contexte : `atelier_leo` *(espace créatif privé, écrans éteints — Emma en déplacement Memorize off-screen ou nuit)*
- **Mode** : différé strict — buffer jusqu'à arrivée dans `atelier_leo`
- **Coloration calculée au déclenchement** :

  | Coloration | Condition flag | Réaction scriptée Léo *(résumé)* |
  |------------|----------------|----------------------------------|
  | **A — Solidaire** | `couche_1 AND NOT couche_2` | Léo dépose son masque, à demi-mot : *« Je protège des choses qu'on ne devrait pas avoir à protéger. »* — silence long quand Margot révèle qu'elle a compris pour Emma. |
  | **B — Asymétrique** | `couche_2 AND NOT couche_1` | Léo croit que Margot a compris la protection d'Emma. Il commence à parler comme à une alliée altruiste. Margot **choisit silencieusement** de laisser l'illusion ou de la rompre — *implicite, pas verbalisé immédiatement*. |
  | **C — Pleine ambiguïté** | `couche_1 AND couche_2` | Léo n'a plus de masque. *« Tu sais déjà tout. Qu'est-ce que tu veux que je te dise ? »* — adulte lucide face à l'impasse. |

- **Pose** : `flag_leo_coloration_A` OU `_B` OU `_C` (exactement un) ; `flag_leo_aveu_mutuel_consomme = true`

### `event_leo_pivot_choix` — *scénique PIVOT, choix Margot selon coloration*

- **Type** : événement scénique conditionnel one-shot *(joué dans la même scène que `event_leo_aveu_mutuel` ou la suivante)*
- **Conditions** :
  - `flag_leo_aveu_mutuel_consomme = true`
  - Une coloration active *(`flag_leo_coloration_X = true`)*
- **Mode** : immédiat — pas de skip possible, c'est le pivot moral de l'arc Léo
- **Choix Margot selon coloration** *(recyclés de l'arc archivé `_archive/A2-romance-leo.md § Beat 4 PIVOT`)* :

  **Coloration A — 2 choix** :
  - `[A]` Sceller l'alliance protectrice sans intimité *(priorité Emma)* → `flag_leo_pacte_protection_scelle = true · MS+2 · relation:leo:+20`. **Ne consomme PAS la romance.**
  - `[B]` Consommer l'intimité solidaire → `flag_leo_intimite_solidaire = true · mirror+10:intrusion_conjugale · relation:leo:+25`.

  **Coloration B — 3 choix** :
  - `[A]` Maintenir l'illusion *(Léo croit toujours qu'elle voit seulement la protection)* → `flag_leo_illusion_maintenue = true · mirror+15:complicite_opportuniste · relation:leo:+15`.
  - `[B]` Briser l'illusion maintenant *(« Je sais pour ton coup »)* → `flag_leo_illusion_brisee = true · relation:leo:-25` — ouvre coda confrontation.
  - `[C]` Consommer sans rien clarifier → `flag_leo_intimite_floue = true · mirror+20:charge_cognitive · relation:leo:+10`.

  **Coloration C — 3 choix** :
  - `[A]` Proposer un pacte explicite *(couple-conspirateurs Margot/Léo)* → `flag_leo_couple_conspirateurs_scelle = true · mirror+10:adultes_lucides · relation:leo:+25` — ouvre la coda FIN-E Léo *« couple-conspirateurs »* (variante la plus dense canon).
  - `[B]` Dénoncer Léo à Emma *(avant qu'il soit trop tard)* → `flag_leo_denonce_a_emma = true · EV+1 · relation:leo:-40 · relation:emma:+15` *(si `flag_pacte_emma = true`)*.
  - `[C]` Retrait lucide sans dénonciation → `flag_leo_retrait_lucide_final = true · MS+1 · relation:leo:-15`.

- **Déverrouille** : 8 codas possibles selon la combinaison coloration × choix *(cf. arc archivé pour le détail beat 5 — 7 NODES coda dans le modèle ancien, désormais simples *résumés* dans cette section)*

### `event_emma_intercept_leo` — *scénique forcé si pacte Emma actif*

- **Type** : événement scénique conditionnel automatique
- **Conditions** :
  - `flag_pacte_emma = true` *(via `pnjs-behavior/emma.md § event_emma_confident`)*
  - Scène contenant Léo seul ou en intimité avec Margot
  - `flag_leo_aveu_mutuel_consomme = true` *(intervention juste après l'aveu mutuel, avant le PIVOT)*
- **Mode** : immédiat
- **Effet** :
  - Emma intercepte Margot en privé après la scène atelier : *« Qu'est-ce que tu cherches avec Léo ? »* — registre **boussole morale**, pas jalousie de cousine.
  - Margot peut écouter ou esquiver. Écouter : `flag_emma_alerte_leo_acceptee = true · MS+1` *(module les coda Léo : si pacte conspirateurs scellé après écoute, l'effet est plus lourd — `mirror+5:malgre_alerte_emma` supplémentaire)*. Esquiver : `relation:emma:-5 · pas de modulation`.
- **Verrou d'écriture** : Emma ne défend pas son couple. Elle protège Margot d'un faux pas. Ton structurant, pas accusatif.

---

## Hooks scènes

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Neutre : *« Design d'interfaces. Memorize. Ce que tu vois quand tu vois rien. »* — sourire bref, ne développe pas |
| `zone_commune_jour` *(à spec)* | présence variable, parfois à son atelier off-screen | Méfiance/Neutre : politesse brève. Favorable+ : peut amorcer `event_leo_favorable` |
| `coursive_residents_nuit` *(à spec)* | rare — Léo travaille tard | Si croisé : ironie complice possible à partir de Favorable |
| `cellule_margot_nuit` ✅ | présent si tirage déterministe = leo *(palier:leo le plus haut parmi {frank, thomas, leo} dans le sujet `sortir_croiser`)* | Si croisé : `event_leo_favorable` ou échange technique court |
| `atelier_leo` *(à spec, semi-privé `palier:leo ≥ Favorable`)* | systématique heures travail + soirs | Hub principal des événements ≥ Confident. `event_leo_aveu_mutuel` se joue ici. |
| `poste_memorize_partage` *(à spec)* | possible si Emma allié couvre Margot | Léo peut être présent en arrière-plan, observe |
| `appart_emma_leo` *(à spec, privé `palier:emma ≥ Allié`)* | présent sauf déplacement Memorize off-screen | Si Margot y entre via Emma : Léo peut être là, ambigu |
| `confrontation_camille` *(A3, à spec)* | absent généralement | Mention possible |
| `coda_finale` *(A4)* | variable selon `flag_leo_*` accumulés | 8 codas possibles selon coloration × choix PIVOT |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `atelier_leo` | semi-privé *(espace créatif Léo, distinct de l'appart partagé Emma/Léo)* | `palier:leo ≥ Favorable` |
| `appart_emma_leo` | privé *(partagé avec Emma)* | `palier:emma ≥ Allié` *(cf. `pnjs-behavior/emma.md`)*. **Note** : palier Léo seul ne suffit pas à entrer dans l'appart — c'est l'accès *via Emma* qui prime. |

---

## Risques structurels

1. **Aplatissement des 3 couches**. Risque majeur d'écriture : réduire Léo à *« le saboteur lassé »* (couche surface seule) ou à *« l'opportuniste cynique »* (couche 2 seule). Mitigation : toute scène Léo en arc romance doit explicitement référencer la coloration active *(`flag_leo_coloration_X`)* dans son contenu — sinon ambiguïté de canon. Vérifier en `dramaturge` que les 3 couches restent simultanément présentes en sous-texte.

2. **FIN-E Léo en 3 variantes** *(canon overview)*. Risque de production trop large. Mitigation : **prioriser FIN-E Léo coloration C couple-conspirateurs** comme variante canon principale dans la production initiale, marquer A et B comme *« P2 ; à brainstormer si bande passante »*. Documenté dans `_archive/A2-romance-leo.md § Risque #2`.

3. **Coordination avec `pnjs-behavior/emma.md`**. Si pacte Emma scellé, `event_emma_intercept_leo` s'enchaîne automatiquement. Risque que cette interception soit oubliée en production. Mitigation : ajouter explicitement le check `flag_pacte_emma` dans le `.dtl` de toute scène Léo intime, et router vers `event_emma_intercept_leo` si vrai. À vérifier en `auditeur-scene` matriciel.

4. **Léo militant**. Risque d'erreur de canon : présenter Léo comme un activiste motivé. Verrou 3 : *« aucune cause militante »*. Mitigation : grep des répliques Léo pour détecter tout vocabulaire militant *(« je veux changer », « c'est pour les gens »)* — refuser en review. Léo dit *« par lassitude »*, pas par cause.

5. **Couple Léo/Emma intime audible** au dîner *(canon)*. Le canon dit *« intimité audible la nuit »*. Mais le couple est aussi *« observation mutuelle silencieuse plus que intimité »* (bible-jeu L532). Tension d'écriture : l'audible est *performé*, pas *vécu*. À écrire avec une légère artificialité — les bruits d'intimité Emma/Léo dans `cellule_nuit` doivent lire comme *trop normaux pour être entièrement spontanés*. Cf. `pnjs-behavior/emma.md` voix Allié+ pour cohérence.

---

## Validation locale

- [x] 9 paliers couverts (Ennemi juré quasi-inaccessible, Fusionnel inaccessible — Léo garde toujours distance esthétique)
- [x] 7 événements de seuil dont 4 scéniques (acces_flux, couche_1_aperçue, couche_2_percee, emma_intercept_leo) et 3 principaux palier-anchored (favorable, aveu_mutuel, pivot_choix)
- [x] Verrous canon explicites (7) alignés avec `bible-jeu.md` + `history.md` (trancheage 2026-05-21 3 couches) + arc-spec archivé
- [x] Hooks scènes pointent vers scenes existantes (`diner_arrivee` ✅, `cellule_nuit` ✅) ou à créer (atelier_leo, appart_emma_leo, poste_memorize_partage)
- [x] Pas de sensitivity reader spécifique requis — mais `dramaturge` obligatoire sur les 3 colorations
- [x] Seuils d'accès cohérents avec `pnjs-behavior/emma.md` (appart partagé)
- [x] 3 colorations × 7 événements = matrice complète recyclée de l'arc archivé
- [x] FIN-E Léo en 3 variantes documentée *(prioriser C couple-conspirateurs en production)*

---

## Validation Léo dans `diner_arrivee.dtl` (audit retroactif)

| Réplique `.dtl` | Palier supposé | Verrou respecté ? |
|-----------------|----------------|-------------------|
| *« Design d'interfaces. Memorize. Ce que tu vois quand tu vois rien. »* | Neutre | ✓ vocabulaire technique, ironie piquante, économie verbale |
| *« Sourire bref. Il ne développe pas. »* | Neutre | ✓ canon registre détaché (`bible-jeu.md` table L566) |
| *« Echange de regards entre Léo et Thomas. Pas de réplique frontale. »* *(evoquer_witness)* | Neutre | ✓ observation silencieuse canon |

**Verdict** : le `.dtl` `diner_arrivee` respecte les verrous canon de Léo. **Aucune correction nécessaire**.

---

## Coordination cross-PNJ

- **Avec `pnjs-behavior/emma.md` ✅** : Léo et Emma sont en couple. Emma le surveille (Weakness Tag Léo). Si `flag_pacte_emma = true`, Emma intercepte au beat 3 de l'arc Léo (`event_emma_intercept_leo` documenté ci-dessus). Si pacte Emma rompu *(`flag_emma_distance` ou `flag_emma_blessee`)*, Emma observe en silence, l'interception ne se déclenche pas.
- **Avec `pnjs-behavior/alex.md` ✅** : Léo peut révéler Alex via flux vidéo *(canon `history.md L510` — si `flag_acces_flux_leo = true`)*. Hook canon `event_alex_revelation_taupe`.
- **Avec `pnjs-behavior/camille.md` ✅** : Camille profile Léo *(par défaut)*. Léo le sent. Tension de fond, sans interaction frontale. Au dîner d'arrivée, Léo regarde Thomas plutôt que Camille — pattern canon.
- **Avec `pnjs-behavior/sofia.md` ✅** : peu d'interaction directe. Sofia peut auditer les flux Memorize en théorie *(département éthique Nexus)*. Si `flag_leo_couche_2_percee = true` ET Sofia alliée *(`flag_sofia_alliee`)*, Sofia peut intervenir en A3 pour exposer Léo — chemin canon de pression sur l'arc Léo.
- **Avec `pnjs-behavior/frank.md` ✅** : Frank évalue Léo comme tous les autres. Léo est *« observe sans agir »* par défaut (canon Spectre). Si Margot allie Léo au sabotage et que Léo crée des angles morts, Frank en est conscient — modulation possible du verdict A3.
