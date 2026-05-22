# Workflow de production canon — 8-MINE

> Documentation du **workflow effectivement utilisé** par l'agent narrative pour produire le canon 8-MINE *(catalogue scenes + catalogue PNJ + .dtl + audits)*.
>
> Référence pour : tout contributeur·rice narrative *(humain ou agent LLM)*. Statut : descriptif → tendance prescriptif au fil de la stabilisation.

---

## Vue d'ensemble

```
┌────────────────────────────────┐
│  SOURCES CANON                 │  bible-jeu.md, history.md, overview.md,
│                                │  internal/design-rules/, variables-register.md
└────────────┬───────────────────┘
             │ (lecture en read-only ; pas de modification sauf trancheage explicite)
             ▼
┌────────────────────────────────┐
│  ARTEFACT À PRODUIRE           │  scene-spec / pnj-behavior / .dtl / audit / index
└────────────┬───────────────────┘
             │ (suivre le prompt approprié — scene-spec, pnj-behavior, write-scene, etc.)
             ▼
┌────────────────────────────────┐
│  CROISEMENT INTER-ARTEFACTS    │  cohérence couple, hooks scenes, événements cross-PNJ,
│                                │  variables, flags, verrous
└────────────┬───────────────────┘
             ▼
┌────────────────────────────────┐
│  AUTO-AUDIT                    │  validation rétroactive contre .dtl existants,
│                                │  vérification verrous canon, signaler risques
└────────────┬───────────────────┘
             ▼
┌────────────────────────────────┐
│  MAJ ANNEXES                   │  index (scenes/_index.md, pnjs-behavior/_index.md),
│                                │  todos overview, variables-register
└────────────┬───────────────────┘
             ▼
┌────────────────────────────────┐
│  COMMIT + PUSH                 │  message structuré : type d'artefact / verrous / coord
│                                │  / validation rétroactive / mises à jour annexes
└────────────────────────────────┘
```

---

## Workflow par type d'artefact

### Workflow A — Production d'une `scene-spec`

**Quand** : nouvelle scène-type à produire *(récurrente ou one-shot multi-PNJ)*.

**Étapes** :

