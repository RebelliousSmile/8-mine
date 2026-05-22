# PNJ Behavior — `sofia`

> *La vigilante éthique · NEXUS · 28 ans · femme trans · Tier 2*
> Source canon : `bible-jeu.md § Sofia Kessler` + `internal/design-rules/sofia-kessler-caracterisation.md` (5 axes canon) + `overview.md § Cast` + `history.md L378-396 (NODE A1-XX FLAG_SOFIA_ALLIEE)` + `history.md L795-805 (FIN-E Sofia « L'Acte éthique »)`.

---

## Métadonnées

```yaml
pnj_id: sofia
tier: 2
corpo: nexus
sprite_set: char_sofia_*.png
voix_dialogic_id: sofia
prenom_var: sofia_prenom
```

---

## Verrous canon (sacrés)

> ⚠ **Référence absolue** : `internal/design-rules/sofia-kessler-caracterisation.md` (5 axes canon non négociables). Cette section reformule en verrous opérationnels — toute contradiction doit être tranchée en faveur du design-rule.

1. **Identité trans connue, intégrée, jamais le sujet d'une scène**. Tous les résidents savent depuis longtemps. Pronoms `elle`, vocabulaire actuel. **Pas d'outing, pas de révélation, pas de plot-point**. *Axe 1 design-rule*. Toute scène qui *« révèle »* l'identité trans de Sofia ou la met en abyme = violation canon.

2. **Couple Sofia × Alex solide, démonstratif, transparent**. **Alex est partie de l'intégration trans de Sofia en milieu corpo conservateur** — perdre Alex = perdre une infrastructure protectrice, pas juste un partenaire. Toute écriture qui montre le couple comme façade ou comme accessoire viole canon. *Axe 2 + 5 design-rule*.

3. **Vigilante éthique paradoxale : sincère + structurellement complice**. Sofia croit en ce qu'elle dit ET sait que Nexus exploite sa posture. Tension permanente. Registre vocal : **analytique → accusatrice → protectrice** *(canon bible-jeu L561, table registres)*. Pas chaleureuse, méfiante par défaut. *Axe 3 design-rule*.

4. **Force pro ≠ force intime**. Sofia tient sa posture d'autorité éthique au travail (Nexus, immeuble, audits) — c'est sa force *publique, travaillée*. En intimité (couple Alex, blessure affective, romance Margot intrusive), elle est plus exposée. **Implication d'écriture absolue** : ne jamais écrire Sofia en posture *« autorité éthique »* face à une blessure intime. Ordre obligatoire : **elle vacille d'abord, se reprend après, jamais en simultané**. *Axe 4 design-rule*. C'est le verrou le plus fréquemment violé en review — vérifier explicitement.

5. **Approche par alignement éthique démontré, pas par séduction**. Pour gagner Sofia : Margot doit *fournir des preuves d'intégrité* (refuser un mensonge, protéger un PNJ, publier sans cacher la source) *en présence* ou *de manière vérifiable par* Sofia. Pas exiger qu'elle accorde sa confiance sur déclaration — Sofia teste, ne croit pas sur parole. *Axe 3 design-rule + canon history L378-396*.

6. **Alliance tacite avec Frank — professionnelle, pas romantique**. Power Tag canon. Parallèle au couple Sofia/Alex, n'entre pas en collision. Sofia et Frank échangent des regards silencieux en zone commune, partagent une éthique tactique. Pas d'amorce romance Frank/Sofia. *Cf. pnjs-behavior/frank.md Coordination cross-PNJ*.

7. **Si A2-romance-alex branche opt-in déclenchée** *(`flag_alex_franchi = true`)* : Sofia est blessée **en intimité**, jamais en posture pro. Le lendemain au travail, elle reste l'autorité éthique inattaquable. Toute scène qui montre Sofia défaillante au boulot après trahison Alex = violation canon. *Axe 4 + design-rule explicite*.

