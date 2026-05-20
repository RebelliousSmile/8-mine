extends "res://tests/helpers/test_environment.gd"

const SLOT_TEST := 2  # On utilise le slot 2 pour ne pas écraser slots utilisateur.


func before_each() -> void:
	super()
	SaveManager.effacer_slot(SLOT_TEST)


func after_each() -> void:
	SaveManager.effacer_slot(SLOT_TEST)


# --- Version format ------------------------------------------------------

func test_version_format_est_2() -> void:
	assert_eq(SaveManager.VERSION_FORMAT, 2,
		"VERSION_FORMAT doit être bumpé à 2 en phase 3")


func test_save_ecrit_version_2() -> void:
	SaveManager.sauvegarder(SLOT_TEST)
	var meta = SaveManager.meta_slot(SLOT_TEST)
	assert_eq(meta.version, 2)


# --- new_game ------------------------------------------------------------

func test_new_game_reset_tous_les_managers() -> void:
	RelationManager.reset_all_for_new_game()
	RelationManager.modifier("sara", 30, "test")
	ExProfileManager.set_ex_name("Naoki")
	SurveillanceManager.increase(50, "test")
	SaveManager.new_game()
	assert_eq(RelationManager.get_valeur("sara"), 0,
		"new_game doit reset relations")
	assert_eq(ExProfileManager.ex_name, "Julien",
		"new_game doit reset profil ex")
	assert_eq(SurveillanceManager.get_level(), 0,
		"new_game doit reset surveillance")


# --- Roundtrip global ----------------------------------------------------

func test_save_load_inclut_tous_les_managers() -> void:
	SaveManager.new_game()
	RelationManager.modifier("sara", 25, "test")
	ExProfileManager.set_ex_name("Naoki")
	SurveillanceManager.increase(40, "test")
	MirrorStatusManager.increase(35, "test")
	ReputationManager.modifier("stratom", -20, "test")
	CountdownManager.tick("audit_marine", 3)

	SaveManager.sauvegarder(SLOT_TEST)
	SaveManager.new_game()  # remet tout à zéro
	SaveManager.charger(SLOT_TEST)

	assert_eq(RelationManager.get_valeur("sara"), 25)
	assert_eq(ExProfileManager.ex_name, "Naoki")
	assert_eq(SurveillanceManager.get_level(), 40)
	assert_eq(MirrorStatusManager.get_status(), 35)
	assert_eq(ReputationManager.get_valeur("stratom"), -20)
	assert_eq(CountdownManager.get_current("audit_marine"), 3)


# --- Migration v1 → v2 ---------------------------------------------------

func test_migrer_v1_garnit_cles_manquantes() -> void:
	var v1 = {
		"version": 1,
		"relations": { "valeurs": { "sara": 10 } },
		"flags": {},
		"lieu": "chambre",
	}
	var v2 = SaveManager.migrer_v1_vers_v2(v1)
	assert_eq(v2.version, 2)
	assert_true(v2.has("countdowns"))
	assert_true(v2.has("surveillance"))
	assert_true(v2.has("mirror"))
	assert_true(v2.has("reputation"))
	assert_true(v2.has("ex_profile"))


func test_charger_v1_silencieux() -> void:
	# Écrit un fichier v1 brut puis charge
	var chemin = "user://saves/save_%d.json" % SLOT_TEST
	DirAccess.make_dir_recursive_absolute("user://saves/")
	var f = FileAccess.open(chemin, FileAccess.WRITE)
	f.store_string(JSON.stringify({
		"version": 1,
		"timestamp": 1700000000,
		"relations": { "valeurs": { "sara": 12 } },
		"flags": {},
		"lieu": "chambre",
	}))
	f.close()

	SaveManager.new_game()
	var data = SaveManager.charger(SLOT_TEST)
	assert_true(data.has("ex_profile"),
		"chargement v1 doit ajouter ex_profile par défaut")
	# La valeur sara doit être restaurée
	assert_eq(RelationManager.get_valeur("sara"), 12)
