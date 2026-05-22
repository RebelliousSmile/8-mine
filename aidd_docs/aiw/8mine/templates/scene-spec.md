# Scene Specification — `<scene_id>`

> Sortie du prompt `scene-spec`. Entrée du prompt `write-dtl`.
> Unité de scène-type réutilisable. Consomme les `pnjs-behavior/` des PNJs concernés.

---

## Métadonnées

```yaml
scene_id: <scene_id>           # ex: diner_arrivee, cellule_nuit, appart_emma_leo
timeline: dialogic/timelines/<fichier>.dtl
lieu: <lieu_id>                # cf. LocationManager
recurring: true|false
actes: [PRO|A1|A2|A3|A4]       # liste des actes où la scène peut se jouer
output_style: scenario         # cf. templates/output-styles/
acces_requis:                  # cf. overview.md § Gating d'accès aux espaces privés
  - palier:<pnj> >= <seuil>    # ex: palier:emma >= Allie (espace privé)
  # ou "public" pour les zones communes (cellule margot, coursives, etc.)
```

---

## Lieu et ambiance

- **Background** : `<bg_xxx.jpg>`
- **Atmosphère** : `<2-3 lignes : palette, éclairage, sonore>`

---

## Jauges activables (scope déclaratif)

> **Règle canon** : aucun sujet de cette scène ne peut modifier une jauge qui n'est pas listée ici. Vérification mécanique en `graph-audit`.

| Jauge | Activable ? | Plage typique de delta sur la scène | Justification |
|-------|-------------|-------------------------------------|---------------|
| `relation:<pnj>` (par PNJ présent) | oui/non | ex. ±2 | <pourquoi> |
| `MS` | oui/non | ex. ±1 | <pourquoi> |
| `PD` | oui/non | ex. +0..+1 | <pourquoi> |
| `EV` | oui/non | ex. +0..+2 | <pourquoi> |
| `mirror` | oui/non | ex. +0..+10 | <pourquoi> |
| `surveillance` | oui/non | ex. +0..+5 | <pourquoi> |
| `reputation:<faction>` | oui/non | par faction | <pourquoi> |
| `countdown:<id>` | oui/non | tick ou pas | <pourquoi> |

*(Lister uniquement les jauges effectivement touchées. Les autres sont implicitement hors-scope.)*

---

## Variables PNJ (résolution de présence)

> **À retenir** : la présence des PNJs est une **variable de scène résolue au runtime**. Chaque PNJ candidat déclare une *règle de présence* qui détermine s'il est dans la scène lors du chargement. Les sujets ciblant un PNJ ne s'affichent que si ce PNJ est présent.

### Pool de candidats

| PNJ | Règle de présence | Variante absent | Sprite (si présent) |
|-----|-------------------|------------------|---------------------|
| `<pnj>` | `toujours` / `si flag_X = true` / `si palier:<pnj> ≥ Y` / `tirage parmi <pool>` | comportement narratif si PNJ absent *(voix off / mention / mute)* | `char_<pnj>_*.png` |

### Effet sur les sujets

- Sujet ciblant `<pnj>` absent → le sujet n'apparaît pas dans le menu Margot.
- Si tous les PNJs candidats d'un sujet broadcast sont absents → le sujet est masqué.
- Les dialogues d'ambiance peuvent référencer un PNJ absent (voix off à travers un mur, mention par un autre PNJ présent) — déclarer ces variantes en *Variante absent*.

### Tirage déterministe *(si applicable)*

Si la règle de présence implique un tirage *(ex. « PNJ croisé en sortie nocturne »)*, déclarer la convention déterministe : *« PNJ avec `relation:` la plus haute parmi le pool, à égalité ordre alphabétique »*. **Aucun RNG aveugle** — la résolution doit être prédictible.

---

## Trigger d'apparition

- **Conditions narratives** : `<ex. "Margot dans la cellule, cycle nuit, en A1+">`
- **Cooldown / cap** : `<ex. "rejouable max 3 fois par run, cooldown 2 ticks">`

---

## Dialogues d'ambiance

```
# Intro (à l'entrée — toujours joué)
[narrator] <description du lieu, des présences>
[ambiance sonore]

# Outro (à la sortie — toujours joué)
[narrator] <closing>
```

---

## Sujets disponibles

### Sujet `<sujet_id>` — *« <libellé joueur> »*

- **Condition d'apparition** : `<ex. "MS ≥ 4" ou "palier:emma ≥ Allié" ou — (toujours)>`
- **Cible** : `<PNJ spécifique OU "tous PNJs présents" OU "Margot seule">`
- **Effets de base** : `<jauges modifiées indépendamment du palier>`
- **Cap** : `<unique / N fois par scène / illimité>`

#### Table de réponses

| Cible | Palier | Réplique (résumé) | Effets supplémentaires |
|-------|--------|-------------------|------------------------|
| `<pnj>` | Méfiance | <résumé> | relation:<pnj>:-1 |
| `<pnj>` | Neutre | <résumé> | — |
| `<pnj>` | Favorable | <résumé> | relation:<pnj>:+1 |
| `<pnj>` | Allié | <résumé> | relation:<pnj>:+2, EV+1 |
| `<pnj>` | Confident | <résumé> | déverrouille sujet/scène X |

*(Répéter Sujet × N selon scène. 3-6 sujets typiques.)*

---

## Événements de seuil susceptibles de se jouer ici

| Event ID | Source | Déclenchement | Effet |
|----------|--------|---------------|-------|
| `event_<pnj>_<palier>` | `pnj-behavior:<pnj>` | Première scène compatible après franchissement | Réaction PNJ + déverrouillage |

---

## Conditions de sortie

- **Cap sujets par visite** : `<X>`
- **Forced exit** : `<condition narrative qui ferme la scène>`

---

## Risques structurels

1. `<risque 1>`
2. `<risque 2>`
3. `<risque 3>`

---

## Validation locale

- [ ] Toutes les jauges mentionnées existent dans `variables-register.md`
- [ ] Toutes les factions citées sont parmi les 8 valides
- [ ] Tous les `pnj-behavior` référencés existent
- [ ] Aucun sujet sans effet (cf. règle canon Margot terrain neutre)
- [ ] Tables de réponses couvrent au moins Méfiance, Neutre, Allié, Confident pour les PNJ-cibles
- [ ] Verrous canon des pnj-behavior respectés
- [ ] **Tous les deltas de jauges des sujets sont couverts par la table « Jauges activables »** (aucun sujet ne modifie une jauge hors-scope)
