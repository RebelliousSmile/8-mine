# PNJ Behavior — `frank`

> *Le test · STRATOM · 42 ans · homme · Tier 1*
> Source canon : `bible-jeu.md § Frank Dosière` + `overview.md § Cast` + `history.md L529-548 (NODE A3-01 Verdict Frank)` + `history.md L774-780 (FIN-E Frank)`.

---

## Métadonnées

```yaml
pnj_id: frank
tier: 1
corpo: stratom
sprite_set: char_frank_*.png
voix_dialogic_id: frank
prenom_var: frank_prenom
```

---

## Verrous canon (sacrés)

1. **Frank évalue Margot pour Stratom**. Sa mission active canon = décider si Margot est *menace à neutraliser* ou *ressource à retourner*. Toute scène qui montre Frank désintéressé ou neutralité passive viole canon — il est en *test permanent*. *Cf. `bible-jeu.md L458` (verdict canon tranché 2026-05-21).*

2. **« Recherche de rédemption » = vulnérabilité latente, pas objectif déclaré**. Frank ne *cherche pas* la rédemption explicitement. C'est une vulnérabilité que **l'intégrité de Margot peut activer rétroactivement**. Toute écriture qui pose Frank comme « ex-tueur en quête de pardon » au premier plan viole canon — c'est trop direct. *Cf. `bible-jeu.md L458`.*

3. **Handler du countdown Équipe Nettoyage**. Frank tient *administrativement* le compteur `equipe_nettoyage` (max 14 ticks). Avance via `personal_danger` ↑ ou alertes sécurité. **Recule via tests d'intégrité réussis** auprès de lui (mécanique canon). *Cf. `bible-jeu.md L446` + `variables-register.md`.*

4. **Couple Camille × Frank glacial mais réel**. Pas de façade — vraie relation longue durée silencieuse par routine et contrôle mutuel. Le silence nocturne Camille/Frank au dîner d'arrivée *(canon `history.md L262`)* n'est pas un mystère : c'est l'**intimité fossilisée** de deux opératifs qui se lisent en permanence. À écrire avec retenue. *Cf. `history.md L941`.*

5. **Frank parle peu**. Économie verbale extrême — un mot, une phrase courte, parfois rien. *« Sécurité. »* / *« On verra. »* / *« J'ai dit on verra. J'ai vu. »* Les longues répliques de Frank sont une erreur d'écriture (sauf en verdict A3-01 où il *peut* développer une phrase complète).

6. **Signaler subtilement**. *(Verrou 2026-05-21)* Le rôle de Frank se signale par les **silences qu'il maintient** (registre vocal : silencieux → test → verdict) et par les **détails physiques** (Frank reflété dans une vitre, regards prolongés, échanges silencieux avec Sofia — alliance tacite pro). Pas de dialogue qui explique son rôle.

