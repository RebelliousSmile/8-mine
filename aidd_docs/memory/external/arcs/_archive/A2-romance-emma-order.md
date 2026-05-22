# Ordre topologique — `A2-romance-emma`

> Sortie de `decompose-arc`. Manifest d'écriture pour `write-dtl`.
> Listage des 7 NODES dans l'ordre topologique (par dépendances de flags) pour orienter l'écriture séquentielle ou parallèle.

---

## Graphe de dépendances

```
A2-04E-01 (exposition, 0 choix)
    │
    └─► A2-04E-02 (3 choix : artificielle | sincere | instrumentalisee)
            │
            └─► A2-04E-03 (3 choix : voyeuriste | evitee | nommee · skippable si A1-05)
                    │
                    └─► A2-04E-04 (PIVOT · 3 choix : pacte | distance | blessee · + modificateur écoute)
                            │
                            ├─► A2-04E-05A (PACTE, 0 choix) ──┐
                            │                                  │
                            ├─► A2-04E-05B (DISTANCE, 0 choix)─┼─► A2-05 (retour ligne principale)
                            │                                  │
                            └─► A2-04E-05C (BLESSÉE, 1 choix) ─┘
```

## Ordre d'écriture recommandé

| Ordre | NODE | Raison |
|-------|------|--------|
| 1 | `A2-04E-04` | **PIVOT** — c'est le verrou canon (bascule cognitive inévitable, phrase canon `[A]`). Écrire en premier pour fixer le ton de l'arc et faire valider par `playtester-lgbtqia` + `dramaturge` + `playtester-margot` avant tout le reste. |
| 2 | `A2-04E-05A` | Résolution PACTE — le succès canonique. Pose l'effet mécanique majeur (`flag_emma_boussole`, cap triggers internes). À écrire juste après le PIVOT pour cohérence de ton. |
| 3 | `A2-04E-05B` | Résolution DISTANCE — la rupture sociale. Court, sobre. |
| 4 | `A2-04E-05C` | Résolution BLESSÉE — la honte adulte. Inclut le seul choix de mitigation post-PIVOT. |
| 5 | `A2-04E-02` | Beat de qualification (3 choix). À écrire après les résolutions pour calibrer les effets différés sur le PIVOT. |
| 6 | `A2-04E-03` | Beat de seuil moral (3 choix + skip variant). Le plus long en variantes, écrire en dernier *parmi les choix*. |
| 7 | `A2-04E-01` | Exposition. Court, atmosphérique. À écrire en dernier — c'est la scène qui doit *préparer* l'arc, donc connaître sa fin aide. |

## Ordre d'écriture parallèle (si plusieurs auteurs)

- **Auteur A** *(verrou canon)* : `A2-04E-04` puis `A2-04E-05A/B/C` (1→2→3→4 ci-dessus). 4 NODES denses, ~250 lignes Dialogic au total.
- **Auteur B** *(setup)* : `A2-04E-01`, `A2-04E-02`, `A2-04E-03`. 3 NODES moyens, ~80 lignes au total. À synchroniser avec Auteur A après que le PIVOT soit validé.

## Lieux à créer (Annexe)

Avant écriture, les lieux suivants doivent être déclarés dans `LocationManager` et leurs backgrounds générés :

| ID lieu | Background asset | Origine |
|---------|------------------|---------|
| `coursive_saint_michel_nuit` | `bg_coursive_saint_michel_nuit.jpg` | nouveau (A2-04E-01) |
| `cellule_margot_nuit` | `bg_cellule_margot_nuit.jpg` *(variante de `bg_cellule_margot_jour.jpg`)* | nouveau (A2-04E-03) |
| `balcon_etage_residents` | `bg_balcon_etage_residents.jpg` | nouveau (A2-04E-03 branche [C]) |
| `appart_emma_leo_nuit` | `bg_appart_emma_leo_nuit.jpg` *(variante de `bg_appart_emma_leo.png`)* | nouveau (A2-04E-04) |
| `appart_emma_leo_matin` | `bg_appart_emma_leo_matin.jpg` | nouveau (A2-04E-05A/B/C) |

## Sprites à créer (Annexe)

| Sprite set | Origine |
|------------|---------|
| `char_emma_nuit_*.png` | A2-04E-01 |
| `char_emma_appart_*.png` | A2-04E-02 |
| `char_emma_balcon_*.png` | A2-04E-03 branche [C] |
| `char_emma_proximite_*.png` | A2-04E-04 (PIVOT) |
| `char_emma_lendemain_*.png` | A2-04E-05A/B/C |

## Validation croisée (checklist `decompose-arc` Step 3)

- [x] Tous les flags consommés par un NODE sont posés par un NODE amont (chaîne A2-04E-01 → 02 → 03 → 04 → 05A/B/C complète)
- [x] Aucun NODE ne pose un flag jamais consommé (les flags `flag_emma_intimite_*` du NODE 02 sont lus par NODE 03 et 04 ; les flags `flag_emma_ecoute_*` du NODE 03 sont lus par NODE 04 ; les flags `flag_pacte_emma / flag_emma_distance / flag_emma_blessee` du NODE 04 routent vers 05A/B/C respectifs)
- [x] Tous les `lieu:` sont valides (existants) ou déclarés ci-dessus (5 nouveaux lieux)
- [x] Tous les PNJs sont déclarés dans `bible-jeu.md` (Emma, Léo, Margot)
- [x] Sommes deltas jauges plausibles : pire cas mirror cumulé sur l'arc = `+10 (B2.A) + +10 (B3.A) + +20 (B4.C)` = **+40 mirror max** *(reste < 60 seuil hésitation — OK)*. MS pire cas : `-0 (B2.A) - 0 (B3.A) - 0 (B4.C)` = **0** *(MS ne baisse pas, juste pas de gain)*.
- [x] Chaque NODE a sa **table Transitions** remplie
- [x] Chaque NODE a ses **Dépendances entrantes** documentées
- [x] `output_style: scenario` — fichier `aidd_docs/aiw/8mine/templates/output-styles/scenario.md` existe
- [x] Toutes les Fins ouvertes/fermées citent des fins déclarées dans `history.md` (A, B, F, G, I — pas de FIN-E Emma, exclue canon)
- [x] Toutes les Réputations citent des factions canon (memorize uniquement, valide)
- [x] **Graph-audit à blanc** : aucune branche ne pointe vers un NODE non listé. Sortie commune confirmée vers `A2-05` *(à spec dans le futur arc-spec A2-principal — placeholder valide pour l'instant)*.

## Risque structurel residual à surveiller

- **A2-05 dépendance amont** : tous les NODES 05A/B/C pointent vers `A2-05` (ligne principale A2). Ce NODE n'est pas encore spec — son point d'entrée doit accepter les 3 états sortants de l'arc Emma (`flag_emma_boussole` true/false, mirror cumulé variable, relation Emma cappée ou non). À documenter dans `arc-spec A2-principal` (P1 todo overview).

---

`2026-05-21` · création via `decompose-arc` depuis `A2-romance-emma.md`
