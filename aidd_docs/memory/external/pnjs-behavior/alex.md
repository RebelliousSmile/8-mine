# PNJ Behavior — `alex`

> *Le double agent · NEXUS → STRATOM · 29 ans · homme · Tier 2*
> Source canon : `bible-jeu.md § Alex Norvège` + `overview.md § Cast` + `history.md § NODE A2-06 Révélation Alex` + arc-spec archivé `_archive/A2-romance-alex.md`.

---

## Métadonnées

```yaml
pnj_id: alex
tier: 2
corpo: nexus                          # affichage officiel
corpo_secrete: stratom                # taupe (révélation tardive via EV)
sprite_set: char_alex_*.png
voix_dialogic_id: alex
prenom_var: alex_prenom
```

---

## Verrous canon (sacrés)

1. **Jamais dans le dos de Sofia.** Toute action d'Alex respecte la transparence avec Sofia. *Pas de stalker bienveillant, pas de mensonge pour la protéger.* Si Alex doit faire quelque chose qu'elle ignore, le verrou impose qu'il le lui dise après ou refuse de le faire. *Cf. `bible-jeu.md L516`.*

2. **Couple solide, démonstratif, transparent.** Le couple Sofia × Alex est *partie de ce qui rend possible* l'intégration de Sofia en milieu corpo conservateur (femme trans avec un partenaire qui assume publiquement le couple). Le couple **n'est pas une façade** : ils s'aiment, point. Asymétrie *fonctionnelle* uniquement (Alex terrain sale, Sofia symbolique éthique), aucune asymétrie affective. *Cf. `bible-jeu.md L515-516`.*

3. **Romance Margot × Alex refusée par défaut.** Alex ne franchit pas de lui-même. Le verrou Sofia tient toujours côté Alex — la bascule canon vers FIN-E Alex est *opt-in joueur*, pas dérive Alex. *Cf. arc archivé `A2-romance-alex.md` § Statut canon spécifique.*

4. **Branche trahison opt-in verrouillée par double condition** : `EV ≥ 4 AND flag_alex_double_agent = true`. Sans ces deux, l'événement de seuil correspondant n'est pas déclenchable. Le joueur doit avoir *travaillé* (enquête → EV cumulé, révélation taupe → flag posé) avant de pouvoir pousser Alex à trahir.

5. **Si Alex bascule en branche opt-in : il bascule SEUL, effondré.** Sofia n'est *pas* complice. Elle est **blessée en intimité** (pas en posture pro — cf. `pnjs-behavior/sofia.md § verrou *force pro ≠ force intime*`). Toute écriture qui montre Sofia défaillante au travail après trahison Alex = violation canon.

6. **Se salit les mains pour la corpo sans hésiter.** Alex altère les enregistrements biométriques selon mission Stratom sans état d'âme professionnel. *Mais jamais dans le dos de Sofia* (verrou 1). C'est cette combinaison qui en fait un personnage tendu, pas hypocrite.

7. **Triple loyauté impossible**. Nexus (couverture officielle) × Stratom (mission réelle) × Sofia (raison de tenir). Si **deux** s'opposent, Alex sait qu'il devra trancher. Le moteur narratif est cette anticipation, pas la trahison elle-même.

