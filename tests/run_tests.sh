#!/bin/bash
# Lance la suite GUT en mode headless.
# Usage : ./tests/run_tests.sh
# Pré-requis : godot dans le PATH (binaire 4.4+, GUT 9.3 testé).
#
# Premier lancement : on force un scan éditeur pour reconstruire
# le cache de class_name (sinon GutUtils n'est pas résolu en CLI).
#
# Workaround : Dialogic 2.0-alpha-19 peut SIGSEGV au shutdown
# headless (cleanup mutex). On considère le run réussi si la
# sentinelle "All tests passed!" apparaît dans la sortie, même
# si le process exit avec un signal.

if [ ! -f .godot/global_script_class_cache.cfg ]; then
  echo "[run_tests] init : scan éditeur pour cache class_name…"
  godot --editor --headless --quit-after 5 > /dev/null 2>&1 || true
fi

OUT=$(godot --headless --path . -s addons/gut/gut_cmdln.gd \
  -gdir=res://tests -gexit 2>&1)
EC=$?

echo "$OUT"

if echo "$OUT" | grep -q "All tests passed!"; then
  exit 0
fi
if echo "$OUT" | grep -qE "([0-9]+) failing tests"; then
  exit 1
fi
exit "$EC"
