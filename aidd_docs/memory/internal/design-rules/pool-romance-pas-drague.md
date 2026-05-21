---
name: pool-romance-pas-drague
type: design-rule
scope: systeme
status: canon
description: Le pool A2-romance des 8 PNJ n'est PAS un menu de drague. C'est un pool de tensions affectives ambiguës — initiative variable, motivation variable, lisibilité variable, aboutissement non garanti. À respecter dans tout arc romance, dialogue, fiche PNJ.
---

# Pool A2-romance — tensions affectives, pas drague

8-MINE n'est pas un dating sim. Le mot « romance » dans `A2-romance-<pnj>` est une étiquette technique de pool — pas une promesse de jeu de séduction. Toute écriture concernant un arc romance doit respecter **quatre axes** (arbitrage auteur 2026-05-21).

## Les 4 axes canon

1. **Initiative variable** — l'arc peut s'amorcer parce qu'un PNJ fait un pas vers Margot (selon ses réactions passées dans le jeu), OU parce que Margot va vers le PNJ. Jamais un menu « choisis ton partenaire ». Le code et les `.dtl` ne doivent jamais présenter une liste de PNJ romance comme un choix explicite.

2. **Motivation variable côté Margot** — quand Margot prend l'initiative, c'est pour une raison parmi : **attirance réelle** · **calcul** (info, alliance, alibi) · **désamorçage** d'une tension qu'elle ne maîtrise plus · **besoin affectif circonstanciel** (fatigue, peur, solitude). Le moteur est rarement pur. Cohérent avec [[margot-terrain-neutre]] (Margot ne « drague » pas, elle navigue) et [[margot-documentariste-sincere]] (la double instrumentalisation N2 × Witness colore toute approche).

3. **Lisibilité variable** — un pas du PNJ peut être ambigu, soumis à interprétation joueur. Jamais étiqueté « avance romantique » par le système. Pas de prompt « Le PNJ X tente une approche romantique ». Le joueur lit un geste, une phrase, un silence ; il décide ce que c'est.

4. **Aboutissement non garanti** — la tension peut s'installer, se déplacer, se résoudre par autre chose (alliance pro, pacte fraternel, rupture définitive), ou ne jamais se résoudre. La FIN-E (« La Romance comme Sortie ») est une *fin parmi d'autres*, pas la conclusion attendue d'un arc romance.

## Why

Le user a explicitement signalé en 2026-05-21 : *« ce n'est pas un jeu de drague. certains PNJ, à des moments, et selon les réactions de Margot, pourront faire des pas vers elle, ou des actions soumises à interprétation, et à l'inverse Margot pourra choisir d'aller vers certains PNJ pour réduire une tension ou pour une attirance, ou par calcul. mais ce ne sera jamais simple. »*

Risque concret : si les `A2-romance-*` se traitent comme des arcs de dating sim (PNJ disponible, Margot draguer, romance scellée), le ton bascule et le jeu perd son registre — thriller cyberpunk sociologique, pas otome game. La règle complète [[margot-terrain-neutre]] : même quand Margot prend l'initiative, c'est calcul ou réaction, pas séduction décidée.

## How to apply

Dans tout brainstorm, arc-spec, `.dtl` ou review concernant un arc `A2-romance-*` :

- (a) **jamais de menu de choix de partenaire** dans les UI ou les dialogues — pas d'écran « avec qui souhaitez-vous développer une relation ? » ;
- (b) **les approches PNJ → Margot sont ambiguës par défaut** — pas d'auto-tagging « romance détectée », le joueur interprète ; le système peut tracker un `FLAG_TENSION_<pnj>` mais pas un `FLAG_ROMANCE_PROPOSEE` ;
- (c) **les approches Margot → PNJ doivent passer par un motif** — toujours offrir une option où Margot va vers le PNJ pour autre chose (info, désamorçage, alibi) que la séduction frontale ; la charge affective vient *par-dessus*, pas seule ;
- (d) **les fins romance (FIN-E variantes) ne sont jamais le défaut d'un arc** — elles surviennent quand une tension trouve une sortie particulière, pas comme aboutissement attendu ; un arc romance qui ne se résout *pas* en romance est canon, pas un échec ;
- (e) **vocabulaire d'écriture** : préférer *tension*, *attirance*, *charge*, *pas*, *geste*, *ambiguïté* — éviter *romance acquise*, *partenaire*, *conquête*, *développer une relation* ;
- (f) **vérifier persona `playtester-margot`** : aucune branche ne doit transformer Margot en draguante stratège ni en « cible romance disponible » ;
- (g) **cas spéciaux** : Sofia (refusée par défaut, branche trahison opt-in — cf. [[sofia-kessler-caracterisation]]), Emma (fusion-confusion non-consommée — pas une romance qui aboutit), Camille (dark cogni-affectif — la tension est instrumentalisée, jamais sincère des deux côtés). Documentés dans `overview.md` § Acte II tableau pool romance.

## Implication structurelle

Le tableau `overview.md` § pool romance n'est pas une *liste d'options pour le joueur* — c'est une *carte de tensions possibles*. Toute documentation publique du jeu (pitch, presse, devlog) doit respecter ce cadrage : on parle de « tensions affectives ambiguës », pas de « 8 routes romance ».
