# PNJ Behavior — `emma`

> POC du modèle 3 couches (cf. `overview.md § Architecture narrative`).
> Recyclage du contenu de l'arc-spec `_archive/A2-romance-emma.md` redistribué sur paliers + événements de seuil.
>
> ⚠ **Critique utilisateur en attente d'arbitrage** *(P0 todo)* : la référence généalogique *cousines germaines + brouille familiale via Julien-catalyseur* tombe à plat narrativement. La piste de remplacement à creuser : *« Emma a vu Julien, donc peut voir Margot »* — l'asymétrie de connaissance comme moteur, pas la similitude biographique. Cette fiche reflète la canon actuelle (cousinage) en attendant la décision.

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

## Verrous canon (sacrés)

- **Fusion-confusion non consommée** : la dimension romantique entre Margot et Emma n'aboutit jamais à un acte sexuel — *pas par interdit moral*, par bascule cognitive (deux adultes urbains post-conservateurs qui se reconnaissent comme *ne devant pas être ça l'une pour l'autre*).
- **Aucune variante FIN-E Emma**. Les fins Emma sont **fraternelles uniquement** : pacte scellé, sacrifice (FIN-C), rupture, silence.
- **Pas de complicité d'enfance**. L'éloignement vécu (brouille familiale ancienne) interdit *« tu te souviens quand on… »*. L'intimité se construit **à Saint-Michel**, pas dans la nostalgie partagée.
- **Emma a connu Julien**. Elle est **la seule** dans l'immeuble qui peut nommer le pattern à Margot — référence partagée acquise pendant la phase de reconnexion adulte.
- **Tiraillée par défaut**. Loyauté familiale (Margot) vs survie corporatiste (Memorize). Aucun palier ne résout cette tension structurelle.

**Sensitivity reader requis** : oui — *playtester-margot* (consentement informationnel de Margot dans les seuils intimes) + *dramaturge* (vérifier la bascule cognitive vs interdit moral) à chaque événement de seuil au-dessus de Allié.

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | *inaccessible canon* — Emma a fait venir Margot, ne devient jamais hostile | — | — |
| Hostile | *inaccessible canon* | — | — |
| Méfiance | Polie distante, formelles corpo ("vous" possible) | "le projet", "ce qu'on fait ici" | Regards évités, mains occupées |
| Neutre | Conversationnelle, surface | Anecdotes immeuble, banalités Memorize | Posture neutre |
| Favorable | Chaleureuse, légère | "On devrait" + petites inclusions | Sourire bref, contact main une fois |
| Allié | Confiante, partage d'opinion | "Je crois que" + opinions personnelles | Proximité physique sans toucher |
| Proche | Vulnérable contenue | "J'ai peur de", "je voulais te dire" | Posture détendue, contact prolongé possible |
| Confident | Aveux structurels, partage Julien possible | Mention nom Julien, exposition de ses propres failles | Présence apaisée, longs silences partagés |
| Fusionnel | *inaccessible canon* — la fusion-confusion est désamorcée avant d'atteindre ce palier (cf. verrous) | — | — |

---

## Événements de seuil

### `event_emma_favorable` — palier Favorable franchi

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:emma` franchit Favorable (≥ +20 typiquement, à caler en code)
  - + contexte : prochaine scène où Emma est présente et la conversation peut dévier
- **Mode** : différé (buffered si conditions contexte pas remplies au franchissement)
- **Réaction scriptée** *(résumé)* :
  > Emma laisse échapper un fragment biographique d'avant la brouille familiale. Pas d'invitation à se souvenir — un dépôt. *« Tu sais qu'on a un grand-père qui faisait de la radio amateur ? On a peut-être ça en commun. Je ne sais pas. »*
- **Déverrouille** :
  - sujet `parler_du_passe_familial` *(table de réponses fragmentée, peu d'info concrète à Allié-)* dans scenes intimes
  - flag `flag_emma_a_evoque_passe = true`

### `event_emma_allie` — palier Allié franchi

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:emma` franchit Allié (≥ +40)
  - + contexte : scène avec Emma en privé OU `flag_emma_a_evoque_passe = true`
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Emma propose à Margot de la **couvrir** dans les rapports Memorize, à son propre risque. *« Si tu fais ce qu'il faut, je peux te donner deux semaines de plus avant qu'ils ne te voient. Pas trois. »*
- **Déverrouille** :
  - sujet `accepter_couverture_emma` dans scenes intimes — *si accepté, pose `flag_emma_couverture_active = true` qui colore la suite (countdown `equipe_nettoyage` ralenti de 2 ticks max, mais Emma exposée si Memorize détecte)*
  - sujet `parler_de_julien` *(amorce — Emma mentionne Julien sans encore comparer)* à Allié+

### `event_emma_confident` — palier Confident franchi *(événement central canon)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:emma` franchit Confident (≥ +60)
  - + contexte : scène intime (`cellule_nuit`, `coursive_residents_nuit`, `appart_emma_leo` Léo absent)
  - + au moins une scène où Margot a abordé un sujet sincère avec Emma (pas que pro)
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Emma raconte à Margot **ce qu'elle a vu, elle, de Julien**, pendant la phase de reconnexion adulte. Récit posé, sans encore comparer à Margot. C'est l'**établissement de la référence partagée** qui permettra plus tard à Emma d'intervenir si Margot reproduit un pattern.
- **Déverrouille** :
  - flag `flag_julien_reference_partagee = true` — **précondition** pour les événements de seuil A3/A4 où Emma peut intervenir si Margot pose un acte Julien-like (cf. *Hooks scènes A3*)
  - sujet `parler_de_julien` *(version pleine)* dans toutes scènes intimes — Margot peut désormais initier
  - *(optionnel selon contexte intime)* moment où Emma initie un geste affectif ambigu — déverrouille le **sujet de bascule cognitive** dans la même scène : 3 options Margot, dont l'option canon de désamorçage *(formulation à valider en `tone-finder` — registre : nommer la similitude biographique sans interdit moral)*.

