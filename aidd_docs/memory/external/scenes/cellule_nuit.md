# Scene Specification — `cellule_nuit`

> Scène **récurrente** : Margot seule dans sa cellule, cycle nuit. Sons des appartements voisins audibles. Hub d'événements de seuil intimes *(notamment Emma à Allié+ et Confident)*.
> Base canon : `history.md L259-288` (NODE [A1-05] *Première nuit*). Recyclage des sujets historiques + extensions par paliers.

---

## Métadonnées

```yaml
scene_id: cellule_nuit
timeline: dialogic/timelines/cellule_nuit.dtl
lieu: cellule_margot_nuit
recurring: true
actes: [A1, A2, A3]            # plusieurs cycles nuit possibles par run
output_style: scenario
```

---

## Lieu et ambiance

- **Background** : `bg_cellule_margot_nuit.jpg`
- **Atmosphère** : 23h. Lumière coupée, seules les LED des appareils éclairent. Bruit ambiant des appartements voisins audible à travers les murs (cf. canon `a1_nuit.dtl`) :
  - Marine/Thomas : dispute étouffée
  - Emma/Léo : intimité audible
  - Sofia/Alex : conversation intime de couple à voix basse — tension éthique en sous-texte, registre dominant = couple
  - Camille/Frank : silence total

---

## Jauges activables (scope déclaratif)

| Jauge | Activable ? | Plage typique de delta | Justification |
|-------|-------------|------------------------|---------------|
| `relation:emma` | **oui** | +1..+3 si Emma frappe à la porte (événement seuil) | Hub principal pour les événements de seuil Emma intimes |
| `relation:<autre_pnj>` | **oui** *(limité)* | +1..+2 sur `[D] sortir croiser quelqu'un` | Rencontre nocturne avec Frank/Thomas/Léo possible |
| `MS` | **oui** | ±1 | Voyeurisme baisse MS ; retrait éthique remonte MS |
| `PD` | **oui** | +0..+2 | Sortir de la cellule la nuit → caméras → PD si échec discrétion |
| `EV` | **oui** | +0..+2 | Écouter capte du concret (notamment Marine/dette si micros posés) |
| `mirror` | **oui** | +0..+5 | L'écoute voyeuriste est de l'instrumentalisation → mirror+ |
| `surveillance` | **oui** | +0..+5 si sortie nocturne échoue | Caméras détectent |
| `reputation:<faction>` | **non** | — | Scène solitaire, aucune corpo informée |
| `countdown:equipe_nettoyage` | **oui** *(rare)* | +1 tick si surveillance franchit 75 dans la scène | Seuil monotone existant Surveillance déclenche |

---

## PNJs susceptibles d'être présents

| PNJ | Condition de présence | Sprite par défaut |
|-----|----------------------|-------------------|
| `emma` | si événement de seuil `event_emma_*` déclenché → Emma frappe à la porte. Sinon : audible à travers le mur (voix off) | `char_emma_visite_nuit_*.png` *(à créer)* |
| `frank`, `thomas`, `leo` | si Margot choisit `[D] sortir croiser quelqu'un` et tirage favorable | sprites existants |

*Hors événements de seuil et hors sortie nocturne, Margot est seule.*

---

## Trigger d'apparition

