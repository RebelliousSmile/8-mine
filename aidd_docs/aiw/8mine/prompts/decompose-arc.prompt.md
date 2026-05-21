---
name: decompose-arc
description: Décompose un arc-spec en specs NODE individuelles avec table Transitions.
argument-hint: <chemin arc-spec.md>
version: 1.1
---

# Decompose Arc — Arc développé → Specs NODE

## Goal

Transformer un `arc-spec.md` en N fichiers `nodes/NN.md`, un par NODE, conformes au
gabarit utilisé pour PRO-01 et PRO-02. Chaque NODE devient une unité écrivable
indépendamment dans `write-dtl`.

## Context

**Arc à décomposer :**
```markdown
@$ARGUMENTS[0]
```

**Ressources canon :**
```
@aidd_docs/memory/external/architecture.md
@aidd_docs/memory/external/nodes/01.md
@aidd_docs/memory/external/nodes/02.md
@aidd_docs/memory/internal/variables-register.md
@aidd_docs/memory/internal/api-cheatsheet.md
```

**Template de sortie :**
```
@aidd_docs/aiw/8mine/templates/node-spec.md
```

## Process

### Step 1 — Lister les NODES depuis l'arc-spec

Extraire le tableau "NODES à produire" de l'arc-spec. Vérifier que chaque NODE :
- A un ID unique conforme à la convention
- A un rôle déclaré
- A une complexité déclarée

### Step 2 — Pour chaque NODE, produire une node-spec

Pour CHAQUE NODE listé :

#### 2.0 — Métadonnées (en-tête YAML)

Renseigner le bloc :

```yaml
node_id: <ARC>-<NN>
arc: <ARC>
timeline: dialogic/timelines/<fichier>.dtl
output_style: scenario           # défaut ; déclarer une variante uniquement si nécessaire
complexite: simple|moyen|dense
```

`output_style` doit pointer vers un fichier de `aidd_docs/aiw/8mine/templates/output-styles/`.
Défaut = `scenario`. Variantes possibles (si présentes) : `introspection`, `action`, etc.
**Si tu choisis une variante non-défaut, vérifier que le fichier existe**.

#### 2.1 — Préconditions (variables à l'entrée)

Croiser avec l'arc-spec :
- Quels flags du NODE précédent sont attendus ?
- Quel est l'état des jauges attendu ?
- Quelles variables Dialogic (`{emma_prenom}`) sont attendues posées ?

Format strict :
```gdscript
flag_<X> = true   # condition d'accès — posée à la fin de NODE <amont>
```

#### 2.2 — Effets (variables activées)

Pour chaque choix proposé dans ce NODE :
- Quels flags pose-t-il ?
- Quels deltas jauges ?
- Quel NODE de sortie ?

Format strict :
```gdscript
# [A] flag_X = true · MS-1 · PD+1
#     → ferme FIN-<X>
```

#### 2.3 — Fichiers Godot liés

Lister explicitement :
- `scenes/<acte>/<scene>.tscn` — TOUJOURS
- `dialogic/timelines/<scene>.dtl` — TOUJOURS
- `scripts/<acte>/<scene>.gd` — SI point-and-click
- `scripts/<acte>/<scene>_init.gd` — UNIQUEMENT si premier NODE de l'arc

#### 2.4 — Characters Dialogic

Inventaire des PNJs présents. Pour chaque PNJ :
- ID Dialogic (lowercase)
- Affichage (`{emma_prenom}` ou nom fixe)
- Style (italique, normal, couleur)
- Sprite

#### 2.5 — Lieu

`LocationManager.aller_a("<id>")` — vérifier que l'ID existe dans la liste connue
(`pro_arrivee`, `pro_zone_commune`, `pro_cellule`, etc.).

Si nouveau lieu → le déclarer dans une annexe "Nouveaux lieux".

#### 2.6 — Choix proposés (si NODE interactif)

Pour chaque choix [A], [B], [C], [D] :
- Libellé court
- Effets exhaustifs (flags + jauges + relations + réputation + countdowns)
- NODE de destination

