# Scene Specification — `diner_arrivee`

> Première scène multi-PNJ : le dîner d'arrivée. Convergence après PRO/A1-01.
> Joue une seule fois par run *(scène one-shot mais matricielle — beaucoup de sujets × PNJ)*.
> Recyclage du contenu historique `nodes/_archive/...` et `history.md L191-225` (NODE [A1-03] *Dîner collectif : les huit*).

---

## Métadonnées

```yaml
scene_id: diner_arrivee
timeline: dialogic/timelines/diner_arrivee.dtl
lieu: zone_commune_soir
recurring: false                # one-shot — c'est LE premier dîner
actes: [A1]
output_style: scenario
acces_requis:
  - public                      # zone commune — pas de gating relation
```

---

## Lieu et ambiance

- **Background** : `bg_zone_commune_soir.jpg`
- **Atmosphère** : table dressée pour 9, lumière chaude tamisée, vue sur cour Saint-Michel à travers une baie. Sons : vaisselle, conversations à voix basse, ambiance pluie sur la baie. Position canon de Margot : *entre les deux blocs* (cf. session-exemple-01 — décision de mise en scène).

---

## Jauges activables (scope déclaratif)

> **Déterminisme** *(fix audit dramaturge 2026-05-22)* : chaque sujet déclare ses deltas de manière **fixe et déterministe**, sans variabilité aléatoire. Cap par sujet × cap par scène = budget jauge maximal déterministe.

| Jauge | Activable ? | Plage typique de delta | Justification + déterminisme |
|-------|-------------|------------------------|------------------------------|
| `relation:emma`, `relation:leo`, `relation:marine`, `relation:thomas`, `relation:sofia`, `relation:alex`, `relation:camille`, `relation:frank` | **oui** | ±2 par sujet, ±1 par interaction question_role | **Déterministe** : `demander_role_pnj` pose `+1` fixe par cible, cap 1 par PNJ par scène. `presentation [A]` pose `relation:sofia:+2` fixe. Pas de RNG. |
| `MS` | **oui** | ±1 | Déterministe par branche : `presentation [A]` = +1 ; `observer_silence` = -1. Pas de cumul aléatoire. |
| `PD` | **oui** | +0..+1 | Déterministe : `presentation [C] échec` = +1, sinon 0. |
| `EV` | **oui** | +0..+1 par sujet, cap +3 cumulé sur la scène | Déterministe : `observer_silence` = +1 ; `demander_role:emma palier ≥ Favorable` = +1 ; `demander_role:sofia` = +1 (Sofia évoque collecte passive). Cap cumulé +3 pour empêcher accumulation excessive. |
| `mirror` | **non** | — | Pas d'acte de manipulation explicite à ce stade |
| `surveillance` | **non** | — | Scène publique encadrée |
| `reputation:presse`, `reputation:memorize`, `reputation:stratom` | **oui** | déterministe par sujet | `evoquer_witness` = `reputation:presse:+2` fixe. `presentation [C] échec` = note implicite Stratom *(via Camille)*. |
| `countdown:*` | **non** | — | Aucun countdown ne tick à ce dîner |

**Règle de déterminisme canon** : si Margot pose 2 fois le même sujet *(impossible mécaniquement via cap, mais doctrinal)*, le delta serait appliqué 2 fois. Aucun delta n'est conditionné à un tirage aléatoire — uniquement à des paliers/flags vérifiés au runtime.

---

## Variables PNJ (résolution de présence)

**Cas spécial** : *premier* dîner d'arrivée canon → les 8 résidents sont **forcés présents** (vitrine officielle N2, voir overview Topologie). Aucune variable à résoudre. Les dîners hebdomadaires ultérieurs *(scene-spec `diner_hebdomadaire` à produire)* auront eux une vraie résolution variable.

### Pool de candidats (tous forcés)

| PNJ | Règle de présence | Variante absent | Sprite |
|-----|-------------------|------------------|--------|
| `emma` | forcé *(premier dîner)* | — *(jamais absent canon)* | `char_emma_diner_*.png` |
| `leo` | forcé | — | `char_leo_diner_*.png` |
| `marine` | forcé | — | `char_marine_diner_*.png` |
| `thomas` | forcé | — | `char_thomas_diner_*.png` |
| `sofia` | forcé | — | `char_sofia_diner_*.png` |
| `alex` | forcé | — | `char_alex_diner_*.png` |
| `camille` | forcé | — | `char_camille_diner_*.png` |
| `frank` | forcé | — | `char_frank_diner_*.png` |

---

## Trigger d'apparition

- **Conditions narratives** : sortie de tout NODE A1-01-* (micro / éthique / confrontation / stratège). Premier soir de Margot à Saint-Michel.
- **Cooldown / cap** : *one-shot* — la scène ne se rejoue pas. Les dîners ultérieurs seront des `diner_hebdomadaire` (scene-spec séparée à produire).

