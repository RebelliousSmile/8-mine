# Audit `auditeur-scene` — `diner_arrivee.dtl`

**Date** : 2026-05-22
**Source `.dtl`** : `dialogic/timelines/diner_arrivee.dtl`
**Scene-spec** : `aidd_docs/memory/external/scenes/diner_arrivee.md`
**PNJ-behaviors chargés** : `pnjs-behavior/emma.md` *(les 7 autres encore à spec — vérifs alignées sur `bible-jeu.md`)*

## Évolution du score

| Passe | Score global | Triage | Fixes appliqués |
|-------|--------------|--------|-----------------|
| Initiale (2026-05-22 matin) | **18.2/20** | 🟡 | — |
| Post-fix (2026-05-22 soir) | **19.4/20** | 🟢 | 3 fixes : dispatcher `ev:`, palier Emma, variable enregistrée |

---

## Scoring détaillé (post-fix)

| Critère | Score | Poids | Note |
|---------|-------|-------|------|
| Scope jauges | 20/20 | 25% | ✅ `ev:` désormais canon (DialogicBridge + dtl_linter + api-cheatsheet) |
| Verrous canon | 18/20 | 25% | Aucune violation ; -2 prudence sur élargissement réplique Emma Neutre *(décision à valider en review Dramaturge)* |
| Présence PNJ | 19/20 | 15% | Exception canon respectée ; -1 pour rappel implicite que le bloc résolution est absent |
| Événements seuil | 19/20 | 20% | `event_camille_cliffhanger` one-shot bien guardé |
| Gating + cap | 20/20 | 15% | ✅ Cap implémenté + variable enregistrée + init explicite en début de timeline |

---

## Audit global (post-fix)

### ✅ Scope jauges *(passe 20/20)*
- Toutes jauges touchées sont dans le scope déclaré.
- Hors-scope respecté : aucune émission de `miroir:`, `surveillance:`, `countdown:` dans le `.dtl`.
- ✅ **`ev:` désormais reconnu** :
  - Ajouté à `DialogicBridge.DISPATCHERS` (match case + `_traiter_ev()` qui modifie `evidence_collected`)
  - Ajouté à `dtl_linter.gd::DISPATCHERS_VALIDES`
  - Documenté dans `api-cheatsheet.md` (syntaxe + exemple + note de clamping)

### ✅ Verrous canon
- Les 8 PNJs respectent leurs verrous (cf. audit initial pour le détail PNJ par PNJ).
- ⚠ Note conservée : Emma à Neutre dans `demander_role_emma` étend le résumé scene-spec. Acceptable comme expansion de voix, à valider en `review-persona dramaturge`.

### ✅ Présence PNJ
- Exception canon premier dîner respectée (8 PNJs forcés).
- Sujets supposent les 8 PNJs accessibles — cohérent avec la scene-spec.

### ✅ Événements seuil
- `event_camille_cliffhanger` correctement guardé :
  - Pose `flag_event_camille_cliffhanger_consomme = true` + `flag_camille_cliffhanger_pose = true`
  - Branche `else` documente *« Camille attend une meilleure occasion »* → pas de re-déclenchement gratuit

### ✅ Gating + cap *(passe 20/20)*
- `acces_requis: public` → pas de gating à valider.
- ✅ **Compteur cap proprement enregistré** :
  - Variable `diner_sujets_consommes` ajoutée à `variables-register.md § Variables de scènes (compteurs locaux)`
  - Initialisation `[set var="diner_sujets_consommes" value="0"]` en début de timeline
  - Stub `.tscn.stub.md` mis à jour (note résolue)

---

## Fixes appliqués (changelog)

### Fix 1 — Canonisation du dispatcher `ev:`

**Avant** : 3 occurrences de `[signal arg="ev:+1:..."]` dans le `.dtl`, dispatcher absent de DialogicBridge / dtl_linter / api-cheatsheet → linter aurait FAIL.

**Modifications** :
1. `scripts/managers/DialogicBridge.gd` — ajout du case `"ev"` dans le match dispatcher (ligne ~121) + nouvelle fonction `_traiter_ev(morceaux)` qui modifie `GameStateManager.evidence_collected` (clampé ≥ 0 par le setter existant). Pattern strictement identique à `_traiter_ms` / `_traiter_pd`.
2. `scripts/tools/dtl_linter.gd` — ajout de `"ev"` à `DISPATCHERS_VALIDES`.
3. `aidd_docs/memory/internal/api-cheatsheet.md` — ligne `[signal arg="ev:<delta>:<raison?>"]` ajoutée à la liste des dispatchers, exemple concret ajouté, note de clamping ajoutée.

**Vérification** : `grep -oE '\[signal arg="[a-z_]+:'` retourne désormais 3 utilisations de `ev:` valides.

