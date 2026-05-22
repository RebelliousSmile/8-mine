# PNJ Behavior — `marine`

> *La performeuse au bord du gouffre · KAIZEN · 26 ans · femme · Tier 2*
> Source canon : `bible-jeu.md § Marine Dubois` + `overview.md § Cast` + `history.md L361-374 (NODE A2-01C Marine)` + `history.md L462-468 (FIN-E Marine)` + `history.md L935 (dette 45k€ révélation organique)`.

---

## Métadonnées

```yaml
pnj_id: marine
tier: 2
corpo: kaizen
sprite_set: char_marine_*.png
voix_dialogic_id: marine
prenom_var: marine_prenom
```

---

## Verrous canon (sacrés)

1. **Enthousiasme performé, sourire crispé**. Marine *performe* l'enthousiasme (75k abonnés à entretenir) — c'est un masque social qu'elle ne lâche presque jamais en public. Le sourire crispé est canon (Weakness Tag). Toute écriture qui montre Marine *sincèrement* enthousiaste viole canon — c'est toujours travaillé.

2. **45 k€ de dette cachée — PIÈGE narratif majeur**. *« Si elle tombe, cascade crédit solidaire → tout l'immeuble s'effondre »* (canon bible-jeu L488). Toute action de Margot qui expose Marine déclenche la cascade. **Toute branche d'exposition doit comporter un signal narratif de risque visible AVANT le choix** (cf. arc-spec archivé, anti-pattern overview *« Cascade Marine déclenchée par naïveté journalistique sans préavis playtester »*).

3. **Countdown `audit_marine` (15 ticks)**. Mécanique canon : avance via échec social, critique publique. À 0 → licenciement Marine → cascade. *Cf. `variables-register.md § Countdowns narratifs`*. Si countdown atteint 0, scène automatique de chute Marine (à spec dans A3).

4. **Acceptée par tous** (Power Tag canon). Marine a un capital social *réel* — elle est socialement appréciée dans l'immeuble malgré la tension Marine/Thomas. Conséquence : elle peut **couvrir Margot socialement** si Margot l'allie. Toute scène qui montre Marine isolée ou rejetée par l'immeuble viole canon (sauf scène de chute post-cascade).

