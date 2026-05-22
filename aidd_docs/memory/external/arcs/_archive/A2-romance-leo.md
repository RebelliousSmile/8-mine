# Arc Specification — `A2-romance-leo`

> Sortie du prompt `arc-spec`. Entrée du prompt `decompose-arc`.
> Contrat de l'arc : ce qu'il consomme, ce qu'il produit.

---

## Identité

- **ID arc** : `A2-romance-leo`
- **Titre** : *Les couches d'un homme fatigué*
- **Position** : Acte II · semaine 2-3 · branche `A2-04L` (variante Léo du point d'entrée romance `A2-04`)
- **Durée estimée joueur** : 18-25 min (varie selon coloration)

**Statut canon spécifique** : *Arc à 3 colorations selon couches percées de l'agenda Léo.* Devient possible **uniquement** quand Margot a perçé la couche 1 (protection d'Emma à son insu) ou la couche 2 (coup personnel sur les flux Memorize) de l'agenda Léo. Le ton, les choix, les fins varient selon les couches percées au moment de l'entrée dans l'arc. Cf. `bible-jeu.md § Léo Mars` + `history.md L932` (trancheage 2026-05-21).

---

## Préconditions (flags entrants)

```yaml
flag_emma_a_reveele: true            # depuis PRO-01
flag_a2_04_atteint: true             # gateway A2-04 ouverte
flag_a2_04l_eligible: true           # leo = premier PNJ-romance à atteindre seuil
relation_leo: ">= 30"
mental_stability: ">= 2"

# AU MOINS UN des deux requis pour entrer dans l'arc :
flag_leo_couche_1_percee: <bool>     # Margot a compris que Léo protège Emma à son insu
flag_leo_couche_2_percee: <bool>     # Margot a compris que Léo a un coup personnel sur les flux Memorize
```

**Verrou d'entrée** : `flag_leo_couche_1_percee OR flag_leo_couche_2_percee`. Sans aucune couche percée, l'arc reste inaccessible — la coloration de surface (lassitude esthétique) ne suffit pas à ouvrir le pool romance Léo.

**Provenance des flags de couche** *(à spec dans arcs amont)* :
- `flag_leo_couche_1_percee` : posé via A1-01-confrontation `[D]` *(alliance Léo + bonnes questions)* OU via A2-01B *(croisement avec révélations Emma)*.
- `flag_leo_couche_2_percee` : posé via `flag_acces_flux_leo = true` *(de A1)* combiné à `EV ≥ 3` et examen direct des logs.

---

## Coloration d'entrée

Calculée au beat 1 selon les flags d'entrée :

| Coloration | Condition | Ton dominant |
|------------|-----------|--------------|
| **A — Solidaire** | `couche_1 AND NOT couche_2` | Margot voit le protecteur. Léo ne sait pas qu'elle voit. Tonalité : *complicité tendre, asymétrique* |
| **B — Asymétrique** | `couche_2 AND NOT couche_1` | Margot voit l'ambition. Léo croit qu'elle voit la protection. Tonalité : *ambiguïté contrôlée, jeu de masque* |
| **C — Pleine ambiguïté** | `couche_1 AND couche_2` | Margot voit tout. Léo le sait. Plus de masque. Tonalité : *adultes lucides face à une situation impossible* |

Le flag de coloration (`flag_leo_coloration_A/B/C`) est posé au beat 1 et conditionne le contenu des beats suivants.

---

## Beats (5)

| # | Titre | Lieu | PNJs | Tension |
|---|-------|------|------|---------|
| 1 | Aveu mutuel *(variante par coloration)* | atelier Léo | leo | montée |
| 2 | Le pacte d'écriture | poste Memorize partagé | leo | montée |
| 3 | Emma observe *(automatique)* | zone commune jour | leo, emma *(témoin silencieux)* | montée ambiguë |
| 4 | **PIVOT** — la nuit du choix | atelier Léo · nuit | leo | pic |
| 5 | Coda selon branche PIVOT (3 variantes) | variable | leo *(+ emma off selon branche)* | chute |

### Détail des beats

