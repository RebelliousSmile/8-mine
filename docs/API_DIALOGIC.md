# API Dialogic — DialogicBridge

> Pont entre les timelines Dialogic (`.dtl`) et les managers 8-MINE.
> Tous les dispatchers listés ci-dessous sont **implémentés** dans
> `scripts/managers/DialogicBridge.gd`.

## Syntaxe universelle

Dans un fichier `.dtl`, utilise l'événement `[signal]` avec la syntaxe :

```
[signal arg="<dispatcher>:<arg1>:<arg2>:<raison?>"]
```

## Dispatchers disponibles

| Dispatcher | Signature | Manager cible | Exemple |
|---|---|---|---|
| `relation` | `relation:<pnj_id>:<delta>` | `RelationManager` | `[signal arg="relation:emma:+10:confidence"]` |
| `flag` | `flag:<cle>:<valeur>` | `GameStateManager` | `[signal arg="flag:flag_emma_a_reveele:true"]` |
| `decision` | `decision:<id>:<libelle>` | `GameStateManager` | `[signal arg="decision:trahison:Trahir Sam"]` |
| `lieu` | `lieu:<id_lieu>` | `LocationManager` | `[signal arg="lieu:zone_commune_soir"]` |
| `surveillance` | `surveillance:<delta>:<raison?>` | `SurveillanceManager` | `[signal arg="surveillance:+10:camera_repere"]` |
| `mirror` | `mirror:<delta>:<raison?>` | `MirrorStatusManager` | `[signal arg="mirror:+5:choix_lache"]` |
| `ms` | `ms:<delta>:<raison?>` | `MirrorStatusManager` (alias) | `[signal arg="ms:-1:mensonge_emma"]` |
| `reputation` | `reputation:<faction>:<delta>:<raison?>` | `ReputationManager` | `[signal arg="reputation:stratom:-15:fuite_dossier"]` |
| `pd` | `pd:<delta>:<raison?>` | `GameStateManager.personal_danger` | `[signal arg="pd:+1:repere_camera"]` |
| `ev` | `ev:<delta>:<raison?>` | `GameStateManager.evidence_value` | `[signal arg="ev:+1:preuve_enregistree"]` |

## Variables Dialogic exposées

`GameStateManager` synchronise automatiquement chaque flag vers
`Dialogic.VAR` :

| Flag interne | Variable Dialogic |
|---|---|
| `chapitre_1.cle_volee` | `chapitre_1_cle_volee` |
| `decision.trahison_sam` | `decision_trahison_sam` |

Les conditions dans les timelines peuvent donc lire ces variables :
`{chapitre_1_cle_volee == true}`. Les autres managers (relations,
réputation, mirror, surveillance, ex profile) **ne sont pas**
exposés automatiquement — utiliser les dispatchers ci-dessus pour
les modifier depuis une timeline.

## Sécurité et dégradation gracieuse

- `DialogicBridge.gd` reste autoload : il ne casse rien si Dialogic
  n'est pas installé (warning `push_warning` + no-op).
- Un dispatcher inconnu émet un warning et est ignoré silencieusement.
- Le linter `scripts/tools/dtl_linter.gd` valide les dispatchers avant
  tout review — seuls les dispatchers de `DISPATCHERS_VALIDES` sont
  acceptés.

## Référence rapide complète

Voir `aidd_docs/memory/internal/api-cheatsheet.md` pour des exemples
complets par scénario d'usage.
