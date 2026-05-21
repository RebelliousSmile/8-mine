---
name: tabula-rasa
description: Reset project by extracting essence into overview.md then clearing .toc/ and chapitres/
argument-hint: Path to project directory (e.g., "zombiology/quonleurcoupelatete")
---

# Tabula Rasa

## Goal

Extraire l'essence narrative d'un projet dans overview.md (500 lignes max), puis vider .toc/ et chapitres/ (dossiers conserves).

## Context

### Configuration

```yaml
@$ARGUMENTS/bank.yml
```

### Sources a Scanner

Lire TOUS les fichiers dans :
- `$ARGUMENTS/.toc/*.md`
- `$ARGUMENTS/chapitres/*.tex`
- `$ARGUMENTS/chapitres/*.md`

## Rules

- overview.md : 500 lignes MAX
- JAMAIS supprimer sans confirmation [1]
- Git stash avant suppression [2]
- Si overview.md existe : renommer .bak [3]
- Si aucun fichier trouve : ABORT
- Vider = supprimer fichiers, conserver dossiers vides

## Steps

### 1. Scanner et Extraire

Lister et lire tous les fichiers, afficher :

```
Fichiers trouves:
  .toc/INDEX.md (45 lignes)
  .toc/toc-chapter01.md (30 lignes)
  chapitres/chapitre01.tex (200 lignes)
  ...
Total: [N] fichiers, [X] lignes
```

Si aucun fichier : `Rien a extraire. ABORT.`

Extraire :

| Garder | Eliminer |
|--------|----------|
| Pitch, concept, themes | Descriptions detaillees |
| Structure (actes, progression) | Dialogues complets |
| Personnages (noms, roles, arcs) | Instructions mise en scene |
| Lieux (noms, fonction) | Regles de jeu |
| Evenements cles | Details d'implementation |

### 2. Generer overview.md

Sections selon contenu trouve (omettre si vide) :

```markdown
# [Nom du Projet]

## Pitch
## Structure
## Personnages
## Lieux
## Themes et Ton
## Notes
```

### 3. Valider [1]

Afficher preview complet, puis :

```
ATTENTION: Suppression du contenu de .toc/ et chapitres/.
Confirmer ? (oui/non)
```

Si non : sauvegarder overview.md sans supprimer, FIN.

### 4. Sauvegarder et Reset [2][3]

Git stash des fichiers a supprimer.

Si pas de git : copier vers `_backup-tabula-rasa/`

Si overview.md existe : renommer en overview.bak.md

Ecrire overview.md, supprimer contenu de .toc/ et chapitres/.

### 5. Rapport

```
=== TABULA RASA ===
Cree: overview.md ([N] lignes)
Supprime: [liste fichiers]
Restaurer: git stash pop

Suite: @brainstorm.prompt.md $ARGUMENTS
```