### Fix 2 — Condition Emma palier Favorable+

**Avant** :
```
{if {relation_emma_palier} == "Allié" or {relation_emma_palier} == "Confident" or {relation_emma_palier} == "Proche"}
```
Manque `Favorable` et `Fusionnel` — scene-spec dit *« Favorable+ »*.

**Après** :
```
{if {relation_emma_palier} == "Favorable" or {relation_emma_palier} == "Allié" or {relation_emma_palier} == "Proche" or {relation_emma_palier} == "Confident" or {relation_emma_palier} == "Fusionnel"}
```

Couvre tous les paliers ≥ Favorable.

### Fix 3 — Variable `diner_sujets_consommes` enregistrée + init

**Avant** : variable utilisée comme compteur sans déclaration canon ni init explicite.

**Modifications** :
1. `aidd_docs/memory/internal/variables-register.md` — nouvelle section *« Variables de scènes (compteurs locaux) »* ajoutée. Entrée :
   ```
   | `diner_sujets_consommes` | int | 0 | `diner_arrivee` | Compteur cap = 2 |
   ```
2. `dialogic/timelines/diner_arrivee.dtl` — ligne `[set var="diner_sujets_consommes" value="0"]` ajoutée après `[signal arg="bg:..."]` en tête de scène, avant tout `[choice]`.
3. `diner_arrivee.tscn.stub.md` — note de todo résolue, marquée ✅.

---

## Risques résiduels (post-fix)

### 🟡 `bg:` dispatcher également absent de DISPATCHERS_VALIDES *(pré-existant)*

**Citation `.dtl` ligne 17** :
```
[signal arg="bg:bg_zone_commune_soir"]
```

Le dispatcher `bg:` est utilisé 4× dans `pro_arrivee.dtl` *(scène déjà implémentée et jouée en playtest)*, mais n'est **pas** dans `DialogicBridge.DISPATCHERS` ni `dtl_linter.gd::DISPATCHERS_VALIDES`. Sa résolution est manifestement gérée ailleurs *(LocationManager ? script de scène ?)* OU silencieusement ignorée comme warning.

**Non lié à mon POC** — c'est un constat pré-existant qui sort de scope `auditeur-scene` pour `diner_arrivee.dtl` mais qui mériterait un ticket séparé. La 5ème utilisation de `bg:` dans `diner_arrivee.dtl` (ligne 17) hérite simplement de ce comportement.

**Recommandation séparée** : trancher si `bg:` doit être canonisé (et ajouté à DISPATCHERS / linter) ou s'il faut migrer les usages vers une autre commande Dialogic (`[bg key="..."]` par exemple).

### 🟡 Emma à Neutre — élargissement de réplique vs résumé scene-spec

**Citation `.dtl` ligne 138** :
```
emma: Analyste flux Memorize. Je passe mes journées dans des dashboards qui ressemblent à des fonds marins.
```

Scene-spec : *« Analyste flux Memorize. — réponse courte, formelle »*. Mon `.dtl` élargit avec l'image *« dashboards qui ressemblent à des fonds marins »*.

Voix Emma cohérente *(post-rupture, sensible, image visuelle)*. Mais c'est une **divergence interprétée** vs **résumé scene-spec**.

**Verdict** : à valider en `review-persona dramaturge` (cohérence) + `review-persona margot-joueuse` (qualité prose). `auditeur-scene` ne tranche pas — ce n'est pas une violation mécanique.

---

## Recommandations d'ordre (post-fix)

✅ Les 3 risques bloquants/structurels initiaux sont résolus.

Prochaines étapes :
1. **Tester `dtl_linter.gd` réel** sur `diner_arrivee.dtl` dans Godot headless (devrait passer PASS, possible WARN sur `bg:` pré-existant qui n'est pas un nouveau problème).
2. **`review-persona dramaturge`** sur le `.dtl` corrigé.
3. **`review-persona margot-joueuse`** sur le `.dtl` corrigé.
4. **`review-persona playtester-lgbtqia`** *(sensitivity)* — particulièrement la scène où Sofia *« calle out »* le mensonge `[C]`.
5. Spec `pnj-behavior:camille` *(urgent — la cliffhanger Camille est dans le `.dtl`, les verrous canon vérifiés contre bible-jeu uniquement)*.

---

## Limites de cet audit (rappel)

- Audit produit par LLM sans exécution Godot réelle. `dtl_linter.gd` produira l'audit syntaxique définitif.
- 7 `pnjs-behavior` manquants (tous sauf Emma) → verrous canon vérifiés contre `bible-jeu.md` directement.
- Cohérence inter-scènes hors scope `auditeur-scene` ; relève du Dramaturge.
- Lisibilité prose hors scope ; relève de `margot-joueuse` et `playtester-accessibilite`.
