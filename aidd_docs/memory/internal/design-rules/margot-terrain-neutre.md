---
name: margot-terrain-neutre
type: design-rule
scope: protagoniste
status: canon
description: Règle de design centrale — Margot n'est pas un personnage qui dérive, c'est un terrain où les PNJ agissent. Défaut sans choix joueur = manipulation par PNJ. Mirror mesure l'instrumentalisation subie.
---

# Margot — terrain neutre, pas dérive

**Margot n'est pas une protagoniste qui « dérive vers l'instrumentalisation »**. C'est l'inverse : Margot est un **terrain neutre** sur lequel les PNJ exercent leur métier (profilage, test, scan biométrique, séduction, manipulation). Le défaut sans action joueur consciente = **les PNJ mènent**.

**Conséquence mécanique** : chaque interaction est un duel asymétrique — soit Margot agit (et le joueur arbitre l'usage de ce qu'elle découvre), soit elle subit (et le PNJ prend l'avantage : Camille profile, Sofia scrute, Frank teste, Alex scanne biométriquement, etc.). Mirror [0-100] mesure le **ratio d'instrumentalisation subie**, pas la dérive interne de Margot.

**À implémenter** : tout choix de dialogue ayant un fallback « ne rien dire / observer / esquiver » doit déclencher une **action PNJ par défaut** (modification relation au gré du PNJ, captation d'info, hausse Surveillance ou Mirror selon le levier exploité). Pas de no-op silencieux. Mirror ne monte JAMAIS sur action involontaire externe (Règle 2 connexe : pression Witness/Stratom peut être refusée, coûts en PD/faction/contrat — pas en Mirror).

## Why

Arbitrage explicite du user 2026-05-21 lors du brainstorm `overview.md`. Cette inversion change la lecture des arcs : la romance Margot×PNJ_marié n'est pas « Margot intrude » mais « le PNJ utilise Margot comme outil de sortie de couple ». Sofia profile Margot autant que Margot profile Sofia. Camille séduit *en* profilant. Frank teste en silence. Sans cette règle, l'écriture dérive vers une Margot active/voyeuse — ce qui rate la thèse du jeu (la documentariste est elle-même documentée).

## How to apply

- (a) Chaque `[choice]` dans un .dtl doit avoir au moins une option « subir/observer/esquiver » qui déclenche un effet *PNJ-driven* (relation, surveillance, mirror, info captée), pas un no-op.
- (b) Dans les arc-specs, déclarer pour chaque beat : *quelle action PNJ par défaut* si Margot ne pousse pas.
- (c) Mirror ne monte que sur action joueur confirmée — vérifier qu'aucun signal `[signal arg="miroir:+N"]` n'est posé en branche « pression externe acceptée sous contrainte ».
- (d) Au moment d'écrire les romances : 6 PNJ en couple = chaque romance Margot×PNJ_marié est aussi une **manipulation du PNJ envers Margot** (chacun a une raison de sortir de son couple via Margot). Concevoir les arcs en double-jeu, pas en intrusion unilatérale.
