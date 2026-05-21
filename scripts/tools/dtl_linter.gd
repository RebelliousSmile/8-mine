#!/usr/bin/env -S godot --headless --script
extends SceneTree
## Linter mécanique pour timelines Dialogic .dtl — 8-MINE
##
## Usage :
##   godot --headless --path . --script scripts/tools/dtl_linter.gd -- <chemin .dtl> [...autres .dtl]
##
## Vérifie :
##   - Commandes [signal arg="..."] reconnues par DialogicBridge (8 dispatchers)
##   - Factions valides parmi les 8 connues
##   - Countdowns valides parmi ceux déclarés
##   - PNJs cités correspondent à un personnage Dialogic connu
##   - Variables {var} référencent une variable existante
##   - Chaque [choice] mène à au moins un [signal arg="lieu:..."] ou flag de fin
##   - Pas de [signal] sans `arg=`
##
## Codes de sortie :
##   0 → PASS (tout OK)
##   1 → FAIL (au moins une erreur bloquante)
##   2 → WARN (warnings uniquement, pas d'erreur bloquante)

const FACTIONS_VALIDES := [
	"stratom", "marine", "presse", "police",
	"activistes", "memorize", "nexus", "kaizen"
]

const COUNTDOWNS_VALIDES := ["equipe_nettoyage", "audit_marine"]

const PNJ_VALIDES := [
	"emma", "frank", "sofia", "leo", "camille", "alex", "victor", "aiko",
	"margot", "narrator",
	"_",                # raccourci narrator Dialogic 2
	"voix_synthetique"  # voix off ambiance Néo-Paris
]

const DISPATCHERS_VALIDES := [
	"relation", "flag", "decision", "lieu",
	"surveillance", "miroir", "reputation", "countdown"
]

const VARIABLES_CANON := [
	"mental_stability", "personal_danger", "evidence_collected",
	"emma_prenom", "frank_prenom", "sofia_prenom", "leo_prenom",
	"camille_prenom", "alex_prenom", "victor_prenom", "aiko_prenom",
	"ex_prenom"
]

var _erreurs: Array[String] = []
var _warnings: Array[String] = []
var _fichier_courant: String = ""


func _init() -> void:
	var args := OS.get_cmdline_user_args()
	if args.is_empty():
		_log("ERREUR : aucun fichier .dtl passé en argument.")
		_log("Usage : godot --headless --path . --script scripts/tools/dtl_linter.gd -- <fichier.dtl>")
		quit(1)
		return

	var exit_code := 0
	for chemin: String in args:
		_fichier_courant = chemin
		_erreurs.clear()
		_warnings.clear()
		_lint_fichier(chemin)
		_afficher_rapport(chemin)
		if not _erreurs.is_empty():
			exit_code = 1
		elif not _warnings.is_empty() and exit_code == 0:
			exit_code = 2

	quit(exit_code)


func _lint_fichier(chemin: String) -> void:
	if not FileAccess.file_exists(chemin):
		_erreur("Fichier introuvable : " + chemin)
		return

	var f := FileAccess.open(chemin, FileAccess.READ)
	if f == null:
		_erreur("Impossible d'ouvrir : " + chemin)
		return

	var lignes: Array[String] = []
	while not f.eof_reached():
		lignes.append(f.get_line())
	f.close()

	var a_choix := false
	var derniere_branche_a_sortie := true  # par défaut, branche linéaire OK

	for i in lignes.size():
		var ligne := lignes[i]
		var num := i + 1

		# Ignorer les commentaires Dialogic (mais détecter les signaux/choices avant)
		var trimmed := ligne.strip_edges()
		var est_commentaire := trimmed.begins_with("#")

		if not est_commentaire:
			_verifier_signaux(ligne, num)
			_verifier_variables(ligne, num)
			_verifier_pnjs(ligne, num)

		if not est_commentaire:
			if ligne.contains("[choice"):
				if a_choix and not derniere_branche_a_sortie:
					_warning(num, "Branche précédente sans sortie explicite (lieu/flag de fin)")
				a_choix = true
				derniere_branche_a_sortie = false

			if a_choix and _ligne_a_signal_sortie(ligne):
				derniere_branche_a_sortie = true

	if a_choix and not derniere_branche_a_sortie:
		_warning(0, "Dernière branche du NODE sans sortie explicite")


func _verifier_signaux(ligne: String, num: int) -> void:
	# Détecte [signal arg="..."]
	var regex := RegEx.new()
	regex.compile('\\[signal\\s+arg="([^"]+)"\\]')
	var matches := regex.search_all(ligne)

	for m in matches:
		var arg: String = m.get_string(1)
		var morceaux := arg.split(":")
		if morceaux.is_empty():
			_erreur_l(num, "[signal arg=\"\"] vide")
			continue

		var dispatcher: String = morceaux[0]
		if dispatcher not in DISPATCHERS_VALIDES:
			_erreur_l(num, "Dispatcher inconnu '%s' — valides : %s"
				% [dispatcher, ", ".join(DISPATCHERS_VALIDES)])
			continue

		_verifier_dispatcher(dispatcher, morceaux, num)

	# Détecte [signal] sans arg=
	if ligne.contains("[signal") and not ligne.contains("arg="):
		_warning(num, "[signal] sans paramètre arg=")


