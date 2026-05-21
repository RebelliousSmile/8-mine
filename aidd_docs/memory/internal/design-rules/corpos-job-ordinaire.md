---
name: corpos-job-ordinaire
type: design-rule
scope: pnj
status: canon
description: Règle de design — les 8 PNJ font leur job (pas de mission secrète) ; culture corpo réactive les rancœurs en contexte pro mais la cohabitation longue normalise les rapports en quotidien. Les 8 sont des agents importants, pas des subalternes.
---

# Corpos — job ordinaire, pas missions secrètes

## Pas de « missions secrètes »

Les 8 PNJ résidents n'ont reçu **aucun ordre spécial** concernant Margot. Ils **font leur job** — profilage (Camille), scan biométrique passif (Alex), audit éthique (Sofia), design surveillance (Léo), maintenance Kaizen (Thomas), performance marketing (Marine), analyse flux (Emma), évaluation Stratom (Frank) — plus leurs **ambitions personnelles d'agents corporatistes**. Le job s'applique à Margot par défaut parce qu'elle est dans leur périmètre professionnel. L'instrumentalisation vient du *quotidien professionnel exécuté sur une cible*, pas d'un complot.

## Statut professionnel des 8 — agents importants *(user 2026-05-21)*

Saint-Michel est un immeuble prestigieux dans une zone stratégique négociée — aucune corpo n'y enverrait des employés moyens. Les 8 sont des **agents importants avec responsabilités significatives**, leur présence prouve leur poids interne.

**Tension d'écriture à tenir** : **fragilité visible au quotidien ≠ inexpérience ou poste subalterne**. Marine n'est pas une influenceuse junior ; Thomas n'est pas un ingé subalterne ; Léo n'est pas un designer débutant ; Emma n'est pas analyste premier niveau ; les 4 Tier 2 (Camille, Frank, Sofia, Alex) sont cadres senior. En contexte pro, chacun a un *vrai pouvoir d'action* : signer un contrat, autoriser un audit, débloquer un accès, ordonner une intervention.

## Culture corpo vs cohabitation longue (deux registres)

- **Vie quotidienne** : après des mois ensemble, les résidents ont **dépassé** les clivages corpo au niveau perso. Repas partagés, entraide, conversations banales — registre normalisé.
- **Travail / dossier sensible** : la culture corpo réactive les **rancœurs héritées** (Memorize/Stratom prédictif vs coercitif, Kaizen méprise Nexus, Nexus méfie Memorize). Même personne, deux registres selon le contexte. La ligne corpo revient à la surface chez l'agent dès qu'un audit, une demande hiérarchique, ou un scan est en jeu.

## Why

Arbitrages 2026-05-21 du user :
- (a) *« margot les voit dans leur vie quotidienne, ils n'ont pas de mission à proprement parler, juste leur job, qui peut être plus ou moins avouable, et évidemment leurs ambitions personnelles : ce sont des agents corporatistes. »*
- (b) *« il y a une culture d'entreprise qui fait que les agents corporatistes sont poussés à prendre la ligne de conduite de leur corpo… pour des gens qui vivent ensemble depuis des mois, ils ont au niveau personnel surement dépassé ces clivages. ca n'empêche pas que le travail peut les amener à faire ressortir des rancoeurs corpo. »*

Cette règle évite que l'écriture dérive vers une intrigue d'espionnage (chaque PNJ avec sa « mission Margot ») et garde la thèse sociologique du jeu : le pouvoir s'exerce par le *travail ordinaire*, pas par le complot.

## How to apply

- (a) Dans tout `arc-spec` ou `.dtl`, ne JAMAIS écrire « Stratom missionne Camille pour profiler Margot ». Écrire à la place : « Camille fait son job de profileuse Stratom, Margot est par défaut dans son périmètre ». Idem pour les 7 autres.
- (b) Modeler **deux registres** par PNJ dans les beats : registre *quotidien normalisé* (cuisine, terrasse, soir) vs registre *job réactivé* (réunion technique, audit, scan, dossier). La bascule contextuelle est un signal narratif que Margot apprend à lire.
- (c) Les frictions inter-corpos (canon `bible-jeu.md` § 4) ne s'expriment **pas** comme conflits perso entre résidents (ils s'entendent au quotidien) mais ressortent **quand le travail les ramène** — Sofia auditant Memorize, Léo refusant un accès à Camille, etc.
- (d) Les **ambitions personnelles** des 8 PNJ sont la vraie surface narrative à creuser, plus que les ordres reçus : Emma veut monter sans casser le lien avec Margot ; Marine veut tenir l'audit ; Camille veut monter dans Stratom ; etc. Lié à `margot-terrain-neutre.md` : action PNJ par défaut = poursuite de leurs ambitions sur le terrain Margot.
