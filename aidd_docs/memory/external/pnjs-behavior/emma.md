# PNJ Behavior — `emma`

> *La cousine tiraillée · MEMORIZE · 28 ans · femme · Tier 1*
> Source canon : `bible-jeu.md § Emma Castellane` + `overview.md § Cast` + `history.md L386-396 (NODE A1-XX FLAG_EMMA_GUIDE)` + `history.md L800+ (FIN Emma fraternelles)`.
>
> **v2 (2026-05-22)** — Refonte suite à critique utilisateur 2026-05-22 *« la référence généalogique tombe à plat »*. La couche *« cousines germaines + brouille familiale + Julien-catalyseur »* est **dépréciée** comme mécanisme central. Nouveau mécanisme : **asymétrie d'être vue via Julien** *(« Emma a vu Julien, donc peut voir Margot »)*. Le cousinage reste un fait canon mais n'est plus le moteur narratif. *Cf. v1 archivée dans historique git pour référence.*

---

## Métadonnées

```yaml
pnj_id: emma
tier: 1
corpo: memorize
sprite_set: char_emma_*.png
voix_dialogic_id: emma
prenom_var: emma_prenom
```

---

## Verrous canon (sacrés — v2 refonte)

1. **Asymétrie d'être vue : Emma a connu Julien**. *(Verrou central remplaçant la fusion-confusion généalogique.)* Emma a fréquenté Julien pendant un épisode du passé adulte de Margot — elle l'a vu fonctionner, vu ses patterns. **C'est la seule personne dans l'immeuble qui peut reconnaître quand Margot reproduit un comportement Julien-like**. Cette connaissance asymétrique est le moteur de la relation : Margot peut être *vue sans avoir à expliquer*. *Cf. bible-jeu.md L349, L414.*

2. **Cousine de Margot — fait canon, pas moteur narratif**. Emma et Margot sont cousines *(degré exact non tranché — peut rester variable libre)*. Ce lien explique pourquoi Emma a contacté Margot pour Saint-Michel, mais **ne porte pas l'arc émotionnel**. L'intimité possible entre elles vient de la *connaissance partagée de Julien*, pas du lien familial.

3. **Pas de FIN-E Emma — fins fraternelles uniquement**. *(Verrou préservé v1.)* Emma reste **boussole morale**, pas partenaire romantique. La raison canonique nouvelle : Emma est ancrée comme *l'observatrice* de Margot — elle voit Margot, mais elles ne se voient pas symétriquement comme amantes potentielles. Le rôle d'Emma est trop chargé d'attente *(« nommer Julien à temps »)* pour qu'une romance puisse coexister sans casser le mécanisme.

4. **Tiraillée par défaut**. Loyauté familiale Margot vs survie corporatiste Memorize *(canon bible-jeu L412)*. Aucun palier ne résout cette tension structurelle.

5. **Nommer Julien = acte coûteux, pas permission**. *(Refonte critique majeure v2.)* Emma *« nomme »* le pattern Julien à Margot uniquement quand :
   - Margot vient de poser un acte Julien-like *(dispositif clandestin, manipulation, utilisation de confiance, justification par « la vérité »)*
   - ET Emma a partagé sa propre perception de Julien en amont *(établissement de la référence partagée — événement de seuil)*
   - ET Emma *choisit* d'intervenir au prix du lien

   **Pas une permission accordée par un palier**, mais un *événement scénique* à conditions multiples. Cf. `event_emma_julien_intervention` ci-dessous.

6. **L'intimité se construit à Saint-Michel** *(verrou préservé v1)*. Pas de *« tu te souviens quand on… »* d'enfance. L'asymétrie de connaissance Julien n'implique pas de complicité enfantine.