**Beat 1 — Aveu mutuel** *(exposition variante, 0 choix)*
Atelier Léo (espace créatif privé, plein d'esquisses, écrans éteints). Léo dépose son masque selon la coloration :
- *Coloration A* : Léo dit, presque à demi-mot, qu'il *« protège des choses qu'on ne devrait pas avoir à protéger »*. Margot révèle qu'elle a compris pour Emma. Léo encaisse — silence long. Pose `flag_leo_coloration_A = true`.
- *Coloration B* : Léo croit que Margot a compris la protection d'Emma (couche 1). Margot a en réalité vu autre chose (le coup personnel). Margot **choisit ou pas de laisser l'illusion** — *implicite, pas verbalisé*. Pose `flag_leo_coloration_B = true`.
- *Coloration C* : Tout est sur la table. Léo n'a plus de masque. *« Tu sais déjà tout. Qu'est-ce que tu veux que je te dise ? »* Pose `flag_leo_coloration_C = true`.

Pose dans tous les cas : `flag_a2_romance_leo_demarre = true` et `flag_a2_04_consomme = true`.

**Beat 2 — Le pacte d'écriture** *(moyen, choix variables selon coloration)*
Poste Memorize partagé, accès aux flux. Léo propose un échange de service.

*Coloration A — 2 choix :*
- `[A]` Renforcer la protection d'Emma (Margot couvre Léo) → *flag_leo_pacte_protection_renforce = true · MS+1 · relation:leo:+10*
- `[B]` Refuser de s'engager (Léo doit faire seul) → *relation:leo:-5 · MS+1*

*Coloration B — 3 choix :*
- `[A]` Accepter le deal Léo en silence (complicité opportuniste) → *flag_leo_deal_accepte = true · EV+2 · mirror+10 · relation:leo:+10*
- `[B]` Confronter Léo sur ce qu'elle voit vraiment → *flag_leo_couche_2_avouee = true · relation:leo:-15 *(brièvement, voir 5B)*
- `[C]` Refuser le deal sans tout dévoiler → *relation:leo:-5 · MS+1*

*Coloration C — 3 choix :*
- `[A]` Proposer un pacte explicite (couple-conspirateurs Margot/Léo) → *flag_leo_couple_conspirateurs_propose = true · mirror+5 · relation:leo:+15*
- `[B]` Forcer Léo à choisir entre Emma et son coup personnel → *flag_leo_force_arbitrage = true · MS-1 · relation:leo:-10*
- `[C]` Se retirer froidement → *flag_leo_retrait_lucide = true · relation:leo:-20*

**Beat 3 — Emma observe** *(exposition variante, 0 choix forcé)*
Zone commune, jour. Margot et Léo se croisent. Emma est là. *Verrou canon : « Emma le surveille »* — Weakness Tag activé. Emma voit la nouvelle dynamique. Variant :
- Si `flag_a2_romance_emma_demarre = true` et pacte fraternel scellé (`flag_pacte_emma`) : Emma intercepte Margot en privé, *« Qu'est-ce que tu cherches avec Léo ? »* — registre boussole morale.
- Sinon : Emma observe en silence, regard prolongé. Pose `flag_emma_alertee_leo = true`.

Pas de delta direct. Module les fins via cumul.

**Beat 4 — PIVOT : la nuit du choix** *(dense, choix variables)*
Atelier Léo, nuit. Emma absente (réunion Memorize tardive, mentionnée off). Léo et Margot seuls.

*Verrou canon* : Léo n'est pas le verrouilleur (contrairement à Alex). Léo est *disponible* — c'est ce qui rend le choix lourd. Margot porte toute la responsabilité du franchissement (ou non).

*Coloration A — 2 choix :*
- `[A]` Sceller l'alliance protectrice sans intimité (priorité Emma) → *flag_leo_pacte_protection_scelle = true · MS+2 · relation:leo:+20 · ne consomme PAS la romance*
- `[B]` Consommer l'intimité solidaire → *flag_leo_intimite_solidaire = true · mirror+10 · relation:leo:+25*

*Coloration B — 3 choix :*
- `[A]` Maintenir l'illusion (Léo continue de croire qu'elle voit seulement la protection) → *flag_leo_illusion_maintenue = true · mirror+15 · relation:leo:+15*
- `[B]` Briser l'illusion maintenant (« Je sais pour ton coup ») → *flag_leo_illusion_brisee = true · relation:leo:-25 · ouvre coda confrontation*
- `[C]` Consommer sans rien clarifier → *flag_leo_intimite_floue = true · mirror+20 · relation:leo:+10 · charge cognitive lourde*

