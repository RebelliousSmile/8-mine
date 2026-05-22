# Registre des variables de jeu — 8-MINE

Source unique de vérité pour les variables de jeu, leurs propriétaires, plages et signaux.

---

## Variables canon (GameStateManager)

| Variable | Plage | Init PRO-01 | Signal émis | Description |
|----------|-------|-------------|-------------|-------------|
| `mental_stability` | [0–6] | 3 | `mental_stability_changed(ancien, nouveau)` | État narratif. Colorie les dialogues, débloque des options, détermine les fins. |
| `personal_danger` | [0–∞] | 0 | `personal_danger_changed(ancien, nouveau)` | Incidents où Margot a été repérée. Incrémenté par SurveillanceManager._declencher_alerte(). |
| `evidence_collected` | [0–∞] | 0 | `evidence_collected_changed(ancien, nouveau)` | Valeur cumulée des preuves. Détermine les fins (FIN-B, FIN-C…). |

---

## Variables mécaniques (Managers dédiés)

| Variable | Manager | Plage | Seuils | Signal game over |
|----------|---------|-------|--------|-----------------|
| Surveillance | `SurveillanceManager._level` | [0–100] | 25, 50, 75, 90 | `surveillance_max_atteint` (à 100) |
| Mirror (dette auth.) | `MirrorStatusManager._status` | [0–100] | 30, 60, 90 | `breakdown_imminent` (à 100) |

**Seuils Surveillance (monotones, une seule émission par partie) :**
- 25 → HUD visible
- 50 → alerte
- 75 → cinematic + auto-tick equipe_nettoyage
- 90 → auto-tick equipe_nettoyage
- 100 → `GameOverHandler` (type "surveillance")

**Seuils Mirror (monotones) :**
- 30 → flashback de l'ex
- 60 → hésitation dialogues
- 90 → option verrouillée
- 100 → `GameOverHandler` (type "miroir")

---

## Countdowns narratifs (CountdownManager)

| ID | Max | Déclencheur initial | Condition d'avancement |
|----|-----|---------------------|------------------------|
| `equipe_nettoyage` | 14 | Révélé dans PRO-01 (Emma : "deux semaines") | Seuil surveillance 75+90, exposition zone caméra |
| `audit_marine` | 15 | Non déclenché dans le code existant | Dialogue Marine (Kaizen) |

**Format de tick :** CountdownManager.tick(id, 1) — chaque tick = 1 unité narrative.

---

## Réputation par faction (ReputationManager)

**8 factions. Valeurs de départ :**

| Faction | Label | Init |
|---------|-------|------|
| `stratom` | Stratom Corp | 0 |
| `marine` | Marine Nationale | 0 |
| `presse` | Presse indépendante | +10 |
| `police` | Police judiciaire | 0 |
| `activistes` | Cellule activiste | +5 |
| `memorize` | Memorize Corp | 0 |
| `nexus` | Nexus Biotech | 0 |
| `kaizen` | Kaizen Corp | 0 |

**Paliers (bornes inférieures) :**
`ennemi_jure` (-100) / `hostile` (-85) / `mefiant` (-50) / `indifferent` (-20) / `favorable` (+5) / `allie` (+25) / `champion` (+60)

---

## Relations PNJ (RelationManager)

17 PNJs, valeur [-100, +100], 9 paliers.

**8 résidents principaux (IDs Dialogic + CharacterRegistry) :**
emma, frank, sofia, leo, camille, alex, marine, thomas

**Paliers Relations :** ennemis_jurés / hostiles / méfiants / neutres / favorables / alliés / proches / confidents / fusionnels

---

## Flags narratifs (GameStateManager._flags)

Convention de nommage : `<node_id>.<cle_descriptive>`

**Flags existants dans le code :**

| Flag | Posé où | Valeur | Usage |
|------|---------|--------|-------|
| `flag_emma_a_reveele` | `pro_arrivee.dtl` ligne 135 | true | Condition d'accès PRO-02 |

**Flags spécifiés dans nodes/02.md (à implémenter) :**

| Flag | Posé quand | Conséquences |
|------|------------|--------------|
| `flag_micros_poses` | Choix [A] PRO-02 | Ferme FIN-A/F |
| `flag_refus_micros` | Choix [B] PRO-02 | Ouvre FIN-A/F |
| `flag_confrontation_emma_precoce` | Choix [C] PRO-02 | — |
| `flag_strategie_miroir` | Choix [D] PRO-02 | Débloque options dialogue miroir |