7. **Verrou couple post-Camille trahison** : si `flag_camille_obsession_active = true` (Camille perd l'autorité morale, cf. `pnj-behavior:camille § event_camille_obsession`), Frank en *est conscient* immédiatement (il lit Camille en permanence). Effet : `flag_frank_a_vu_camille_basculer = true` pose une tension de fond dans toute scène Frank ultérieure.

**Sensitivity reader requis** : non spécifique *(pas de tropé identitaire majeur)* — mais cohérence inter-arcs (Frank ↔ Camille, Frank ↔ Sofia alliance tacite) à vérifier en `dramaturge`.

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *quasi-inaccessible* — requiert `personal_danger ≥ 5` ET acte explicite de Margot contre Stratom | aucun mot — passage à l'acte | Présence menaçante, main visible sur la table ou poche |
| Hostile | Si Margot a déclenché countdown ≥ 10 ET refusé tous tests d'intégrité | mots techniques, présent immédiat | Distance tactique, scan permanent |
| Méfiance | Par défaut si Margot a échoué ≥ 1 test d'intégrité sans rattrapage | bref, opérationnel | Position tactique (dos au mur, vue sur sorties) |
| Neutre *(défaut)* | Silencieux, observe long | *« Sécurité »*, *« On verra »*, *« Filme tout »* | Un mot par échange max, regard de 3 secondes |
| Favorable | Margot a réussi ≥ 1 test d'intégrité | *« Pas mal »*, *« Continue »* | Hochement bref, regard moins long |
| Allié | `flag_frank_allie = true` après verdict A3-01 réussi | *« J'ai vu »*, phrases complètes possibles | Présence plus assumée, peut s'asseoir face à Margot |
| Proche | Rare — requiert ≥ 2 tests intégrité + scène nocturne *(`flag_rencontre_nocturne_frank = true`)* | *« Tu n'as pas idée de ce que je faisais avant »* | Pose les coudes, regard de plain-pied |
| Confident | Plafond canon — Frank ouvre la possibilité de FIN-E | *« Il y a longtemps que je cherchais quelqu'un d'assez intègre pour mériter ça »* | Présence détendue, retrait du contrôle tactique permanent |
| Fusionnel | *inaccessible canon* — Frank reste un opératif, garde toujours une distance tactique même en intimité | — | — |

---

## Événements de seuil

### `event_frank_test_integrite` — *scénique récurrent, pas palier-anchored*

- **Type** : événement scénique conditionnel récurrent *(jusqu'à 3 fois par run)*
- **Conditions de déclenchement** :
  - Margot pose un acte d'intégrité visible dans une scène où Frank est présent OU peut entendre/voir (zone commune, coursive, croisement nocturne)
  - Exemples canon d'actes d'intégrité : refuser de mentir quand Margot pourrait gagner à mentir · protéger un PNJ vulnérable au prix d'une opportunité · publier une info sans cacher la source · refuser une instrumentalisation Witness
  - `flag_frank_tests_reussis < 3` *(cap canon)*
- **Mode** : immédiat dans la scène où l'acte est posé
- **Effet** :
  - Pose `flag_frank_tests_reussis = <N+1>`
  - `relation:frank:+5:test_integrite_<N>`
  - `countdown:equipe_nettoyage:-1` *(recul canon — bible-jeu.md L446)*
  - Réaction scriptée Frank : un hochement bref, ou un mot *(« Pas mal. »* / *« On verra. »)* selon palier
- **Note canon** : *réussite récurrente* — la mécanique est canon (« tests d'intégrité réussis »). Trois réussites accumulées ouvrent automatiquement le verdict A3-01 favorable.

### `event_frank_favorable` — palier Favorable franchi *(via tests réussis)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:frank` franchit Favorable (≥ +20)
  - Typiquement déclenché *via accumulation* de tests d'intégrité réussis (`event_frank_test_integrite`)
- **Mode** : immédiat à la fin de la scène qui a poussé le palier
- **Réaction scriptée** *(résumé)* :
  > Frank, en croisement de couloir : il s'arrête, demi-seconde. *« Margot. »* — c'est tout. Mais c'est la première fois qu'il prononce son prénom. Avant, il l'appelait « Sinclair » ou rien du tout.
- **Déverrouille** :
  - sujet `parler_a_frank_seul` dans `zone_commune_jour` *(Margot peut désormais initier une conversation à 2-3 phrases, pas juste un mot)*
  - flag `flag_frank_prenom_acquis = true` *(lu en outro coda finale pour colorer)*

### `event_frank_rencontre_nocturne` — *scénique conditionnel, prerequis Proche*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - Margot active sujet `sortir_croiser` dans `cellule_nuit` ET tirage déterministe = frank *(palier:frank ≥ Favorable + le plus haut parmi {frank, thomas, leo})*
  - Vérification cachée PD : réussite si `personal_danger ≤ 3` *(Margot n'est pas trop suspecte)*
- **Mode** : immédiat
- **Effet** :
  - Réussite : pose `flag_rencontre_nocturne_frank = true` · `relation:frank:+10:rencontre_nocturne` · scène brève dans le couloir avant la cellule Frank *(pas dans son appart)*
  - Échec : caméra détecte → `pd:+1 · surveillance:+5`, Frank n'apparaît pas, Margot rentre fauchée
- **Note canon** : prerequisite pour ouvrir la coda FIN-E Frank *(history.md L442 — *« Relation Frank ≥ +30 · FLAG_RENCONTRE_NOCTURNE_FRANK = true ou ≥ 2 tests intégrité réussis »*)*

### `event_frank_verdict_a3` — *scénique, A3 forcé par countdown*

- **Type** : événement scénique conditionnel **automatique** *(pas joueur-initié)*
- **Conditions de déclenchement** :
  - `countdown:equipe_nettoyage ≤ 7` *(canon history.md L533)*
  - Acte = A3
- **Mode** : immédiat dans la prochaine scène compatible *(salon Stratom ou croisement isolé)*
- **Effet ternaire** *(canon `history.md L535-548`)* :
  - **Allié** *(si `flag_frank_tests_reussis ≥ 3`)* :
    > *« J'ai dit on verra. J'ai vu. »*
    > Pose `flag_frank_allie = true · countdown:equipe_nettoyage:0` *(suspendu)* · ouvre FIN-E romance Frank et aide décisive A4
  - **Neutre** *(`flag_frank_tests_reussis = 2` ou ambigu)* :
    > *« Je ne peux pas te protéger. Mais je ne t'empêcherai pas non plus. »*
    > Pose `flag_frank_neutre = true · countdown continue` *(progression normale)*
  - **Hostile** *(`flag_frank_tests_reussis ≤ 1`)* :
    > *(Frank ne dit rien. Il ne vient pas à la scène. Le countdown accélère.)*
    > Pose `flag_frank_hostile = true · countdown:equipe_nettoyage:-2` *(tick supplémentaire — Stratom déploie)*
- **Note canon** : verdict est **unique et irrévocable** — pas de second verdict, pas de revirement post-A3-01.

### `event_frank_confident` — palier Confident franchi *(ouvre FIN-E Frank)*

- **Type** : montée, one-shot
- **Conditions** *(toutes requises)* :
  - `relation:frank` franchit Confident (≥ +60)
  - `flag_frank_allie = true` *(verdict A3 réussi)*
  - `flag_rencontre_nocturne_frank = true` OU `flag_frank_tests_reussis ≥ 3`
- **Mode** : différé *(buffered, joué dans la prochaine scène A4 compatible)*
- **Réaction scriptée** *(canon citation `history.md L779`)* :
  > Frank donne le dossier Stratom interne sur l'Équipe Nettoyage. Il déclenche lui-même une alerte administrative qui bloque l'intervention. Sa carrière Stratom est finie.
  >
  > *« J'ai dit 'on verra'. Il y a longtemps que je cherchais quelqu'un d'assez intègre pour mériter ça. »*
- **Déverrouille** :
  - coda FIN-E Frank accessible *(palier:frank ≥ Confident + flag_frank_allie + flag_frank_carriere_finie)*
  - aide décisive A4 : `EV+2:dossier_stratom_interne` + blocage administratif Équipe Nettoyage
  - flag `flag_frank_carriere_finie = true` *(conséquence canon — Frank sacrifie son poste)*

---

## Hooks scènes

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Neutre : *« Sécurité. »* + 3 secondes de regard prolongé |
| `zone_commune_jour` *(à spec)* | présence variable, posté en surveillance discrète | Méfiance/Neutre : un mot, observation. Favorable+ : `event_frank_favorable` possible (croisement avec prénom) |
| `coursive_residents_nuit` *(à spec)* | rare — Frank patrouille discrètement | Si croisé : test silencieux possible (`event_frank_test_integrite`) |
| `cellule_margot_nuit` ✅ | présent si tirage déterministe = frank | `event_frank_rencontre_nocturne` possible si conditions |
| `verdict_frank` *(A3, à spec)* | scène pivotale A3 | `event_frank_verdict_a3` automatique si countdown ≤ 7 |
| `appart_camille_frank` *(à spec, privé)* | systématique si Margot y entre | Confident requis, présence de Camille à gérer côté `pnj-behavior:camille` |
| `coda_finale` *(A4)* | variable selon `flag_frank_*` | Si Allié + Confident : coda FIN-E Frank ; si Neutre : présence silencieuse ; si Hostile : Équipe Nettoyage déployée |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `appart_camille_frank` | privé *(couple Camille/Frank)* | `palier:frank ≥ Confident` OU `palier:camille ≥ Confident` *(cf. `pnj-behavior:camille`)*. **Note** : pas de poste technique privé Frank distinct — Frank n'a pas d'espace pro propre dans l'immeuble *(canon : Stratom n'a pas d'opérations locales en visible, Frank travaille off-site)*. |

---

## Risques structurels

1. **Frank verbeux**. Risque majeur d'écriture : multiplier les répliques courtes pour Frank tout en rallongeant chacune. Mitigation : grep des répliques Frank dans les `.dtl`, vérifier qu'aucune ne dépasse 15 mots sauf en `event_frank_verdict_a3` *(seul moment canon où il développe)*.

2. **« Recherche de rédemption » trop frontale**. Risque que les scènes A2-A3 montrent Frank ouvertement en quête. Mitigation : la rédemption est *un effet rétroactif* du test Margot, pas un moteur déclaré. Toute réplique du type *« Je veux racheter ce que j'ai fait »* viole canon. La citation canon de FIN-E Frank dit *« il y a longtemps que je cherchais »* — au passé, en bilan, **pas en plainte**. Vérifier en `dramaturge`.

3. **Cohérence avec couple Camille/Frank fossilisé**. Si Frank a des scènes intimes Margot avant verdict A3, le couple Camille/Frank doit rester visible (silence à la maison, croisements glaciaux dans la zone commune). Risque que les scènes Frank intimisent au point d'effacer Camille — Camille doit toujours apparaître au moins en mention. À vérifier en `dramaturge` croisé avec `pnjs-behavior:camille`.

---

## Validation locale

- [x] 9 paliers couverts (Ennemi juré quasi-inaccessible, Fusionnel inaccessible canon — Frank garde toujours distance tactique)
- [x] 5 événements de seuil dont 1 récurrent (test_integrite) + 1 automatique forcé (verdict A3)
- [x] Verrous canon explicites (7) et alignés avec `bible-jeu.md` + `history.md` + threads tranchés 2026-05-21
- [x] Hooks scènes pointent vers scenes existantes (`diner_arrivee` ✅, `cellule_nuit` ✅) ou à créer
- [x] Pas de sensitivity reader spécifique requis — cohérence inter-arcs avec Camille à vérifier en `dramaturge`
- [x] Seuil d'accès au seul espace privé Frank (`appart_camille_frank`) cohérent avec `pnj-behavior:camille`
- [x] Mécanique countdown `equipe_nettoyage` documentée *(recul via tests d'intégrité réussis — pattern canon existant)*

---

## Validation Frank dans `diner_arrivee.dtl` (audit retroactif)

| Réplique `.dtl` | Palier | Verrou respecté ? |
|-----------------|--------|-------------------|
| *« Sécurité. »* | Neutre | ✓ un mot, vocabulaire canon |
| *« Un seul mot. Il ne te lâche pas du regard pendant trois secondes. »* | Neutre | ✓ détail physique canon (regard prolongé), économie verbale |
| Pose `flag_frank_a_observe = true` | Neutre | ✓ Frank observe par défaut — cohérent avec mission canon d'évaluation |

**Verdict** : le `.dtl` `diner_arrivee` respecte les verrous canon de Frank. Aucune correction nécessaire.

---

## Coordination cross-PNJ

- **Avec `pnj-behavior:camille`** : Frank lit Camille en permanence. Si `flag_camille_obsession_active = true`, Frank en est conscient (`flag_frank_a_vu_camille_basculer = true`). À l'inverse, Camille lit Frank — le silence nocturne Camille/Frank canon n'est *pas* absence d'amour passé, c'est sa fossilisation présente, à écrire avec retenue (verrou commun).
- **Avec `pnj-behavior:sofia` (à spec)** : *« alliance tacite avec Frank »* canon (cf. `bible-jeu.md L476`) — professionnelle/éthique, parallèle au couple Sofia/Alex, n'entre pas en collision. Frank et Sofia peuvent échanger des regards silencieux en zone commune, à documenter dans la fiche Sofia.
- **Avec `pnj-behavior:emma` ✅** : Frank évalue aussi Emma via ses choix. Si Emma révèle Alex (canon `history.md L509`), Frank en est informé via Stratom — moduler son verdict A3 conditionnellement.
