# PNJ Behavior — `thomas`

> *Le résigné · KAIZEN · 29 ans · homme · Tier 1*
> Source canon : `bible-jeu.md § Thomas Renard` + `overview.md § Cast` + `history.md L448-453 (Thomas romance arc canon)` + `history.md L785-793 (FIN-E Thomas « La Révélation »)`.
>
> **8/8 — dernière fiche du catalogue PNJ. Boucle bouclée sur les 8 résidents.**

---

## Métadonnées

```yaml
pnj_id: thomas
tier: 1
corpo: kaizen
sprite_set: char_thomas_*.png
voix_dialogic_id: thomas
prenom_var: thomas_prenom
```

---

## Verrous canon (sacrés)

1. **Épuisement chronique, cynisme absolu, aucun investissement émotionnel apparent**. Thomas vit en *mode économie d'énergie permanente*. Toute écriture qui montre Thomas vivant, plein d'élan ou émotionnellement engagé en surface viole canon. *Cf. `bible-jeu.md L539`.*

2. **« Peut révéler par pure fatigue ce qu'il devrait taire »** (Weakness Tag canon). C'est la vulnérabilité narrative principale. Thomas ne trahit pas consciemment — il *lâche* par épuisement, par *« à quoi bon mentir, je n'en ai pas la force »*. Toute scène où Thomas calcule ce qu'il révèle viole canon.

3. **Cynisme désarmant** (Power Tag canon). Sa lucidité n'est pas agressive — elle *désarme* l'interlocuteur en refusant d'être touché. *« On est déjà filmés 24/7. »* dit calmement désamorce toute paranoïa. *« Fais ce que tu veux. »* refuse l'autorité d'autrui sur ses propres choix. Toute scène où Thomas est cynique-agressif (sarcasme méchant) viole canon.

4. **Couple Marine × Thomas en tension visible, Thomas encaisse en silence**. Dispute étouffée la nuit (canon `history.md L261`). *« Thomas, résigné, encaisse en silence la performance de Marine et la dette 45k€ qui menace tout l'immeuble »* (bible-jeu L545). Toute écriture qui montre Thomas activement en conflit avec Marine viole canon — la tension est *contenue*, *avalée*.

5. **« Rupture visible » condition canon FIN-E Thomas**. *« Marine/Thomas ont eu une scène de tension visible »* (`history.md L449`) est le verrou d'accès à l'arc romance Thomas. Sans dispute Marine/Thomas explicite à un moment du run *(canon `event_marine_rupture_visible_amorce` cf. `pnjs-behavior/marine.md`)*, l'arc Thomas se ferme.

6. **Invisibilité par épuisement** (Power Tag canon). Thomas *passe inaperçu* par défaut. Personne ne le considère comme un acteur narratif majeur — c'est sa protection et son angle d'attaque. Margot peut entendre des choses devant Thomas que personne d'autre n'entendrait, parce qu'on oublie Thomas dans la pièce.

7. **FIN-E Thomas « La Révélation »** : Thomas donne les données Kaizen internes pour sauver Marine **sans l'exposer**. C'est le seul moment du run où Thomas *agit*. *« Je pensais que t'étais comme tous les autres. T'étais là pour prendre. »* — citation canon. Conséquences pour Thomas : pas de carrière finie comme Frank/Sofia/Marine, mais *« il a arrêté de croire que rien ne change »* — c'est sa rédemption canon, minuscule mais réelle.

**Sensitivity reader requis** : non spécifique — mais `dramaturge` obligatoire sur la **cohérence couple Marine/Thomas** *(rupture visible condition FIN-E)*.

---

## Voix par palier

