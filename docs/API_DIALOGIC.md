# API Dialogic — couche 4a

> **Cette couche n'intègre pas Dialogic.** Le pont
> `DialogicBridge.gd` (Prompt 1) est en place pour les Custom Events
> futurs (Prompt 4c) mais n'est pas étendu ici.

## Pourquoi pas d'intégration ici

L'objectif de 4a est d'avoir une **couche de systèmes testable en
isolation**, sans dépendance runtime à un plugin externe. Les
managers 8-MINE doivent pouvoir tourner :

- En tests GUT headless (pas d'autoload Dialogic chargé)
- Dans `SystemsDebugScene` (UI native Godot, pas de timeline)
- Dans un futur portage console / mobile où Dialogic ne serait pas
  installé

## Comment Dialogic appellera ces managers (futur Prompt 4c)

Quand un Custom Event Dialogic sera créé, il aura accès aux
autoloads et pourra :

```gdscript
# Custom Event Dialogic exemple : "augmenter surveillance"
extends DialogicEvent

@export var amount: int = 10
@export var raison: String = ""

func _execute() -> void:
    SurveillanceManager.increase(amount, raison)
    finish()
```

Le pont actuel (`DialogicBridge`) supporte déjà la syntaxe textuelle
universelle :

```
[signal arg="surveillance:+10:traversee_rue_filmee"]
[signal arg="mirror:+5:choix_lache"]
[signal arg="reputation:stratom:-15:fuite_dossier"]
```

À implémenter dans `DialogicBridge._on_signal_event` quand 4c sera
joué. Voir le code actuel pour les patterns `relation:`, `flag:`,
`decision:`, `lieu:`.

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
exposés automatiquement — un futur prompt ajoutera des `getter`
Dialogic dédiés.

## Hors-scope assumé

- Aucun fichier `.dtl` créé dans cette phase
- Aucun appel à `Dialogic.start()` ou `Dialogic.VAR.*` depuis les
  nouveaux managers
- `DialogicBridge.gd` (Prompt 1) reste autoload : il ne casse rien
  si Dialogic n'est pas installé (warning push + no-op)
