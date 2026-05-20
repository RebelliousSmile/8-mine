# Mécaniques 8-MINE

> Règles métier des systèmes de jeu. Le « pourquoi » des chiffres
> et des comportements documentés dans
> [`API_PUBLIQUE.md`](API_PUBLIQUE.md).

## Ton et univers

Thriller cyberpunk contemporain. Le PJ est journaliste indépendante
qui enquête sur Stratom, conglomérat soupçonné d'écouter ses propres
employés. Elle est sous surveillance croissante. Elle traverse un
deuil amoureux récent : son ex revient en flashbacks et en échos
narratifs (système ExProfile).

## Countdowns

Compteurs croissants. Chaque tick → conséquence narrative.

### Canon

| ID | Max | Description | Source de ticks |
|---|---|---|---|
| `audit_marine` | 15 | Audit Marine par Kaizen | choix journalistiques visibles publiquement |
| `equipe_nettoyage` | 14 | Équipe Nettoyage Stratom | augmentations majeures de surveillance |

Quand un countdown atteint son `max`, signal `countdown_completed`.
Le scénariste branche dessus la scène de conséquence.

### Cycle de vie

- `_ready()` du manager : ne crée rien (évite d'écraser un load).
- `reset_all_for_new_game()` : vide tout, recrée les CANON_COUNTDOWNS
  à current=0.
- `load_state(data)` : restaure à partir du save (peut contenir des
  countdowns custom créés en cours de partie).

### tick(id, amount)

- `amount` doit être > 0 (assert).
- `id` doit exister (assert avec message clair).
- Si `is_completed`, le tick est ignoré silencieusement (pas
  d'erreur, on ne re-tick pas un countdown fini).
- Émet `countdown_advanced` et, sur dernier tick,
  `countdown_completed`.

### Seuils internes

Chaque countdown peut déclarer ses propres seuils dans le constant.
Par défaut, les seuils canon sont à `max/3` et `2*max/3`.

---

## Mirror Status (dette d'authenticité)

Le PJ accumule de la dette miroir quand elle fait des choix
contraires à ses valeurs (mensonges utilitaires, fuite, capitulation).
À 100 → **Game Over Miroir** : flashback brutal où elle revoit son
ex (référencé via `ExProfileManager`) et reconnaît qu'elle reproduit
le même pattern.

### Seuils

| Niveau | Effet narratif |
|---|---|
| 30 | premier flashback nominal, HUD pulse 1× |
| 60 | dialogue intérieur impose une option « hésiter » |
| 90 | option de dialogue « être honnête » verrouillée |
| 100 | game over miroir, payload contient `overlay_quote` |

### Overlay quote

`MirrorStatusManager.get_overlay_quote()` consulte
`ExProfileManager.get_echo_phrase()`. Cas :

- ex défini (nom override OU genre override OU ≥ 1 trait) :
  « Comme {ex_name} faisait. » → ex `« Comme Julien faisait. »`
- ex non défini :
  « Tu reproduis un pattern que tu connais trop bien. »

---

## Surveillance

Pression externe (Stratom, Marine, drones, écoutes). Valeur `[0, 100]`.

### Seuils

| Niveau | Effet narratif |
|---|---|
| 25 | HUD passe en mode visible permanent |
| 50 | bandeau « écoute active » apparaît |
| 75 | scène cinématique « tu es suivie » force déclenche |
| 90 | tick automatique sur countdown `equipe_nettoyage` |
| 100 | **Game Over Surveillance** |

### Couplages

Quand `increase()` franchit 75, on appelle
`CountdownManager.tick("equipe_nettoyage", 1)`. Pas de propagation
automatique : c'est codé explicitement dans `SurveillanceManager`
pour rester local et lisible.

---

## Réputation vs Relation

Deux choses **distinctes** qui peuvent diverger :

- **Relation** = lien affectif PJ ↔ PNJ individuel. Privé, modifié
  par des actes intimes (mensonge, soutien…).
- **Réputation** = perception de la PJ par une faction publique.
  Modifiée par des actes visibles (publication, fuite, alliance
  affichée).

Couplages explicites (codés à la main, pas magiques) :

- Trahir un PNJ d'une faction baisse aussi la rep de cette faction.
- Pas l'inverse : monter la rep d'une faction n'élève pas la
  relation des PNJ individuels (la confiance se gagne en privé).

Exemple côté code :

```gdscript
# Quand on signe un article anti-Stratom
RelationManager.modifier("marl", -5, "article_critique")
ReputationManager.modifier("stratom", -15, "article_critique")
```

---

## Profil de l'ex

L'ex est un personnage fantôme qui revient en flashbacks. Le joueur
peut le caractériser via dialogue (Prompt 4c) :

- Nom (override unique)
- Genre (override unique → conditionne les pronoms)
- Traits (multiples, choisis dans VALID_TRAITS)
- Durée / circonstances de fin

### Pourquoi configurable

Tester sur soi, projeter, ou rester abstrait. Le défaut canonique
(« Julien », masculin, aucun trait) reste l'ex de Maïa, la
journaliste protagoniste, dans la version de référence.

### Cohérence nom/genre

**Non imposée**. Le joueur peut écrire « Julien » avec genre
féminin. Le dialogue 4c peut suggérer une combinaison cohérente ou
non — c'est au scénario d'orienter, pas au manager.

---

## Roster

### PNJs (9)

| ID | Faction | Init relation | Rôle narratif |
|---|---|---|---|
| sara | presse | 0 | binôme journaliste |
| kaizen | marine | -10 | enquêteur militaire ambigu |
| lior | activistes | 5 | hacker, ressource |
| marl | stratom | 0 | source interne potentielle |
| tess | police | 0 | contact police lent |
| viktor | stratom | -20 | DSI Stratom, antagoniste |
| mira | presse | 15 | rédactrice en chef |
| aslan | activistes | 0 | activiste violent |
| nadia | marine | 0 | analyste Marine, neutre |

### Factions (5)

| ID | Init rep | Note |
|---|---|---|
| stratom | 0 | méfie au moindre signal |
| marine | 0 | observe |
| presse | 10 | prête à publier |
| police | 0 | demande des preuves |
| activistes | 5 | sympathise par défaut |

---

## Transition de scène vers Game Over

Choix retenu : **réutiliser `LocationManager`** existant (Prompt 1)
plutôt que le SceneLoader natif de Maaack.

Justification :
- `LocationManager.aller_a_scene(id, chemin)` accepte déjà un chemin
  arbitraire.
- Le fondu noir 0.4 s est déjà implémenté et homogène avec les
  autres transitions du jeu.
- Pas de dette technique si on retire Maaack plus tard.

Maaack reste utilisé pour le menu principal, les options, le splash.
On ne le brise pas, on n'en dépend pas non plus pour les flux de
scène.

```gdscript
# GameOverHandler.gd
LocationManager.aller_a_scene(
    "game_over_" + payload.type,
    "res://scenes/core/GameOverScreen.tscn"
)
```

---

## Tableau récap des actions joueur → systèmes

| Action narrative | Manager touché | Méthode |
|---|---|---|
| Publier un article sensible | Reputation | `modifier("presse", +10)` |
| Idem | Surveillance | `increase(15, "publication")` |
| Mentir à un PNJ proche | Relation, Mirror | `modifier(perso, -8)`, `increase(5, "mensonge")` |
| Avouer une faiblesse | Relation, Mirror | `modifier(perso, +12)`, `decrease(10, "honnetete")` |
| Croiser un drone Stratom | Surveillance | `increase(3, "drone")` |
| Audit Marine progresse | Countdown | `tick("audit_marine", 1)` |
| Choisir caractérisation ex | ExProfile | `set_ex_name("...")`, `add_trait(...)` |

Tout ceci est appelé depuis les dialogues / scènes, jamais en
réaction automatique. Le scénariste reste maître.
