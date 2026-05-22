# Audit `auditeur-scene` — `diner_arrivee.dtl`

**Date** : 2026-05-22
**Source `.dtl`** : `dialogic/timelines/diner_arrivee.dtl`
**Scene-spec** : `aidd_docs/memory/external/scenes/diner_arrivee.md`
**PNJ-behaviors chargés** : `pnjs-behavior/emma.md` *(les 7 autres encore à spec — vérifs alignées sur `bible-jeu.md`)*
**Score global** : **18.2/20** — 🟡 corrections mineures requises avant prod

---

## Scoring détaillé

| Critère | Score | Poids | Note |
|---------|-------|-------|------|
| Scope jauges | 17/20 | 25% | -3 sur `ev:` dispatcher non canonisé |
| Verrous canon | 18/20 | 25% | Aucune violation détectée ; -2 par prudence sur élargissement réplique Emma Neutre |
| Présence PNJ | 19/20 | 15% | Exception canon respectée (premier dîner = 8 forcés) ; -1 pour rappel implicite que le bloc résolution est absent |
| Événements seuil | 19/20 | 20% | `event_camille_cliffhanger` correctement guardé one-shot ; -1 sur explication conditionnelle implicite |
| Gating + cap | 18/20 | 15% | `acces_requis: public` ✓ ; cap = 2 ✓ ; -2 sur lisibilité du compteur cap (incrément via `[set]`, syntaxe Dialogic 2 à vérifier) |

---

## Audit global

### ✅ Scope jauges
- Jauges activables déclarées par scene-spec : `relation:<8 PNJ>`, `ms`, `pd`, `ev`, `reputation:presse/memorize/stratom`
- Jauges hors-scope déclarées : `mirror`, `surveillance`, `countdown:*`
- **Vérification** : `grep` des signaux émis montre **aucune occurrence** de `miroir:`, `surveillance:`, `countdown:` ✓
- Toutes les jauges touchées sont dans le scope ✓
- ⚠ Voir Risque #1 : `ev:` est dans le scope déclaré, mais le dispatcher canonique correspondant n'est pas documenté

### ✅ Verrous canon (les 8 PNJs)

| PNJ | Verrou clé canon | Respect dans `.dtl` |
|-----|------------------|----------------------|
| Emma | Pas de complicité d'enfance · Fusion-confusion non consommée · Emma a connu Julien (référence non révélée trop tôt) | ✓ Aparté à Allié+ sans révélation Julien |
| Léo | Lassitude esthétique cultivée, sourire bref | ✓ « Design d'interfaces. Memorize. Ce que tu vois quand tu vois rien. » |
| Marine | Sourire crispé, performeuse 80k abonnés, dette cachée | ✓ Présentation ambassadrice + attente réaction |
| Thomas | Ingénieur épuisé, cynisme désarmant, regarde son verre | ✓ « J'ingénie. C'est très palpitant. » |
| Sofia | Jamais posture pro défaillante · Identité trans non plot-point · Vigilance éthique | ✓ Calling out mensonge sans hostilité ; « Pas pour censurer » |
| Alex | Jamais dans le dos de Sofia · Scan biométrique passif | ✓ Regard échangé avec Sofia ; mentionne « scan » publiquement |
| Camille | Dark cogni-affectif jamais physique · Profilage en temps réel | ✓ Range quelque chose, sourire +1/2 mm, cliffhanger anodin |
| Frank | Parle peu, observe long, ex-opératif | ✓ Un mot, 3 secondes de regard |

### ✅ Présence PNJ
- Scene-spec : **cas spécial premier dîner** → 8 PNJs forcés, pas de bloc de résolution requis
- `.dtl` n'a pas de bloc de résolution ✓ (cohérent avec l'exception)
- Sujets supposent les 8 PNJs accessibles → cohérent