---

## Dialogues d'ambiance

```
# Intro (à l'entrée — toujours joué)
[narrator] La porte coulisse. Huit visages se tournent vers elle.
[narrator] Margot prend sa place — entre les deux blocs, comme par accident.
[ambiance sonore] vaisselle qui s'installe, conversation qui reprend bas

# Outro (à la sortie — variantes selon flag_camille_cliffhanger_pose)
[narrator si cliffhanger] "Parle-nous un peu de toi. Tu viens d'où ?"
                          La pièce se fige. La scène coupe.
[narrator sinon]          Le café arrive. Margot lève les yeux.
                          La table s'éparpille en conversations parallèles.
```

---

## Sujets disponibles

### Sujet `presentation` — *« Comment te présenter à la table »*

- **Condition d'apparition** : toujours *(sujet d'entrée — forcé en début de dîner)*
- **Cible** : tous PNJs présents *(broadcast)*
- **Effets de base** : pose `flag_diner_presentation_choisie = true`
- **Cap** : unique *(un seul choix de présentation par dîner)*

#### Variantes de présentation

| Variante Margot | Effets jauges | Effets flags |
|-----------------|---------------|--------------|
| `[A]` Honnêteté complète : parler de Julien/Julie | `relation:sofia:+2 · MS+1 · relation:camille:+1 cachée` | `flag_camille_profil_trauma=true` *(Camille recueille)* · débloque sujet `parler_avec_sofia_profond` en A2 |
| `[B]` Professionnalisme strict : documentaire | `relation:tous:+0` *(neutre)* | `flag_marine_veut_couverture=true` |
| `[C]` Mensonge valorisant : grande mediacorp | requiert `FLAG_MOTIVATION ∈ {argent, carriere}`. Sofia fait vérif Witness cachée : réussite (`relation:marine:+2 · respect:+1`) ou échec (`relation:sofia:-3 · PD+1 · flag_menteuse_demasquee=true`) | — |
| `[D]` Évasif : *« Ça ne se résume pas »* | `relation:thomas:+1` *(complice du flou)* · `relation:camille:-1` *(intriguée mais frustrée)* | `flag_diner_presentation_evasive=true` |

### Sujet `demander_role_pnj` — *« Demander à un résident son rôle dans l'immeuble »*

- **Condition d'apparition** : après `presentation` consommée
- **Cible** : 1 PNJ ciblé parmi les 8
- **Effets de base** : `EV+1` *(si la réponse révèle du concret)* · `relation:<cible>:+1`
- **Cap** : 2 fois max par dîner *(on ne grille pas 8 questions)*

#### Table de réponses (résumées par PNJ × palier disponible au dîner — paliers majoritairement Neutre, parfois Favorable si flag favorable amont)

| Cible | Palier | Réplique (résumé) | Effets supplémentaires |
|-------|--------|-------------------|------------------------|
| `emma` | Neutre | *« Analyste flux Memorize. »* — réponse courte, formelle | — |
| `emma` | Favorable+ *(si A1-01-confrontation = [A])* | *« Je peux te montrer quelque chose après le repas. Pas ici. »* | déverrouille sujet privé après dîner *(scene `coursive_residents_nuit`)* |
| `leo` | Neutre | *« Design d'interfaces. »* — un sourire bref, ne développe pas | — |
| `marine` | Neutre | *« Tu connais Kaizen Métrique ? Je suis l'ambassadrice. »* — sourire crispé | `relation:marine:+1 supplémentaire` *(elle veut être vue)* |
| `thomas` | Neutre | *« J'ingénie. C'est très palpitant. »* — regarde son verre | — |
| `sofia` | Neutre | *« Département éthique Nexus. »* — pose, regarde Margot droit | `EV+1 supplémentaire` *(elle évoque les flux passifs)* |
| `alex` | Neutre | *« Technique. Maintenance des systèmes. »* — bref, regard vers Sofia | — |
| `camille` | Neutre | *« Profilage comportemental, Stratom. »* — voix chaleureuse, observe | `flag_camille_a_remarque_margot=true` |
| `frank` | Neutre | *« Sécurité. »* — un seul mot, regard prolongé | `PD+0 mais pose flag_frank_a_observe=true` |

### Sujet `evoquer_witness` — *« Mentionner ton contrat avec Witness »*

- **Condition d'apparition** : après `presentation = [B] (pro)` OU `[D] (évasif)`. Pas après `[A]` *(Margot aurait déjà tout dit)* ni `[C]` *(elle ment, ne va pas se contredire)*.
- **Cible** : tous PNJs présents
- **Effets de base** : `reputation:presse:+2`
- **Cap** : unique

#### Réactions PNJ

