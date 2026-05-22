# PNJ Behavior — `<pnj>`

> Sortie du prompt `pnj-behavior`. Catalogue de comportement d'un PNJ à travers les paliers de relation et les événements de seuil.
> Consommé par `scene-spec` (pour les tables de réponses) et `write-dtl` (pour les voix).

---

## Métadonnées

```yaml
pnj_id: <pnj>
tier: 1|2|3
corpo: <memorize|kaizen|nexus|stratom|none>
sprite_set: char_<pnj>_*.png
voix_dialogic_id: <pnj>          # ID CharacterRegistry
prenom_var: <pnj>_prenom         # variable Dialogic
```

---

## Verrous canon (sacrés)

Phrases / comportements interdits, conditions hard, sensitivity reader si requis :

- `<verrou 1>`
- `<verrou 2>`
- *(extraire de `bible-jeu.md` + `internal/design-rules/<pnj>-*.md` si existe)*

**Sensitivity reader requis** : `<oui/non + persona>`

---

## Voix par palier

| Palier | Registre | Vocabulaire / lexique | Ton physique |
|--------|----------|------------------------|--------------|
| Ennemi juré | <description> | <ex> | <attitude corporelle> |
| Hostile | ... | ... | ... |
| Méfiance | ... | ... | ... |
| Neutre | ... | ... | ... |
| Favorable | ... | ... | ... |
| Allié | ... | ... | ... |
| Proche | ... | ... | ... |
| Confident | ... | ... | ... |
| Fusionnel | <ou marquer "inaccessible canon"> | ... | ... |

---

## Événements de seuil

### `event_<pnj>_<palier>` — palier franchi vers `<X>`

- **Type** : `montée` (hausse de palier, monotone, one-shot par partie)
- **Conditions de déclenchement** :
  - `relation:<pnj>` franchit le seuil <X> vers le haut
  - + contexte : `<ex. "scène intime, PNJ présent seul">`
  - + jauges/flags : `<ex. "MS ≥ 3" ou "flag_X = true">`
- **Mode de jouage** :
  - immédiat *(si conditions déjà remplies au moment du franchissement)*
  - différé *(buffered : `flag_event_<pnj>_<palier>_pending = true`, joué prochaine scène compatible)*
- **Réaction scriptée** (résumé, formulation à valider en tone-finder) :
  > *« <réplique canon ou registre de réaction> »*
- **Déverrouille** :
  - nouveau sujet `<sujet_id>` dans scenes `<liste>`
  - nouvelle scène `<scene_id>` *(si applicable)*
  - nouvelle action point-and-click `<action>` *(si applicable)*

### `event_<pnj>_<autre>` — *(répéter pour chaque seuil significatif)*

---

## Hooks scènes

Scènes où ce PNJ apparaît typiquement, avec actions génériques :

| Scène | Présence | Actions typiques par palier |
|-------|---------|-----------------------------|
| `<scene_id>` | toujours / sous condition | <ex. "à Méfiance refuse, à Allié+ propose une info"> |

---

## Risques structurels

1. `<risque écriture / canon>`
2. `<risque mécanique / palier inatteignable>`
3. `<risque sensitivity reader>`

---

## Validation locale

- [ ] Tous les 9 paliers ont une voix décrite (ou marqués inaccessibles)
- [ ] Au moins 1 événement de seuil par palier significatif (typiquement Confident, parfois Allié + autre)
- [ ] Verrous canon explicites et alignés avec `bible-jeu.md` + `internal/design-rules/`
- [ ] Hooks scènes pointent vers `scenes/` existants ou à créer
- [ ] Sensitivity reader requis identifié si applicable
