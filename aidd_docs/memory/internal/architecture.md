# 8-MINE — Architecture & Conventions
> Définitions stables du projet. Ne change qu'en cas de décision de design structurelle.
> Lecteurs : Claude Code (briefing technique) + game designer (référence).
> **Ce fichier ne contient pas d'état de production.** → `etat-prod.md` pour les ❌/⏸/✅.

---

## Navigation

| Document | Contenu | Quand l'ouvrir |
|----------|---------|----------------|
| `architecture.md` | Ce fichier — conventions · variables · pipeline · composants | Briefer Claude Code · décision de design structurelle |
| `etat-prod.md` | État courant — assets · scripts · tâches · log | Reprendre le projet · vérifier avancement |
| `histoire.md` | Arborescence narrative complète · fins · notes playtest | Écrire un `.dtl` · concevoir un choix · vérifier une condition |
| `bible-jeu-video.md` | Vision · cast · mécaniques · DA | Cohérence globale · nouveaux assets · casting |
| `pnjs-secondaires.md` | Secondaires · sources journalistiques | Écrire les PNJs périphériques |
| `session-[N]-checkpoint-[N].md` | Détail complet d'un playtest | Rejouer une scène · vérifier un dialogue précis |

---

## Terminologie canonique

| ❌ Ancien | ✅ Correct |
|-----------|-----------|
| Deep-Paris | Sous-Paris |
| Saint-Michel Haute | Tour Quadri-Corp (nom de la station) |
| `bg_*.png` (backgrounds) | `bg_*.jpg` (backgrounds) |
| `evidence_value` | `evidence_collected` |

---

## Architecture de jeu

**Paradigme : Point-and-click en perspective fixe**

Backgrounds 1920×1080 navigables, sprites en pied dans la scène,
Dialogic 2 déclenché par interaction hotspot/NPC.

---

## Format de livraison — par NODE

Chaque NODE produit **trois ou quatre fichiers** :

```
dialogic/timelines/[node_id].dtl        ← dialogues, choix, events custom
scenes/[acte]/[node_id].tscn            ← scène Godot (backgrounds, sprites, hotspots)
scripts/[acte]/[node_id].gd             ← logique scène (signal handling, démarrage Dialogic)
scripts/[acte]/[node_id]_init.gd        ← _ready : variables initiales (PRO-01 uniquement)
```

> `_init.gd` uniquement pour PRO-01 (seul node qui pose MS/PD/EV à zéro).
> Les autres nodes héritent de l'état courant de `GameStateManager`.
>
> Le `.gd` de logique (signal handling, hooks NavigableRoom) est présent sur tous les
> nodes point-and-click. Pour les nodes purement dialogiques, le `.tscn` peut être
> autonome (Dialogic lancé directement depuis `LocationManager`).

**Nœud racine PRO-01 :**
`scenes/prologue/pro_arrivee.tscn` orchestre les sous-scènes 1→4 en séquence.

---

## Format de scène — Structure obligatoire

```
1. En-tête (NODE ID, fichier .dtl, acte, [NAV] si navigable, variables)
2. Fichiers Godot liés (.tscn · .dtl · _init.gd si applicable)
3. Characters Dialogic utilisés dans cette scène
4. Assets — Backgrounds (prompt Flux.1 Dev = STYLE_COMMUN + diff spécifique)
5. Assets — Sprites (prompt Flux.1 Dev)
6. [NAV] HOTSPOTS — liste avec id · label · condition · action
7. Par sous-scène :
   a. Narration d'entrée
   b. Éléments interactifs (textes d'examen au clic)
   c. Narration séquencée (dialogues, événements, choix)
8. Note d'enchaînement
```

### Convention HOTSPOTS (scènes navigables)

```
[NAV] — ce node a une scène .tscn avec hotspots actifs

HOTSPOTS
  id: [hotspot_id]
  label: texte visible au survol
  condition: toujours | flag:[nom] | variable:[nom op valeur]
  action: examine | dialogic:[node_id] | nav:[scene_path]
  examine_text: (si action=examine) texte retourné au clic
```

> Les hotspots sans conséquence narrative (examine-text pur) sont listés dans le fichier de scène.
> Les hotspots avec effet sur flags/variables sont aussi signalés dans `histoire.md` (section `🗺`).

---

## STYLE_COMMUN_BACKGROUNDS — Constante Flux.1 Dev

> Copier tel quel **en tête de chaque prompt de background**, avant le diff spécifique au lieu.
> Ne modifier qu'en cas de changement global de DA — propager dans tous les fichiers de scène.

