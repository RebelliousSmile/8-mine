---
name: deployment
description: Infrastructure et distribution 8-MINE
scope: all
---

# Deployment

## Project Structure (top-level)

```text
8-mine/
├── project.godot          # Config moteur + ordre des 14 autoloads
├── Main.tscn              # Scène de démarrage
├── scripts/               # Autoloads + scripts GDScript
├── scenes/                # Scènes .tscn + scripts attachés .gd
├── dialogues/             # Timelines Dialogic .dtl
├── addons/                # Plugins (Dialogic 2, GUT 9.6.0)
├── assets/                # bg_*.jpg, sprites, audio
├── data/                  # JSON config narratif
├── docs/                  # Documentation technique
├── aidd_docs/             # Mémoire AI + AIW
└── tests/                 # GUT specs + mocks
```

## Build / Export

- **Engine** : Godot 4 .NET (variante .NET utilisée mais pas de C# — GDScript pur)
- **Export targets** : configurés via Godot Editor (`Project → Export`)
- **Pas de pipeline CI/CD de release** actuellement — builds locaux depuis l'éditeur

## Environments

- **Development** : éditeur Godot local (`godot --editor --path .`)
- **Test** : runner GUT headless ou via `tests/run_tests.bat`
- **Production / distribution** : non automatisée — export manuel via éditeur Godot

## Saves utilisateur

- Localisation : `user://saves/save_N.json` (3 slots)
- Format : JSON v2 (migration v1 → v2 au load)
- Raccourcis in-game : `F5` quicksave slot 0, `F9` quickload slot 0

## Monitoring & Logging

- **Pas de monitoring distant** — jeu solo offline
- **Logs locaux** : `print()` / `push_warning()` GDScript, lisibles via la console Godot

## Variables d'environnement

Aucune. Le jeu est entièrement self-contained. `Config.DEBUG_MODE` (autoload 1) sert de flag debug runtime.
