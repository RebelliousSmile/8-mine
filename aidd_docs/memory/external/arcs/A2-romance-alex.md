# Arc Specification — `A2-romance-alex`

> Sortie du prompt `arc-spec`. Entrée du prompt `decompose-arc`.
> Contrat de l'arc : ce qu'il consomme, ce qu'il produit.

---

## Identité

- **ID arc** : `A2-romance-alex`
- **Titre** : *La tension qui ne se consomme pas*
- **Position** : Acte II · semaine 2-3 · branche `A2-04A` (variante Alex du point d'entrée romance `A2-04`)
- **Durée estimée joueur** : 15-20 min en branche DEFAULT · 20-28 min en branche OPT-IN

**Statut canon spécifique** : *Romance refusée par défaut + branche trahison opt-in verrouillée.* L'arc se conclut sans franchissement physique dans la branche `[A]` du PIVOT — alliance opérationnelle profonde, tension perçue par Sofia mais jamais consommée. La branche `[B]` est explicitement opt-in : verrouillée par `EV ≥ 4` ET choix joueur conscient. Si déclenchée, Alex bascule **seul**, Sofia blessée *en intimité* (pas en posture pro — cf. `sofia-kessler-caracterisation` § force pro ≠ force intime). Cf. `bible-jeu.md § Alex Norvège` + `history.md L928` (trancheage 2026-05-21).

---

## Préconditions (flags entrants)

```yaml
flag_emma_a_reveele: true            # depuis PRO-01
flag_a2_04_atteint: true             # gateway A2-04 ouverte
flag_a2_04a_eligible: true           # alex = premier PNJ-romance à atteindre seuil
relation_alex: ">= 30"
mental_stability: ">= 2"

# Optionnel — colorie l'arc si présent :
flag_alex_double_agent: <bool>       # depuis A2-01B (révélation Emma) si EV permet
```

**Exclusivité** : pose `flag_a2_04_consomme = true` en entrée du beat 1, ce qui bloque les autres variantes `A2-04F/T/S/M/C/E/L` pour ce run.

**Verrou supplémentaire branche [B] (opt-in)** : déclenchable uniquement si `EV >= 4 AND flag_alex_double_agent = true` au moment du beat 4. Sinon l'option `[B]` est *grisée/désactivée* (mécanique standard projet).

---

## Beats (5 + variante coda à 2 temps en branche B)

| # | Titre | Lieu | PNJs | Tension |
|---|-------|------|------|---------|
| 1 | Reconnaissance professionnelle | poste technique partagé | alex | montée |
| 2 | La proximité technique | poste technique nuit | alex (sofia mentionnée off) | montée |
| 3 | Sofia perçoit (et ne dit rien) | zone commune jour | alex, sofia *(témoin silencieux)* | montée ambiguë |
| 4 | **PIVOT** — le moment où ça pourrait basculer | poste technique tardif | alex | pic |
| 5A | Coda DEFAULT : alliance opérationnelle confirmée | zone commune jour | alex, sofia | chute |
| 5B.1 | Coda BETRAYAL temps 1 : la bascule | poste technique tardif | alex | pic prolongé |
| 5B.2 | Coda BETRAYAL temps 2 : conséquence Sofia | appart Sofia/Alex matin | sofia, alex *(off)* | chute lourde |

### Détail des beats

**Beat 1 — Reconnaissance professionnelle** *(exposition, 0 choix)*
Alex propose à Margot un accès technique qu'elle ne devrait pas avoir (par exemple : un canal annexe pour vérifier les bio-flux en circulation). Ce n'est pas une avance romantique — c'est une reconnaissance qu'ils sont du *même côté technique* malgré leurs étiquettes corpo. Margot perçoit Alex comme **collègue de fortune** avant de le percevoir comme autre chose.
Pose `flag_a2_romance_alex_demarre = true` et `flag_a2_04_consomme = true`.

**Beat 2 — La proximité technique** *(confrontation moyenne, 2 choix)*
Poste de travail partagé, nuit. Alex et Margot manipulent les mêmes données. La proximité physique devient lisible.
- `[A]` Accepter l'alliance, garder distance pro → *flag_alex_alliance_pro = true · EV+1 · relation:alex:+10*
- `[B]` Tester la proximité (geste discret, regard prolongé) → *flag_alex_proximite_testee = true · MS-1 · relation:alex:+5*

> **Verrou de design** : pas de troisième option « rejeter ». Margot ne refuse pas une alliance utile à ce stade — le choix porte sur le *ton*, pas sur le principe.

**Beat 3 — Sofia perçoit (et ne dit rien)** *(exposition variante, 0 choix forcés)*
Zone commune, jour. Margot et Sofia se croisent au moment où Alex passe. Sofia *voit* la tension. Elle salue, normalement. Elle passe.

> **Verrou d'écriture canon** : Sofia n'est *jamais* jalouse, *jamais* confrontante, *jamais* victime. Elle est *lucide*. C'est exactement ce qui rend la tension impossible à consommer sans rupture.

Variante selon flag beat 2 :
- Si `flag_alex_alliance_pro` : Sofia donne un regard de remerciement *(perçoit qu'Alex est protégé)*
- Si `flag_alex_proximite_testee` : Sofia donne un regard *neutre, légèrement appuyé — non-confrontant mais lucide* (Margot encaisse intérieurement)

Pose `flag_sofia_a_percu_tension = true` dans tous les cas. Pas de delta jauges en lecture frontale.

**Beat 4 — PIVOT : le moment où ça pourrait basculer** *(dense, 2 choix · `[B]` verrouillé)*
Poste technique tardif. Alex et Margot seuls. Une fenêtre s'ouvre : Alex est *vulnérable* (fatigue, charge mentale double-loyauté), Margot est *consciente* du pouvoir qu'elle a.

> **Verrou canon central** : Alex ne franchira pas de lui-même. Le pouvoir de bascule est entièrement côté Margot. Cf. `bible-jeu.md L516`.

- `[A]` Honorer le verrou Sofia (ne pas pousser) → *flag_alex_verrou_honore = true · MS+2 · relation:alex:+15 · alliance approfondie sans franchissement*
- `[B]` Pousser Alex à trahir Sofia *(verrouillé : nécessite `EV >= 4 AND flag_alex_double_agent = true`)* → *flag_pousse_alex_trahir = true · mirror+25 · branche OPT-IN trahison*

**Beat 5A — Coda DEFAULT** *(résolution simple, 0 choix)*
Lendemain. Margot, Alex, Sofia se croisent en zone commune. Alex remercie discrètement (pas verbal — un regard, un café partagé). Sofia salue Margot avec *respect*. L'alliance opérationnelle est scellée sans avoir traversé l'intime.
Pose `flag_alex_allie_op = true` et `flag_sofia_alex_couple_intact = true`.

**Beat 5B.1 — Coda BETRAYAL temps 1 : la bascule** *(résolution simple, 0 choix · branche [B] uniquement)*
Même nuit. Alex bascule — pas par désir équivalent, par épuisement de la triple loyauté + pression Margot. Le moment est *décrit en ellipse* : le baiser ou le geste consommé n'est jamais montré explicitement. La caméra (narration) reste sur le visage d'Alex au moment où il franchit — *visage défait, pas illuminé*.

> **Phrase canon Alex (verrouillée)** : *« Je n'aurais pas dû. Je ne vais pas le lui cacher. »* (formulation exacte ou très proche, à valider en `tone-finder`). C'est ce qui distingue cette bascule d'une « romance gagnée ».

Pose `flag_alex_bascule_seul = true` et `flag_alex_franchi = true`.

**Beat 5B.2 — Coda BETRAYAL temps 2 : conséquence Sofia** *(résolution moyenne, 1 choix · branche [B] uniquement)*
Matin. Appart Sofia/Alex. Alex a dit la vérité à Sofia *(off-screen — verrou Alex transparence)*. Sofia confronte Margot en intimité — pas en posture éthique pro.

> **Verrou d'écriture canon** : Sofia *ne perd pas sa posture pro*. La blessure est *intime*. Elle est *blessée comme conjointe*, pas *fragilisée comme éthicienne*. Au boulot le lendemain, elle restera l'autorité éthique inattaquable. La scène doit lire ainsi. Cf. `sofia-kessler-caracterisation`.

- `[A]` Reconnaître la responsabilité (« j'ai poussé ») → *flag_margot_assume_trahison = true · mirror-5 · relation:sofia:-25 · relation:alex:-15*
- `[B]` Se défendre / minimiser → *flag_margot_nie_trahison = true · mirror+10 · relation:sofia:-40 · relation:alex:-25*

Pose `flag_sofia_blessee_intime = true` et `flag_couple_sofia_alex_brise = true` dans tous les cas.

---

## Branches majeures

```
Beat 2 — choix Margot
├── [A] alliance pro      → flag_alex_alliance_pro · EV+1 · rel+10
└── [B] proximité testée  → flag_alex_proximite_testee · MS-1 · rel+5

Beat 3 — Sofia perçoit (variante automatique selon B2)
└── (aucun choix · pose flag_sofia_a_percu_tension)

Beat 4 — PIVOT
├── [A] honorer verrou Sofia    → flag_alex_verrou_honore · MS+2 · rel+15
│        → Beat 5A (coda DEFAULT)
└── [B] pousser à trahir         → VERROU : EV >= 4 AND flag_alex_double_agent
         flag_pousse_alex_trahir · mirror+25
         → Beat 5B.1 puis 5B.2 (coda BETRAYAL 2 temps)

Beat 5B.2 — choix Margot (uniquement branche B)
├── [A] assumer       → mirror-5 · rel:sofia:-25 · rel:alex:-15
└── [B] se défendre   → mirror+10 · rel:sofia:-40 · rel:alex:-25
```

**Contrainte canon vérifiée** : la branche `[A]` du PIVOT *n'est pas* une « romance ratée » mais une *alliance opérationnelle approfondie*. La branche `[B]` *n'est pas* une « romance réussie » mais une *trahison consommée*.

---

## Postconditions (flags sortants)

```yaml
# Garantis (toutes branches) :
flag_arc_a2_romance_alex_termine: true
flag_a2_04_consomme: true
flag_sofia_a_percu_tension: true

# Selon branche beat 2 :
flag_alex_alliance_pro: <bool>
flag_alex_proximite_testee: <bool>

# Selon branche beat 4 (PIVOT) :
flag_alex_verrou_honore: <bool>      # uniquement si [A]
flag_pousse_alex_trahir: <bool>      # uniquement si [B]

# Conditionnel à [A] beat 4 :
flag_alex_allie_op: <bool>           # alliance opérationnelle confirmée
flag_sofia_alex_couple_intact: <bool>

# Conditionnel à [B] beat 4 :
flag_alex_bascule_seul: <bool>
flag_alex_franchi: <bool>
flag_sofia_blessee_intime: <bool>
flag_couple_sofia_alex_brise: <bool>
flag_margot_assume_trahison: <bool>  # selon choix 5B.2
flag_margot_nie_trahison: <bool>     # selon choix 5B.2
```

---

## Fins impactées

| Fin | Avant arc | Après arc DEFAULT [A] | Après arc OPT-IN [B] |
|-----|-----------|------------------------|----------------------|
| **FIN-A** *La Reconstruction* | ouverte | renforcée (Alex+Sofia alliés stables) | fragilisée (rel sofia < +50 plausible) |
| **FIN-B** *L'Exposé* | ouverte | renforcée (≥1 allié op confirmé) | possible si Emma reste à +50, sinon fermée |
| **FIN-C** *Le Pacte de Sang* | ouverte | neutre | neutre |
| **FIN-D Nexus* *L'Alliance Corporate* | ouverte | renforcée (Sofia/Alex deal possible ensemble) | fermée (couple brisé, deal impossible) |
| **FIN-E Alex** | fermée par défaut | **fermée** (verrou honoré — pas de FIN-E sans franchissement) | **ouverte** si `flag_alex_franchi + relation:alex >= 60 + MS >= 3` |
| **FIN-F** *Les Mains Propres* | ouverte | renforcée (MS+2) | **fermée** (mirror+25 cumulé) |
| **FIN-G** *Le Silence* | ouverte | neutre | renforcée si `[B]` 5B.2 (rel:sofia et rel:alex effondrées) |
| **FIN-H** *La Capture* | neutre | neutre | légèrement aggravée *(Alex peut alerter Stratom — voir Risque #2)* |
| **FIN-I** *Julien* | ouverte | neutre | **renforcée** (mirror+25 = 1 trigger interne |

---

## NODES à produire

| NODE ID | Rôle | Complexité | Choix |
|---------|------|------------|-------|
| `A2-04A-01` | exposition (reconnaissance pro) | simple | 0 |
| `A2-04A-02` | confrontation (proximité technique) | moyen | 2 |
| `A2-04A-03` | exposition variante (Sofia perçoit) | simple | 0 |
| `A2-04A-04` | **PIVOT** (le moment où ça pourrait basculer) | dense | 2 *(dont `[B]` verrouillé par condition)* |
| `A2-04A-05A` | coda DEFAULT (alliance confirmée) | simple | 0 |
| `A2-04A-05B-1` | coda BETRAYAL temps 1 (bascule Alex) | simple | 0 |
| `A2-04A-05B-2` | coda BETRAYAL temps 2 (conséquence Sofia) | moyen | 1 (binaire) |

**Convention** : `A2-04A` désigne la variante Alex du gateway A2-04 ; le 3ᵉ segment indexe le beat. Les variantes B5 portent un suffixe `-1` / `-2` pour la coda à 2 temps (cas unique dans le pool romance).

---

## Personas concernés (pour `review-persona`)

- **Margot (joueuse)** : doit ressentir le PIVOT comme un *seuil moral*, pas comme un *seuil érotique*. La branche `[A]` doit lire en **lucidité adulte**, pas en frustration. La branche `[B]` doit lire en **violation consciente** (Margot sait ce qu'elle fait), pas en élan irrépressible.
- **Dramaturge** : invariants à préserver — *Alex ne franchit jamais de lui-même*, *Sofia n'est jamais jalouse*, *Sofia garde sa posture pro même blessée intime*, *couple intact en branche A par défaut*.
- **playtester-lgbtqia** *(OBLIGATOIRE, sensitivity reader)* : vérifier qu'en branche `[B]`, Sofia ne soit pas réduite à sa douleur de personnage trans. La blessure est *conjugale*, pas *identitaire*. Sa réaction reste adulte, posée, autorité intacte.
- **playtester-margot** : vérifier consentement informationnel — le PIVOT doit avoir été *préparé* par les beats 2-3, jamais surgir comme tentation cachée. La option `[B]` doit être *clairement irrévocable* à la sélection.
- **Sofia (persona PNJ)** : sa voix dans 5B.2 doit rester *Sofia* — pas une variante effondrée. *Analytique → blessée → protectrice (envers Alex, pas envers elle-même)*. Cf. `sofia-kessler-caracterisation`.

---

## Risques structurels (3)

1. **Branche `[A]` lue comme « romance ratée »** par des joueurs habitués au « tout est accessible ». Mitigation : le beat 3 (Sofia perçoit) doit fonctionner comme *signal narratif clair* — pas un obstacle, une *présence calme* qui rend la consommation absurde. La coda 5A doit lire en **alliance scellée**, pas en consolation. Vérifier en review-persona Margot.

2. **Branche `[B]` lue comme « romance gagnée »** plutôt que comme trahison consommée. Mitigation : la phrase canon d'Alex en 5B.1 (*« Je n'aurais pas dû. Je ne vais pas le lui cacher. »*) doit apparaître textuellement, et la coda 5B.2 est **obligatoire** (pas de skip). De plus, FIN-E Alex requiert `relation:alex >= 60` après 5B.2 — quasi-impossible à atteindre avec les pénalités (5B.2 retire 15-25 points selon choix). Donc FIN-E Alex est *techniquement* ouverte mais *narrativement très étroite*. C'est conforme au verrou canon (« opt-in verrouillée »).

3. **Sofia réduite à sa douleur en branche `[B]`**. Risque persona trans. Mitigation : la scène 5B.2 doit montrer Sofia *en intimité* (chez elle, en peignoir, café) mais sa *parole reste structurée* — pas larmes, pas effondrement, pas confidence inappropriée. *« Tu savais ce que tu faisais. Je ne te demande pas pardon, je te demande de partir. »* — registre canon possible. Passage obligatoire `playtester-lgbtqia` + `sofia-kessler-caracterisation` + `dramaturge` avant write-dtl. Coordonner avec `arc-spec A2-romance-sofia` si jamais ce dernier est aussi spec (cohérence du couple Sofia/Alex à maintenir).

---

## Notes auteur

- **La phrase canon de 5B.1 est verrouillée** : *« Je n'aurais pas dû. Je ne vais pas le lui cacher. »* (formulation exacte ou très proche). C'est le hook moral de la branche opt-in — elle prouve qu'Alex respecte le verrou de transparence dans son couple *même dans la trahison*.
- **Verrou EV ≥ 4 sur `[B]` du PIVOT** : protège contre une bascule prématurée. Le joueur doit avoir fait du *travail d'enquête* avant de pouvoir pousser Alex à la trahison. Sans EV ≥ 4, l'option apparaît grisée avec un tooltip explicatif (« Tu n'as pas assez d'éléments pour le déstabiliser »).
- **Sofia blessure intime ≠ blessure pro** : verrou design absolu. Si une scène ultérieure (A3, A4) montre Sofia défaillante en posture éthique parce qu'Alex l'a trahie, c'est une violation canon à refuser en review. La blessure intime peut affecter Sofia *en privé*, *jamais au boulot*.
- **Coordination avec autres arcs** :
  - `arc-spec A2-romance-sofia` (à spec) : doit déclarer son comportement si Margot a déjà déclenché branche `[B]` ici (Sofia connait Margot comme trahison ; arc Sofia probablement bloqué).
  - `arc-spec A3` (P1 todo) : si branche `[B]`, Stratom peut tenter d'exploiter Alex fragilisé. Hook à prévoir.
- **Alliance opérationnelle (5A)** : pose `flag_alex_allie_op = true` qui débloque une ressource concrète en A3-A4 (aide Alex sur dossier Stratom interne, comparable à FIN-E Frank).

---

## Validation locale (checklist)

- [x] Toutes les jauges mentionnées existent dans `variables-register.md` (MS, PD, EV, Mirror, relation_alex, relation_sofia)
- [x] Toutes les factions citées sont parmi les 8 valides (nexus, stratom mentionnées implicitement)
- [x] Les fins citées sont parmi A-I (A, B, C, D, E Alex *(opt-in)*, F, G, H, I — FIN-E Alex explicitement opt-in)
- [x] Tous les NODES proposés ont un ID unique (A2-04A-01 à A2-04A-05B-2, 7 IDs distincts)
- [x] Aucune branche ne mène à un cul-de-sac sans flag de sortie (toutes posent `flag_arc_a2_romance_alex_termine = true`)
- [x] Verrou opt-in `[B]` du PIVOT correctement déclaré (`EV >= 4 AND flag_alex_double_agent`)
- [x] Sofia jamais en posture pro défaillante (verrou design respecté)
