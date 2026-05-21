---
name: node-manage
description: Gestion du cycle de vie des nodes 8-MINE — list, status, update, retire.
argument-hint: --list | --status <NN> | --update <NN> --feedback "<texte>" | --retire <NN>
version: 1.0
---

# Node Manage — Cycle de vie des nodes

## Goal

Centraliser les opérations transverses sur les nodes :

- **Listing** : table de bord (qui existe, qui est écrit, qui est reviewé, quel triage)
- **Status d'un node** : détail (spec, .dtl, review, linter, transitions sortantes)
- **Update d'un node-spec** : régénération partielle après feedback de review (Stage 5 → Stage 3 sans repartir d'`02-decompose-arc`)
- **Retire** : sortir un node du jeu actif (archivage)

**À ne pas confondre avec** :
- `02-decompose-arc` qui **crée** la liste initiale de nodes depuis un arc-spec
- `03-write-dtl` qui **écrit** le `.dtl` à partir d'un node-spec
- `04-review-persona` qui **score** un `.dtl` écrit

Ce prompt **ne génère pas** de propositions (pas de profusion) ; il **gère** ce qui existe. Pour de la divergence/contradiction, voir les prompts de proposition (workshop).

## Context

**Specs de nodes :**
```
@aidd_docs/memory/external/nodes/
```

**Timelines écrites :**
```
@dialogic/timelines/
```

**Reviews (si présentes) :**
```
@aidd_docs/aiw/8mine/reviews/
```

**Arc-specs (pour rattachement) :**
```
@aidd_docs/memory/external/arcs/
```

**Source de vérité linter :**
```
@scripts/tools/dtl_linter.gd
```

## Conventions de nommage

- **Node-spec** : `aidd_docs/memory/external/nodes/<NN>.md` (2 chiffres). H1 = `# NODE [<arc>-<NN>] — <titre>`. Ligne 2 commence par `` `<dtl_filename>` · … ``.
- **Timeline** : `dialogic/timelines/<arc_lowercase>_<topic>.dtl` (ex : `pro_cellule.dtl` pour PRO-02).
- **Review** : `aidd_docs/aiw/8mine/reviews/<dtl_basename>-review.md` ou `review-report-<arc>-<NN>.md`.

Si la convention est cassée pour un node (fichier orphelin, H1 absent), le signaler dans le rapport — ne pas inventer un mapping.

## Process

### Action `--list` (par défaut si aucun argument)

Scanner `nodes/`, croiser avec `timelines/` et `reviews/`, produire :

```markdown
# Nodes 8-MINE — État au <YYYY-MM-DD>

| NN | Arc | Titre | Spec | .dtl | Linter | Review | Triage |
|----|-----|-------|------|------|--------|--------|--------|
| 01 | PRO | Prologue | ✅ | ✅ | ? | — | — |
| 02 | PRO | La Cellule | ✅ | ✅ | ? | ✅ | 🔴 |
| 03 | A1  | … | ✅ | ❌ | — | — | — |

- ✅ = présent · ❌ = manquant · ? = à vérifier (lancer le linter) · — = non applicable
- Triage : dernier verdict review consolidé (🟢 patchable · 🟡 structurel · 🔴 systémique)

## Synthèse
- Specs : X · .dtl : Y · Reviews : Z
- 🔴 bloquants : <liste NN>
- Specs orphelines (sans .dtl) : <liste NN>
- .dtl orphelins (sans spec) : <liste filename>
```

### Action `--status <NN>`

Détail exhaustif d'un node. Format :

```markdown
# NODE <NN> — <titre>

**Arc** : <arc> · **Timeline** : `<dtl>` · **Scène** : `<tscn si déclarée>`

## Spec
- Fichier : <chemin>
- Variables entrée : <liste extraite de "Variables à l'entrée">
- Variables sortie : <liste extraite de "Flags activés">
- Choix : [A] <libellé> · [B] … · [C] … · [D] …
- Transitions : → <node suivant ou fin>

## .dtl
- Fichier : <chemin>
- Lignes : <n>
- Choix détectés : <n>
- Signaux émis : <liste types : relation/flag/decision/ms/pd/...>

## Linter
- Dernière passe : <statut si journalisé, sinon "à exécuter">
- Warnings prévisibles : <croisement avec PNJ_VALIDES, FACTIONS_VALIDES, DISPATCHERS_VALIDES>

## Review
- Personas passés : <liste>
- Verdict global : 🟢/🟡/🔴
- Faiblesses ouvertes : <liste extraite des reviews>

## Dépendances entrantes
- Flags attendus posés par : <liste nodes amont>

## Dépendances sortantes
- Flags posés consommés par : <liste nodes aval>
```

