# NODE [`<NODE_ID>`] — `<Titre>`
`<dialogic/timelines/<fichier>.dtl>` · `<Acte>` · Scène `<n>`

> Sortie du prompt `decompose-arc`. Entrée du prompt `write-dtl`.
> Format aligné sur `aidd_docs/memory/external/nodes/NN.md`.

---

## Métadonnées

```yaml
node_id: <ARC>-<NN>
arc: <ARC>
timeline: dialogic/timelines/<fichier>.dtl
output_style: scenario           # référence templates/output-styles/<nom>.md
complexite: simple|moyen|dense   # 0 / 1-2 / 3+ choix
```

**Output-style** : tonalité rédactionnelle à appliquer dans `write-dtl`. Défaut = `scenario`.
Variantes possibles si déclarées dans `templates/output-styles/` (ex : `introspection`, `action`).

---

## Variables à l'entrée

```gdscript
flag_<préconditions> = true   # provient de NODE <amont>
# Variables Dialogic attendues : {ex_prenom} (depuis A1-XX), etc.
```

## Flags et variables activés dans cette scène

```gdscript
# Selon le choix :
# [A] flag_X = true · MS-1 · PD+1
#     → ferme FIN-<X>
# [B] flag_Y = true · MS+1
# [C] flag_Z = true · miroir+10
#     → ouvre FIN-<Y>
```

## Fichiers Godot liés

```
scenes/<acte>/<scene>.tscn         ← scène navigable (point-and-click) OU vide (dialogue pur)
dialogic/timelines/<scene>.dtl     ← timeline complète
scripts/<acte>/<scene>.gd          ← logique signal handling (si point-and-click)
scripts/<acte>/<scene>_init.gd     ← UNIQUEMENT si premier NODE de l'arc
```

## Characters Dialogic utilisés

| ID | Affichage | Style | Sprite |
|----|-----------|-------|--------|
| `narrator` | *(aucun)* | italique gris | — |
| `margot` | `MARGOT` | normal ocre | — |
| `emma` | `{emma_prenom}` | normal blanc | `char_emma_*.png` |

## Lieu(x)

```
LocationManager.aller_a("<id_lieu>")
```

Background(s) : `<bg_xxx.jpg>`

## Choix proposés (si NODE interactif)

### [A] `<libellé court>`

```
Effets :
  - flag_X = true
  - MS -1
  - PD +1
  - relation:emma:-5
Sortie : NODE <suivant_si_A>
```

### [B] `<libellé court>`

```
Effets :
  - flag_Y = true
  - MS +1
Sortie : NODE <suivant_si_B>
```

### [C] `<libellé court>` (optionnel)

```
Effets :
  - flag_Z = true
  - miroir +10
Sortie : NODE <suivant_si_C>
```

---

## Transitions (TABLE CANONIQUE — source de vérité pour `graph-audit`)

| Branche | Condition d'accès | Flag(s) posé(s) | Jauges | Réputation | Countdown | Next NODE | Fins fermées | Fins ouvertes |
|---------|-------------------|-----------------|--------|------------|-----------|-----------|--------------|---------------|
| [A] `<libellé>` | `<précondition[s]>` ou — | `flag_X=true` | `MS-1, PD+1` | `stratom:-5` | — | `<ARC>-<NN+1>-strat` | FIN-A, FIN-F | — |
| [B] `<libellé>` | — | `flag_Y=true` | `MS+1` | — | — | `<ARC>-<NN+1>-doute` | — | — |
| [C] `<libellé>` | `flag_emma_a_reveele=true` | `flag_Z=true` | `miroir+10` | — | `equipe_nettoyage:+1` | `<ARC>-01-confrontation` | — | FIN-G |
| [D] `<libellé>` (opt.) | `mental_stability >= 2` | `flag_W=true` | `PD+1` | `marine:+3` | — | `<ARC>-03-miroir` | — | — |

**Règles** :
1. Une seule branche par ligne. Pas de "ou" implicite dans une cellule.
2. Conditions composées explicites : `flag_X AND NOT flag_Y` (lisible).
3. `Next NODE` est obligatoire — pour une fin terminale, écrire `FIN-<X>` (et déclarer la fin dans `history.md`).
4. `Fins fermées` / `Fins ouvertes` = effets sur l'arborescence narrative globale, traduits en flags par les Postconditions.

## Transitions sortantes (signaux Dialogic)

```
[signal arg="lieu:<id_lieu_suivant>"]
ou
[signal arg="flag:<arc>_termine:true"]
```

## Dépendances entrantes (audit)

Pour chaque entrée de "Variables à l'entrée", indiquer le node amont qui la pose :

| Flag attendu | Posé par |
|--------------|----------|
| `flag_emma_a_reveele` | PRO-01 branche [A] ou [B] |

## Notes de mise en scène

`<Indications pour l'écriture du .dtl : tonalité de Margot, rythme, sous-texte, références culturelles, beats. Pas de prose, pas de dialogue.>`

## Contrainte de complexité

- [ ] **Simple** : 0 choix, narration linéaire (5-15 lignes Dialogic)
- [ ] **Moyen** : 1-2 choix, branches courtes (20-40 lignes)
- [ ] **Dense** : 3+ choix, branches longues avec sous-conditions (50-100 lignes)

---

## Changelog

`<YYYY-MM-DD>` · création via `decompose-arc` depuis `<arc-spec>.md`