**Sensitivity reader requis** : oui — *playtester-lgbtqia* + *dramaturge* + *playtester-margot* à chaque événement de seuil ≥ Allié *(la dynamique « être vue sans expliquer » peut basculer en intrusion psychologique si mal écrite)*.

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *inaccessible canon* — Emma a fait venir Margot, ne devient jamais hostile | — | — |
| Hostile | *inaccessible canon* | — | — |
| Méfiance | Polie distante, formelles corpo *(« vous »* possible)* | *« le projet »*, *« ce qu'on fait ici »* | Regards évités, mains occupées |
| Neutre | Conversationnelle, surface | Anecdotes immeuble, banalités Memorize | Posture neutre |
| Favorable | Chaleureuse, légère | *« On devrait »* + petites inclusions | Sourire bref, contact main une fois |
| Allié | Confiante, partage d'opinion | *« Je crois que »* + opinions personnelles | Proximité physique sans toucher |
| Proche | Vulnérable contenue, peut évoquer Julien indirectement | *« J'ai peur de »*, *« je voulais te dire »* | Posture détendue, contact prolongé possible |
| Confident | Aveux structurels — Emma raconte ce qu'elle a vu de Julien | Mention nom Julien, partage propre lecture de patterns | Présence apaisée, longs silences partagés |
| Fusionnel | *inaccessible canon* — Emma reste observatrice, ne fusionne pas | — | — |

---

## Événements de seuil

### `event_emma_favorable` — palier Favorable franchi

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:emma` franchit Favorable (≥ +20)
  - + contexte : prochaine scène où Emma peut s'approcher en privé *(coursive, croisement matinal)*
- **Mode** : différé *(buffered si conditions contexte pas remplies au franchissement)*
- **Réaction scriptée** *(résumé v2 — refonte)* :
  > Emma trouve un prétexte pour parler à Margot seule à seule. Pas d'intimité forcée — un détail pratique de la vie d'immeuble *(une livraison, un voisin qui demande quelque chose)*. Elle laisse échapper *« Je vois bien que c'est dur. Tu veux que je m'occupe de ça ? »* — décoder : *« je vois ce qui t'arrive. »*
- **Déverrouille** :
  - sujet `accepter_aide_emma` dans scenes ultérieures
  - flag `flag_emma_a_propose_aide = true`

### `event_emma_allie` — palier Allié franchi *(canon `flag_emma_guide`)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:emma` franchit Allié (≥ +40)
  - + Margot a accepté l'aide d'Emma au moins une fois *(`flag_emma_a_propose_aide = true` consommé)*
  - + contexte : scène avec Emma en privé OU semi-privé
- **Mode** : différé
- **Réaction scriptée** *(résumé v2)* :
  > Emma propose à Margot de la **couvrir** dans les rapports Memorize, à son propre risque. *« Je peux te donner deux semaines de plus avant qu'ils ne te voient. Pas trois. »* — c'est l'investissement protecteur de la cousine *(et la prise de risque corporatiste)*.
- **Déverrouille** :
  - flag `flag_emma_guide = true` *(canon historique conservé)*
  - sujet `accepter_couverture_emma` — accepté : pose `flag_emma_couverture_active = true`, ralentit countdown `equipe_nettoyage` de 2 ticks max
  - sujet `parler_de_julien_amorce` *(Emma mentionne brièvement Julien sans encore se livrer)*

### `event_emma_confident` — palier Confident franchi *(événement central v2 — REFONTE MAJEURE)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:emma` franchit Confident (≥ +60)
  - + contexte : scène intime *(`cellule_nuit`, `coursive_residents_nuit`, `appart_emma_leo` Léo absent)*
  - + Margot a abordé un sujet sincère avec Emma sur au moins 2 scènes antérieures *(pas que pro)*
- **Mode** : différé
- **Réaction scriptée v2** *(REFONTE — la phrase canon précédente « tu es ma moitié biographique » est dépréciée)* :
  > Emma raconte à Margot **ce qu'elle a vu, elle, de Julien**. Pas comme une thérapie — comme un dépôt. Elle nomme les patterns *(« il commençait par X, puis Y »)*. Margot encaisse. Aucune comparaison avec Margot n'est faite à ce moment — Emma *partage la référence* sans encore l'appliquer.
  >
  > À la fin, Emma dit simplement : *« Tu fais ce que tu fais. Mais s'il faut que je te dise, je te dirai. »*
