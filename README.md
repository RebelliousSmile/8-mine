# 8-mine

Framework Godot 4 .NET pour jeu narratif de type *Life is Strange* :
dialogues branchés, relations PJ ↔ PNJ, conséquences différées,
exploration de lieux, sauvegarde multi-slots.

## Pile technique

| Brique | Rôle | Statut |
|---|---|---|
| **Godot 4 .NET** (4.3+) | Moteur | À installer |
| **Maaack's Game Template** | Menu principal, options, écran titre, save UI | À installer (asset library) |
| **Dialogic 2** | Système de dialogue (timelines, personnages, conditions) | À installer (asset library) |
| **GDScript custom** | Relations, état narratif, lieux, pont Dialogic | Inclus dans ce dépôt |

Aucun code C# n'est fourni : tout est en GDScript. On utilise quand
même la version .NET de Godot pour rester compatible avec d'éventuels
plugins/MCP .NET futurs.

## Démarrage en 5 étapes

### 1. Installer Godot 4 .NET

Téléchargez la dernière version stable « .NET » sur
<https://godotengine.org/download> (ou via `mise`/`asdf`).
Installez aussi le SDK .NET 8 (requis par Godot .NET).

Vérification :

```bash
godot --version           # doit afficher 4.x.y.stable.mono
dotnet --version          # doit afficher 8.x ou plus
```

### 2. Ouvrir ce projet

```bash
godot --editor --path .
```

À la première ouverture, Godot va :
- générer le dossier `.godot/`
- importer `icon.svg`
- créer un `.csproj` (puisque `config/features` contient `"C#"`)

Aucun warning n'est attendu côté autoloads (ils sont déjà déclarés
dans `project.godot`).

### 3. Installer Maaack's Game Template

Dans l'éditeur :
- **AssetLib** (onglet en haut) → chercher `Maaack's Game Template`
- Télécharger → installer dans `addons/maaacks_game_template/`
- Suivre l'assistant : il propose de générer une scène titre +
  options menu. Acceptez ; choisissez de placer la scène de menu
  dans `scenes/core/MainMenu.tscn`.

Branchez le bouton « Nouvelle partie » du menu Maaack sur
`scenes/core/Main.tscn` (ou directement
`LocationManager.aller_a("template")`).

### 4. Installer Dialogic 2

Dans l'éditeur :
- **AssetLib** → chercher `Dialogic` → version 2.x
- Télécharger → installer dans `addons/dialogic/`
- **Projet > Paramètres du projet > Extensions** : activer
  `Dialogic`. Cela ajoute automatiquement un autoload `Dialogic`.
- **Réordonner les autoloads** (Projet > Paramètres > Autoload) pour
  que `DialogicBridge` soit **après** `Dialogic`.

Importez la timeline d'exemple :
- **Dialogic > Timelines** → bouton « Importer »
- Sélectionnez `dialogues/exemple_relation.dtl`
- Sauvegardez.

### 5. Lancer

Appuyez sur **F5** dans l'éditeur (ou bouton ▶).

Le `Main.tscn` charge `Location_Template.tscn` via `LocationManager`,
qui applique un fondu noir. Vous devriez voir :
- un fond gris-bleu plein écran,
- le HUD relations en haut à droite (alex / sam à « neutre »),
- trois hotspots cliquables (Porte, Bureau, Fenêtre).

Cliquer sur « Bureau » lance la timeline d'exemple. Les choix de
dialogue modifient les relations en temps réel (le HUD se met à jour
et clignote quand un palier change).

## Cartographie du dépôt