#### 2.7 — Transitions sortantes

##### 2.7.a — Table canonique des transitions (OBLIGATOIRE)

Remplir la table "Transitions" du node-spec. **Une ligne par branche** :

| Branche | Condition d'accès | Flag(s) posé(s) | Jauges | Réputation | Countdown | Next NODE | Fins fermées | Fins ouvertes |
|---------|-------------------|-----------------|--------|------------|-----------|-----------|--------------|---------------|

Règles :
- Pas de "ou" implicite dans une cellule — splitter en deux lignes
- Conditions composées explicites : `flag_X AND NOT flag_Y`
- `Next NODE` obligatoire — pour une fin terminale, écrire `FIN-<X>`
- Croiser `Fins ouvertes` / `Fins fermées` avec `history.md` (les 9 fins déclarées)
- Croiser `Réputation` avec les 8 factions canon

Cette table est la **source de vérité** pour `graph-audit` — elle doit être exhaustive et machine-parsable (format Markdown table strict).

##### 2.7.b — Dépendances entrantes (OBLIGATOIRE)

Pour chaque flag de "Variables à l'entrée", indiquer le node amont qui le pose :

| Flag attendu | Posé par |
|--------------|----------|

##### 2.7.c — Signaux Dialogic sortants

Format Dialogic exact :
```
[signal arg="lieu:<id_lieu_suivant>"]
ou
[signal arg="flag:arc_termine:true"]
```

#### 2.8 — Notes de mise en scène

3-5 lignes destinées à `write-dtl`. Pas du dialogue ; des indications :
- Tonalité de Margot dans ce NODE
- Rythme attendu (lent / nerveux)
- Sous-texte à préserver
- Références éventuelles

#### 2.9 — Contrainte de complexité

Cocher l'une des 3 cases :
- Simple : 0 choix
- Moyen : 1-2 choix
- Dense : 3+ choix

Cette case détermine la durée d'écriture estimée.

### Step 3 — Validation croisée

Avant d'écrire les fichiers :

- [ ] Tous les flags consommés par un NODE sont posés par un NODE amont (chaîne complète)
- [ ] Aucun NODE ne pose un flag jamais consommé (sauf flags terminaux d'arc)
- [ ] Tous les `lieu:` sont valides ou déclarés en annexe
- [ ] Tous les PNJs sont déclarés dans `bible-jeu.md` ou `pnjs-secondaires.md`
- [ ] Les sommes de deltas jauges sur l'arc complet sont plausibles (pas +50 MS d'un coup)
- [ ] Chaque node a sa **table Transitions** remplie (une ligne par branche)
- [ ] Chaque node a ses **Dépendances entrantes** documentées
- [ ] Chaque `output_style` déclaré pointe vers un fichier existant
- [ ] Toutes les `Fins ouvertes`/`Fins fermées` citent des fins déclarées dans `history.md`
- [ ] Toutes les `Réputation` citent une des 8 factions canon
- [ ] Lancer un `graph-audit` à blanc (mental) : aucune branche ne pointe vers un node non listé

### Step 4 — Ordre d'écriture

Produire un fichier `aidd_docs/memory/external/arcs/<ARC_ID>-order.md` qui liste les
NODES dans l'ordre topologique (par dépendances), pour orienter le écriture parallèle.

## Output

Écrire :
- `aidd_docs/memory/external/nodes/<NODE_ID>.md` × N (un par NODE)
- `aidd_docs/memory/external/arcs/<ARC_ID>-order.md` (manifest)

## Rules

1. **Pas de dialogue** — un node-spec décrit la mécanique, jamais la prose
2. **IDs uniques** — vérifier qu'aucun ID existant n'est réutilisé
3. **Lieux et PNJs canon** — toute nouveauté doit être déclarée explicitement
4. **Pas de NODE orphelin** — chaque NODE a un point d'entrée et au moins une sortie
5. **Cohérence avec arc-spec** — si un beat n'apparaît dans aucun NODE, c'est une erreur
