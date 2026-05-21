extends Node
## Configuration globale du build.
## Autoload nommé `Config` (premier de la liste).

const DEBUG_MODE := true  ## mettre à false pour build prod

## Accès direct aux phrases d'écho miroir (préload).
const ECHO_PHRASES := preload("res://scripts/config/echo_phrases.gd")