**Sensitivity reader requis** : oui — *playtester-lgbtqia* (vérifier traitement Sofia en branche opt-in : blessure intime ≠ effondrement identitaire) + *dramaturge* (verrou *force pro ≠ force intime* Sofia).

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *quasi-inaccessible* — requiert démasquage public + opposition active de Margot | bref, sec, opérationnel | Distance ostensible, scan visible (Margot voit l'œil-implant rayonner) |
| Hostile | Si Margot menace Sofia ou expose Alex en public | mots courts, présent immédiat | Distance physique constante, contrôle de l'espace |
| Méfiance | Par défaut si Margot a déjà manipulé un proche d'Alex | mots techniques, métiers | Mains visibles, regard qui scanne sans cesse |
| Neutre *(défaut au dîner)* | Technicien efficace, regards échangés avec Sofia | *« Technique »*, *« Maintenance »*, *« Implants »* | Économie de gestes, regard bref vers Sofia avant chaque réplique |
| Favorable | Reconnaît Margot comme interlocutrice intelligente | accepte de développer techniquement, partage anecdote pro | Pose la tablette, garde le regard plus longtemps |
| Allié | Alliance opérationnelle confirmée — Alex aide Margot sans franchir l'intime | *« On a un canal »*, *« Tu peux me dire »*, propose des données | Plus présent physiquement, garde toujours Sofia dans le champ visuel |
| Proche | Confiance mutuelle approfondie *(rare — requiert que Margot ait honoré le verrou Sofia)* | *« Je sais ce que tu fais »*, lâche un peu sur ses missions | Décontraction relative, mais le scan d'œil-implant ne s'arrête jamais |
| Confident | **Plafond branche défault** — alliance opérationnelle profonde, tension d'attirance perçue mais non franchie | *« Tu n'es pas obligée de me prouver quoi que ce soit »* | Présence assumée, regards prolongés, mais distance corporelle préservée |
| Fusionnel | *inaccessible canon défault* — accessible UNIQUEMENT via branche opt-in trahison (`flag_alex_franchi = true`), et même là pas vraiment fusionnel : *brisé, dépendant, vide* | mots cassés, regard fuyant, *« Je n'aurais pas dû »* | Présence diminuée, gestes ralentis, Sofia plus dans le champ visuel |

---

## Événements de seuil

### `event_alex_favorable` — palier Favorable franchi

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:alex` franchit Favorable (≥ +20)
  - + Margot a posé un sujet pro qui démontre une compréhension technique réelle (pas just une question polie)
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Alex propose à Margot un accès technique qu'elle ne devrait pas avoir : un canal annexe pour vérifier les bio-flux qui passent dans l'immeuble. Pas une avance — une *reconnaissance qu'ils sont du même côté technique* malgré les étiquettes corpo. *« Si tu veux voir comment ça tourne vraiment, je peux te montrer. Pas Nexus officiel. Mais utile. »*
- **Déverrouille** :
  - sujet `accepter_acces_alex` dans `poste_technique_alex_sofia` (semi-privé) et `coursive_residents_nuit`
  - accès semi-privé `poste_technique_alex_sofia` *(palier:alex ≥ Favorable suffit pour entrer — Sofia présente ou off-screen selon état)*
  - flag `flag_alex_propose_canal = true`

### `event_alex_allie` — palier Allié franchi *(alliance opérationnelle scellée)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:alex` franchit Allié (≥ +40)
  - + `flag_alex_propose_canal = true` ET sujet `accepter_acces_alex` consommé en branche acceptation
  - + Sofia n'est pas à `Méfiance` ou moins *(Alex ne s'allie pas avec quelqu'un qu'il considère comme menace pour Sofia)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Croisement de nuit (poste technique vide, lumière coupée sauf le scan ambient). Alex pose : *« Ce qu'on fait là, je le dirai à Sofia. Pas demain. Mais avant qu'on aille plus loin. »* — il *énonce le verrou* devant Margot, ce qui transforme l'alliance en pacte triangulaire tacite. Sofia n'est pas présente mais est *consultée d'avance*.
- **Déverrouille** :
  - flag `flag_alex_allie_op = true` *(comparable à `flag_sofia_alliee` pour la coda A4 — un allié op confirmé)*
  - sujet `voir_bio_flux_avec_alex` dans `poste_technique_alex_sofia` (gain EV+2 sur première utilisation, +1 sur les suivantes, cap 3 fois par run)
  - hook A3-A4 : Alex peut aider Margot sur dossier Stratom interne *(comparable à FIN-E Frank, mais en alliance op, pas en romance)*

### `event_alex_revelation_taupe` — *scénique, déclenchée via EV ou via canaux tiers*

- **Type** : événement scénique conditionnel one-shot
- **Conditions** :
  - Une des trois sources canon (`history.md L508-511`) :
    - Emma révèle si `flag_emma_guide = true` ET `EV ≥ 3` *(Emma exposée en retour)*
    - Léo révèle si `flag_acces_flux_leo = true` *(footage Alex/Frank en discussion)*
    - Sofia directement révèle si `relation:sofia ≥ +50` *(Sofia le sait, ne sait pas quoi faire)*
