# Review Report — PRO-02 La Cellule

**Date** : 2026-05-21
**Fichier reviewé** : `dialogic/timelines/pro_cellule.dtl`
**Spec source** : `aidd_docs/memory/external/nodes/02.md`
**Linter** : ✅ PASS (aucune erreur, aucun warning)

---

## Matrice de scoring

| Branche | Margot | Dramaturge | Divergence | Verdict consolidé |
|---------|--------|------------|------------|-------------------|
| [A] Installer micros | 15.6/20 🟢 | **9.5/20 🔴** | **6.1** | 🔴 systémique |
| [B] Laisser matériel | 15.1/20 🟡 | **10.0/20 🔴** | **5.1** | 🔴 systémique |
| [C] Confronter Emma | 12.6/20 🟡 | 12.0/20 🟡 | 0.6 | 🟡 structurel |
| [D] Stratégie miroir | 13.7/20 🟡 | 12.0/20 🟡 | 1.7 | 🟡 structurel |

**Plateau check** : ❌ Aucune branche 🟢. Le NODE est globalement défaillant.
**Divergence check** : ⚠️ Branches [A] et [B] divergent > 4 points → indicateur de faille
systémique, pas de désaccord de goût.

---

## Verdict global : 🔴 SYSTÉMIQUE — retour Stage 3

La review révèle une cause racine **infrastructurelle** qui invalide la majorité
des effets narratifs promis par `nodes/02.md` :

### Faille 1 — DialogicBridge ne supporte pas `ms:` ni `pd:`

`nodes/02.md` spécifie pour chaque branche des deltas MS (mental_stability) et PD
(personal_danger). Or `DialogicBridge._on_signal_event()` ne connaît que 8
dispatchers : `relation`, `flag`, `decision`, `lieu`, `surveillance`, `miroir`,
`reputation`, `countdown`. **Les jauges canon `mental_stability` et
`personal_danger` ne sont pas modifiables depuis une timeline.**

Conséquence : le `.dtl` posté pour PRO-02 ne pose aucun delta MS/PD, alors que
la spec en exige sur les 4 branches. Le linter ne peut pas le détecter (il ne
connaît pas la spec). C'est invisible mécaniquement mais ruine la
caractérisation narrative.

### Faille 2 — Précondition `flag_emma_a_reveele` jamais testée

`nodes/02.md` exige `flag_emma_a_reveele = true` en entrée. Le `.dtl` se
contente d'un commentaire ; aucun `{if {flag_emma_a_reveele}}` ne protège
l'entrée. Si PRO-01 ne pose pas le flag (cas d'une branche qui le rate), PRO-02
joue quand même comme si Emma avait révélé.

### Faille 3 — Branche [B] structurellement vide

Branche [B] (« Laisser le matériel ») ne pose qu'un `flag:flag_micros_poses:false`
et une `decision:` — aucun effet jauges. La spec prévoit MS+1 (calme retrouvé).
Avec la Faille 1, ce delta est de toute façon impossible à poser. Résultat : la
branche **morale** du NODE est mécaniquement indifférente.

### Faille 4 — Pronoun hardcodé en [D]

Margot : *« J'ai écrit exactement ce qu'il aurait écrit. »* — « il » présuppose
un ex masculin. `ExProfileManager` permet un ex non-binaire ou féminin. Devrait
être conditionnel sur `{ex_genre}` ou utiliser une formulation neutre.

---

## Détail par branche

### Branche [A] — Installer les micros

**Margot 15.6/20 🟢**

