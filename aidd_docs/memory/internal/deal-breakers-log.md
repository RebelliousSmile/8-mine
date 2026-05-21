# Deal-breakers — Log de résolution

Contradictions trouvées entre docs externes et code réel.
Session d'audit : 2026-05-21.

---

## ✅ DB-01 — `etat-prod.md` section scripts périmée

**Constat** : La section "Scripts Godot" listait tout à ❌, tâches 1 et 2 non barrées.
- Les 14 autoloads, 6 scripts point-and-click, NameInputDialog et ask_name = tous implémentés.
- Note : "PRO-01 ⏸" = en cours d'écriture .dtl (pas "non implémenté") — cohérent avec le playtest papier 2025-11-21.
- Note : "PRO-02 ⏸ Playtest ✅" = joué en session papier, mais .dtl absent du projet Godot.

**Résolution** : `etat-prod.md` mis à jour — scripts marqués ✅, tâches 1/2 cochées, tâche 3 (PRO-02) promue en priorité 🔴.

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

## ✅ DB-05 — Convention "3 fichiers par NODE" ≠ réalité

**Constat** : `architecture.md` disait "3 fichiers" et ne listait pas le `.gd` de logique de scène.
PRO-01 en a 4 : `.dtl` + `.tscn` + `.gd` (logique/signals) + `_init.gd` (variables initiales).

**Résolution** : `architecture.md` mis à jour → "3 ou 4 fichiers", avec le `.gd` dans la liste et clarification :
- `.gd` présent sur tous les nodes point-and-click (signal handling)
- `_init.gd` uniquement PRO-01 (seul node qui pose MS/PD/EV à zéro)
- Nodes purement dialogiques peuvent être `.tscn` autonome sans `.gd`

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

## ⚠️ DB-08 — PRO-01 .dtl utilise 3 dispatchers fictifs (découvert par dtl_linter)

**Constat** : `dialogic/timelines/pro_arrivee.dtl` contient :
- `[signal arg="bg:bg_xxx"]` × 4 (lignes 17, 33, 70, 109)
- `[signal arg="show_char:..."]` × 3 (lignes 54, 110, 111)
- `[signal arg="goto_scene:..."]` × 1 (ligne 136)

Aucun de ces 3 préfixes n'existe dans `DialogicBridge._on_signal_event()`. À l'exécution, ils déclenchent `push_warning("commande inconnue 'bg'")` et n'ont aucun effet.

**Impact** :
- Backgrounds non changés (visuels figés sur le bg initial)
- Sprites PNJ non affichés
- Transition de scène en fin de PRO-01 → `pro_zone_commune.tscn` non déclenchée

**Hypothèses** :
- Soit le `.dtl` a été écrit en anticipant des dispatchers à venir
- Soit les changements visuels passent par un autre canal (signal direct depuis le `.tscn`)

**Action** : à arbitrer par l'auteur. Soit (a) ajouter `bg`, `show_char`, `goto_scene` à DialogicBridge, soit (b) retirer ces lignes du .dtl et déclencher les visuels autrement.

**Découvert par** : `scripts/tools/dtl_linter.gd` (créé 2026-05-21 avec le pipeline `aiw/8mine/`).

---

## ℹ️ DB-07 — Deux systèmes "stabilité mentale" distincts : pas un bug

**Constat** : `GameStateManager.mental_stability` [0–6] et `MirrorStatusManager._status` [0–100] coexistent.

**Clarification** :
- `mental_stability` = narratif discret. Score de "santé narrative" qui colorie les dialogues et débloque des options. Initialisé à 3 dans `pro_arrivee_init.gd`.
- `MirrorStatusManager` = pression de dette d'authenticité (game over à 100). Mécanique de jeu indépendante.
- `GameStateManager.get_mirror_status()` = proxy qui lit MirrorStatusManager. Utilisé par les consommateurs qui pensent en termes de GameState.

**Action** : Pas de fix nécessaire. À documenter clairement dans les timelines .dtl (ne pas confondre `miroir:` et `mental_stability`).