---

## Flags PNJ-driven *(introduits par pnjs-behavior/*.md — catalogue 8/8)*

> Catalogue exhaustif des flags posés et lus par les événements de seuil PNJ. Cf. `pnjs-behavior/_index.md § Variables Dialogic introduites` pour la vue synoptique.

### Emma *(`pnjs-behavior/emma.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_a2_romance_emma_demarre` | event_emma_favorable | scenes A2-A3 |
| `flag_emma_a_evoque_passe` | event_emma_favorable | sujets emma intimes |
| `flag_emma_couverture_active` | event_emma_allie *(branche accepter)* | countdown:equipe_nettoyage ralenti |
| `flag_pacte_emma` | event_emma_confident *(branche désamorçage)* | event_emma_intercept_leo + scenes A3/A4 |
| `flag_emma_distance` | event_emma_confident *(branche déni)* | scenes A3/A4 codas |
| `flag_emma_blessee` | event_emma_confident *(branche silence)* | scenes A3/A4 codas |
| `flag_julien_reference_partagee` | event_emma_confident | precondition event_emma_julien_intervention |
| `flag_emma_boussole` | event_emma_confident | cap triggers internes Margot A3/A4 |
| `flag_emma_a_vu_sans_dire` | event_emma_julien_intervention *(branche silence)* | coda A4 |

### Léo *(`pnjs-behavior/leo.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_acces_flux_leo` | event_leo_acces_flux | scenes Memorize, canal 2 dette Marine |
| `flag_leo_couche_1_percee` | event_leo_couche_1_aperçue | verrou d'entrée arc Léo |
| `flag_leo_couche_2_percee` | event_leo_couche_2_percee | verrou d'entrée arc Léo |
| `flag_leo_coloration_A` | event_leo_aveu_mutuel *(couche_1 seule)* | events Léo aval |
| `flag_leo_coloration_B` | event_leo_aveu_mutuel *(couche_2 seule)* | events Léo aval |
| `flag_leo_coloration_C` | event_leo_aveu_mutuel *(les deux)* | events Léo aval, coda FIN-E |
| `flag_leo_pacte_protection_scelle` | event_leo_pivot_choix coloration A | coda FIN-E Léo |
| `flag_leo_intimite_solidaire` | event_leo_pivot_choix coloration A intime | coda FIN-E Léo |
| `flag_leo_illusion_maintenue` | event_leo_pivot_choix coloration B [A] | coda FIN-E Léo |
| `flag_leo_illusion_brisee` | event_leo_pivot_choix coloration B [B] | coda FIN-E Léo |
| `flag_leo_intimite_floue` | event_leo_pivot_choix coloration B [C] | coda FIN-E Léo |
| `flag_leo_couple_conspirateurs_scelle` | event_leo_pivot_choix coloration C [A] | coda FIN-E Léo principale |
| `flag_leo_denonce_a_emma` | event_leo_pivot_choix coloration C [B] | A3+, coda |
| `flag_leo_retrait_lucide_final` | event_leo_pivot_choix coloration C [C] | coda A4 |

### Marine *(`pnjs-behavior/marine.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_marine_veut_couverture` | diner_arrivee `[B]` | event_marine_favorable precondition |
| `flag_marine_propose_couverture` | event_marine_favorable | sujet accepter_couverture |
| `flag_marine_couverture_donnee` | sujet accepter_couverture_marine | A2-A3 |
| `flag_marine_dette_connue` | event_marine_dette_revelee | sujets dette aval |
| `flag_marine_alliee` | event_marine_allie | scenes A2-A3, gating appart |
| `flag_marine_thomas_rupture_visible` | event_marine_rupture_visible_amorce | **precondition canon FIN-E Thomas** |
| `flag_marine_masque_baisse` | event_marine_proche | sujet parler_du_faux |
| `flag_marine_carriere_finie` | event_marine_confident | coda FIN-E Marine |
| `flag_cascade_marine` | exposition publique *(anti-pattern)* | game over collateral |
| `flag_immeuble_effondre` | flag_cascade_marine = true | coda A4 |

