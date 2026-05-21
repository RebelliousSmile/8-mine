#!/bin/bash
# Lance la suite GUT en mode headless.
# Usage : ./tests/run_tests.sh
# Pré-requis : godot dans le PATH (binaire 4.4+, GUT 9.3 testé).
#
# Premier lancement : on force un scan éditeur pour reconstruire
# le cache de class_name (sinon GutUtils n'est pas résolu en CLI).
set -e

if [ ! -f .godot/global_script_class_cache.cfg ]; then
  echo "[run_tests] init : scan éditeur pour cache class_name…"
  godot --editor --headless --quit-after 5 > /dev/null 2>&1 || true
fi

godot --headless --path . -s addons/gut/gut_cmdln.gd \
  -gdir=res://tests -gexit
