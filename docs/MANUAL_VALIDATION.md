# Validation manuelle 8-MINE

> Cases à cocher après chaque release de la couche 4a. Pour chaque
> entrée : `✅` + date + note brève. Les éléments rendu / animation /
> input ne sont pas testables headless ; cette liste est le filet
> de sécurité.

## SurveillanceHUD

| # | Cas | Statut | Date | Note |
|---|---|---|---|---|
| H1 | HUD visible en haut-droite, layer ≥ 50 | ☐ | | |
| H2 | Emprise ≤ 25 % × 20 % de l'écran | ☐ | | |
| H3 | 80 % inférieurs réservés (zone dialogue future) restent libres | ☐ | | |
| H4 | `set_visible_for_cinematic(false)` masque sans casser le layout | ☐ | | |
| H5 | `Shift+F1` toggle l'affichage | ☐ | | |
| H6 | Pulse visuel sur `surveillance_changed` | ☐ | | |
| H7 | Pulse plus marqué sur `threshold_crossed` | ☐ | | |
| H8 | Overlay `show_game_over_overlay(quote)` couvre 100 %, animation 1–2 s, signal final | ☐ | | |

## GameOverScreen

| # | Cas | Statut | Date | Note |
|---|---|---|---|---|
| G1 | Affiche `title` du payload en gros | ☐ | | |
| G2 | Affiche `overlay_quote` sous le titre | ☐ | | |
| G3 | `history` scrollable, mise en page lisible | ☐ | | |
| G4 | `history_formatter` (Callable) utilisé si fourni, fallback sinon | ☐ | | |
| G5 | Bouton « Recommencer » → `SaveManager.new_game()` + retour menu | ☐ | | |
| G6 | Bouton « Menu » → menu principal Maaack | ☐ | | |
| G7 | Esc ne ferme pas le screen (force le choix) | ☐ | | |

## SystemsDebugScene (10 cas de référence)

Accessible via menu Maaack si `Config.DEBUG_MODE == true`.

| # | Cas | Statut | Date | Note |
|---|---|---|---|---|
| 1 | Set ex_name « Naoki », vérifier `get_display_name() == "Naoki"`, set ex_name « Autre » refusé | ☐ | | |
| 2 | `add_trait("manipulateur")` × 2 → `has_trait` true, pas de doublon | ☐ | | |
| 3 | Set ex_name, augmenter MirrorStatus à 100 → overlay game over contient le nom posé | ☐ | | |
| 4 | CountdownManager `tick("audit_marine", 5)` → HUD reflète 5/15 | ☐ | | |
| 5 | SurveillanceManager passe 25, 50, 75 → 3 signals `threshold_crossed` (un par seuil, dans l'ordre) | ☐ | | |
| 6 | SurveillanceManager redescend puis remonte au-dessus de 50 → **pas** de second signal pour 50 (monotone) | ☐ | | |
| 7 | Sauvegarde v1 (manuelle, JSON sans clé `version` ou `version=1`) chargée → migration silencieuse, défauts appliqués | ☐ | | |
| 8 | Modifier réputation `stratom -15` → relation `marl` n'est **pas** auto-modifiée (séparation explicite) | ☐ | | |
| 9 | `RelationManager.modifier("sara", -8, "test")` → réputation `presse` modifiée seulement si couplage explicite codé | ☐ | | |
| 10 | Set `ex_gender("feminin")` → `get_pronouns().subject == "elle"`, `is_defined()` devient true même sans nom override ni traits ; save slot, reload Godot, load slot : genre + pronoms persistent ; new_game : retour défauts (`masculin`, override false) | ☐ | | |

## SystemsDebugScene — panneau Ex Profile (v7)

| # | Élément attendu | Statut |
|---|---|---|
| EX1 | 4 boutons radio Genre : `[masculin] [feminin] [non_binaire] [unspecified]` | ☐ |
| EX2 | Premier clic sur un genre → set effectif, override = true, autres clics no-op | ☐ |
| EX3 | Label « Pronoms actuels » affiche le dict retourné par `get_pronouns()` formaté | ☐ |
| EX4 | Label « Genre overridden : true / false » se met à jour | ☐ |
| EX5 | Bouton « New Game » sur le panneau → retour `masculin`, override false | ☐ |

## Régression demo.tscn

> N'a pas d'objet en 4a si Prompt 3 (qui crée `demo.tscn`) n'a pas
> été joué. Marqué N/A sur ce projet tant que demo.tscn n'existe pas.

| # | Cas | Statut |
|---|---|---|
| D1 | Lancer `demo.tscn`, modifier la relation Sara | N/A |
| D2 | Sauvegarder slot 1, quitter Godot | N/A |
| D3 | Relancer, charger slot 1 : relation Sara identique | N/A |
| D4 | JSON du slot 1 a `version == 2` (pas de migration nécessaire) | N/A |

## Procédure recommandée

1. Lancer `./tests/run_tests.sh` — doit être 100 % vert avant
   validation manuelle.
2. Lancer Godot éditeur, ouvrir `scenes/core/SystemsDebugScene.tscn`,
   parcourir les 10 cas dans l'ordre.
3. Pour chaque case cochée, écrire la date + une note d'une ligne
   (« OK », « OK après ajustement du timing à 1.2 s », etc.).
4. Si un cas échoue : créer une issue, ne pas cocher.

## Statut global

- Date de la dernière validation complète : ___
- Validateur : ___
- Version Godot : 4.4.1
- Version GUT : 9.3.0
- Cas cochés : 0 / 30
