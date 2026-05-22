# Arc Specification — `A2-romance-emma`

> Sortie du prompt `arc-spec`. Entrée du prompt `decompose-arc`.
> Contrat de l'arc : ce qu'il consomme, ce qu'il produit.

---

## Identité

- **ID arc** : `A2-romance-emma`
- **Titre** : *La moitié biographique*
- **Position** : Acte II · semaine 2-3 · branche `A2-04E` (variante Emma du point d'entrée romance `A2-04`)
- **Durée estimée joueur** : 15-20 min

**Statut canon spécifique** : *Pseudo-romance — fusion-confusion non consommée.* Pas un arc de drague. La charge affective intense (cousines germaines, éloignement vécu, reconnexion adulte tardive via Julien) se retraduit en pacte fraternel par bascule cognitive — pas par interdit moral. Cf. `bible-jeu.md § 6` (Emma) + `internal/design-rules/pool-romance-pas-drague.md`. **Aucune variante FIN-E Emma : les fins Emma sont fraternelles uniquement (pacte scellé, sacrifice, rupture).**

---

## Préconditions (flags entrants)

```yaml
flag_emma_a_reveele: true            # depuis PRO-01
flag_a2_04_atteint: true             # gateway A2-04 ouverte
flag_a2_04e_eligible: true           # emma = premier PNJ-romance à atteindre seuil
relation_emma: ">= 40"               # seuil propre Emma — plus haut que les autres (+30) car la barre d'entrée biographique est lourde
mental_stability: ">= 2"             # sinon dialogues colorisés bloquent options
flag_emma_guide: "optionnel"         # depuis A1-01-confrontation ; améliore branche A si true
```

**Exclusivité** : pose `flag_a2_04_consomme = true` en entrée du beat 1, ce qui bloque les autres variantes `A2-04F/T/S/M/C/L/A` pour ce run.

---

## Beats (5)

| # | Titre | Lieu | PNJs | Tension |
|---|-------|------|------|---------|
| 1 | Surcharge des retrouvailles | coursive Saint-Michel · nuit | emma | montée |
| 2 | Le test biographique | cellule Margot | emma | montée |
| 3 | Nuit d'écoute (variante intime) | cellule Margot · 23h | emma (off · audible) · leo (off · audible) | montée |
| 4 | **PIVOT** — le geste qui se retraduit | appart Emma/Léo · Léo absent | emma | pic |
| 5 | Pacte ou rupture | appart Emma/Léo · matin | emma | chute |

### Détail des beats

**Beat 1 — Surcharge des retrouvailles** *(exposition, 0 choix)*
Emma trouve Margot seule dans la coursive après le dîner. Cigarette ou café tardif. Conversation banale de Saint-Michel qui dérive vers quelque chose d'intime sans qu'aucune ne le décide. Emma laisse échapper un fragment biographique d'avant la brouille — Margot constate intérieurement qu'elle ne le partage pas. *Règle d'écriture canon : aucun « tu te souviens quand on… ». L'intimité se construit à Saint-Michel.*
Pose `flag_a2_romance_emma_demarre = true`.

**Beat 2 — Le test biographique** *(confrontation moyenne, 3 choix)*
Le lendemain, Emma apporte un objet familial (lettre, album, bijou) chez Margot — geste de réparation. L'absence de souvenirs partagés se rend palpable.
- `[A]` Faire semblant de se souvenir → *mirror +10 · relation emma +5 (sur faux-semblant) · flag_emma_intimite_artificielle = true*
- `[B]` Avouer le trou de mémoire (sincérité) → *relation emma +15 · MS +1 · flag_emma_intimite_sincere = true*
- `[C]` Pivot pro : « Tu as ce souvenir parce que tu travailles à Memorize ? » → *EV +1 · relation emma -10 · mirror +5 · flag_emma_intimite_instrumentalisee = true*

**Beat 3 — Nuit d'écoute (variante intime)** *(moyenne, 3 choix · skippable si `flag_a1_05_passe = true`)*
23h. Margot, dans sa cellule, entend l'intimité Emma/Léo (cf. A1-05). Cette fois la résonance est différente parce qu'Emma vient de se livrer.
- `[A]` Écouter sciemment (collecte voyeuriste) → *EV +1 · mirror +10 · si découvert plus tard : relation emma -15*
- `[B]` Mettre des écouteurs, s'écarter → *MS +1*
- `[C]` Rejoindre Emma le lendemain et nommer ce qu'elle a entendu → *relation emma +5 si beat 2 = [B] · relation emma -10 sinon*

**Beat 4 — PIVOT : le geste qui se retraduit** *(dense, 3 choix · pic de tension)*
Appart Emma/Léo. Léo en déplacement Memorize (off-screen, 1 nuit). Conversation tardive bascule en proximité physique. Emma initie un geste ambigu (main qui s'attarde, regard prolongé, proximité corporelle).

> **Règle d'écriture canon (verrou)** : la bascule cognitive est INÉVITABLE côté Emma. Même si Margot pousse, Emma elle-même fait la bascule à un moment du beat. *La fusion-confusion n'est jamais consommée.* Cf. `bible-jeu.md` ligne 416.

- `[A]` Reconnaître et nommer la première : *« Tu es ma moitié biographique, pas mon amante »* → *flag_pacte_emma = true · relation emma +20 · MS +2 · désamorce proprement*
- `[B]` Reculer sans nommer (déni) → *flag_emma_distance = true · relation emma -15 · ouvre route rupture*
- `[C]` Répondre par le même geste sans nommer → *Emma elle-même fait la bascule cognitive (off-screen interne, jouée dans son silence puis son retrait). Résultat canonique inévitable : pas de fusion consommée, mais Margot a tenté et porte la charge.* → *mirror +20 · relation emma -10 · flag_emma_blessee = true*

**Beat 5 — Pacte ou rupture** *(résolution, 0-1 choix · 3 variantes selon flag beat 4)*
- *Si `flag_pacte_emma = true`* → **Pacte fraternel scellé**. Emma révèle Julien en détail — elle nomme le pattern de Margot. Devient sa sentinelle morale.
  - Pose `flag_emma_boussole = true`. Effet mécanique : *cap triggers internes Margot à 4/5 max* (Emma peut nommer à temps).
- *Si `flag_emma_distance = true`* → **Rupture froide**. Emma reste cousine, sans pacte, sans dialogue intime. Relation emma cappée à +30 pour le reste du run.
- *Si `flag_emma_blessee = true`* → **Conséquence honte**. Margot porte la charge. Emma reste alliée minimale (info Memorize) mais sans pacte. Mirror cumulé reste. Un choix unique : `[A]` s'excuser explicitement (*relation emma +10 · mirror -5 partiel·* ) ou `[B]` ne rien dire (*relation emma -5 · mirror inchangé*).

---

## Branches majeures

```
Beat 2 — choix Margot
├── [A] semblant         → mirror+10 · rel+5  · ferme partiellement [A]B4 (sincérité brisée)
├── [B] sincérité        → rel+15 · MS+1     · ouvre [A]B4 confortable
└── [C] pivot pro        → EV+1 · rel-10 · mirror+5

Beat 3 — choix Margot (skippable)
├── [A] écouter          → EV+1 · mirror+10
├── [B] s'écarter        → MS+1
└── [C] nommer           → rel+5 si B2=[B], sinon rel-10

Beat 4 — PIVOT
├── [A] nommer en 1er    → flag_pacte_emma · rel+20 · MS+2
├── [B] reculer          → flag_emma_distance · rel-15
└── [C] répondre+silence → flag_emma_blessee · mirror+20 · rel-10
                          (Emma fait la bascule, fusion jamais consommée)

Beat 5 — coda selon branche B4
[pacte]    → Julien nommé · flag_emma_boussole · cap triggers internes à 4/5
[distance] → Emma reste à +30 max · pas d'aide A3
[blessee]  → choix excuse / silence (mitigation mirror partielle)
```

**Contrainte canon vérifiée** : aucune branche ne mène à FIN-E Emma. La branche `[A]` du PIVOT n'est pas une « romance réussie » mais une **nomination réussie**.

---

## Postconditions (flags sortants)

```yaml
# Garantis (toutes branches) :
flag_arc_a2_romance_emma_termine: true
flag_a2_04_consomme: true              # bloque autres variantes A2-04

# Selon branche beat 2 :
flag_emma_intimite_artificielle: <bool>
flag_emma_intimite_sincere: <bool>
flag_emma_intimite_instrumentalisee: <bool>

# Selon branche beat 4 (PIVOT) :
flag_pacte_emma: <bool>          # uniquement si [A]
flag_emma_distance: <bool>       # uniquement si [B]
flag_emma_blessee: <bool>        # uniquement si [C]

# Conditionnel à [A] :
flag_emma_boussole: <bool>       # cap triggers internes Margot
flag_julien_pattern_nomme: <bool>
```

---

## Fins impactées

| Fin | Avant arc | Après arc |
|-----|-----------|-----------|
| **FIN-A** *La Reconstruction* | ouverte | renforcée si `[A]` (rel emma garantie >+50) · neutre `[B]` · fragile `[C]` |
| **FIN-B** *L'Exposé* | ouverte | renforcée si `[A]` (allié Emma confirmé) · ouverte `[B]/[C]` |
| **FIN-C** *Le Pacte de Sang* | ouverte | restée ouverte ; coût symbolique amplifié si `[A]` (sacrifier une boussole nommée) |
| **FIN-D** *L'Alliance Corporate* | ouverte | neutre |
| **FIN-E Emma** | ❌ **exclue canon** | ❌ **exclue canon** (verrou design — voir Notes auteur) |
| **FIN-F** *Les Mains Propres* | ouverte | fragile si `[C]` (mirror cumulé) |
| **FIN-G** *Le Silence* | ouverte | renforcée si `[C]` puis `[B]` au beat 5 (toutes relations<+40 plausible) |
| **FIN-H** *La Capture* | neutre | neutre |
| **FIN-I** *Julien* | ouverte | **affaiblie si `[A]`** : `flag_emma_boussole` cappe triggers internes à 4/5 (Emma nomme le pattern à temps) |

---

## NODES à produire

| NODE ID | Rôle | Complexité | Choix |
|---------|------|------------|-------|
| `A2-04E-01` | exposition (surcharge retrouvailles) | simple | 0 |
| `A2-04E-02` | confrontation (test biographique) | moyenne | 3 |
| `A2-04E-03` | confrontation (nuit d'écoute) — *skippable* | moyenne | 3 |
| `A2-04E-04` | **PIVOT** (geste qui se retraduit) | dense | 3 |
| `A2-04E-05A` | résolution branche pacte | moyenne | 0 |
| `A2-04E-05B` | résolution branche distance | simple | 0 |
| `A2-04E-05C` | résolution branche blessée | moyenne | 1 |

**Convention** : `A2-04E` désigne la variante Emma du gateway A2-04 ; le 3ᵉ segment indexe le beat (cf. nommage NODE défini dans `overview.md § Glossaire`). Les 3 variantes du beat 5 portent une lettre supplémentaire (A/B/C) qui reprend l'index du choix PIVOT.

---

## Personas concernés (pour `review-persona`)

- **Margot (joueuse)** : doit ressentir la *charge non-décidée*, pas une attirance verbalisée. Au beat 4, la bascule cognitive doit être un soulagement (branche A), une honte (branche C) ou un manque (branche B) — jamais un *fail romance*.
- **Dramaturge** : invariants à préserver — *fusion-confusion non consommée*, *pas de FIN-E Emma*, *Emma = boussole morale si pacte*, *triggers internes cappés si boussole*.
- **playtester-lgbtqia** *(OBLIGATOIRE, sensitivity reader)* : vérifier que la bascule cognitive du beat 4 ne tombe pas dans le tropé incestueux malaisant. La nomination doit lire en **désamorçage** (deux adultes qui se reconnaissent), pas en **interdit moral**. Cf. CLAUDE.md.
- **playtester-margot** : vérifier le consentement informationnel — Margot doit avoir conscience qu'elle s'engage dans une intensité affective, le geste du beat 4 ne doit pas surgir sans préparation des beats 1-3.

---

## Risques structurels (3)

1. **Tropé incestueux malaisant si écriture beat 4 dérape**. La canon dit *fusion-confusion par bascule cognitive*, pas *interdit moral*. Mitigation : passage obligatoire par `playtester-lgbtqia` + `dramaturge` + `playtester-margot` avant write-dtl. Une seule formule canon imposée à Margot en `[A]` : *« Tu es ma moitié biographique, pas mon amante »* — c'est la phrase qui prouve que le désamorçage est cognitif (deux adultes urbains post-conservateurs qui se reconnaissent), pas censorial.

2. **Branche `[C]` cumule mirror et peut bloquer FIN-A/B/F**. Si joueur enchaîne `[A]B2 → [A]B3 → [C]B4`, mirror cumulé peut excéder 60 (seuil hésitation) voire 90 (option verrouillée). Mitigation : beat 5 variante blessée offre un choix de mitigation partielle (excuse). Vérifier en `graph-audit` qu'aucune branche complète ne dépasse mirror +35 dans cet arc seul.

3. **Tentation de spec une FIN-E Emma malgré canon**. Anti-pattern explicitement listé dans `overview.md § Anti-patterns`. Tout reviewer doit refuser une PR qui introduit `FIN-E-emma` ou équivalent. Ce risque est doublé par la tentation *intuitive* (« 8 PNJ pool romance → 8 variantes FIN-E »). Rappel : pool romance = 8, FIN-E = 7 max (cf. overview tableau Variantes FIN-E).

---

## Notes auteur

- **La phrase canon de [A]B4 est verrouillée** : *« Tu es ma moitié biographique, pas mon amante »* (ou variante très proche, à valider en tone-finder). Elle doit apparaître dans `a2_romance_emma.dtl` ligne ~270 (estimation). C'est le hook moral de l'arc.
- **Emma = seule à pouvoir nommer Julien**. Si `flag_emma_boussole = true`, prévoir un beat de rappel en A3 où Emma intercepte Margot avant un trigger interne. Ce hook se spec dans `arc-spec A3` (P1 todo).
- **Léo absent au beat 4 — déplacement Memorize** : à coordonner avec `arc-spec A2-romance-leo` (P0 todo). Si les deux arcs Léo et Emma sont actifs simultanément, le déplacement de Léo doit être cohérent.
- **Skippabilité beat 3** : si `flag_a1_05_passe = true`, le NODE A2-04E-03 doit s'ouvrir directement sur l'option `[C]` (Margot a *déjà* entendu, il s'agit de décider quoi en faire) plutôt que de rejouer la scène d'écoute.
- **Témoin Léo** : Léo, à son retour, peut percevoir le pacte (ou la rupture) entre les cousines. Hook narratif pour `arc-spec A2-romance-leo` — si pacte fraternel scellé, Léo gagne `flag_leo_observe_pacte = true` qui module sa propre couche 1 (protection Emma).

---

## Validation locale (checklist)

- [x] Toutes les jauges mentionnées existent dans `variables-register.md` (MS, PD, EV, Mirror, Surveillance, relation_emma)
- [x] Toutes les factions citées sont parmi les 8 valides (memorize, stratom mentionnées)
- [x] Les fins citées sont parmi A-I (A, B, C, D, F, G, H, I — pas de FIN-E Emma : exclue canon)
- [x] Tous les NODES proposés ont un ID unique (A2-04E-01 à A2-04E-05C, 7 IDs distincts)
- [x] Aucune branche ne mène à un cul-de-sac sans flag de sortie (toutes branches posent au moins `flag_arc_a2_romance_emma_termine = true`)
- [x] Aucune branche ne mène à FIN-E Emma (vérification canon explicite — voir Risque #3)