### ✅ Événements de seuil
- `event_camille_cliffhanger` :
  - Pose `flag_event_camille_cliffhanger_consomme = true` ✓
  - Pose `flag_camille_cliffhanger_pose = true` ✓ *(flag d'usage avale par scenes A2)*
  - Conditionné par `{if flag_diner_presentation_A or _C or _D}` ✓ (pas si B)
  - Branche `else` pose `flag_camille_attend_meilleure_occasion` → pas de re-déclenchement gratuit ✓

### ✅ Gating + cap
- `acces_requis: public` → pas de gating à valider ✓
- Cap sujets = 2 : implémenté via `{if {diner_sujets_consommes} < 2}` + `{else}` outro forcée ✓
- ⚠ Syntaxe `[set var=... value="{var} + 1"]` à vérifier Dialogic 2 conforme

---

## Risques structurels (3 minimum requis)

### 1. ⚠ Dispatcher `ev:` non documenté dans `api-cheatsheet.md`

**Citation .dtl ligne ~95** :
```
[signal arg="ev:+1:emma_propose_acces"]
```

L'`api-cheatsheet.md` documente : `relation, flag, decision, lieu, surveillance, miroir, reputation, countdown, ms, pd`. **Pas de `ev`**.

La canon utilise pourtant `evidence_collected` comme variable centrale (cf. `variables-register.md`).

**Impact** : `dtl_linter.gd` aurait `FAIL` sur un dispatcher inconnu si `DISPATCHERS_VALIDES` ne contient pas `ev:`. 3 occurrences dans le `.dtl` (sujets `demander_role:emma`, `demander_role:sofia`, `observer_silence`).

**Fix recommandé** : ajouter le dispatcher `ev:<delta>:<raison?>` à `DialogicBridge.DISPATCHERS_VALIDES` + à `api-cheatsheet.md` (le dispatcher manque manifestement dans la doc, l'usage est canon par scope scene-spec).
**Fix alternatif** : remplacer chaque `[signal arg="ev:+N:raison"]` par `[signal arg="flag:flag_ev_increment_<scene>_<sujet>:true"]` + handler GD qui incrémente `evidence_collected` — moins propre, ne respecte pas le scope déclaré.

### 2. ⚠ Condition Emma palier `Favorable` omise

**Citation .dtl ligne ~83** :
```
{if {relation_emma_palier} == "Allié" or {relation_emma_palier} == "Confident" or {relation_emma_palier} == "Proche"}
```

La scene-spec dit *« Emma à Favorable+ »* — `Favorable` est inclus dans ce seuil. Mon `.dtl` saute le palier `Favorable` (et `Fusionnel`).

**Impact** : si Margot arrive au dîner avec `palier:emma = Favorable` (cas plausible avec `flag_emma_guide=true` mais sans alliance pro plus tard), la réplique enrichie d'Emma ne se déclenche pas — la joueuse récupère la version Neutre (fallback du `{else}`), donc cohérence narrative perdue.

**Fix** : ajouter `Favorable` et `Fusionnel` à la liste :
```
{if {relation_emma_palier} == "Favorable" or _palier == "Allié" or _palier == "Proche" or _palier == "Confident" or _palier == "Fusionnel"}
```

### 3. ⚠ Variable `diner_sujets_consommes` non enregistrée

**Citation .dtl ligne ~89, 105, 117, ..., 145** :
```
[set var="diner_sujets_consommes" value="{diner_sujets_consommes} + 1"]
```

Variable utilisée comme compteur de cap mais **non enregistrée dans `variables-register.md`**. Risque : initialisation non garantie au runtime → si Dialogic démarre la variable à `null`, la condition `{diner_sujets_consommes} < 2` peut faire un truthy test imprévisible.

**Fix** : ajouter l'entrée dans `variables-register.md § Variables Dialogic` :
```markdown
| `diner_sujets_consommes` | int | 0 | Compteur de sujets joués pendant `diner_arrivee` (cap = 2). |
```

Et initialiser dans `diner_arrivee.gd._ready()` :
```gdscript
Dialogic.VAR.set("diner_sujets_consommes", 0)
```

---

## Recommandations d'ordre

Avant **`dtl_linter.gd`** (vérification syntaxique réelle) :
1. Trancher `ev:` dispatcher → patch `DialogicBridge` + `api-cheatsheet.md`.

Avant **`review-persona dramaturge`** + qualitatifs :
2. Compléter la condition Emma au sujet `demander_role_emma`.
3. Enregistrer `diner_sujets_consommes` + l'initialiser au `_ready`.

Après les 3 fixes : `auditeur-scene` rejouerait probablement **18.5+/20** et le `.dtl` serait prêt pour la suite du pipeline.

---

## Limites de cet audit

- Audit produit par LLM sans exécution Godot réelle. Le `dtl_linter.gd` produira l'audit syntaxique définitif.
- 7 `pnjs-behavior` manquants (tous sauf Emma) → les verrous canon des 7 autres PNJs vérifiés contre `bible-jeu.md` directement, pas contre un `pnj-behavior` formalisé. Si les pnjs-behavior à spec ajoutent des verrous nouveaux (formulations interdites précises, etc.), un nouveau passage `auditeur-scene` sera requis.
- Cohérence inter-scènes (Emma confidente ici → Méfiance ailleurs ?) hors scope de cet audit ; relève du Dramaturge.
- Lisibilité prose / sous-texte / charge cognitive hors scope ; relève de `margot-joueuse` et `playtester-accessibilite`.
