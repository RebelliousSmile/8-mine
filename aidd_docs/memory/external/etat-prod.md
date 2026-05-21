# 8-MINE — État de production
> Tableau de bord courant. S'actualise à chaque session.
> **Définitions structurelles** (variables, conventions, pipeline, composants) → `architecture.md`.

---

## Navigation

| Document | Contenu | Quand l'ouvrir |
|----------|---------|----------------|
| `architecture.md` | Conventions · variables · pipeline · composants | Briefer Claude Code · référence structurelle |
| `etat-prod.md` | Ce fichier — avancement · tâches · log | Reprendre le projet · vérifier l'état du jour |
| `histoire.md` | Arborescence narrative complète · fins · notes playtest | Écrire un `.dtl` · concevoir un choix |
| `bible-jeu-video.md` | Vision · cast · mécaniques · DA | Cohérence globale · nouveaux assets |
| `pnjs-secondaires.md` | Secondaires · sources journalistiques | Écrire les PNJs périphériques |
| `session-[N]-checkpoint-[N].md` | Détail complet d'un playtest | Rejouer une scène · vérifier un dialogue précis |

---

## Tâches prioritaires

| # | Priorité | Tâche |
|---|----------|-------|
| 1 | 🔴 | Implémenter scripts point-and-click (Claude Code) |
| 2 | 🔴 | Implémenter `NameInputDialog` + custom event `[ask_name]` |
| 3 | 🔴 | Écrire A1-03 (dîner — 5 micro-choix prénoms + ex_genre) |
| 4 | 🟠 | Écrire A1-01-ethique · A1-04 |
| 5 | 🟠 | Générer backgrounds Prologue (Flux.1 Dev) |
| 6 | 🟠 | Pipeline LoRA Emma (première à apparaître) |
| 7 | 🟡 | Sprites sans LoRA pour playtest rapide |

---

## État de production — Scènes

| NODE | Fichier `.dtl` | Écrit | Validé |
|------|---------------|-------|--------|
| CP-01 | `cp_motivation.dtl` | ❌ | ❌ |
| PRO-01 | `pro_arrivee.dtl` | ⏸ | Playtest ✅ |
| PRO-02 | `pro_cellule.dtl` | ⏸ | Playtest ✅ |
| A1-01-ethique | `a1_decision_ethique.dtl` | ❌ | Playtest ✅ |
| A1-01-micro | `a1_micro_pose.dtl` | ❌ | ❌ |
| A1-01-confrontation | `a1_confrontation_emma.dtl` | ❌ | ❌ |
| A1-01-stratege | `a1_stratege.dtl` | ❌ | ❌ |
| A1-03 | `a1_diner.dtl` | ❌ | Playtest ✅ |
| A1-04 | `a1_camille_question.dtl` | ⏸ | ❌ |
| A1-05 | `a1_nuit.dtl` | ❌ | ❌ |
| A1-06 | `a1_plan.dtl` | ❌ | ❌ |
| A2-01A | `a2_leo_alliance.dtl` | ❌ | ❌ |
| A2-01B | `a2_emma_alliance.dtl` | ❌ | ❌ |
| A2-01C | `a2_marine_dette.dtl` | ❌ | ❌ |
| A2-01D | `a2_sofia_alliance.dtl` | ❌ | ❌ |
| A2-02 | `a2_witness_pression.dtl` | ❌ | ❌ |
| A2-03 | `a2_premiere_preuve.dtl` | ❌ | ❌ |
| A2-04 (×5) | `a2_romance_[pnj].dtl` | ❌ | ❌ |
| A2-05 | `a2_confrontation_camille.dtl` | ❌ | ❌ |
| A2-06 | `a2_revelation_alex.dtl` | ❌ | ❌ |
| A3-01 | `a3_verdict_frank.dtl` | ❌ | ❌ |
| A3-02 | `a3_emma_pression.dtl` | ❌ | ❌ |
| A3-C | `a3_mains_propres.dtl` | ❌ | ❌ |
| A3-witness | `a3_witness_lache.dtl` | ❌ | ❌ |
| A4-01 | `a4_revelation_choix.dtl` | ❌ | ❌ |
| A4-02 | `a4_montage.dtl` | ❌ | ❌ |
| FIN-A à FIN-I | `fin_[a-i].dtl` | ❌ | ❌ |

---

## État de production — Assets

### Backgrounds

| Fichier | Scène | Généré |
|---------|-------|--------|
| `bg_tramway_jour.jpg` | PRO-01 | ❌ |
| `bg_hall_tour.jpg` | PRO-01 | ❌ |
| `bg_ascenseur.jpg` | PRO-01 | ❌ |
| `bg_couloir_residences.jpg` | PRO-02 | ❌ |
| `bg_zone_commune_soir.jpg` | PRO-01 · A1-03 | ❌ |
| `bg_cellule_margot_jour.jpg` | PRO-02 | ❌ |
| `bg_cellule_sdb.jpg` | PRO-02 | ❌ |
| `bg_cellule_margot_nuit.jpg` | A1-05 | ❌ |
| `bg_appart_emma_leo.jpg` | A1-01-confrontation | ❌ |

### Personnages — LoRA + sprites en pied

| PNJ | Faction | Première apparition | LoRA | Sprites | Intégré |
|-----|---------|-------------------|------|---------|---------|
| Emma Castellane | Memorize | PRO-01 hall | ❌ | ❌ | ❌ |
| Frank Dosière | Stratom | PRO-01 zone commune | ❌ | ❌ | ❌ |
| Sofia Kessler | Nexus | PRO-01 zone commune | ❌ | ❌ | ❌ |
| Marine Dubois | Kaizen | A1-03 dîner | ❌ | ❌ | ❌ |
| Thomas Renard | Kaizen | A1-03 dîner | ❌ | ❌ | ❌ |
| Léo Mars | Memorize | A1-03 dîner | ❌ | ❌ | ❌ |
| Camille Armand | Stratom | A1-03 dîner | ❌ | ❌ | ❌ |
| Alex Norvège | Nexus | A1-03 dîner | ❌ | ❌ | ❌ |

---

## État de production — Scripts Godot

### Autoloads

| Script | État |
|--------|------|
| `GameStateManager.gd` | ❌ |
| `MirrorStatusManager.gd` | ❌ |
| `RelationManager.gd` | ❌ |
| `SaveManager.gd` | ❌ |
| `CountdownManager.gd` | ❌ |

### Point-and-click

| Script | État |
|--------|------|
| `NavigableRoom.gd` | ❌ |
| `Margot.gd` | ❌ |
| `Hotspot.gd` | ❌ |
| `CameraZone.gd` | ❌ |
| `SurveillanceManager.gd` | ❌ |
| `NPC.gd` | ❌ |

### Dialogic custom

| Script / Scène | Rôle | État |
|----------------|------|------|
| `NameInputDialog.tscn` | Popup saisie prénom PNJ | ❌ |
| `AskNameEvent.gd` | Custom event `[ask_name]` pour Dialogic | ❌ |

---

## Log playtests

> Résumés uniquement. Détail complet → fichier `session-[N]-checkpoint-[N].md`.

### Playtest 01 — 2025-11-21 · 120 min
Scènes : PRO-01 · PRO-02 · A1-01-ethique · A1-03 · A1-04 ⏸
Choix clés : PRO-02 [B] micros refusés · A1-03 [D] transparence + contrat
État final : EV 0 · PD 0 · MS 3 · 0 trigger · 9/9 fins accessibles
Détail → `session-01-checkpoint-01.md`

### Playtest 00 — 2025-11-11 · ARCHIVÉ