func _verifier_dispatcher(disp: String, morceaux: PackedStringArray, num: int) -> void:
	match disp:
		"reputation":
			if morceaux.size() < 3:
				_erreur_l(num, "reputation:<faction>:<delta>:<raison?> — format invalide")
				return
			var faction: String = morceaux[1]
			if faction not in FACTIONS_VALIDES:
				_erreur_l(num, "Faction inconnue '%s' — valides : %s"
					% [faction, ", ".join(FACTIONS_VALIDES)])

		"countdown":
			if morceaux.size() < 3:
				_erreur_l(num, "countdown:<id>:<delta> — format invalide")
				return
			var cd: String = morceaux[1]
			if cd not in COUNTDOWNS_VALIDES:
				_warning(num, "Countdown '%s' non déclaré dans variables-register" % cd)

		"surveillance", "miroir":
			if morceaux.size() < 2:
				_erreur_l(num, "%s:<delta>:<raison?> — format invalide" % disp)
				return
			var delta: String = morceaux[1]
			if not _est_delta_valide(delta):
				_erreur_l(num, "%s : delta invalide '%s' (attendu +N ou -N)" % [disp, delta])
			if morceaux.size() < 3:
				_warning(num, "%s sans raison — traçabilité affaiblie" % disp)

		"relation":
			if morceaux.size() < 3:
				_erreur_l(num, "relation:<npc_id>:<delta>:<raison?> — format invalide")
				return
			var pnj: String = morceaux[1]
			if pnj not in PNJ_VALIDES:
				_warning(num, "PNJ '%s' non listé dans variables-register" % pnj)

		"flag":
			if morceaux.size() < 3:
				_erreur_l(num, "flag:<cle>:<valeur> — format invalide")

		"lieu":
			if morceaux.size() < 2:
				_erreur_l(num, "lieu:<id> — format invalide")

		"decision":
			if morceaux.size() < 3:
				_erreur_l(num, "decision:<id>:<libelle> — format invalide")


func _verifier_variables(ligne: String, num: int) -> void:
	# Détecte {var_name} hors blocs de code
	var regex := RegEx.new()
	regex.compile("\\{([a-z_][a-z0-9_]*)\\}")
	var matches := regex.search_all(ligne)

	for m in matches:
		var nom_var: String = m.get_string(1)
		# Les flags GameStateManager (avec "." → "_") sont autorisés
		# Les variables canon sont autorisées
		# Tout autre nom : warning
		if nom_var in VARIABLES_CANON:
			continue
		if nom_var.begins_with("flag_"):
			continue
		if nom_var.begins_with("pro_") or nom_var.begins_with("a1_") \
				or nom_var.begins_with("a2_") or nom_var.begins_with("a3_") \
				or nom_var.begins_with("a4_") or nom_var.begins_with("fin_"):
			continue
		# Mots-clés Dialogic à ignorer
		if nom_var in ["if", "endif", "else", "elif"]:
			continue
		_warning(num, "Variable '%s' non déclarée — vérifier variables-register" % nom_var)


func _verifier_pnjs(ligne: String, num: int) -> void:
	# Détecte les speakers Dialogic : "<pnj>:" en début de ligne (hors signaux)
	var trimmed := ligne.strip_edges()
	if trimmed.is_empty() or trimmed.begins_with("#") or trimmed.begins_with("["):
		return
	if not trimmed.contains(":"):
		return

	var prefix := trimmed.split(":", true, 1)[0].strip_edges().to_lower()
	# Ignorer les expressions de condition et les blocs Dialogic non-speaker
	if prefix.length() > 32 or prefix.contains(" "):
		return
	if prefix in PNJ_VALIDES:
		return
	if prefix.is_empty():
		return
	# Speakers non listés : warning seulement
	_warning(num, "Speaker '%s' non listé dans PNJ_VALIDES" % prefix)


func _ligne_a_signal_sortie(ligne: String) -> bool:
	if ligne.contains('[signal arg="lieu:'):
		return true
	if ligne.contains('[signal arg="flag:') and ligne.contains("termine"):
		return true
	if ligne.contains("arc_termine") or ligne.contains("node_termine"):
		return true
	return false


func _est_delta_valide(s: String) -> bool:
	if s.is_empty():
		return false
	if not (s.begins_with("+") or s.begins_with("-") or s[0].is_valid_int()):
		return false
	var n := s.lstrip("+-").to_int()
	return n != 0 or s == "0"


# --- Reporting ------------------------------------------------------------

func _erreur(msg: String) -> void:
	_erreurs.append(msg)


func _erreur_l(num: int, msg: String) -> void:
	_erreurs.append("L%d : %s" % [num, msg])


func _warning(num: int, msg: String) -> void:
	if num > 0:
		_warnings.append("L%d : %s" % [num, msg])
	else:
		_warnings.append(msg)


func _afficher_rapport(chemin: String) -> void:
	_log("")
	_log("════════════════════════════════════════════════════════")
	_log("📄 " + chemin)
	_log("════════════════════════════════════════════════════════")

	if _erreurs.is_empty() and _warnings.is_empty():
		_log("✅ PASS — aucune erreur, aucun warning")
		return

	if not _erreurs.is_empty():
		_log("❌ %d erreur(s) bloquante(s) :" % _erreurs.size())
		for e in _erreurs:
			_log("   • " + e)

	if not _warnings.is_empty():
		_log("⚠️  %d warning(s) :" % _warnings.size())
		for w in _warnings:
			_log("   • " + w)

	if _erreurs.is_empty():
		_log("⚠️  WARN — warnings uniquement (exit 2)")
	else:
		_log("❌ FAIL — au moins une erreur bloquante (exit 1)")


func _log(msg: String) -> void:
	print(msg)