Tonalité commune : *épuisé qui s'amuse à peine — l'humour fonctionne mais l'énergie est minimale*. Phrases courtes, regard qui se pose sur des objets plutôt que sur les gens.

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *quasi-inaccessible* — Thomas n'a pas l'énergie de l'hostilité active | — | — |
| Hostile | *quasi-inaccessible* — au pire, Thomas devient *encore plus silencieux* | mots minimaux, refuse l'interaction | Quitte la pièce |
| Méfiance | Par défaut si Margot a démontré une volonté manipulatrice claire | marmonne | Regarde son verre, sa main, ses chaussures |
| Neutre *(défaut au dîner)* | Cynique calme, économie verbale maximale | *« J'ingénie. C'est très palpitant. »*, *« On est déjà filmés 24/7. »* | Regarde son verre, demi-sourire qui s'arrête à mi-chemin |
| Favorable | Margot a démontré une forme d'intégrité que Thomas reconnaît | *« Toi tu sais. »*, *« Logique. »* | Lève les yeux plus souvent, peut soutenir un regard |
| Allié | `flag_thomas_complice_silencieux = true` — Thomas couvre Margot par omission | *« Je n'ai rien vu. »*, *« Pas mon problème. »* | Présence un peu plus engagée, peut s'asseoir face plutôt que de côté |
| Proche | Rare — requiert que Marine/Thomas ait eu rupture visible ET que Margot ait été *présente* dans la fissure | *« Elle a 45k€ de dette. Tu le sais déjà. »*, lâche de l'info par fatigue plus que par confiance | Posture détendue, peut parler 3-4 phrases consécutives *(rare)* |
| Confident *(plafond canon — ouvre FIN-E Thomas)* | Thomas *décide* — première fois du run | *« Je pensais que t'étais comme tous les autres. T'étais là pour prendre. »* | Présence pleine *(unique du run)*, regard direct, voix audible |
| Fusionnel | *inaccessible canon* — Thomas reste fondamentalement seul, même en intimité partagée | — | — |

---

## Événements de seuil

