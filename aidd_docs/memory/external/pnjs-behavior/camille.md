# PNJ Behavior — `camille`

> *La profileuse · STRATOM · 32 ans · femme · Tier 2*
> Source canon : `bible-jeu.md § Camille Armand` + `overview.md § Cast` + `history.md L484-501 (NODE A2-05 Confrontation Camille)`.

---

## Métadonnées

```yaml
pnj_id: camille
tier: 2
corpo: stratom
sprite_set: char_camille_*.png
voix_dialogic_id: camille
prenom_var: camille_prenom
```

---

## Verrous canon (sacrés)

1. **Dark cogni-affectif, jamais physique**. Toute attaque/séduction de Camille passe par *les mots, l'asymétrie d'information, le profilage*. Aucune emprise corporelle. Aucune sexualisation explicite. *Cf. `overview.md § Anti-patterns d'écriture : Romance Camille avec emprise physique → refus en review`.*

2. **Couple Camille × Frank glacial mais réel**. Aucune façade — vraie relation longue durée devenue silencieuse par routine et contrôle mutuel (profileuse + ex-opératif qui se lisent en permanence). **Pas de mystère à élucider** dans le couple ; à écrire avec retenue, pas comme une intrigue. *Cf. `history.md L941`.*

3. **Camille ne s'effondre pas en hostilité**. Même démasquée, elle garde son calme professionnel. *Les paliers Ennemi juré et Hostile sont inaccessibles canon.* Si Margot l'attaque frontalement et que Camille recule, c'est en *Méfiance* avec retrait diplomate, pas en colère.

4. **Camille ne va jamais à Fusionnel**. *La fusion implique perte de soi dans l'autre — incompatible avec la nature professionnelle de Camille.* Plafond palier maximal canon = **Confident** *(au sens dark cogni-affectif : complicité dans le profilage)*.

5. **Camille a profilé Margot dès la première rencontre**. Son cliffhanger au dîner d'arrivée n'est pas une question anodine — c'est une *première sonde*. Tout dialogue qui montre Camille découvrant Margot tardivement viole canon.

6. **Weakness Tag actif** : *« Margot reconnaît ses techniques (trauma Julien) »*. Margot peut nommer le profilage et déstabiliser Camille — c'est l'angle d'attaque canonique. Implémenté dans `A2-05 Confrontation Camille [B]` (cf. history.md L488).

**Sensitivity reader requis** : oui — *playtester-margot* (consentement informationnel sur la dark cogni-affectif) + *playtester-lgbtqia* (vérifier que la séduction-outil ne tombe pas dans un stéréotype) à chaque événement de seuil ≥ Favorable.

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | **inaccessible canon** — Camille reste professionnelle | — | — |
| Hostile | **inaccessible canon** | — | — |
| Méfiance | Diplomate distante, courtoise glaciale | *« Je vois »*, *« D'accord »*, *« On a le temps »* | Sourire de façade, regard qui glisse, range sa tablette |
| Neutre *(défaut au dîner)* | Chaleureuse en surface, profilage permanent en sous-texte | *« Oh ! »*, *« Parle-nous »*, *« Intéressant »* | Sourire ouvert, mais yeux qui calculent ; consulte tablette « une seconde de trop » |
| Favorable | Curieuse pro, intéressée par le matériau Margot | *« On a peut-être des choses à se dire »*, *« Tu écris sur les gens »* | Pose la tablette, regard direct, attention soutenue |
| Allié | Complice tacite *(rare — Margot doit avoir reconnu le jeu sans le rompre)* | *« Toi et moi »*, *« Disons que »*, métaphores du métier | Mains posées, voix descendue d'une demi-octave |
| Proche | Fascination personnelle qui dépasse le pro | *« Tu n'es pas comme les autres »*, abandons de précautions corporatistes | Inclinaison du buste, proximité spatiale assumée *(sans contact)* |
| Confident | Dark cogni-affectif consommé : Camille et Margot pratiquent ensemble la lecture des autres | échanges en sous-texte, complicité du profilage, ironie partagée | Présence calme, silences qui en disent, regards échangés sur les autres résidents |
| Fusionnel | **inaccessible canon** *(plafond Confident — fusion = perte de soi, incompatible)* | — | — |

---

## Événements de seuil