```
neo-paris 2084 cyberpunk, fixed perspective interior/exterior shot,
photorealistic concept art, cinematic lighting, dark base tones,
haussmannian paris architecture under smart glass and corporate overlays,
muted palette with selective neon accents
```

**Usage dans les fichiers de scène :**
```
[STYLE_COMMUN] + [diff spécifique au lieu]
```
Exemple diff : `interior of silent magnetic levitation tram, wide fixed perspective shot from passenger seat, ...`

---

## Factions — `FACTION_DEFINITIONS`

### Corporations (agents internes à l'immeuble)

| ID | Nom | Couleur | Agents |
|----|-----|---------|--------|
| `memorize` | MEMORIZE | `#4a90d9` bleu | Emma · Léo |
| `kaizen` | KAIZEN | `#d9a44a` orange | Marine · Thomas |
| `nexus` | NEXUS | `#4ad97a` vert | Sofia · Alex |
| `stratom` | STRATOM | `#d94a4a` rouge | Frank · Camille |

### Factions hors-immeuble (pression narrative externe)

| ID | Nom | Rôle |
|----|-----|------|
| `marine_nationale` | Marine Nationale | Countdown Audit Marine |
| `presse` | Presse indépendante | Alliés potentiels de Margot |
| `police` | Police corporatiste | Escalade PD |
| `activistes` | Collectifs activistes | Sources journalistiques |

---

## Architecture Dialogic — Characters

### Characters sans sprite (narration)

| ID | Affichage | Style |
|----|-----------|-------|
| `narrator` | *(aucun nom affiché)* | italique · gris clair · sans fond de bulle |
| `voix_synthetique` | `VOIX SYNTHÉTIQUE` | italique · bleu froid `#4a90d9` · monospace |

### Characters PNJ principaux

| ID | Affichage par défaut | Variable prénom | Portraits disponibles |
|----|---------------------|-----------------|----------------------|
| `emma` | `Emma` | `emma_prenom` | neutre · légère tension · tension · sourire · crise · murmure |
| `frank` | `Frank` | `frank_prenom` | neutre · légère tension · tension · sourire · crise |
| `sofia` | `Sofia` | `sofia_prenom` | neutre · légère tension · tension · sourire · crise |
| `marine` | `Marine` | `marine_prenom` | neutre · légère tension · tension · sourire · crise |
| `thomas` | `Thomas` | `thomas_prenom` | neutre · légère tension · tension · sourire · crise |
| `leo` | `Léo` | `leo_prenom` | neutre · légère tension · tension · sourire · crise |
| `camille` | `Camille` | `camille_prenom` | neutre · légère tension · tension · sourire · crise |
| `alex` | `Alex` | `alex_prenom` | neutre · légère tension · tension · sourire · crise |

> Swap de portrait : syntaxe native Dialogic 2 `[portrait char=emma portrait=tension]`
> Aucun custom event pour les swaps de sprites.

### Character joueur

| ID | Affichage | Style |
|----|-----------|-------|
| `margot` | `MARGOT` | normal · ocre · sans sprite |

---

## Composants Godot custom

### `NameInputDialog.tscn`

Popup déclenchée par le custom event Dialogic `[ask_name]`.

```gdscript
# Syntaxe custom event dans le .dtl :
[ask_name var="emma_prenom" default="Emma"]

# La popup expose :
#   - LineEdit (saisie libre)
#   - Bouton "Valider"
#   - Bouton "Garder Emma" (ou le default de la variable)
# Au validate → GameStateManager.[var] = saisie
#             → Dialogic.set_variable([var], saisie)
#             → signal npc_renamed([var], saisie)
```

---

## Prénoms personnalisables — Règle générale

Les 8 PNJs principaux ont un prénom personnalisable par le joueur.
Les PNJs secondaires ont des prénoms fixes non modifiables.

**Règle d'implémentation :**
- Le micro-choix se déclenche à la **première apparition nommée** du PNJ
- Une fois défini, `[pnj]_prenom` remplace le prénom canonique partout
- Le nom de famille reste fixe (interfaces corporatistes uniquement)

**Exception PRO-01 :** Emma introduit Frank et Sofia dans la même scène.
Les deux micro-choix se déclenchent en séquence, séparés par la narration.

**PNJs secondaires (prénoms fixes) :**
Sources journalistiques, supérieurs hiérarchiques, voix synthétiques.

---

## Variables de personnalisation — `GameStateManager.gd`

