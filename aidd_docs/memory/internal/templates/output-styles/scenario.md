# Output Style — `scenario` (défaut 8-MINE)

**Univers** : 8-MINE — Néo-Paris 2084
**Type** : timeline Dialogic narrative (`.dtl`)
**Version** : 1.0
**À déclarer dans le node-spec** : `output_style: scenario`

---

## Atmosphère

- **Ton** : noir, journalistique, sec. Pas de cyber-jargon performatif (« datacore implosé », « nanofibre quantique » → BANNI).
- **Sous-texte > exposition** : ce que Margot ne dit pas porte le sens. Aucun PNJ ne récapitule au joueur ce qu'il sait déjà.
- **Néo-Paris se ressent** : caméras, factions, jauges. Jamais expliqué frontalement.
- **Margot reste journaliste** : précision, observation, méfiance. Pas d'épanchement lyrique.

## Registre

- **Adresse du joueur** : aucune. Le joueur est Margot ; Margot ne parle pas au joueur.
- **Voix interne Margot** : *italique gris*. Pensées, observations, doutes.
- **Voix parlée Margot** : ocre normal. Toujours en relation, jamais en monologue intérieur déguisé.
- **Narrator** : italique discret, descriptions courtes, jamais omniscient (ne sait pas plus que Margot).
- **PNJ** : ID Dialogic lowercase (`emma`, `frank`, etc.). Voix distincte par personnage (lexique, rythme).

## Vocabulaire

### Lexique à privilégier

- Concret : noms d'objets, de lieux, de marques fictives canon (Stratom, Memorize, Nexus, Kaizen)
- Sensoriel : odeurs, sons, textures (le rythme du néon, la condensation sur la vitre)
- Détails de surveillance : caméras nommées, angles morts, balises RFID

### Lexique à BANNIR

- « crucial », « essentiel », « profond », « sublime », « palpable », « tangible », « immersif », « viscéral », « brut », « intense », « finalement »
- Toute formule qui sent l'IA générative (« il est important de noter que »)
- Le présent de narration générique (« Margot ressent une vague de... » → trop ChatGPT)

### Marqueurs typographiques

| Élément | Forme |
|---------|-------|
| Voix interne Margot | `_:` ou `narrator:` italique gris |
| Voix parlée Margot | `margot:` normal |
| PNJ | `<id>:` normal, couleur charte |
| Description neutre | `narrator:` italique discret |
| Choix joueur | `[choice text="..."]` — verbe d'action en premier, < 60 caractères |

## Contraintes mécaniques (DialogicBridge)

Tous les effets passent par `[signal arg="..."]`. Référence canon : `aidd_docs/memory/internal/api-cheatsheet.md`.

Dispatchers reconnus :
- `relation:<pnj_id>:<delta>`
- `flag:<nom>:<valeur>`
- `decision:<id>`
- `lieu:<id>`
- `surveillance:<delta>:<raison>`
- `miroir:<delta>:<raison>`
- `reputation:<faction>:<delta>`
- `countdown:<id>:<delta>`

**Toujours** indiquer la raison pour `surveillance:`, `miroir:`, `reputation:` (traçabilité review).

**Erreurs courantes** :
- ❌ `[signal arg="miroir:+5"]` → manque la raison
- ✅ `[signal arg="miroir:+5:mensonge_emma"]`
- ❌ `[signal arg="reputation:5"]` → manque la faction
- ✅ `[signal arg="reputation:stratom:+5"]`

## Forme prose

### Longueur

- **Ligne Dialogic** : < 200 caractères (sinon coupure visuelle pénible)
- **Paragraphe Dialogic** : ≤ 3 phrases consécutives sans interaction
- **Bloc narratif sans choix** : < 15 lignes Dialogic

### Phrases

- Phrases courtes. Subordonnées rares. Pas de virgule décorative.
- Verbes concrets. Adjectifs économes.
- Pas de comparaison ronflante.

### Dialogues PNJ (typographie française)

```
margot: "On se connaît ?"
emma: "Tu sais qu'on se connaît, Margot."
```

Guillemets droits dans le `.dtl` (Dialogic-friendly). Les tirets cadratin sont réservés au narrator pour les didascalies.

## Conditions et branches

Format Dialogic :

```dtl
{if {flag_emma_a_reveele}}
  emma: "Tu sais ce que j'ai fait."
{else}
  emma: "Margot, on doit se parler."
{endif}
```

Les `.` dans les noms de flags deviennent `_` automatiquement. Les variables Dialogic s'inscrivent `{var_name}`.

## Exemples

### Exemple 1 — Voix interne + dialogue + signal

```dtl
narrator: *L'odeur du métal chaud. Quelque chose vient de griller dans le mur.*

margot: "Coupure ?"

emma: "Surveillance qui se réinitialise. Tu as cinq minutes."

[signal arg="surveillance:-10:reboot_camera"]

narrator: *Cinq minutes. Et après ?*
```

### Exemple 2 — Choix bien formé

```dtl
[choice text="Poser les micros pendant la coupure"]
  [signal arg="flag:flag_micros_poses:true"]
  [signal arg="surveillance:+15:mouvement_suspect"]
  [signal arg="miroir:-5:franchir_ligne"]
  margot: "..."
  [signal arg="lieu:pro_couloir"]

[choice text="Renoncer et sortir"]
  [signal arg="flag:flag_micros_poses:false"]
  [signal arg="miroir:+3:integrite"]
  [signal arg="lieu:pro_couloir"]
```

## Checklist d'écriture

Avant de remettre un `.dtl` :

- [ ] Aucun mot de la red-list (« crucial », « immersif », etc.)
- [ ] Italique Margot interne ≠ italique narrator (règle stricte)
- [ ] Tous les libellés `[choice]` < 60 caractères, verbe d'action en premier
- [ ] Toutes les lignes < 200 caractères
- [ ] Tous les `[signal arg="surveillance:..."]`, `miroir:`, `reputation:` ont une raison
- [ ] Aucune ligne sans interaction au-delà de 3 phrases consécutives
- [ ] PNJ canon uniquement (croiser `bible-jeu.md` + `pnjs-secondaires.md`)
- [ ] Linter `dtl_linter.gd` PASS

---

**Note** : ce style est le défaut. Des variantes (`output-styles/introspection.md` pour les beats Miroir longs, `output-styles/action.md` pour surveillance haute, etc.) peuvent être créées et déclarées par node si l'auteur le souhaite.