- Crédibilité dialogue : 16/20 — voix interne authentique
- Tension narrative : 17/20 — le geste est lourd, le rappel de l'ex porte
- Choix non-évident : 15/20 — coût (devenir comme l'ex) lisible
- Sous-texte : 14/20 — bien, mais la chemise comme cachette est un cliché

Verbatims notables :
- « *Il gardait un journal de mes habitudes dans son téléphone. Il appelait ça
  de la « documentation ». C'est exactement ce que je suis en train de faire.* »
  → frappe juste. C'est ce qui fait le poids du choix.

**Dramaturge 9.5/20 🔴**

- Préconditions 8/20 : non testées explicitement
- Postconditions 12/20 : flag + decision OK, mais `surveillance:+5` et
  `miroir:+5` posés alors que la spec dit PD+1 / MS-1 (deux jauges *différentes*)
- Cohérence jauges 6/20 : `nodes/02.md` parle MS/PD, le `.dtl` parle
  surveillance/miroir. **Confusion canon vs mécanique.**
- Fins 12/20 : la transition `lieu:a1_zone_commune` est correcte
- Beats 10/20 : la scène saute directement au geste sans tension de décision

### Branche [B] — Laisser le matériel

**Margot 15.1/20 🟡** — la voix est juste mais la scène est trop brève.
**Dramaturge 10.0/20 🔴** — **aucune jauge n'est modifiée**. Branche morte
mécaniquement.

### Branche [C] — Confronter Emma

**Margot 12.6/20 🟡** — l'aparté « voix normale, pour les micros » est habile,
mais le déclencheur (Margot qui retourne dans le couloir) est mince
psychologiquement.
**Dramaturge 12.0/20 🟡** — `relation:emma:-3` correct, mais le `.dtl` redirige
vers `a1_confrontation_emma` (NODE inexistant — premier point bloquant pour
implémenter l'Acte 1).

### Branche [D] — Stratégie miroir

**Margot 13.7/20 🟡** — l'écriture du carnet est bien, le retour de la voix
ironique fonctionne.
**Dramaturge 12.0/20 🟡** — `miroir:+10` posé (bien), mais pronom « il »
hardcodé, et la spec demande PD+1 non posé.

---

## Actions par triage

### 🔴 Systémique (Faille 1) — DialogicBridge

**Décision à prendre** : ajouter les dispatchers `ms:` et `pd:` à
`DialogicBridge.gd`, ou reformuler `nodes/02.md` pour n'utiliser que
surveillance/miroir.

**Recommandation** : **ajouter ms:/pd: à DialogicBridge**. Raisons :
1. `mental_stability` et `personal_danger` sont des jauges canon
   (`GameStateManager`), pas des hacks.
2. La spec `nodes/02.md` (et probablement toutes les nodes/) raisonne en
   MS/PD — reformuler 30+ nodes est plus coûteux qu'ajouter 2 handlers.
3. Cohérence avec les 8 dispatchers existants : `surveillance`/`miroir` modifient
   des managers dédiés, `ms`/`pd` modifieraient `GameStateManager` directement.

Implémentation : ~20 lignes dans `DialogicBridge.gd` + ajout à `dtl_linter.gd`
(`DISPATCHERS_VALIDES`) + doc dans `api-cheatsheet.md`.

### 🔴 Systémique (Faille 2) — Précondition non testée

Le `.dtl` doit s'ouvrir sur :
```
{if not {flag_emma_a_reveele}}
  _: [i]ERREUR : PRO-02 lancé sans Emma_révélée. Retour PRO-01.[/i]
  [signal arg="lieu:pro_arrivee"]
{endif}
```
Ou — préférable — la transition `lieu:pro_cellule` ne doit être posée que par
les branches PRO-01 où `flag_emma_a_reveele` est vrai. À arbitrer Stage 3.

### 🟡 Structurel (Faille 3) — Branche [B] vide

Une fois `ms:` disponible : poser `[signal arg="ms:+1:soulagement_refus"]` dans
[B] pour matérialiser le soulagement spec.

### 🟡 Structurel (Faille 4) — Pronom hardcodé

Remplacer en [D] par : *« J'ai écrit exactement ce que cette personne aurait
écrit. »* ou conditionnel `{if {ex_genre} == "f"}…{else}…{endif}`.

---

## Bilan du pipeline (méta)

Le trial PRO-02 a fait son travail : la review a **détecté en amont** une faille
qui n'apparaîtrait qu'à l'écriture des Actes I–IV (toutes les nodes raisonnent
en MS/PD). Le coût d'ajout des 2 dispatchers est ~30min ; le coût de découvrir
ce manque après écriture de 20 timelines serait massif.

**Validation du pipeline** : ✅
- Stage 4 (`03-write-dtl`) produit un `.dtl` lintable.
- Stage 5 (`04-review-persona`) détecte ce que le linter rate.
- La divergence Margot/Dramaturge > 4 points est bien un signal de faille
  structurelle, pas de désaccord de goût.

**Prochain pas** : trancher DB-08 (dispatchers fictifs `bg:`/`show_char:`/
`goto_scene:`) et ajouter `ms:`/`pd:` dans la même PR sur `DialogicBridge`,
puis re-Stage 4 sur PRO-02 avec `--feedback`.