### `event_thomas_favorable` — palier Favorable franchi *(via intégrité reconnue)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:thomas` franchit Favorable *(≥ +20)*
  - + Margot a démontré une intégrité visible *(refus de manipuler, refus d'instrumentaliser, partage d'info sans demande)* en présence ou audible par Thomas
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Thomas lève les yeux de son verre pour la première fois. *« Toi tu sais. »* — c'est tout. Mais c'est la première fois qu'il pose le regard *avant* qu'on lui parle.
- **Déverrouille** :
  - sujet `parler_avec_thomas` *(disponible dans `zone_commune_jour`, `coursive_residents_nuit`, `cellule_nuit` si Thomas tiré)* — Margot peut désormais initier conversation longue *(2-4 phrases au lieu d'un mot)*
  - flag `flag_thomas_reconnait_margot = true`

### `event_thomas_complice_silencieux` — palier Allié franchi *(couverture par omission)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:thomas` franchit Allié *(≥ +40)*
  - + Margot a posé un acte risqué *(installation micros, intrusion, instrumentalisation justifiée)* dans une scène où Thomas était présent ou avait raison de savoir
  - + Thomas a *choisi de ne pas voir* — `event_thomas_choix_silence` *(scénique récurrent à ce palier — Thomas peut couvrir Margot 2 fois par run avant épuisement de la complicité)*
- **Mode** : immédiat à la scène où Thomas *choisit* de ne pas voir
- **Réaction scriptée** *(résumé)* :
  > Thomas regarde Margot droit dans les yeux *(unique en arc)*. *« Je n'ai rien vu. Pas mon problème. »* — pose son verre, change de pièce. C'est une absolution silencieuse offerte sans condition.
- **Déverrouille** :
  - Pose `flag_thomas_complice_silencieux = true`
  - `relation:thomas:+5:complicite_silencieuse`
  - **Compteur** : `thomas_complicites_offertes < 2` *(cap canon — Thomas n'a pas l'énergie de couvrir indéfiniment)*. Après 2 utilisations, le sujet devient *« Pas cette fois. »* avec `relation:thomas:-3 · décompte épuisé`.

### `event_thomas_proche` — palier Proche franchi *(post rupture visible)*

- **Type** : montée, one-shot
- **Conditions** *(toutes requises)* :
  - `relation:thomas` franchit Proche *(≥ +50)*
  - + `flag_marine_thomas_rupture_visible = true` *(canon `pnjs-behavior/marine.md § event_marine_rupture_visible_amorce`)*
  - + Margot était *présente dans la fissure* — soit témoin direct, soit a posé un acte qui a réduit la pression sur Thomas *(`flag_marine_alliee = true` par exemple)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Thomas s'arrête dans le couloir alors qu'il a entendu Margot rentrer. Voix basse. *« Elle a 45k€ de dette. Tu le sais déjà. Je le sais. On le sait. Je ne sais pas ce qu'on fait avec ça. »* — c'est la première fois qu'il dit *« on »* en incluant Margot.
- **Déverrouille** :
  - sujet `parler_de_marine_avec_thomas` dans toutes scènes Thomas privées *(donne accès canal d'info Marine sans déclencher cascade)*
  - flag `flag_thomas_partage_marine = true`

### `event_thomas_confident` — palier Confident franchi *(ouvre FIN-E Thomas)*

- **Type** : montée, one-shot
- **Conditions** *(toutes requises, canon `history.md L787`)* :
  - `relation:thomas` franchit Confident *(≥ +60)*
  - + `flag_marine_thomas_rupture_visible = true`
  - + `MS ≥ 3` côté Margot *(condition canon FIN-E)*
- **Mode** : différé
- **Réaction scriptée** *(résumé, citation canon)* :
  > Thomas pose les données Kaizen internes sur la table de Margot. *« Pour la sauver sans l'exposer. C'est faisable. Tu vois ce que je veux dire. »*
  >
  > *« Je pensais que t'étais comme tous les autres. T'étais là pour prendre. »*
- **Déverrouille** :
  - coda FIN-E Thomas *« La Révélation »* accessible
  - `EV+2:donnees_kaizen_internes_marine` — gain d'EV majeur sans déclencher cascade dette
  - flag `flag_thomas_a_choisi = true` *(Thomas a agi pour la première fois du run — sa rédemption canon)*
  - **Conséquence couple** : si `flag_thomas_confident_consomme = true`, le couple Marine/Thomas reste en tension mais Marine est sauvée par Thomas. `flag_marine_sauvee_par_thomas = true` — coda A4 spécifique.

### `event_thomas_revele_par_fatigue` — *scénique, Weakness Tag canon*

- **Type** : événement scénique conditionnel récurrent *(cap 2 par run)*
- **Conditions de déclenchement** :
  - Scène avec Thomas en intimité ou semi-privé
  - Margot pose un sujet sensible *(politique Kaizen, dette Marine, opinions Stratom, etc.)*
  - Heure tardive *(scène cycle nuit OU `audit_marine ≤ 10` — Thomas plus épuisé)*
  - `thomas_revelations_par_fatigue_compteur < 2`
- **Mode** : immédiat
- **Effet** :
  - Thomas **lâche** une info qu'il devrait taire. Pas calculé, pas conscient. Pose le verre, regarde ailleurs, dit la chose, change de sujet.
  - `EV+1:thomas_revelation_par_fatigue_<N>`
  - Compteur : `thomas_revelations_par_fatigue_compteur += 1`
  - **Pas de gain relation** *(Thomas ne se souvient pas vraiment avoir dit, ou s'en moque)*
- **Catalogue de révélations possibles** *(une par run au maximum, pseudo-aléatoire selon état)* :
  - Détail Kaizen (méthode audit, identité d'un cadre)
  - Détail Marine (timeline dette, créancier nominal)
  - Détail système surveillance immeuble *(« il y a un angle mort dans la coursive 3 »)*
  - Détail couple *(« on aurait dû arrêter il y a deux ans »)*

---

## Hooks scènes

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Neutre : *« J'ingénie. C'est très palpitant. »*, regarde son verre |
| `zone_commune_jour` *(à spec)* | présence régulière mais discrète | Méfiance/Neutre : marmonne. Favorable+ : `event_thomas_favorable` croisement |
| `coursive_residents_nuit` *(à spec)* | rare — Thomas couche tôt par épuisement | Si croisé : phrase courte cynique |
| `cellule_margot_nuit` ✅ | présent si tirage déterministe = thomas *(palier:thomas le plus haut parmi {frank, thomas, leo})* | Si présent : `event_thomas_revele_par_fatigue` possible |
| `appart_marine_thomas` *(à spec, privé `palier:thomas ≥ Allié`)* | systématique heures privées | Hub `event_thomas_proche` et `event_thomas_confident` |
| `coda_finale` *(A4)* | variable selon `flag_thomas_*` | FIN-E Thomas *« La Révélation »* si conditions ; coda Marine sauvée par Thomas ; ou silence résigné |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `appart_marine_thomas` | privé *(couple Marine/Thomas)* | `palier:thomas ≥ Allié` OU `palier:marine ≥ Allié` *(cf. `pnjs-behavior/marine.md`)*. Pas de verrou *« couple intact »* — l'intrusion conjugale est canon (rupture visible attendue), donc l'accès reste ouvert même post-dispute. |

---

## Risques structurels

1. **Thomas verbeux ou émotif**. Risque majeur d'écriture — multiplier les répliques ou les rendre touchantes. Mitigation : grep des répliques Thomas, vérifier qu'aucune ne dépasse 2 phrases sauf en `event_thomas_proche` et `event_thomas_confident` *(seuls moments canon où il peut développer)*. La citation canon de FIN-E est 2 phrases courtes : *« Je pensais que t'étais comme tous les autres. T'étais là pour prendre. »* — c'est le maximum d'investissement émotionnel canon.

2. **Cynisme méchant vs cynisme désarmant**. Risque que Thomas devienne sarcastique-méchant au lieu de cynique-désarmant. Mitigation : le cynisme de Thomas doit *désamorcer* l'interlocuteur, pas le blesser. *« On est déjà filmés 24/7 »* dit calmement = canon. *« Tu crois vraiment que ça change quelque chose ? »* avec sarcasme = violation canon.

3. **Cohérence couple Marine/Thomas**. La rupture visible est condition canon FIN-E Thomas. Coordination obligatoire avec `pnjs-behavior/marine.md § event_marine_rupture_visible_amorce`. Si production avance sur arc Thomas sans rupture canon, vérifier en `auditeur-scene` matriciel.

4. **Thomas « sauveur silencieux ». Risque trope**. Risque que Thomas devienne *« le bon résigné qui sauve tout le monde »*. Mitigation : Thomas n'agit *qu'une seule fois* dans le run (`event_thomas_confident`). Le reste du temps, il est *passif*, c'est sa nature canon. Toute écriture qui le montre actif plusieurs fois viole canon (sauf les 2 complicités silencieuses cappées).

---

## Validation locale

- [x] 9 paliers couverts (Ennemi juré et Hostile quasi-inaccessibles — Thomas n'a pas l'énergie ; Fusionnel inaccessible — reste fondamentalement seul)
- [x] 5 événements de seuil dont 2 récurrents cappés (complicité silencieuse cap 2, révélation par fatigue cap 2)
- [x] Verrous canon explicites (7) alignés avec `bible-jeu.md` + `history.md`
- [x] Hooks scènes pointent vers scenes existantes ou à créer
- [x] Pas de sensitivity reader spécifique — mais `dramaturge` obligatoire (cohérence couple Marine/Thomas)
- [x] Seuil d'accès cohérent avec `pnjs-behavior/marine.md`
- [x] Coordination Marine (rupture visible canon) explicitée

---

## Validation Thomas dans `diner_arrivee.dtl` (audit retroactif)

| Réplique `.dtl` | Palier | Verrou respecté ? |
|-----------------|--------|-------------------|
| *« J'ingénie. C'est très palpitant. »* + *« Il regarde son verre. La phrase est tellement neutre qu'elle bouscule. »* | Neutre | ✓ économie verbale, cynisme désarmant calme, regard sur objet canon |
| *« Réponse honnête. »* + *« Thomas relève les yeux. Pas un sourire. Un quelque-chose dans le regard. »* *(presentation [D] évasif)* | Neutre → amorce Favorable | ✓ reconnaissance d'intégrité, économie maximale (2 mots), regard exceptionnel |

**Verdict** : le `.dtl` `diner_arrivee` respecte intégralement les verrous canon de Thomas. **Aucune correction nécessaire**.

---

## Coordination cross-PNJ

- **Avec `pnjs-behavior/marine.md` ✅** : couple en tension visible. La **rupture visible** *(canon)* est condition d'ouverture de l'arc Thomas. Coordination via `event_marine_rupture_visible_amorce` qui pose `flag_marine_thomas_rupture_visible = true`.
- **Avec `pnjs-behavior/emma.md` ✅** : Thomas peut entendre Emma audible la nuit. Pas d'interaction directe canon, mais Thomas pourrait *« lâcher par fatigue »* qu'il a entendu Emma — canal info passif possible.
- **Avec `pnjs-behavior/leo.md` ✅** : Léo et Thomas échangent parfois des regards en sous-texte au dîner *(canon `.dtl` observation_silence variante)*. Pas d'alliance, juste deux résignés/lassés qui se reconnaissent.
- **Avec `pnjs-behavior/frank.md` ✅** : Frank évalue Thomas mais le sous-estime *(canon Power Tag « invisibilité par épuisement »)*. Si Thomas pose `event_thomas_confident` en A3/A4, Frank en est surpris *(modulateur de coda)*.
- **Avec `pnjs-behavior/camille.md` ✅** : Camille profile Thomas mais le considère comme variable mineure. Sous-estimation parallèle à Frank — c'est la *protection canon* de Thomas (invisibilité par épuisement).
- **Avec `pnjs-behavior/sofia.md` ✅** : peu d'interaction directe. Sofia peut éventuellement allier Thomas si nécessité éthique majeure (rare).
- **Avec `pnjs-behavior/alex.md` ✅** : aucune interaction directe canon. Thomas ne fréquente pas le poste technique Alex/Sofia.

---

## 🎉 8/8 résidents formalisés — catalogue PNJ complet

Cette fiche clôture le catalogue `pnjs-behavior/` pour les 8 résidents canoniques de Saint-Michel.

**Vue d'ensemble finale** :

| PNJ | Couple | Plafond palier | FIN-E | Sensitivity reader |
|---|---|---|---|---|
| `emma` | × Léo | Confident *(fraternel)* | ❌ exclu canon | playtester-lgbtqia + dramaturge + playtester-margot |
| `camille` | × Frank | Confident *(dark cogni-affectif)* | ✓ via `event_camille_dark_proposition` | playtester-margot + playtester-lgbtqia ≥ Favorable |
| `alex` | × Sofia | Confident *(verrou Sofia honoré)*, Fusionnel uniquement via opt-in dégradé | ✓ via opt-in trahison verrouillée | playtester-lgbtqia pour branche opt-in |
| `frank` | × Camille | Confident | ✓ via `event_frank_confident` | dramaturge (cohérence Camille) |
| `sofia` | × Alex | Confident | ✓ « L'Acte éthique » | **OBLIGATOIRE** playtester-lgbtqia + sofia-kessler-caracterisation à chaque scène |
| `leo` | × Emma | Confident en 3 colorations | ✓ en 3 variantes *(production prioriser C)* | dramaturge (3 couches) |
| `marine` | × Thomas | Confident *(masque baissé)* | ✓ « Le Livestream » | playtester-accessibilite (piège dette) + dramaturge |
| `thomas` | × Marine | Confident *(décide pour la 1ère fois)* | ✓ « La Révélation » | dramaturge (cohérence couple) |
