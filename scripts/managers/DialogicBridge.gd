extends Node
## Pont entre Dialogic 2 et les managers narratifs custom.
##
## Dialogic n'a pas besoin de connaître nos managers : il émet des
## signaux génériques (`signal_event`) avec un argument texte qu'on
## interprète ici. Cela évite tout couplage dur dans les timelines.
##
## ── Syntaxe à utiliser dans les timelines .dtl ─────────────────────
##
##   [signal arg="relation:alex:+5:compliment"]
##       → RelationManager.modifier("alex", 5, "compliment")
##
##   [signal arg="relation:alex:-10:mensonge"]
##       → RelationManager.modifier("alex", -10, "mensonge")
##
##   [signal arg="flag:chapitre_1.cle_volee:true"]
##       → GameStateManager.set_flag("chapitre_1.cle_volee", true)
##
##   [signal arg="decision:trahison_sam:Trahir Sam au club"]
##       → GameStateManager.enregistrer_decision("trahison_sam",
##                                                "Trahir Sam au club", {})
##
##   [signal arg="lieu:chambre_max"]
##       → LocationManager.aller_a("chambre_max")
##
##   [signal arg="surveillance:+10:camera_repere"]
##       → SurveillanceManager.increase(10, "camera_repere")
##
##   [signal arg="miroir:+5:mensonge_emma"]
##       → MirrorStatusManager.increase(5, "mensonge_emma")
##
##   [signal arg="reputation:stratom:-20:fuite_documents"]
##       → ReputationManager.modifier("stratom", -20, "fuite_documents")
##
##   [signal arg="countdown:equipe_nettoyage:1"]
##       → CountdownManager.tick("equipe_nettoyage", 1)
##
##   [signal arg="ms:-1:mensonge_emma"]
##       → GameStateManager.mental_stability += -1  (clamped 0..MAX)
##
##   [signal arg="pd:+1:repere_camera"]
##       → GameStateManager.personal_danger += 1   (clamped >= 0)
##
## Vous pouvez aussi appeler directement les autoloads via la syntaxe
## d'expression Dialogic : `{RelationManager.modifier("alex", 5, "")}`.
## Le format `signal` reste préférable car il documente l'effet
## narratif sans embarquer du code dans la timeline.

func _ready() -> void:
	# Connexion paresseuse : on attend la frame suivante au cas où
	# Dialogic ne serait pas encore initialisé.
	call_deferred("_connecter_dialogic")


func _connecter_dialogic() -> void:
	var dialogic := get_node_or_null("/root/Dialogic")
	if dialogic == null:
		push_warning("DialogicBridge : autoload Dialogic introuvable. "
			+ "Installez Dialogic 2 et activez-le dans Paramètres > Extensions.")
		return

	# Dialogic 2 expose `signal_event` (signal global émis par
	# l'événement texte [signal arg="..."])
	if dialogic.has_signal("signal_event"):
		dialogic.signal_event.connect(_on_signal_event)
	else:
		push_warning("DialogicBridge : 'signal_event' absent de Dialogic. "
			+ "Vérifiez la version (≥ 2.0).")

	# Dialogic 2 expose aussi `timeline_ended` et `timeline_started`,
	# pratiques pour bloquer les hotspots pendant un dialogue.
	if dialogic.has_signal("timeline_started"):
		dialogic.timeline_started.connect(_on_timeline_started)
	if dialogic.has_signal("timeline_ended"):
		dialogic.timeline_ended.connect(_on_timeline_ended)


# --- Signaux exposés vers la couche UI ------------------------------------

signal dialogue_demarre
signal dialogue_termine


# --- Handlers -------------------------------------------------------------

func _on_signal_event(argument: Variant) -> void:
	# `argument` peut être Dictionary (Dialogic ≥ 2.1) ou String.
	var texte := ""
	if typeof(argument) == TYPE_STRING:
		texte = String(argument)
	elif typeof(argument) == TYPE_DICTIONARY:
		texte = String(argument.get("argument", ""))
	if texte.is_empty():
		return

	var morceaux := texte.split(":", false)
	if morceaux.is_empty():
		return

	match morceaux[0]:
		"relation":
			_traiter_relation(morceaux)
		"flag":
			_traiter_flag(morceaux)
		"decision":
			_traiter_decision(morceaux)
		"lieu":
			_traiter_lieu(morceaux)
		"surveillance":
			_traiter_surveillance(morceaux)
		"miroir":
			_traiter_miroir(morceaux)
		"reputation":
			_traiter_reputation(morceaux)
		"countdown":
			_traiter_countdown(morceaux)
		"ms":
			_traiter_ms(morceaux)
		"pd":
			_traiter_pd(morceaux)
		"ev":
			_traiter_ev(morceaux)
		_:
			push_warning("DialogicBridge : commande inconnue '%s'" % morceaux[0])