1. **Lecture canon ciblée** :
   - `overview.md § Architecture narrative` + § scene-spec si déjà décrite
   - `bible-jeu.md` pour les PNJs susceptibles d'être présents
   - `history.md` pour la canon de la scène-type *(si héritée d'un NODE legacy)*
   - `internal/variables-register.md` pour les jauges et flags disponibles
   - `scenes/_index.md` pour les scenes existantes *(éviter duplications, identifier les dépendances)*

2. **Identification des `pnj-behavior` à consommer** :
   - Lister les PNJs candidats à la présence dans la scène
   - Vérifier que leurs fiches `pnjs-behavior/<pnj>.md` existent
   - Si fiche manquante : **STOP** ou marquer dépendance comme risque structurel

3. **Application du template** `aidd_docs/memory/internal/templates/scene-spec.md` :
   - Métadonnées (YAML)
   - **Scope jauges déclaratif** *(verrou : aucun sujet ne pourra toucher hors-scope)*
   - **Variables PNJ** *(résolution de présence runtime — pool de candidats, règles, variantes absentes)*
   - Trigger d'apparition
   - Dialogues d'ambiance *(intro/outro)*
   - **Sujets disponibles** *(libellé court, condition apparition, cible, effets, table de réponses par palier)*
   - Événements de seuil susceptibles de s'y jouer
   - Conditions de sortie
   - **Risques structurels** *(≥ 3)*
   - **Validation locale** *(checklist)*

4. **Cohérence cross-fiches** :
   - Vérifier que les paliers cités existent dans les `pnj-behavior` correspondants
   - Vérifier que les événements de seuil référencés correspondent à ceux déclarés dans les pnj-behavior
   - Vérifier le gating `acces_requis` cohérent avec la nature du lieu

5. **Validation rétroactive** *(si scene reformule un NODE legacy)* :
   - Lire le NODE legacy
   - Vérifier que tous les choix canon ont leur équivalent dans la scene-spec
   - Documenter les divergences explicites

6. **Mise à jour annexes** :
   - `scenes/_index.md` (ajouter la scene au catalogue par acte / par lieu)
   - `overview.md § Production todos` (marquer ✅)

7. **Commit + push** *(message structuré, cf. § Conventions de commit)*

---

### Workflow B — Production d'une `pnj-behavior`

**Quand** : nouveau PNJ à formaliser *(parmi les 17 canon)*.

**Étapes** :

1. **Lecture canon ciblée** :
   - `bible-jeu.md § <PNJ>` fiche complète
   - `overview.md § Cast` ligne PNJ + verrous canon listés
   - `internal/design-rules/` si design-rule spécifique au PNJ existe *(ex. `sofia-kessler-caracterisation.md`)*
   - `history.md` grep du nom PNJ — extraire toutes mentions canon (FLAG_*, FIN-E, NODE A2-04X, etc.)
   - Arc-spec archivé `_archive/A2-romance-<pnj>.md` si existe *(recyclage des éléments compatibles)*

2. **Lecture des fiches PNJ déjà livrées** *(pour cohérence cross-PNJ)* :
   - Vérifier comment ce PNJ est mentionné dans les autres `pnjs-behavior/<autre>.md § Coordination cross-PNJ`
   - Identifier les attentes mécaniques *(flags posés, événements référencés)*

3. **Application du template** `aidd_docs/memory/internal/templates/pnj-behavior.md` :
   - Métadonnées (YAML)
   - **Verrous canon (sacrés)** — au minimum 5, idéalement 7+, alignés avec sources
   - **Voix par palier** — 9 paliers couverts (Ennemi juré → Fusionnel), marquer explicitement inaccessibles avec justification canon
   - **Événements de seuil** — au moins 1 par palier significatif (Confident notamment)
   - Hooks scènes
   - Seuils d'accès aux espaces privés
   - **Risques structurels** *(≥ 3)*
   - **Validation locale** *(checklist)*

4. **Coordination cross-PNJ explicite** *(section dédiée en fin de fiche)* :
   - Citer chaque autre PNJ avec qui ce PNJ interagit canonniquement
   - Documenter les flags partagés *(qui pose, qui lit)*
   - Documenter les contraintes couple si applicable

5. **Validation rétroactive sur `.dtl` existants** :
   - Pour chaque `.dtl` où ce PNJ apparaît *(notamment `diner_arrivee.dtl`)*, vérifier que les répliques respectent les verrous canon de la fiche
   - Documenter dans la fiche elle-même *(section « Validation <PNJ> dans <scene>.dtl »)*

6. **Mise à jour annexes** :
   - `pnjs-behavior/_index.md` *(synoptique + matrice cross-PNJ + glossaire)*
   - `scenes/_index.md` *(ajouter événements de seuil de ce PNJ au catalogue events)*
   - `overview.md § Production todos`
   - `variables-register.md` *(à compléter au fil des fiches — P0 todo persistant)*

7. **Commit + push**

---

### Workflow C — Production d'un `.dtl` via `write-scene`

**Quand** : un `.dtl` est requis à partir d'une scene-spec stabilisée.

**Étapes** *(suit le prompt `write-scene.prompt.md`)* :

1. **Charger la scene-spec** + valider sections requises
2. **Charger les pnj-behaviors** de tous les PNJs candidats *(STOP si fiche manquante)*
3. **Charger l'output-style** *(scenario par défaut)*
4. **Structurer la timeline** avec :
   - Bloc de résolution PNJ runtime *(sauf exception canon documentée — ex. premier dîner force 8 PNJ présents)*
   - Vérification événements de seuil bufferés à injecter
   - Intro ambiance
   - Sujets filtrés par présence + paliers + flags
   - Outro variants
5. **Brancher les signaux** *(respect strict du scope jauges déclaré par scene-spec)*
6. **Conditions de palier** *(format `{if {relation_<pnj>_palier} == "..."}`)*
7. **Cap sortie**
8. **Stub `.tscn`** *(markdown, pas binaire)*
9. **Validation locale** *(auto-checklist)*
10. **Linter** *(dtl_linter.gd — PASS obligatoire)*

**Note importante** : si un dispatcher utilisé dans le `.dtl` n'est pas dans `DISPATCHERS_VALIDES` *(linter)* ou dans `DialogicBridge`, **patcher d'abord le code GDScript** avant de tester le `.dtl`. Cf. fix `ev:` dispatcher 2026-05-22 (commit `90e0a6e`).

---

### Workflow D — Audit `auditeur-scene` sur un `.dtl`

**Quand** : un `.dtl` vient d'être produit ou modifié.

**Étapes** *(suit le prompt `review-persona.prompt.md` avec persona `auditeur-scene`)* :

1. **Précondition** : `dtl_linter.gd` PASS *(sinon STOP, retour `write-scene --feedback`)*
2. **Charger scene-spec source** + pnj-behaviors candidats
3. **Vérifier 5 critères** *(scoring /20)* :
   - **Scope jauges respecté** (aucune émission hors scope déclaré)
   - **Verrous canon tenus** (grep des verrous interdits dans les répliques)
   - **Présence PNJ runtime** (bloc résolution présent, sujets filtrés)
   - **Événements de seuil one-shot** (`_consomme` posé, contexte respecté)
   - **Gating + cap sortie** (`acces_requis`, cap sujets)
4. **Documenter findings** *(citations exactes, scoring, triage 🟢/🟡/🔴)*
5. **Si 🟡 ou 🔴** : produire liste de fixes pour `write-scene --feedback`
6. **Écrire le rapport** dans `aidd_docs/aiw/8mine/audit-<date>-<scene>.md`

---

### Workflow E — Upgrade d'un catalogue *(meta-workflow structurel)*

**Quand** : un catalogue *(scenes, pnj-behavior, prompts)* contient ≥ 5 artefacts et mérite une revue de cohérence globale.

**Étapes** *(suit `upgrade.prompt.md` adapté à un catalogue)* :

1. **Évaluer le catalogue comme ensemble** *(forces + faiblesses)* — pas chaque fiche individuellement
2. **Noter /20 avec justification argumentaire**
3. **Lister numérotées les suggestions** pour atteindre 20/20
4. **Appliquer les suggestions structurantes** *(les plus utiles pour la maintenance — typiquement créer un `_index.md`, normaliser typographie, glossaire)*
5. **Documenter dans le commit** quelles suggestions ont été appliquées et lesquelles restent ouvertes

**Exemple récent** *(2026-05-22)* : upgrade catalogue PNJ → création `pnjs-behavior/_index.md` avec synoptique, matrice cross-PNJ, glossaire, anti-patterns consolidés. Score initial 17/20 → post-upgrade ~18.5/20.

**Différence avec workflow F (`persona-trainer`)** : upgrade est *structurel/cosmétique* à un instant T *(forme, redondance, index)*. Persona-trainer est *data-driven* — il améliore l'efficacité d'un persona basé sur les *issues qu'il a manquées* dans des reviews précédentes. Les deux sont complémentaires : upgrade pour la forme, persona-trainer pour la pertinence.

---

### Workflow F — Amélioration data-driven d'un persona *(persona-trainer · AUTO-DÉCLENCHÉ)*

**Quand** : déclenché **automatiquement** par `review-persona.prompt.md` Step 8 si une des 4 conditions est vraie *(cf. section ci-dessous)*. Plus besoin d'invocation manuelle — le persona-trainer est chaîné depuis la review.

**Conditions de déclenchement automatique** *(review-persona.prompt.md v1.5 Step 8)* :
1. **Concordance étroite ET indulgente** : 4 personas convergent à ±1 point + score moyen ≥ 17/20
2. **Plafond non enclenché malgré score ≥ 17** : aucune faiblesse 🟠+ trouvée ET recherche active non explicitement déclarée
3. **Pattern de findings systématiquement manqués** *(rétroactif sur historique utilisateur)*
4. **Recherche active non déclarée** : « moins de 3 faiblesses » sans démonstration d'exhaustivité

Cf. également `aidd_docs/aiw/8mine/auto-triggers-demonstration-*.md` pour exemples concrets historisés.

**Étapes** *(suit `persona-trainer.prompt.md` workshop AIW)* :

1. **Collecter le feedback** sur le persona à améliorer *(retours utilisateur, issues missed dans des reviews antérieures)*
2. **Identifier les patterns récurrents** dans ce que le persona manque systématiquement
3. **Renforcer ses `expectations`** dans le YAML *(must-haves, deal-breakers, Craft Checklist items)*
4. **Tester la version améliorée** sur un cas connu *(régression check : ne perd-elle pas une force ?)*
5. **Bump la version** du YAML *(v1.0 → v1.1, etc.)* + documenter les modifications dans le YAML *(commentaire `# persona-trainer 2026-XX-XX : ajout ...`)*

**À utiliser quand** :
- Un `playtester-lgbtqia` n'a pas détecté un trope subtil → auto-trigger condition #3
- Un `dramaturge` n'a pas vu une violation de scope jauges → auto-trigger condition #1 ou #4
- Un `playtester-visual-novel` a noté 18/20 un dialogue exposé → auto-trigger condition #2
- Etc.

**Première démonstration** *(2026-05-22)* — auto-trigger #1 détecté rétroactivement sur review v1 *(scores 17.75 ± 0.7)*, confirmant le signal utilisateur « scores trop bons pour un premier passage ». Cf. `aidd_docs/aiw/8mine/auto-triggers-demonstration-2026-05-22.md`.

---

### Workflow G — Amélioration data-driven d'un output-style *(tone-finder · AUTO-DÉCLENCHÉ)*

**Quand** : déclenché **automatiquement** par `write-scene.prompt.md` Step 12 *(post-linter PASS)* OU par `review-persona.prompt.md` Step 9 *(post-review)* si une des 4 conditions est vraie.

**Conditions de déclenchement automatique** :
1. **Output-style atteint son 3ème `.dtl` produit** *(seuil échantillon statistique)*
2. **Reviewer flag linguistique** : `voix uniforme`, `prose redondante`, `rythme uniforme`, `sur-utilisation de X`, `sous-utilisation de Y`
3. **Output-style non revu depuis > 5 `.dtl`** produits
4. **Pattern lexical détecté automatiquement** : grep mécanique *(narrator italique > 70%, répétitions tournures > 3, variabilité longueur σ < 15)*

**Différence avec workflow F (persona-trainer)** : workflow F corrige *la performance d'un reviewer* *(quelles issues il rate)*. Workflow G corrige *la prose elle-même* *(le style narratif appliqué dans les `.dtl`)*.

**Pas encore déclenché** *(2026-05-22)* — seuil échantillon `scenario.md` à 1 `.dtl` produit *(diner_arrivee)*. Trigger #1 attendu au 3ème `.dtl` produit. Trigger #2 possible si reviewer flag linguistique au prochain passage.

---

**Différence avec workflow E (upgrade)** : workflow E corrige *la forme* du catalogue *(redondances, indexes, glossaire, normalisation)*. Workflow F corrige *la performance* d'un persona *(quelles issues il rate, quelles checklist items renforcer)*.

---

## Conventions de commit

### Format de message canonique

```
<type artefact> : <description courte> (<position dans catalogue si applicable>)

<paragraphe d'intro contextuelle>

<bloc de détails structurés> :
- <point clé 1>
- <point clé 2>
...

<section verrous canon si applicable>

<section coordination cross-* si applicable>

<section validation rétroactive si applicable>

<section mises à jour annexes>
```

### Exemples canon

#### Pour une `pnj-behavior` :
```
pnj-behavior:<pnj> — <épithète canon> (POC <N>/8)

<résumé canon en 2-3 lignes>

Verrous canon (<N>) :
- <verrou 1>
- ...

Voix par palier (9 paliers, <X> inaccessibles avec justification).

Événements de seuil (<N>) :
1. <event 1>
2. ...

Seuils accès :
- <espace> : <palier>

Sensitivity reader : <reviewers>

Validation rétroactive .dtl <scene> : <verdict>

Mises à jour annexes :
- scenes/_index.md : <N> nouveaux events ajoutés
- overview todos : pnj-behavior:<pnj> ✅ livré
```

#### Pour un fix canon :
```
fixes audit POC <scene> : <fix 1> · <fix 2> · <fix 3>

<N> fixes appliqués suite à audit auditeur-scene initial (<score>/20 → <score>/20 🟢).

Fix 1 — <description> (<N> fichiers modifiés)
- <fichier 1> : <modification>
- ...

Fix 2 — ...

Rapport audit mis à jour :
- <fichier rapport> : <changement>
```

#### Pour un upgrade catalogue :
```
upgrade catalogue <type> : <résumé livraison> + <changement structurel>

Suite à upgrade.prompt.md sur catalogue <type> (<N>/<M> livrés), <action>.
Suggestions appliquées #<X>, #<Y>, #<Z>.

<artefact créé> :
- <section 1>
- ...

Note évaluative upgrade : <score>/20 — <justification 1 ligne>.
Reste à faire : <todos>.
```

---

## Principes de production canon

### Source primary > derived

L'ordre de priorité canon est :
1. `bible-jeu.md` *(canon le plus stable)*
2. `internal/design-rules/<pnj>-*.md` *(règles spécifiques, sacrées)*
3. `history.md` *(arborescence des scenes, FIN-E, threads tranchés)*
4. `overview.md` *(synthèse — peut être déprécié par bible-jeu si conflit)*
5. Arc-specs archivés `_archive/` *(matériel recyclable mais déprécié)*

Si conflit : **bible-jeu et design-rules priment**. Toute déviation doit être tranchée explicitement *(commit dédié, mention `trancheage <date>`)*.

### Verrous canon = sacrés

Un verrou canon listé dans une fiche `pnj-behavior` est **non-négociable**. Toute réplique, choix, événement qui le violerait :
- est refusé en review-persona auditeur-scene
- doit être corrigé via `write-scene --feedback`
- si le verrou lui-même est erroné, c'est la fiche `pnj-behavior` qui doit être corrigée *(commit dédié explicite)*

### Coordination cross-fiches obligatoire

Toute fiche `pnj-behavior` ou `scene-spec` qui référence un autre artefact *(autre PNJ, autre scene, événement seuil)* doit :
- Vérifier l'existence de l'artefact cible
- Documenter la coordination dans la section dédiée *(« Coordination cross-PNJ », « Hooks scènes », etc.)*
- Signaler en risque structurel si l'artefact cible n'existe pas encore

### Validation rétroactive systématique

Toute nouvelle fiche `pnj-behavior` doit valider rétroactivement les `.dtl` existants où le PNJ apparaît. Section *« Validation <PNJ> dans <scene>.dtl »* obligatoire en fin de fiche.

### Patcher le code avant le canon si nécessaire

Si une fiche / scene-spec / .dtl utilise un dispatcher, une jauge, ou une variable Dialogic qui n'existe pas dans le code Godot, **patcher d'abord le code** :
- `DialogicBridge.gd` *(ajouter le case + le handler)*
- `dtl_linter.gd` *(ajouter au registre validé)*
- `api-cheatsheet.md` *(documenter)*
- `variables-register.md` *(enregistrer)*

Cf. exemple `ev:` dispatcher fix 2026-05-22 (commit `90e0a6e`).

---

## Anti-patterns de workflow *(à éviter)*

| Anti-pattern | Symptôme | Fix |
|--------------|----------|-----|
| Production `.dtl` sans scene-spec stabilisée | Le `.dtl` invente des verrous ou des jauges hors-canon | Revenir à scene-spec, stabiliser, ensuite write-scene |
| Production `pnj-behavior` sans grep history.md | Manque les FIN-E, FLAGS canon, NODE A2-04X | grep <PNJ> systématique avant écriture |
| Coordination cross-PNJ implicite | « On verra plus tard » au lieu de documenter | Section *Coordination* obligatoire en fin de fiche |
| Validation rétroactive oubliée | Les `.dtl` existants peuvent contredire la nouvelle fiche silencieusement | Section *Validation* obligatoire |
| Commit message vague | Difficile à recuperer en archéologie | Suivre format canonique ci-dessus |
| Patcher canon sans patcher code | Linter FAIL au prochain run Godot | Toujours code-first si dispatcher / jauge / variable nouvelle |
| Upgrade pour le sport | Improvements cosmétiques sans valeur ajoutée pour maintenance | Upgrade seulement si > 5 artefacts dans le catalogue |

---

## Outils utilisés *(ordre d'invocation typique)*

| Outil | Quand | Output |
|-------|-------|--------|
| `Read` / `grep` *(via Bash)* | Lecture canon ciblée | Contenu lu |
| `Write` | Création artefact *(fiche, .dtl, audit)* | Fichier neuf |
| `Edit` *(replace_all=false par défaut)* | Patch ciblé sur fichier existant | Fichier modifié |
| `Bash` *(commit + push)* | Persistance | Commit + remote sync |
| Prompts *(scene-spec, pnj-behavior, write-scene, review-persona)* | Pas invocables ici, **logique appliquée mentalement** | — |

---

## État du workflow au 2026-05-22

- ✅ **Refonte modèle 3 couches** complète *(scenes × sujets × seuils)* — overview v5
- ✅ **Templates** : scene-spec, pnj-behavior livrés
- ✅ **Prompts** : scene-spec, pnj-behavior, write-scene livrés
- ✅ **Catalogue scenes** : 2 POC scene-specs + 2 NODE-specs PRO conservés
- ✅ **Catalogue PNJ** : 8/8 résidents formalisés
- ✅ **POC `.dtl`** bout-en-bout : `diner_arrivee.dtl` produit, audité, fixé (19.4/20 🟢)
- ✅ **Index** : `scenes/_index.md` + `pnjs-behavior/_index.md`
- ✅ **Pipeline export Godot** documenté
- ✅ **Workflow de production** documenté *(ce fichier)*

### Reste P0

- Enregistrement de ~25 variables Dialogic dans `variables-register.md` *(upgrade #2 catalogue PNJ)*
- Intégration des anti-patterns consolidés dans `overview.md § Anti-patterns d'écriture` *(upgrade #7)*
- Trancher critique généalogique Emma *(canon)*
- review-persona dramaturge + lgbtqia sur catalogue PNJ
- POC `write-scene cellule_nuit` *(2ème scene-spec, contexte récurrent)*

---

*Document maintenu manuellement. Mises à jour à chaque évolution majeure du workflow.*