### Thomas *(`pnjs-behavior/thomas.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_thomas_reconnait_margot` | event_thomas_favorable | sujet parler_avec_thomas |
| `flag_thomas_complice_silencieux` | event_thomas_complice_silencieux *(cap 2)* | scenes A2-A3 |
| `flag_thomas_partage_marine` | event_thomas_proche | sujet parler_de_marine_avec_thomas |
| `flag_thomas_a_choisi` | event_thomas_confident | coda FIN-E Thomas |
| `flag_marine_sauvee_par_thomas` | event_thomas_confident consommé | coda A4 |
| `thomas_complicites_offertes` *(compteur)* | event_thomas_complice_silencieux | cap 2 |
| `thomas_revelations_par_fatigue_compteur` *(compteur)* | event_thomas_revele_par_fatigue | cap 2 |

### Sofia *(`pnjs-behavior/sofia.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_sofia_alliee` | event_sofia_alignement_test `[A]` | scenes A2-A3, FIN-E precondition |
| `flag_sofia_suspecte_methodes` | event_sofia_alignement_test `[C]` | ferme alliance Sofia |
| `flag_sofia_alliance_op_active` | event_sofia_allie | A3, sujet blocage_sofia |
| `flag_sofia_blocage_utilise` | sujet demander_blocage_sofia *(usage unique)* | A3-A4 |
| `flag_sofia_vulnerabilite_partagee` | event_sofia_proche | sujets intimes ultérieurs |
| `flag_sofia_dossier_transmis` | event_sofia_confident | coda FIN-E Sofia |
| `flag_sofia_carriere_finie` | event_sofia_confident | coda FIN-E Sofia |
| `flag_sofia_blessee_intime` | event_sofia_blessee_intime *(automatique post-trahison)* | couple brisé, gating appart |
| `flag_couple_sofia_alex_brise` | event_sofia_blessee_intime | gating appart, codas |
| `flag_margot_assume_trahison` | event_sofia_blessee_intime `[A]` | coda A4 |
| `flag_margot_nie_trahison` | event_sofia_blessee_intime `[B]` | coda A4 |

### Alex *(`pnjs-behavior/alex.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_alex_propose_canal` | event_alex_favorable | sujet accepter_acces_alex |
| `flag_alex_allie_op` | event_alex_allie | scenes A4 codas |
| `flag_alex_double_agent` | event_alex_revelation_taupe | precondition event_alex_franchi_optin |
| `flag_alex_expose` | event_alex_revelation_taupe `[A]` | A3+ |
| `flag_levier_alex` | event_alex_revelation_taupe `[B]` | option chantage A3 |
| `flag_alex_verrou_honore` | event_alex_confident | coda A4 alliance op |
| `flag_alex_franchi` | event_alex_franchi_optin | event_sofia_blessee_intime + gating appart |
| `flag_alex_bascule_seul` | event_alex_franchi_optin | coda A4 |

### Camille *(`pnjs-behavior/camille.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_camille_profil_trauma` | diner_arrivee `[A]` | event_camille_obsession precondition |
| `flag_camille_a_remarque_margot` | sujet demander_role_camille | observer_silence variante |
| `flag_camille_a_pris_note` | evoquer_witness | A2 |
| `flag_event_camille_cliffhanger_consomme` | event_camille_cliffhanger | one-shot |
| `flag_camille_cliffhanger_pose` | event_camille_cliffhanger | scenes A2+ |
| `flag_camille_attend_meilleure_occasion` | outro diner_arrivee branche `[B]` | scenes A2+ |
| `flag_camille_a_propose_echange` | event_camille_favorable | sujet parler_avec_camille_profilage |
| `flag_camille_complicite_active` | event_camille_allie *(branche accepter)* | mirror cumul |
| `flag_camille_a_teste_complicite` | event_camille_allie | scenes A2 |
| `flag_camille_demasquee` | event_camille_demasquee_test *(réussite)* | A3 |
| `flag_camille_fascination` | event_camille_demasquee_test ou _dark_proposition | precondition event_camille_obsession |
| `flag_camille_proposition_dark` | event_camille_dark_proposition | coda FIN-E Camille |
| `flag_camille_proposition_refusee` | event_camille_dark_proposition *(branche refuser)* | scenes A2-A3 |
| `flag_camille_obsession_active` | event_camille_obsession | scenes A3+ |

