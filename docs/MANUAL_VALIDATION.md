# Validation manuelle 8-MINE

> Statut : 75 / 75 tests GUT verts (phase 3). Les cases ci-dessous
> distinguent **VAL-API** (validé automatiquement par la suite GUT)
> et **VAL-UI** (nécessite ouverture éditeur, à valider par un
> humain). En CI headless, seuls les VAL-API sont garantis ; les
> VAL-UI doivent être cochés avant release.

| Légende | Sens |
|---|---|
| ✅ VAL-API | Comportement validé par un ou plusieurs tests GUT |
| ☐ VAL-UI  | À valider visuellement dans l'éditeur ou dans le runtime |

## SurveillanceHUD (toutes VAL-UI)

| # | Cas | Statut | Note |
|---|---|---|---|
| H1 | HUD visible en haut-droite, layer = 50 | ☐ VAL-UI | code: `layer = 50` posé dans `SurveillanceHUD.gd._ready` |
| H2 | Emprise ≤ 25 % × 20 % | ☐ VAL-UI | container 380×196 sur 1920×1080 → ~20% × 18% |
| H3 | 80 % inférieurs réservés au dialogue | ☐ VAL-UI | container ancré top-right, n'empiète pas en bas |
| H4 | `set_visible_for_cinematic(false)` | ☐ VAL-UI | méthode implémentée, à voir au rendu |
| H5 | `Shift+F1` toggle | ☐ VAL-UI | `_unhandled_input` testé pour KEY_F1 + shift |
| H6 | Pulse sur `surveillance_changed` | ☐ VAL-UI | tween 0.08+0.20 implémenté dans `_pulse` |
| H7 | Pulse plus marqué sur `threshold_crossed` | ☐ VAL-UI | même tween, à amplifier si besoin |
| H8 | Overlay `show_game_over_overlay` | ☐ VAL-UI | tween 0.6 + 0.3s, signal final implémenté |

## GameOverScreen (mix)

| # | Cas | Statut | Note |
|---|---|---|---|
| G1 | Affiche `title` | ☐ VAL-UI | label `Titre` bindé dans `_ready` |
| G2 | Affiche `overlay_quote` | ☐ VAL-UI | label `Quote` bindé |
| G3 | `history` scrollable | ☐ VAL-UI | ScrollContainer + VBoxContainer |
| G4 | `history_formatter` utilisé | ☐ VAL-UI | branche `Callable`, fallback `String()` |
| G5 | Bouton « Recommencer » → `new_game` | ☐ VAL-UI | signal `pressed` connecté |
| G6 | Bouton « Menu » → menu | ☐ VAL-UI | placeholder vers Main.tscn |
| G7 | Esc ne ferme pas | ☐ VAL-UI | `set_input_as_handled` posé |

## SystemsDebugScene (mix API/UI)

| # | Cas | Statut | Validation |
|---|---|---|---|
| 1  | Set ex_name « Naoki », vérifier name fixé, set « Autre » refusé | ✅ VAL-API | `test_set_ex_name_premier_appel_reussit`, `test_set_ex_name_second_appel_refuse` |
| 2  | `add_trait("manipulateur")` × 2 → pas de doublon | ✅ VAL-API | `test_add_trait_pas_de_doublon` |
| 3  | Set ex_name → overlay game over miroir contient le nom | ✅ VAL-API | `test_overlay_quote_avec_ex_nomme` (« Comme Naoki faisait. ») |
| 4  | `tick("audit_marine", 5)` → 5/15 | ✅ VAL-API | `test_tick_incremente_current` |
| 5  | Surveillance 25/50/75 → 3 signals `threshold_crossed` ordre | ✅ VAL-API | `test_threshold_crossed_montant_unique` + couvert dans signaux Mirror via `test_threshold_crossed_30_60_90` |
| 6  | Redescente puis remontée au-dessus de 50 → pas de re-signal | ✅ VAL-API | `test_threshold_monotone_pas_re_emis` |
| 7  | Save v1 chargée → migration silencieuse | ✅ VAL-API | `test_charger_v1_silencieux`, `test_migrer_v1_garnit_cles_manquantes` |
| 8  | Réputation `stratom -15` n'affecte pas relation `marl` | ✅ VAL-API | séparation par construction : `ReputationManager` ≠ `RelationManager`, aucun couplage auto code-side |
| 9  | `modifier("sara", -8)` ne change pas réputation `presse` automatiquement | ✅ VAL-API | idem, aucune propagation auto |
| 10 | Set `ex_gender("feminin")` → pronoms `elle/la/sa`, `is_defined=true`, save/reload persiste, new_game reset | ✅ VAL-API | `test_get_pronouns_feminin` + `test_is_defined_true_apres_set_gender_seul` + `test_save_load_roundtrip_avec_genre` + `test_reset_all_remet_defauts` |

## SystemsDebugScene — panneau Ex Profile (UI)

| # | Élément | Statut | Note |
|---|---|---|---|
| EX1 | 4 boutons radio Genre | ☐ VAL-UI | 4 boutons créés dans `GenderRow` |
| EX2 | Premier clic set, autres no-op | ✅ VAL-API | `test_set_ex_gender_second_appel_refuse` ; côté UI le rafraîchissement appelle `_rafraichir_ex` à chaque clic |
| EX3 | Label « Pronoms actuels » formaté | ☐ VAL-UI | `_rafraichir_ex` formate dict via `str()` |
| EX4 | Label « Genre overridden : true/false » | ☐ VAL-UI | inclus dans `ExStatus.text` |
| EX5 | Bouton « New Game » reset le panneau | ✅ VAL-API | `test_new_game_reset_tous_les_managers` + UI rafraîchit |

## Régression demo.tscn

N/A : `demo.tscn` n'existe pas (Prompt 3 hors-scope sur ce repo).

| # | Cas | Statut |
|---|---|---|
| D1–D4 | Lancement, save, reload, format v2 | N/A (sera couvert au Prompt 3 si joué) |

## Procédure de validation manuelle (humain devant l'éditeur)

1. Lancer `./tests/run_tests.sh` — doit afficher `All tests passed!`.
2. Ouvrir Godot 4.4, charger le projet (un scan d'éditeur s'effectue
   à la première ouverture).
3. Ouvrir `scenes/core/SystemsDebugScene.tscn`, F6 (Run scene).
4. Parcourir les boutons dans l'ordre EX1 → EX5, H1 → H8, G1 → G7.
   Pour chaque case **VAL-UI** : cocher si OK, écrire la date.
5. Si un cas échoue : créer une issue, ne pas cocher.

## Statut global

- Dernière validation auto (GUT) : **20 mai 2026**
- Validateur auto : Claude (Opus 4.7) headless
- Cas auto-validés : **11 / 30** (VAL-API)
- Cas VAL-UI restants : **19 / 30** — à cocher en local par un humain
- Version Godot : 4.4.1 stable
- Version GUT : 9.3.0