*Coloration C — 3 choix :*
- `[A]` Pacte couple-conspirateurs scellé (intimité + collaboration) → *flag_leo_couple_conspirateurs_scelle = true · mirror+10 · relation:leo:+25*
- `[B]` Dénoncer Léo à Emma (avant qu'il soit trop tard) → *flag_leo_denonce_a_emma = true · EV+1 · relation:leo:-40 · relation:emma:+15 si pacte fraternel actif*
- `[C]` Retrait lucide sans dénonciation → *flag_leo_retrait_lucide_final = true · MS+1 · relation:leo:-15*

**Beat 5 — Coda selon branche** *(résolution, 3 variantes principales avec sous-variantes)*

Le NODE de coda à déployer dépend de la branche du PIVOT *et* de la coloration d'entrée. Voir tableau récapitulatif en section *NODES à produire* — 7 NODES coda distincts.

---

## Branches majeures

```
Coloration calculée au Beat 1 :
A (couche 1 seule)  → arbre 2-choix dans B2 et B4
B (couche 2 seule)  → arbre 3-choix avec dimension illusion/confrontation
C (les deux couches) → arbre 3-choix avec dimension dénonciation

Beat 4 PIVOT — branches typiques :
[A] (toutes colorations) → pacte / alliance / couple → coda intégrative
[B] (toutes colorations) → confrontation ou intimité solidaire → coda à risque
[C] (B et C seulement)   → ambiguïté ou retrait → coda froide
```

**Contrainte canon vérifiée** :
- Aucune branche ne consomme l'intimité **sans** mirror+ (Léo est marié à Emma, intrusion conjugale assumée par canon).
- Branche dénonciation `[B]` coloration C est *la seule* qui sauve Emma directement via Margot — mais coûte Léo entièrement.

---

## Postconditions (flags sortants)

```yaml
# Garantis (toutes branches) :
flag_arc_a2_romance_leo_termine: true
flag_a2_04_consomme: true
flag_leo_coloration_A | flag_leo_coloration_B | flag_leo_coloration_C: true  # exactement un

# Selon branche PIVOT — exemples non exhaustifs :
flag_leo_pacte_protection_scelle: <bool>      # A.[A]
flag_leo_intimite_solidaire: <bool>            # A.[B]
flag_leo_illusion_maintenue: <bool>            # B.[A]
flag_leo_illusion_brisee: <bool>               # B.[B]
flag_leo_intimite_floue: <bool>                # B.[C]
flag_leo_couple_conspirateurs_scelle: <bool>   # C.[A]
flag_leo_denonce_a_emma: <bool>                # C.[B]
flag_leo_retrait_lucide_final: <bool>          # C.[C]

# Dérivés :
flag_leo_allie_emma: <bool>          # vrai si pacte protection ou couple-conspirateurs
flag_leo_compromis: <bool>           # vrai si intimité consommée quelle que soit coloration
```

---

## Fins impactées

| Fin | Coloration A | Coloration B | Coloration C |
|-----|--------------|--------------|--------------|
| **FIN-A** | renforcée si `[A]` | fragilisée *(mirror cumulé)* | renforcée si `[B]` (Emma sauvée) ; fermée si `[A]` (mirror+10+10) |
| **FIN-B** | renforcée si `[A]` (allié Léo) | possible mais coût | renforcée si `[B]` |
| **FIN-C** | neutre | risque accru si `[B]` *(Léo confronté → ré-équilibre)* | possible si `[B]` (Emma sauvée mais Léo perdu) |
| **FIN-D Memorize** | renforcée si `[A]` (deal Memorize-interne possible via Léo) | fermée si `[B]` | renforcée si `[A]` couple-conspirateurs |
| **FIN-E Léo** | **ouverte** si `[B]` ET `relation:leo >= 60` (intimité solidaire pleine) | **ouverte** si `[A]` ou `[C]` ET conditions secondaires *(complicité opportuniste pousse FIN-E vers une coloration trouble — voir Notes auteur)* | **ouverte** si `[A]` ET conditions secondaires *(couple-conspirateurs = FIN-E la plus pleine et la plus sombre)* |
| **FIN-F** | renforcée si `[A]` (mains propres, alliance sans intimité) | fermée *(mirror cumulé)* | mixte |
| **FIN-G** | possible si rejet `[B]` initial | renforcée si `[B]` *(rupture)* | renforcée si `[C]` retrait |
| **FIN-H** | neutre | neutre | légèrement aggravée si Léo exposé *(Memorize peut riposter)* |
| **FIN-I** | possible si mirror cumulé | aggravée *(mirror plus haut)* | aggravée si `[A]` couple-conspirateurs |

> **3 colorations × 3 variantes FIN-E Léo** — c'est la singularité canon de cet arc. FIN-E Léo n'est **pas une fin** au sens monolithique, c'est *trois fins* selon la coloration. Cf. `overview.md § Variantes FIN-E`.

---

## NODES à produire

| NODE ID | Rôle | Complexité | Choix |
|---------|------|------------|-------|
| `A2-04L-01` | exposition aveu mutuel *(3 variantes texte selon coloration)* | simple | 0 |
| `A2-04L-02-A` | pacte d'écriture · coloration A | moyen | 2 |
| `A2-04L-02-B` | pacte d'écriture · coloration B | dense | 3 |
| `A2-04L-02-C` | pacte d'écriture · coloration C | dense | 3 |
| `A2-04L-03` | Emma observe *(variante automatique selon flag_pacte_emma)* | simple | 0 |
| `A2-04L-04-A` | PIVOT · coloration A | moyen | 2 |
| `A2-04L-04-B` | PIVOT · coloration B | dense | 3 |
| `A2-04L-04-C` | PIVOT · coloration C | dense | 3 |
| `A2-04L-05-A1` | coda A.[A] pacte protection | simple | 0 |
| `A2-04L-05-A2` | coda A.[B] intimité solidaire | moyen | 1 |
| `A2-04L-05-B1` | coda B.[A] illusion maintenue | moyen | 1 |
| `A2-04L-05-B2` | coda B.[B] illusion brisée (confrontation) | dense | 2 |
| `A2-04L-05-B3` | coda B.[C] intimité floue | moyen | 1 |
| `A2-04L-05-C1` | coda C.[A] couple-conspirateurs | dense | 2 |
| `A2-04L-05-C2` | coda C.[B] dénonciation à Emma | dense | 2 |
| `A2-04L-05-C3` | coda C.[C] retrait lucide | simple | 0 |

**Total : 16 NODES.** C'est l'arc le plus large du pool romance — cohérent avec sa singularité canon (3 colorations × 3 branches). Cf. `overview.md § Variantes FIN-E Léo`.

**Convention** : `A2-04L-NN-X` où `X ∈ {A, B, C}` indexe la coloration ou la branche PIVOT selon le segment.

---

## Personas concernés (pour `review-persona`)

- **Margot (joueuse)** : doit ressentir Léo comme *fatigué authentiquement, pas méprisable*. Sa lassitude est une vraie posture sociale, pas un déguisement transparent. Les 3 colorations doivent lire en *différentes textures de manipulation mutuelle*, jamais en *moralisme*.
- **Dramaturge** : invariants à préserver — *Léo a un agenda à 3 couches non-réductibles*, *Emma le surveille (Weakness Tag)*, *Emma reste boussole morale si pacte scellé en `A2-romance-emma`*.
- **playtester-margot** : vérifier que le joueur comprend dans quelle coloration il joue (signal narratif clair au beat 1). Une coloration imposée sans signal = arc cassé.
- **Léo (persona PNJ)** : voix canon = *lassitude cultivée + lucidité piquante*. Pas cynique. Pas amer. *Fatigué qui s'amuse encore par défi intellectuel*. Cf. registre vocal `bible-jeu.md` table L560-568.
- **Emma (persona PNJ)** : si pacte fraternel actif (`flag_pacte_emma`), Emma intercepte au beat 3 — sa voix doit être *boussole morale*, pas *jalousie de cousine*. Verrou design : Emma ne défend pas son couple — elle protège Margot d'un faux pas.

---

## Risques structurels (3)

1. **Coloration confuse pour le joueur**. Risque que le joueur ne sache pas pourquoi il est en coloration A vs B vs C — donc lit les choix sans contexte. Mitigation : le beat 1 doit ouvrir par une *réplique de Léo qui signale la coloration* (« Tu as compris pour Emma. » = A · « Tu as vu plus que ce que je voulais montrer. » = B · « Tu sais tout. Je n'ai plus rien à protéger. » = C). Vérifier en review-persona Margot que la coloration est *lisible dès la première minute*.

2. **FIN-E Léo en 3 variantes — risque de production trop large**. 16 NODES + 3 codas FIN-E distinctes en aval (A4-FIN-E-leo-A/B/C). Mitigation : *prioriser FIN-E Léo coloration C* (couple-conspirateurs) comme variante canon principale dans la production initiale, marquer A et B comme *« P2 ; à brainstormer si bande passante »*. Documenter dans `overview.md § Production todos`.

3. **Intrusion conjugale + Emma surveille = risque cascade narrative**. Si branche `[B]` coloration C (dénonciation à Emma) déclenchée pendant que `A2-romance-emma` est aussi actif, Emma reçoit l'info pendant son arc — interaction inter-arcs non triviale. Mitigation : déclarer une *règle de séquence* — `A2-romance-emma` doit être terminé (un de ses 3 codas posés) avant que `A2-romance-leo` n'atteigne son beat 5. Sinon, `flag_leo_denonce_a_emma` se buffer et Emma le découvre au beat 5A de son propre arc. *Coordination à valider dans graph-audit.*

---

## Notes auteur

- **Trois colorations = trois textures de Léo, pas trois Léo différents**. Le personnage est unifié, ce sont les *informations partagées avec Margot* qui colorient la dynamique. En réécriture, garder la même voix Léo dans les trois colorations.
- **FIN-E Léo coloration C couple-conspirateurs = la plus dense et la plus sombre**. C'est la fin où Margot a *tout vu*, *tout compris*, et a *choisi* d'épouser le projet de Léo plutôt que de le freiner. Mirror cumulé important. Pose `flag_couple_conspirateurs_avec_leo = true` qui doit conditionner la coda A4 spécifique (à spec dans `arc-spec FIN-E-leo-C`).
- **Verrou Emma** : si `flag_pacte_emma = true` (Emma boussole morale), elle DOIT intercepter au beat 3. Si `flag_emma_distance = true` ou `flag_emma_blessee = true`, elle observe en silence (pas d'interception). La présence/absence d'Emma comme conscience morale est *le signal* du sérieux de l'arc.
- **Coordination avec `A2-romance-emma`** : la résolution de l'arc Emma colorie l'arc Léo *via Emma elle-même* (témoin actif vs passif au beat 3). Documenter dans `arc-spec A2-romance-emma` un *hook outbound* : si `flag_pacte_emma = true`, exposer un point d'interception pour les autres arcs.
- **Coordination avec `A2-romance-alex`** : si branche `[B]` opt-in trahison déclenchée dans Alex (couple Sofia/Alex brisé), Margot a perdu un repère moral parallèle — la branche `[A]` coloration C de Léo (couple-conspirateurs) devient *narrativement plus probable* pour un joueur déjà engagé dans la transgression. Pas de blocage mécanique, mais signal de cohérence à monitorer en QA.

---

## Validation locale (checklist)

- [x] Toutes les jauges mentionnées existent dans `variables-register.md` (MS, PD, EV, Mirror, relation_leo, relation_emma)
- [x] Toutes les factions citées sont parmi les 8 valides (memorize implicite)
- [x] Les fins citées sont parmi A-I (A, B, C, D, E Léo *(3 variantes)*, F, G, H, I)
- [x] Tous les NODES proposés ont un ID unique (16 IDs distincts A2-04L-01 à A2-04L-05-C3)
- [x] Aucune branche ne mène à un cul-de-sac sans flag de sortie (toutes posent `flag_arc_a2_romance_leo_termine = true`)
- [x] Verrou d'entrée coloration correctement déclaré (`couche_1 OR couche_2`)
- [x] FIN-E Léo en 3 variantes documentée (cohérent avec overview)
- [x] Coordination avec `A2-romance-emma` et `A2-romance-alex` notée (Notes auteur)