**Sensitivity reader OBLIGATOIRE** : *playtester-lgbtqia* + `sofia-kessler-caracterisation` à **chaque scène avec Sofia**, particulièrement :
- Tout événement de seuil ≥ Favorable
- Toute scène intime (cellule_nuit avec Sofia injectée, poste_technique, appart)
- La coda `event_sofia_blessee_intime` (branche opt-in Alex)
- L'événement `event_sofia_alignement_test` (test éthique)

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *quasi-inaccessible* — requiert dénonciation publique de Sofia OU outing involontaire par Margot | accusatrice, distance pro irrévocable | Présence ostensible, pas de regard, contact via canaux Nexus officiels |
| Hostile | Si Margot a violé l'éthique de manière flagrante en présence de Sofia *(mensonge prouvé, instrumentalisation d'un autre résident)* | analytique → accusatrice | Distance physique, regard direct mais glacé |
| Méfiance *(défaut au dîner)* | Posture éthique reconnue, pas chaleureuse | *« Je vois »*, *« Je vais probablement »*, *« Pas pour censurer »* | Regard direct, pose les couverts pour parler, droit dans les yeux |
| Neutre | Politesse pro, observation soutenue | *« On en reparlera. Ou pas. »* | Présence calme, peu de mouvements parasites |
| Favorable | Test éthique réussi 1 fois, Sofia ouvre la porte | *« Tu sais ce que ça veut dire »*, propose des termes éthiques | Regard plus long, demi-sourire bref |
| Allié *(`flag_sofia_alliee = true` canon)* | Test intégrité majeur réussi — Sofia accepte de partager des moyens | *« Je peux bloquer un rapport »*, *« On peut faire ça ensemble »* | Présence engagée, peut s'asseoir face à Margot |
| Proche | Confiance affective au-delà du pro — Sofia laisse voir une vulnérabilité *(en intimité, jamais au boulot — verrou 4)* | *« Ça pèse »*, *« Je n'ai pas dit tout »*, partage personnel mesuré | Pose les mains, peut soupirer, regard qui s'attarde |
| Confident *(plafond canon — ouvre FIN-E Sofia)* | Sofia transmet l'ultime moyen *(dossier comité éthique Nexus)* | *« J'aurais dû faire ça depuis le début. Je t'attendais peut-être. »* | Présence assumée, regard direct, voix descendue |
| Fusionnel | *quasi-inaccessible* — Sofia garde toujours son paradoxe éthique, ne se fond pas | — | — |

---

## Événements de seuil

### `event_sofia_alignement_test` — *scénique, premier test éthique*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - `relation:sofia ≥ Méfiance` *(≥ +5 typiquement, canon history L378)*
  - Scène en privé OU semi-privé OU croisement isolé *(zone commune permet aussi)*
  - Sofia *initie* — c'est elle qui pose la question éthique
- **Mode** : immédiat dans la scène où les conditions s'alignent
- **Réaction scriptée** *(résumé, canon history L378-396)* :
  > Sofia interpelle Margot sur ses propres méthodes documentaires. *« Tu films comment ? Avec ou sans consentement ? Et quand tu vois quelque chose que tu ne devrais pas voir, tu fais quoi ? »* — test direct, sans hostilité, sans aménité.
- **3 choix Margot** *(canon history L383-396)* :
  - `[A]` Répondre avec intégrité sur ses propres limites *(reconnaît qu'elle n'a pas toujours filmé proprement)* → `relation:sofia:+20:test_integrite_reussi · flag_sofia_alliee = true · EV+1`
  - `[B]` Défense liberté de la presse *(intellectuel mais évasif sur ses limites)* → `relation:sofia:+5 · EV+1` *(Sofia accepte mais reste sur sa réserve)*
  - `[C]` Esquiver la question *(détournement)* → `flag_sofia_suspecte_methodes = true · relation:sofia:-10` *(ferme alliance profonde — verrou Sofia, pas de seconde chance frontale)*
- **Note canon** : c'est **l'événement déclencheur de `flag_sofia_alliee`** — pas un palier-seuil classique, un test scénique unique. La canon ne prévoit pas de re-déclenchement.