```gdscript
# Ex de Margot — déclenché en Acte I (premier dialogue où Margot mentionne l'ex)
# NE PAS déclencher en Prologue
var ex_prenom    : String = ""     # "Julien" | "Julie" | texte libre
var ex_genre     : String = ""     # "M" | "F" — 2 boutons, pas de texte libre
var ex_mentionne : bool   = false

# PNJs principaux — prénoms personnalisables
var emma_prenom    : String = "Emma"    # première apparition : PRO-01 Scène 2
var frank_prenom   : String = "Frank"   # première apparition : PRO-01 Scène 4
var sofia_prenom   : String = "Sofia"   # première apparition : PRO-01 Scène 4
var marine_prenom  : String = "Marine"  # première apparition : A1-03 (dîner)
var thomas_prenom  : String = "Thomas"  # première apparition : A1-03 (dîner)
var leo_prenom     : String = "Léo"     # première apparition : A1-03 (dîner)
var camille_prenom : String = "Camille" # première apparition : A1-03 (dîner)
var alex_prenom    : String = "Alex"    # première apparition : A1-03 (dîner)

# Flags de déclenchement (micro-choix déjà présenté)
var emma_prenom_defini    : bool = false
var frank_prenom_defini   : bool = false
var sofia_prenom_defini   : bool = false
var marine_prenom_defini  : bool = false
var thomas_prenom_defini  : bool = false
var leo_prenom_defini     : bool = false
var camille_prenom_defini : bool = false
var alex_prenom_defini    : bool = false
var ex_mentionne          : bool = false
```

---

## Variables de progression — `GameStateManager.gd`

```gdscript
# Valeurs par défaut dans le script : 0 / 0 / 0
# Valeurs initiales de partie posées par pro_arrivee_init.gd au _ready
var mental_stability   : int = 0   # → posé à 3 par pro_arrivee_init.gd
var personal_danger    : int = 0
var evidence_collected : int = 0
```

> Abréviations dans les docs narratifs : MS = mental_stability · PD = personal_danger · EV = evidence_collected

---

## Variable de dette — `MirrorStatusManager.gd`

```gdscript
var mirror_status : int = 0   # 0 → 100 · dette d'authenticité accumulée
```

| | `mental_stability` | `mirror_status` |
|---|---|---|
| Échelle | 0 – 6 | 0 – 100 |
| Rôle | État narratif courant (dialogues, fins) | Paliers mécaniques (game-over, triggers) |
| Gestionnaire | `GameStateManager` | `MirrorStatusManager` |
| Abréviation docs | MS | — |

**Relation entre les deux :** quand `mirror_status` franchit un palier défini dans `MirrorStatusManager`, cela peut déclencher `mental_stability −1` dans `GameStateManager`. Le couplage est unidirectionnel et explicite — pas de getter dérivé.

### Triggers internes (`mental_stability −1`)

```gdscript
var trigger_surveillance   : bool = false
var trigger_manipulation   : bool = false
var trigger_emma           : bool = false
var trigger_rationalisation: bool = false
var trigger_voyeurisme     : bool = false
```

---

## Flags narratifs — `GameStateManager.gd`

```gdscript
var flag_motivation : String = "relations"

var flag_micros_poses                : bool = false
var flag_emma_a_reveele              : bool = false
var flag_strategie_miroir            : bool = false

var flag_emma_guide                  : bool = false
var flag_acces_flux_leo              : bool = false
var flag_leo_mefiant                 : bool = false
var flag_angle_mort_leo              : bool = false
var flag_sofia_alliee                : bool = false
var flag_sofia_suspecte_methodes     : bool = false
var flag_marine_alliee               : bool = false
var flag_marine_veut_couverture      : bool = true
var flag_marine_ennemie              : bool = false
var flag_frank_allie                 : bool = false
var flag_frank_neutre                : bool = false
var flag_confrontation_emma_precoce  : bool = false

var flag_camille_profil_partiel      : bool = false
var flag_camille_profil_complet      : bool = false
var flag_camille_profil_trauma       : bool = false
var flag_camille_demasquee           : bool = false
var flag_camille_demasquee_precoce   : bool = false
var flag_camille_fascination         : bool = false

var flag_alex_double_agent           : bool = false
var flag_alex_expose                 : bool = false
var flag_levier_alex                 : bool = false

var flag_emma_exposee                : bool = false
var flag_emma_sacrifiee              : bool = false
var flag_emma_sauvee                 : bool = false
var flag_emma_risque                 : bool = false

var flag_witness_silencieux          : bool = false
var flag_witness_vendu               : bool = false

var flag_rencontre_nocturne_frank    : bool = false
var flag_rencontre_nocturne_thomas   : bool = false
var flag_rencontre_nocturne_leo      : bool = false

var flag_romance_possible            : bool = false
var flag_romance_actif               : bool = false
var pnj_romance                      : String = ""

var flag_mains_propres               : bool = false
var flag_deal_corpo                  : bool = false
var flag_alex_double_agent_connu     : bool = false
```