| Cible | Palier | Réplique (résumé) | Effets |
|-------|--------|-------------------|--------|
| `sofia` | tout palier | *« Je vais probablement voir tes rushes. Pas pour censurer. »* | `relation:sofia:+1 · flag_sofia_signale_protection=true` |
| `camille` | tout palier | *« Witness… intéressant choix. »* — sourire fin | `relation:camille:+1 · flag_camille_a_pris_note=true` |
| `marine` | tout palier | *« Tu peux me filmer si tu veux. »* — trop enthousiaste | `relation:marine:+1` |
| autres | — | regards échangés, pas de réplique frontale | — |

### Sujet `observer_silence` — *« Ne rien dire, observer la table »*

- **Condition d'apparition** : `presentation` consommée
- **Cible** : Margot seule *(action sans cible)*
- **Effets de base** : `EV+1 · MS-1 · relation:tous:-0.5` *(perçue distante mais pas hostile — arrondi à -1 pour le PNJ qui interpelle ensuite)*
- **Cap** : unique *(plus d'une fois et la table le remarque, soft fail)*

#### Effet narratif

Margot capte un détail (un échange de regards, une crispation de Marine, un silence de Frank qui pèse). Un flag d'observation aléatoire est posé selon configuration des PNJ : `flag_diner_observation_<emma_leo_silence|marine_crispation|frank_observation_silencieuse|sofia_alex_intime|camille_scan>` — *l'un d'eux choisi pseudo-aléatoirement parmi les disponibles à l'état actuel*. Chacun débloque un mini-sujet ciblé en A1-06.

---

## Événements de seuil susceptibles de se jouer ici

| Event ID | Source | Déclenchement | Effet |
|----------|--------|---------------|-------|
| `event_camille_cliffhanger` | `pnj-behavior:camille` *(à spec — P1)* | Outro forcée si `flag_diner_presentation_choisie = true` ET `presentation ∈ {[A], [C], [D]}` | Camille pose *« Tu viens d'où ? »* en fin de dîner → cliffhanger, scène coupe. Pose `flag_camille_cliffhanger_pose = true` |
| `event_emma_favorable` *(buffer possible)* | `pnj-behavior:emma` | Joué immédiat si `relation:emma` franchit Favorable pendant ce dîner *(possible si arrivée à +18 et `[A]` donne +2)* ET contexte intime *(emma adresse un regard appuyé à Margot)* — sinon **bufferisé** | Réaction Emma minimale dans la scène, événement complet différé à `coursive_residents_nuit` |

---

## Conditions de sortie

- **Cap sujets par visite** : `presentation` *(forcé)* + 2-3 sujets optionnels *(typiquement `demander_role_pnj` × 2 + 1 sujet supplémentaire)*
- **Forced exit** : `event_camille_cliffhanger` (la plupart des runs) OU `outro_paisible` si présentation = `[B]` propre et aucun cliffhanger déclenché

---

## Risques structurels

1. **Saturation cognitive** : 8 PNJs à la table + 4 sujets disponibles = beaucoup d'options visibles. Mitigation : seul `presentation` est forcé en entrée. Les autres sujets apparaissent *après* consommation de `presentation` *(staged disclosure)*, et `demander_role_pnj` est cappé à 2. Total options affichées simultanément : ≤ 4.
2. **Sofia vérif Witness sur `[C]` mensonge** : la vérification est cachée mais ses effets sont importants (PD+1, relation:sofia:-3). Vérifier en playtest que le joueur perçoit le risque AVANT de choisir `[C]` *(le verrou `FLAG_MOTIVATION ∈ {argent, carriere}` aide — seuls les joueurs avec ces motivations peuvent choisir et savent qu'ils mentent)*.
3. **Distinguer Marine/Thomas/Emma sonorement** : la canon `session-exemple-01.md` note que chaque PNJ doit "sonner" différent. Risque de production : les répliques de Neutre se ressemblent trop si on copie-colle. À soigner en `tone-finder` PNJ par PNJ. Mitigation : la table par PNJ ci-dessus donne des distinctions explicites *(une expression, une posture, un détail)*.

---

## Validation locale

- [x] Toutes les jauges modifiées par les sujets sont déclarées en *Jauges activables*
- [x] Aucune jauge hors-scope touchée *(mirror, surveillance, countdowns explicitement out)*
- [x] Toutes les jauges existent dans `variables-register.md`
- [x] Toutes les factions citées sont parmi les 8 valides (`presse`, `memorize`, `stratom`)
- [x] `pnj-behavior:emma` existe ; `pnj-behavior:camille` à spec (`event_camille_cliffhanger` référencé en risque)
- [x] Aucun sujet sans effet
- [x] Tables de réponses couvrent les paliers disponibles au moment du dîner *(majoritairement Neutre + variantes Favorable+ marquées explicitement)*
- [x] Verrous canon respectés *(pas de fusion-confusion Emma à ce stade, paliers loin de Confident)*
