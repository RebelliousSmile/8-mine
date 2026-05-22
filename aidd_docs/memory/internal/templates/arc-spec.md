# Arc Specification — `<ARC_ID>`

> Sortie du prompt `arc-spec`. Entrée du prompt `decompose-arc`.
> Contrat de l'arc : ce qu'il consomme, ce qu'il produit.

---

## Identité

- ID arc : `<PRO · A1 · A2-romance-leo · A3-mains-propres · FIN-D…>`
- Titre : `<titre éditorial>`
- Position : `<acte · scène>`
- Durée estimée joueur : `<X-Y min>`

## Préconditions (flags entrants)

```yaml
flag_emma_a_reveele: true       # depuis PRO-01
flag_dossier_ouvert: false      # n'a pas encore été ouvert
mental_stability: ">= 2"        # contrainte gauge
```

## Beats (3-7)

| # | Titre | Lieu | PNJs | Tension |
|---|-------|------|------|---------|
| 1 | `<incident déclencheur>` | `<lieu>` | `<emma>` | montée |
| 2 | `<confrontation>` | `<lieu>` | `<emma, frank>` | pic |
| … | | | | |

## Branches majeures

```
Beat 3 — choix Margot
├── [A] coopère avec Emma   → flag_pacte_emma=true · MS-1
├── [B] refuse                → MS+1 · ferme romance_emma
└── [C] joue double-jeu      → miroir+10 · ouvre FIN-G
```

Pour chaque branche : effets sur les jauges (MS, PD, EV, Surveillance, Miroir, Réputation, Countdowns) et fins ouvertes/fermées.

## Postconditions (flags sortants)

```yaml
# Garantis après l'arc, quelle que soit la branche :
flag_arc_<ARC>_termine: true

# Selon branche :
flag_pacte_emma: <bool>
flag_strategie_double_jeu: <bool>
```

## Fins impactées

| Fin | Avant arc | Après arc |
|-----|-----------|-----------|
| FIN-A | ouverte | ouverte si [B] |
| FIN-G | fermée | ouverte si [C] |

## NODES à produire

| NODE ID | Rôle | Complexité | Choix |
|---------|------|------------|-------|
| `<ARC>-01` | exposition | simple | 0 |
| `<ARC>-02` | confrontation | dense | 3+ |
| `<ARC>-03` | résolution | moyenne | 1-2 |

## Personas concernés (pour `review-persona`)

- **Margot (joueuse)** : ce qu'elle doit ressentir à chaque beat
- **Dramaturge** : invariants à préserver (stakes, arc émotionnel, fins)

## Notes auteur

`<…>`