- **Conditions narratives** : cycle nuit (après dîner / après scène d'acte) + Margot dans sa cellule.
- **Cooldown / cap** :
  - Cycle régulier (1 par jour in-game).
  - Cap total sur le run : ~6-8 fois (chaque acte a 1-3 cycles nuit).
  - Contenu des sujets varie selon état des jauges et flags accumulés *(la 1ère nuit ≠ la 5ème)*.

---

## Dialogues d'ambiance

```
# Intro (à l'entrée — toujours joué, variantes selon flag_premiere_nuit)
[narrator si flag_premiere_nuit=false] 23h. Cellule. La routine du soir.
[narrator si flag_premiere_nuit=true]  23h. Cellule. Premier soir.
                                       Les murs sont fins. Plus fins qu'elle pensait.
[ambiance sonore] Marine/Thomas étouffés · Emma/Léo audibles · Sofia/Alex voix basse · Camille/Frank silence

# Outro (à la sortie — selon sujet final consommé)
[narrator si MS gagné]  Margot éteint la lumière. Quelque chose s'est calmé.
[narrator si MS perdu]  Margot éteint la lumière. Quelque chose pèse.
[narrator si EV gagné] Margot ferme son carnet. Pas vide, ce soir.
```

---

## Sujets disponibles

### Sujet `ecouter_activement` — *« Coller l'oreille au mur et noter »*

- **Condition d'apparition** : toujours
- **Cible** : Margot seule
- **Effets de base** :
  - Si `flag_micros_poses = true` → flux audio clair, *pas de vérification* — `EV +1 · MS -1`
  - Si `flag_micros_poses = false` → vérification cachée sur PD courant → réussite : `EV +1 · MS -1` · échec : `EV +0 · MS -1` *(fragments confus, l'effort pèse sans rapporter)*
  - Mirror : `+5` *(c'est de l'instrumentalisation, voyeurisme conscient)*
- **Cap** : 1 fois par nuit *(rejouable cycles ultérieurs)*

#### Contenu capté (selon nuit + flags)

| Cycle nuit | Contenu capté résumé | Flag posé |
|------------|----------------------|-----------|
| Nuit 1 *(première fois)* | Dispute Marine/Thomas étouffée — voix de Marine *« Tu sais combien… »*, coupée. Suggestion de la dette sans le chiffre | `flag_marine_dispute_entendue=true` |
| Nuit 1 + `flag_micros_poses=true` | Voix claire : Marine au téléphone, créancier, mot *« quarante-cinq »* | `flag_marine_dette_entendue=true · EV+1 supplémentaire` |
| Cycle 2+ + `relation:emma >= Allié` | Intimité Emma/Léo audible mais cette fois Margot entend Emma rire — léger, normal | `flag_emma_audible_rire=true` *(module la coloration des sujets emma)* |
| Cycle 3+ + `relation:sofia >= Favorable` | Voix Sofia/Alex à voix basse : Sofia dit *« Tu ne mentiras pas à Margot, n'est-ce pas »* — entend la confiance, pas la confrontation | `flag_sofia_protege_margot=true` |

### Sujet `mettre_ecouteurs` — *« Mettre les écouteurs, ne pas écouter »*

- **Condition d'apparition** : toujours
- **Cible** : Margot seule
- **Effets de base** : `MS +1`
- **Cap** : 1 fois par nuit
- **Effet narratif** : maintient FIN-F et FIN-A accessibles. Pose `flag_nuit_<N>_ecart_ethique = true`.

### Sujet `ecouter_comprendre` — *« Écouter sans documenter, juste comprendre »*

- **Condition d'apparition** : `relation:<au moins un PNJ audible> >= Favorable` *(Margot tient à quelqu'un dans l'immeuble)*
- **Cible** : Margot seule
- **Effets de base** :
  - Vérification cachée sur `relation:<pnj entendu>` au-dessus de Favorable → réussite : `MS +0` *(neutre, compréhension)* · échec : `MS +0 · fragments confus`
  - Mirror : `+0` *(intention non-instrumentale)*
- **Cap** : 1 fois par nuit
- **Effet narratif** : pose `flag_nuit_<N>_ecoute_comprehensive=true` qui peut moduler les répliques par palier dans les scènes ultérieures avec le PNJ entendu.

### Sujet `sortir_croiser` — *« Descendre, croiser quelqu'un d'éveillé »*

- **Condition d'apparition** : `MS >= 3` *(pas trop fatiguée)* ET `mental_stability >= 2`
- **Cible** : Margot seule à l'amorce, puis tirage de PNJ rencontré
- **Effets de base** :
  - Vérification cachée sur PD courant :
    - Réussite + tirage favorable : rencontre nocturne avec **frank**, **thomas** ou **léo** selon `relation:` la plus haute parmi ces 3 + `flag_rencontre_nocturne_<pnj>=true` · `relation:<pnj>:+2`
    - Échec : caméra détecte → `PD +1 · surveillance +5`
- **Cap** : 1 fois par nuit, 2-3 fois max sur le run *(au-delà = pattern dangereux trop visible)*

#### Sous-routes par PNJ croisé

Selon le PNJ rencontré, un mini-événement scénique s'enclenche (référence : pnj-behavior:frank/thomas/leo à spec) :
- **frank** : test silencieux *(décrement countdown `equipe_nettoyage` de 1 si réussite intégrité)*
- **thomas** : conversation cynique à voix basse — partage anecdote Kaizen
- **leo** : croisement dans l'atelier *(débloque sujet `voir_les_flux` si Margot pose les bonnes questions)*

### Sujet `frapper_chez_emma` — *« Aller frapper chez Emma »*

- **Condition d'apparition** : `relation:emma >= Allié` ET cycle nuit ≥ 2 *(pas la première nuit, ce serait étrange)*
- **Cible** : `emma`
- **Effets de base** :
  - Vérification cachée *(passage devant la caméra du couloir)* : réussite `PD+0` · échec `PD+1`
  - À l'arrivée : selon palier emma → réponse différente
- **Cap** : 1 fois par cycle, 3 fois max par run

#### Table de réponses Emma

| Palier emma | Réplique (résumé) | Effets |
|-------------|-------------------|--------|
| Allié | *« Margot. Léo dort. Tu rentres ? »* | `relation:emma:+1` · entre, scène se prolonge avec sujet privé court |
| Proche | *« Je commençais à espérer que tu viennes. »* | `relation:emma:+2` · scène intime, peut déclencher `event_emma_confident` si conditions |
| Confident | événement de seuil prioritaire — voir section suivante | — |

---

## Événements de seuil susceptibles de se jouer ici

| Event ID | Source | Déclenchement | Effet |
|----------|--------|---------------|-------|
| `event_emma_allie` | `pnj-behavior:emma` | Si `flag_event_emma_allie_pending = true` ET cycle nuit ≥ 2 ET Margot reste en cellule (ne sort pas) | **Emma frappe à la porte** *(initiative PNJ)*. Propose à Margot de la couvrir dans les rapports Memorize. Déverrouille sujet `accepter_couverture_emma` ici-même. |
| `event_emma_confident` | `pnj-behavior:emma` | Si `flag_event_emma_confident_pending = true` ET *(Margot a frappé chez Emma OU Emma frappe spontanément)* ET contexte intime *(Léo absent, audible par mur)* | Emma raconte Julien — *établissement de la référence partagée*. Pose `flag_julien_reference_partagee = true`. La scène se prolonge significativement. Sensitivity reader OBLIGATOIRE à l'écriture. |
| `event_seuil_surveillance_75` | `SurveillanceManager` *(natif code)* | Si surveillance franchit 75 pendant la scène *(via échec sortie nocturne)* | Cinematic + tick auto `equipe_nettoyage`. Joué via signal natif. |

---

## Conditions de sortie

- **Cap sujets par visite** : 2 sujets max par nuit *(au-delà, Margot s'endort — outro forcée)*
- **Forced exit** :
  - Sortie nocturne échoue → outro alerte
  - Événement de seuil Emma consommé → outro spéciale après scène prolongée
  - 2 sujets consommés → outro paisible / pesante selon delta MS

---

## Risques structurels

1. **Cap mirror cumulé sur runs longs**. La scène est récurrente (6-8 fois max) et `ecouter_activement` pose `mirror +5` à chaque fois. Pire cas joueur compulsif : `mirror +30` cumulé sur les nuits seules. Mitigation : la voie *« comprendre »* (sujet `ecouter_comprendre`) ne pose pas de mirror et reste accessible si Margot a au moins une relation Favorable+. À monitorer en `graph-audit` matriciel.
2. **Tirage du PNJ rencontré en `sortir_croiser`**. Le tirage doit être déterministe selon relations (pas RNG aveugle), sinon le joueur ne comprend pas pourquoi il croise Frank vs Thomas. Convention : *PNJ avec la plus haute relation:* parmi les 3 candidats au moment T ; à égalité, ordre `frank > thomas > leo` par défaut. Documenter en `write-dtl` pour cohérence.
3. **`event_emma_confident` est l'événement le plus délicat de la canon Emma**. Sa scène prolongée doit respecter tous les verrous (pas de complicité d'enfance, bascule cognitive vs interdit moral, etc.). Passage obligatoire par `playtester-lgbtqia` + `dramaturge` + `playtester-margot` AVANT toute écriture du `.dtl` correspondant. Le sujet n'apparaît jamais comme option *« faire l'amour avec Emma »* — c'est un événement narratif, pas un choix joueur.

---

## Validation locale

- [x] Toutes les jauges modifiées par les sujets sont déclarées en *Jauges activables*
- [x] Aucune jauge hors-scope touchée *(reputation:factions explicitement out)*
- [x] Toutes les jauges existent dans `variables-register.md`
- [x] `pnj-behavior:emma` existe et ses événements de seuil sont référencés correctement
- [x] `pnj-behavior:frank/thomas/leo` à spec — référence faite, hooks pointent vers fichiers à créer
- [x] Aucun sujet sans effet
- [x] Tables de réponses couvrent les paliers où le sujet est accessible
- [x] Verrous canon respectés *(notamment Emma fusion-confusion non consommée — `event_emma_confident` reste un événement narratif, pas une option de drague)*