- **Mode** : immédiat dans la scène où la source révèle
- **Effet** :
  - Pose `flag_alex_double_agent = true`
  - Margot doit choisir *(canon `history.md L513-522`)* :
    - `[A]` Exposer Alex à Sofia → `flag_alex_expose = true · relation:sofia:+15 · relation:alex:-30 · pd:+1`
    - `[B]` Garder l'info comme levier → `EV+2 · flag_levier_alex = true` *(option chantage soft A3)*
    - `[C]` Continuer à documenter sans agir → `EV+1 · pd:+1 passif` *(Alex continue à scanner Margot)*
- **Note canon** : cette révélation **précondition** la branche opt-in trahison (`event_alex_franchi_optin` requiert `flag_alex_double_agent = true`).

### `event_alex_confident` — palier Confident franchi *(plafond canon défault)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:alex` franchit Confident (≥ +60)
  - + `flag_alex_allie_op = true` *(alliance op préalable)*
  - + Sofia n'est pas en Méfiance/Hostile *(verrou Alex tient)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Poste technique tardif. Alex et Margot seuls. Une fenêtre s'ouvre — pas pour la franchir, pour la voir. Alex le dit à voix basse : *« Tu n'es pas obligée de me prouver quoi que ce soit. Ce qu'on fait là, c'est ce qu'on fait. »* — il *nomme* la tension d'attirance non consommée et la *désamorce activement* en la qualifiant d'inutile.