5. **Révélation organique de la dette** *(tranché 2026-05-21, `history.md L935`)*. La dette 45k€ n'est pas révélée par un canal unique — Margot peut la découvrir via 4 sources canoniques : (a) A1-05 nuit d'écoute si micros posés *(Marine au téléphone créancier)* ; (b) Léo en alliance *(via flux Memorize)* ; (c) Emma en confidence sous pression ; (d) Camille en profilage *(Camille sait, Margot peut le lui faire dire)*. **Tag faille : `transferable`** (l'info circule entre arcs).

6. **Couple Marine × Thomas en tension visible**. Dispute étouffée la nuit (canon `history.md L261`). Thomas encaisse en silence la performance Marine et la dette. La **« rupture visible »** est condition canon de FIN-E Thomas — sans tension Marine/Thomas explicitée à un moment, l'arc Thomas se ferme. *Cf. `pnjs-behavior/thomas.md`.*

7. **FIN-E Marine « Le Livestream »** : aide chaotique et décisive — livestream impromptu qui craque en direct devant ses 75k abonnés. Conséquences pour Marine : *fin de carrière publique* (`flag_marine_carriere_finie = true` — parallèle aux sacrifices Frank/Sofia). Citation canon à valider en `tone-finder`.

**Sensitivity reader requis** : oui — *playtester-accessibilite* (vérifier que le piège dette ne soit pas une punition pour joueur·euse non-spécialiste journalisme) + *dramaturge* (cohérence countdown + cascade).

---

## Voix par palier

Tonalité commune : *performance + crispation sous la performance*. Marine reste presque toujours en représentation. La crispation se voit dans les détails (un demi-temps de trop, un sourire qui s'attarde, une question hâtive).

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | Si Margot a déclenché la cascade | distance professionnelle glaciale | Sourire 0 — c'est canon, le sourire est mort |
| Hostile | Si `flag_marine_ennemie = true` *(canon history L374 — option C de A2-01C)* | accusatrice contenue | Présence en façade, regard qui se détourne |
| Méfiance | Par défaut si Margot a refusé de la couvrir *(option [B] Witness B)* | enthousiasme baisé, plus mécanique | Sourire moins long, recul d'épaules |
| Neutre *(défaut au dîner)* | Enthousiasme performé pleine puissance | *« Tu connais Kaizen Métrique ? »*, *« Tu peux me filmer si tu veux »* | Sourire crispé, regard qui cherche l'approbation |
| Favorable | `flag_marine_veut_couverture = true` activé — Marine voit Margot comme allié potentiel | *« Si tu as besoin d'un fil rouge »*, propose la couverture proactivement | Pose une main sur la table, voix qui descend une demi-octave |
| Allié *(`flag_marine_alliee = true` canon)* | Test couverture réussi *(A2-01C [A])* — Marine accepte que Margot ne la pousse pas | *« Je te dois ça »*, partage info sur les autres résidents | Présence plus détendue, sourire qui s'élargit *vraiment* parfois |
| Proche | Rare — requiert que Marine ait *baissé sa garde* en intime | *« Je sais que c'est faux »*, lâche sur la dette ou Thomas | Sourire qui s'éteint en privé, mains visibles plus immobiles |
| Confident *(plafond canon — ouvre FIN-E Marine)* | Marine accepte l'effondrement — accepte la fin de sa façade | *« Je vais tout dire en live. Aide-moi à pas mourir avec. »* | Présence sans masque, voix nue, regard de plain-pied |
| Fusionnel | *inaccessible canon* — Marine reste toujours une performeuse, même brisée | — | — |

---

## Événements de seuil

### `event_marine_favorable` — palier Favorable franchi *(via [B] Witness B canon)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:marine` franchit Favorable
  - + sujet `evoquer_witness` consommé OU `flag_marine_veut_couverture = true` *(posé au dîner d'arrivée canon `diner_arrivee.dtl` ligne ~70)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Marine propose à Margot une *« couverture »* — angle promotionnel positif sur Kaizen Métrique en échange d'inclusion bienveillante dans le documentaire. Pas un chantage, une *transaction performée comme service mutuel*. Sourire crispé légèrement plus large que d'habitude.
- **Déverrouille** :
  - sujet `accepter_couverture_marine` (cap unique, route `flag_marine_couverture_donnee = true` si acceptée : `relation:marine:+10 · couverture sociale acquise — Marine peut intercéder pour Margot en cas de friction sociale`)
  - flag `flag_marine_propose_couverture = true`

### `event_marine_dette_revelee` — *scénique, 4 canaux canon*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** *(canaux canon `history.md L935`)* :
  - Canal 1 : `flag_micros_poses = true` ET scène `cellule_nuit` jouée *(Marine au téléphone créancier audible)*
  - Canal 2 : `flag_acces_flux_leo = true` ET sujet `examiner_flux_leo_avec_attention` consommé *(Léo transmet via flux Memorize)*
  - Canal 3 : `relation:emma ≥ Allié` ET sujet `parler_des_residents_avec_emma` consommé *(Emma en confidence)*
  - Canal 4 : `relation:camille ≥ Favorable` ET sujet `lire_marine_avec_camille` consommé *(Camille connaît, peut le faire dire)*
- **Mode** : immédiat dans le canal qui le déclenche
- **Effet** :
  - Pose `flag_marine_dette_connue = true` *(EV+1 : Margot sait maintenant)*
  - **Choix Margot ouvert dans toute scène A2-A3 avec Marine** :
    - Sujet `aborder_dette_marine_doucement` *(disponible si `flag_marine_dette_connue = true`)*
      - À palier Allié+ : `relation:marine:+15 · MS+1 · flag_marine_confidence_active = true`
      - À palier ≤ Favorable : `relation:marine:-10 · sourire de surface mais blessure interne`
    - Sujet `aborder_dette_marine_frontalement` *(disponible si EV ≥ 4)*
      - **PIÈGE CANON** : pose `flag_marine_pression_directe = true · countdown:audit_marine:-3 ticks` *(Marine recule mais l'audit accélère par stress visible)*
    - Sujet `exposer_marine_publiquement` *(jamais disponible automatiquement — déclenchable uniquement si Margot tape *manuellement* l'option ou via Witness exigence)*
      - **DÉCLENCHE LA CASCADE** : `flag_cascade_marine = true · countdown:audit_marine:0 · effondrement immeuble pose flag_immeuble_effondre`. Documenté comme anti-pattern à signaler en review.

### `event_marine_allie` — palier Allié franchi *(canon FLAG_MARINE_ALLIEE)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:marine` franchit Allié *(≥ +40)*
  - + `flag_marine_dette_connue = true` ET Margot a choisi `aborder_dette_marine_doucement` à palier Allié+
  - + sujet canon `[A] Offrir une couverture éthique` consommé *(canon history L362-365 NODE A2-01C)*
- **Mode** : immédiat
- **Effet** :
  - Pose `flag_marine_alliee = true` *(canon)*
  - `countdown:audit_marine:-2` *(Marine relâche la pression interne, audit recule)*
  - `EV+1:info_thomas` *(Marine partage info sur Thomas — c'est la couche cachée du couple, accessible via Marine)*
  - Déverrouille hook `event_marine_proche` *(palier suivant)*

### `event_marine_rupture_visible_amorce` — *scénique, rupture couple visible*

- **Type** : événement scénique conditionnel one-shot
- **Conditions de déclenchement** :
  - `flag_marine_alliee = true` OU `flag_marine_pression_directe = true`
  - + countdown `audit_marine ≤ 8` *(pression interne assez haute pour que la tension couple éclate visiblement)*
- **Mode** : immédiat dans la prochaine scène où Marine ET Thomas sont co-présents *(zone_commune_soir au dîner hebdomadaire, ou audible via cellule_nuit)*
- **Effet** :
  - **Dispute visible** entre Marine et Thomas — Marine craque, Thomas marmonne quelque chose de cynique qui dépasse la limite, Marine quitte la pièce
  - Pose `flag_marine_thomas_rupture_visible = true` *(condition canon FIN-E Thomas — cf. `pnjs-behavior/thomas.md`)*
  - `relation:marine:-5` *(public — exposition de la performance défaillante)*
  - `relation:thomas:+5` *(Thomas peut désormais s'ouvrir à Margot — sa résignation a une fissure)*

### `event_marine_proche` — palier Proche franchi *(masque qui craque en privé)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:marine` franchit Proche *(≥ +50)*
  - + `flag_marine_alliee = true`
  - + contexte intime privé *(appart_marine_thomas avec Thomas absent OU cellule_margot_nuit si Marine injectée)*
- **Mode** : différé strict
- **Réaction scriptée** *(résumé)* :
  > Marine éteint ses lumières — geste rare, presque sacré pour quelqu'un qui vit en exposition permanente. Le sourire crispé disparaît pour la première fois. Voix nue. *« Je sais que c'est faux. Tout. Et je ne sais pas comment faire autrement maintenant. »*
- **Déverrouille** :
  - sujet `parler_du_faux_avec_marine` dans toutes scènes intimes ultérieures
  - flag `flag_marine_masque_baisse = true`

### `event_marine_confident` — palier Confident franchi *(ouvre FIN-E Marine)*

- **Type** : montée, one-shot
- **Conditions** :
  - `relation:marine` franchit Confident *(≥ +60)*
  - + `flag_marine_masque_baisse = true`
  - + `MS ≥ 3` côté Margot *(condition canon FIN-E)*
- **Mode** : différé
- **Réaction scriptée** *(résumé)* :
  > Marine propose le livestream impromptu : *« Je vais tout dire en live. Aide-moi à pas mourir avec. »* — c'est le sacrifice canon. Sa carrière publique se finit, mais l'immeuble est protégé *(Marine pré-publie, désamorce la cascade par publicité contrôlée)*.
- **Déverrouille** :
  - coda FIN-E Marine *« Le Livestream »* accessible
  - flag `flag_marine_carriere_finie = true` *(sacrifice parallèle Frank/Sofia)*
  - `EV+2 · countdown:audit_marine:0` *(forçage neutre — l'audit ne peut plus déclencher la cascade, Marine a pris les devants)*

---

## Hooks scènes

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `diner_arrivee` ✅ | forcée *(premier dîner)* | Neutre : enthousiasme performé pleine puissance, *« Tu connais Kaizen Métrique ? »* |
| `zone_commune_jour` *(à spec)* | présence régulière | Marine livestream dans la zone parfois, présence sociale active |
| `coursive_residents_nuit` *(à spec)* | rare *(Marine couché tard pour ses streams)* | Si croisée : sourire crispé, performance même de nuit |
| `cellule_margot_nuit` ✅ | si dette révélée canal 1 micros : Marine audible au téléphone créancier | Sons à travers le mur uniquement |
| `appart_marine_thomas` *(à spec, privé `palier:marine ≥ Allié` ou `palier:thomas ≥ Allié`)* | systématique heures privées | Hub des événements ≥ Proche, lieu probable de `event_marine_proche` |
| `coda_finale` *(A4)* | variable selon `flag_marine_*` | FIN-E Marine *« Le Livestream »* ; ou cascade si exposée ; ou silence si refusée |

---

## Seuils d'accès aux espaces privés *(cf. overview.md § Gating)*

| Scène | Espace | Seuil d'accès |
|-------|--------|---------------|
| `appart_marine_thomas` | privé *(couple Marine/Thomas)* | `palier:marine ≥ Allié` OU `palier:thomas ≥ Allié` *(coordonné avec `pnjs-behavior/thomas.md`)*. **Note** : pas de verrou *« couple intact »* comme Sofia/Alex — le couple Marine/Thomas est en tension visible par défaut, l'intrusion conjugale est *moins coûteuse symboliquement* (mais plus mécaniquement risquée à cause de la cascade dette). |

---

## Risques structurels

1. **Cascade dette déclenchée par naïveté journalistique**. Anti-pattern explicitement listé dans `overview § Anti-patterns d'écriture`. Risque : joueur sympathique à l'éthique journalistique expose Marine pour gagner EV, déclenche cascade, perd le run. Mitigation : `event_marine_dette_revelee` doit *toujours* afficher en commentaire ou narration : *« Si Margot expose Marine pour gagner EV, elle déclenche elle-même la cascade. »* Et le sujet `exposer_marine_publiquement` n'est pas auto-disponible — il requiert un acte explicite du joueur. À vérifier en `dramaturge` + `auditeur-scene`.

2. **Marine comme stéréotype influenceuse vide**. Risque trope : Marine réduite à *« la fille superficielle qui souffre »*. Mitigation : verrou 4 (acceptée par tous, capital social réel) doit être présent dans chaque scène — Marine est *socialement compétente*, pas naïve. Son enthousiasme est *travaillé*, pas creux. Les détails canon (75k abonnés, performance crispation, déni actif) doivent rester en sous-texte. Vérifier en `playtester-accessibilite`.

3. **Coordination dispute Marine/Thomas**. La rupture visible est condition canon FIN-E Thomas. Si l'arc Marine progresse rapidement à `flag_marine_alliee = true` sans dispute Marine/Thomas explicite, l'arc Thomas se bloque. Mitigation : `event_marine_rupture_visible_amorce` est forcé automatiquement quand conditions remplies (countdown ≤ 8 + alliée OU pression). Vérifier en `auditeur-scene` matriciel que la cohérence inter-arcs tient.

---

## Validation locale

- [x] 9 paliers couverts (Fusionnel inaccessible canon — Marine reste performeuse, même brisée)
- [x] 6 événements de seuil (favorable, dette_revelee scénique 4 canaux, allié canon, rupture_visible_amorce scénique, proche, confident)
- [x] Verrous canon explicites (7) alignés avec `bible-jeu.md` + `history.md` + threads tranchés 2026-05-21
- [x] Hooks scènes pointent vers scenes existantes (`diner_arrivee` ✅, `cellule_nuit` ✅) ou à créer
- [x] Sensitivity reader identifié (`playtester-accessibilite` + `dramaturge`)
- [x] Seuil d'accès appart cohérent avec `pnjs-behavior/thomas.md` (à spec)
- [x] Coordination cross-PNJ Thomas explicite (rupture visible condition canon FIN-E Thomas)

---

## Validation Marine dans `diner_arrivee.dtl` (audit retroactif)

| Réplique `.dtl` | Palier | Verrou respecté ? |
|-----------------|--------|-------------------|
| *« Marine se penche, presque imperceptible. Tu vas filmer quoi exactement ? »* + *« On peut prévoir. Si tu as besoin d'un fil rouge. »* *(presentation [B])* | Neutre → Favorable amorce | ✓ enthousiasme performé, propose la couverture, pose `flag_marine_veut_couverture` canon |
| *« Tu connais Kaizen Métrique ? Je suis l'ambassadrice publique. Quatre-vingts mille abonnés. »* *(demander_role)* | Neutre | ✓ enthousiasme performé, sourire crispé canon |
| *« Tu peux me filmer si tu veux. »* — trop enthousiaste *(evoquer_witness)* | Neutre | ✓ canon *« acceptée par tous »* + crispation invisible |
| Variante observation_silence : *« Marine rit à une blague de Léo. Le rire est une demi-seconde trop long. »* | Neutre | ✓ détail crispation canon |

**Verdict** : le `.dtl` `diner_arrivee` respecte les verrous canon de Marine. **Aucune correction nécessaire**.

---

## Coordination cross-PNJ

- **Avec `pnjs-behavior/thomas.md` (à spec, suivant immédiat)** : couple en tension visible. `event_marine_rupture_visible_amorce` est la **clé canon** qui débloque l'arc Thomas (condition FIN-E Thomas). Coordination obligatoire.
- **Avec `pnjs-behavior/leo.md` ✅** : Léo peut transmettre la dette de Marine via flux Memorize (canon `history.md L935` canal 2). Hook documenté.
- **Avec `pnjs-behavior/emma.md` ✅** : Emma peut révéler la dette en confidence sous pression (canal 3). Hook documenté.
- **Avec `pnjs-behavior/camille.md` ✅** : Camille connaît la dette, peut le faire dire à Margot via sujet `lire_marine_avec_camille` (canal 4, déclenche `event_camille_allie` simultanément).
- **Avec `pnjs-behavior/sofia.md` ✅** : Sofia peut intervenir éthiquement si l'audit Marine devient public — mais sans expose direct, alliance possible Sofia + Margot pour protéger Marine en A3.
- **Avec `pnjs-behavior/frank.md` ✅** : Frank évalue Marine indirectement — si Marine cascade, Stratom prend l'opportunité pour escalader la surveillance de tout l'immeuble (countdown `equipe_nettoyage` accéléré).
