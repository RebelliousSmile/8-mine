extends Node
## STUB phase 2. Implémentation phase 3.

signal ex_name_set(new_name: String)
signal ex_gender_set(new_gender: String)
signal trait_added(trait_id: String)

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

var ex_name: String = ""
var is_name_overridden: bool = false
var ex_gender: String = ""
var is_gender_overridden: bool = false
var ex_traits: Dictionary = {}
var relationship_duration_months: int = 0
var relationship_ended_months_ago: int = 0
var relationship_end_circumstance: String = ""


func set_ex_name(_name: String) -> bool: return false
func set_ex_gender(_gender: String) -> bool: return false
func get_display_name() -> String: return ""
func get_pronouns() -> Dictionary: return {}
func add_trait(_trait_id: String) -> void: pass
func has_trait(_trait_id: String) -> bool: return false
func set_duration(_months: int) -> void: pass
func set_ended(_months_ago: int) -> void: pass
func set_end_circumstance(_text: String) -> void: pass
func is_defined() -> bool: return false
func get_echo_phrase() -> String: return ""
func save_state() -> Dictionary: return {}
func load_state(_data: Dictionary) -> void: pass
func reset_all_for_new_game() -> void: pass