### `event_sofia_allie` — palier Allié franchi (post-`flag_sofia_alliee`)

- **Type** : montée, one-shot
- **Conditions** :
  - `flag_sofia_alliee = true` *(posé par event_sofia_alignement_test [A])*
  - `relation:sofia` franchit Allié *(≥ +40 effective après test)*
  - + contexte : scène à 2 *(privé ou semi-privé), Sofia disponible (pas en mission Nexus off-screen)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Sofia propose à Margot une alliance opérationnelle concrète : *« Je peux bloquer un rapport Memorize sur toi en Acte III. Pas tout le temps, pas plusieurs. Une fois. À toi de choisir quand. »* — c'est la transformation du test éthique en levier mécanique.
- **Déverrouille** :
  - sujet `demander_blocage_sofia` en A3 *(usage unique : `EV+2 · flag_sofia_blocage_utilise = true`, Sofia épuise son crédit Nexus pour cet acte)*
  - flag `flag_sofia_alliance_op_active = true`
  - hook coda A4 : Sofia peut témoigner pour Margot dans certaines fins *(FIN-B notamment)*

### `event_sofia_proche` — palier Proche franchi *(vulnérabilité intime visible)*

- **Type** : montée, one-shot
- **Conditions** *(toutes requises)* :
  - `relation:sofia` franchit Proche *(≥ +50)*
  - `flag_sofia_alliance_op_active = true`
  - Contexte : **scène intime uniquement** *(appart_sofia_alex avec Alex absent ; ou poste_technique tardif ; ou cellule_margot_nuit si Sofia injectée — situation rare)*
  - **Pas pendant scène pro** *(verrou 4 : force pro ≠ force intime — l'événement n'est jouable qu'en contexte intime)*
- **Mode** : différé strict — buffer jusqu'à ce qu'un contexte intime se présente
- **Réaction scriptée** *(résumé)* :
  > Sofia laisse voir, brièvement, le coût de tenir sa posture éthique. *« Ça pèse, parfois. Tu sais ce que c'est, je crois. Tenir une posture publique quand l'intime sait que c'est plus compliqué. »* — référence indirecte qui peut s'appliquer à *tenir une identité trans en milieu corpo conservateur* OU *tenir Margot en posture journaliste face à Witness* OU *tenir Sofia en posture éthique face à Nexus structurellement complice* — **ambiguïté volontaire**, Sofia ne précise pas, Margot ne demande pas.
- **Verrou d'écriture** : Sofia ne nomme **jamais** sa propre identité trans dans cette réplique. Le *« tu sais ce que c'est »* renvoie à *toute identité publique tenue contre une intimité plus complexe* — le joueur queer entendra une chose, le joueur cis-hétéro une autre, les deux lectures sont canon.
- **Déverrouille** :
  - sujet `parler_de_l_effort_sofia` dans toutes scènes intimes ultérieures
  - flag `flag_sofia_vulnerabilite_partagee = true`

### `event_sofia_confident` — palier Confident franchi *(plafond canon, ouvre FIN-E Sofia)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:sofia` franchit Confident *(≥ +60)*
  - `flag_sofia_alliance_op_active = true`
  - **Couple Sofia/Alex en l'état** : soit intact, soit brisé *(si `flag_alex_franchi = true`, événement est encore jouable mais avec coloration différente — voir cas spécial)*
- **Mode** : différé
- **Réaction scriptée** *(résumé, canon history L803)* :
  > Sofia transmet le **dossier complet du comité éthique Nexus** — preuve que le département éthique a validé l'expérience Nexus Social en connaissance de cause. C'est le scandale éthique le plus dévastateur disponible dans le jeu.
  >
  > *« J'aurais dû faire ça depuis le début. Je t'attendais peut-être. »*
- **Déverrouille** :
  - coda FIN-E Sofia *(« L'Acte éthique »)* accessible si `relation:sofia ≥ +60`
  - `EV+3:dossier_comite_ethique` — gain d'EV majeur, le plus gros du jeu
  - flag `flag_sofia_dossier_transmis = true`
  - **Conséquence canon** : Sofia perd sa carrière Nexus à terme. Pose `flag_sofia_carriere_finie = true` *(comparable à `flag_frank_carriere_finie` — sacrifice symétrique des deux Stratom/Nexus alliés profonds)*.

### `event_sofia_blessee_intime` — *scénique forcé par branche opt-in Alex*

- **Type** : événement scénique conditionnel **automatique** *(pas joueur-initié — déclenché par `event_alex_franchi_optin`)*
- **Conditions de déclenchement** :
  - `flag_alex_franchi = true` *(posé par `pnj-behavior:alex § event_alex_franchi_optin`)*
  - Scène suivante avec Sofia, matin *(canon : Alex a dit la vérité à Sofia off-screen — verrou transparence Alex)*
- **Mode** : immédiat — joué dans la scène matin post-trahison
- **Réaction scriptée canon** *(résumé)* :
  > Sofia confronte Margot **en intimité** *(appart Sofia/Alex matin, ou poste_technique avant heures pro)*. Voix structurée, pas larmes. *Pose la tablette*. Reste debout — pas en posture d'autorité éthique, en posture **adulte blessée**.
  >
  > *« Tu savais ce que tu faisais. Je ne te demande pas pardon, je te demande de partir. »*
- **2 choix Margot** *(canon arc archivé `A2-romance-alex § Beat 5B.2`)* :
  - `[A]` Reconnaître la responsabilité (*« J'ai poussé. »*) → `flag_margot_assume_trahison = true · mirror:-5:reconnaissance · relation:sofia:-25 · relation:alex:-15`
  - `[B]` Se défendre / minimiser → `flag_margot_nie_trahison = true · mirror:+10:negation · relation:sofia:-40 · relation:alex:-25`
- **Verrou d'écriture absolu** : Sofia **ne pleure pas**, **ne s'effondre pas**, **ne parle pas de son identité trans**. Elle est blessée *en intimité*, pas *en identité*. Au boulot le lendemain, elle restera l'autorité éthique inattaquable. *Cf. verrou 4 + axe 4 design-rule*.
- **Conséquence canon** :
  - Couple Sofia/Alex brisé *(`flag_couple_sofia_alex_brise = true`)*
  - L'appartement Sofia/Alex se ferme à Margot indépendamment du palier *(cf. `pnjs-behavior/alex.md § Seuils d'accès`)*
  - Sofia conserve son palier actuel mais **plafonne à Allié maximum** pour le reste du run *(plafonnement post-trahison — la confiance intime ne se reconstruit pas dans un run)*

### `event_sofia_alliance_frank_visible` — *scénique récurrent discret*

- **Type** : événement d'ambiance récurrent *(pas one-shot — peut se jouer plusieurs fois en arrière-plan)*
- **Conditions** :
  - Scène = zone commune ou couloir
  - Sofia ET Frank présents simultanément
  - Pas de cap — c'est un détail d'arrière-plan qui colore les scènes
- **Effet** :
  - Détail narratif : un regard échangé entre Sofia et Frank, silencieux, à propos de Margot ou d'un autre PNJ. Le joueur attentif voit l'alliance tacite *(Power Tag canon)*.
  - Aucun delta de jauge. Aucun flag posé. C'est de la mise en scène d'ambiance.
- **Note canon** : cette alliance est **professionnelle/éthique**, jamais romantique (verrou 6). Toute écriture qui glisse vers une suggestion romantique Sofia/Frank viole canon.

---

## Hooks scènes

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Méfiance : *« Département éthique Nexus. Je vérifie que la collecte passive reste dans le cadre. »* + regard direct dans les yeux |
| `zone_commune_jour` *(à spec)* | variable selon état Sofia | `event_sofia_alignement_test` peut s'y déclencher ; `event_sofia_alliance_frank_visible` en arrière-plan si Frank présent |
| `cellule_nuit` ✅ | audible via mur *(canon : intimité Sofia/Alex à voix basse, registre couple)* | À haut palier *(Confident)* + flag spécial : Sofia peut frapper à la porte de Margot — événement rare |
| `coursive_residents_nuit` *(à spec)* | rare | Sofia patrouille discrètement Nexus le soir — possible croisement test éthique |
| `poste_technique_alex_sofia` *(à spec, semi-privé `palier:sofia ≥ Favorable`)* | systématique heures pro | Hub de `event_sofia_allie` et `event_sofia_proche` selon palier |
| `appart_sofia_alex` *(à spec, privé)* | systématique si gating respecté | `event_sofia_proche` et `event_sofia_confident` peuvent s'y jouer ; **fermé si `flag_alex_franchi = true`** |
| `verdict_frank` *(A3, à spec)* | présence en arrière-plan possible | Si Sofia présente : regard échangé avec Frank (`event_sofia_alliance_frank_visible`) |
| `confrontation_camille` *(A3, à spec)* | rare | Sofia peut intervenir si `flag_sofia_alliance_op_active = true` ET `relation:sofia ≥ Allié` |
| `coda_finale` *(A4)* | variable selon `flag_sofia_*` | FIN-E Sofia *« L'Acte éthique »* ; FIN-B avec témoignage Sofia ; FIN-G silence Sofia ; coda blessée si `flag_alex_franchi = true` |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `poste_technique_alex_sofia` | semi-privé *(partagé Nexus)* | `palier:sofia ≥ Favorable` OU `palier:alex ≥ Favorable` *(cf. `pnjs-behavior/alex.md`)* |
| `appart_sofia_alex` | privé *(couple Sofia/Alex)* | `palier:sofia ≥ Allié` ET **couple intact** *(`flag_alex_franchi = false`)*. **Verrou post-trahison** : si `flag_alex_franchi = true`, l'appart se ferme à Margot indépendamment du palier — cohérent avec `pnjs-behavior/alex.md` |

---

## Risques structurels

1. **Sofia en autorité éthique simultanée à une blessure intime**. Verrou le plus violé en review. Risque haut dans `event_sofia_proche`, `event_sofia_confident`, et surtout `event_sofia_blessee_intime` *(branche opt-in Alex)*. Mitigation : **vérification systématique** que toute scène intime Sofia se joue **en intimité explicite** *(lieu privé, hors heures pro, gestes domestiques)*, jamais dans son bureau ni en posture professionnelle. La scène de blessure post-Alex doit la montrer *en peignoir / chez elle / au matin*, jamais en train de signer un audit. Cf. design-rule § How to apply (e).

2. **Identité trans qui devient sujet de scène**. Risque permanent — la moindre mention explicite *« en tant que femme trans »* viole canon. Mitigation : toute évocation de Sofia comme *« quelqu'un qui tient une posture »* doit rester **ambiguë** *(applicable à toute identité publique tenue contre une intimité plus complexe)*. Cf. `event_sofia_proche` réplique canon. Vérification *playtester-lgbtqia* obligatoire.

3. **Romance Sofia trop facile / séduction au lieu d'éthique**. Si l'arc romance Sofia s'enclenche par charme ou attirance, c'est cassé. Mitigation : toute progression palier Sofia est conditionnée à **preuves d'intégrité fournies** *(canon `event_sofia_alignement_test` puis `event_sofia_allie`)*. Pas de gain palier par flatterie ou par sujet *« demander à Sofia ses opinions »* sans acte démontré. Vérifier en `dramaturge`.

4. **Coordination couple Sofia/Alex pendant branche opt-in**. Si `event_alex_franchi_optin` déclenché, `event_sofia_blessee_intime` doit s'enchaîner **automatiquement** dans la scène suivante — pas de skip possible. Risque que le joueur évite cette confrontation en évitant les scènes Sofia. Mitigation : le matin post-trahison, Sofia *initie* la confrontation publiquement *(message, croisement forcé)*, Margot ne peut pas l'esquiver narrativement.

5. **Sofia comme « PNJ queer du chapitre »**. Risque trope. Sofia n'est pas un personnage *« représentation »* — elle est un personnage *à part entière* avec ses verrous canon, dont l'identité trans est un fait, pas un thème. Mitigation : passage obligatoire `playtester-lgbtqia` + `sofia-kessler-caracterisation` avant toute production .dtl la concernant.

---

## Validation locale

- [x] 9 paliers couverts (Ennemi juré quasi-inaccessible justifié, Fusionnel quasi-inaccessible — Sofia garde son paradoxe éthique)
- [x] 5 événements de seuil + 1 événement scénique forcé (blessee_intime) + 1 événement d'ambiance récurrent (alliance_frank_visible)
- [x] Verrous canon explicites (7) alignés avec `bible-jeu.md` + `sofia-kessler-caracterisation.md` (5 axes design-rule)
- [x] Hooks scènes pointent vers scenes existantes (`diner_arrivee` ✅, `cellule_nuit` ✅) ou à créer
- [x] **Sensitivity reader OBLIGATOIRE** identifié pour chaque scène + événement (playtester-lgbtqia + sofia-kessler-caracterisation)
- [x] Seuils d'accès aux espaces privés cohérents avec `pnjs-behavior/alex.md`
- [x] Coordination cross-PNJ : Alex (couple, blessure intime), Frank (alliance tacite pro), Emma (révélation Alex possible), Camille (Sofia observée par profileuse)

---

## Validation Sofia dans `diner_arrivee.dtl` (audit retroactif)

| Réplique `.dtl` | Palier supposé | Verrou respecté ? |
|-----------------|----------------|-------------------|
| *« Merci de l'avoir dit ici. Pas obligée. »* *(presentation [A] honnêteté)* | Méfiance | ✓ adulte, respectueux, sans chaleur excessive |
| *« Lead européen, vraiment ? »* + *« Je vais probablement voir tes rushes. Pas pour censurer. »* *(presentation [C] mensonge échec)* | Méfiance | ✓ verrou *force pro* tenue, calling out sans hostilité, citation canon bible-jeu L480 textuelle |
| *« Département éthique Nexus. Je vérifie que la collecte passive reste dans le cadre. »* + *« Tu sais ce que ça veut dire, collecte passive ? On en reparlera. Ou pas. »* *(demander_role_sofia)* | Méfiance/Neutre | ✓ vocabulaire pro, regard direct, registre canon |
| *« Sofia hoche. Je vais probablement voir tes rushes. Pas pour censurer. »* *(evoquer_witness)* | Méfiance | ✓ flag_sofia_signale_protection cohérent avec verrou 2 (Sofia protège quand elle le peut) |

**Verdict** : le `.dtl` `diner_arrivee` respecte intégralement les 7 verrous canon de Sofia. **Aucune correction nécessaire**.

---

## Coordination cross-PNJ

- **Avec `pnjs-behavior/alex.md` ✅** : couple solide transparent. Si `event_alex_franchi_optin` se joue, `event_sofia_blessee_intime` enchaîne automatiquement. Verrou *force pro ≠ force intime* respecté côté Sofia.
- **Avec `pnjs-behavior/frank.md` ✅** : alliance tacite professionnelle, jamais romantique. `event_sofia_alliance_frank_visible` est un détail d'ambiance récurrent (pas one-shot) — peut se jouer plusieurs fois dans `zone_commune_jour` et `verdict_frank`.
- **Avec `pnjs-behavior/camille.md` ✅** : Camille profile Sofia *(par défaut)*. Sofia le sait (Power Tag *« lecture rapide des contrats »*). Tension professionnelle latente — pas frontale, mais le silence Sofia/Camille en zone commune n'est pas neutre.
- **Avec `pnjs-behavior/emma.md` ✅** : Sofia peut révéler Alex à Margot si `relation:sofia > +50` *(canon `history.md L511`)*. Emma et Sofia ne se connaissent pas particulièrement — interaction polie, pas d'alliance.
