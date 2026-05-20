@echo off
REM Lance la suite GUT en mode headless (Windows).
godot --headless --path . -s addons/gut/gut_cmdln.gd ^
  -gdir=res://tests -gexit