### Frank *(`pnjs-behavior/frank.md`)*

| Flag | Posé par | Lu par |
|------|----------|--------|
| `flag_frank_tests_reussis` *(compteur)* | event_frank_test_integrite | cap 3, precondition event_frank_verdict_a3 |
| `flag_frank_prenom_acquis` | event_frank_favorable | outro coda finale |
| `flag_rencontre_nocturne_frank` | event_frank_rencontre_nocturne | precondition FIN-E Frank |
| `flag_frank_allie` | event_frank_verdict_a3 *(branche Allié)* | scenes A4 codas FIN-E Frank |
| `flag_frank_neutre` | event_frank_verdict_a3 *(branche Neutre)* | coda A4 |
| `flag_frank_hostile` | event_frank_verdict_a3 *(branche Hostile)* | escalade Stratom |
| `flag_frank_a_observe` | sujet demander_role_frank | observer_silence variante |
| `flag_frank_a_vu_camille_basculer` | conscience post-event_camille_obsession | scenes Frank ultérieures |
| `flag_frank_carriere_finie` | event_frank_confident | coda FIN-E Frank |

### Variables scene-driven *(introduites par scenes/*)* 

| Var | Type | Default | Scène propriétaire | Description |
|-----|------|---------|---------------------|-------------|
| `diner_sujets_consommes` | int | 0 | `diner_arrivee` | Cap = 2. Init `_ready()`. |
| `flag_diner_presentation_choisie` | bool | false | `diner_arrivee` | Pose à la première présentation |
| `flag_diner_presentation_A/B/C/D` | bool | false | `diner_arrivee` | Branche présentation choisie |
| `flag_diner_mensonge_passe` | bool | false | `diner_arrivee` `[C]` | Mensonge mediacorp passé |
| `flag_menteuse_demasquee` | bool | false | `diner_arrivee` `[C]` échec | PD+1, gestion A2 |
| `flag_emma_propose_aparte` | bool | false | `demander_role_emma` Favorable+ | Hook après dîner |
| `flag_sofia_signale_protection` | bool | false | evoquer_witness | scenes A2 |
| `flag_diner_arrivee_consomme` | bool | false | outro `diner_arrivee` | Sortie scène |
| `flag_diner_observation_<camille_scan/frank_silence/marine_crispation>` | bool | false | observer_silence | A1-06 sujets ciblés |

### Lieux introduits *(à enregistrer dans LocationManager)*

| Lieu | Source | Background |
|------|--------|------------|
| `zone_commune_soir` | `diner_arrivee` *(existant)* | `bg_zone_commune_soir.jpg` |
| `cellule_margot_nuit` | `cellule_nuit` | `bg_cellule_margot_nuit.jpg` |
| `coursive_residents_nuit` | scene à spec | à créer |
| `appart_emma_leo` | scene à spec | à créer |
| `appart_marine_thomas` | scene à spec | à créer |
| `appart_sofia_alex` | scene à spec | à créer |
| `appart_camille_frank` | scene à spec | à créer |
| `atelier_leo` | scene à spec | à créer |
| `salon_camille` | scene à spec | à créer |
| `poste_technique_alex_sofia` | scene à spec | à créer |
| `poste_memorize_partage` | scene à spec | à créer |
| `confrontation_camille` | scene A3 à spec | à créer |
| `verdict_frank` | scene A3 à spec | à créer |

---

## Variables Dialogic.VAR (synchronisées avec GameStateManager)

Toute valeur posée via `set_flag()` est automatiquement pushée dans `Dialogic.VAR` (clé "." → "_").

**Variables de prénom (ask_name) :**

| Var | Default | CharacterRegistry npc_id |
|-----|---------|--------------------------|
| `emma_prenom` | "Emma" | `emma` |
| `frank_prenom` | "Frank" | `frank` |
| `sofia_prenom` | "Sofia" | `sofia` |
| `ex_prenom` | (ExProfileManager) | — |

**Variables de scènes (compteurs locaux) :**

| Var | Type | Default | Scène propriétaire | Description |
|-----|------|---------|---------------------|-------------|
| `diner_sujets_consommes` | int | 0 | `diner_arrivee` | Compteur de sujets joués au dîner d'arrivée (cap = 2). Initialisé au `_ready()` de la scène. |
