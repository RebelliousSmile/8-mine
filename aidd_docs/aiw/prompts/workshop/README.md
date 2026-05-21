# Workshop : Système de Prompts

Prompts interconnectés pour l'écriture structurée de documents narratifs et JdR.

## Flux Principal

```
[brainstorm] ──→ [generate-toc] ──→ [write-toc-chapter]† ──→ [write-novel]       ──→ [doctor] ──→ build-icml
                                                           └──→ [write-roleplaying] ──→ [doctor] ──→ build-icml

† optionnel — fiche détaillée par chapitre avant rédaction
```

**Pipeline review (itératif) :**
```
chapitres/chapitre<NN>.md
  → [comment] (personas)
  → TRIAGE :
      Issues patchables     → [doctor] --remarks <fichier>
      Issues structurelles  → [write-*] --feedback (réécriture depuis TOC)
      Patterns systémiques  → [tone-finder] (output-style v+1)
  → re-[comment] → LOOP (max 3 itérations)
```

**Pipeline cohérence (avant ou après doctor) :**
```
chapitres/ ou --scripts <chemin>
  → [coherence-checker] [--cross-chapters]
  → .wip/coherence/remarks-<identifiant>.md
  → [doctor] --remarks .wip/coherence/remarks-<identifiant>.md
```

**Flux extraction PDF (multi-session) :**
```
Session 1     : [extract]          → progress.md + chunks découpés
Sessions 2-N  : [extract-chunk]    → classified/*.md (1 session par chunk)
Session finale: [extract-distribute] → fichiers univers mis à jour
Anomalie      : [extract-debug]
```

## Prompts Disponibles

### Écriture et Révision

| Prompt | Rôle | Sortie principale |
|--------|------|------------------|
| `brainstorm` | Itère sur l'overview jusqu'à generate-toc | `overview.md` mis à jour |
| `generate-toc` | Génère la table des matières depuis un source | `.toc/INDEX.md` |
| `write-toc-chapter` | Fiche détaillée d'un chapitre (optionnel) | `.toc/toc-chapter<NN>.md` |
| `write-novel` | Rédige du contenu narratif | `chapitres/chapitre<NN>.md` |
| `write-roleplaying` | Rédige du contenu JdR | `chapitres/chapitre<NN>.md` |
| `comment` | Évalue un chapitre via persona | `.wip/comments/<id>-chapitre<NN>.md` |
| `doctor` | Corrections techniques + application remarks | Fichier corrigé + `.wip/changelog/` |

### Configuration et Qualité

| Prompt | Rôle | Sortie principale |
|--------|------|------------------|
| `init-project` | Initialise ou audite un projet | Structure + `bank.yml` + output-styles + personas |
| `tone-finder` | Génère ou met à jour un output-style | `<univers>/.output-styles/<univers>-<type>.md` |
| `generate-persona` | Crée un fichier persona YAML | `<id>.yml` |
| `persona-trainer` | Affine un persona depuis les feedbacks accumulés | `<id>.yml` mis à jour |
| `univers-extract` | Extrait terminologie depuis des sources | `terminologie.md` |
| `research` | Recherche documentaire web croisée | Rapport enrichissant `.docs/` |
| `upgrade` | Améliore itérativement un prompt ou texte | Version améliorée |
| `tabula-rasa` | Réinitialise un projet (destructif) | Projet réinitialisé |

### Extraction PDF (multi-session)

| Prompt | Rôle | Sortie principale |
|--------|------|------------------|
| `extract` | Setup extraction — session 1 | `progress.md` + chunks découpés |
| `extract-chunk` | Extrait 1 chunk — sessions 2-N | `classified/*.md` |
| `extract-distribute` | Fusionne et distribue — session finale | Fichiers univers mis à jour |
| `extract-debug` | Diagnostique les anomalies | Rapport debug |

## Agents Autonomes (`docs/agents/`)

Agents orchestrant des workflows complets, exécutables en parallèle.

| Agent | Rôle | Sortie principale |
|-------|------|------------------|
| `writing-pipeline` | Écrit N chapitres en parallèle | `chapitres/chapitre<NN>.md` |
| `coherence-checker` | Vérifie cohérence intra/inter-fichiers | `.wip/coherence/index-*.yml` + `remarks-*.md` |
| `memory-manager` | Gère la mémoire contextuelle | Fichier mémoire mis à jour |

## Transitions Clés

### generate-toc → write-toc-chapter → write-*

```
generate-toc produit          : .toc/INDEX.md
write-toc-chapter lit         : .toc/INDEX.md → produit .toc/toc-chapter<NN>.md
write-novel / write-roleplaying lisent : .toc/toc-chapter<NN>.md (synopsis + points clés + output-style)
```