```
├── project.godot              Config moteur + autoloads + input map
├── icon.svg                   Icône de fenêtre
│
├── assets/                    Vide par défaut, prêt à recevoir vos médias
│   ├── backgrounds/           Fonds plein écran (.png/.jpg/.webp)
│   ├── characters/            Portraits PNJ (utilisés par Dialogic)
│   ├── ui/                    Boutons custom, polices, thèmes
│   ├── music/                 Pistes ambiance (.ogg)
│   └── sfx/                   Sons d'interaction (.wav/.ogg)
│
├── dialogues/                 Timelines Dialogic (.dtl)
│   └── exemple_relation.dtl   Démo intégration ↔ RelationManager
│
├── scenes/
│   ├── core/Main.tscn         Point d'entrée (transition vers premier lieu)
│   ├── locations/
│   │   └── Location_Template.tscn   Lieu de base à dupliquer
│   ├── characters/            Scènes PNJ avancées (animations, etc.)
│   └── ui/
│       ├── RelationHUD.tscn   Panneau relations
│       └── Hotspot.tscn       Zone cliquable instanciable
│
├── scripts/
│   ├── managers/              Tous les autoloads
│   │   ├── SaveManager.gd
│   │   ├── GameStateManager.gd
│   │   ├── RelationManager.gd
│   │   ├── LocationManager.gd
│   │   └── DialogicBridge.gd
│   └── ui/
│       ├── Main.gd
│       ├── Location.gd
│       ├── RelationHUD.gd
│       └── Hotspot.gd
│
└── data/
    └── personnages.json       Fiches PNJ (bios, portraits)
```

## Les managers en bref

### SaveManager
- 3 slots dans `user://saves/save_0..2.json`
- `sauvegarder(slot)`, `charger(slot)`, `meta_slot(slot)`
- Sauvegarde rapide sur `F5`, chargement sur `F9`
- Délègue la collecte d'état aux autres managers via
  `collecter_etat()` / `appliquer_etat()`

### GameStateManager
- Flags clé/valeur : `set_flag("ch1.cle_volee", true)`,
  `get_flag(cle, defaut)`, `a_flag(cle)`
- Journal de décisions : `enregistrer_decision(id, libelle, contexte)`
- Synchro automatique vers les variables Dialogic
  (`chapitre_1.cle_volee` devient `chapitre_1_cle_volee` côté Dialogic)

### RelationManager
- Valeurs `[-100, 100]` par personnage
- 9 paliers : `ennemi`, `hostilité`, `méfiance`, `froid`, `neutre`,
  `sympathie`, `confiance`, `amitié`, `intime`
- `modifier(perso, delta, raison)`, `get_niveau(perso)`,
  `au_moins(perso, "confiance")`
- Signal `palier_change` pour déclencher cinématiques /
  variations de dialogue

### LocationManager
- Table déclarative `LIEUX` (id → chemin de scène)
- `aller_a(id)` avec fondu noir 0.4 s, historique, signaux
- `retour_arriere()` pour revenir au lieu précédent

### DialogicBridge
- Écoute `Dialogic.signal_event` et traduit les arguments en
  appels managers. Voir le commentaire d'en-tête pour la syntaxe :
  `relation:alex:+5:compliment`, `flag:ch1.cle:true`,
  `decision:trahison:Trahir Sam`, `lieu:chambre`.

## Tester un manager en isolation

Chaque manager est testable seul depuis la console de l'éditeur
(touche `~` ou via un script attaché à un Node de test) :

```gdscript
RelationManager.modifier("alex", 25, "compliment sincère")
print(RelationManager.get_niveau("alex"))        # → "sympathie"

GameStateManager.set_flag("test.ok", true)
print(GameStateManager.a_flag("test.ok"))         # → true

SaveManager.sauvegarder(0)
print(SaveManager.meta_slot(0))
```

## Conventions

- **Tout en français** : noms de variables, libellés narratifs,
  commentaires. Les méthodes publiques sont aussi en français
  (`modifier`, `aller_a`) sauf les hooks Godot (`_ready`, `_input`).
- **Signaux > polling** : les UI s'abonnent aux signaux des
  managers et ne stockent jamais d'état dupliqué.
- **Pas de référence directe inter-manager dans `_ready()`** :
  on utilise `call_deferred` ou `get_node_or_null` pour éviter
  les courses d'init.
- **Branche de dev** : `claude/godot-narrative-framework-m2BGL`.

## Pièges connus

- **Dialogic non installé** → `DialogicBridge` affiche un warning au
  démarrage mais le projet tourne. Les hotspots avec une `timeline`
  configurée seront simplement inertes.
- **Maaack non installé** → pas de menu principal, le jeu démarre
  directement sur `Main.tscn`. Pour brancher Maaack, remplacez
  `run/main_scene` dans `project.godot` par votre `MainMenu.tscn`.
- **Ordre des autoloads** → si vous voyez « autoload not found »
  au démarrage, vérifiez que `Dialogic` est listé **avant**
  `DialogicBridge`.
