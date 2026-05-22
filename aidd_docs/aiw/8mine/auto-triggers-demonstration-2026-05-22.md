# Démonstration auto-triggers persona-trainer + tone-finder

> Démonstration des conditions de déclenchement automatique sur les 2 reviews historiques (v1 naïve + v2 recalibrée) de `diner_arrivee.dtl`.
> Date : 2026-05-22

---

## Review v1 (naïve, 17.75 ± 0.7) — auto-triggers qui auraient été déclenchés

### ⚙ persona-trainer — TRIGGER ACTIVÉ : Concordance étroite ET indulgente

**Condition** : 4 personas convergent à 17.75 ± 0.7 ET score moyen ≥ 17/20 → calibration suspecte *(trigger #1 review-persona.prompt.md Step 8)*

**Persona ciblé** : *tous les 4*, mais en priorité celui qui a le score le plus haut sans faiblesse 🟠+ trouvée *(dramaturge 18.5/20, playtester-cyberpunk 18/20)*

**Findings 🟠+ manqués qui auraient été à ancrer** *(découverts en v2 recalibrée)* :

| Persona | Finding manqué v1 | À ancrer en craft checklist |
|---------|-------------------|-----------------------------|
| Dramaturge | Scope jauges déterminisme par sujet non documenté | *« vérifier que chaque sujet a un delta jauge déterministe par cap d'utilisation »* |
| Playtester LGBTQIA+ | Pronom Julien/Julie potentiellement hardcodé | *« grep des prénoms ex hardcodés ; cross-check ExProfileManager »* |
| Playtester Visual Novel | Saturation menu 10 sujets simultanés | *« compter les options visibles dans le menu post-choix forcé ; > 6 = scène-tunnel décisionnelle »* |
| Playtester Visual Novel | Amnésie PNJ aucune référence PRO-02 | *« grep des références aux flags amont par les PNJ ; absence systématique = ancrage 7/20 »* |
| Playtester Cyberpunk | Augmentations Alex sans coût porté | *« grep détails somatiques sur les PNJ augmentés ; absence = ancrage 11/20 »* |

**Modifications proposées aux YAMLs personas** :
- `dramaturge.yml` v1.1 → v1.2 : ajout craft checklist *« vérifier déterminisme deltas »*
- `playtester-lgbtqia.yml` v1.0 → v1.1 : ajout craft checklist *« grep prénoms hardcodés »*
- `playtester-visual-novel.yml` v1.1 → v1.2 : ajout craft checklist *« compter options menu post-choix »* + *« grep références flags amont »*
- `playtester-cyberpunk.yml` v1.1 → v1.2 : ajout craft checklist *« grep détails somatiques sur augmentés »*

### 🎨 tone-finder — TRIGGER NON ACTIVÉ

**Condition #1** : output-style `scenario` n'a que 1 `.dtl` produit *(diner_arrivee)* → seuil 3 non atteint
**Condition #2** : aucun reviewer n'a flag *« voix uniforme »* en v1 *(ils étaient trop kind)*
**Condition #3** : output-style à v1.0, pas stale *(< 5 .dtl)*
**Condition #4** : pas de pattern lexical mécanique détecté avec un seul `.dtl`

**Verdict** : aucun trigger tone-finder. Output-style `scenario.md` reste à v1.0.

---

## Review v2 (recalibrée, 14 ± 0.5) — auto-triggers qui se déclenchent

### ⚙ persona-trainer — TRIGGER NON ACTIVÉ

**Condition #1** : concordance 14 ± 0.5 mais score < 17 → pas d'indulgence
**Condition #2** : plafond automatique enclenché par 🟠+ chez chaque persona → pas d'indulgence
**Condition #3** : pas de finding signalé "missed" *(la review v2 est la première recalibrée, pas de rétroaction utilisateur)*
**Condition #4** : recherche active déclarée par les 4 personas → pas d'indulgence

**Verdict** : ✅ les personas v2 ont **trouvé les findings**. La calibration fonctionne. Aucun re-training nécessaire à cette itération.

### 🎨 tone-finder — TRIGGER NON ACTIVÉ *(toujours)*

Mêmes conditions qu'en v1 — seuil échantillon non atteint *(1 `.dtl` seulement)*.

---

## Conclusion sur les auto-triggers

✅ **Le mécanisme aurait correctement identifié le problème v1** *(persona-trainer trigger #1)* sans intervention utilisateur. Le signal *« scores trop bons pour un premier passage »* aurait été détecté automatiquement.

✅ **Le mécanisme se comporte correctement post-recalibration** *(aucun trigger inutile en v2)*. Pas d'over-engineering.

⚠ **Tone-finder dort tant que < 3 `.dtl` produits**. Le 2ème `.dtl` à produire *(probablement `cellule_nuit.dtl`)* ne déclenchera pas tone-finder. Le 3ème *(probablement un appart ou autre récurrente)* déclenchera tone-finder automatiquement sur `scenario.md`.

---

## Prochaines vraies invocations attendues

| Moment | Trigger probable | Auto-déclenche |
|--------|------------------|-----------------|
| Après écriture `cellule_nuit.dtl` *(2ème .dtl)* | Si reviewer flag « voix uniforme entre Margot et narrator » | tone-finder *(condition #2 lexical reviewer)* |
| Après écriture du 3ème `.dtl` *(typiquement appart_emma_leo ou autre)* | Échantillon statistique de 3 `.dtl` atteint | tone-finder *(condition #1 seuil)* |
| Si une review future est notée 18+ sans 🟠 trouvé | Recherche active non déclarée | persona-trainer *(condition #4)* |
| Si l'utilisateur signale « ce finding manqué » sur une review | Rétroactif | persona-trainer *(condition #3)* |

Le workflow est désormais **auto-correctif** : les outils d'amélioration s'invoquent eux-mêmes quand le bruit dépasse le signal.