### comment → doctor ou write-* (triage)

```
comment produit                : .wip/comments/<id>-chapitre<NN>.md
  → Issues patchables          : doctor --remarks ".wip/comments/<id>-chapitre<NN>.md"
  → Issues structurelles       : write-* --feedback ".wip/comments/<id>-chapitre<NN>.md"
```

### comment → persona-trainer (affinage persona)

```
comment produit (N sessions)   : .wip/comments/<id>-*.md
persona-trainer consomme       : persona-trainer <id> --feedback-files ".wip/comments/<id>-*.md"
persona-trainer produit        : <univers>/.templates/personas/<id>.yml mis à jour
```

### coherence-checker → doctor

```
coherence-checker produit      : .wip/coherence/remarks-<identifiant>.md
doctor consomme                : doctor chapitres/chapitre<NN>.md --remarks ".wip/coherence/remarks-<identifiant>.md"
```

### tone-finder → write-*

```
tone-finder met à jour : <univers>/.output-styles/<univers>-<type>.md (fichier référencé dans bank.yml)
Les write-* suivants chargent ce fichier mis à jour via le chemin déclaré dans bank.yml
```

## Ressources Chargées (depuis bank.yml)

| Ressource | Champ bank.yml | Utilisée par |
|-----------|---------------|-------------|
| Output-style univers | `output-style.<type>` | write-*, doctor, comment |
| Output-style projet | `output-style.projet` | write-*, doctor, comment |
| UNIVERS.md | `docs.univers` | write-*, doctor, comment, coherence-checker |
| terminologie.md | `docs.terminologie` | write-*, doctor, comment, coherence-checker |
| Docs projet | `docs.projet[*]` | write-*, coherence-checker, brainstorm |
| Personas | `docs.personas.*` | comment, persona-trainer, coherence-checker |
| Rules-files | `rules-files.*` | write-roleplaying, coherence-checker |
| TOC | `toc.fichier` | write-*, doctor, coherence-checker |
| Overview | `overview` | brainstorm, generate-toc |

## Dossiers Générés par le Pipeline

| Dossier | Contenu | Généré par |
|---------|---------|-----------|
| `.toc/` | `INDEX.md`, `toc-chapter<NN>.md` | generate-toc, write-toc-chapter |
| `chapitres/` | `chapitre<NN>.md` | write-novel, write-roleplaying |
| `.wip/comments/` | Évaluations personas | comment |
| `.wip/changelog/` | Historique corrections doctor | doctor |
| `.wip/reports/` | Rapports doctor, tone-finder | doctor, tone-finder |
| `.wip/coherence/` | Index YAML + fichiers remarks | coherence-checker |
| `output/` | `.icml` pour InDesign | build-icml.py |

## Points d'Entrée Courants

| Situation | Prompt de départ |
|-----------|-----------------|
| Nouveau projet | `init-project <univers>/<projet>` |
| Projet à auditer (intégrité) | `init-project <univers>/<projet> --integrity-check` |
| Concept à affiner | `brainstorm <univers>/<projet>` |
| Structure à créer | `generate-toc <source.md>` |
| Chapitre à rédiger | `write-novel <n>` ou `write-roleplaying <n>` |
| Chapitre à corriger | `doctor <fichier.md>` |
| Cohérence à vérifier | `coherence-checker <univers>/<projet>` |
| Scripts NPC à vérifier | `coherence-checker <univers>/<projet> --scripts <chemin>` |
| Persona à créer | `generate-persona "<description>"` |
| Persona à affiner | `persona-trainer <id> --feedback-files ".wip/comments/<id>-*.md"` |
| Style à définir | `tone-finder <univers>` |
| Documentation manquante | `research "<sujet>"` ou `univers-extract <univers> <fichier>` |
| Prompt à améliorer | `upgrade` (sur le dernier output) |
| Import depuis PDF | `extract <projet> <PDF>` |

## Version

**Version :** 2.2
**Date :** 2026-03-01
**Changelog 2.2 :** Astérisque `write-toc-chapter` légendé († optionnel). Transition `comment → persona-trainer` ajoutée. `Tous` dans Ressources remplacé par liste précise. Formulation tone-finder corrigée. Tableau Prompts divisé en 3 sous-groupes (Écriture, Configuration, Extraction). `persona-trainer` ajouté dans Points d'entrée.
**Changelog 2.1 :** Diagramme ASCII restauré. Transitions clés. Flux extraction. Colonne Sortie agents. --integrity-check dans points d'entrée.
**Changelog 2.0 :** Réécriture complète. Suppression prompts obsolètes. Pipeline cohérence. Chemins `.md`.
