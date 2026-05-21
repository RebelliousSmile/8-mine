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
emma, frank, sofia, leo, camille, alex, victor, aiko

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

## Variables Dialogic.VAR (synchronisées avec GameStateManager)

Toute valeur posée via `set_flag()` est automatiquement pushée dans `Dialogic.VAR` (clé "." → "_").

**Variables de prénom (ask_name) :**

| Var | Default | CharacterRegistry npc_id |
|-----|---------|--------------------------|
| `emma_prenom` | "Emma" | `emma` |
| `frank_prenom` | "Frank" | `frank` |
| `sofia_prenom` | "Sofia" | `sofia` |
| `ex_prenom` | (ExProfileManager) | — |