Si une donnée n'est pas trouvable (review absente, .dtl absent), afficher `—` plutôt qu'inventer.

### Action `--update <NN> --feedback "<texte>"`

Mettre à jour le node-spec `<NN>.md` en intégrant un feedback de review (typiquement Stage 5 → 🟡 structurel ou 🔴 systémique).

**Étapes** :

1. Lire `nodes/<NN>.md` (spec actuelle)
2. Lire la review la plus récente si présente (`reviews/*<NN>*`)
3. Identifier les sections à patcher selon `<texte>` :
   - Modification de variables → patch section "Variables à l'entrée" / "Flags activés"
   - Modification de choix → patch section décrivant les `[A][B][C][D]`
   - Ajout/retrait de PNJ → patch section "Characters Dialogic"
   - Modification de transition → patch section "Transitions"
4. **Toujours conserver** : H1, ligne 2 (filename .dtl), structure de sections existante
5. **Ajouter un changelog** en fin de fichier :
   ```markdown
   ---
   ## Changelog
   - <YYYY-MM-DD> · update via node-manage · raison : <résumé du feedback>
   ```
6. Écrire le fichier patché
7. **Ne pas toucher au `.dtl`** — l'auteur relancera `03-write-dtl <NN>` ensuite si la spec a bougé sur des points qui impactent l'écriture

**Confirmation obligatoire** : afficher le diff avant écriture si plus de 20 lignes touchées.

### Action `--retire <NN>`

Sortir un node du jeu actif. **Pas de suppression destructive**.

1. Déplacer `nodes/<NN>.md` → `nodes/.retired/<NN>.md`
2. Si `.dtl` correspondant existe : déplacer vers `dialogic/timelines/.retired/`
3. Ajouter une entrée dans `aidd_docs/memory/internal/deal-breakers-log.md` ou un journal équivalent :
   ```markdown
   ## Retired <YYYY-MM-DD> · NODE <NN>
   - Raison : <demander à l'auteur si non précisée>
   - Impact arcs : <liste arcs qui référencent ce NN>
   - Fix : <retirer du arc-spec / réécrire un remplaçant>
   ```
4. **Warning si** des nodes aval consomment des flags posés par le node retiré → lister les nodes impactés.

Confirmation explicite obligatoire avant déplacement.

## Output

- `--list` : tableau Markdown stdout
- `--status` : fiche Markdown stdout
- `--update` : fichier `nodes/<NN>.md` modifié + diff stdout
- `--retire` : fichiers déplacés + rapport d'impact stdout

Aucune action sans confirmation pour `--update` et `--retire`.

## Rules

1. **Ne pas inventer de donnée manquante** — afficher `—` ou flagger l'incohérence
2. **Update ≠ rewrite** — ce prompt patche la spec, il ne réécrit pas le `.dtl`. Pour le `.dtl`, relancer `03-write-dtl`
3. **Retire ≠ delete** — toujours archiver dans `.retired/`
4. **Préserver les conventions** — H1, ligne 2 (filename .dtl), structure de sections. Toute dérogation = bug
5. **Source de vérité = fichiers sur disque** — pas de cache, pas de mémoire ; relire à chaque invocation
6. **Linter non lancé ici** — ce prompt n'exécute pas `dtl_linter.gd`. Il peut indiquer "linter à relancer" mais ne le fait pas
7. **Pas de génération créative** — pas de propositions, pas de variantes. Pour ça, utiliser les prompts de workshop / decompose-arc

## Note d'intégration

Ce prompt est l'**outil de pilotage** entre Stage 3 et Stage 5. Cycle typique d'usage :

```
02-decompose-arc                    → crée nodes/01.md … nodes/NN.md
node-manage --list                  → vérifie le set
03-write-dtl 02.md                  → écrit pro_cellule.dtl
04-review-persona pro_cellule.dtl dramaturge   → review 🟡
node-manage --update 02 --feedback "Branche [B] structurellement vide — ajouter un beat avant le choix"
03-write-dtl 02.md                  → réécriture du .dtl
04-review-persona pro_cellule.dtl dramaturge   → re-review
```

Pour les opérations de masse (lister tous les nodes 🔴, etc.), `--list` suffit ; pas de mode `--filter triage=🔴` prévu (trop spécifique, l'auteur grep le tableau).