func _on_timeline_started() -> void:
	dialogue_demarre.emit()


func _on_timeline_ended() -> void:
	dialogue_termine.emit()


# --- Parseurs --------------------------------------------------------------

func _traiter_relation(morceaux: PackedStringArray) -> void:
	# relation:<personnage>:<delta>:<raison?>
	if morceaux.size() < 3:
		return
	var personnage: String = morceaux[1]
	var delta: int = int(morceaux[2])
	var raison: String = morceaux[3] if morceaux.size() > 3 else ""
	RelationManager.modifier(personnage, delta, raison)


func _traiter_flag(morceaux: PackedStringArray) -> void:
	# flag:<cle>:<valeur>
	if morceaux.size() < 3:
		return
	var cle: String = morceaux[1]
	var brut: String = morceaux[2]
	var valeur: Variant = _typer(brut)
	GameStateManager.set_flag(cle, valeur)


func _traiter_decision(morceaux: PackedStringArray) -> void:
	# decision:<id>:<libelle>
	if morceaux.size() < 3:
		return
	var id_dec: String = morceaux[1]
	var libelle: String = morceaux[2]
	GameStateManager.enregistrer_decision(id_dec, libelle, {
		"lieu": LocationManager.get_lieu_actuel(),
	})


func _traiter_lieu(morceaux: PackedStringArray) -> void:
	# lieu:<id_lieu>
	if morceaux.size() < 2:
		return
	LocationManager.aller_a(morceaux[1])


func _traiter_surveillance(morceaux: PackedStringArray) -> void:
	# surveillance:<delta>:<raison?>
	# delta positif = increase, négatif = decrease
	if morceaux.size() < 2:
		return
	var delta: int = int(morceaux[1])
	var raison: String = morceaux[2] if morceaux.size() > 2 else ""
	if delta > 0:
		SurveillanceManager.increase(delta, raison)
	elif delta < 0:
		SurveillanceManager.decrease(-delta, raison)


func _traiter_miroir(morceaux: PackedStringArray) -> void:
	# miroir:<delta>:<raison?>
	# delta positif = increase, négatif = decrease
	if morceaux.size() < 2:
		return
	var delta: int = int(morceaux[1])
	var raison: String = morceaux[2] if morceaux.size() > 2 else ""
	if delta > 0:
		MirrorStatusManager.increase(delta, raison)
	elif delta < 0:
		MirrorStatusManager.decrease(-delta, raison)


func _traiter_reputation(morceaux: PackedStringArray) -> void:
	# reputation:<faction>:<delta>:<raison?>
	if morceaux.size() < 3:
		return
	var faction: String = morceaux[1]
	var delta: int = int(morceaux[2])
	var raison: String = morceaux[3] if morceaux.size() > 3 else ""
	ReputationManager.modifier(faction, delta, raison)


func _traiter_countdown(morceaux: PackedStringArray) -> void:
	# countdown:<id>:<delta>
	# delta positif = tick (avance), négatif = untick (recule)
	if morceaux.size() < 3:
		return
	var id_cd: String = morceaux[1]
	var delta: int = int(morceaux[2])
	if delta > 0:
		CountdownManager.tick(id_cd, delta)
	elif delta < 0:
		CountdownManager.untick(id_cd, -delta)


func _traiter_ms(morceaux: PackedStringArray) -> void:
	# ms:<delta>:<raison?>
	# Modifie mental_stability (clampé par le setter de GameStateManager).
	# La raison reste informative dans la timeline et n'est pas persistée ici.
	if morceaux.size() < 2:
		return
	var delta: int = int(morceaux[1])
	if delta != 0:
		GameStateManager.mental_stability += delta


func _traiter_pd(morceaux: PackedStringArray) -> void:
	# pd:<delta>:<raison?>
	# Modifie personal_danger (clampé >= 0 par le setter de GameStateManager).
	if morceaux.size() < 2:
		return
	var delta: int = int(morceaux[1])
	if delta != 0:
		GameStateManager.personal_danger += delta


func _traiter_ev(morceaux: PackedStringArray) -> void:
	# ev:<delta>:<raison?>
	# Modifie evidence_collected (clampé >= 0 par le setter de GameStateManager).
	# La raison reste informative dans la timeline et n'est pas persistée ici.
	if morceaux.size() < 2:
		return
	var delta: int = int(morceaux[1])
	if delta != 0:
		GameStateManager.evidence_collected += delta


## Convertit un texte en bool/int/float si possible, sinon le laisse en String.
func _typer(brut: String) -> Variant:
	match brut.to_lower():
		"true", "vrai":
			return true
		"false", "faux":
			return false
	if brut.is_valid_int():
		return int(brut)
	if brut.is_valid_float():
		return float(brut)
	return brut
