extends Node
## Profil de l'ex référencé dans le récit. Nom, genre, traits.
## Tous les overrides sont immuables après le premier set
## (l'engagement narratif du joueur est définitif).

signal ex_name_set(new_name: String)
signal ex_gender_set(new_gender: String)
signal trait_added(trait_id: String)

const EchoConfig := preload("res://scripts/config/echo_phrases.gd")

const VALID_TRAITS := [
	"manipulateur", "absent", "violent_verbal", "envahissant",
	"infidele", "controlant", "froid", "instable", "menteur",
	"sain",
]

const VALID_GENDERS := ["masculin", "feminin", "non_binaire", "unspecified"]

const PRONOUNS := {
	"masculin":    { "subject": "il",      "object": "le",     "possessive": "son",    "stress": "lui" },
	"feminin":     { "subject": "elle",    "object": "la",     "possessive": "sa",     "stress": "elle" },
	"non_binaire": { "subject": "iel",     "object": "le/la",  "possessive": "ses",    "stress": "iel" },
	"unspecified": { "subject": "il/elle", "object": "le/la",  "possessive": "son/sa", "stress": "lui/elle" },
}

const DEFAUT_NAME := "Julien"
const DEFAUT_GENDER := "masculin"

var ex_name: String = DEFAUT_NAME
var is_name_overridden: bool = false
var ex_gender: String = DEFAUT_GENDER
var is_gender_overridden: bool = false
var ex_traits: Dictionary = {}
var relationship_duration_months: int = 0
var relationship_ended_months_ago: int = 0
var relationship_end_circumstance: String = ""


func _ready() -> void:
	# Les valeurs par défaut sont déjà posées par déclaration de variable.
	# reset_all_for_new_game est appelé explicitement par SaveManager.new_game.
	pass


# --- Setters immuables ----------------------------------------------------

func set_ex_name(new_name: String) -> bool:
	if is_name_overridden:
		return false
	ex_name = new_name
	is_name_overridden = true
	ex_name_set.emit(new_name)
	return true


func set_ex_gender(new_gender: String) -> bool:
	assert(new_gender in VALID_GENDERS,
		"set_ex_gender: '%s' n'est pas dans VALID_GENDERS" % new_gender)
	if is_gender_overridden:
		return false
	ex_gender = new_gender
	is_gender_overridden = true
	ex_gender_set.emit(new_gender)
	return true


# --- Accès ----------------------------------------------------------------

func get_display_name() -> String:
	return ex_name


func get_pronouns() -> Dictionary:
	return PRONOUNS[ex_gender]


# --- Traits ---------------------------------------------------------------

func add_trait(trait_id: String) -> void:
	assert(trait_id in VALID_TRAITS,
		"add_trait: '%s' n'est pas dans VALID_TRAITS" % trait_id)
	if ex_traits.has(trait_id):
		return
	ex_traits[trait_id] = true
	trait_added.emit(trait_id)


func has_trait(trait_id: String) -> bool:
	return ex_traits.get(trait_id, false)


# --- Durée / circonstances -----------------------------------------------

func set_duration(months: int) -> void:
	relationship_duration_months = maxi(0, months)


func set_ended(months_ago: int) -> void:
	relationship_ended_months_ago = maxi(0, months_ago)


func set_end_circumstance(text: String) -> void:
	relationship_end_circumstance = text


# --- État dérivé ----------------------------------------------------------

func is_defined() -> bool:
	return is_name_overridden or is_gender_overridden or ex_traits.size() > 0


func get_echo_phrase() -> String:
	if is_defined():
		return EchoConfig.ECHO_PHRASES["defined"].format({"ex_name": ex_name})
	return EchoConfig.ECHO_PHRASES["undefined"]


# --- Sérialisation --------------------------------------------------------

func save_state() -> Dictionary:
	return {
		"ex_name": ex_name,
		"is_name_overridden": is_name_overridden,
		"ex_gender": ex_gender,
		"is_gender_overridden": is_gender_overridden,
		"ex_traits": ex_traits.duplicate(true),
		"relationship_duration_months": relationship_duration_months,
		"relationship_ended_months_ago": relationship_ended_months_ago,
		"relationship_end_circumstance": relationship_end_circumstance,
	}


func load_state(data: Dictionary) -> void:
	ex_name = String(data.get("ex_name", DEFAUT_NAME))
	is_name_overridden = bool(data.get("is_name_overridden", false))
	ex_gender = String(data.get("ex_gender", DEFAUT_GENDER))
	is_gender_overridden = bool(data.get("is_gender_overridden", false))
	ex_traits = (data.get("ex_traits", {}) as Dictionary).duplicate(true)
	relationship_duration_months = int(data.get("relationship_duration_months", 0))
	relationship_ended_months_ago = int(data.get("relationship_ended_months_ago", 0))
	relationship_end_circumstance = String(data.get("relationship_end_circumstance", ""))


func reset_all_for_new_game() -> void:
	ex_name = DEFAUT_NAME
	is_name_overridden = false
	ex_gender = DEFAUT_GENDER
	is_gender_overridden = false
	ex_traits = {}
	relationship_duration_months = 0
	relationship_ended_months_ago = 0
	relationship_end_circumstance = ""
