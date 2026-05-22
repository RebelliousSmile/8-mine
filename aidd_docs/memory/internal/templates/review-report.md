# Review Report — `<ARC_ID>`

> Sortie consolidée de `review-persona`. Entrée du triage `doctor` / `write-dtl --feedback`.
> Un rapport par arc, consolidant les personas.

---

## Métadonnées

- Arc : `<ARC_ID>`
- NODES analysés : `<liste>`
- Personas : `<margot-joueuse, dramaturge>`
- Date : `<YYYY-MM-DD>`
- Linter status : `<PASS · WARN · FAIL>` (depuis `dtl_linter.gd`)

---

## Matrice NODE × Persona × Branche

| NODE | Branche | 🎭 Margot | 🎭 Dramaturge | Triage |
|------|---------|-----------|---------------|--------|
| PRO-02 | [A] micros | 14/20 — crédible mais brutal | 16/20 — stakes posés | 🟢 patch |
| PRO-02 | [B] refus | 12/20 — manque tension | 15/20 — fin A préservée | 🟡 rewrite |
| PRO-02 | [C] confrontation | 17/20 | 14/20 — ouvre trop tôt | 🟢 patch |
| PRO-02 | [D] miroir | 11/20 — choix flou | 10/20 — incohérent arc | 🔴 systémique |

**Légende triage :**
- 🟢 **Patchable** (score ≥ 14 sur les deux) → `doctor.prompt.md` (patchs ciblés)
- 🟡 **Structurel** (un score 11-13) → rewrite local du NODE/branche
- 🔴 **Systémique** (un score ≤ 10 ou divergence > 4) → retour `arc-spec` / `decompose-arc`

---

## Section 1 — Verbatims persona Margot

> Format : chaque branche, 3 lignes max. Crédibilité dialogue, tension, choix non-évident.

**PRO-02 [A]** : « Margot pose les micros trop facilement. Ses mains devraient trembler. La ligne *"Emma est devenue impossible"* sonne juste mais la suivante désamorce la tension. Le choix n'est pas non-évident — y a-t-il vraiment un risque si elle accepte ? »

**PRO-02 [B]** : `<…>`

---

## Section 2 — Verbatims persona Dramaturge

> Format : invariants de l'arc, beats, stakes, fins ouvertes/fermées.

**PRO-02 [A]** : « Stakes correctement posés (PD+1, MS-1). Ferme FIN-A et FIN-F comme prévu dans arc-spec. Mais le beat 2 (confrontation Emma) arrive sans préparation — il manque un signal de doute en beat 1. »

**PRO-02 [B]** : `<…>`

---

## Section 3 — Actions à prendre

### 🟢 Patchable (doctor surgical)

```
@aidd_docs/aiw/prompts/workshop/doctor.prompt.md dialogic/timelines/pro_cellule.dtl
  --target "PRO-02 [A] beat 1-2"
  --fix "ajouter signal de doute avant confrontation Emma"
```

### 🟡 Structurel (rewrite local)

```
/dialogic-draft fix aidd_docs/memory/external/nodes/02.md
  --target "PRO-02 [B]"
  --feedback "branche refus manque de tension narrative"
```

### 🔴 Systémique (retour `arc-spec` / `decompose-arc`)

```
PRO-02 [D] : le choix "miroir" n'est pas justifié à ce stade.
  → revoir arc-spec : retirer [D] de PRO-02, le replacer en A1-01-stratege.
```

---

## Divergence check

Pour chaque branche, écart-type Margot ↔ Dramaturge :
- Si **|Margot - Dramaturge| > 4** → réévaluer, le triage est suspect.
- Exemple PRO-02 [C] : Margot 17, Dramaturge 14 → écart 3, OK.
- Exemple PRO-02 [D] : Margot 11, Dramaturge 10 → consensus rouge clair.

---

## Plateau check

Si après 1 itération de rewrite le triage reste majoritairement 🟡/🔴 :
- **STOP** la review automatique.
- Demander un **playtest papier** (autorité finale).
- Mettre l'arc en `Playtest ⏳` dans `etat-prod.md`.