- **Déverrouille** :
  - flag `flag_julien_reference_partagee = true` — **précondition** pour `event_emma_julien_intervention` en A3/A4
  - sujet `parler_de_julien_avec_emma` *(version pleine)* dans toutes scènes intimes — Margot peut désormais initier
  - flag `flag_emma_boussole = true` *(potentielle — voir effet mécanique ci-dessous)*

**Effet mécanique nouveau v2** : `flag_emma_boussole` ne *cape pas* les triggers internes automatiquement. Il *autorise* `event_emma_julien_intervention` à se déclencher si conditions remplies. La décision *« nommer ou se taire »* reste à Emma, en scène, avec coût.

### `event_emma_julien_intervention` — intervention en A3/A4 *(REFONTE — événement coûteux)*

- **Type** : événement scénique conditionnel one-shot *(au plus 1 fois par run)*
- **Conditions** *(toutes requises)* :
  - `flag_julien_reference_partagee = true` *(posé par `event_emma_confident`)*
  - + Margot vient de poser un acte Julien-like dans la scène en cours OU la précédente *(un des flags : `flag_dispositif_clandestin`, `flag_manipulation_info`, `flag_confiance_utilisee_contre_emma`, `flag_transgression_justifiee`)*
  - + Emma présente dans la scène en cours