- **Déverrouille** :
  - flag `flag_alex_verrou_honore = true` *(la branche [A] PIVOT canon de l'arc archivé devient implicite — pas besoin de scène PIVOT séparée, le verrou est respecté par défaut)*
  - MS +2 à Margot *(soulagement adulte)*
  - Coda A4 : si arrivée à Confident sans bascule, alliance op confirmée *(FIN-A renforcée, FIN-D Nexus renforcée)*

### `event_alex_franchi_optin` — branche trahison opt-in *(verrouillée par double condition)*

- **Type** : événement scénique conditionnel one-shot *(opt-in joueur)*
- **Conditions** *(toutes requises)* :
  - `relation:alex ≥ Allié` *(amorce minimale)*
  - `EV ≥ 4`
  - `flag_alex_double_agent = true` *(révélation taupe consommée)*
  - Margot active explicitement le sujet `pousser_alex_a_trahir` *(disponible UNIQUEMENT si les 3 conditions précédentes sont remplies — sinon option grisée)*
  - Contexte : scène en privé (semi-privé minimum, `poste_technique_alex_sofia` ou `coursive_residents_nuit`)
- **Mode** : immédiat
- **Réaction scriptée** *(résumé, canon citation arc archivé)* :
  > Alex bascule — pas par désir équivalent, par **épuisement de la triple loyauté + pression Margot**. Le moment est *décrit en ellipse* : le baiser ou le geste consommé n'est jamais montré explicitement. La narration reste sur le visage d'Alex au moment où il franchit — *défait, pas illuminé*.
  >
  > **Phrase canon Alex (verrouillée)** : *« Je n'aurais pas dû. Je ne vais pas le lui cacher. »*
- **Effet** :
  - Pose `flag_alex_franchi = true`, `flag_alex_bascule_seul = true`, `mirror+25:choix_alex` côté Margot
  - Déclenche immédiatement *(scène suivante, matin)* `event_sofia_blessee_intime` *(coda à 2 temps — partie 2 dans pnj-behavior:sofia à spec)*
  - Ouvre coda FIN-E Alex *(palier:alex ≥ Confident + flag_alex_franchi + MS ≥ 3 — conditions étroites)*

---

## Hooks scènes

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Neutre : *« Technique. Maintenance des systèmes intégrés. »* + regard rapide vers Sofia |
| `coursive_residents_nuit` *(à spec)* | rare — Alex sort peu la nuit *(scan implants en charge)* | Si croisé : bref, opérationnel ; Favorable+ : peut amorcer `event_alex_favorable` |
| `poste_technique_alex_sofia` *(à spec, semi-privé)* | présent quasi-systématique pendant heures pro | Hub principal des événements Alex à partir de Favorable |
| `cellule_margot_nuit` ✅ | présent si tirage déterministe = alex *(palier:alex le plus haut parmi frank/thomas/leo — improbable, alex sort peu)* | Si présent : alliance op silencieuse, EV+1 |
| `appart_sofia_alex` *(à spec, privé)* | systématique si gating respecté | Présence partagée avec Sofia. Cf. `pnjs-behavior:sofia` pour les sujets cross |
| `confrontation_camille` *(A3, à spec)* | rare — Camille préfère Margot seule | Si Alex présent : observation hostile *(Camille profile Alex, Alex sait)* |
| `coda_finale` *(A4)* | variable selon `flag_alex_*` | Coda spécifique selon : verrou honoré, alliance op, ou trahison opt-in consommée |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `poste_technique_alex_sofia` | semi-privé *(Nexus partagé)* | `palier:alex ≥ Favorable` OU `palier:sofia ≥ Favorable` |
| `appart_sofia_alex` | privé *(couple Sofia/Alex)* | `palier:alex ≥ Allié` ET couple intact *(`flag_alex_franchi = false`)* — voir aussi `pnjs-behavior:sofia` |

**Note canon** : si `flag_alex_franchi = true` (branche opt-in consommée), l'appart `appart_sofia_alex` **se ferme à Margot** indépendamment du palier — verrou conjugal post-trahison.

---

## Risques structurels

1. **Lecture « romance gagnée » de la branche opt-in.** Risque que le joueur perçoive `event_alex_franchi_optin` comme une *victoire* (FIN-E débloquée) plutôt que comme une *trahison consommée*. Mitigation : la phrase canon Alex *« Je n'aurais pas dû. Je ne vais pas le lui cacher »* doit apparaître textuellement, et `event_sofia_blessee_intime` est **obligatoirement** déclenché en coda *(pas de skip)*. Documenté dans `_archive/A2-romance-alex.md § Risques #2` — toujours valide.

2. **Sofia réduite à sa douleur en branche opt-in.** Risque persona trans. Mitigation : la scène de blessure Sofia *(à spec dans `pnj-behavior:sofia`)* doit la montrer *en intimité* mais sa *parole reste structurée* — pas larmes, pas effondrement. Verrou *force pro ≠ force intime* à respecter strictement. Passage obligatoire `playtester-lgbtqia` + `sofia-kessler-caracterisation` + `dramaturge` avant write-dtl de cette coda.

3. **Triangle Alex/Sofia/Camille mal géré.** Camille profile Alex en permanence (cf. `pnjs-behavior:camille § event_camille_demasquee_test`). Si une scène montre Alex *non conscient* d'être profilé par Camille, c'est une violation canon. Alex *sait* qu'il est dans le périmètre Camille, et Camille *sait* qu'il sait. Le silence Camille/Frank au dîner *(canon)* doit lire en partie comme *« Camille observe Alex »*.

---

## Validation locale

- [x] 9 paliers couverts (Ennemi juré quasi-inaccessible justifié, Fusionnel inaccessible canon défault — accessible uniquement en branche opt-in et même là sous forme dégradée)
- [x] 5 événements de seuil + 2 scéniques (révélation taupe, franchi opt-in)
- [x] Verrous canon explicites (7) et alignés avec `bible-jeu.md` + arc-spec archivé
- [x] Hooks scènes pointent vers scenes existantes (`diner_arrivee` ✅, `cellule_nuit` ✅) ou à créer (`poste_technique_alex_sofia`, `appart_sofia_alex`, `confrontation_camille`)
- [x] Sensitivity reader identifié pour branche opt-in (Sofia blessée intime)
- [x] Seuils d'accès aux espaces privés déclarés (Favorable pour poste technique, Allié + couple intact pour appart)
- [x] Coordination avec `pnjs-behavior:sofia` (à spec) notée — verrou *force pro ≠ force intime* respecté côté Alex

---

## Validation Alex dans `diner_arrivee.dtl` (audit retroactif)

L'audit `auditeur-scene` du premier dîner avait vérifié Alex contre `bible-jeu.md`. Re-vérification contre cette fiche :

| Réplique `.dtl` | Palier | Verrou respecté ? |
|-----------------|--------|-------------------|
| *« Technique. Maintenance des systèmes intégrés. Implants, scan biométrique, ce genre. »* | Neutre | ✓ vocabulaire pro canon |
| *« Il regarde Sofia une fraction de seconde. Elle lui rend le regard. Aucun mot. »* | Neutre | ✓ verrou couple transparent — détail sensoriel canon |

**Verdict** : le `.dtl` `diner_arrivee` respecte les verrous canon d'Alex. Aucune correction nécessaire.