---

## Countdowns — `CountdownManager.gd`

```gdscript
var countdown_equipe_nettoyage : int = 14
var countdown_audit_marine     : int = 15
```

---

## Relations PNJ — `RelationManager.gd`

```gdscript
var relation_emma_castellane : int = 5
var relation_frank_dosiere   : int = 5
var relation_sofia_kessler   : int = 5
var relation_marine_dubois   : int = 0
var relation_thomas_renard   : int = 0
var relation_leo_mars        : int = 0
var relation_camille_armand  : int = 0
var relation_alex_norvege    : int = -5
```

---

## NPC_DEFINITIONS — plan d'extension

`set_npc_display_name(id, name)` requiert que le PNJ soit enregistré dans `NPC_DEFINITIONS`.

| Phase | Entrées ajoutées | Déclencheur |
|-------|-----------------|-------------|
| PRO-01 (maintenant) | `emma` (memorize) · `frank` (stratom) · `sofia` (nexus) | Micro-choix prénoms Prologue |
| A1-03 (avant le dîner) | `marine` · `thomas` · `leo` · `camille` · `alex` | Micro-choix prénoms dîner |

> Les 9 NPCs du Prompt 4a (sara · kaizen · lior · marl · tess · viktor · mira · aslan · nadia) coexistent dans `NPC_DEFINITIONS` sans interférence — factions et logique de relation séparées.
> Total cible : **17 entrées** (8 résidents 8-MINE + 9 Prompt 4a).

---

## Pipeline assets — Flux.1 Dev

### Backgrounds
- Format : **1920×1080 · jpg · perspective fixe**
- Éléments interactifs visibles et distincts dans l'image
- **Prompt = STYLE_COMMUN_BACKGROUNDS + diff spécifique** (voir section dédiée ci-dessus)

### Sprites personnages
- Format : **~400×900px · png · fond transparent**
- Pipeline : Flux.1 Dev → rembg → Godot
- Cohérence : **LoRA par personnage**

### Workflow LoRA (≈ 1 jour par personnage)

```
1. Générer 20-30 variantes (Flux sans LoRA)
2. Sélectionner 10-15 images cohérentes
3. Entraîner LoRA (~1h sur RTX 2080 Super)
4. Générer toutes les expressions avec LoRA
5. rembg → png fond transparent
```

**Stratégie early dev :** sprites sans LoRA pour premiers playtests,
LoRAs en parallèle. Ne pas bloquer l'écriture.

### Expressions par PNJ
5 minimum : **neutre · légère tension · tension · sourire · crise**
Emma : 6 expressions (+ **murmure** — spécifique PRO-02)

---

## Convention de nommage

```
scenes/[prologue|acte1-4]/[node_id].tscn
scenes/[prologue|acte1-4]/[node_id]_init.gd
dialogic/[node_id].dtl
assets/backgrounds/bg_[lieu]_[moment].jpg
assets/characters/[pnj]/char_[pnj]_[expression].png
autoloads/[NomManager].gd
scenes/base/[NomComposant].gd
```

---

## Fins

| Fin | Titre | Condition | Rareté |
|-----|-------|-----------|--------|
| FIN-A | La Reconstruction | EV 6 · MS 6 · 0 trigger · Emma ok | ~5% |
| FIN-B | L'Exposé | EV 6 · MS 3-5 · Emma ok · allié | ~25% |
| FIN-C | Le Pacte de Sang | EV 6 · Emma sacrifiée · MS 2-4 | ~10% |
| FIN-D | L'Alliance Corporate | EV 4-5 · deal corpo · ≥1 trigger | ~10% |
| FIN-E | La Romance (×5) | EV 3-5 · romance ≥+60 · MS ≥3 | ~15% |
| FIN-F | Les Mains Propres | EV 4-5 · MS ≥5 · 0 trigger | ~10% |
| FIN-G | Le Silence | EV <4 · Witness lâche | ~10% |
| FIN-H | La Capture | PD 6 · countdown 0 · Frank hostile | ~5% |
| FIN-I | Julien | MS 0 · 5/5 triggers | ~10% |