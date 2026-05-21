# Deal-breakers — Log de résolution

Contradictions trouvées entre docs externes et code réel.
Session d'audit : 2026-05-21.

---

## ✅ DB-01 — `etat-prod.md` entièrement périmé

**Constat** : Tous les items marqués ❌ sont en réalité implémentés.
- "5 autoloads ❌" → 14 autoloads dans `project.godot`
- "6 scripts point-and-click ❌" → `NavigableRoom.gd`, `Hotspot.gd`, `CameraZone.gd`, `Margot.gd`, `NPC.gd`, `Location.gd` tous présents
- "2 composants Dialogic ❌" → `NameInputDialog.tscn/.gd` + `addons/dialogic_additions/AskName/` implémentés
- "PRO-01 ⏸" → PRO-01 complètement jouable (playtest 2025-11-21 validé)

**Résolution** : `etat-prod.md` reflète un snapshot très ancien (avant Prompt 4a/4b).
**Action** : Ne pas utiliser `etat-prod.md` pour connaître l'état réel — utiliser `code-state.md` (ce dossier).

---

## ✅ DB-02 — Nombre de factions incorrect dans CLAUDE.md

**Constat** : CLAUDE.md ligne autoload 11 disait "5 factions" ; le code `ReputationManager.gd::FACTION_DEFINITIONS` en a **8**.
```
stratom, marine, presse, police, activistes,   ← Prompt 4a
memorize, nexus, kaizen                         ← 8-MINE coliving
```

**Résolution** : CLAUDE.md corrigé → "8 factions : stratom, marine, presse, police, activistes, memorize, nexus, kaizen"

---

## ✅ DB-03 — DialogicBridge : 4 dispatchers manquants

**Constat** : DialogicBridge n'avait que `relation:`, `flag:`, `decision:`, `lieu:`.
Impossible de modifier SurveillanceManager, MirrorStatusManager, ReputationManager ou CountdownManager depuis une timeline .dtl sans passer par des flags (hacky).

**Impact** : Tous les Actes I–IV sont bloqués sur ces effets narratifs courants :
- caméra repère Margot → `surveillance:+10`
- Margot ment à Emma → `miroir:+5`
- dossier fuite vers presse → `reputation:presse:+20`
- chronologie Stratom avance → `countdown:equipe_nettoyage:1`

**Résolution** : Ajout de `_traiter_surveillance()`, `_traiter_miroir()`, `_traiter_reputation()`, `_traiter_countdown()` dans `DialogicBridge.gd`.
Syntaxe complète documentée dans `api-cheatsheet.md`.

---

## ✅ DB-04 — GameStateManager : lookups répétés get_node_or_null

**Constat** : `_synchroniser_dialogic()` et `get_mirror_status()` appelaient `get_node_or_null()` à chaque invocation (donc à chaque `set_flag()` et chaque affichage qui demande le statut miroir).

**Résolution** : Ajout de `_dialogic: Node` et `_mirror: Node` cachés dans `_ready()`. Pattern identique à `SurveillanceManager`.

---

## ⚠️ DB-05 — Convention "3 fichiers par NODE" ≠ réalité

**Constat** : `architecture.md` (externe) dit "3 fichiers par scène (.dtl, .tscn, _init.gd)".
Réalité pour PRO-01 : **4 fichiers**.
- `dialogic/timelines/pro_arrivee.dtl` — timeline Dialogic
- `scenes/prologue/pro_arrivee.tscn` — scène Godot (charge la timeline)
- `scripts/prologue/pro_arrivee.gd` — logique de la scène (signal handling)
- `scripts/prologue/pro_arrivee_init.gd` — init des variables au démarrage du NODE

**Convention réelle** : `_init.gd` = fichier séparé pour l'état initial (isolé pour testabilité GUT).
`architecture.md` doit être mis à jour par le game designer.

**Action** : Ne pas créer de NODE avec 3 fichiers — toujours 4. Voir `code-state.md` pour la structure cible.

---

## ⚠️ DB-06 — PRO-02 : spécifié dans nodes/02.md mais non implémenté

**Constat** : `nodes/02.md` décrit en détail PRO-02 (La Cellule), avec 4 choix, 3 backgrounds, flags etc.
Aucun fichier code correspondant :
- ❌ `dialogic/timelines/pro_cellule.dtl`
- ❌ `scenes/prologue/pro_cellule.tscn`
- ❌ `scripts/prologue/pro_cellule.gd`
- ❌ `scripts/prologue/pro_cellule_init.gd`

**Contexte** : PRO-01 se termine sur `pro_zone_commune.tscn` (scène point-and-click existante), puis un `[signal arg="lieu:pro_cellule"]` devrait charger PRO-02. Ce signal échouera silencieusement (LocationManager warn).

**Action** : PRO-02 est le prochain NODE à implémenter. Utiliser `nodes/02.md` comme spec.

---

## ℹ️ DB-07 — Deux systèmes "stabilité mentale" distincts : pas un bug

**Constat** : `GameStateManager.mental_stability` [0–6] et `MirrorStatusManager._status` [0–100] coexistent.

**Clarification** :
- `mental_stability` = narratif discret. Score de "santé narrative" qui colorie les dialogues et débloque des options. Initialisé à 3 dans `pro_arrivee_init.gd`.
- `MirrorStatusManager` = pression de dette d'authenticité (game over à 100). Mécanique de jeu indépendante.
- `GameStateManager.get_mirror_status()` = proxy qui lit MirrorStatusManager. Utilisé par les consommateurs qui pensent en termes de GameState.

**Action** : Pas de fix nécessaire. À documenter clairement dans les timelines .dtl (ne pas confondre `miroir:` et `mental_stability`).