### `event_camille_cliffhanger` — premier sondage *(scène-anchored, pas palier-anchored)*

- **Type** : événement scénique conditionnel one-shot *(pas un seuil de palier — déclencheur lié au déroulement de la scène `diner_arrivee`)*
- **Conditions de déclenchement** :
  - Scène en cours = `diner_arrivee`
  - `flag_diner_presentation_choisie = true`
  - Choix de présentation ∈ `{[A] honnêteté, [C] mensonge, [D] évasif}` *(pas si `[B]` pro propre — Camille trouve Margot trop lisse pour qu'il vaille le coup)*
  - `flag_event_camille_cliffhanger_consomme = false`
- **Mode** : immédiat en outro de `diner_arrivee`
- **Réaction scriptée** *(canon citation : `bible-jeu.md L438`)* :
  > *« Parle-nous un peu de toi. Tu viens d'où ? »*
  >
  > La pièce se fige. Tu entends une horloge quelque part. Tu n'avais pas entendu l'horloge avant.
- **Déverrouille** :
  - flag `flag_camille_cliffhanger_pose = true` *(lu par scenes A1-06+ pour colorer la perception Camille)*
  - décision `diner_cliffhanger_camille` enregistrée dans `GameStateManager.decisions`

### `event_camille_favorable` — palier Favorable franchi

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:camille` franchit Favorable (≥ +20 typiquement)
  - + Margot a posé au moins 1 acte qui *intéresse* Camille pro *(observation silencieuse au dîner, mensonge réussi, ou question pointue sur le profilage)*
- **Mode** : différé *(buffered si conditions contexte pas remplies au franchissement)*
- **Réaction scriptée** *(résumé)* :
  > Camille s'arrête à hauteur de Margot dans la zone commune. Pose la tablette. *« Tu écris sur les gens, c'est ça ? On a peut-être des choses à se dire. »* — sans avancer plus, mais elle a transformé une politesse en proposition.
- **Déverrouille** :
  - sujet `parler_avec_camille_profilage` dans `zone_commune_jour` et `coursive_residents_nuit` — Margot peut désormais aborder le profilage comme sujet
  - flag `flag_camille_a_propose_echange = true`

### `event_camille_allie` — palier Allié franchi

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:camille` franchit Allié (≥ +40)
  - + `flag_camille_a_propose_echange = true`
  - + contexte : scène avec Camille en privé OU semi-privé (`salon_camille`, croisement nocturne)
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Camille teste : elle propose à Margot de lire un autre résident avec elle *(typiquement Marine, la plus lisible)*. *« Regarde-la. Le sourire crispé, là, juste avant le rire. Tu vois ce qu'elle protège ? »* — c'est une invitation à devenir complice du profilage.
- **Déverrouille** :
  - sujet `lire_un_resident_avec_camille` *(cible : Marine, Thomas, Léo, ou Emma — selon état des relations)* — Margot choisit d'accepter ou refuser. Accepter pose `flag_camille_complicite_active = true` et fait gagner `EV+1` *(elle apprend des choses par Camille)* mais aussi `mirror+10:complicite_profilage` *(instrumentalisation des autres résidents)*.
  - flag `flag_camille_a_teste_complicite = true`
- **Verrou** : si Margot refuse, palier reste à Allié sans monter. Camille reprend sa distance professionnelle.

### `event_camille_demasquee_test` — Margot reconnaît le profilage *(scène-anchored, pas palier-anchored)*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - Scène = `A2-05 confrontation_camille` *(à spec)* OU `salon_camille` *(si accessible)*
  - Margot pose le sujet `nommer_le_profilage_camille` *(disponible si `flag_event_camille_favorable_consomme = true` OU `EV ≥ 3`)*
  - Vérification cachée : réussite si `relation:camille ≥ Allié` OU `mental_stability ≥ 4`
- **Mode** : immédiat
- **Réaction scriptée** *(résumé, canon citation `history.md L488-493`)* :
  > *Réussite* : Camille marque un temps. *« Bien vu. »* — Et c'est tout. Aucune émotion lisible. Mais quelque chose a basculé : `flag_camille_demasquee = true · flag_camille_fascination = true · countdown:equipe_nettoyage:-1 · relation:camille:-10`.
  > *Échec* : Camille retourne l'accusation avec la même chaleur qu'avant. *« Tu projettes peut-être un peu, Margot. Ton ex faisait ça ? »* — `ms:-1:projection_retournee · pd:+1:vulnerabilite_exposee`.
- **Déverrouille** *(réussite uniquement)* :
  - sujet `pousser_camille_a_se_decouvrir` en `A3` *(scène à spec)*
  - colore les codas FIN-E Camille *(la dark romance devient *« deux profileuses qui se reconnaissent »* au lieu de *« profileuse séduit cible »*)*

### `event_camille_dark_proposition` — palier Confident franchi *(plafond canon)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:camille` franchit Confident (≥ +60)
  - + `flag_camille_complicite_active = true` OU `flag_camille_demasquee = true` *(deux chemins d'accès au plafond canon)*
  - + contexte : `salon_camille` la nuit OU `confrontation_camille` au pic
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Camille pose les mots calmement, sans poser les mains. *« Ce que je te propose, ce n'est pas ce que tu crois. Reste. Pas comme objet. Comme miroir. »* — c'est l'invitation à la dark cogni-affectif consommée : alliance cognitive avec Stratom *via* Camille, asymétrie d'information acceptée des deux côtés.
- **Déverrouille** :
  - ouvre la coda FIN-E Camille *(palier:camille ≥ Confident + flag_camille_fascination = true)* — *« Retournement profilage »* canon : la fin Camille existe.
  - pose `flag_camille_proposition_dark = true`. Margot peut accepter *(verse `mirror+25:choix_camille` mais débloque ressources Stratom-internes pour FIN-E)*, refuser *(pose `flag_camille_proposition_refusee = true`, relation cap Confident inchangée, Camille reprend sa distance professionnelle sans hostilité)*.

### `event_camille_obsession` — Weakness Tag activé *(rare, descente conditionnelle)*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - `flag_camille_fascination = true` *(posé par event_demasquee_test ou event_dark_proposition)*
  - + `relation:sofia ≤ Méfiance` OU `flag_camille_proposition_refusee = true` *(Margot a refusé la dark proposition)*
  - + acte A3+ *(pas avant — Camille ne se laisse pas obséder en A1)*
- **Mode** : immédiat dans la prochaine scène où Camille est présente
- **Réaction scriptée** *(résumé)* :
  > Camille perd son calme professionnel pour la première fois. Elle a *préparé* la rencontre — change quelque chose dans son apparence, dans sa voix. *« Margot. On peut parler ? Pas en pro. »* — la Weakness Tag canonique *« obsession »* (cf. `bible-jeu.md L430`) s'active.
- **Effet** :
  - Pose `flag_camille_obsession_active = true`
  - Margot peut choisir d'exploiter *(`mirror+15:exploitation_obsession · countdown:equipe_nettoyage:-2`)* ou de désamorcer *(`ms+2:retrait_ethique · relation:camille:-15`)*
- **Verrou canon** : c'est **la** scène où Camille perd l'autorité morale (cf. Weakness Tag). Ne peut pas se répéter dans le run.

---

## Hooks scènes

Scènes-types où Camille apparaît typiquement (`scenes/*.md` ou à spec) :

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Neutre : chaleur + scan permanent. Outro : `event_camille_cliffhanger` si conditions. |
| `zone_commune_jour` *(à spec)* | toujours, croisement matinal | Méfiance/Neutre : politesse glaciale. Favorable+ : amorce conversation pro. Allié+ : peut initier `event_camille_allie`. |
| `coursive_residents_nuit` *(à spec)* | rare *(silence Camille/Frank canon)* | Si croisée : un mot, regard. Peut révéler le silence du couple. |
| `salon_camille` *(à spec, gated `palier:camille ≥ Confident`)* | espace privé | Confident requis pour entrer — c'est *le* lieu d'`event_camille_dark_proposition`. |
| `confrontation_camille` *(A3, à spec)* | scène pivotale A3 | Pic narratif : Margot peut nommer (réussir `event_camille_demasquee_test`), ou subir. |
| `coda_finale` *(A4)* | systématique *(au moins voix off)* | Selon `flag_camille_*` accumulés : coda FIN-E Camille, FIN-B alliée tacite, FIN-G silence, etc. |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `salon_camille` | semi-privé *(salon de réception Camille — distinct de l'appart Camille/Frank)* | `palier:camille ≥ Favorable` |
| `appart_camille_frank` | privé *(intimité couple glaciale, accès tardif)* | `palier:camille ≥ Confident` OU `palier:frank ≥ Confident` |

---

## Risques structurels

1. **Tropé "femme manipulatrice sexualisée"**. Le canon est strict : *dark cogni-affectif jamais physique*. Risque haut si une scène glisse vers de la séduction physique (geste, contact, etc.). Mitigation : la voix par palier Proche/Confident **ne décrit jamais de contact physique** ; toute proposition Camille passe par les **mots**. Passage obligatoire `playtester-margot` + `playtester-lgbtqia` à chaque scène ≥ Favorable. Anti-pattern listé dans `overview § Anti-patterns d'écriture`.

2. **Camille trop transparente pour le joueur**. Si le profilage de Camille est trop signalé textuellement, le sous-texte se perd. Mitigation : la voix Neutre/Favorable doit lire comme *« femme chaleureuse qui s'intéresse »* en première lecture ; ce sont les détails sensoriels *(tablette consultée « une seconde de trop », sourire « +1/2 millimètre »)* qui signalent au lecteur attentif. Pas de narration explicite *« Camille profile Margot »* sauf en `event_demasquee_test` où c'est nommé.

3. **Cohérence couple Camille/Frank**. Risque que les scènes en intime avec Camille fassent oublier Frank. Mitigation : tout `event_camille_*` ≥ Allié doit faire une *micro-mention* du silence Camille/Frank (Frank off-screen mentionné, silence à la maison évoqué, etc.). Pas de scène intime Camille sans cette tension de fond. À vérifier en `review-persona dramaturge`.

---

## Validation locale

- [x] 9 paliers couverts (3 marqués inaccessibles canon : Ennemi juré, Hostile, Fusionnel — avec justification)
- [x] 5 événements de seuil + 1 cliffhanger scénique = 6 événements (Cliffhanger, Favorable, Allié, Demasquee-test scénique, Dark-proposition Confident, Obsession Weakness)
- [x] Verrous canon explicites et alignés avec `bible-jeu.md` + `overview.md § Anti-patterns`
- [x] Hooks scènes pointent vers `scenes/diner_arrivee.md` ✅ existant + scenes/ à créer (`zone_commune_jour`, `coursive_residents_nuit`, `salon_camille`, `confrontation_camille`)
- [x] Sensitivity reader identifié : `playtester-margot` + `playtester-lgbtqia` obligatoires à partir de Favorable
- [x] Seuils d'accès aux espaces privés déclarés (Favorable pour salon, Confident pour appart couple)

---

## Validation Camille dans `diner_arrivee.dtl` (audit retroactif)

L'audit `auditeur-scene` du `.dtl` premier dîner avait vérifié Camille contre `bible-jeu.md` directement. Re-vérification contre cette fiche `pnj-behavior:camille` :

| Réplique `.dtl` | Palier supposé | Verrou respecté ? |
|-----------------|----------------|-------------------|
| *« Margot. Présente-toi, qu'on te connaisse un peu. »* | Neutre | ✓ chaleureuse + sondage |
| Sourire élargi d'un demi-millimètre, range quelque chose *(presentation [A])* | Neutre | ✓ détail sensoriel, profilage en sous-texte |
| *« Witness… intéressant choix. »* sourire fin *(evoquer_witness)* | Neutre | ✓ note prise, pas hostile |
| *« Profilage comportemental, Stratom. Je lis les gens. »* + *« On a peut-être des choses à se dire »* *(demander_role_camille)* | Neutre | ✓ amorce vers Favorable, pas encore là |
| *« Camille consulte sa tablette une seconde de trop »* *(observer_silence)* | Neutre | ✓ détail sensoriel canon |
| Cliffhanger *« Parle-nous un peu de toi. Tu viens d'où ? »* | Neutre + `event_camille_cliffhanger` | ✓ citation canon exacte |
| *« On a le temps. »* *(presentation [D] évasif)* | Méfiance amorce | ✓ retrait diplomatique |

**Verdict** : le `.dtl` `diner_arrivee` respecte intégralement les verrous canon de Camille. Aucune correction nécessaire sur Camille dans `diner_arrivee.dtl`.