### `event_emma_julien_intervention` — *intervention en A3/A4 si Margot pose un acte Julien-like*

- **Type** : événement scénique conditionnel *(pas un seuil de palier, un seuil d'acte)*
- **Conditions** :
  - `flag_julien_reference_partagee = true` *(posé par `event_emma_confident`)*
  - + acte récent de Margot qualifié Julien-like *(un de : `flag_dispositif_clandestin`, `flag_manipulation_info`, `flag_confiance_utilisee_contre_emma`, `flag_transgression_justifiee`)*
  - + Emma présente dans la scène en cours
- **Mode** : immédiat *(s'injecte dans la scène où l'acte vient d'être commis, ou la suivante avec Emma)*
- **Choix d'Emma** *(scripté, peut dépendre de `relation:emma` au moment T)* :
  - Si `relation:emma ≥ Confident` au moment : Emma **intervient** — confrontation. Coût : `relation:emma:-15` *(risque relationnel pris)*. Effet : un `trigger_interne_<X>` déjà acquis se **réinitialise** *(le pattern Julien est nommé, Margot peut entendre)*. Si `mental_stability ≥ 3` côté Margot ET le joueur choisit *écouter* : effet appliqué. Sinon : `relation:emma:-30`, effet non appliqué.
  - Si `relation:emma < Confident` au moment *(refroidi entre le Confident et l'acte)* : Emma **se tait** — observation muette. Pas d'effet mécanique. Mais flag `flag_emma_a_vu_sans_dire = true` posé, qui pèse sur la coda A4.

**Importance canon** : c'est *l'événement utile* de la canon Emma. Tout le reste (cousinage, événements de seuil amont) sert à *créer les conditions* de cet événement. Sans Confident + référence partagée + acte Julien-like + écoute Margot, la mécanique boussole morale ne joue pas.

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `appart_emma_leo` | privé (appart partagé Emma/Léo) | `palier:emma ≥ Allié` |
| Atelier Léo *(si Léo est l'occupant exclusif)* | semi-privé | `palier:leo ≥ Favorable` |

## Hooks scènes

Scènes-types où Emma apparaît typiquement (à spec dans `scenes/`) :

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` *(PRO/A1)* | toujours | Méfiance/Neutre : présentations corpo. Favorable+ : adresses regards à Margot, sourires. Allié+ : initie sujets connexion. |
| `coursive_residents_nuit` *(A1/A2/A3)* | tirage favorable selon état Emma | À Allié+ : peut amorcer conversation hors caméras. Confident : possible que `event_emma_confident` se joue ici si contexte. |
| `cellule_margot_nuit` *(A1/A2/A3)* | si frappe à la porte (sous condition Allié+) | Visite spontanée à Allié+. Confident : moment de partage Julien si l'événement n'est pas encore consommé. |
| `appart_emma_leo` *(A1/A2/A3)* | toujours quand Margot s'y rend | Variant majeur selon présence Léo (off-screen ou non). Confident + Léo absent : déclencheur le plus probable de `event_emma_confident`. |
| `poste_memorize_partage` *(A2/A3)* | si flux Memorize accessibles | Allié+ : peut couvrir Margot dans les rapports (lien à `event_emma_allie`). |
| `confrontation_camille` *(A3)* | Emma off-screen comme témoin distant | Si `flag_julien_reference_partagee` : Emma peut intercepter Margot avant la scène (cf. `event_emma_julien_intervention`). |
| `coda_finale` *(A4)* | systématique | Selon paliers et flags accumulés : pacte fraternel scellé / sacrifice (FIN-C) / rupture / silence. |

---

## Risques structurels

1. **La référence généalogique tombe à plat** *(critique utilisateur 2026-05-22)*. La couche *cousines germaines + brouille familiale via Julien-catalyseur* est un retrofit qui ne se ressent pas dans la jouabilité. Solution à arbitrer : remplacer le mécanisme central par *« Emma a vu Julien, donc peut voir Margot »* (asymétrie de connaissance) et déprécier la couche généalogique. Cf. P0 todo overview.
2. **`event_emma_julien_intervention` exige une référence partagée préalable**. Sans `event_emma_confident` joué, l'intervention A3/A4 n'a pas de base. Vérifier en `graph-audit` matriciel que les conditions sont cohérentes — si le joueur évite l'intimité avec Emma, l'intervention boussole ne se déclenche pas, ce qui rend FIN-I (Julien) significativement plus probable. C'est *intentionnel* (Emma boussole se mérite) mais doit être lisible côté joueur.
3. **Sensitivity reader sur événement Confident**. La bascule cognitive (option canon de désamorçage face au geste affectif) requiert review obligatoire (*playtester-lgbtqia* + *dramaturge* + *playtester-margot*) à l'écriture du `.dtl`. Le risque tropé incestueux malaisant est documenté dans la canon — il se gère ici, pas dans la scène-spec qui hostera l'événement.

---

## Validation locale

- [x] 9 paliers couverts (2 marqués inaccessibles avec justification canon)
- [x] 3 événements de seuil sur paliers (Favorable, Allié, Confident) + 1 événement scénique conditionnel (intervention Julien A3/A4)
- [x] Verrous canon listés exhaustivement (5 verrous)
- [x] Hooks scènes pointent vers scenes/ à créer (toutes en attente de spec)
- [x] Sensitivity reader identifié (Confident + intervention Julien)
- [ ] **À arbitrer** : critique utilisateur sur référence généalogique — décision impactera la canon de Emma