- **Mode** : immédiat
- **Choix d'Emma** *(décision scriptée, dépend de `relation:emma` au moment T)* :
  - Si `relation:emma ≥ Confident` au moment : Emma **intervient** — confrontation. Coût : `relation:emma:-15` *(risque relationnel pris)*.
    - Margot peut écouter *(`mental_stability ≥ 3` côté Margot)* :
      - Écouter : un `trigger_interne_<X>` déjà acquis se **réinitialise** *(le pattern est nommé, Margot peut entendre)*
      - Refuser : `relation:emma:-30` *(elle a tenté, Margot refuse)*, effet non appliqué
  - Si `relation:emma < Confident` au moment *(refroidi entre Confident et l'acte)* : Emma **se tait** — observation muette. Pas d'effet mécanique direct. Mais flag `flag_emma_a_vu_sans_dire = true` posé, qui pèse sur la coda A4.

**Importance canon v2** : c'est *l'événement utile* du dispositif Emma. Tout le reste *(palier Confident, partage Julien)* sert à *créer les conditions* de cet événement. Sans Confident + référence partagée + acte Julien-like + écoute Margot, la mécanique boussole morale ne joue pas.

---

## Hooks scènes

Scènes-types où Emma apparaît typiquement *(à spec dans `scenes/`)* :

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | toujours en A1+ | Méfiance/Neutre : présentations corpo. Favorable+ : adresses regards à Margot, sourires. Allié+ : initie sujets connexion. Référence subtile au choix PRO-02 *(« je vois que tu as bien installé »)* |
| `coursive_residents_nuit` *(à spec)* | tirage favorable selon état Emma | À Allié+ : peut amorcer conversation hors caméras. Confident : possible que `event_emma_confident` se joue ici si contexte intime. |
| `cellule_margot_nuit` ✅ | si frappe à la porte *(sous condition Allié+)* | Visite spontanée à Allié+. Confident : moment de partage Julien. |
| `appart_emma_leo` *(à spec)* | toujours quand Margot s'y rend *(gating `palier:emma ≥ Allié`)* | Variant majeur selon présence Léo. Confident + Léo absent : déclencheur le plus probable de `event_emma_confident`. |
| `poste_memorize_partage` *(à spec)* | si flux Memorize accessibles | Allié+ : peut couvrir Margot dans les rapports. |
| `confrontation_camille` *(A3)* | Emma off-screen comme témoin distant | Si `flag_julien_reference_partagee` : Emma peut intercepter Margot avant la scène. |
| `coda_finale` *(A4)* | systématique | Selon paliers et flags accumulés : pacte fraternel scellé / sacrifice *(FIN-C)* / rupture / silence. |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `appart_emma_leo` | privé *(partagé avec Léo)* | `palier:emma ≥ Allié` |

---

## Risques structurels

1. **Régression vers la couche généalogique v1** *(refonte 2026-05-22)*. Risque élevé : un auteur peut être tenté de réintroduire le *« cousine germaine + brouille familiale »* comme moteur. **Verrou v2** : l'arc Emma est désormais conduit par l'asymétrie de connaissance Julien, pas par la généalogie. Toute scène qui invoque la généalogie comme moteur émotionnel principal *(et pas comme contexte de fond)* doit être refusée en review-persona.

2. **Intrusion psychologique mal écrite** : *« être vue sans expliquer »* peut basculer en *« être surveillée par quelqu'un qui croit te connaître »*. Mitigation : Emma *propose* des observations, ne les *impose* jamais. Toujours formuler en *« je crois voir »*, jamais en *« je sais »*. Sensitivity reader obligatoire.

3. **Sur-utilisation de l'intervention Julien** : si `event_emma_julien_intervention` se déclenche plusieurs fois, l'effet se dilue. Cap canon : **1 fois par run maximum**. Vérifier en `auditeur-scene` matriciel que le flag `_consomme` est bien posé.

---

## Validation locale

- [x] 9 paliers couverts *(2 marqués inaccessibles avec justification canon)*
- [x] 4 événements de seuil *(favorable, allié canon, confident refonte v2, julien_intervention scénique conditionnel)*
- [x] Verrous canon listés exhaustivement *(6 verrous, refonte v2)*
- [x] Hooks scènes pointent vers `scenes/` à créer
- [x] Sensitivity reader identifié *(Confident + intervention Julien)*
- [x] **Critique généalogique 2026-05-22 RÉSOLUE** : mécanisme central refondu vers asymétrie de connaissance Julien

---

## Changelog

| Version | Date | Modification |
|---------|------|--------------|
| v1 | 2026-05-21 | POC initial — cousinage germain + brouille familiale + fusion-confusion non consommée comme mécanisme central |
| **v2** | 2026-05-22 | **Refonte canon suite critique utilisateur** *« la référence généalogique tombe à plat »*. Asymétrie de connaissance via Julien remplace la généalogie comme moteur. Phrase canon *« moitié biographique »* dépréciée. event_emma_confident refondu en *« Emma partage sa lecture de Julien »*. event_emma_julien_intervention conservé comme événement utile principal (au prix d'`relation:emma:-15` pour Emma quand elle intervient). |

---

## Coordination cross-PNJ *(inchangée v2)*

- **Avec `pnjs-behavior/leo.md` ✅** : Léo est en couple avec Emma. Si `flag_pacte_emma = true`, Emma intercepte au beat 3 de l'arc Léo *(boussole morale, pas jalousie de cousine)*.
- **Avec `pnjs-behavior/alex.md` ✅** : Emma peut révéler la taupe Stratom Alex à Margot si `flag_emma_guide = true` ET `EV ≥ 3`.
- **Avec `pnjs-behavior/marine.md` ✅** : Emma peut transmettre la dette Marine en confidence sous pression.
- **Avec `pnjs-behavior/camille.md` ✅** : Emma est observée par Camille *(profilage)*, en pleine conscience. Tension de fond.
- **Avec `pnjs-behavior/sofia.md` ✅** : peu d'interaction directe. Sofia peut révéler Alex à Margot indépendamment d'Emma.
- **Avec `pnjs-behavior/frank.md` ✅** : Frank évalue Emma indirectement. Si Margot expose Emma *(`flag_emma_exposee = true` à venir)*, Stratom prend l'opportunité.
- **Avec `pnjs-behavior/thomas.md` ✅** : aucune interaction frontale canon.
