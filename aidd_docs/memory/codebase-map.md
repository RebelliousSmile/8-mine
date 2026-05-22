---
name: codebase-structure
description: Carte macro du codebase 8-MINE
scope: all
---

# Codebase Structure

```mermaid
flowchart TD
    Root[8-mine/]
    Root --> Scenes[scenes/<br/>Scènes Godot .tscn + .gd]
    Root --> Scripts[scripts/<br/>14 autoloads GDScript]
    Root --> Dialogues[dialogues/<br/>Timelines Dialogic .dtl]
    Root --> Dialogic[dialogic/<br/>Plugin runtime + character files]
    Root --> Addons[addons/<br/>dialogic, gut]
    Root --> Assets[assets/<br/>bg_*.jpg, sprites, audio]
    Root --> Data[data/<br/>JSON config narratif]
    Root --> Docs[docs/<br/>Documentation technique]
    Root --> AiddDocs[aidd_docs/<br/>AIDD memory + AIW]
    Root --> Tests[tests/<br/>GUT specs + mocks + helpers]
    Scripts -. autoload order .-> ProjectGodot[project.godot]
    Dialogues -. parsed by .-> Dialogic
    Scenes -. instantiate .-> Scripts
```

## Dossiers clés

- `scenes/` — racines visuelles (rooms point-and-click, écrans, UI overlays)
- `scripts/` — autoloads, gestionnaires, helpers GDScript
- `dialogues/` — timelines Dialogic `.dtl` (un fichier = une scène/dialogue)
- `addons/dialogic/` — plugin Dialogic 2
- `addons/gut/` — plugin GUT 9.6.0
- `data/` — JSON statiques (PNJ, paliers, factions, configs UI complexes)
- `docs/` — `ARCHITECTURE_8MINE.md`, `API_PUBLIQUE.md`, `MECANIQUES_8MINE.md`, etc.
- `aidd_docs/` — mémoire AI (memory/internal, memory/external, aiw/8mine)
- `tests/` — `helpers/test_environment.gd`, `mocks/`, specs `test_*.gd`

## Points d'entrée

- `project.godot` — config moteur + ordre des 14 autoloads
- `Main.tscn` — scène de démarrage (Maaack supprimé)
- `tests/run_tests.bat` / `tests/run_tests.sh` — runner GUT
